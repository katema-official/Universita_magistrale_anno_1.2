asm euclideMCD

import StandardLibrary

signature:
	controlled numA: Integer
	controlled numB: Integer

definitions:
	main rule r_Main =
		if(numA != numB) then
			if (numA > numB) then
				numA := numA - numB
			else
				numB := numB - numA
			endif
		endif

// INITIAL STATE
default init s0:
	function numA = 6409
	function numB = 3289
