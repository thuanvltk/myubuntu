#!/usr/bin/env bash
# set -e
[[ -n "$MYDEBUG" ]] && set -o xtrace

# Declare variables
GIT_CONTENT_URL='https://raw.githubusercontent.com/thuanvltk/myubuntu/main'
USER_HOME=$(getent passwd "$USER" | cut -d: -f6)

# Backup .bashrc before editting
cp "$USER_HOME"/.bashrc "$USER_HOME"/.bashrc.bk.$(date +"%m_%d_%Y-%H_%M_%S")

grep 'My custom script' "$USER_HOME"/.bashrc &> /dev/null
if [[ $? -ne 0 ]]
then
  printf "\n### My custom script ###\n\n" >> "$USER_HOME"/.bashrc
fi

################### ssh ##########################
# # ssh-agent cahce SSH credentials passphrase
# grep 'eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa' $USER_HOME/.bashrc
# if [[ $? -ne 0 ]]
# then
#   echo 'eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa' >> $USER_HOME/.bashrc
# fi
##################################################

################### aliases ######################
# sudo 
grep 'alias sudo=' "$USER_HOME"/.bash_aliases &> /dev/null
if [[ $? -ne 0 ]]
then
  echo "alias sudo='sudo '" >> "$USER_HOME"/.bash_aliases
fi

# kubectl
grep 'alias kube=' "$USER_HOME"/.bash_aliases &> /dev/null
if [[ $? -ne 0 ]]
then
  echo "alias kube='kubectl'" >> "$USER_HOME"/.bash_aliases
fi

# source .bashrc
grep 'alias brc=' "$USER_HOME"/.bash_aliases &> /dev/null
if [[ $? -ne 0 ]]
then
  echo "alias brc='source ~/.bashrc'" >> "$USER_HOME"/.bash_aliases
fi
###################################################

#################### vim ##########################
# set vim as default editor
sudo update-alternatives --set editor /usr/bin/vim.basic

# set paste mode
grep 'set paste' "$USER_HOME"/.vimrc &> /dev/null
if [[ $? -ne 0 ]]
then
  echo "set paste" >> "$USER_HOME"/.vimrc
fi
###################################################

############### terminal color ####################
# fix color of 777 directory
grep "^OTHER_WRITABLE" "$USER_HOME"/.dircolors &> /dev/null
if [[ $? -ne 0 ]]
then
  echo 'OTHER_WRITABLE 34' >> ~/.dircolors
fi
###################################################

################### sudo ##########################
# sudo without password
echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/sudo_without_password &> /dev/null
###################################################

################### kubernetes ####################
# kubectl
sudo curl --output-dir /tmp -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  sudo mv /tmp/kubectl /usr/local/bin && sudo chmod a+x /usr/local/bin/kubectl
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl &> /dev/null
grep 'complete -o default -F __start_kubectl kube' "$USER_HOME"/.bashrc &> /dev/null
if [[ $? -ne 0 ]]
then
  echo "complete -o default -F __start_kubectl kube" >> "$USER_HOME"/.bashrc
fi

# kubectx & kubens
sudo curl --output-dir /tmp -LO "$GIT_CONTENT_URL/kubectx/kubectx.sh" && \
  sudo mv /tmp/kubectx.sh /usr/local/bin/kubectx && \
  sudo chmod a+x /usr/local/bin/kubectx

sudo curl --output-dir /tmp -LO "$GIT_CONTENT_URL/kubectx/kubens.sh" && \
  sudo mv /tmp/kubens.sh /usr/local/bin/kubens && \
  sudo chmod a+x /usr/local/bin/kubens

sudo curl --output-dir /tmp -LO "$GIT_CONTENT_URL/kubectx/completion/kubectx.bash" && \
  sudo mv /tmp/kubectx.bash /etc/bash_completion.d

sudo curl --output-dir /tmp -LO "$GIT_CONTENT_URL/kubectx/completion/kubens.bash" && \
  sudo mv /tmp/kubens.bash /etc/bash_completion.d

# kube-ps1
sudo curl --output-dir /tmp -LO "$GIT_CONTENT_URL/kube-ps1/kube-ps1.sh" && \
  sudo mv /tmp/kube-ps1.sh /usr/local/bin && sudo chmod a+x /usr/local/bin/kube-ps1.sh
grep 'source /usr/local/bin/kube-ps1.sh' "$USER_HOME"/.bashrc &> /dev/null
if [[ $? -ne 0 ]]
then
  echo 'source /usr/local/bin/kube-ps1.sh' >> "$USER_HOME"/.bashrc
fi
grep 'PS1="$(kube_ps1)' $USER_HOME/.bashrc &> /dev/null
if [[ $? -ne 0 ]]
then
  echo 'PS1="$(kube_ps1) \u:\[\e[0;33m\]\w\[\e[0m\]\$ "' >> "$USER_HOME"/.bashrc
fi

# helm
HELM_VERSION=$(curl -sL "https://get.helm.sh/helm-latest-version")
sudo curl --output-dir /tmp -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
  sudo rm -rf /tmp/helm && sudo mkdir /tmp/helm && \
  sudo tar -xzf /tmp/helm-"${HELM_VERSION}"-linux-amd64.tar.gz -C /tmp/helm && \
  sudo mv /tmp/helm/linux-amd64/helm /usr/local/bin/helm && \
  sudo chmod a+x /usr/local/bin/helm
helm completion bash | sudo tee /etc/bash_completion.d/helm &> /dev/null
###################################################

echo "DONE!!!"
# END