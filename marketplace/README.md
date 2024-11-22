## Marketplace

## Usage

### Build

```bash
$ forge build
```

### Test

```bash
$ forge test
```

### Deploy

- create `.env` file

```bash
$ cp .env.example .env
```

#### Deploy Local Node

- tab 1

```bash
$ anvil
```

- copy `PRIVATE_KEY` in `.env` file

- tab 2

```bash
$ source .env
$ forge script script/Marketplace.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```


#### Deploy Testnet

```bash
$ forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY src/Marketplace.sol:Marketplace
```

### Run Contract

#### mint nft

```bash
$ cast send <NFT_CONTRACT_ADDRESS> "safeMint(address,string)" <TO_ADDRESS> <TOKEN_URI> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast send 0x5fbdb2315678afecb367f032d93f642f64180aa3 "safeMint(address,string)" "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" "https://example.com" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

#### Check balance nft

```bash
$ cast call <NFT_CONTRACT_ADDRESS>  "balanceOf(address)" <ADDRESS> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "balanceOf(address)" "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

#### Check owner nft

```bash
$ cast call <NFT_CONTRACT_ADDRESS> "ownerOf(uint256)" <TOKEN_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "ownerOf(uint256)" 0 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

#### Approve nft

```bash
$ cast send <NFT_CONTRACT_ADDRESS> "setApprovalForAll(address,bool)" <OPERATOR_ADDRESS> true --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast send 0x5fbdb2315678afecb367f032d93f642f64180aa3 "setApprovalForAll(address,bool)" "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512" true --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

#### Check approved nft

```bash
$ cast call <NFT_CONTRACT_ADDRESS> "isApprovedForAll(address,address)" <OWNER_ADDRESS> <OPERATOR_ADDRESS> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "isApprovedForAll(address,address)" "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### List NFT

```bash
$ cast send <MARKETPLACE_CONTRACT_ADDRESS> "listNFT(uint256,bool,uint256,uint256,address,uint256)" <PRICE> <IS_AUCTION> <AUCTION_START> <AUCTION_END> <NFT_CONTRACT_ADDRESS> <TOKEN_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast send 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "listNFT(uint256,bool,uint256,uint256,address,uint256)" 1000000000000000000 false 0 0 0x5fbdb2315678afecb367f032d93f642f64180aa3 0 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### Check listed NFT

```bash
$ cast call <MARKETPLACE_CONTRACT_ADDRESS> "items(uint256)" <ITEM_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast call 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "items(uint256)" 1 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### Buy NFT

```bash
$ cast send <MARKETPLACE_CONTRACT_ADDRESS> "buyNFT(uint256)" <ITEM_ID> --value <PRICE> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast send 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "buyNFT(uint256)" 1 --value 1000000000000000000 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```


### Check bought NFT

```bash
$ cast call <NFT_CONTRACT_ADDRESS> "ownerOf(uint256)" <TOKEN_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

- example

```bash
$ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "ownerOf(uint256)" 0 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```
