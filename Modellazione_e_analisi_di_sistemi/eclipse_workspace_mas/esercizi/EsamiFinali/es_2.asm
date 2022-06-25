// a simple example with a tic tac toe game

asm es_2

import ../StandardLibrary
import ../CTLlibrary

signature:
	domain Controller subsetof Agent
	domain Light subsetof Agent
	enum domain PhaseDomain = {DAY, NIGHT}
	enum domain LightDomain = {ON, OFF}
	enum domain ControllerDomain = {WORKING, MALFUNCTIONING}
	
	controlled stateL: Light -> LightDomain
	monitored gate: Boolean
	monitored passed10: Boolean
	controlled pulse: Boolean
	monitored phase: PhaseDomain
	controlled stateC: Controller -> ControllerDomain
	
	static light: Light
	static controller: Controller
	
	monitored error: Boolean

definitions:

	// FUNCTION DEFINITIONS
	
	// RULE DEFINITIONS

	rule r_light =
		if pulse = true then
			par
				pulse := false
				stateL(self) := ON
			endpar
		else 
			if passed10 = true then
				stateL(self) := OFF
			endif
		endif
		
		
	rule r_controller =
		if stateC(self) = WORKING and not error then
			if phase = NIGHT then
				if gate = true then
					pulse := true
				endif
			endif
		else
			stateC(self) := MALFUNCTIONING
		endif


	// INVARIANTS




	// MAIN RULE
	main rule r_Main =
		par
			program(controller)
			program(light)
		endpar
		
		
// INITIAL STATE
default init s0:
	function stateL($l in Light) = OFF
	function stateC($c in Controller) = WORKING
	
	agent Light:
		r_light[]
		
	agent Controller:
		r_controller[]
