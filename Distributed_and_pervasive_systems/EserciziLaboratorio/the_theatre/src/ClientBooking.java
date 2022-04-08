import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.Socket;

public class ClientBooking {
    public static void main(String args[]) throws Exception{

        for(int i = 0; i < 15; i ++) {
            String result = "";

            /* Inizializza una socket client, connessa al server */
            Socket clientSocket = new Socket("localhost", 6789);

            /* Inizializza lo stream di input dalla socket */
            BufferedReader inFromServer =
                    new BufferedReader(new
                            InputStreamReader(clientSocket.getInputStream()));

            /* asks the server if the managed to buy a ticket */
            result = inFromServer.readLine();

            System.out.println("FROM SERVER: " + result);

            clientSocket.close();
        }




    }

}
