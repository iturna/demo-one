//SPDX-Licence-Identifier: MIT

pragma solidity 0.8.26;

contract MyContract {

    string public ourString = "World!123123";

    function updateOurString(string memory _updateString) public {
        ourString = _updateString;
    }
}