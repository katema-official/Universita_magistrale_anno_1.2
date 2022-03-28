// a simple example with a tic tac toe game

asm esercizio_popolazione_raffinato_2_LaGreca

import StandardLibrary

signature:
	// DOMAINS
	dynamic abstract domain Persons
	enum domain Sex = {MALE, FEMALE}
	// FUNCTIONS
	static adamo: Persons
	static eva: Persons
	static adamo2: Persons
	static eva2: Persons
	
	//funzioni per sapere il sesso, l'età, la madre e il padre di un individuo
	controlled sex: Persons -> Sex
	controlled age: Persons -> Integer
	controlled mother: Persons -> Persons
	controlled father: Persons -> Persons
	
	//funzione per sapere se un individuo è vivo o morto (volevo usare un set
	//che si espandeva e contraeva al nascere e morire di un individuo,
	//ma dato che un'invariante chiede esplicitamente di dimostrare che ogni
	//bambino appena nato è vivo, non vedo altra soluzione se non questa)
	controlled alive: Persons -> Boolean //true = vivo, false = morto

	controlled count: Integer
	
	derived areBrothers: Prod(Persons, Persons) -> Boolean
	derived giveBrothers: Persons -> Powerset(Persons)
	
definitions:
	// DOMAIN DEFINITIONS

	// FUNCTION DEFINITIONS
	function areBrothers($p1 in Persons, $p2 in Persons) =
		$p1 != $p2 and father($p1) = father($p2) and mother($p1) = mother($p2)
	
	function giveBrothers($p in Persons) =
		{$x in Persons | areBrothers($p, $x) : $x}
	
	// RULE DEFINITIONS
	rule r_die($p in Persons) =
		par
			alive($p) := false
			count := count - 1
		endpar
		
	
	rule r_reproduce($mom in Persons, $dad in Persons) =
		extend Persons with $child do
			par
				//il sesso del nascituro
				choose $n in {1,2} with true do
					if $n = 1 then
						sex($child) := MALE
					else
						sex($child) := FEMALE
					endif
					
				//i suoi genitori
				mother($child) := $mom
				father($child) := $dad
				
				//la sua età
				age($child) := 0
				
				//è vivo
				alive($child) := true
				
				count := count + 1
				
			endpar
	
	
	rule r_choose_partner($mom in Persons) =
		
		if sex($mom) = FEMALE and age($mom) >= 13 and age($mom) <= 50 then
			choose $m in {1:5} with true do
				if $m = 1 then
					if (exist $male in Persons with sex($male) = MALE 
						and age($male) >= 13 
						and alive($male)
						and father($mom) != $male
						and mother($male) != $mom
						and areBrothers($mom, $male) = false
					) then
						choose $y in Persons with sex($y) = MALE 
							and age($y) >= 13 
							and alive($y)
							and father($mom) != $y
							and mother($y) != $mom
							and areBrothers($mom, $y) = false do
								r_reproduce[$mom, $y]
					endif
				endif
		endif	
	
			
	rule r_age($x in Persons) =
		age($x) := age($x) + 1
	
	rule r_makeAYearPass =
		//quando passa un anno, ogni individuo (vivo) deve:
		//-morire, oppure
		//-riprodursi, se è una donna in età fertile e vuole farlo
		//(gli uomini si riproducono se trovano una partner), oppure
		//-invecchia di un anno
		forall $x in Persons with alive($x) do
			par
				//ogni anno, ogni individuo invecchia di un anno
				r_age[$x]
				
				choose $n in {1:50} with true do
					if $n = 1 then		//muore
						r_die[$x]
					else	//non muore: forse si riproduce
						r_choose_partner[$x]
					endif
			
			endpar
		
	// INVARIANTS
	//l'età dei figli è inferiore a quella dei genitori (se questi sono vivi)
	invariant over age, father, mother:
		(forall $x in Persons with 
			alive($x) implies
			((alive(mother($x)) implies age($x) <= age(mother($x))) and 
			(alive(father($x)) implies age($x) <= age(father($x))))
		)
	
	//i bambini appena nati sono vivi
	invariant over age, alive:
		(forall $x in Persons with (age($x) = 0 implies alive($x)))
		
	//per ogni individuo, il padre è diverso dalla madre (non vale per adamo ed eva)
	invariant over father, mother:
		(forall $x in Persons with 
			($x != adamo and $x != eva and $x != adamo2 and $x != eva2) 
			implies father($x) != mother($x)
		)

	//Modello R4: i genitori di ogni persona non possono essere fratelli
	invariant over father, mother:
		(forall $x in Persons with areBrothers(father($x), mother($x)) = false)

	// MAIN RULE
	main rule r_Main =
		r_makeAYearPass[]
		

// INITIAL STATE
default init r2:
	function sex($p in Persons) = switch($p)
									case adamo: MALE
									case eva: FEMALE
									case adamo2: MALE
									case eva2: FEMALE
								endswitch

	function age($p in Persons) = switch($p)
									case adamo: 20
									case eva: 20
									case adamo2: 20
									case eva2: 20
								endswitch
	
	function mother($p in Persons) = switch($p)
									case adamo: adamo
									case eva: eva
									case adamo2: adamo2
									case eva2: eva2
								endswitch
	
	function father($p in Persons) = switch($p)
									case adamo: adamo
									case eva: eva
									case adamo2: adamo2
									case eva2: eva2
								endswitch
	
	function alive($p in Persons) = switch($p)
									case adamo: true
									case eva: true
									case adamo2: true
									case eva2: true
								endswitch
								
	
	
	function count = 4
