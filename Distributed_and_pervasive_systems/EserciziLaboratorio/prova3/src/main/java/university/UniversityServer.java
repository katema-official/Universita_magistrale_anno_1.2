package university;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class UniversityServer {
    public static void main(String argv[]) throws IOException {

        //apro il server
        ServerSocket serverSocket = new ServerSocket(9999);
        Socket s = serverSocket.accept();

        while(true) {

            //Student student = Student.parseFrom(s.getInputStream());

        }

    }
}
