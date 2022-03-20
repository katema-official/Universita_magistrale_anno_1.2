//abbiamo:
//-un controllore che manda segnali a
//-un condizionatore
//-due fasi della giornata da modellare
//-una variabile che ci dice la temperatura corrente
//-una variabile che ci dice la temperatura ambiente
//-una variabile che ci dice la temperatura minima
//-forse una variabile aggiuntiva che modelli la volontà
//dell'utente di aggiornare o la temperatura ambiente
//o la temperatura minima? In realtà non ce ne sarebbe bisogno,
//ma la aggiungerò lo stesso per fare in modo che, durante
//l'esecuzione del modello, ad ogni passo di evoluzione venga
//prima chiesto se si vuole aggiornare la temperatura richiesta.
//Se la rispostà è affermativa, tale temperatura verrà chiesta
//in input. Altrimenti, non verrà chiesto altro all'utente (lo faccio
//per evitare bloating di input insomma, altrimenti, per specificare
//che non voglio cambiare la temperatura, ad ogni passo dovrei fornire
//come input il valore precedente)

asm esercizio7

import StandardLibrary

signature:
	//DOMINI
	enum domain Phase = {DAY | NIGHT}
	//FUNZIONI
	//controllore che rappresenta il momento della giornata
	monitored controller: Phase
	//le varie temperature
	
	/*ATTENZIONE: avrei voluto rendere current_t shared, visto
	che vorrei sapere la temperatura corrente dall'ambiente
	e poi aggiornarla azionando il condizionatore, ma dopo
	qualche esecuzione fallimentare ho cercato sulla documentazione
	e ho trovato questo:
	'(Shared) It is not supported by the current simulator: it
	could be implemented by using a monitored
	function to get the value from the user and a
	controlled function to store it so it can be used
	by the machine.' Farò così quindi*/
	controlled current_t: Integer
	monitored current_t_input: Integer
	
	controlled ambient_t: Integer
	monitored ambient_t_input: Integer
	
	controlled minimum_t: Integer
	monitored minimum_t_input: Integer
	
	//forse si potrebbero costruire un dominio e 
	//due funzioni del tipo:
	//enum domain Temperature = {CURRENT | AMBIENT | MINIMUM}
	//monitored t_input: Temperature -> Integer
	//controlled t: Temperature -> Integer
	//ma non riesco a capire come scriverle in modo tale
	//che mi vengano accettate dal compilatore. O meglio,
	//vorrei inizializzare questi valori, ma non capisco
	//come fare.
	
	monitored update_button: Boolean
	

definitions:

	//REGOLE
	
		
	rule r_day =
		par
			if update_button = true then
				ambient_t := ambient_t_input		
			endif
			
			seq
				current_t := current_t_input
				if current_t > ambient_t then
					current_t := ambient_t	//troppo semplice? Non so
				endif
			endseq
		endpar
	
	rule r_night =
		par
			if update_button = true then
				minimum_t := minimum_t_input		
			endif
			
			seq
				current_t := current_t_input
				if current_t > minimum_t then
					current_t := minimum_t	//troppo semplice? Non so
				endif
			endseq
		endpar
	
	rule r_error =
		skip

	rule r_condizionatore = 
		if controller = DAY then
			r_day[]
		else
			if controller = NIGHT then
				r_night[]
			else
				r_error[]
			endif
		endif

	// MAIN RULE
	main rule r_Main =
		r_condizionatore[]

// INITIAL STATE
default init s0:
	function ambient_t = 26
	function minimum_t = 28
	function controller = DAY
	function update_button = false
	//function t($AMBIENT) = 26	//??? Come si fa?
	
