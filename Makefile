GOBIN ?= $(PWD)/bin

bin/protoc-gen-go:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.30.0

test: bin/protoc-gen-go
	@protoc --go_out=. \
		--go_opt=paths=source_relative \
		marshaller/*.proto
	@go build -o ~/go/bin/protoc-gen-json-marshaller main.go
	@protoc --go_out=. \
		--json-marshaller_out=./example \
		--go_opt="paths=source_relative,Mproto-json-marshaller/marshaller/marshaller.proto=/Users/sereger/go/src/github.com/Sereger/proto-json-marshaller/marshaller" \
		--json-marshaller_opt=enums_as_ints=true \
		-I ${GOPATH}/src/github.com/Sereger/proto-json-marshaller/marshaller \
		-I ./example \
		example/test.proto

BUF_VERSION=1.15.1
bin/buf:
ifeq ($(wildcard $(GOBIN)/buf),)
	curl -sSL "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(shell uname -s)-$(shell uname -m)" -o "${GOBIN}/buf"
	chmod +x ${GOBIN}/buf
endif