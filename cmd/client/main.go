package main

import (
	"context"
	"log"
	"time"

	"github.com/AndreiShkolnyi/go-chat/pkg/chat_v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

const (
	address = "localhost:50051"
)

func main() {
	conn, err := grpc.Dial(address, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect to server: %v", err)
	}
	defer conn.Close()

	c := chat_v1.NewChatV1Client(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	r, err := c.Create(ctx, &chat_v1.CreateRequest{Usernames: []string{"Andrei", "Shkolnyi"}})
	if err != nil {
		log.Fatalf("failed to get chat: %v", err)
	}
	log.Printf("Chat: %v", r.GetId())

}
