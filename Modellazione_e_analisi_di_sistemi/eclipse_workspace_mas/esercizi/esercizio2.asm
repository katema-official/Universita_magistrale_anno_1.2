asm esercizio2

import StandardLibrary

signature:
	//DOMINI
	dynamic abstract domain Pos
	dynamic abstract domain Elem
	
	//FUNZIONI
	static k: Integer
	monitored insert_rear: Elem
	monitored delete_front: Boolean
	controlled size: Integer
	controlled next: Pos -> Pos
	controlled prec: Pos -> Pos
	controlled head: Pos
	controlled tail: Pos
	controlled content: Pos -> Elem
	
	static e1: Elem
	static e2: Elem
	
definitions:
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
			extend Pos with $pp do
				par
					content($pp) := insert_rear
					next($pp) := tail
					prec(tail) := $pp
					tail := $pp
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
