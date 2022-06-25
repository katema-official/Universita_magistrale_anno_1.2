// a simple example with a tic tac toe game

asm es_1

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	enum domain ColorsDomain = {RED | YELLOW | GREEN}
	domain MyInteger subsetof Integer
	enum domain PhaseDomain = {PHASE1, PHASE2, PHASE3, PHASE4}
	enum domain SemaphoreDomain = {SEM1, SEM2}
	
	
	monitored passed: MyInteger -> Boolean
	controlled phase: PhaseDomain
	controlled semaphore: SemaphoreDomain -> ColorsDomain
	
	
	
	
definitions:
	// DOMAIN DEFINITIONS
	domain MyInteger = {30, 120}
	
	rule r_phase1 =
		if phase = PHASE1 then
			if passed(30) then
				par
					phase := PHASE2
					semaphore(SEM1) := GREEN
					semaphore(SEM2) := RED
				endpar
			endif
		endif
	
	rule r_phase2 =
		if phase = PHASE2 then
			if passed(120) then
				par
					phase := PHASE3
					semaphore(SEM1) := YELLOW
					semaphore(SEM2) := YELLOW
				endpar
			endif
		endif
		
	rule r_phase3 =
		if phase = PHASE3 then
			if passed(30) then
				par
					phase := PHASE4
					semaphore(SEM1) := RED
					semaphore(SEM2) := GREEN
				endpar
			endif
		endif
	
	rule r_phase4 =
		if phase = PHASE4 then
			if passed(120) then
				par
					phase := PHASE1
					semaphore(SEM1) := YELLOW
					semaphore(SEM2) := YELLOW
				endpar
			endif
		endif

	//safety: i due semafori non sono MAI entrambi verdi
	CTLSPEC ag(not(semaphore(SEM1) = GREEN and semaphore(SEM2) = GREEN))
	//liveness: prima o poi ogni semaforo diventa verde
	CTLSPEC ag(ef(semaphore(SEM1) = GREEN)) and ag(ef(semaphore(SEM2) = GREEN))
	//reachability: il sistema può giungere in uno stato in cui un semaforo diventa verde
	CTLSPEC ef(semaphore(SEM1) = GREEN or semaphore(SEM2) = GREEN)
	CTLSPEC ef(semaphore(SEM1) = GREEN) and ef(semaphore(SEM2) = GREEN)
	

	// MAIN RULE
	main rule r_Main =
		par
			r_phase1[]
			r_phase2[]
			r_phase3[]
			r_phase4[]
		endpar

// INITIAL STATE
default init s0:
	function phase = PHASE1
	function semaphore($s in SemaphoreDomain) = YELLOW
