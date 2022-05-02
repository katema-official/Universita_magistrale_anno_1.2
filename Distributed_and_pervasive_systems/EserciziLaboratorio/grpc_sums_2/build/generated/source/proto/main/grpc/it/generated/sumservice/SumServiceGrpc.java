package it.generated.sumservice;

import static io.grpc.MethodDescriptor.generateFullMethodName;
import static io.grpc.stub.ClientCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ClientCalls.asyncClientStreamingCall;
import static io.grpc.stub.ClientCalls.asyncServerStreamingCall;
import static io.grpc.stub.ClientCalls.asyncUnaryCall;
import static io.grpc.stub.ClientCalls.blockingServerStreamingCall;
import static io.grpc.stub.ClientCalls.blockingUnaryCall;
import static io.grpc.stub.ClientCalls.futureUnaryCall;
import static io.grpc.stub.ServerCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ServerCalls.asyncClientStreamingCall;
import static io.grpc.stub.ServerCalls.asyncServerStreamingCall;
import static io.grpc.stub.ServerCalls.asyncUnaryCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedStreamingCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall;

/**
 */
@javax.annotation.Generated(
    value = "by gRPC proto compiler (version 1.25.0)",
    comments = "Source: SumService.proto")
public final class SumServiceGrpc {

  private SumServiceGrpc() {}

  public static final String SERVICE_NAME = "it.generated.sumservice.SumService";

