#!/bin/bash
set -e

# Backup .bashrc before editting
cp ~/.bashrc ~/.bashrc.bk.$(date +"%m_%d_%Y-%H_%M_%S")

grep 'My custom script' ~/.bashrc > /dev/null
if [[ $? -ne 0 ]]
then
  printf "### My custom script ###\n\n" >> ~/.bashrc
fi

################### ssh ##########################

# ssh-agent cahce SSH credentials passphrase
grep 'eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa' ~/.bashrc
if [[ $? -ne 0 ]]
then
  echo 'eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa' >> ~/.bashrc
fi

##################################################

################### aliases ######################

# sudo 
grep 'alias sudo' ~/.bashrc > /dev/null
if [[ $? -ne 0 ]]
then
  echo "alias sudo='sudo '" >> ~/.bashrc
fi

# kubectl
grep 'alias kube' ~/.bashrc > /dev/null
if [[ $? -ne 0 ]] then
  echo "alias kube='kubectl'" >> ~/.bashrc
fi

###################################################

#################### vim ##########################

# set vim as default editor
update-alternatives --set editor /usr/bin/vim.basic

# set paste mode
cat ~/.vimrc | grep "set paste" > /dev/null
if [[ $? -ne 0 ]]
then
  echo "set paste" >> ~/.vimrc
fi

###################################################

################### kubernetes ####################

# kubectx & kubens
cp ./kubectx/kubectx.sh /usr/local/bin/
cp ./kubectx/kubens.sh /usr/local/bin/
chmod u+x /usr/local/bin/kubectx.sh
chmod u+x /usr/local/bin/kubens.sh
cp ./kubectx/completion/kubectx.bash /etc/bash_completion.d/
cp ./kubectx/completion/kubens.bash /etc/bash_completion.d/
source ~/.bashrc



###################################################
