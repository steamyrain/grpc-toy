package main

import (
	"log"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	pb "github.com/steamyrain/grpc-toy/cmd/proto"
)

var addr = "0.0.0.0:4000"

func main() {
  conn, err := grpc.Dial(addr, grpc.WithTransportCredentials(insecure.NewCredentials()))

  if err!=nil {
    log.Fatalf("Unable to dial %s, err: %v", addr, err)
  }

  defer conn.Close()

  c := pb.NewGreetServiceClient(conn)

  doGreet(c)
}
