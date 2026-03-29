"""Auth service proto definitions."""

from service_user_proto.auth import auth_pb2
from service_user_proto.auth import auth_pb2_grpc

__all__ = [
    'auth_pb2',
    'auth_pb2_grpc',
]
