// a simple example with a tic tac toe game

asm esercizio2

import StandardLibrary

signature:
	//DOMINI
	abstract domain Pos
	domain Sizes subsetof Integer
	abstract domain Elem
	
	//FUNZIONI
	static k: Integer
	monitored insert_rear: Elem
	monitored delete_front: Boolean
	controlled size: Sizes
	controlled next: Pos -> Pos
	controlled prec: Pos -> Pos
	controlled head: Pos
	controlled tail: Pos
	controlled content: Pos -> Elem
	
definitions:
	// DOMAIN DEFINITIONS
	domain Sizes = {0:k}

	// FUNCTION DEFINITIONS
	function k = 10
	
	
	// RULE DEFINITIONS
	rule r_insert =
		if head = undef then
			extend Pos with $p do
				par
					content($p) := insert_rear
					head := $p
					tail := $p
				endpar
		else
			extend Pos with $p do
				par
					content($p) := insert_rear
					next($p) := tail
					prec(tail) := $p
					tail := $p
				endpar
		endif

	
	rule r_delete =
		par
			content(head) := undef
			head := prec(head)
		endpar
			
	
	// MAIN RULE
	main rule r_Main =
		if insert_rear != undef and size < k then
			r_insert[]
		else
			if delete_front = true and size > 0 then
				r_delete[]
			endif
		endif
		

// INITIAL STATE
default init s0:
	function size = 0
	function head = undef
	function tail = undef
