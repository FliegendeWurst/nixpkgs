GrpcCMakeFlags() {
  cmakeFlagsArray+=(
    "-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=@protobuf_build@/bin/protoc"
    "-D_gRPC_CPP_PLUGIN=@grpc_build@/bin/grpc_cpp_plugin"
  )
}

preConfigureHooks+=(GrpcCMakeFlags)