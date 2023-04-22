PROTOS_DIR = protos
PROTOS = $(wildcard $(PROTOS_DIR)/*.proto)
GO_DIR = go
GO_PKG = ./dotspb

.PHONY: all
all: protogen

.PHONY: protogen
protogen:
	protoc \
		--proto_path=$(PROTOS_DIR) \
		--go_out=$(GO_DIR) \
		--go-grpc_out=$(GO_DIR) \
		$(patsubst $(PROTOS_DIR)/%,--go_opt=M%=$(GO_PKG),$(PROTOS)) \
		$(patsubst $(PROTOS_DIR)/%,--go-grpc_opt=M%=$(GO_PKG),$(PROTOS)) \
		$(patsubst $(PROTOS_DIR)/%,%,$(PROTOS))
