#!/bin/bash
echo "==========================================================================================================================="
echo -e "\033[0;35m"
echo "  ██████╗ ██████╗ ███╗   ██╗████████╗██████╗ ██╗██████╗ ██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗██████╗  █████╗  ██████╗ ";
echo " ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██║██╔══██╗██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗";
echo " ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║██████╔╝██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║██║  ██║███████║██║   ██║";
echo " ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║██╔══██╗██║   ██║   ██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║██║   ██║";
echo " ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║██████╔╝╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║╚██████╔╝";
echo "  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ";
																													  
echo -e "\033[0;35m"
echo "==========================================================================================================================="                                                                                    
sleep 1



#function Updatingpackages 
echo -e "\e[1m\e[32mInstalling required tool \e[0m" && sleep 1
sudo  apt update && apt install git sudo unzip wget -y < "/dev/null"



#function Installingdependencies 
echo -e "\e[1m\e[32mInstalling dependencies \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y < "/dev/null"





#function Installinggo 
echo -e "\e[1m\e[32mInstalling GO \e[0m" && sleep 1
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version



#function Installingcelestia 
echo -e "\e[1m\e[32mInstalling Celestia \e[0m" && sleep 1
cd $HOME
sudo rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app
APP_VERSION=$(curl -s https://api.github.com/repos/celestiaorg/celestia-app/releases/latest | jq -r ".tag_name")
git checkout tags/$APP_VERSION -b $APP_VERSION
make install


#function setupp2pnetworks 
echo -e "\e[1m\e[32mSetup P2P Network \e[0m" && sleep 1
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git


#function setupconfig 
echo -e "\e[1m\e[32mSetup mamaki config \e[0m" && sleep 1
read -p "Insert node name: " nodename 
celestia-appd init ${nodename} --chain-id mamaki


#function setupwallet 
echo -e "\e[1m\e[32mSetup mamaki config \e[0m" && sleep 1
celestia-appd config chain-id mamaki
celestia-appd config keyring-backend test



#function setupgenesis 
echo -e "\e[1m\e[32mSetup genesis config \e[0m" && sleep 1
cp $HOME/networks/mamaki/genesis.json $HOME/.celestia-app/config




#function setseedsandpeers 
BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
echo $BOOTSTRAP_PEERS
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml






