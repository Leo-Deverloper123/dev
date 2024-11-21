FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o server

FROM alpine:3.18
RUN addgroup -g 2000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser
WORKDIR /app
COPY --from=builder /app/server .
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 8080
CMD ["./server"]