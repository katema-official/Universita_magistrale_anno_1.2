asm esercizio6

import StandardLibrary

//entità in ballo:
//-due videocamere, una d'ingresso e una d'uscita
//-un semaforo che può essere verde o rosso
//-un counter delle macchine parcheggiate
//-un numero massimo di posti disponibili nel parcheggio.
//"Siamo in un parcheggio..."

signature:
	//DOMAINS
	enum domain Color = {GREEN | RED}
	//enum domain Camera = {ENTRANCE | EXIT}
	
	//FUNCTIONS
	//nello stato iniziale, sarà l'utente a dirmi
	//quanto è grande il parcheggio
	monitored maxInit: Integer
	controlled max: Integer
	//le videocamere sono segnali che provengono dall'ambiente
	monitored entrance: Boolean	//da cambiare
	monitored exit: Boolean
	//monitored videocamera_f: Camera -> Boolean (Volevo farla
	//così ma non capisco se o come si può fare)
	//il semaforo è una cosa che controlla il sistema
	controlled semaphore: Color
	//mi serve un counter per le macchine presenti
	controlled cars: Integer

	

definitions:
	//REGOLE
	rule r_entrataMacchina =
		//ho pensato anche di mettere i due if in parallelo, ma il
		//comportamento che otterrei non penso rispecchi adeguatamente
		//il modello che desidero: ad un passo evolutivo del mio
		//sistema, se (esempio) il numero massimo di auto è 3 e ce
		//ne sono già 2, e ne sta entrando una terza, voglio:
		//1) aggiungere la macchina al parcheggio
		//2) cambiare il semaforo da GREEN a RED
		//mettendole in parallelo questo comportamento lo si avrebbe
		//in due stati del sistema distinti. Lo stesso discorso
		//vale per la regola di uscita
		if semaphore = GREEN and entrance = true and cars < max then
			seq
				cars := cars + 1
				
				if cars = max then
					semaphore := RED
				endif
			endseq
		endif
			
		
	rule r_uscitaMacchina = 
		if exit = true then
			seq
				cars := cars - 1
				
				if semaphore = RED then
					semaphore := GREEN
				endif
			endseq
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
	//function videocamera_f[($ENTRANCE in Camera)] = false
