import java.io.*;
import java.net.Socket;

public class HandleThread implements Runnable{

    private int num1;
    private int num2;
    private Socket mySocket;

    public HandleThread(Socket s){
        mySocket = s;
    }


    @Override
    public void run() {



        /* Inizializza lo stream di input e output verso la socket */
        InputStream is = null;
        DataOutputStream outToClient = null;
        try {
            is = mySocket.getInputStream();
            outToClient = new DataOutputStream(mySocket.getOutputStream());
            byte[] data = new byte[2];
            int count = is.read(data);
            ByteArrayInputStream bais = new ByteArrayInputStream(data);

            num1 = bais.read();
            System.out.println("num 1 = " + num1);
            num2 = bais.read();
            System.out.println("num 2 = " + num2);

            int result = num1 + num2;

            /* Invia la risposta al client */
            outToClient.writeInt(result);

            mySocket.close();



        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
