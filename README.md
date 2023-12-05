## NoogaNaega Red NFT smart contract used on Goerli test network.

This is a Solidity smart contract for a non-fungible token (NFT) collection named "NoogaNaega". 

It inherits from several OpenZeppelin libraries, including ERC721 for implementing the NFT standard, Ownable for setting an owner who has special permissions, ReentrancyGuard for preventing reentrancy attacks, and PaymentSplitter for automatically distributing funds to a list of addresses and percentages.

The contract has several variables and functions that can be used to manage the NFT collection. It has a maximum supply of 9001 tokens, and each transaction can mint up to 10 tokens at once. 

The publicMint function allows users to mint tokens, but only when the contract is not paused, the amount requested is greater than zero, and the current total number of tokens plus the amount requested is less than or equal to the maximum supply. 

Additionally, the price for each token is set at 0.01 ETH for testing purposes, and the function checks that the total payment amount is sufficient to cover the cost of the requested tokens.

The mintInternal function is used to actually mint the tokens, and it increments the token ID counter and mints a new token to the message sender.

The setBaseURI and setBaseExtension functions can be used to set the base URI and base extension for the tokens' metadata. The tokenURI function is used to construct the token's URI, which is a concatenation of the base URI, the token ID, and the base extension.

Finally, the contract includes the totalSupply function to get the current total number of tokens minted.


## Security audit of our smart contract

1. No critical vulnerabilities were identified in this smart contract. However, as a best practice, it is always recommended to perform a thorough code review and testing to identify and mitigate any possible security threats.

2. This contract imports several widely used OpenZeppelin libraries such as ERC721, Ownable, ReentrancyGuard, PaymentSplitter, and Counters which are extensively tested and secure.
The contract has a paused state which can be used to temporarily disable publicMint function, thus avoiding reentrancy attacks.

3. The onlyAccounts modifier ensures that minting can only be done from externally-owned accounts (EOAs) rather than smart contracts, which can prevent some attack vectors.

4. The contract uses the SafeMath library from OpenZeppelin to prevent overflows and underflows.

5. The smart contract is well-structured and follows best practices such as using require for input validation, using view functions to prevent state changes, and using public and external keywords to enforce function access.

Overall, the contract is well-written and secure, but it's still recommended to perform a thorough code review and testing to identify and mitigate any possible security threats.


