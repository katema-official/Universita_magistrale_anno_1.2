import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

public class MainClient {
    public static void main(String args[]) throws IOException {
        /* Inizializza una socket client, connessa al server */
        Socket clientSocket = new Socket("localhost", 6789);

        MyQueue receiveQueue = new MyQueue();
        MyQueue sendQueue = new MyQueue();
        Produttore p0 = new Produttore(0, clientSocket, receiveQueue, sendQueue);
        Produttore p1 = new Produttore(1, clientSocket, receiveQueue, sendQueue);
        Consumatore c0 = new Consumatore(0, clientSocket, receiveQueue, sendQueue);
        Consumatore c1 = new Consumatore(1, clientSocket, receiveQueue, sendQueue);

        Thread t0 = new Thread(p0);
        Thread t1 = new Thread(p1);
        Thread t2 = new Thread(c0);
        Thread t3 = new Thread(c1);
        t0.start();
        t1.start();
        t2.start();
        t3.start();
    }
}
