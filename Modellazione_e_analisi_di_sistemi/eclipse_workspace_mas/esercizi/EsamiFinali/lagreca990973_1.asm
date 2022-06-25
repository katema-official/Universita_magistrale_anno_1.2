// a simple example with a tic tac toe game

asm lagreca990973_1

import ../StandardLibrary
import ../CTLlibrary

signature:
	// DOMAINS
	domain Player subsetof Agent
	domain MyIntegers subsetof Integer
	
	
	// FUNCTIONS
	controlled plateCounter: MyIntegers
	controlled possessedTokens: Player -> MyIntegers
	static p1: Player
	static p2: Player
	static p3: Player
	
	derived left: Player -> Player
	derived right: Player -> Player
	

definitions:
	// DOMAIN DEFINITIONS
	domain MyIntegers = {0:9}
	
	// FUNCTION DEFINITIONS
	function left($p in Player) =
		switch $p
			case p1: p3
			case p2: p1
			case p3: p2
		endswitch
		
	function right($p in Player) =
		switch $p
			case p1: p2
			case p2: p3
			case p3: p1
		endswitch
	
	// RULE DEFINITIONS
	
		
	
	rule r_play =
		if possessedTokens(self) > 0 then
			par
				possessedTokens(self) := possessedTokens(self) - 1
				plateCounter := plateCounter + 1
			endpar
		else
			if possessedTokens(right(self)) > 0 then
				par
					possessedTokens(self) := possessedTokens(self) + 1
					possessedTokens(right(self)) := possessedTokens(right(self)) - 1
				endpar
			else
				if possessedTokens(left(self)) > 0 then
					par
						possessedTokens(right(self)) := possessedTokens(right(self)) + 1
						possessedTokens(left(self)) := possessedTokens(left(self)) - 1
					endpar
				endif
			endif	
		endif
	
	// INVARIANTS
	invariant inv_1 over plateCounter, possessedTokens: plateCounter + possessedTokens(p1) +
		possessedTokens(p2) + possessedTokens(p3) = 9
	
	//CTLSPECs
	//1) nel sistema ci sono sempre al massimo 9 token
	CTLSPEC ag(plateCounter + possessedTokens(p1) + possessedTokens(p2) + possessedTokens(p3) <= 9)
	//2) ogni giocatore non ha mai più di 3 token
	CTLSPEC (forall $p in Player with ag(possessedTokens($p) <= 3))
	//3) prima o poi nessun giocatore ha token
	CTLSPEC ag(af(possessedTokens(p1) = 0 and possessedTokens(p2) = 0 and possessedTokens(p3) = 0))
	//4) prima o poi il piatto ha 9 token
	CTLSPEC ag(af(plateCounter = 9))
	//ATTENZIONE! Le ultime due non riescono ad essere verificate dato che il model checker considera
	//(giustamente, in quanto ho usato il connettivo af()) anche un cammino molto sfortunato, in cui:
	//ad un certo punto, due players, diciamo p1 e p2, hanno una solo token, mentre p3 non ne ha.
	//dato il funzionamento della choose, ad ogni passo di computazione viene mandato in esecuzione un
	//solo agente per volta. Bene, supponiamo questo sia p3. P3 prenderà un token da p1. Al passo successivo
	//viene scelto come player in esecuzione p1, che prende una caramella da p2, e così via all'infinito.
	//Si tratta chiaramente di un caso limite dovuto ai limiti imposti dal linguaggio di asmeta e dai limiti
	//del model checker stesso. Possiamo comunque provare le seguenti proprietà, che rappresentando una
	//versione indebolita delle precedenti, ma che sono comunque di reachability:
	CTLSPEC ag(ef(possessedTokens(p1) = 0 and possessedTokens(p2) = 0 and possessedTokens(p3) = 0))
	CTLSPEC ag(ef(plateCounter = 9))

	// MAIN RULE
	main rule r_Main =
		choose $p in Player with true do
			program($p)

// INITIAL STATE
default init s0:
	function plateCounter = 0
	function possessedTokens($p in Player) = 3
	
	agent Player:
		r_play[]
