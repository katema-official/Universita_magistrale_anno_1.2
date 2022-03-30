

asm ATM

import StandardLibrary

signature:
	// DOMAINS
	abstract domain NumCard
	enum domain State = {AWAITCARD | AWAITPIN | 
		CHOOSE | OUTOFSERVICE | CHOOSEAMOUNT | 
		STANDARDAMOUNTSELECTION | OTHERAMOUNTSELECTION}
	enum domain Service = {BALANCE | WITHDRAWAL | EXIT}
	domain MoneySize subsetof Integer
	enum domain MoneySizeSelection = {STANDARD | OTHER}
	// FUNCTIONS
	controlled currCard: NumCard
	controlled atmState: State
	controlled outMess: String
	static pin: NumCard -> Integer
	controlled balance: NumCard -> Integer
	controlled accessible: NumCard -> Boolean
	
	monitored insertedCard: NumCard
	monitored insertedPin: Integer
	monitored selectedService: Service
	monitored standardOrOther: MoneySizeSelection
	monitored insertMoneySizeStandard: Integer
	monitored insertMoneySizeOther: Integer
	controlled moneyLeft: Integer
	derived allowed: Prod(NumCard, Integer) -> Boolean
	
	static minMoney: Integer
	
	controlled numOfBalanceChecks: Integer
	
	static card1: NumCard
	static card2: NumCard
	static card3: NumCard
	
	

definitions:
	// DOMAIN DEFINITIONS
	domain MoneySize = {10, 20, 40, 50, 100, 150, 200}

	// FUNCTION DEFINITIONS
	function allowed($c in NumCard, $m in Integer) =
		balance($c) >= $m
	
	function pin($c in NumCard) = switch($c)
								case(card1): 1
								case(card2): 2
								case(card3): 3
								endswitch
	
	function minMoney = 10
	
	// RULE DEFINITIONS
	rule r_insertCard =
		if(atmState = AWAITCARD) then
			if(exist $c in NumCard with $c = insertedCard) then
				par
					currCard := insertedCard
					atmState := AWAITPIN
					outMess := "Enter pin"
				endpar
			endif
		endif

	rule r_enterPin =
		if(atmState = AWAITPIN) then
			if(insertedPin=pin(currCard)) then//and accessible(currCard)) then
				par
					outMess := "Choose service"
					atmState := CHOOSE
					numOfBalanceChecks := 0
				endpar
			else
				par
					atmState := AWAITCARD
					if(insertedPin != pin(currCard)) then	//let?
						outMess := "Wrong pin"
					endif
					if accessible(currCard) = false and insertedPin=pin(currCard) then
						outMess := "Account not accessible"
					endif
				endpar
			endif
		endif

	rule r_chooseService =
		if (atmState=CHOOSE) then
			par
				if(selectedService = BALANCE) then
					if(numOfBalanceChecks = 0) then
						par
							numOfBalanceChecks := numOfBalanceChecks + 1
							outMess := toString(balance(currCard))
						endpar
					else
						par
							atmState := AWAITCARD
							outMess := "You can check your balance only once, goodbye"
						endpar
					endif
				endif
				if(selectedService = WITHDRAWAL) then
					par
						atmState := CHOOSEAMOUNT
						outMess := "Choose Standard or Other"
					endpar
				endif
				if (selectedService = EXIT) then
					par
						atmState := AWAITCARD
						outMess := "Goodbye"
					endpar
				endif
			endpar
		endif
		
	rule r_chooseAmount =
		if(atmState = CHOOSEAMOUNT) then
			par
				if(standardOrOther = STANDARD) then
					par
						atmState := STANDARDAMOUNTSELECTION
						outMess := "Select a money size"
					endpar
				endif
				if(standardOrOther = OTHER) then
					par
						atmState := OTHERAMOUNTSELECTION
						outMess := "Enter money size"
					endpar
				endif
			endpar
		endif
		
	rule r_subtractFrom($c in NumCard, $m in Integer) =
		balance($c) := balance($c) - $m
		
	rule r_grantMoney($m in Integer) =
		par
			r_subtractFrom[currCard, $m]
			moneyLeft := moneyLeft - $m
			accessible(currCard) := false
			atmState := AWAITCARD
			outMess := "Goodbye"
		endpar
		
	rule r_processMoneyRequest($m in Integer) =
		if(allowed(currCard, $m)) then
			r_grantMoney[$m]
		else
			outMess := "Not enough money in your account"
		endif	
	
	rule r_withdraw =
		par
			if(atmState = STANDARDAMOUNTSELECTION) then
				if(exist $m in MoneySize with $m = insertMoneySizeStandard) then
					if(insertMoneySizeStandard <= moneyLeft) then
						r_processMoneyRequest[insertMoneySizeStandard]
					else
						outMess := "No enough cash in the ATM"
					endif
				endif
			endif
		
			if(atmState = OTHERAMOUNTSELECTION) then
				if(mod(insertMoneySizeOther, 10) = 0) then
					if(insertMoneySizeOther <= moneyLeft) then
						r_processMoneyRequest[insertMoneySizeOther]
					else
						outMess := "No enough cash in the ATM"
					endif
				endif
			endif	
		endpar
		
	rule r_goOutOfService = 
		if(moneyLeft < minMoney) then 
			par
				atmState := OUTOFSERVICE
				outMess := "Out of service"
			endpar
		endif
			
	// INVARIANTS

	// MAIN RULE
	main rule r_Main =
		seq
			r_goOutOfService[]
			par
				r_insertCard[]
				r_enterPin[]
				r_chooseService[]
				r_chooseAmount[]
				seq
					r_withdraw[]
					if isDef(currCard) then
						if not(accessible(currCard)) then
							accessible(currCard) := true
							//il sistema centrale sblocca l'account
							//della carta corrente
						endif
					endif
				endseq
			endpar
		endseq

// INITIAL STATE
default init s0:
	function balance($c in NumCard) = switch($c)
								case card1: 100
								case card2: 200
								case card3: 300
								endswitch
	
	function accessible($c in NumCard) = switch($c)
								case card1: true
								case card2: true
								case card3: true
								endswitch
								
	function moneyLeft = 1000
	
	function atmState = AWAITCARD
	
	function numOfBalanceChecks = 0
	
	function outMess = "."
