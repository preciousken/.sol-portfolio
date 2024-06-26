# Smart Energy Token smart Contract Documentation

This README provides an overview of the functionalities and usage of the Smart Energy Token and ICO smart contract.

The Deployed Token smart contract: 0x4c5d8d027e97b52542dc66399752c76e017dc6e9

ICO smart contract: 0xe82d9249a8b8903e0bdb3784fb3a6d1d995e9cab

## Overview of Smart Energy Token

### Token Initialization

- The constructor initializes the token with the name "Smart Energy Token" and the symbol "SET".
- It mints an initial supply of 500 billion tokens to the deployer's address (msg.sender), multiplied by 10^decimals where decimals is the number  of decimal places (usually 18 in this case).

### Token Features:

- Users can transfer tokens to other addresses using the transfer function.
- Users can approve other addresses to spend tokens on their behalf using the approve function.
- Users can transfer tokens on behalf of another address if allowed using the transferFrom function.
- Token holders can burn their own tokens using the burn function, reducing the total supply.
- Token holders can also burn tokens from another account if allowed, using the burnFrom function.

## Overview of ICO

### Initialization
- Initializes the contract with the Smart EnergyT Token address and the token price in Wei. Only the contract deployer becomes the initial owner.
### Featurns
#### To use the ICO contract, follow these steps:
##### 1. Token Purchase Function (buyTokens):
- Allows users to buy tokens by sending ETH to the contract.
- Users specify the number of tokens they want to buy.
- The contract calculates the total cost based on the number of tokens requested and the token price.
- Users must send enough ETH to cover the total cost.
- Upon successful purchase, tokens are transferred to the buyer, and ETH equivalent to the total cost is transferred to the contract owner.

##### 2. Token Recovery Function (recoverToken):
- Allows the contract owner to recover any excess tokens left in the contract.
- Retrieves the token balance of the contract and transfers the entire balance of tokens to the owner's address.

##### 3. Available Token Function (availableToken):
- Allows external callers to check the balance of tokens held by the ICO contract.


## Contract Deploy steps
1. Deploy Smart Energy Token contract first 
2. Deploy ICO using Smart Energy Token contract address and price of token in Wei.(if you want set price 0.001 just convert it into Wei 1000000000000000)

## How to depoly contract on mainnet

## Prerequisites

- Install the MetaMask browser extension and set up your Ethereum account.
- Access Remix IDE in your web browser.

## Steps

1. **Compile Smart Contract:**
   - Open Remix and go to the "Solidity Compiler" tab.
   - Select the appropriate compiler version for your contract.
   - Write or import your smart contract code.
   - Click on the "Compile" button to compile the contract.

2. **Deploy Contract:**
   - Switch to the "Deploy & Run Transactions" tab in Remix.
   - Choose "Injected Provider MetaMask" as the environment to connect Remix with MetaMask.
   - Ensure MetaMask is unlocked and set to the mainnet.
   - Select the contract to deploy from the dropdown menu.
   - Enter any constructor parameters required by your contract (if applicable).
   - Click on the "Deploy" button to initiate the deployment.

3. **Confirm Transaction in MetaMask:**
   - MetaMask will open a popup window showing the deployment transaction details.
   - Review the gas fee and other details.
   - Click "Confirm" to submit the transaction.

4. **View Contract Address:**
   - After successful deployment, Remix will display the deployed contract's address.
   - Copy this contract address for future interactions with your contract.

## Troubleshooting

- If the deployment fails, check for error messages in Remix or MetaMask for more details.
- Ensure your MetaMask account has enough ETH to cover gas fees for the transaction.

## BSC Testnet Transaction
```
Smart Energy Token contract testnet address
[Smart Energy Token contract](https://testnet.bscscan.com/address/0x479ff45f7BCe645CCca22B33ADcac0c664Cd0B45#code)

ICO smart contract testnet address
      I have set token price 1 Wei for testing purpose
[ICO SMART CONTRACT](https://testnet.bscscan.com/address/0xE99f24451335D85111040527097756B292B5cAc9#code)

Sent token to ICO contract
https://testnet.bscscan.com/tx/0xf0ab87b6d161bcc7f5bf960325099af4adb02056e7affec65e50843024e0aa1b

Buy token
https://testnet.bscscan.com/tx/0xc7ed8973fecf69c8123f42b7cd9c3605593947288040919a4104187ed649bc08

Transfer ownership using owner address
https://testnet.bscscan.com/tx/0x6b6ecc0edc49a2b01340a3964d383abcfddaf68a6ae1e243b0d2e62f1e981c1d

recover token using owner address
https://testnet.bscscan.com/tx/0x1127122350f3c86d3103fb102b27eb2d2663a0818650c239b2f84c9d00848777

Notes

- Ensure you are connected to the BSC Testnet network on your MetaMask to view these transactions and contracts.
- Check transaction details for gas fees and confirmations.
```
