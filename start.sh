#!/bin/bash

gCommandList=("git" "zip" "vim" "curl")
gDebianList=("git" "zip" "vim" "curl")
gRedHatList=("git" "zip.x86_64" "vim" "curl")
DISTRO=
PM=

CpFile() {
    objs=".vimrc .vimrc.bundles"
    for file in $objs; do
        if [ ! -f $file ]; then
            echo "$file doesn't exists."
            return 1
        fi
        cp $file ~/
    done
    return 0
}

#detect the system and software
GetDistName() {
    Issuefile=/etc/issue
    ReleaseFile=/etc/*-release
    for dis in "Ubuntu" "Debian" "Centos" "Oracle Linux"; do
        if grep -Eqi $dis $Issuefile || grep -Eq $dis $ReleaseFile; then
            DISTRO=$dis
            case $dis in
                "Centos") PM="yum";;
                "Oracle Linux") PM="yum";;
                *) PM="apt";;
            esac
        fi
    done
}

CheckCommand() {
    local cmd
    local idx=0
    for cmd in ${gCommandList[@]}; do
        which $cmd >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            if [ "x$dis" = "xCentos" ]; then
                yes | $PM install ${gRedHatList[$idx]}
            else
                yes | $PM install ${gDebianList[$idx]}
            fi
        fi
        ##check again
        which $cmd >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Failed to install $cmd"
            exit 1
        fi
        idx=$idx+1
    done
    return 0
}


############## MAIN FUNCTION #############################



CpFile
if [ $? != 0 ]; then
    echo "File not exists.\n" 
    exit 1
fi
GetDistName
CheckCommand

#install 
$PM install -y git curl ctags cscope unzip
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
#download taglist
curl -LSso $HOME/.vim/taglist.zip https://vim.sourceforge.io/scripts/download_script.php?src_id=19574
cd $HOME/.vim/ && unzip taglist.zip && rm $HOME/.vim/taglist.zip
vim -c "silent !ls" -c 'PluginInstall' -c 'qa!'
