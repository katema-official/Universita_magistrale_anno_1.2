package alessio.client;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.Server;
import io.grpc.stub.StreamObserver;
import it.generated.sumservice.SumServiceGrpc;
import it.generated.sumservice.SumServiceGrpc.*;
import it.generated.sumservice.SumServiceOuterClass.*;

import java.util.concurrent.TimeUnit;

public class Client {

    public static void main(String[] args) throws InterruptedException {

        String host = "localhost";
        int port = 8080;

        //prima chiamiamo il servizio più semplice: dati due interi, sommali.
        //facciamolo sia in modo sincrono che asincrono
        synchronousCall(host, port);
        asynchronousStreamCallFirst(host, port);
        asynchronousStreamCallSecond(host, port);
        asynchronousStreamCallThird(host, port);


    }

    private static void synchronousCall(String host, int port) {
        //crea un channel tra il client e il server
        //"plaintext channel on the address (ip/port) which offers the GreetingService service"
        //final
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

    private static void asynchronousStreamCallFirst(String host, int port) throws InterruptedException {
        //anche qui creiamo il channel
        //final
        ManagedChannel channel = ManagedChannelBuilder.forTarget("localhost:8080").usePlaintext().build();

        //creiamo la stub
        //"creating an ASYNCHRONOUS stub on the channel
        SumServiceStub stub = SumServiceGrpc.newStub(channel);

        //ora creiamo la richiesta
        ClientRequestIntegersToSum req = ClientRequestIntegersToSum.newBuilder().setN1(10).setN2(5).build();

        //e ora chiamiamo il metodo RPC, che però essendo asincrono, richiede degli handlers.
        //"calling the RPC method. Since it is asynchronous, we need to define handlers"
        stub.oneToOneSum(req, new StreamObserver<ServerResponseInteger>() {

            //"this handler takes care of each item received in the stream"
            @Override
            public void onNext(ServerResponseInteger value) {
                System.out.println("async " + req.getN1() + " + " + req.getN2() + " = " + value.getRes());
            }

            //"if there are some errors, this method will be called"
            @Override
            public void onError(Throwable t) {
                System.out.println("Error! " + t.getMessage());
            }

            //"When the stream is completed (the server called "onCompleted") just close the channel
            @Override
            public void onCompleted() {
                channel.shutdownNow();
            }
        });

        channel.awaitTermination(10, TimeUnit.SECONDS);
    }

    private static void asynchronousStreamCallSecond(String host, int port) throws InterruptedException {
        //anche qui creiamo il channel
        //final
        ManagedChannel channel = ManagedChannelBuilder.forTarget("localhost:8080").usePlaintext().build();

        //creiamo la stub
        //"creating an ASYNCHRONOUS stub on the channel
        SumServiceStub stub = SumServiceGrpc.newStub(channel);

        //ora creiamo la richiesta
        ClientRequestIntegersToSum req = ClientRequestIntegersToSum.newBuilder().setN1(10).setN2(5).build();

        //e ora chiamiamo il metodo RPC, che però essendo asincrono, richiede degli handlers.
        //"calling the RPC method. Since it is asynchronous, we need to define handlers"
        stub.oneToStreamSum(req, new StreamObserver<ServerResponseInteger>() {

            //"this handler takes care of each item received in the stream"
            @Override
            public void onNext(ServerResponseInteger value) {
                System.out.println("Stream n t current sum: " + value.getRes());
            }

            //"if there are some errors, this method will be called"
            @Override
            public void onError(Throwable t) {
                System.out.println("Error! " + t.getMessage());
            }

            //"When the stream is completed (the server called "onCompleted") just close the channel
            @Override
            public void onCompleted() {
                channel.shutdownNow();
            }
        });

        channel.awaitTermination(10, TimeUnit.SECONDS);
    }

    private static void asynchronousStreamCallThird(String host, int port) throws InterruptedException {
        ManagedChannel channel = ManagedChannelBuilder.forTarget("localhost:8080").usePlaintext().build();
        SumServiceStub stub = SumServiceGrpc.newStub(channel);

        //QUI C'E' LA DIFFERENZA
        //stub prima non restituiva nulla, mentre ora restituisce uno StreamObserver
        //tale StreamObserver è scritto dal client e letto dal server
        StreamObserver<ClientRequestIntegersToSum> streamServer = stub.streamToStreamSum(new StreamObserver<ServerResponseInteger>() {
            //questo qui invece è lo stream su cui il client legge (e il server manda messaggi).
            //in pratica devo definire cosa fare lato client quando ricevo un messaggio dal server
            @Override
            public void onNext(ServerResponseInteger value) {
                System.out.println("returned from server: " + value.getRes());
            }

            @Override
            public void onError(Throwable t) {

            }

            @Override
            public void onCompleted() {

            }
        });

        //ora possiamo scrivere sullo stream diretto al server (QUELLO RESTITUITO DALLA STUB)
        ClientRequestIntegersToSum[] requests = new ClientRequestIntegersToSum[3];
        for(int i = 0; i < 3; i++){
            requests[i] = ClientRequestIntegersToSum.newBuilder().setN1(i).setN2(i).build();
            streamServer.onNext(requests[i]);
        }

        //You NEED this. Otherwise the method will terminate before the answrs from the servers are received
        channel.awaitTermination(10, TimeUnit.SECONDS);
    }
}
