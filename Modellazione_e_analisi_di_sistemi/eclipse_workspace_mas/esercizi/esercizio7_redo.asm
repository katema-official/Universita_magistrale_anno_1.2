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

asm esercizio7_redo

import StandardLibrary

signature:
	//DOMINI
	enum domain Phase = {DAY | NIGHT}
	enum domain Temperature = {CURRENT | AMBIENT | MINIMUM}
	//FUNZIONI
	//controllore che rappresenta il momento della giornata
	monitored controller: Phase
	monitored fault: Boolean
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
	
	monitored t_input: Temperature -> Integer
	controlled t: Temperature -> Integer
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
				t(AMBIENT) := t_input(AMBIENT)	
			endif
			
			seq	//se non usassi seq avrei un aggiornamento inconsistente.
				//inoltre l'uso del seq è dovuto al fatto che non posso
				//usare una variabile shared
				t(CURRENT) := t_input(CURRENT)
				if t(CURRENT) > t(AMBIENT) then
					t(CURRENT) := t(AMBIENT)	//troppo semplice? Non so
				endif
			endseq
		endpar
	
	rule r_night =
		par
			if update_button = true then
				t(MINIMUM) := t_input(MINIMUM)		
			endif
			
			seq
				t(CURRENT) := t_input(CURRENT)
				if t(CURRENT) > t(MINIMUM) then
					t(CURRENT) := t(MINIMUM)
				endif
			endseq
		endpar
	
	rule r_condizionatore = 
		if controller = DAY then
			r_day[]
		else
			r_night[]
		endif

	// MAIN RULE
	main rule r_Main =
		if not fault then
			r_condizionatore[]
		endif
		
// INITIAL STATE
default init s0:
	function controller = DAY
	function update_button = false
	function fault = false
	function t($temp in Temperature) = switch($temp)
										case AMBIENT: 26
										case MINIMUM: 28
										endswitch
