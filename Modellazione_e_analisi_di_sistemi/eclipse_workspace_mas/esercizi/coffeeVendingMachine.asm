// a simple example with a tic tac toe game

asm coffeeVendingMachine

import StandardLibrary

signature:
	// DOMAINS
	enum domain CoinType = {HALF | ONE}
	enum domain Product = {COFFEE | MILK}
	domain QuantityDomain subsetof Integer
	domain CoinDomain subsetof Integer
	controlled available: Product -> QuantityDomain
	controlled coins: CoinDomain
	monitored insertedCoin: CoinType

definitions:
	// DOMAIN DEFINITIONS
	domain QuantityDomain = {0:10}
	domain CoinDomain = {0:25}

	rule r_serveProduct($p in Product) =
		par
			available($p) := available($p) - 1
			coins := coins + 1
		endpar

	// MAIN RULE
	main rule r_Main =
		if coins < 25 then
			if insertedCoin = HALF then
				if available(MILK) > 0 then
					r_serveProduct[MILK]
				endif
			else
				if available(COFFEE) > 0 then
					r_serveProduct[COFFEE]
				endif
			endif
		endif
		

// INITIAL STATE
default init s0:
	function coins = 0
	function available($p in Product) = 10
