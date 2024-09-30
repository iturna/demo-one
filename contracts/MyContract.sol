//SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract MyContract {

    bytes public ourString = "World!123123";

    function updateOurString(bytes _updateString) public {
        ourString = _updateString;
    }
    
}