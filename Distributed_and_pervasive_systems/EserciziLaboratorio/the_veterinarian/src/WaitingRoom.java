public class WaitingRoom {

    private boolean isCatPresent;
    private int dogCounter;

    public WaitingRoom(){
        isCatPresent = false;
        dogCounter = 0;
    }

    //a cat can't enter if there is already another animal
    //a dog can't enter if there is already a cat
    //a dog can't enter if there are already four dogs
    public synchronized void enterRoom(String animalType) throws InterruptedException {
        switch(animalType){
            case AnimalThread.CAT_IDENTIFIER -> {
                while(isCatPresent || dogCounter > 0){
                    System.out.println("cat " + Thread.currentThread().getName() + " waits...");
                    wait();
                    System.out.println("cat " + Thread.currentThread().getName() + " retries!");
                }
                isCatPresent = true;
            }
            case AnimalThread.DOG_IDENTIFIER -> {
                while(isCatPresent || dogCounter > 4){
                    System.out.println("dog " + Thread.currentThread().getName() + " waits...");
                    wait();
                    System.out.println("dog " + Thread.currentThread().getName() + " retries!");
                }
                dogCounter++;
            }


        }
    }

    public synchronized void exitRoom(String animalType){
        switch(animalType){
            case AnimalThread.CAT_IDENTIFIER -> {
                isCatPresent = false;
                notify();
            }

            case AnimalThread.DOG_IDENTIFIER -> {
                dogCounter--;
                notify();
            }
        }
    }
}
