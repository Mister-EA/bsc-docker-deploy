# Start from the Go base image
FROM golang:1.19-alpine

RUN apk add --no-cache make cmake gcc musl-dev linux-headers git bash build-base libc-dev

RUN mkdir -p /app/bin 

# Beacon Chain
COPY ./node /node
WORKDIR /node
RUN make build
RUN cp ./build/tbnbcli /app/bin/tbnbcli
RUN cp ./build/bnbchaind /app/bin/bnbchaind


ADD ./bsc /bsc
ENV CGO_CFLAGS="-O -D__BLST_PORTABLE__" 
ENV CGO_CFLAGS_ALLOW="-O -D__BLST_PORTABLE__"

# Now copy over the entire bsc. 
# Please keep in mind, Docker will need to re-run the steps from here every time any file changes inside the ./bsc directory
COPY ./bsc /bsc

# Now move into the bsc folder
WORKDIR /bsc

# Run make geth
RUN make geth

# Build the app
RUN go build -o ./build/bin/bootnode ./cmd/bootnode

# Copy the binary to a stable location
RUN cp ./build/bin/geth /app/bin/geth \
  && cp ./build/bin/bootnode /app/bin/bootnode




WORKDIR /app

COPY ./bsc-genesis-contract/genesis.json .
COPY ./config.toml  .

RUN mkdir bls
RUN mkdir keystore

RUN apk add --no-cache jq

EXPOSE 8545 6060 30311 30311/udp

# init genesis
RUN bin/geth init --datadir . genesis.json
RUN rm -f geth/nodekey

ENV AUTHORITY_NAME "alice"

RUN echo ${AUTHORITY_NAME}

# Run validator

COPY ./docker_entrypoint.sh .
RUN chmod +x /app/docker_entrypoint.sh

ENTRYPOINT ["/app/docker_entrypoint.sh"]








