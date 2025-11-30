#!/bin/bash
CURPATH=$(pwd)
pushd .secrets
user=$(cat cifs.json | jq -r ".user")
pwd=$(cat cifs.json | jq -r ".pwd")
backtest_namespace=backtest-crypto

# Fetch aws secret from ../.secrets/aws_secrets.json
# put the secret from json file into environment variables
AWS_ACCESS_KEY_ID=$(cat aws_secrets.json | jq -r ".AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY=$(cat aws_secrets.json | jq -r ".AWS_SECRET_ACCESS_KEY")
AWS_DEFAULT_REGION=$(cat aws_secrets.json | jq -r ".AWS_DEFAULT_REGION")

kubectl create ns $backtest_namespace
# echo $user
# echo $pwd
kubectl delete secret smbcreds --namespace=$bktest_namespace
kubectl create secret generic smbcreds --from-literal username=${user} --from-literal password=${pwd} \
    --namespace=$bktest_namespace

kubectl delete secret runconfig -n $backtest_namespace
kubectl create secret generic runconfig --from-file=RunConfig.json=./RunConfig.k3s.json --namespace=$backtest_namespace

kubectl delete secret runconfig-dummy -n $backtest_namespace
kubectl create secret generic runconfig-dummy --from-file=RunConfig.json=./RunConfig.dummy.json --namespace=$backtest_namespace

kubectl delete secret jupyter-secret -n $backtest_namespace
kubectl create secret generic jupyter-secret --from-file=jupyter_notebook_config.json=./jupyter_secret.json --namespace=$backtest_namespace

kubectl delete secret optimize-batch-job-controller-secret -n $backtest_namespace
kubectl create secret generic optimize-batch-job-controller-secret --from-file=optimize_batch_job_controller.json=k8s_optimize_batch_job_controller.json --namespace=$backtest_namespace

#Create the secret into k8s with name=AWS_ACCESS_KEY_ID
kubectl delete secret aws-accesskey-id -n $backtest_namespace
kubectl create secret generic aws-accesskey-id --from-literal=aws-accesskey-id=${AWS_ACCESS_KEY_ID} --namespace=$backtest_namespace

#Create the secret into k8s with name=AWS_SECRET_ACCESS_KEY
kubectl delete secret aws-secret-access-key -n $backtest_namespace
kubectl create secret generic aws-secret-access-key --from-literal=aws-secret-access-key=${AWS_SECRET_ACCESS_KEY} --namespace=$backtest_namespace

#Create the secret into k8s with name=AWS_DEFAULT_REGION
kubectl delete secret aws-default-region -n $backtest_namespace
kubectl create secret generic aws-default-region --from-literal=aws-default-region=${AWS_DEFAULT_REGION} --namespace=$backtest_namespace

kubectl create ns monitoring
kubectl delete secret grafana-admin-credentials -n monitoring
grafana_usr=$(cat grafana-admin-credentials.json | jq -r ".user")
grafana_pwd=$(cat grafana-admin-credentials.json | jq -r ".password")

kubectl create secret generic grafana-admin-credentials --from-literal=admin-user=${grafana_usr} --from-literal=admin-password=${grafana_pwd} -n monitoring

kubectl delete secret postgres-credentials -n $backtest_namespace
psql_usr=$(cat postgres-credentials.json | jq -r ".user")
psql_pwd=$(cat postgres-credentials.json | jq -r ".password")
kubectl create secret generic postgres-credentials --from-literal=postgres-user=${psql_usr} --from-literal=postgres-password=${psql_pwd} -n $backtest_namespace
cd ${CURPATH}