FROM golang AS build

RUN echo "nobody:x:65534:65534:Nobody:/:" > /etc_passwd
WORKDIR /go/src/github.com/nrmitchi/k8s-controller-sidecars

COPY *.go /go/src/github.com/nrmitchi/k8s-controller-sidecars/
RUN go get -v

RUN CGO_ENABLED=0 go build -o /bin/k8s-controller-sidecars .


FROM scratch

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=0 /etc_passwd /etc/passwd

COPY --from=build /bin/k8s-controller-sidecars /bin/k8s-controller-sidecars

USER nobody

ENTRYPOINT ["/bin/k8s-controller-sidecars"]
