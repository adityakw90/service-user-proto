.PHONY: go py all clean deps go-deps py-deps

# Dependencies
deps: go-deps py-deps

go-deps:
	@echo "Installing Go protobuf plugins..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1
	@echo "Go dependencies installed successfully."

py-deps:
	@echo "Installing Python protobuf dependencies..."
	@poetry env use 3.12
	@poetry install
	@echo "Python dependencies installed successfully."

# Individual language generation
go:
	@echo "Generating Go code for all proto files..."
	@mkdir -p gen/go
	@protoc \
		--proto_path=proto \
		--go_out=. --go_opt=module=github.com/adityakw90/service-user-proto \
		--go-grpc_out=. --go-grpc_opt=module=github.com/adityakw90/service-user-proto \
		proto/**/*.proto
	@echo "Go code generated successfully."

py:
	@echo "Generating Python code for all proto files..."
	@mkdir -p gen/python/service_user_proto
	@poetry env use 3.12
	@poetry run python -m grpc_tools.protoc \
		--proto_path=proto \
		--python_out=gen/python/service_user_proto \
		--grpc_python_out=gen/python/service_user_proto \
		proto/**/*.proto
	@echo "Fixing Python imports and restructuring..."
	@poetry run python scripts/fix_python_imports.py
	@echo "Python code generated and fixed successfully."

# Generate all
all: go py

clean:
	@echo "Cleaning generated code..."
	@rm -rf gen
	@echo "Cleaned successfully."
