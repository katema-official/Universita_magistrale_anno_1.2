// a simple example with a tic tac toe game

asm new_file

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	domain Controller subsetof Agent
	domain Door subsetof Agent
	enum domain ControllerStateDomain = {MOVING, ARRIVED, DOOROPEN, STARTINGTOCLOSE}
	enum domain DoorStateDomain = {FULLYCLOSED, OPENING, FULLYOPEN, CLOSING}
	enum domain StatusDomain = {JUSTOPENED, JUSTCLOSED}
	enum domain CommandDomain = {OPEN, CLOSE}
	// FUNCTIONS
	monitored arrived: Boolean
	monitored status: StatusDomain
	monitored pass_person: Boolean
	monitored passed_one_minute: Boolean
	
	controlled controllerState: Controller -> ControllerStateDomain
	controlled doorState: Door -> DoorStateDomain
	controlled command: CommandDomain
	
	static controller: Controller
	static door: Door
	

definitions:
	// DOMAIN DEFINITIONS
	

	// FUNCTION DEFINITIONS
	

	// RULE DEFINITIONS
	rule r_moving =
		if(controllerState(self) = MOVING) then
			if arrived = true then
				par
					command := OPEN
					controllerState(self) := ARRIVED
				endpar
			endif
		endif
	
	rule r_arrived =
		if controllerState(self) = ARRIVED then
			if status = JUSTOPENED then
				controllerState(self) := DOOROPEN
			endif
		endif
	
	rule r_dooropen = 
		if controllerState(self) = DOOROPEN then
			if passed_one_minute = true then
				par
					command := CLOSE
					controllerState(self) := STARTINGTOCLOSE
				endpar
			endif
		endif
	
	rule r_startingtoclose =
		if controllerState(self) = STARTINGTOCLOSE then
			if pass_person = true then
				par
					command := OPEN
					controllerState(self) := ARRIVED
				endpar
			else
				if status = JUSTCLOSED then
					controllerState(self) := MOVING
				endif
			endif
		endif
	
	
	
	rule r_controller =
		par
			r_moving[]
			r_arrived[]
			r_dooropen[]
			r_startingtoclose[]
		endpar
	
	rule r_fullyclosed_to_opening =
		if(doorState(self) = FULLYCLOSED and command = OPEN) then
			doorState(self) := OPENING
		endif
	
	rule r_opening_to_fullyopen =
		if doorState(self) = OPENING then
			if status = JUSTOPENED then
				doorState(self) := FULLYOPEN
			endif
		endif
		
	rule r_fullyopen_to_closing =
		if(doorState(self) = FULLYOPEN and command = CLOSE) then
			doorState(self) := CLOSING
		endif
	
	rule r_closing_to_fullyclosed =
		if(doorState(self) = CLOSING) then
			if command = OPEN then
				doorState(self) := OPENING
			else
				if
		endif
	
	rule r_door =
		par
			r_fullyclosed_to_opening[]
			r_opening_to_fullyopen[]
			r_fullyopen_to_closing[]
			r_closing_to_fullyclosed[]
		endpar

	// INVARIANTS
	

	// MAIN RULE
	main rule r_Main =
		par
			program(controller)
			program(door)
		endpar

// INITIAL STATE
default init s0:
	function doorState($d in Door) = FULLYCLOSED
	function controllerState($c in Controller) = MOVING
	
	agent Controller:
		r_controller[]
	agent Door:
		r_door[]
		
		
