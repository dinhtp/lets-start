#!/bin/bash

# shellcheck disable=SC2129
# shellcheck disable=SC2162
# shellcheck disable=SC2086
# shellcheck disable=SC2016
# shellcheck disable=SC1090

read -p "Git02 Username:" gitUsername
until [[ -n $gitUsername ]]; do read -p "Git02 Username:" gitUsername; done

read -p "Git02 Email:" gitEmail
until [[ -n $gitEmail ]]; do read -p "Git02 Email:" gitEmail; done

echo "--- Configure Git02 Globally"
git config --global user.name $gitUsername
git config --global user.email $gitEmail
git config --global push.default current
git config --global url."https://git02.smartosc.com/production".insteadOf git@git02.smartosc.com:production

echo "--- Install Golang (VersionID=5646;VersionNo=1.16;Channel=Stable)"
snap install go --channel="1.16/stable" --classic
go version

echo "--- Setup project directory"
export PROJECT_DIR=$HOME/Projects
export GO_DIR=$PROJECT_DIR/go
export HOSTNAME=git02.smartosc.com
export CODEBASE=$GO_DIR/src/$HOSTNAME/production
mkdir "$PROJECT_DIR"
mkdir "$GO_DIR"
mkdir "$GO_DIR"/src
mkdir "$GO_DIR"/src/$HOSTNAME
mkdir "$CODEBASE"

echo "--- Append environment variables to current user profile"
cp "$HOME"/.profile "$HOME"/profile_bak

echo '' >> "$HOME"/.profile
echo '# Go environment variables' >> "$HOME"/.profile
echo 'export GOROOT=/snap/go/current' >> "$HOME"/.profile
echo 'export GOPATH=$HOME/Projects/go' >> "$HOME"/.profile
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> "$HOME"/.profile
source "$HOME"/.profile

echo "--- Set Go environment variable"
go env -w GO111MODULE=""
go env -w GONOSUMDB="git02.smartosc.com/production/*"
go env -w GOROOT=/snap/go/current
go env -w GOPATH="$HOME"/Projects/go
go env -w GOBIN="$HOME"/Projects/go/bin
go env

echo "--- Install gRPC"
go get -u google.golang.org/grpc

echo "--- Install Protocol Buffers v3.15.6"
cp ./grpc/protoc-3.15.6-linux-x86_64/bin/protoc "$GO_DIR"/bin/protoc
sudo ln -s "$GO_DIR"/bin/protoc /usr/local/bin/protoc
sudo cp -r ./grpc/protoc-3.15.6-linux-x86_64/include /usr/local/include

echo "--- Install protoc-gen-go"
go get -u google.golang.org/protobuf/cmd/protoc-gen-go
sudo ln -s $GO_DIR/bin/protoc-gen-go /usr/local/bin/protoc-gen-go

echo "--- Install protoc-gen-gogo"
go get -u github.com/gogo/protobuf/protoc-gen-gogo
sudo ln -s $GO_DIR/bin/protoc-gen-gogo /usr/local/bin/protoc-gen-gogo

echo "--- Install protoc-gen-go-grpc"
go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
sudo ln -s "$GO_DIR"/bin/protoc-gen-go-grpc /usr/local/bin/protoc-gen-go-grpc

echo "--- Install protoc-gen-govalidators"
go get -u github.com/mwitkow/go-proto-validators/protoc-gen-govalidators
sudo ln -s "$GO_DIR"/bin/protoc-gen-govalidators /usr/local/bin/protoc-gen-govalidators

echo "--- Install protoc-gen-grpc-gateway"
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
sudo ln -s "$GO_DIR"/bin/protoc-gen-grpc-gateway /usr/local/bin/protoc-gen-grpc-gateway

echo "--- Install protoc-gen-swagger"
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
sudo ln -s "$GO_DIR"/bin/protoc-gen-swagger /usr/local/bin/protoc-gen-swagger

echo "--- All Protoc Plugins Installed"
echo "--- Include protoc/include/google to /usr/local/include/google "

echo "================================================"
echo "Environment Setup Completed!"
echo "================================================"
