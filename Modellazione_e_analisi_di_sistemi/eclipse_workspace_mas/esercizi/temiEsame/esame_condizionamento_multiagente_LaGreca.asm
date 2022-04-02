asm esame_condizionamento_multiagente_LaGreca

import ../StandardLibrary

signature:
	// DOMAINS
	domain Controller subsetof Agent
	domain Conditioner subsetof Agent
	enum domain UserTemperatureDomain = {AMBIENT, MINIMUM}
	enum domain Phase = {DAY, NIGHT}
	enum domain CondStateDomain = {ON, OFF}
	// FUNCTIONS
	static controller: Controller
	static conditioner: Conditioner
	controlled userTemperature: UserTemperatureDomain -> Integer
	controlled phase: Phase
	controlled condState: CondStateDomain
	monitored newUserChoice: Integer
	monitored temperature: Integer
	monitored userPressedButton: Boolean
	
	monitored fault: Boolean

definitions:
	// DOMAIN DEFINITIONS

	// FUNCTION DEFINITIONS
	
	// RULE DEFINITIONS
	rule r_day =
		if phase = DAY then
			par
				if userPressedButton then
					userTemperature(AMBIENT) := newUserChoice
				endif
				
				if temperature > userTemperature(AMBIENT) then
					condState := ON
				else
					condState := OFF
				endif
			endpar
		endif
	
	rule r_night =
		if phase = NIGHT then
			par
				if userPressedButton then
					userTemperature(MINIMUM) := newUserChoice
				endif
				
				if temperature > userTemperature(MINIMUM) then
					condState := ON
				else
					condState := OFF
				endif
			endpar
		endif
	
	rule r_controller =
		par
			r_day[]
			r_night[]
		endpar
	
	rule r_conditioner =
		skip
	
	// INVARIANTS

	// MAIN RULE
	main rule r_Main =
		if not fault then
			par
				program(controller)
				program(conditioner)
			endpar
		endif
		

// INITIAL STATE
default init s0:
	
	function userTemperature($t in UserTemperatureDomain) = switch($t)
															case AMBIENT: 26
															case MINIMUM: 28
															endswitch
															
	
	agent Controller:
		r_controller[]
		
	agent Conditioner:
		r_conditioner[]
		
		
