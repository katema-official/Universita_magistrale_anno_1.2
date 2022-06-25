
asm lagreca990973_0

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	domain Euros subsetof Integer
	domain Values subsetof Integer
	enum domain GameStatus = {WINUSER, WINPC, PATTA, UNDEFINED}
	
	// FUNCTIONS
	controlled pc_choice: Values
	monitored user_choice: Values
	controlled ownedMoneyPc: Euros
	controlled ownedMoneyUser: Euros
	derived winner: GameStatus
	derived finalWinner: GameStatus
	
	controlled currentMess: GameStatus
	controlled finalMess: GameStatus
	

definitions:
	// DOMAIN DEFINITIONS
	domain Euros = {0:10}
	domain Values = {1:5}
	
	
	// FUNCTION DEFINITIONS
	
	function winner =
		if user_choice > pc_choice then
			WINUSER
		else
			if user_choice < pc_choice then
				WINPC
			else
				PATTA
			endif
		endif
	
	function finalWinner =
		if ownedMoneyPc = 10 then
			WINPC
		else
			if ownedMoneyUser = 10 then
				WINUSER
			else
				UNDEFINED	//non nel senso che la partita si è conclusa, quanto che non è ancora terminata.
			endif
		endif
	

	// RULE DEFINITIONS
	rule r_choosePc =
		choose $v in Values with true do
			pc_choice := $v
		
	rule r_userWon($user in Values, $pc in Values) =
		if $user > $pc then
			par
				ownedMoneyUser := ownedMoneyUser + 1
				ownedMoneyPc := ownedMoneyPc - 1
			endpar
		endif
		
	 rule r_pcWon($user in Values, $pc in Values) =
	 	if $user < $pc then
			par
				ownedMoneyUser := ownedMoneyUser - 1
				ownedMoneyPc := ownedMoneyPc + 1
			endpar
		endif
	 
	 rule r_playATurn($user in Values, $pc in Values) =
		 if finalWinner = UNDEFINED then
		 	par
				pc_choice := $pc
				r_userWon[$user, $pc]
				r_pcWon[$user, $pc]
			endpar
		endif

	// INVARIANTS
	
	
	//CTLSPECs
	//il saldo dell'utente può assumere un qualsiasi valore nell'intervallo [0, 10] euro
	//CTLSPEC (forall $x in Euros with ag(ef(ownedMoneyUser = $x)))
	CTLSPEC (forall $x in Euros with ef(ownedMoneyUser = $x))
	//nel sistema ci sono sempre 10 euro
	CTLSPEC ag(ownedMoneyPc + ownedMoneyUser = 10)
	//esiste un cammino in cui il saldo del pc è sempre maggiore o uguale a 1 euro
	CTLSPEC eg(ownedMoneyPc >= 1)

	// MAIN RULE
	main rule r_Main =
		par
			currentMess := winner
			finalMess := finalWinner
			let ($us = user_choice) in
				choose $v in Values with true do
					r_playATurn[$us, $v]
			endlet
		endpar
		
	

// INITIAL STATE
default init s0:
	function ownedMoneyPc = 5
	function ownedMoneyUser = 5
	function pc_choice = 0

