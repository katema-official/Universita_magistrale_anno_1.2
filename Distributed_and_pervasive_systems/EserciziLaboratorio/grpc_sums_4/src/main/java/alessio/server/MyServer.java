package alessio.server;

import io.grpc.Server;
import io.grpc.ServerBuilder;

import java.io.IOException;

public class MyServer {
    public static void main(String[] args) throws IOException, InterruptedException {

        Server serverService = ServerBuilder.forPort(8080).addService(new SumServiceImpl()).build();
        serverService.start();
        System.out.println("Servizio SumService operativo");
        serverService.awaitTermination();
    }
}
