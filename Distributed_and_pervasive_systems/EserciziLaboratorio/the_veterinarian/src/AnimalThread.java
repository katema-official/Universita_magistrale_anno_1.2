import java.util.Random;

public class AnimalThread implements Runnable{
    private String animalType;
    private WaitingRoom wr;
    private static int catCount = 0;
    private static int dogCount = 0;
    public static final String CAT_IDENTIFIER = "cat";
    public static final String DOG_IDENTIFIER = "dog";

    public AnimalThread(String animalType, WaitingRoom wr){
        this.animalType = animalType;
        this.wr = wr;
    }

    @Override
    public void run() {
        try {
            wr.enterRoom(animalType);
            String s = animalType == CAT_IDENTIFIER ? "cat " : "dog ";
            System.out.println(s + Thread.currentThread().getName() + " entered the waiting room");
            Random rnd = new Random();
            double seconds = 1 + Math.random() * 10;
            Thread.sleep((long) seconds * 1000);
            wr.exitRoom(animalType);
            System.out.println(s + Thread.currentThread().getName() + " exited the waiting room" );
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }
}
