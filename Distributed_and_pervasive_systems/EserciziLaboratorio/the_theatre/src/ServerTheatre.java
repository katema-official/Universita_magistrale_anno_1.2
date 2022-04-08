import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class ServerTheatre {

    //I create the show (there is only one) of the theatre
    public static Reservations show= new Reservations(10);

    public static void main(String args[]) throws Exception{

        BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));

        /* Crea una "listening socket" sulla porta specificata */
        ServerSocket welcomeSocket = new ServerSocket(6789);

        while(true) {
            System.out.println("Waiting for a new connection...");
            /*
             * Viene chiamata accept (bloccante).
             * All'arrivo di una nuova connessione crea una nuova
             * "established socket".
             * I assume that, when a client connects to the server,
             * it does so because he wants to buy a ticket.
             */
            Socket connectionSocket = welcomeSocket.accept();
            Thread ht = new Thread(new HandleThread(connectionSocket));
            ht.start();


        }



    }


}
