//-avrò bisogno di uno stato che mi dice se è giorno o notte
//-un sensore che mi dice quando viene aperto il cancello di casa
//-una variable che rappresenta la luce
//-probabilmente devo modellare lo scorrere del tempo
//non è specificato cosa si intende con "notte", quindi assumerò
//che sia il periodo di tempo, durante la giornata, che va
//dalle 22.00 alle 6.00.

asm esercizio8

import StandardLibrary

signature:
	//DOMINI
	enum domain Moment = {DAY | NIGHT}
	domain Hours subsetof Integer
	domain Min subsetof Integer
	domain TimerTime subsetof Integer
	//FUNZIONI
	controlled state: Moment
	monitored gate: Boolean	//true = aperto, false = chiuso
	controlled timer: TimerTime	//se > 0, la luce è considerata accesa
	controlled h: Hours
	controlled m: Min
	
	static h_beginNight: Integer
	static h_beginDay: Integer
	

definitions:
	// DOMAIN DEFINITIONS
	domain Hours = {0:23}
	domain Min = {0:59}
	domain TimerTime = {0:10}
	
	//FUNCTION DEFINITIONS
	function h_beginNight = 22
	function h_beginDay = 6

	//RULES
	rule r_updateHour =
		h := (h + 1) mod 24
	
	//regola per far scorrere il tempo
	rule r_updateMin =
		par
			if m = 59 then
				r_updateHour[]
			endif
			m := (m + 1) mod 60
		endpar
		
	//regola per accendere per 10 minuti la luce quando
	//il cancello si apre
	rule r_lightOn = 
		timer := 10
		
	//regola per far scorrere il timer della luce quando
	//la luce è accesa
	rule r_lightDim =
		timer := timer - 1
		
	
	// MAIN RULE
	main rule r_Main =
		par
			//faccio scorrere il tempo
			r_updateMin[]
			
			//controllo se sono passato dalla notte al
			//giorno e viceversa
			if state = NIGHT and h >= h_beginDay then
				state := DAY
			endif
			if state = DAY and h >= h_beginNight then
				state := NIGHT
			endif
			
			//se il cancello viene aperto di notte, il timer si setta a 10
			if state = NIGHT and gate = true then
				r_lightOn[]
			//altrimenti, se la luce è ancora accesa, faccio
			//scorrere il timer
			else if timer > 0 then
					r_lightDim[]
				endif
			endif
		endpar

// INITIAL STATE
init s0:
	function m = 0
	function h = 0
	function state = NIGHT
	function timer = 0
	
//per analizzare un caso interessante
default init s1:
	function m = 55
	function h = 5
	function state = NIGHT
	function timer = 0
