#!/bin/sh
# https://grafana.com/docs/loki/latest/setup/install/helm/install-monolithic/
#helm repo add grafana https://grafana.github.io/helm-charts

#helm show values grafana/loki > loki-values.yaml



helm install loki grafana/loki -n monitoring --wait \
         -f loki-values.yaml

kubectl apply -f grafana-promtail-install.yaml