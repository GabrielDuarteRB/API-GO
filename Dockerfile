FROM golang:1.23-alpine AS builder

WORKDIR /src

COPY go.mod ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /out/api .

FROM alpine:3.21

RUN addgroup -S app && adduser -S -G app app

COPY --from=builder /out/api /usr/local/bin/api

USER app

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/api"]
