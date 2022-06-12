asm esame_15_09_2011_redo

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	domain Process subsetof Agent
	domain Semaphore subsetof Agent
	enum domain SemaphoreStateDomain = {FREE | LOCKED}
	enum domain ProcessStateDomain = {IDLE, ENTERING, CRITICAL, EXITING}
	domain ProcessRequestState subsetof Integer
	domain ProcessesInCriticalDomain subsetof Integer
	
	// FUNCTIONS
	monitored processRequestEnter: Process -> Boolean
	monitored processRequestExit: Process -> Boolean
	controlled pendingRequests: Process -> ProcessRequestState 	
	controlled semaphoreState: Semaphore -> SemaphoreStateDomain
	controlled processState: Process -> ProcessStateDomain
	
	//agenti
	static process1: Process
	static process2: Process
	static process3: Process
	static semaphore: Semaphore
	
	//derived processesInCritical: ProcessesInCriticalDomain

definitions:
	domain ProcessRequestState = {0:2}	//0 = not interested, 1 = interested, 2 = granted
	domain ProcessesInCriticalDomain = {0:3}

	//function processesInCritical = 
	//	size({$p in Process | processState($p) = CRITICAL : $p})
		
	rule r_idle =
		if(processState(self) = IDLE) and processRequestEnter(self) = true then
			par
				processState(self) := ENTERING
				pendingRequests(self) := 1
			endpar
		endif
	
	rule r_entering =
		if(processState(self) = ENTERING and pendingRequests(self) = 2) then
			processState(self) := CRITICAL
		endif
		
	rule r_critical =
		if(processState(self) = CRITICAL and processRequestExit(self) = true) then
			processState(self) := EXITING
		endif
	
	
	rule r_exiting = 
		if(processState(self) = EXITING) then
			par
				pendingRequests(self) := 0
				processState(self) := IDLE
			endpar
		endif
	
	rule r_process =
		par
			r_idle[]
			r_entering[]
			r_critical[]
			r_exiting[]
		endpar
		
	rule r_semaphore =
		if(semaphoreState(self) = FREE) then
			choose $p in Process with pendingRequests($p) = 1 do
				if(isDef($p)) then
					par
						pendingRequests($p) := 2
						semaphoreState(self) := LOCKED
					endpar
				endif
		else
			//if not(exist $pp in Process with pendingRequests($pp) = 2) then
			if pendingRequests(process1) != 2 and pendingRequests(process2) != 2 and pendingRequests(process3) != 2 then
				semaphoreState(self) := FREE
			endif
		endif
	
	
	//invariant inv_1 over processesInCritical: (processesInCritical <= 1)
	CTLSPEC ag((processState(process1) = CRITICAL and not(processState(process2) = CRITICAL) and not(processState(process3) = CRITICAL)) or 
		(processState(process2) = CRITICAL and not(processState(process1) = CRITICAL) and not(processState(process3) = CRITICAL)) or
		(processState(process3) = CRITICAL and not(processState(process2) = CRITICAL) and not(processState(process1) = CRITICAL)) or
		(not(processState(process1) = CRITICAL) and not(processState(process2) = CRITICAL) and not(processState(process3) = CRITICAL)))
	

	// MAIN RULE
	main rule r_Main =
		par
			choose $p in Process with true do
				program($p)
			program(semaphore)
		endpar
		

// INITIAL STATE
default init s0:
	function semaphoreState($s in Semaphore) = FREE
	function processState($p in Process) = IDLE
	function pendingRequests($p in Process) = 0
	
	agent Process:
		r_process[]
	
	agent Semaphore:
		r_semaphore[]
	
	
