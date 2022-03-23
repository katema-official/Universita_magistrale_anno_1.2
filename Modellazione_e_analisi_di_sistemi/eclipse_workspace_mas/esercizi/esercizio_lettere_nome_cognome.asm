// a simple example with a tic tac toe game

asm esercizio_lettere_nome_cognome

import StandardLibrary

signature:
	// DOMAINS
	domain Set subsetof Integer
	domain RandomNumbersPC subsetof Integer
	enum domain Result = {ONGOING, USER_WIN, PC_WIN, TIE}
	
	// FUNCTIONS
	controlled alreadyChosen: Set -> Boolean	//true = già scelto, false = non ancora
	//il punteggio dell'utente e del pc può essere modellato come
	//un'unica variabile che:
	//-aumenta di due quando l'utente vince il turno corrente
	//-diminuisce di due quando il pc vince il turno corrente
	//-non cambia quando c'è un pareggio
	//alla fine, se score >0 ha vinto l'utente, se = 0 c'è
	//stato pareggio, se <0 ha vinto il pc
	controlled score: Integer
	monitored userChoice: Set
	derived notEnd: Boolean
	controlled result_f: Result

definitions:
	// DOMAIN DEFINITIONS
	domain Set = {1, 3, 5, 7, 9, 12, 15, 18, 19}
	domain RandomNumbersPC = {1:26}

	//la partita non finisce fintanto che l'utente ha da scegliere almeno
	//un elemento di set
	function notEnd =
		(exist $s in Set with alreadyChosen($s) = false)
		
	rule r_turn($choice in Set) =
		choose $numpc in RandomNumbersPC with true do
			if $choice > $numpc then
				score := score + 2
			else
				if $choice < $numpc then
					score := score - 2
				endif
				//in caso di pareggio il punteggio non viene alterato
			endif
	
	rule r_ending =
		if score > 0 then
			result_f := USER_WIN
		else
			if score < 0 then
				result_f := PC_WIN
			else
				result_f := TIE
			endif
		endif

	// MAIN RULE
	main rule r_Main =
		if notEnd then
			let($choice = userChoice) in
				//se l'utente non aveva mai scelto prima questo valore dal set,
				//il turno può essere giocato
				if alreadyChosen($choice) = false then
					par
						r_turn[$choice]
						alreadyChosen($choice) := true
					endpar
				endif
			endlet
		else
			r_ending[]
		endif

// INITIAL STATE
default init s0:
	function alreadyChosen($s in Set) = false
	function result_f = ONGOING
	function score = 0
