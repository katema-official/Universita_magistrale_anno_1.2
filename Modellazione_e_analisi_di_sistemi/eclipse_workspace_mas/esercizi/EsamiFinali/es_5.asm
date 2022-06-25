
asm es_5

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	enum domain StateDomain = {NORMAL, LIMITED, STOP}
	enum domain CurrentActionDomain = {PRINT, COPY, SCAN, NONE}
	// FUNCTIONS
	controlled printerState: StateDomain
	controlled printerAction: CurrentActionDomain
	monitored print_webfile: Boolean	//ordinati per priorità
	monitored copy_document: Boolean
	monitored scan_document: Boolean
	controlled outmess: String

definitions:

	// FUNCTION DEFINITIONS
	

	// RULE DEFINITIONS
	rule r_normal =
		if printerState = NORMAL then
			if print_webfile = true then
				printerAction := PRINT
			else
				if copy_document = true then
					printerAction := COPY
				else
					if scan_document = true then
						printerAction := SCAN
					else
						printerAction := NONE
					endif
				endif
			endif
		endif
			
		
	
	rule r_limited =
		if printerState = LIMITED then
			if print_webfile then
				printerAction := PRINT
			else
				printerAction := NONE
			endif
		endif
	
	
	rule r_stop = 
		if printerState = STOP then
			outmess := "The defice is out of service, sorry"
		endif

	// INVARIANTS

	// MAIN RULE
	main rule r_Main =
		par
			r_normal[]
			r_limited[]
			r_stop[]
		endpar
		

// INITIAL STATE
default init s0:
	function printerState = NORMAL
	function printerAction = NONE
