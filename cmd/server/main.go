package main

import (
	"log"
	"net"

	pb "github.com/steamyrain/grpc-toy/cmd/proto"
	"google.golang.org/grpc"
)

const addr = "0.0.0.0:4000"

type Server struct {
  pb.GreetServiceServer
}

func main() {
  lis, err := net.Listen("tcp4", addr)

  if err != nil {
    log.Fatalf("Error listening at %s, error: %v\n", addr, err)
  }

  log.Printf("Listening at %s\n", addr)

  s := grpc.NewServer()
  pb.RegisterGreetServiceServer(s, &Server{})

  if err = s.Serve(lis); err != nil {
    log.Fatalf("Failed to serve: %v\n", err)
  }
}
