PROTOS_DIR = protos
GO_DIR = go/dotspb

.PHONY: all
all: protogen

.PHONY: protogen
protogen:
	protoc \
		--proto_path=$(PROTOS_DIR) \
		--go_out=. \
		--go-grpc_out=. \
		--go_opt=Mdec_exec.proto=$(GO_DIR) \
		--go-grpc_opt=Mdec_exec.proto=$(GO_DIR) \
		dec_exec.proto
