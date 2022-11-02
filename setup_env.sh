#!/bin/bash

# shellcheck disable=SC2129
# shellcheck disable=SC2162
# shellcheck disable=SC2086
# shellcheck disable=SC2016
# shellcheck disable=SC1090

read -p "Git Username:" gitUsername
until [[ -n $gitUsername ]]; do read -p "Git Username:" gitUsername; done

read -p "Git Email:" gitEmail
until [[ -n $gitEmail ]]; do read -p "Git Email:" gitEmail; done

echo "--- Configure Git Globally"
git config --global user.name $gitUsername
git config --global user.email $gitEmail
git config --global push.default current
git config --global url."https://git02.smartosc.com/production".insteadOf git@git02.smartosc.com:production

echo "--- Install Golang (Version: 1.16)"
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

echo "--- Include protoc/include/google to /usr/local/include/google "
sudo cp -r ./grpc/protoc-3.15.6-linux-x86_64/include /usr/local/include

echo "--- Install protoc-gen-grpc-gateway for Go"
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
sudo ln -s "$GO_DIR"/bin/protoc-gen-grpc-gateway /usr/local/bin/protoc-gen-grpc-gateway

echo "--- Install protoc-gen-swagger for Go"
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
sudo ln -s "$GO_DIR"/bin/protoc-gen-swagger /usr/local/bin/protoc-gen-swagger

echo "--- Install protoc-gen-go plugin for Go"
go get -u google.golang.org/protobuf/cmd/protoc-gen-go
sudo ln -s $GO_DIR/bin/protoc-gen-go /usr/local/bin/protoc-gen-go

echo "--- Install protoc-gen-go-grpc plugin for Go"
go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
sudo ln -s "$GO_DIR"/bin/protoc-gen-go-grpc /usr/local/bin/protoc-gen-go-grpc

echo "--- Install protoc-gen-gogo plugin for Go"
go get -u github.com/gogo/protobuf/protoc-gen-gogo
sudo ln -s "$GO_DIR"/bin/protoc-gen-gogo /usr/local/bin/protoc-gen-gogo

echo "--- Install protoc-gen-govalidators plugin for Go"
go get -u github.com/mwitkow/go-proto-validators/protoc-gen-govalidators
sudo ln -s "$GO_DIR"/bin/protoc-gen-govalidators /usr/local/bin/protoc-gen-govalidators

echo "--- Install Kubernetes"
curl -LO "https://dl.k8s.io/release/v1.23.5/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
mkdir ~/.kube

echo "--- Install AWS IAM authenticator"
sudo apt-get install awscli
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p "$HOME"/bin && cp ./aws-iam-authenticator "$HOME"/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc


echo "---------------------------------------------------------------"
echo "Next steps:"
echo "1. Ask your team leader/product manager to create your new account to access AWS IAM console and receive AWS Access Key ID and AWS Secret Access Key"
echo "2. Type $(aws configure) in the command line interface and set the following information"
echo "    AWS Access Key ID [None]: {Your AWS Access Key ID}"
echo "    AWS Secret Access Key [None]: {Your AWS Secret Access Key}"
echo "    Default region name [None]: eu-north-1"
echo "    Default output format [None]: json"
echo "3. Login to AWS ECR for deployment access by typing $(aws ecr get-login --no-include-email) and copy the result output, then execute the output command"
echo "4. Build each of the services you have access to then start the whole infrastructure to develop!"
echo "---------------------------------------------------------------"

echo "DONE!"
