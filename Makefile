# .ONESHELL:
# SHELL := /bin/bash
# K0SCTL_CONFIG := k0sctl.yml
# SSH_KEY := ~/.ssh/id_rsa.pub

# # Default Multipass instance names
# MASTER := k8s-master
# WORKER1 := k8s-worker1
# WORKER2 := k8s-worker2

# # Default resources
# MASTER_CPU := 2
# MASTER_MEM := 2G
# MASTER_DISK := 5G

# WORKER_CPU := 1
# WORKER_MEM := 1G
# WORKER_DISK := 4G

# # Colors
# GREEN=\033[0;32m
# RED=\033[0;31m
# NC=\033[0m

# .PHONY: all setup clean deploy destroy reset

# all: setup deploy
# 	@echo -e "${GREEN}All tasks completed successfully.${NC}"

# setup:
# 	@echo -e "${GREEN}Setting up Multipass instances...${NC}"
# 	multipass launch 22.04 --name $(MASTER) --cpus $(MASTER_CPU) --memory $(MASTER_MEM) --disk $(MASTER_DISK) || echo -e "${RED}$(MASTER) already exists. Skipping.${NC}"
# 	multipass launch 22.04 --name $(WORKER1) --cpus $(WORKER_CPU) --memory $(WORKER_MEM) --disk $(WORKER_DISK) || echo -e "${RED}$(WORKER1) already exists. Skipping.${NC}"
# 	multipass launch 22.04 --name $(WORKER2) --cpus $(WORKER_CPU) --memory $(WORKER_MEM) --disk $(WORKER_DISK) || echo -e "${RED}$(WORKER2) already exists. Skipping.${NC}"

# 	@echo -e "${GREEN}Adding SSH keys...${NC}"
# 	multipass exec $(MASTER) -- bash -c "echo '$$(cat $(SSH_KEY))' >> ~/.ssh/authorized_keys"
# 	multipass exec $(WORKER1) -- bash -c "echo '$$(cat $(SSH_KEY))' >> ~/.ssh/authorized_keys"
# 	multipass exec $(WORKER2) -- bash -c "echo '$$(cat $(SSH_KEY))' >> ~/.ssh/authorized_keys"

# 	@echo -e "${GREEN}Fetching IP addresses and generating k0sctl.yml...${NC}"
# 	MASTER_IP=$$(multipass info $(MASTER) | grep IPv4 | awk '{print $$2}')
# 	WORKER1_IP=$$(multipass info $(WORKER1) | grep IPv4 | awk '{print $$2}')
# 	WORKER2_IP=$$(multipass info $(WORKER2) | grep IPv4 | awk '{print $$2}')
# 	@echo "apiVersion: k0sctl.k0sproject.io/v1beta1" > $(K0SCTL_CONFIG)
# 	@echo "kind: Cluster" >> $(K0SCTL_CONFIG)
# 	@echo "metadata:" >> $(K0SCTL_CONFIG)
# 	@echo "  name: k0s-cluster" >> $(K0SCTL_CONFIG)
# 	@echo "spec:" >> $(K0SCTL_CONFIG)
# 	@echo "  hosts:" >> $(K0SCTL_CONFIG)
# 	@echo "  - ssh:" >> $(K0SCTL_CONFIG)
# 	@echo "      address: $$MASTER_IP" >> $(K0SCTL_CONFIG)
# 	@echo "      user: ubuntu" >> $(K0SCTL_CONFIG)
# 	@echo "      keyPath: ~/.ssh/id_rsa" >> $(K0SCTL_CONFIG)
# 	@echo "    role: controller" >> $(K0SCTL_CONFIG)
# 	@echo "  - ssh:" >> $(K0SCTL_CONFIG)
# 	@echo "      address: $$WORKER1_IP" >> $(K0SCTL_CONFIG)
# 	@echo "      user: ubuntu" >> $(K0SCTL_CONFIG)
# 	@echo "      keyPath: ~/.ssh/id_rsa" >> $(K0SCTL_CONFIG)
# 	@echo "    role: worker" >> $(K0SCTL_CONFIG)
# 	@echo "  - ssh:" >> $(K0SCTL_CONFIG)
# 	@echo "      address: $$WORKER2_IP" >> $(K0SCTL_CONFIG)
# 	@echo "      user: ubuntu" >> $(K0SCTL_CONFIG)
# 	@echo "      keyPath: ~/.ssh/id_rsa" >> $(K0SCTL_CONFIG)
# 	@echo "    role: worker" >> $(K0SCTL_CONFIG)
# 	@echo -e "${GREEN}k0sctl.yml generated successfully.${NC}"


# clean:
# 	@echo -e "${RED}Removing k0sctl.yml...${NC}"
# 	rm -f $(K0SCTL_CONFIG)

# destroy:
# 	@echo -e "${RED}Destroying Multipass instances...${NC}"
# 	multipass delete $(MASTER) $(WORKER1) $(WORKER2) || true
# 	multipass purge
# 	rm -f $(K0SCTL_CONFIG)
# 	@echo -e "${GREEN}All instances and configurations cleaned up.${NC}"

# reset: destroy setup deploy


# Makefile for Multipass VM and k0s cluster management

# Variables
SSH_KEY=~/.ssh/id_rsa
K0SCTL_CONFIG=k0sctl.yml

# Default targets
.PHONY: all create spinup destroy

# Create VMs using the init.sh script
create:
	@bash ./init.sh

# Install k0s on the created VMs
spinup: create
	@echo "Spinning up k0s cluster..."
	k0sctl apply --config $(K0SCTL_CONFIG)

# Destroy VMs and cleanup
destroy:
	@echo "Destroying all Multipass instances..."
	multipass delete k8s-master k8s-worker1 k8s-worker2
	multipass purge
	@echo "Deleting k0sctl configuration..."
	rm -f $(K0SCTL_CONFIG)
	@echo "Cleanup complete."

# List all Multipass instances
list:
	@echo "Listing all Multipass instances..."
	multipass list

# Check status of the cluster
status:
	@echo "Checking k0s cluster status..."
	k0sctl status --config $(K0SCTL_CONFIG)
