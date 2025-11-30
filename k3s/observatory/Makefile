.PHONY: setup-base install-prometheus install-loki install-tempo install-alloy install-grafana clean

setup-base:
	kubectl apply -f prometheus-service-iam.yaml
	kubectl apply -f prometheus-pvc.yaml

install-prometheus:
	kubectl apply -f prometheus-config-map.yaml
	kubectl apply -f prometheus-alert-manager.yaml
	kubectl apply -f prometheus-kube-state-metrics.yaml
	kubectl apply -f node_exporter_daemon.yaml
	kubectl apply -f prometheus-deployment.yaml

install-loki:
	./grafana-loki-helm.sh

install-tempo:
	kubectl apply -f grafana-tempo-config.yaml
	kubectl apply -f grafana-tempo-deploy.yaml

install-alloy:
	kubectl apply -f grafana-alloy-config.yaml
	kubectl apply -f grafana-alloy-deploy.yaml

install-grafana:
	kubectl apply -f grafana-install.yaml

clean:
	kubectl delete namespace monitoring
