//abbiamo una popolazione che si evolve.
//ogni individuo è caratterizzato da:
//-un sesso
//-un'età
//-una madre e un padre
//un passo della macchina = trascorre un anno
//ogni volta che passa un anno, un individuo fa UNA di queste tre cose:
//-invecchia di un anno
//-si riproduce
//-muore

//VINCOLI
//una donna tra i 13 e 50 anni si può riprodurre.
//l'uomo può riprodursi dai 13 anni in poi.
//una donna fertile si riproduce con prob. = 20% -> sceglie un uomo fertile.
//il sesso nel nascituor è 50% M e 50% F.

//ogni anno, un individuo muore con prob. = 10%

asm esercizio_popolazione_LaGreca

import StandardLibrary

signature:
	// DOMAINS
	dynamic abstract domain Persons
	enum domain Sex = {MALE, FEMALE}
	// FUNCTIONS
	static adamo: Persons
	static eva: Persons
	
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

	//solo per debug (per vedere insomma quanta gente è viva in un dato
	//momento), si può togliere tranquillamente
	controlled count: Integer
	
definitions:
	// DOMAIN DEFINITIONS

	// FUNCTION DEFINITIONS
	
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
				
				choose $n in {1:20} with true do
					if $n = 1 then		//muore
						r_die[$x]
					else	//non muore: o si riproduce o invecchia
						if sex($x) = FEMALE and age($x) >= 13 and age($x) <= 50 then
							choose $m in {1:5} with true do
								if $m = 1 then
									if (exist $male in Persons with sex($male) = MALE and age($male) >= 13 and alive($male)) then
										choose $y in Persons with sex($y) = MALE and age($y) >= 13 and alive($y) do
											r_reproduce[$x, $y]
									endif
								endif
						endif	
					endif
			
			endpar
		
	// INVARIANTS
	//l'età dei figli è inferiore a quella dei genitori (se questi sono vivi)
	invariant over age, father, mother:
		(forall $x in Persons with 
			alive(mother($x)) implies age($x) <= age(mother($x)) and 
			alive(father($x)) implies age($x) <= age(father($x))
		)
	
	//i bambini appena nati sono vivi
	invariant over age, alive:
		(forall $x in Persons with (age($x) = 0 implies alive($x)))
		
	//per ogni individuo, il padre è diverso dalla madre (non vale per adamo ed eva)
	invariant over father, mother:
		(forall $x in Persons with 
			($x != adamo and $x != eva) implies father($x) != mother($x)
		)

	// MAIN RULE
	main rule r_Main =
		r_makeAYearPass[]
		

// INITIAL STATE
default init s0:
	function sex($p in Persons) = switch($p)
									case adamo: MALE
									case eva: FEMALE
								endswitch

	function age($p in Persons) = switch($p)
									case adamo: 20
									case eva: 20
								endswitch
	
	function mother($p in Persons) = switch($p)
									case adamo: adamo
									case eva: eva
								endswitch
	
	function father($p in Persons) = switch($p)
									case adamo: adamo
									case eva: eva
								endswitch
	
	function alive($p in Persons) = switch($p)
									case adamo: true
									case eva: true
								endswitch
	
	function count = 2
	