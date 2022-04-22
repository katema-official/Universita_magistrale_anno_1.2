import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;

public class Consumatore implements Runnable{

    private int role;   //0 = riceve il messaggio dall'altro, 1 = deve mandare il messaggio all'altro
    private Socket socket;
    private MyQueue receiveQueue;
    private MyQueue sendQueue;
    private DataOutputStream outToClient;

    public Consumatore(int role, Socket socket, MyQueue receiveQueue, MyQueue sendQueue) throws IOException {
        this.role = role;
        this.socket = socket;
        this.receiveQueue = receiveQueue;
        this.sendQueue = sendQueue;
        this.outToClient = new DataOutputStream(socket.getOutputStream());
    }


    @Override
    public void run() {
        //role = 0: il consumatore (sia lato client che lato server) legge il
        //messaggio dalla coda e lo butta nello standard output
        while(true) {
            if (role == 0) {
                String message = receiveQueue.take();
                System.out.println("Dal tuo interlocutore: " + message);
            } else {
                //role = 1: il consumatore prende il messaggio dalla coda e lo manda all'altro
                String message = sendQueue.take() + "\n";
                System.out.println("letto il messaggio dalla coda send, ora lo mando");
                try {
                    outToClient.writeBytes(message);
                    System.out.println("mandato");
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
