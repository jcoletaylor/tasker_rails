FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && apt-get install -y software-properties-common \
    && apt-get install -y ruby2.7 ruby2.7-dev \
    && apt-get install -y curl \
    && apt-get install -y build-essential \
    && rm -rf /var/lib/apt/lists/*
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
WORKDIR /source
