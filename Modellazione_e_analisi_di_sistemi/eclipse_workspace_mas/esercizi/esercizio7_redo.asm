asm esercizio7_redo

import StandardLibrary

signature:
	//DOMINI
	enum domain Phase = {DAY | NIGHT}
	enum domain Temperature = {CURRENT | AMBIENT | MINIMUM | INPUT}
	//FUNZIONI
	//controllore che rappresenta il momento della giornata
	monitored controller: Phase
	monitored fault: Boolean
	//le varie temperature
	monitored t_input: Temperature -> Integer
	controlled t: Temperature -> Integer
	monitored user_choice: Boolean
	//il condizionatore
	controlled air_conditioner: Boolean //true = acceso, false = spento

definitions:

	//REGOLE
	rule r_day =
		par
			if user_choice = true then
				t(AMBIENT) := t_input(INPUT)	
			endif
			
			let ($cur = t_input(CURRENT)) in
				if $cur > t(AMBIENT) and air_conditioner = false then
					air_conditioner := true
				else if $cur <= t(AMBIENT) and air_conditioner = true then
						air_conditioner := false
					endif
				endif
			endlet
		endpar
	
	rule r_night =
		par
			if user_choice = true then
				t(MINIMUM) := t_input(INPUT)		
			endif
			
			let ($cur = t_input(CURRENT)) in
				if $cur > t(MINIMUM) and air_conditioner = false then
					air_conditioner := true
				else if $cur <= t(MINIMUM) and air_conditioner = true then
						air_conditioner := false
					endif
				endif
			endlet
		endpar
	
	rule r_condizionatore = 
		if controller = DAY then
			r_day[]
		else
			r_night[]
		endif

	// MAIN RULE
	main rule r_Main =
		if not fault then
			r_condizionatore[]
		endif
		
// INITIAL STATE
default init s0:
	function controller = DAY
	function user_choice = false
	function fault = false
	function t($temp in Temperature) = switch($temp)
										case AMBIENT: 26
										case MINIMUM: 28
										endswitch
	function air_conditioner = false
