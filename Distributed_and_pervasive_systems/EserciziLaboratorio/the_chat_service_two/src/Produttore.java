import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.util.Scanner;

public class Produttore implements Runnable{

    private int role;   //0 = riceve il messaggio dall'altro, 1 = deve mandare il messaggio all'altro
    private Socket socket;
    private MyQueue receiveQueue;
    private MyQueue sendQueue;
    private BufferedReader inFromOther;
    public Produttore(int role, Socket socket, MyQueue receiveQueue, MyQueue sendQueue) throws IOException {
        this.role = role;
        this.socket = socket;
        this.receiveQueue = receiveQueue;
        this.sendQueue = sendQueue;
        /* Inizializza lo stream di input dalla socket */
        this.inFromOther = new BufferedReader(new InputStreamReader(socket.getInputStream()));
    }

    @Override
    public void run() {
        while(true) {
            //role = 0: il produttore (sia lato client che lato server) legge dalla
            //socket il messaggio e lo mette nella coda
            if (role == 0) {
                try {
                    System.out.println("Attendo messaggio...");
                    String result = inFromOther.readLine();
                    System.out.println("ricevuto messaggio, ora lo metto in coda receive");
                    receiveQueue.put(result);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } else {
                //role = 1: il produttore deve leggere da stdin il messaggio da mandare all'altro
                Scanner sc = new Scanner(System.in);
                String message = sc.nextLine();
                sendQueue.put(message);
                System.out.println("messo messaggio nella send queue");
            }
        }
    }
}
