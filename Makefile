include scripts/*

setup-tools: brew-common k8s-docker-pull

k8s-up: k8s-create-cluster k8s-load-docker k8s-preload-fluxcd
k8s-down: k8s-delete-cluster
k8s-run: k8s-fluxcd-init

telepresence-up: k8s-init-telepresence
telepresence-down: k8s-delete-telepresence