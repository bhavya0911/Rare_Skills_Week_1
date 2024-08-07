//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BondCurve is ERC20, ERC20Permit, ReentrancyGuard {
    uint256 private constant TO_ETH = 1 ether;

    constructor() ERC20("Test", "TST") ERC20Permit("Test") {}

    function buy(uint256 amount) public payable {
        uint256 price = _calculateBuyPrice(amount);
        require(price * TO_ETH <= msg.value, "Not enough eth");

        _mint(msg.sender, amount);
    }

    function sell(uint256 amount) public nonReentrant {
        uint256 amountToSend = _calculateSellPrice(amount);
        _burn(msg.sender, amount);
        (bool success,) = msg.sender.call{value: amountToSend}("");
        require(success, "Eth transfer failed");
    }

    function calculateBuyPrice(uint256 amount) public view returns (uint256 price) {
        return _calculateBuyPrice(amount);
    }

    function calculateSellPrice(uint256 amount) public view returns (uint256 price) {
        return _calculateSellPrice(amount);
    }

    function _calculateBuyPrice(uint256 amount) private view returns (uint256 price) {
        uint256 initialSupply = totalSupply();
        uint256 finalSupply = initialSupply + amount - 1;
        price = amount * (finalSupply + initialSupply) / 2;
    }

    function _calculateSellPrice(uint256 amount) private view returns (uint256 price) {
        uint256 initialSupply = totalSupply();
        if (amount != initialSupply) {
            require(amount < initialSupply, "Cannot sell more than totalSupply");
            uint256 finalSupply = initialSupply - amount - 1;
            price = amount * (finalSupply + initialSupply) / 2;
        } else {
            price = (amount - 1) * initialSupply / 2;
        }
    }
}
