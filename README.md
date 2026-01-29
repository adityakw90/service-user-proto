# service-user-proto

Protobuf definitions and gRPC contracts for the User Service.

## Installation

1. Install Protocol Buffers compiler:

```bash
# For Ubuntu/Debian
sudo apt-get install protobuf-compiler

# For macOS
brew install protobuf
```

2. Install Go plugins:

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```
