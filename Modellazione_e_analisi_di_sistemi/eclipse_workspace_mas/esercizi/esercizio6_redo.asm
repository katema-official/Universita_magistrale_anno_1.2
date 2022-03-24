asm esercizio6_redo

import StandardLibrary
//ci può essere un aggiornamento inconsistente se, nello stesso
//passo, una macchina entra e l'altra esce. Al momento
//non saprei come risolvere
signature:
	//DOMAINS
	enum domain Color = {GREEN | RED}
	enum domain Camera = {ENTRANCE | EXIT}
	
	//FUNCTIONS
	monitored maxInit: Integer
	controlled max: Integer
	//le videocamere sono segnali che provengono dall'ambiente
	monitored videocamera_f: Camera -> Boolean 
	controlled semaphore: Color
	//mi serve un counter per le macchine presenti
	controlled cars: Integer

	

definitions:
	//REGOLE
	rule r_entrataMacchina =
		if semaphore = GREEN and videocamera_f(ENTRANCE) = true and cars < max then
			par
				cars := cars + 1
				
				if cars = max - 1 then
					semaphore := RED
				endif
			endpar
		endif
			
		
	rule r_uscitaMacchina = 
		if videocamera_f(EXIT) = true then
			par
				cars := cars - 1
				
				if semaphore = RED then
					semaphore := GREEN
				endif
			endpar
		endif

	// MAIN RULE
	main rule r_Main =
		par
			r_entrataMacchina[]
			r_uscitaMacchina[]
		endpar

// INITIAL STATE
default init s0:
	function max = maxInit
	function cars = 0
	function semaphore = GREEN
	function videocamera_f($c in Camera) = false