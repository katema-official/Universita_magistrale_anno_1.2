import java.io.*;
import java.net.Socket;

public class Client {
    public static void main(String args[]) throws Exception{
        BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Give me the address of the server");
        String address = inFromUser.readLine();

        System.out.println("Now give me the port of the server");
        int port = Integer.parseInt(inFromUser.readLine());

        System.out.println("Give me the two numbers to sum, separed by a whitespace");
        String[] numbers_array = inFromUser.readLine().split(" ");

        if(numbers_array.length != 2) throw new Exception("Error: expected two integers ");
        int num1 = Integer.parseInt(numbers_array[0]);
        int num2 = Integer.parseInt(numbers_array[1]);



        /* Inizializza una socket client, connessa al server */
        Socket clientSocket = new Socket(address, port);

        /* Inizializza lo stream di output verso la socket */
        DataOutputStream outToServer =
                new DataOutputStream(clientSocket.getOutputStream());



        /* Invia la linea al server */
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        baos.write(num1);
        baos.write(num2);
        byte[] b = baos.toByteArray();
        outToServer.write(b);

        //prendo il messaggio che mi ha mandato il server
        DataInputStream dis = new DataInputStream(clientSocket.getInputStream());

        /* Legge la risposta inviata dal server (linea terminata da \n) */
        int result = dis.readInt();

        System.out.println("Result calculated by server: " + result);

    }

}
