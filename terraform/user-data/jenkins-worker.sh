#!/bin/bash
set -euxo pipefail

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/xata-setup.log
}

error_exit() {
  log "ERROR: $1"
  exit 1
}

# ===== System Update =====
log "Updating system packages..."
apt-get update -y || error_exit "Failed to update packages"
apt-get install -y ca-certificates curl gnupg git jq || error_exit "Failed to install prerequisites"

# ===== Docker Official Install =====
log "Installing Docker..."
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg || error_exit "Failed to add Docker GPG key"

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y || error_exit "Failed to update Docker repository"

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin || error_exit "Failed to install Docker"

# Enable and start Docker
systemctl enable docker || error_exit "Failed to enable Docker"
systemctl start docker || error_exit "Failed to start Docker"

# Verify Docker installation
docker --version || error_exit "Docker installation verification failed"

# Docker Group Management =====
log "Configuring Docker group..."
if ! id -nG ubuntu | grep -qw docker; then
  usermod -aG docker ubuntu || error_exit "Failed to add ubuntu user to docker group"
fi

# Reload Docker daemon to apply group changes
newgrp docker << EOF
echo "Docker group activated"
EOF

apt-get install -y fontconfig openjdk-21-jre || error_exit "Failed to install OpenJDK 21"