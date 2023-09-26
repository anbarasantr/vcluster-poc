#!/bin/bash

set -euo pipefail

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Kind if not already installed
if ! command -v kind &> /dev/null
then
    brew install kind
fi

# Create a Kind cluster
if ! kind create cluster --name atlan-host-cluster --config kind-config.yaml
then
    echo "Failed to create Kind cluster"
    exit 1
fi

# Wait for the Kind cluster to be up
while ! kubectl cluster-info &> /dev/null
do
    echo "Waiting for Kind cluster to be up..."
    sleep 5
done

# Install kubectl if not already installed
if ! command -v kubectl &> /dev/null
then
    brew install kubectl
fi

# Install Helm if not already installed
if ! command -v helm &> /dev/null
then
    brew install helm
fi