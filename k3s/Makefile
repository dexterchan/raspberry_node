BACKTEST_VERSION:=0.0.1
SITE:=example.com
SELF_SIGNED_CERT_PATH:=~/.ssh/self_signed/

.IPHONY init_env
init_env:
	kubectl apply -f Config-env.yaml
	kubectl apply -f Config-code-maint.yaml
	sh deploy_secrets.sh
	kubectl apply -f k8s-client/