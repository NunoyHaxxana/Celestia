sudo systemctl stop celestia-appd && journalctl -u celestia-appd -f -o cat

# set P2P Configuration Options
max_num_inbound_peers=0
max_num_outbound_peers=0
max_connections=45

sed -i -e "s/^use-legacy *=.*/use-legacy = false/;\
s/^max-num-inbound-peers *=.*/max-num-inbound-peers = $max_num_inbound_peers/;\
s/^max-num-outbound-peers *=.*/max-num-outbound-peers = $max_num_outbound_peers/;\
s/^max-connections *=.*/max-connections = $max_connections/" $HOME/.celestia-app/config/config.toml

rm -rf $HOME/.celestia-app/data/peerstore.db

sudo systemctl start celestia-appd && journalctl -u celestia-appd -f -o cat

curl -s localhost:26657/net_info | grep n_peers