  // Static method descriptors that strictly reflect the proto.
  private static volatile io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
      it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getOneToOneSumMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "oneToOneSum",
      requestType = it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum.class,
      responseType = it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
      it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getOneToOneSumMethod() {
    io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum, it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getOneToOneSumMethod;
    if ((getOneToOneSumMethod = SumServiceGrpc.getOneToOneSumMethod) == null) {
      synchronized (SumServiceGrpc.class) {
        if ((getOneToOneSumMethod = SumServiceGrpc.getOneToOneSumMethod) == null) {
          SumServiceGrpc.getOneToOneSumMethod = getOneToOneSumMethod =
              io.grpc.MethodDescriptor.<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum, it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "oneToOneSum"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger.getDefaultInstance()))
              .setSchemaDescriptor(new SumServiceMethodDescriptorSupplier("oneToOneSum"))
              .build();
        }
      }
    }
    return getOneToOneSumMethod;
  }

  private static volatile io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
      it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getOneToStreamSumMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "oneToStreamSum",
      requestType = it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum.class,
      responseType = it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger.class,
      methodType = io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
  public static io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
      it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getOneToStreamSumMethod() {
    io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum, it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getOneToStreamSumMethod;
    if ((getOneToStreamSumMethod = SumServiceGrpc.getOneToStreamSumMethod) == null) {
      synchronized (SumServiceGrpc.class) {
        if ((getOneToStreamSumMethod = SumServiceGrpc.getOneToStreamSumMethod) == null) {
          SumServiceGrpc.getOneToStreamSumMethod = getOneToStreamSumMethod =
              io.grpc.MethodDescriptor.<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum, it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.SERVER_STREAMING)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "oneToStreamSum"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger.getDefaultInstance()))
              .setSchemaDescriptor(new SumServiceMethodDescriptorSupplier("oneToStreamSum"))
              .build();
        }
      }
    }
    return getOneToStreamSumMethod;
  }

  private static volatile io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
      it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getStreamToStreamSumMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "streamToStreamSum",
      requestType = it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum.class,
      responseType = it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger.class,
      methodType = io.grpc.MethodDescriptor.MethodType.BIDI_STREAMING)
  public static io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
      it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getStreamToStreamSumMethod() {
    io.grpc.MethodDescriptor<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum, it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> getStreamToStreamSumMethod;
    if ((getStreamToStreamSumMethod = SumServiceGrpc.getStreamToStreamSumMethod) == null) {
      synchronized (SumServiceGrpc.class) {
        if ((getStreamToStreamSumMethod = SumServiceGrpc.getStreamToStreamSumMethod) == null) {
          SumServiceGrpc.getStreamToStreamSumMethod = getStreamToStreamSumMethod =
              io.grpc.MethodDescriptor.<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum, it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.BIDI_STREAMING)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "streamToStreamSum"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger.getDefaultInstance()))
              .setSchemaDescriptor(new SumServiceMethodDescriptorSupplier("streamToStreamSum"))
              .build();
        }
      }
    }
    return getStreamToStreamSumMethod;
  }

  /**
   * Creates a new async stub that supports all call types for the service
   */
  public static SumServiceStub newStub(io.grpc.Channel channel) {
    return new SumServiceStub(channel);
  }

  /**
   * Creates a new blocking-style stub that supports unary and streaming output calls on the service
   */
  public static SumServiceBlockingStub newBlockingStub(
      io.grpc.Channel channel) {
    return new SumServiceBlockingStub(channel);
  }

  /**
   * Creates a new ListenableFuture-style stub that supports unary calls on the service
   */
  public static SumServiceFutureStub newFutureStub(
      io.grpc.Channel channel) {
    return new SumServiceFutureStub(channel);
  }

  /**
   */
  public static abstract class SumServiceImplBase implements io.grpc.BindableService {

    /**
     */
    public void oneToOneSum(it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum request,
        io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> responseObserver) {
      asyncUnimplementedUnaryCall(getOneToOneSumMethod(), responseObserver);
    }

    /**
     */
    public void oneToStreamSum(it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum request,
        io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> responseObserver) {
      asyncUnimplementedUnaryCall(getOneToStreamSumMethod(), responseObserver);
    }

    /**
     */
    public io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum> streamToStreamSum(
        io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> responseObserver) {
      return asyncUnimplementedStreamingCall(getStreamToStreamSumMethod(), responseObserver);
    }

    @java.lang.Override public final io.grpc.ServerServiceDefinition bindService() {
      return io.grpc.ServerServiceDefinition.builder(getServiceDescriptor())
          .addMethod(
            getOneToOneSumMethod(),
            asyncUnaryCall(
              new MethodHandlers<
                it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
                it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>(
                  this, METHODID_ONE_TO_ONE_SUM)))
          .addMethod(
            getOneToStreamSumMethod(),
            asyncServerStreamingCall(
              new MethodHandlers<
                it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
                it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>(
                  this, METHODID_ONE_TO_STREAM_SUM)))
          .addMethod(
            getStreamToStreamSumMethod(),
            asyncBidiStreamingCall(
              new MethodHandlers<
                it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum,
                it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>(
                  this, METHODID_STREAM_TO_STREAM_SUM)))
          .build();
    }
  }

  /**
   */
  public static final class SumServiceStub extends io.grpc.stub.AbstractStub<SumServiceStub> {
    private SumServiceStub(io.grpc.Channel channel) {
      super(channel);
    }

    private SumServiceStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected SumServiceStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new SumServiceStub(channel, callOptions);
    }

    /**
     */
    public void oneToOneSum(it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum request,
        io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(getOneToOneSumMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     */
    public void oneToStreamSum(it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum request,
        io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> responseObserver) {
      asyncServerStreamingCall(
          getChannel().newCall(getOneToStreamSumMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     */
    public io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum> streamToStreamSum(
        io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> responseObserver) {
      return asyncBidiStreamingCall(
          getChannel().newCall(getStreamToStreamSumMethod(), getCallOptions()), responseObserver);
    }
  }

  /**
   */
  public static final class SumServiceBlockingStub extends io.grpc.stub.AbstractStub<SumServiceBlockingStub> {
    private SumServiceBlockingStub(io.grpc.Channel channel) {
      super(channel);
    }

    private SumServiceBlockingStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected SumServiceBlockingStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new SumServiceBlockingStub(channel, callOptions);
    }

    /**
     */
    public it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger oneToOneSum(it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum request) {
      return blockingUnaryCall(
          getChannel(), getOneToOneSumMethod(), getCallOptions(), request);
    }

    /**
     */
    public java.util.Iterator<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> oneToStreamSum(
        it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum request) {
      return blockingServerStreamingCall(
          getChannel(), getOneToStreamSumMethod(), getCallOptions(), request);
    }
  }

  /**
   */
  public static final class SumServiceFutureStub extends io.grpc.stub.AbstractStub<SumServiceFutureStub> {
    private SumServiceFutureStub(io.grpc.Channel channel) {
      super(channel);
    }

    private SumServiceFutureStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected SumServiceFutureStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new SumServiceFutureStub(channel, callOptions);
    }

    /**
     */
    public com.google.common.util.concurrent.ListenableFuture<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger> oneToOneSum(
        it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum request) {
      return futureUnaryCall(
          getChannel().newCall(getOneToOneSumMethod(), getCallOptions()), request);
    }
  }

  private static final int METHODID_ONE_TO_ONE_SUM = 0;
  private static final int METHODID_ONE_TO_STREAM_SUM = 1;
  private static final int METHODID_STREAM_TO_STREAM_SUM = 2;

  private static final class MethodHandlers<Req, Resp> implements
      io.grpc.stub.ServerCalls.UnaryMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ServerStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ClientStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.BidiStreamingMethod<Req, Resp> {
    private final SumServiceImplBase serviceImpl;
    private final int methodId;

    MethodHandlers(SumServiceImplBase serviceImpl, int methodId) {
      this.serviceImpl = serviceImpl;
      this.methodId = methodId;
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public void invoke(Req request, io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_ONE_TO_ONE_SUM:
          serviceImpl.oneToOneSum((it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum) request,
              (io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>) responseObserver);
          break;
        case METHODID_ONE_TO_STREAM_SUM:
          serviceImpl.oneToStreamSum((it.generated.sumservice.SumServiceOuterClass.ClientRequestIntegersToSum) request,
              (io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>) responseObserver);
          break;
        default:
          throw new AssertionError();
      }
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public io.grpc.stub.StreamObserver<Req> invoke(
        io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_STREAM_TO_STREAM_SUM:
          return (io.grpc.stub.StreamObserver<Req>) serviceImpl.streamToStreamSum(
              (io.grpc.stub.StreamObserver<it.generated.sumservice.SumServiceOuterClass.ServerResponseInteger>) responseObserver);
        default:
          throw new AssertionError();
      }
    }
  }

  private static abstract class SumServiceBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoFileDescriptorSupplier, io.grpc.protobuf.ProtoServiceDescriptorSupplier {
    SumServiceBaseDescriptorSupplier() {}

    @java.lang.Override
    public com.google.protobuf.Descriptors.FileDescriptor getFileDescriptor() {
      return it.generated.sumservice.SumServiceOuterClass.getDescriptor();
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.ServiceDescriptor getServiceDescriptor() {
      return getFileDescriptor().findServiceByName("SumService");
    }
  }

  private static final class SumServiceFileDescriptorSupplier
      extends SumServiceBaseDescriptorSupplier {
    SumServiceFileDescriptorSupplier() {}
  }

  private static final class SumServiceMethodDescriptorSupplier
      extends SumServiceBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoMethodDescriptorSupplier {
    private final String methodName;

    SumServiceMethodDescriptorSupplier(String methodName) {
      this.methodName = methodName;
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.MethodDescriptor getMethodDescriptor() {
      return getServiceDescriptor().findMethodByName(methodName);
    }
  }

  private static volatile io.grpc.ServiceDescriptor serviceDescriptor;

  public static io.grpc.ServiceDescriptor getServiceDescriptor() {
    io.grpc.ServiceDescriptor result = serviceDescriptor;
    if (result == null) {
      synchronized (SumServiceGrpc.class) {
        result = serviceDescriptor;
        if (result == null) {
          serviceDescriptor = result = io.grpc.ServiceDescriptor.newBuilder(SERVICE_NAME)
              .setSchemaDescriptor(new SumServiceFileDescriptorSupplier())
              .addMethod(getOneToOneSumMethod())
              .addMethod(getOneToStreamSumMethod())
              .addMethod(getStreamToStreamSumMethod())
              .build();
        }
      }
    }
    return result;
  }
}
