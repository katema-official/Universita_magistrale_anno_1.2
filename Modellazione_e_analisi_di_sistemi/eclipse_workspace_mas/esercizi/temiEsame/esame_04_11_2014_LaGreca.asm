// a simple example with a tic tac toe game

asm esame_04_11_2014_LaGreca

import ../StandardLibrary

signature:
	// DOMAINS
	enum domain GateStatusSensor = {JUST_OPENED, JUST_CLOSED}	//se le porte SI SONO aperte o chiuse
	enum domain GateStatus = {OPENING, OPEN, CLOSING, CLOSE}	//se le porte SONO aperte o chiuse
	// FUNCTIONS
	
	//i tre sensori
	monitored arrived: Boolean //true = il treno è arrivato in stazione, false = il treno si sta muovendo
	monitored status: GateStatusSensor	//JUST_OPENED = le porte si sono aperte, JUST_CLOSED = si sono chiuse.
	monitored pass_person: Boolean //true = una persona sta attraversando la porta, false = nessuno lo sta facendo
	
	//il testo dell'esercizio mi fa pensare che il controller debba essere un agente, ma sinceramente,
	//non vedendo altri agenti in gioco, almeno dal testo dell'esercizio, posso immaginare
	//il mio modello come un modello mono-agente, e quindi immaginare che il controller sia l'intera
	//applicazione
	controlled gates: GateStatus	//OPEN = le porte sono aperte, OPENING, le porte si stanno aprendo,
									//CLOSE = le porte sono chiuse, CLOSING, le porte si stanno chiudendo.
	monitored oneMinutePassed: Boolean //true = è passato un minuto dall'apertura delle porte, false altrimenti
	
		

definitions:
	// DOMAIN DEFINITIONS

	// FUNCTION DEFINITIONS
	
	// RULE DEFINITIONS
	rule r_arrive =
		//non appena la metro arriva alla stazione, il controller fa aprire le porte
		if gates = CLOSE then
			if arrived then
				gates := OPENING
			endif
		endif
	
	rule r_stay =
		par
			//le porte si stanno aprendo, e status mi dirà quando si saranno aperte del tutto
			if gates = OPENING then	//non li metto in and perchjé altrimenti mi chiede status anche quando non
									//ce n'è bisogno
				if status = JUST_OPENED then
					gates := OPEN
				endif
			endif
		
			//le porte sono aperte, e dopo un minuto cominciano a chiudersi
			if gates = OPEN then
				if oneMinutePassed = true then
					gates := CLOSING
				endif
			endif
		
		endpar
	
	rule r_restart = 
		//se le porte si stanno chiudendo...
		if gates = CLOSING then
			//se qualcuno si è fiondato nella metro, riapriamole
			if pass_person then
				gates := OPENING
			else
				//se così non è e le porte hanno finito di chiudersi, allora le consideriamo chiuse
				if status = JUST_CLOSED then
					gates := CLOSE
				endif
			endif
		endif
		
	// INVARIANTS
	
	// MAIN RULE
	main rule r_Main =
		par
			r_arrive[]	//la metro arriva alla stazione
			r_stay[]	//la metro rimane alla stazione
			r_restart[]	//la metro si appresta a lasciare la stazione
		endpar

// INITIAL STATE
default init s0:
	function gates = CLOSE
