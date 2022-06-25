// a simple example with a tic tac toe game

asm es_3

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	domain Controller subsetof Agent
	domain Actuator subsetof Agent
	enum domain ActuatorStateDomain = {ON, OFF}
	enum domain PulsesDomain = {ONPULSE, OFFPULSE, NOPULSE}
	enum domain PhaseDomain = {PHASE1, PHASE2, PHASE3, PHASE4}
	domain TriggerHours subsetof Integer
	// FUNCTIONS
	controlled pulses: Actuator -> PulsesDomain
	controlled actState: Actuator -> ActuatorStateDomain
	monitored hourSensor: TriggerHours -> Boolean
	controlled phase: PhaseDomain
	
	static controller: Controller
	static actuator1: Actuator
	static actuator2: Actuator

definitions:
	// DOMAIN DEFINITIONS
	domain TriggerHours = {8, 12, 14, 20}
	
	// FUNCTION DEFINITIONS
	
	// RULE DEFINITIONS
	rule r_phase1 =
		if phase = PHASE1 and hourSensor(8) = true then
			par
				phase := PHASE2
				pulses(actuator1) := ONPULSE
			endpar
		endif
		
	rule r_phase2 =
		if phase = PHASE2 and hourSensor(12) = true then
			par
				phase := PHASE3
				pulses(actuator1) := OFFPULSE
			endpar
		endif
	
	rule r_phase3 =
		if phase = PHASE3 and hourSensor(14) = true then
			par
				phase := PHASE4
				pulses(actuator2) := ONPULSE
			endpar
		endif
	
	rule r_phase4 =
		if phase = PHASE4 and hourSensor(20) = true then
			par
				phase := PHASE1
				pulses(actuator2) := OFFPULSE
			endpar
		endif
	
	
	rule r_controller =
		par
			r_phase1[]
			r_phase2[]
			r_phase3[]
			r_phase4[]
		endpar
	
	rule r_actuator =
		if(actState(self) = OFF and pulses(self) = ONPULSE) then
			par
				actState(self) := ON
				pulses(self) := NOPULSE
			endpar
		else
			if actState(self) = ON and pulses(self) = OFFPULSE then
				par
					actState(self) := OFF
					pulses(self) := NOPULSE
				endpar
			endif
		endif
	

	// INVARIANTS

	// MAIN RULE
	main rule r_Main =
		par
			program(controller)
			forall $p in Actuator with true do program($p)
		endpar

// INITIAL STATE
default init s0:
	function pulses($a in Actuator) = NOPULSE
	function actState($a in Actuator) = OFF
	function phase = PHASE1
	agent Controller: 
		r_controller[]
	agent Actuator:
		r_actuator[]
