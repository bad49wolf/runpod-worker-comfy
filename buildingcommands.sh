docker buildx build \
  --platform linux/amd64 \
  -t bad49wolf/flux-dev-krea-upscaler-all-fp8:latest \
  --load \
  .

# 1. Update package index
sudo apt-get update

# 2. Install prerequisites
sudo apt install curl apt-transport-https ca-certificates software-properties-common

# 3. Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 4. Set up the repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. Verify installation
sudo systemctl status docker
sudo docker run hello-world