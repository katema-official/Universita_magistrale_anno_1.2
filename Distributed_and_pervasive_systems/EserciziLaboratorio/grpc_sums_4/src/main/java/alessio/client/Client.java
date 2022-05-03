package alessio.client;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import it.generated.sumservice.SumServiceGrpc;
import it.generated.sumservice.SumServiceGrpc.*;
import it.generated.sumservice.SumServiceOuterClass.*;

public class Client {

    public static void main(String[] args) throws InterruptedException{

        String host = "localhost";
        int port = 8080;

        //prima chiamiamo il servizio più semplice: dati due interi, sommali.
        //facciamolo sia in modo sincrono che asincrono
        synchronousCall(host, port);
        asynchronousStreamCall();




    }

    private static void synchronousCall(String host, int port){
        //crea un channel tra il client e il server
        //"plaintext channel on the address (ip/port) which offers the GreetingService service"
        ManagedChannel channel = ManagedChannelBuilder.forTarget(host + ":" + port).usePlaintext().build();

        //ora serve la stub.
        //"creating a BLOCKING stub on the channel"
        SumServiceBlockingStub stub = SumServiceGrpc.newBlockingStub(channel);

        //chiediamo al server di fare la somma di due interi
        ClientRequestIntegersToSum req = ClientRequestIntegersToSum.newBuilder().setN1(10).setN2(20).build();
        ServerResponseInteger res = stub.oneToOneSum(req);

        System.out.println("chiamata bloccante: " + req.getN1() + " + " + req.getN2() + " = " + res.getRes());

        channel.shutdown();
    }

    private static void asynchronousStreamCall(){

    }
}
