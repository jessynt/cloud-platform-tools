FROM alpine:3.7

ENV \
  CLOUD_SDK_VERSION=239.0.0 \
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
    openssl \
    openssl-dev \
    python3 \
  && rm -rf /var/cache/apk/* \
  && pip3 install --upgrade pip \
  && curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xzf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xzC /usr/local/bin --strip-components 1 linux-amd64/helm \
  && curl -sL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip | unzip -d /usr/local/bin - \
  && git clone https://github.com/AGWA/git-crypt.git \
  && cd git-crypt && make && make install && cd - && rm -rf git-crypt \
  && chmod +x /usr/local/bin/*

COPY scripts/setup-kube-auth /usr/local/bin/setup-kube-auth
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

ENTRYPOINT ["/usr/local/bin/setup-kube-auth"]
