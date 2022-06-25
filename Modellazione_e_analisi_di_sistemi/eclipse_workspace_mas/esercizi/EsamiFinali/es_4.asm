
asm es_4

import ../StandardLibrary

signature:
	// DOMAINS
	enum domain Color = {RED, GREEN, ERROR_COLOR}
	enum domain StateDomain = {MOVING, STILL, ERROR}
	// FUNCTIONS
	monitored is19: Boolean
	controlled state: StateDomain
	monitored dirty: Color
	monitored tank: Color
	
	

definitions:
	// DOMAIN DEFINITIONS
	
	// FUNCTION DEFINITIONS
	

	// RULE DEFINITIONS
	rule r_move =
		if state = STILL and (dirty = RED and tank = GREEN) then
			state := MOVING
		endif
	
	rule r_stop =
		if state = MOVING and (dirty = GREEN or tank = RED) then
			state := STILL
		endif
	

	// INVARIANTS
	
	

	// MAIN RULE
	main rule r_Main =
		if state != ERROR and (dirty = ERROR_COLOR or tank = ERROR_COLOR) then
			if is19 then
				par
					r_move[]
					r_stop[]
				endpar
			endif
		endif
	
		

// INITIAL STATE
default init s0:
	function state = STILL