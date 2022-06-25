asm lagreca

import StandardLibrary
import CTLlibrary

signature:
	//domain XX subsetof YY
	//enum domain ZZ = { ... | ...}
	enum domain CameraDomain = {NONE, STANDARD, PREMIUM}	//per dire se è entrata/uscita una
	//macchina standard, premium o se non è esntrata/uscita alcuna macchina
	enum domain SemaphoreDomain = {GREEN, YELLOW, RED}
	domain FreeSlotsDomain subsetof Integer
	domain FreeSlotsPremiumDomain subsetof Integer
	
	//sensori
	monitored enterCamera: CameraDomain
	monitored exitCamera: CameraDomain
	
	//contatori dei posti liberi
	controlled freeSlots: FreeSlotsDomain
	controlled freeSlotsPremium: FreeSlotsPremiumDomain
	
	//semaforo
	controlled semaphore : SemaphoreDomain
	
	//controlled f: A -> B
	//monitored g: C -> D
	//derived h: S -> T
	
definitions:
	domain FreeSlotsDomain = {0:15}	//ci sono al massimo 15 posti liberi
	domain FreeSlotsPremiumDomain = {0:5}
	
	

	//function ...

	rule r_enter =
		//se c'è una macchina standard all'entrata e il semaforo è verde,
		//allora quella macchina può parcheggiare in un posto standard libero.
		if(enterCamera = STANDARD and semaphore = GREEN) then
			freeSlots := freeSlots - 1
		//se invece vuole entrare una macchina premium e ci sono posti liberi,
		//la facciamo entrare. 
		else
			if(enterCamera = PREMIUM and semaphore != RED) then
				freeSlotsPremium := freeSlotsPremium - 1
			endif
		endif
	
	rule r_exit =
		//se esce una macchina standard, si libera un posto standard
		if(exitCamera = STANDARD and freeSlots < 15) then
			freeSlots := freeSlots + 1
		else 
			if(exitCamera = PREMIUM and freeSlotsPremium < 5) then
				freeSlotsPremium := freeSlotsPremium + 1
			endif
		endif
			
	rule r_updateSemaphore =
	
		//prima pensiamo a cosa succede quando esce una macchina.
		if(exitCamera != NONE) then
			
			//se il parcheggio è pieno ed esce una macchina premium, il semaforo diventa giallo
			if(semaphore = RED and freeSlots + freeSlotsPremium = 0 and exitCamera = PREMIUM) then
				semaphore := YELLOW
			//se invece, quando il semaforo non è verde, esce una macchina standard, 
			//il semaforo diventa verde
			else
				if(semaphore != GREEN and exitCamera = STANDARD and freeSlots < 15) then
					semaphore := GREEN
				
				endif
			endif
			
		else
			//quindi, se siamo qui, non sono uscite macchine, ma potrebbero esserne entrate alcune
		
			//se il semaforo è verde, i posti liberi standard occupati sono tutti occupati
			//meno che uno, e sta entrando una macchina standard, allora il semaforo deve diventare
			//giallo
			if(semaphore = GREEN and freeSlots = 1 and enterCamera = STANDARD) then
				semaphore := YELLOW
			//se invece, in generale, sta entrando una macchina e la somma dei posti liberi 
			//standard e premium fa 1, allora il semaforo deve diventare rosso
			else 
				if((freeSlots = 1 and freeSlotsPremium = 0 and enterCamera = STANDARD) or 
					(freeSlots = 0 and freeSlotsPremium = 1 and enterCamera = PREMIUM))then
						semaphore := RED
				endif
			endif
				
		endif
		
		
		
			
			
		
	//Si suppone che, quando entra una macchina premium, ci sia almeno un posto premium libero
	//invariant over enterCamera, freeSlotsPremium: (enterCamera = PREMIUM implies freeSlotsPremium > 0)
	
	//non possono uscire macchine quando non ce ne sono nel parcheggio
	//invariant over exitCamera, freeSlots, freeSlotsPremium: ((exitCamera != NONE) implies freeSlots + freeSlotsPremium < 20)
	
	//CTLSPEC ....
	//prima o poi il semaforo diventa rosso
	CTLSPEC ef(semaphore = RED)
	
	//se non ci sono posti liberi ma ce ne sono ancora per abbonati, il semaforo è giallo
	CTLSPEC ag((freeSlots = 0 and freeSlotsPremium > 0) implies semaphore = YELLOW)

	//se il semaforo è rosso, prima o poi diventa verde
	//(non è possibile, riporta un controesempio)
	CTLSPEC ag(semaphore = RED implies af(semaphore = GREEN))
	
	//main rule r_Main =
	//	par
	//		r_enter[]
	//		r_exit[]
	//		r_updateSemaphore[]
	//	endpar
	
	//main rule alternativa che gestisce esplicitamente il fatto che potrebbe, nello stesso stato,
	//entrare e uscire una macchina. In questo caso, do la priorità alla macchina che esce. Sarà
	//il sistema, nello stato successivo, a dirmi che c'è ancora una macchina in attesa di entrare
	main rule r_Main =
		par
			if(exitCamera != NONE) then
				r_exit[]
			else
				r_enter[]
			endif
			r_updateSemaphore[]
		endpar
	
		
default init s0:
	function freeSlots = 1
	function freeSlotsPremium = 3
	function semaphore = GREEN