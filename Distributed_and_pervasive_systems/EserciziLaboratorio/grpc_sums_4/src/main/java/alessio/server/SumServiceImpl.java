package alessio.server;

import io.grpc.Server;
import io.grpc.stub.StreamObserver;
import it.generated.sumservice.SumServiceGrpc.SumServiceImplBase;
import it.generated.sumservice.SumServiceOuterClass.*;

public class SumServiceImpl extends SumServiceImplBase {

    @Override
    public void oneToOneSum(ClientRequestIntegersToSum request, StreamObserver<ServerResponseInteger> responseObserver){
        int n1 = request.getN1();
        int n2 = request.getN2();

        ServerResponseInteger sum = ServerResponseInteger.newBuilder().setRes(n1+n2).build();

        responseObserver.onNext(sum);

        responseObserver.onCompleted();
    }

    @Override
    public void oneToStreamSum(ClientRequestIntegersToSum request, StreamObserver<ServerResponseInteger> responseObserver){
        int n = request.getN1();
        int t = request.getN2();

        for(int i = 1; i <= t; i++){
            ServerResponseInteger r = ServerResponseInteger.newBuilder().setRes(n*i).build();
            responseObserver.onNext(r);
        }

        responseObserver.onCompleted();
    }

    @Override
    public StreamObserver<ClientRequestIntegersToSum> streamToStreamSum(StreamObserver<ServerResponseInteger> responseObserver) {
        //il valore di ritorno è lo stream usato dal server per prendere le richieste dal client.
        //l'argomento passato è lo stream usato dal client per prendere le risposte del server.

        //VALORE DI RITORNO: Stream mediante il quale il server legge dal client.
        //ERGO, ci va definito quello che succede quando il server riceve un messaggio sullo stream.
        //ARGOMENTO: stream mediante il quale il client legge dal server.
        //ERGO, il server dovrà scriverci sopra.

        //"it returns the stream that will be used ny the client to send messages. The client will write on this stream"
        return new StreamObserver<ClientRequestIntegersToSum>() {
            //chiamato quando il server riceve qualcosa
            @Override
            public void onNext(ClientRequestIntegersToSum value) {
                int n1 = value.getN1();
                int n2 = value.getN2();

                ServerResponseInteger res = ServerResponseInteger.newBuilder().setRes(n1+n2).build();

                responseObserver.onNext(res);
            }

            @Override
            public void onError(Throwable t) {

            }

            @Override
            public void onCompleted() {

            }
        };
    }

    /*
    rpc oneToOneSum(ClientRequestIntegersToSum) returns (ServerResponseInteger);

    rpc oneToStreamSum(ClientRequestIntegersToSum) returns (stream ServerResponseInteger);

    rpc streamToStreamSum(stream ClientRequestIntegersToSum) returns (stream ServerResponseInteger);
    */

}
