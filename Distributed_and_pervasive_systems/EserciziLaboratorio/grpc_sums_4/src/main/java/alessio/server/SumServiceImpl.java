package alessio.server;

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

    }
/*
    rpc oneToOneSum(ClientRequestIntegersToSum) returns (ServerResponseInteger);

    rpc oneToStreamSum(ClientRequestIntegersToSum) returns (stream ServerResponseInteger);

    rpc streamToStreamSum(stream ClientRequestIntegersToSum) returns (stream ServerResponseInteger);
    */

}
