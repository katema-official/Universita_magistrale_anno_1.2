// a simple example with a tic tac toe game

asm esame_15_09_2011_LeGreca

import ../StandardLibrary

signature:
	// DOMAINS
	domain Process subsetof Agent
	enum domain SemaphoreDomain = {RED, GREEN}
	enum domain ProcessStateDomain = {IDLE, ENTERING, CRITICAL, EXITING}
	// FUNCTIONS
	static process1: Process
	static process2: Process
	static process3: Process
	
	controlled semaphore: SemaphoreDomain
	controlled processState: Process -> ProcessStateDomain
	
	static processesInCritical: Integer

definitions:
	// DOMAIN DEFINITIONS

	// FUNCTION DEFINITIONS
	function processesInCritical =
		size({$p in Process | processState($p) = CRITICAL : $p}) 
		
	// RULE DEFINITIONS
	rule r_idle =
		if processState(self) = IDLE then
			processState(self) := ENTERING
		endif
		
	rule r_entering =
		if processState(self) = ENTERING then
			if semaphore = GREEN then
				par
					semaphore := RED
					processState(self) := CRITICAL
				endpar
			endif
		endif
		
	rule r_critical = 
		if processState(self) = CRITICAL then
			par
				skip	//ci immaginiamo che faccia delle robe...
				skip
				skip
				processState(self) := EXITING
			endpar
		endif
		
	rule r_exiting =
		if processState(self) = EXITING then
			par
				semaphore := GREEN
				processState(self) := IDLE
			endpar
		endif
		
	rule r_agent =
		par
			r_idle[]
			r_entering[]
			r_critical[]
			r_exiting[]
		endpar

	// INVARIANTS
	invariant over semaphore, processState:
		((semaphore = RED) implies processesInCritical <= 1)

	// MAIN RULE
	main rule r_Main =
		choose $proc in Process with true do
			program($proc)	//se "schedulassimo" più di un processo per volta avremmo inconsistenze,
							//dobbiamo immaginare di avere una sola CPU sul nostro computer ove
							//risiedono i processi

// INITIAL STATE
default init s0:
	
	function processState($p in Process) = IDLE
	function semaphore = GREEN
	agent Process:
		r_agent[]
