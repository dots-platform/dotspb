PROTOS_DIR = protos
PROTOS = $(wildcard $(PROTOS_DIR)/*.proto)
GO_DIR = go
GO_PKG = ./dotspb
RUST_DIR = rust
RUST_PROTOGEN_DIR = rust-protogen

.PHONY: all
all: protogen-go protogen-rust

.PHONY: protogen-go
protogen-go:
	protoc \
		--proto_path=$(PROTOS_DIR) \
		--go_out=$(GO_DIR) \
		--go-grpc_out=$(GO_DIR) \
		$(patsubst $(PROTOS_DIR)/%,--go_opt=M%=$(GO_PKG),$(PROTOS)) \
		$(patsubst $(PROTOS_DIR)/%,--go-grpc_opt=M%=$(GO_PKG),$(PROTOS)) \
		$(patsubst $(PROTOS_DIR)/%,%,$(PROTOS))

.PHONY: protogen-rust
protogen-rust:
	cd $(RUST_PROTOGEN_DIR) && cargo run
	cd $(RUST_DIR) && cargo build
