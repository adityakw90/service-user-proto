.PHONY: go clean deps

# Generate Go code for all proto files
go:
	mkdir -p gen/go
	protoc --go_out=. --go_opt=module=github.com/adityakw90/service-user-proto \
		--go-grpc_out=. --go-grpc_opt=module=github.com/adityakw90/service-user-proto proto/*.proto

clean:
	rm -rf gen
