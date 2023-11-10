# Variables
PROTO_DIR = proto
CLIENT_DIR = client
SERVER_DIR = server
BIN_DIR = bin

# Print message and return false if directory doesn't exist
CHECK_DIR_CMD = test -d $@ || (echo "\033[31mDirectory $@ doesn't exist\033[0m" && false)

# Print go module from go.mod file, see double dollars on makefile documentation
PACKAGE = $(shell head -1 go.mod | awk '{print $$2}')

MODULE = 'module='

# enums ? check this later on makefile documentation
projects := cmd

# Basic makefile structure
# target: prerequisites
#	 recipes
#
#
build: ${projects}

cmd: $@

$(projects):
	@${CHECK_DIR_CMD}
	protoc -I$@/${PROTO_DIR} --go_opt=module=${PACKAGE} --go_out=. \
	--go-grpc_opt=module=${PACKAGE} --go-grpc_out=. $@/${PROTO_DIR}/*.proto
	go build -o ${BIN_DIR}/$@/${SERVER_DIR} ./$@/${SERVER_DIR}
	go build -o ${BIN_DIR}/$@/${CLIENT_DIR} ./$@/${CLIENT_DIR}

clean:
	-rm cmd/${PROTO_DIR}/*.pb.go
	-rm -r ssl/*.crt
	-rm -r ssl/*.csr
	-rm -r ssl/*.key
	-rm -r ssl/*.pem
	-rm -r ${BIN_DIR}

bump: build
	go get -u ./...

# collection of targets that is not a file
.PHONY: build clean bump cmd
