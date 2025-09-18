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



echo "Start kubernetes"
sudo snap install microk8s --classic
microk8s status --wait-ready
alias kubectl="microk8s kubectl"


echo "Setup argocd"
kubectl create namespace argocd
kubectl create namespace apps
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n argocd


