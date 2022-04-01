// a simple example with a tic tac toe game

asm bambini_e_caramelle_LaGreca

import StandardLibrary

signature:
	// DOMAINS
	domain Child subsetof Agent
	// FUNCTIONS
	static child1: Child
	static child2: Child
	static child3: Child
	static child4: Child
	controlled ownedCandies: Child -> Integer
	static rightOf: Child -> Child
	static leftOf: Child -> Child
	
definitions:
	
	// FUNCTION DEFINITIONS
	function rightOf($c in Child) = 
		switch($c)
			case child1: child2
			case child2: child3
			case child3: child4
			case child4: child1
		endswitch
	
	function leftOf($c in Child) = 
		switch($c)
			case child1: child4
			case child2: child1
			case child3: child2
			case child4: child3
		endswitch
	
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
	
	// MAIN RULE
	main rule r_Main =
		choose $c in Child with true do
			program($c)

// INITIAL STATE
default init s0:
	function ownedCandies($c in Child) = 4
	
	agent Child:
		r_child[]
