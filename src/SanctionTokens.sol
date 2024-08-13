//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

event sanctionSet(address indexed user, bool indexed value);

contract SanctionTokens is ERC20, ERC20Permit, Ownable2Step {
    mapping(address => bool) private sanctioned;

    constructor() ERC20("Test", "TST") ERC20Permit("Test") Ownable(msg.sender) {}

    function isSanctioned(address user) public view returns (bool) {
        return sanctioned[user];
    }

    function setSanction(address user, bool value) public onlyOwner {
        sanctioned[user] = value;
        emit sanctionSet(user, value);
    }

    function _update(address from, address to, uint256 value) internal override {
        require(!sanctioned[from], "Cannot deal with banned address");
        require(!sanctioned[to], "Cannot deal with banned address");
        super._update(from, to, value);
    }
}
