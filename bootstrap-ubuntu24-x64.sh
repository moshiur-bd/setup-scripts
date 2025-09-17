echo "Update packages"
sudo apt -y update
sudo apt -y upgrade

echo "Install fish, unzip, make, gcc, git, ..."
sudo apt -y install fish unzip make gcc ripgrep git xclip

echo "Install neovim"
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt -y update
sudo apt -y install neovim

echo "Install tmux"
sudo apt -y install tmux

echo "Setup neovim scripts"
curl -LO https://github.com/moshiur-bd/nvim/archive/refs/heads/remote.zip
unzip remote.zip && rm remote.zip
mkdir  ~/.config
sudo mv -f nvim-remote ~/.config/nvim
sudo rm -rf nvim-remote #in case the above command fails due to pre-existing config

if ! grep -q 'fish' ~/.bashrc; then
    echo "Make fish default"
    echo "fish" >> ~/.bashrc
fi

echo "Setup Docker"
sudo apt -y install docker.io

echo "Install minikube X64"
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64


echo "Install kubectl"
snap install kubectl --classic

echo "Start kubernetes"
minikube start --force
