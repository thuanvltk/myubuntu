#!/bin/bash

##### vim #####

# set vim as default editor
sudo update-alternatives --set editor /usr/bin/vim.basic

# set paste mode
cat ~/.vimrc | grep "set paste" > /dev/null
if [[ $? -ne 0 ]]
then
  echo "set paste" >> ~/.vimrc
fi

###############
