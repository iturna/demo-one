// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("TokenB", "TKB") {
        // İlk bakiyeyi dağıtmak için belirli bir miktar belirleyin
        _mint(msg.sender, 1000000 * 10 ** decimals()); // 1,000,000 token üret
    }
}