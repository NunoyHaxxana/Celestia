# Menu install Celestia Light node

## System Requirements
The following hardware minimum requirements are recommended for running the Light node:

>:black_square_button:  OS Ubuntu 20.04 (LTS) x64<br> 

Memory: 2 GB RAM

CPU: Single Core

Disk: 5 GB SSD Storage

Bandwidth: 56 Kbps for Download/56 Kbps for Upload

## 1. Please use user root for install

```
sudo su
```

## 2. Download and run script

```
wget -q -O lightnodes.sh https://raw.githubusercontent.com/Contribution-DAO/Celestia/main/Thai/Light%20nodes/Autolight.sh && chmod +x lightnodes.sh && sudo /bin/bash lightnodes.sh
```


## Select Option 1 Install

and wait to script install complete



## Select Option 2 Get Wallet
and wait to script install complete



## Select Option 3 Get Node ID
and wait to script install complete
### *This step gen wallet and Please write you mnemonic phrase.



## Select Option 4 Restart
and wait to script install complete

![image](https://user-images.githubusercontent.com/83507970/229556254-406f0a1f-32ec-4a14-9c06-f0671a67d105.png)


## Select Option 6 Quit
for quick menu




## 2. Useful commands

Check Service Status

```
systemctl status celestia-lightd
```

Check Logs

```
journalctl -u celestia-lightd.service -f
```


Restart Node

```
systemctl restart celestia-lightd
```


Stop Node

```
systemctl stop celestia-lightd
```


List Wallet

```
./cel-key list --node.type light --keyring-backend test --p2p.network blockspacerace
```







