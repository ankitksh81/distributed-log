#!/bin/bash

# This file contains various protoc compiler commands for
# Protocol buffer and grpc.

# Command for compiling from basic log.proto file
protoc api/v1/*.proto --go_out=. --go_opt=paths=source_relative --proto_path=.

# Command for compiling from log.proto file with grcp
protoc api/v1/*.proto --go_out=. --go-grpc_out=. --go_opt=paths=source_relative --go-grpc_opt=paths=source_relative --proto_path=.