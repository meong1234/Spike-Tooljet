# K8s support

KIND              := kindest/node:v1.26.3
TELEPRESENCE      := docker.io/datawire/tel2:2.17.0

FLUXCD-SOURCE := ghcr.io/fluxcd/source-controller:v1.1.2
FLUXCD-NOTIFICATION := ghcr.io/fluxcd/notification-controller:v1.1.0
FLUXCD-KUSTOMIZE := ghcr.io/fluxcd/kustomize-controller:v1.1.1
FLUXCD-HELM := ghcr.io/fluxcd/helm-controller:v0.36.2

CLOUDNATIVE-PG 			 		 := ghcr.io/cloudnative-pg/cloudnative-pg:1.24.0
CLOUDNATIVE-PG-POSTGRES 		 := ghcr.io/cloudnative-pg/postgresql:16.4-bookworm
FLYWAY					 		 := flyway/flyway:10.1-alpine
TOOLJET-CE					     := tooljet/tooljet-ce:CE-LTS-latest

k8s-docker-pull:
	docker pull $(KIND)
	docker pull $(CLOUDNATIVE-PG)
	docker pull $(CLOUDNATIVE-PG-POSTGRES)
	docker pull $(FLYWAY)
	docker pull --platform linux/amd64 $(TOOLJET-CE)

KIND_CLUSTER := tooljet-starter-cluster

k8s-create-cluster:
	kind create cluster \
    		--image kindest/node:v1.26.3@sha256:61b92f38dff6ccc29969e7aa154d34e38b89443af1a2c14e6cfbd2df6419c66f \
    		--name $(KIND_CLUSTER) \

	kubectl wait --timeout=120s --namespace=local-path-storage --for=condition=Available deployment/local-path-provisioner


TELEPRESENCE-MANAGER			 := docker.io/datawire/ambassador-telepresence-manager:2.17.0
TELEPRESENCE-AGENT			     := docker.io/ambassador/ambassador-agent:1.0.21

k8s-init-telepresence:
	docker pull $(TELEPRESENCE)
	docker pull $(TELEPRESENCE-MANAGER)
	docker pull $(TELEPRESENCE-AGENT)
	kind load docker-image $(TELEPRESENCE) --name $(KIND_CLUSTER)
	kind load docker-image $(TELEPRESENCE-MANAGER) --name $(KIND_CLUSTER)
	kind load docker-image $(TELEPRESENCE-AGENT) --name $(KIND_CLUSTER)
	telepresence --context=kind-$(KIND_CLUSTER) helm install
	telepresence --context=kind-$(KIND_CLUSTER) connect

#for faster demo
k8s-preload-fluxcd:
	docker pull $(FLUXCD-SOURCE)
	docker pull $(FLUXCD-NOTIFICATION)
	docker pull $(FLUXCD-KUSTOMIZE)
	docker pull $(FLUXCD-HELM)
	kind load docker-image $(FLUXCD-SOURCE) --name $(KIND_CLUSTER)
	kind load docker-image $(FLUXCD-NOTIFICATION) --name $(KIND_CLUSTER)
	kind load docker-image $(FLUXCD-KUSTOMIZE) --name $(KIND_CLUSTER)
	kind load docker-image $(FLUXCD-HELM) --name $(KIND_CLUSTER)

k8s-delete-cluster:
	kind delete cluster --name $(KIND_CLUSTER)

k8s-delete-telepresence:
	telepresence quit -s

k8s-load-docker:
	kind load docker-image $(CLOUDNATIVE-PG) --name $(KIND_CLUSTER)
	kind load docker-image $(CLOUDNATIVE-PG-POSTGRES) --name $(KIND_CLUSTER)
	kind load docker-image $(FLYWAY) --name $(KIND_CLUSTER)
	kind load docker-image $(TOOLJET-CE) --name $(KIND_CLUSTER)
