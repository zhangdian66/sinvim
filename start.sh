#!/bin/sh
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

DISTRO=
PM=
#detect the system and software
GetDistName() {
    Issuefile=/etc/issue
    ReleaseFile=/etc/*-release
    for dis in "Ubuntu" "Debian" "Centos"; do
        if grep -Eqi $dis $Issuefile || grep -Eq $dis $ReleaseFile; then
            DISTRO=$dis
            if [ "$dis" = "Centos" ]; then
                PM="yum"
            else
                PM="apt"
            fi
        fi
    done
}

CpFile
if [ $? != 0 ]; then
    echo "File not exists.\n" 
    exit 1
fi
GetDistName

#install 
$PM install -y git curl ctags cscope unzip
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
#download taglist
curl -LSso $HOME/.vim/taglist.zip https://vim.sourceforge.io/scripts/download_script.php?src_id=19574
cd $HOME/.vim/ && unzip taglist.zip && rm $HOME/.vim/taglist.zip
vim -c "silent !ls" -c 'PluginInstall' -c 'qa!'
