// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SMLToken is ERC20 {
    constructor() ERC20("SML Token", "SML") {
        // Mint initial supply to the contract creator (owner)
        //_mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    // Optional: function to mint more tokens (only the owner can call)
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
