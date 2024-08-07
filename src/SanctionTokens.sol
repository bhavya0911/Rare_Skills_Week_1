//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SanctionTokens is ERC20, ERC20Permit, Ownable {
    mapping(address => bool) private sanctioned;

    constructor() ERC20("Test", "TST") ERC20Permit("Test") Ownable(msg.sender) {}

    function isSanctioned(address user) public view returns (bool) {
        return sanctioned[user];
    }

    function setSanction(address user, bool value) public onlyOwner {
        sanctioned[user] = value;
    }

    function mint(address user, uint256 amount) public onlyOwner {
        _mint(user, amount);
    }

    function burn(address user, uint256 amount) public onlyOwner {
        _burn(user, amount);
    }

    function _update(address from, address to, uint256 value) internal override {
        require(!sanctioned[from], "Cannot deal with banned address");
        require(!sanctioned[to], "Cannot deal with banned address");
        super._update(from, to, value);
    }
}
