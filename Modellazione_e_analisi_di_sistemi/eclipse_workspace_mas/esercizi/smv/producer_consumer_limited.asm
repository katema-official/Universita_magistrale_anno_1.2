asm producer_consumer_limited 

import ../StandardLibrary
import ../CTLlibrary

signature:
	domain Producer subsetof Agent
	domain Consumer subsetof Agent
	enum domain Products = {PROD1, PROD2, PROD3, PROD4, PROD5}

	dynamic controlled waiting: Producer -> Boolean // se l'agente e' in attesa
	dynamic controlled waiting: Consumer -> Boolean
	dynamic controlled inBuffer: Products // contenuto del buffer

	dynamic controlled consumedProducts: Prod(Consumer, Products) -> Boolean // prodotti consumati dal consumer

	static producer: Producer
	static consumer: Consumer

definitions:

	rule r_writeBuffer($p in Products) =
		inBuffer := $p // mette il prodotto nel buffer

	rule r_readBuffer =
		par
			//dato che a un certo punto gli elementi da mettere nel buffer possono finire,
			//dobbiamo chiedere al consumatore di consumare solo se c'è un elemento
			if(isDef(inBuffer)) then
				let($x = inBuffer) in
					consumedProducts(self, $x) := true //legge il valore dal buffer
				endlet
			endif
			inBuffer := undef // svuota il buffer
			
		endpar

	//l'agente si mette in attesa
	rule r_waiting =
		waiting(self) := true

	//l'agente $a viene svegliato
	rule r_notify($a in Producer) =
		waiting($a) := false
	
	rule r_notify($a in Consumer) =
		waiting($a) := false

	//se il produttore non e' in attesa puo' produrre
	rule r_produce =
		if(not(waiting(self))) then
			par
				//non possiamo usare l'extend, quindi assumiamo di scegliere a caso
				//un elemento non ancora consumato dal consumatore e di metterlo
				//nel buffer
				//if(size(consumedProducts(consumer)) < 5) then
					choose $prod in Products with consumedProducts(consumer, $prod) = false do 
						r_writeBuffer[$prod] // mette il prodotto nel buffer
				//endif
				r_waiting[] // si mette in attesa
				r_notify[consumer] //sveglia il consumatore
			endpar
		endif

	//se il consumatore non e' in attesa puo' consumare
	rule r_consume =
		if(not(waiting(self))) then
			par
				r_readBuffer[] //prende il prodotto dal buffer
				r_waiting[] //si mette in attesa
				r_notify[producer] //sveglia il produttore
			endpar
		endif
	
	//CTLSPECs
	//quando il produttore è in esecuzione, il buffer deve essere vuoto (undef)
	CTLSPEC ag((not waiting(producer)) implies isDef(inBuffer) = false)
	
	//quando il consumatore è in esecuzione, il buffer deve essere pieno
	CTLSPEC ag(not(waiting(consumer)) implies isDef(inBuffer))
	
	//se un elemento è sul buffer, allora non è tra gli elementi consumati dal consumatore
	CTLSPEC ag(not consumedProducts(consumer, inBuffer))
	
	//in ogni stato, o il produttore o il consumatore è in esecuzione, ma mai contemporaneamente
	CTLSPEC ag(not(waiting(producer)) xor not(waiting(consumer)))
	
	//il consumatore consuma tutti i prodotti generati dal produttore
	CTLSPEC ag(isDef(inBuffer) implies ax(consumedProducts(consumer, inBuffer)))

	main rule r_Main =
		par
			program(producer)
			program(consumer)
		endpar

default init s0:
	function waiting($a in Consumer) = true
	function waiting($a in Producer) = false
	
	function consumedProducts($c in Consumer, $p in Products) = false // all'inizio il consumatore non ha consumato nulla

	agent Producer:
		r_produce[]

	agent Consumer:
		r_consume[]