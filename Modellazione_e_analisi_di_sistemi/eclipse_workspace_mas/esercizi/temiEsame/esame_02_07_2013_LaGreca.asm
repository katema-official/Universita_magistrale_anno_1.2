// a simple example with a tic tac toe game

asm esame_02_07_2013_LaGreca

import ../StandardLibrary

signature:
	// DOMAINS
	domain Controller subsetof Agent
	domain Gate subsetof Agent
	enum domain State = {OPEN, CLOSED}
	
	// FUNCTIONS
	static controller: Controller
	static gate: Gate
	controlled is_car_present: Boolean	//true = c'è una macchina, false = non c'è
	controlled gateState: State
	
	monitored in_sensor: Boolean
	monitored out_sensor: Boolean

definitions:
	// DOMAIN DEFINITIONS

	// FUNCTION DEFINITIONS
	
	// RULE DEFINITIONS
	rule r_controller =
		par
			if in_sensor then
				is_car_present := true
			endif
			
			if out_sensor then
				is_car_present := false
			endif
		endpar
	
	rule r_gate =
			if is_car_present then
				gateState := OPEN
			else
				gateState := CLOSED
			endif
			

	// INVARIANTS
	//se una macchina sta aspettando di passare, non è possibile che sia già passata
	invariant over in_sensor, out_sensor:
		not (in_sensor and out_sensor)	
	
		

	// MAIN RULE
	main rule r_Main =
		par
			program(controller)
			program(gate)
		endpar

// INITIAL STATE
default init s0:
	
	function gateState = CLOSED
	function is_car_present = in_sensor
	
	agent Controller:
		r_controller[]
	
	agent Gate:
		r_gate[]
