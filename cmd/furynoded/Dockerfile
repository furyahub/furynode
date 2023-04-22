#
# Build: Cosmovisor
#
FROM golang:1.18 AS cosmovisor

ENV GOBIN=/go/bin
ENV GOPATH=/go
ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

#
# Build: Furynode
#
FROM golang:1.18 AS furynode

ARG chainnet

ENV GOBIN=/go/bin
ENV GOPATH=/go
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV CHAINNET=$chainnet

WORKDIR /furynet
COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CHAINNET=$CHAINNET make install

#
# Main
#
FROM alpine

ENV PACKAGES curl jq bind-tools expect

EXPOSE 1317
EXPOSE 26656
EXPOSE 26657

RUN apk add --update --no-cache $PACKAGES

# Copy the compiled binaires over.
COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=furynode /go/bin/furynoded /usr/bin/furynoded
COPY --from=furynode /go/bin/furygen /usr/bin/furygen
