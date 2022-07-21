# Setting Up A Celestia Validator Node 

## Hardware Requirements
The following hardware minimum requirements are recommended for running the validator node:

>:black_square_button:  OS Ubuntu 18.04 - 22.04<br> 
>:black_square_button:Memory: 8 GB RAM<br> 
>:black_square_button:CPU: Quad-Core<br> 
>:black_square_button:Disk: 250 GB SSD Storage<br> 
>:black_square_button:Bandwidth: 1 Gbps for Download/100 Mbps for Upload<br> 
>:black_square_button:TCP Port: 26656,26657,26660,9090<br>

## 1. Setup Validator Node

```

wget -q -O Mamaki.sh https://raw.githubusercontent.com/NunoyHaxxana/Celestia/main/Mamaki.sh && chmod +x Mamaki.sh && sudo /bin/bash Mamaki.sh
```

## 2. Setup Bridge Node

```

wget -q -O Bridge_Node.sh https://raw.githubusercontent.com/NunoyHaxxana/Celestia/main/Bridge_Node.sh && chmod +x Bridge_Node.sh && sudo /bin/bash Bridge_Node.sh
```



## 3. Connect Validator

```

wget -q -O create-validator.sh https://raw.githubusercontent.com/NunoyHaxxana/Celestia/main/create-validator.sh && chmod +x create-validator.sh && sudo /bin/bash create-validator.sh
```

