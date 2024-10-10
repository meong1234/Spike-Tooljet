
GITHUB_OWNER     		:= meong1234
GITHUB_REPO      		:= Spike-Tooljet
GITHUB_BRANCH    		:= main
GITHUB_CLUSTER_FOLDER  	:= clusters/local-cluster

# Flux support
k8s-fluxcd-init:
	flux check --pre
	flux bootstrap github \
      --token-auth \
      --owner=$(GITHUB_OWNER) \
      --repository=$(GITHUB_REPO) \
      --branch=$(GITHUB_BRANCH) \
      --path=$(GITHUB_CLUSTER_FOLDER) \
      --personal