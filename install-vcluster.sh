#!/bin/bash

set -euo pipefail

# Set the tenant names
tenants=("tenant1" "tenant2" "tenant3")

# Set the host cluster name
host_cluster="kind-host-cluster"

# Install vcluster if not already installed
if ! command -v vcluster &> /dev/null
then
    curl -L https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-darwin-amd64 -o vcluster
    chmod +x vcluster
    sudo mv vcluster /usr/local/bin/
fi

# Install kustomize if not already installed
if ! command -v kustomize &> /dev/null
then
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
    sudo mv kustomize /usr/local/bin/
fi

# Check if Helm is installed
if ! command -v helm &> /dev/null
then
    # Install Helm
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi

# Create vclusters
for tenant in "${tenants[@]}"
do
    kubectl config use-context kind-host-cluster
    vcluster create "$tenant"
    
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install wordpress bitnami/wordpress --set mariadb.primary.persistence.enabled=true
    
done
