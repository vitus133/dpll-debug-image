FROM registry.ci.openshift.org/ocp/builder:rhel-9-golang-1.20-openshift-4.14 AS builder
RUN git clone https://github.com/vitus133/go-dpll.git
WORKDIR /go/src/github.com/openshift/origin/go-dpll
RUN make build

FROM registry.redhat.io/rhel9/support-tools:latest
WORKDIR /
USER root
RUN dnf install -y git python3 python3-pip && \
    git clone --depth=1 https://github.com/torvalds/linux.git && \
    pip install -r /linux/tools/net/ynl/requirements.txt && \
    dnf remove -y git
COPY --from=builder /go/src/github.com/openshift/origin/go-dpll/dpll-cli /usr/local/bin/
WORKDIR /linux/tools/net/ynl

# Uncomment this line if you want cli to block while waiting on netlink notifications
RUN sed -i 's/, socket.MSG_DONTWAIT//g' lib/ynl.py 

