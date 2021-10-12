FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu60 \
    libunwind8 \
    netcat \
    libssl1.0 \
    runc \
    php-cli \
    mysql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN curl -LO https://github.com/moby/buildkit/releases/download/v0.9.1/buildkit-v0.9.1.linux-amd64.tar.gz \
  && tar -xf buildkit-v0.9.1.linux-amd64.tar.gz \
  && install bin/buildkitd /usr/local/bin/buildkitd \
  && install bin/buildctl /usr/local/bin/buildctl \
  && rm -rf bin buildkit-v0.9.1.linux-amd64.tar.gz

RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.22.2/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl

RUN curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz \
  && tar -xf helm.tar.gz \
  && install linux-amd64/helm /usr/local/bin/ \
  && rm -f helm.tar.gz \
  && rm -rf linux-amd64

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.185.1

WORKDIR /azp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]
