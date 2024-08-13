//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract BondCurve is ERC20, ERC20Permit {
    constructor() ERC20("Test", "TST") ERC20Permit("Test") {}

    function buy(uint256 amount) public payable {
        require(amount != 0, "Cannot buy 0 tokens");

        uint256 price = calculateBuyPrice(amount);
        require(price <= msg.value, "Not enough eth");
        uint256 excessEth = msg.value - price;

        _mint(msg.sender, amount);

        if (excessEth != 0) {
            (bool success,) = msg.sender.call{value: excessEth}("");
            require(success, "Eth transfer failed");
        }
    }

    function sell(uint256 amount, uint256 mininumAmount) public {
        require(amount != 0, "Cannot sell 0 tokens");

        uint256 amountToSend = calculateSellPrice(amount);
        require(amountToSend >= mininumAmount, "Cannot get minimum amount");

        _burn(msg.sender, amount);

        (bool success,) = msg.sender.call{value: amountToSend}("");
        require(success, "Eth transfer failed");
    }

    function calculateBuyPrice(uint256 amount) public view returns (uint256 price) {
        uint256 initialSupply = totalSupply();
        uint256 finalSupply = initialSupply + amount;
        price = (amount * (finalSupply + initialSupply)) / (2 * 10 ** 18);
    }

    function calculateSellPrice(uint256 amount) public view returns (uint256 price) {
        uint256 initialSupply = totalSupply();
        if (amount != initialSupply) {
            require(amount < initialSupply, "Cannot sell more than totalSupply");
            uint256 finalSupply = initialSupply - amount;
            price = (amount * (finalSupply + initialSupply)) / (2 * 10 ** 18);
        } else {
            price = (amount * initialSupply) / (2 * 10 ** 18);
        }
    }
}
