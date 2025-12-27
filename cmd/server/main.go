package main

import (
	"fmt"
	"log"
	"net"

	"github.com/AndreiShkolnyi/go-chat/pkg/chat_v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

const grpcPort = 50051

type server struct {
	chat_v1.UnimplementedChatV1Server
}

// func (s *server) Get(ctx context.Context, req *chat_v1.GetRequest) (*chat_v1.GetResponse, error) {
// 	log.Printf("Note id: #{req.GetId()}")

// 	return &note_v1.GetResponse{
// 		Note: &note_v1.Note{
// 			Id: req.GetId(),
// 			Info: &note_v1.NoteInfo{
// 				Title:    gofakeit.BeerName(),
// 				Content:  gofakeit.IPv4Address(),
// 				Author:   gofakeit.Name(),
// 				IsPublic: gofakeit.Bool(),
// 			},
// 			CreatedAt: timestamppb.New(gofakeit.Date()),
// 			UpdatedAt: timestamppb.New(gofakeit.Date()),
// 		},
// 	}, nil
// }

func main() {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%v", grpcPort))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	reflection.Register(s)
	chat_v1.RegisterChatV1Server(s, &server{})
	log.Println("server listening at #{lis.Addr()}")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
