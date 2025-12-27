LOCAL_BIN:=$(CURDIR)/bin

install-golangci-lint:
	GOBIN=$(LOCAL_BIN) go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.61.0

lint:
	$(LOCAL_BIN)/golangci-lint run ./... --config .golangci.pipeline.yaml

install-deps:
	GOBIN=$(LOCAL_BIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
	GOBIN=$(LOCAL_BIN) go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2.0
	COBIN=$(LOCAL_BIN) go install github.com/pressly/goose/v3/cmd/goose@v3.14.0

get-deps:
	go get -u google.golang.org/protobuf/cmd/protoc-gen-go
	go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
	go get -u google.golang.org/grpc/status
	go get -u google.golang.org/grpc/codes
	go get -u google.golang.org/grpc


generate:
	make generate-chat-api

generate-chat-api:
	mkdir -p pkg/chat_v1
	protoc --proto_path api/chat_v1 \
	--go_out=pkg/chat_v1 --go_opt=paths=source_relative \
	--plugin=protoc-gen-go=bin/protoc-gen-go \
	--go-grpc_out=pkg/chat_v1 --go-grpc_opt=paths=source_relative \
	--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
	api/chat_v1/chat.proto


build:
	GOOS=linux GOARCH=amd64 go build -o crud_server cmd/server/main.go

# docker-build-and-push:
# 	docker buildx build --no-cache --platform linux/amd64 -t cr.selcloud.ru/andrei-shkolnyi/test-server:v0.0.1 .
# 	docker login -u token -p CRgAAAAA420oRwcm8D8cGzw48DFLSK7Ps46ldKf5 cr.selcloud.ru/andrei-shkolnyi
# 	docker push cr.selcloud.ru/andrei-shkolnyi/test-server:v0.0.1

docker-build-and-push:
	docker login cr.selcloud.ru -u token --password-stdin <<< "CRgAAAAA420oRwcm8D8cGzw48DFLSK7Ps46ldKf5"
	docker buildx build \
		--no-cache \
		--platform linux/amd64 \
		-t cr.selcloud.ru/andrei-shkolnyi/chat_server:v0.0.1 \
		--push .

copy-to-server:
	scp crud_server root@87.228.83.168:

local-migration-status:
	goose -dir ${LOCAL_MIGRATION_DIR} postgres ${LOCAL_MIGRATION_DSN} status -v

local-migration-up:
	goose -dir ${LOCAL_MIGRATION_DIR} postgres ${LOCAL_MIGRATION_DSN} up -v

local-migration-down:
	goose -dir ${LOCAL_MIGRATION_DIR} postgres ${LOCAL_MIGRATION_DSN} down -v