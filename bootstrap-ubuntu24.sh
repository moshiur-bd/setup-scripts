echo "Update packages"
sudo apt -y update
sudo apt -y upgrade

echo "Install fish, unzip, make, gcc, git, ..."
sudo apt -y install fish unzip make gcc ripgrep git xclip

echo "Install neovim"
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt -y update
sudo apt -y install neovim

echo "Setup neovim scripts"
curl -LO https://github.com/moshiur-bd/nvim/archive/refs/heads/remote.zip
unzip remote.zip && rm remote.zip
mkdir  ~/.config
sudo mv -f nvim-remote ~/.config/nvim


echo "Install minikube"

curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube && rm minikube-linux-arm64

