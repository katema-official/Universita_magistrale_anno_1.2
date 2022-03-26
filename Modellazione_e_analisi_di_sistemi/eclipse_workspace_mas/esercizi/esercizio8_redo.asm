asm esercizio8_redo

import StandardLibrary

signature:
	//DOMINI
	enum domain Moment = {DAY | NIGHT}
	//FUNZIONI
	monitored state: Moment
	monitored gate: Boolean	//true = aperto, false = chiuso
	controlled light: Boolean	//true = accesa, false = spenta
	monitored passed_10_minutes: Boolean	//sono passati i dieci minuti?
	
	

definitions:

	//RULES
	rule r_day =
		if state = DAY then
			light := false	//di giorno, la luce è sempre spenta
		endif
	
	
	rule r_night =
		if state = NIGHT then
				if gate = true then
					light := true
				else if light = true and passed_10_minutes = true then
					light := false
					endif
				endif
		endif
	
	// MAIN RULE
	main rule r_Main =
		par
			r_day[]
			r_night[]
		endpar

// INITIAL STATE
default init s0:
	function light = false
