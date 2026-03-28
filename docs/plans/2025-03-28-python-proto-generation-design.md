# Python Proto Generation Support Design

**Date:** 2025-03-28
**Status:** Approved
**Author:** Claude

## Overview

Add Python code generation alongside the existing Go generation, using the standard `google.protobuf` approach with `grpcio-tools`. The design follows the existing pattern with `make py` generating Python code to `gen/python/`.

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Package name | `service_user_proto` | Matches Go module naming style |
| Python version | 3.11+ | Modern type hints, cleaner syntax |
| Protocol library | `google.protobuf` (standard) | Widely supported, well-maintained |
| Location | `gen/python/` | Alongside `gen/go/` for consistency |
| Deps management | `pyproject.toml` | Modern Python standard |
| Consumers | Multiple (services + clients) | Supports both use cases |

## Architecture

```
proto/
  user/
    ├── auth.proto
    ├── common.proto
    ├── device.proto
    ├── user.proto
    └── user_file.proto

gen/
  ├── go/                    # (existing)
  └── python/                # (new)
      └── service_user_proto/
          ├── __init__.py
          ├── user/
          │   ├── __init__.py
          │   ├── auth_pb2.py
          │   ├── auth_pb2_grpc.py
          │   ├── common_pb2.py
          │   └── ...
          └── py.typed        # PEP 561 type hints marker
```

## Implementation

### Makefile Changes

```makefile
.PHONY: go py clean deps go-deps py-deps

# Dependencies
deps: go-deps py-deps

go-deps:
	@echo "Installing Go protobuf plugins..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1

py-deps:
	@echo "Python dependencies managed via pip/uv..."
	@echo "Run: pip install -e . (or uv pip install -e .)"

# Individual language generation
go:
	@echo "Generating Go code..."
	@mkdir -p gen/go
	@protoc \
		--proto_path=proto \
		--go_out=. --go_opt=module=github.com/adityakw90/service-user-proto \
		--go-grpc_out=. --go-grpc_opt=module=github.com/adityakw90/service-user-proto \
		proto/**/*.proto

py:
	@echo "Generating Python code..."
	@mkdir -p gen/python/service_user_proto
	@protoc \
		--proto_path=proto \
		--python_out=gen/python \
		--grpc_python_out=gen/python \
		proto/**/*.proto
	@touch gen/python/service_user_proto/__init__.py
	@touch gen/python/service_user_proto/py.typed

# Generate all
all: go py

clean:
	@rm -rf gen
```

### pyproject.toml

```toml
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.build_meta"

[project]
name = "service-user-proto"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "grpcio>=1.60.0",
    "grpcio-tools>=1.60.0",
    "protobuf>=4.25.0",
]

[tool.setuptools.packages.find]
where = ["gen/python"]
```

## Usage Example

```python
# Client usage
import grpc
from service_user_proto.user.auth_pb2 import LoginRequest
from service_user_proto.user.auth_pb2_grpc import AuthServiceStub

channel = grpc.insecure_channel("localhost:50051")
client = AuthServiceStub(channel)
response = client.Login(LoginRequest(email="user@example.com", password="secret"))
```

## Migration Steps

1. Add `pyproject.toml` and update `Makefile`
2. Run `make py` to generate initial Python code
3. Commit both new files and generated code
4. Update README.md with Python usage documentation

## Edge Cases

- **Empty directories**: Handled by `mkdir -p` and `touch __init__.py`
- **Clean target**: Already removes all of `gen/`
- **CI/CD**: Add `pip install -e .` step before `make py`
- **Mixed proto changes**: Regenerate both languages together after any proto change
