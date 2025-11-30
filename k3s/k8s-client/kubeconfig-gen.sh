#!/bin/sh
# set -eux

# Reads the API server name from the default `kubeconfig` file.
# Here we suppose that the kubectl command-line tool is already configured to communicate with our cluster.
APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

SERVICE_ACCOUNT_NAME=${1:-spark-client-sa}
NAMESPACE=${2:-backtest-crypto}
SECRET_NAME=$(kubectl get serviceaccount ${SERVICE_ACCOUNT_NAME} -n ${NAMESPACE} -o jsonpath='{.secrets[0].name}')
TOKEN=$(kubectl get secret ${SECRET_NAME} -n ${NAMESPACE} -o jsonpath='{.data.token}' | base64 --decode)
CACERT=$(kubectl get secret ${SECRET_NAME} -n ${NAMESPACE} -o jsonpath="{['data']['ca\.crt']}")


cat << EOF | tee kubeconfig-sa
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CACERT}
    server: ${APISERVER}
  name: default-cluster
contexts:
- context:
    cluster: default-cluster
    namespace: ${NAMESPACE}
    user: ${SERVICE_ACCOUNT_NAME}
  name: default-context
current-context: default-context
users:
- user:
    token: ${TOKEN}
  name: ${SERVICE_ACCOUNT_NAME}
EOF