# START: begin
CONFIG_PATH=${HOME}/.proglog/

all: init gencert

init:
	@echo "Creating directory..."
	mkdir -p ${CONFIG_PATH}
	@echo "Directory created."

gencert:
	@echo "Generating Certificate"
	
	cfssl gencert -initca test/ca-csr.json | cfssljson -bare ca
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=test/ca-config.json -profile=server test/server-csr.json | cfssljson -bare server
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=test/ca-config.json -profile=client test/client-csr.json | cfssljson -bare client
	mv *.pem *.csr ${HOME}/.proglog/

	@echo "Certificate generated"

test:
	go test -race ./...

compile:
	protoc api/v1/*.proto \
		--go_out=. \
		--go-grpc_out=. \
		--go_opt=paths=source_relative \
		--go-grpc_opt=paths=source_relative \
		--proto_path=.