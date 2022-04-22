import java.util.Random;

public class Main {

    public static void main(String[] args){
        //stanza 7020 7* piano

        WaitingRoom wr = new WaitingRoom();

        for(int i = 0; i < 20; i++){
            Random rand = new Random();
            int random_integer = rand.nextInt(2-0) + 0;
            Thread t;
            System.out.println(random_integer);
            if(random_integer == 0){
                t = new Thread(new AnimalThread(AnimalThread.CAT_IDENTIFIER, wr));
            }else{
                t = new Thread(new AnimalThread(AnimalThread.DOG_IDENTIFIER, wr));
            }
            t.start();
        }
        System.out.println("aaa");
    }


}
