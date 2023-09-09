PROTOS_DIR = protos
PROTOS = $(wildcard $(PROTOS_DIR)/*.proto)
GO_DIR = go
GO_PACKAGE = github.com/dots-platform/dotspb/go/dotspb
GO_PACKAGE_NAME = dotspb
RUST_DIR = rust
RUST_PROTOGEN_DIR = rust-protogen

.PHONY: all
all: protogen-go protogen-rust

.PHONY: protogen-go
protogen-go:
	rm -rf $(GO_DIR)/gen
	mkdir -p $(GO_DIR)/gen
	protoc \
		--proto_path=$(PROTOS_DIR) \
		--go_out=$(GO_DIR)/gen \
		--go-grpc_out=$(GO_DIR)/gen \
		$(PROTOS)
	@if find $(GO_DIR)/gen -type f -not -path '$(GO_DIR)/gen/$(GO_PACKAGE)/*' | grep ''; then \
		echo 'Found generated stubs outside of $(GO_DIR)/gen/$(GO_PACKAGE)! Please ensure that all protos are defined with go_package within $(GO_PACKAGE).' \
		; exit 1 \
	; fi
	find $(GO_DIR)/$(GO_PACKAGE_NAME) -type f -name '*.pb.go' -print0 | xargs -0 rm -f
	mv $(GO_DIR)/gen/$(GO_PACKAGE)/* $(GO_DIR)/$(GO_PACKAGE_NAME)
	rm -rf $(GO_DIR)/gen

.PHONY: protogen-rust
protogen-rust:
	cd $(RUST_PROTOGEN_DIR) && cargo run
	cd $(RUST_DIR) && cargo build
