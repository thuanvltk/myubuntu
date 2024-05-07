#!/bin/bash
# set -e
set -o xtrace

# Declare variables
GIT_CONTENT_URL='https://raw.githubusercontent.com/thuanvltk/myubuntu/main'
USER_HOME=$(getent passwd "$USER" | cut -d: -f6)

# Backup .bashrc before editting
cp $USER_HOME/.bashrc $USER_HOME/.bashrc.bk.$(date +"%m_%d_%Y-%H_%M_%S")

grep 'My custom script' $USER_HOME/.bashrc > /dev/null
if [[ $? -ne 0 ]]
then
  printf "\n### My custom script ###\n\n" >> $USER_HOME/.bashrc
fi

################### ssh ##########################

# ssh-agent cahce SSH credentials passphrase
grep 'eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa' $USER_HOME/.bashrc
if [[ $? -ne 0 ]]
then
  echo 'eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa' >> $USER_HOME/.bashrc
fi

##################################################

################### aliases ######################

# sudo 
grep 'alias sudo' $USER_HOME/.bashrc > /dev/null
if [[ $? -ne 0 ]]
then
  echo "alias sudo='sudo '" >> $USER_HOME/.bashrc
fi

# kubectl
grep 'alias kube' $USER_HOME/.bashrc > /dev/null
if [[ $? -ne 0 ]]
then
  echo "alias kube='kubectl'" >> $USER_HOME/.bashrc
fi

###################################################

#################### vim ##########################

# set vim as default editor
sudo update-alternatives --set editor /usr/bin/vim.basic

# set paste mode
cat $USER_HOME/.vimrc | grep "set paste" > /dev/null
if [[ $? -ne 0 ]]
then
  echo "set paste" >> $USER_HOME/.vimrc
fi

###################################################

################### kubernetes ####################

# kubectl
sudo curl --output-dir /usr/local/bin -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod a+x /usr/local/bin/kubectl
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
grep 'complete -o default -F __start_kubectl kube' $USER_HOME/.bashrc > /dev/null
if [[ $? -ne 0 ]]
then
  echo "complete -o default -F __start_kubectl kube" >> $USER_HOME/.bashrc
fi

# kubectx & kubens
sudo curl --output-dir /usr/local/bin -o kubectx $GIT_CONTENT_URL/kubectx/kubectx.sh
sudo curl --output-dir /usr/local/bin -o kubens $GIT_CONTENT_URL/kubectx/kubens.sh
sudo chmod a+x /usr/local/bin/kubectx
sudo chmod a+x /usr/local/bin/kubens
sudo curl --output-dir /etc/bash_completion.d -O $GIT_CONTENT_URL/kubectx/completion/kubectx.bash
sudo curl --output-dir /etc/bash_completion.d -O $GIT_CONTENT_URL/kubectx/completion/kubens.bash

###################################################

# reload .bashrc
source $USER_HOME/.bashrc

echo "DONE!!!"
# END
