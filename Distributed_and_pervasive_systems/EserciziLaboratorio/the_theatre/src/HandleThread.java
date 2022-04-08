import java.io.ByteArrayInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;

public class HandleThread implements Runnable{

    private Socket mySocket;

    public HandleThread(Socket s){
        mySocket = s;
    }

    @Override
    public void run() {
        /* Inizializza lo stream di output verso la socket */
        DataOutputStream outToClient = null;
        try {
            outToClient = new DataOutputStream(mySocket.getOutputStream());

            //Let's try to buy a ticket for the client. In fact there could be none.
            int res = ServerTheatre.show.buyTicket();
            if(res!= -1){
                outToClient.writeBytes("Have a good show! You are the " + res + "th client!");
            }else{
                outToClient.writeBytes("Sorry, sold out!");
            }

            mySocket.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
