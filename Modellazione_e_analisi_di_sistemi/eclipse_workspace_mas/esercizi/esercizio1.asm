// a simple example with a tic tac toe game

asm esercizio1

import StandardLibrary

signature:
	//DOMINI
	enum domain State = {NORMAL, MAINTENANCE}
	enum domain Commands = {COMMAND1, COMMAND2, COMMAND3}
	abstract domain Devices
	
	//FUNZIONI
	controlled state: State
	controlled control: Commands -> Boolean	//true: controllo comando ok
	
	
	

definitions:
	// DOMAIN DEFINITIONS
	
	//REGOLE
	rule r_testing($d in Devices) = 
		skip
	
	rule r_testDevices =
		forall $d in Devices with true do r_testing[$d]

	rule r_completeDiagnosis = 
		skip
		
	rule r_controlCommand($c in Commands) =
		if control($c) then 
			skip 
		endif
	
	rule r_checkCommands =
		forall $c in Commands with true do r_controlCommand[$c]
	
	// MAIN RULE
	main rule r_Main =
		if state = NORMAL then
			skip
		else
			par
				seq
					r_testDevices[]
					r_completeDiagnosis[]
				endseq
				r_checkCommands[]
				state := NORMAL
			endpar
		endif
		
// INITIAL STATE
default init s0:
	function state = MAINTENANCE
	function control($c in Commands) = true
