FROM alpine:3.7

ENV \
  HELM_VERSION=2.13.0 \
  KUBECTL_VERSION=1.13.3 \
  TERRAFORM_VERSION=0.11.11

RUN \
  apk add \
    --no-cache \
    --no-progress \
    bash \
    build-base \
    ca-certificates \
    coreutils \
    curl \
    findutils \
    git \
    grep \
    jq \
    python3 \
    util-linux \
  && rm -rf /var/cache/apk/*
  && pip3 install --upgrade pip \
  && curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xzC /usr/local/bin --strip-components 1 linux-amd64/helm \
  && curl -sL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip | unzip -d /usr/local/bin - \
  && chmod +x /usr/local/bin/*

