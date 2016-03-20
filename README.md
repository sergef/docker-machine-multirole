# Multi-role Docker Swarm cluster environment

## Provisioned by Docker Machine (with/without Vagrant)

Could be used with Vagrant or other already existing vm.

Example:

```shell
vagrant up machine-1
```

```shell
make machine-infra-provision \
  HOST_NAME=machine-1 \
  HOST_USER=vagrant \
  HOST_KEY=$HOME/.vagrant.d/insecure_private_key
```

```shell
eval $(docker-machine env machine-1)
```
