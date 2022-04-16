// a simple example with a tic tac toe game

asm SSL

import StandardLibrary

signature:
	// DOMAINS
	domain GoodAgent subsetof Agent
	dynamic abstract domain Nonce
	dynamic abstract domain PubKey
	dynamic abstract domain PriKey
	dynamic abstract domain SessionKey
	dynamic abstract domain Message
	dynamic abstract domain Traffic
	enum domain MessageType = {MSG1, MSG2, MSG3}
	dynamic abstract domain EncryptedNonce
	
	// FUNCTIONS
	static pubkey: Agent -> PubKey
	static prikey: Agent -> PriKey
	static inv: PubKey -> PriKey
	controlled genNonces: Agent -> Powerset(Nonce)
	
	static agentA: GoodAgent
	static agentB: GoodAgent
	
	static pubKeyA: PubKey
	static pubKeyB: PubKey
	static priKeyA: PriKey
	static priKeyB: PriKey
	
	controlled message1: Message -> Prod(SessionKey, PubKey)
	controlled message2: Message -> Prod(Nonce, SessionKey)
	controlled message3: Message -> Prod(PubKey, EncryptedNonce, SessionKey)	//modello il certificato C_a come la sua chiave pubblica e basta
	
	monitored wishToInitiate: Agent -> Boolean
	monitored wishToInitiate: Prod(Agent, Agent) -> Boolean
	controlled dest: Traffic -> Agent
	controlled readTraffic: Traffic -> Boolean
	controlled val: Traffic -> Prod(Agent, Agent, Message)
	controlled messageType: Message -> MessageType
	controlled recipient: Nonce -> Agent
	
	derived decryptM1: Prod(Message, PriKey) -> SessionKey
	derived decryptM2: Prod(Message, SessionKey) -> Nonce
	derived decryptM3: Prod(Message, SessionKey) -> Prod(PubKey, Nonce)
	
	controlled knownSessionKeys: Agent -> Seq(SessionKey)
	
	controlled encryptNonce: Prod(Nonce, PriKey) -> EncryptedNonce
	controlled keyToDecryptNonce: EncryptedNonce -> PubKey
	controlled nonceToEncryptedNonce: Nonce -> EncryptedNonce
	controlled encryptedNonceToNonce: EncryptedNonce -> Nonce
	derived decryptNonce: Prod(EncryptedNonce, PubKey) -> Nonce

definitions:
	// DOMAIN DEFINITIONS

	// FUNCTION DEFINITIONS
	function pubkey($a in Agent) =
		switch($a)
			case agentA: pubKeyA
			case agentB: pubKeyB
		endswitch
	
	function prikey($a in Agent) =
		switch($a)
			case agentA: priKeyA
			case agentB: priKeyB
		endswitch
	
	function inv($pub in PubKey) = 
		if(pubkey(self) = $pub) then
			switch(self)
				case agentA: priKeyA
				case agentB: priKeyB
			endswitch
		endif
		

	function decryptNonce($en in EncryptedNonce, $pub in PubKey) =
		if keyToDecryptNonce($en) = $pub then
			encryptedNonceToNonce($en)
		endif

	
	function decryptM1($m in Message, $k in PriKey) =
		let($truem = message1($m)) in
			if(isDef($truem)) then
				if( inv(second($truem)) = $k ) then
					first($truem)
				endif
			endif
		endlet
	
	function decryptM2($m in Message, $k in SessionKey) =
		let($truem = message2($m)) in
			if(isDef($truem)) then
				if( contains(asSet(knownSessionKeys(self)), $k) ) then
					first($truem)
				endif
			endif
		endlet
	
	function decryptM3($m in Message, $k in SessionKey) =
		let($truem = message3($m)) in
			if(isDef($truem)) then
				if( contains(asSet(knownSessionKeys(self)), $k) ) then
					let($nonce = decryptNonce(second($truem), first($truem))) in
						(first($truem), $nonce)
					endlet
				endif
			endif
		endlet

	// RULE DEFINITIONS
	//ci si aspetta che pri = inv(pub)
	macro rule r_encryptNonce($n in Nonce, $pri in PriKey, $pub in PubKey) =
		if($pri = inv($pub)) then
			extend EncryptedNonce with $en do
				par
					encryptNonce($n, $pri) := $en
					keyToDecryptNonce($en) := $pub
					encryptedNonceToNonce($en) := $n
					nonceToEncryptedNonce($n) := $en
				endpar
		endif
	
	macro rule r_clear($t in Traffic) =
		//val($t) := undef
		readTraffic($t) := true

	macro rule r_send($s in Agent, $r in Agent, $m in Message) =
		extend Traffic with $t do // creazione di un nuovo elemento di traffico
			par
				val($t) := ($s, $r, $m)
				readTraffic($t) := false // l'elemento di traffico non e' ancora stato letto dal receiver
			endpar
	
	macro rule r_initSession = 
		if(wishToInitiate(self)) then
			choose $x in Agent with $x != self and wishToInitiate(self, $x) and
				(forall $t in Traffic with (first(val($t)) and second(val($t)) = $x implies readTraffic($t) = true)) do
					extend SessionKey with $sk do
						extend Message with $m do
							par
								knownSessionKeys(self) := append(knownSessionKeys(self), $sk)
								message1($m) := ($sk, pubkey($x))
								messageType($m) := MSG1
								r_send[self, $x, $m]
							endpar
		endif
	
	macro rule r_receiveMessage1 =
		choose $t in Traffic with second(val($t)) = self and messageType(third(val($t))) = MSG1 
			and readTraffic($t) = false do
				let ($sk = decryptM1(third(val($t)), prikey(self))) in
					extend Nonce with $n do
						extend Message with $m do
							par
								genNonces(self) := including(genNonces(self), $n)
								message2($m) := ($n, $sk)
								knownSessionKeys(self) := append(knownSessionKeys(self), $sk)
								messageType($m) := MSG2
								r_send[self, first(val($t)), $m]
								r_clear[$t]
							endpar
					
				endlet
			
	macro rule r_receiveMessage2 =
		choose $t in Traffic with second(val($t)) = self and messageType(third(val($t))) = MSG2 
			and readTraffic($t) = false do
				let ($nonce = decryptM2(third(val($t)), last(knownSessionKeys(self)))) in
					extend Message with $m do
						par
							seq
								r_encryptNonce($n, prikey(self), pubkey(self))
								message3($m) := (pubkey(self), nonceToEncryptedNonce($nonce), last(knownSessionKeys(self)))
							endseq
							messageType($m) := MSG3
							r_send[self, first(val($t)), $m]
							r_clear[$t]
						endpar
					
				endlet
	
	macro rule r_receiveMessage3 =
		choose $t in Traffic with second(val($t)) = self and messageType(third(val($t))) = MSG3 
			and readTraffic($t) = false do
				let ($decrMsg = decryptM3(third(val($t)), last(knownSessionKeys(self)))) in
					let($nonce = second($decrMsg)) in
						if(contains(genNonces(self), $nonce)) then
							r_clear[$t]
						endif
					endlet
				endlet
	

	macro rule r_goodAgentProgram =
		par
			r_initSession[]
			r_receiveMessage1[]
			r_receiveMessage2[]
			r_receiveMessage3[]
		endpar

	// MAIN RULE
	main rule r_Main =
		forall $a in GoodAgent with true do
			program($a)

// INITIAL STATE
default init s0:
	function genNonces($a in Agent) = {}
	
	agent GoodAgent:
		r_goodAgentProgram[]
