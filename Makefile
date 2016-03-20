CLUSTER_DC=dev
CLUSTER_DOMAIN=local.net
HOST_IP=$(shell ping -c 1 $(HOST_NAME) | awk -F'[()]' '/PING/{print $$2}')
SPLUNK_TOKEN=

all:

machine-infra: machine-infra-provision, machine-infra-deploy

machine-infra-provision:
	docker-machine \
		--debug \
		create \
		--driver generic \
		--generic-ip-address $(HOST_IP) \
		--generic-ssh-key $(HOST_KEY) \
		--generic-ssh-user $(HOST_USER) \
		--engine-opt graph=/appdata/docker/var \
		$(HOST_NAME)

machine-infra-deploy:
	eval $$(docker-machine env $(HOST_NAME)); \
		CLUSTER_DC=$(CLUSTER_DC) \
		CLUSTER_DOMAIN=$(CLUSTER_DOMAIN) \
		HOST_NAME=$(HOST_NAME) \
		HOST_IP=$$(docker-machine ip $(HOST_NAME)) \
		SPLUNK_TOKEN=$(SPLUNK_TOKEN) \
		docker-compose \
			-f machine-infra.yaml \
			up -d

machine-master: machine-master-provision, machine-master-deploy

machine-master-provision:
	docker-machine \
		create \
		--driver generic \
		--generic-ip-address $(HOST_IP) \
		--generic-ssh-key $(HOST_KEY) \
		--generic-ssh-user $(HOST_USER) \
		--engine-opt graph=/appdata/docker/var \
		--engine-opt log-driver=splunk \
		--engine-opt log-opt=splunk-token=$(SPLUNK_TOKEN) \
		--engine-opt log-opt=splunk-url=https://$$(docker-machine ip $(HOST_NAME_INFRA)):8088 \
		--engine-opt log-opt=splunk-insecureskipverify=true \
		--swarm \
		--swarm-master \
		--swarm-discovery consul://$$(docker-machine ip $(HOST_NAME_INFRA)):8500 \
		--engine-opt cluster-store=consul://$$(docker-machine ip $(HOST_NAME_INFRA)):8500 \
		--engine-opt cluster-advertise=eth0:2376 \
		$(HOST_NAME)

machine-master-deploy:
	eval $$(docker-machine env $(HOST_NAME)); \
		CLUSTER_DC=$(CLUSTER_DC) \
		CLUSTER_DOMAIN=$(CLUSTER_DOMAIN) \
		HOST_NAME=$(HOST_NAME) \
		HOST_IP=$$(docker-machine ip $(HOST_NAME)) \
		HOST_IP_INFRA=$$(docker-machine ip $(HOST_NAME_INFRA)) \
		SPLUNK_TOKEN=$(SPLUNK_TOKEN) \
		docker-compose \
			-f machine.yaml \
			up -d

machine-agent: machine-agent-provision, machine-agent-deploy

machine-agent-provision:
	docker-machine \
		create \
		--driver generic \
		--generic-ip-address $(HOST_IP) \
		--generic-ssh-key $(HOST_KEY) \
		--generic-ssh-user $(HOST_USER) \
		--engine-opt graph=/appdata/docker/var \
		--engine-opt log-driver=splunk \
		--engine-opt log-opt=splunk-token=$(SPLUNK_TOKEN) \
		--engine-opt log-opt=splunk-url=https://$$(docker-machine ip $(HOST_NAME_INFRA)):8088 \
		--engine-opt log-opt=splunk-insecureskipverify=true \
		--swarm \
		--swarm-discovery consul://$$(docker-machine ip $(HOST_NAME_INFRA)):8500 \
		--engine-opt cluster-store=consul://$$(docker-machine ip $(HOST_NAME_INFRA)):8500 \
		--engine-opt cluster-advertise=eth0:2376 \
		$(HOST_NAME)

machine-agent-deploy:
	eval $$(docker-machine env $(HOST_NAME)); \
		CLUSTER_DC=$(CLUSTER_DC) \
		CLUSTER_DOMAIN=$(CLUSTER_DOMAIN) \
		HOST_NAME=$(HOST_NAME) \
		HOST_IP=$$(docker-machine ip $(HOST_NAME)) \
		HOST_IP_INFRA=$$(docker-machine ip $(HOST_NAME_INFRA)) \
		SPLUNK_TOKEN=$(SPLUNK_TOKEN) \
		docker-compose \
			-f machine.yaml \
			up -d
