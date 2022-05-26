

asm bambini_e_caramelle_limited

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	domain Child subsetof Agent
	domain CandyInt subsetof Integer
	// FUNCTIONS
	static child1: Child
	static child2: Child
	static child3: Child
	static child4: Child
	static child5: Child
	static child6: Child
	controlled ownedCandies: Child -> CandyInt
	static rightOf: Child -> Child
	static leftOf: Child -> Child
	derived totalCandies: CandyInt
	
definitions:

	domain CandyInt = {0:24}
	
	// FUNCTION DEFINITIONS
	function rightOf($c in Child) = 
		switch($c)
			case child1: child2
			case child2: child3
			case child3: child4
			case child4: child5
			case child5: child6
			case child6: child1
		endswitch
	
	function leftOf($c in Child) = 
		switch($c)
			case child1: child6
			case child2: child1
			case child3: child2
			case child4: child3
			case child5: child4
			case child6: child5
		endswitch
		
	function totalCandies = ownedCandies(child1) +ownedCandies(child2) + ownedCandies(child3) + 
		ownedCandies(child4) + ownedCandies(child5) + ownedCandies(child6)
	
	rule r_eatCandy =
		if (ownedCandies(self) > 0) then
			ownedCandies(self) := ownedCandies(self) - 1
		endif
	
	rule r_stealCandy =
		if (ownedCandies(self) = 0) then
			if (ownedCandies(rightOf(self)) > 0) then
				par
					ownedCandies(rightOf(self)) := ownedCandies(rightOf(self)) - 1
					ownedCandies(self) := ownedCandies(self) + 1
				endpar
			else
				if (ownedCandies(leftOf(self)) > 0) then
					par
						ownedCandies(leftOf(self)) := ownedCandies(leftOf(self)) - 1
						ownedCandies(rightOf(self)) := ownedCandies(rightOf(self)) + 1
					endpar
				endif
			endif
		endif
	
	// RULE DEFINITIONS
	rule r_child =
		par
			r_eatCandy[]
			r_stealCandy[]
		endpar

	// INVARIANTS
	
	//CTL specs
	//nel sistema ci sono sempre al massimo 24 caramelle
	CTLSPEC ag(totalCandies <= 24)
	
	//ogni bambino non ha mai più di 4 caramelle (sarà falsa... in teoria)
	CTLSPEC (forall $x in Child with ag(ownedCandies($x) <= 4))
	
	//prima o poi nel sistema non ci sono più caramelle
	CTLSPEC af(totalCandies = 0)
	
	// MAIN RULE
	main rule r_Main =
		choose $c in Child with true do	//con la forall funziona NuSMV ma non ASMeta
			program($c)

// INITIAL STATE
default init s0:
	function ownedCandies($c in Child) = 4
	
	agent Child:
		r_child[]
