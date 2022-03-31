asm SluiceGate

import StandardLibrary

signature:
	// DOMAINS
	abstract domain Position
	domain Minutes subsetof Integer
	enum domain PhaseDomain = {FULLYCLOSED | OPENING | FULLYOPENED | CLOSING}
	enum domain DirectionDomain = {CLOCKWISE | ANTICLOCKWISE}
	enum domain MotorDomain = {ON | OFF}
	
	
	// FUNCTIONS
	controlled dir: DirectionDomain
	controlled motor: MotorDomain
	static openPeriod: Minutes
	static closedPeriod: Minutes
	static top: Position
	static bottom: Position
	controlled phase: PhaseDomain
	monitored passed: Minutes -> Boolean
	monitored event: Position -> Boolean
	//passed(10) e passed(170) indicano se è trascorso l'intervallo di tempo
	//in cui la saracinesca deve essere completamente aperta e, rispettivamente,
	//completamente chiusa

definitions:
	// DOMAIN DEFINITIONS
	domain Minutes = {10, 170}

	// FUNCTION DEFINITIONS
	function openPeriod = 10
	function closedPeriod = 170

	//RULES
	rule r_start_to_raise =
		par
			dir := CLOCKWISE
			motor := ON
		endpar
	
	rule r_start_to_lower =
		par
			dir := ANTICLOCKWISE
			motor := ON
		endpar
		
	rule r_stop_motor =
		motor := OFF
		
	// INVARIANTS
	invariant over phase, motor:
		(((phase = FULLYCLOSED or phase = FULLYOPENED) and motor = OFF) or
		((phase = OPENING or phase = CLOSING) and motor = ON))
	
	//MAIN RULE
	main rule r_Main =
		par
			if(phase = FULLYCLOSED) then
				if(passed(closedPeriod)) then
					par
						r_start_to_raise[]
						phase := OPENING
					endpar
				endif
			endif
			
			if(phase = OPENING) then
				if(event(top)) then
					par
						r_stop_motor[]
						phase := FULLYOPENED
					endpar
				endif
			endif
			
			if(phase = FULLYOPENED) then
				if(passed(openPeriod)) then
					par
						r_start_to_lower[]
						phase := CLOSING
					endpar
				endif
			endif
			
			if(phase = CLOSING) then
				if(event(bottom)) then
					par
						r_stop_motor[]
						phase := FULLYCLOSED
					endpar
				endif
			endif
			
		endpar

// INITIAL STATE
default init s0:
	function phase = FULLYCLOSED
	function motor = OFF
	function dir = ANTICLOCKWISE
