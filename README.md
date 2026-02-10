# service-user-proto

Protobuf definitions and gRPC contracts for the User Service.

## Directory Structure

- `proto/`: Contains the source `.proto` files defining the service API and messages.
- `gen/`: Contains the generated code from the proto definitions.
  - `go/`: Generated Go code.

## Services Overview

This repository defines the following gRPC services:

### 1. AuthService (`auth.proto`)

Handles authentication and token management.

- **Auth**: Authenticates a user and returns access and refresh tokens.
- **GoogleOAuth**: Initiates OAuth flow with Google.
- **HandleGoogleOAuth**: Handles OAuth callback and returns tokens/user info.
- **RefreshToken**: Refreshes the access token using a valid refresh token.
- **ValidateToken**: Validates an access token and returns user claims.
- **RevokeToken**: Revokes access/refresh tokens.
- **VerifyPin**: Verifies a user's PIN for sensitive actions.

### 2. UserService (`user.proto`)

Manages user accounts and profiles.

- **List/Get**: Retrieves user information.
- **Add/Update/Delete**: CRUD operations for user accounts.
- **GetProfile/UpdateProfile**: Manages detailed user profiles including bio and avatar.
- **UpdatePin**: Updates the user's secure PIN.
- **ListDevice/RevokeDevice**: Manages user devices (also see `DeviceService`).

### 3. DeviceService (`device.proto`)

Dedicated service for managing user devices.

- **List**: Lists devices with filtering and pagination.
- **Get**: Retrieves details of a specific device.
- **Delete**: Removes a device record.

### 4. UserFileService (`user_file.proto`)

Manages files associated with users (e.g., uploaded documents, images).

- **List/Get**: Retrieves file metadata.
- **Add/Update/Delete**: CRUD operations for user files.

### Common Definitions (`common.proto`)

Contains shared message definitions used across multiple services:

- **Pagination**: Standard pagination request parameters (page, limit, sort).
- **Meta**: Pagination response metadata (total items, total pages).
- **Success**: A simple success boolean response.

## Installation

### 1. Install Protocol Buffers compiler

**For Ubuntu/Debian:**

```bash
sudo apt-get install protobuf-compiler
```

**For macOS:**

```bash
brew install protobuf
```

### 2. Install Go plugins

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1
```

## Usage

To generate the Go code from the proto definitions, run the following command from the root of the repository:

```bash
make go
```

This command will:

1. Create the `gen/go` directory if it doesn't exist.
2. Compile all `.proto` files in the `proto/` directory.
3. Output the generated Go code into `gen/go`, preserving the package structure defined by `go_package`.
