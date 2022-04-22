import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class MainServer {
    public static void main(String args[]) throws IOException {

        /* Crea una "listening socket" sulla porta specificata */
        ServerSocket welcomeSocket = new ServerSocket(6789);

        System.out.println("Waiting for a new connection...");
        Socket connectionSocket = welcomeSocket.accept();
        MyQueue receiveQueue = new MyQueue();
        MyQueue sendQueue = new MyQueue();
        Produttore p0 = new Produttore(0, connectionSocket, receiveQueue, sendQueue);
        Produttore p1 = new Produttore(1, connectionSocket, receiveQueue, sendQueue);
        Consumatore c0 = new Consumatore(0, connectionSocket, receiveQueue, sendQueue);
        Consumatore c1 = new Consumatore(1, connectionSocket, receiveQueue, sendQueue);

        Thread t0 = new Thread(p0);
        Thread t1 = new Thread(p1);
        Thread t2 = new Thread(c0);
        Thread t3 = new Thread(c1);
        t0.start();
        t1.start();
        t2.start();
        t3.start();
        System.out.println("lato server tutto on");
        try{t0.join();}
        catch(Exception e){e.printStackTrace();}

    }

}
