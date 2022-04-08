import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String args[]) throws Exception {
        BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("Give me the port of the server (the one I'll use for my service)");
        int port = Integer.parseInt(inFromUser.readLine());

        /* Crea una "listening socket" sulla porta specificata */
        ServerSocket welcomeSocket = new ServerSocket(port);

        while(true) {
            System.out.println("Waiting for a new connection...");
            /*
             * Viene chiamata accept (bloccante).
             * All'arrivo di una nuova connessione crea una nuova
             * "established socket"
             */
            Socket connectionSocket = welcomeSocket.accept();
            Thread ht = new Thread(new HandleThread(connectionSocket));
            ht.start();


        }



    }
}
