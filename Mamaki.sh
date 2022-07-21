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
read -p "Insert node name: " nodename && sleep 2
celestia-appd init ${nodename} --chain-id mamaki


#function setupwallet 
echo -e "\e[1m\e[32mSetup Wallet \e[0m" && sleep 1
celestia-appd config chain-id mamaki
celestia-appd config keyring-backend test



#function setupgenesis 
echo -e "\e[1m\e[32mSetup genesis config \e[0m" && sleep 1
cp $HOME/networks/mamaki/genesis.json $HOME/.celestia-app/config




#function setseedsandpeers 
echo -e "\e[1m\e[32mSet seeds and peers  \e[0m" && sleep 1
BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
echo $BOOTSTRAP_PEERS
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml

#function configpruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="5000"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.celestia-app/config/app.toml


#function setvalidatormode
echo -e "\e[1m\e[32mSet validator node  \e[0m" && sleep 1
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml

#function quickSync 
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - -C ~/.celestia-app/data/


#function createservice 
echo -e "\e[1m\e[32mSet service  \e[0m" && sleep 1
tee $HOME/celestia-appd.service > /dev/null <<EOF
[Unit]
Description=celestia-appd
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which celestia-appd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/celestia-appd.service /etc/systemd/system/


#function startservice 
echo -e "\e[1m\e[32mStart service  \e[0m" && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable celestia-appd
sudo systemctl restart celestia-appd




