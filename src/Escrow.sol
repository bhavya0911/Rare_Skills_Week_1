//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

event newListing(address indexed maker, bytes32 indexed salt);

event claimed(address indexed maker, bytes32 indexed salt);

event refunded(address indexed maker, address indexed taker, address indexed ERC20Address);

struct listing {
    address maker;
    address taker;
    address ERC20Address;
    uint256 creationTimestamp;
    uint256 amountOfCoins;
    uint256 ethRequired;
}

contract Escrow is ReentrancyGuard {
    uint256 private constant THREE_DAYS = 3 days;

    mapping(bytes32 => listing) listings;

    constructor() {}

    function createListing(address ERC20Token, uint256 amount, address taker, uint256 requiredEth)
        external
        nonReentrant
    {
        IERC20 token = IERC20(ERC20Token);
        require(token.allowance(msg.sender, address(this)) >= amount, "Don't have allowance to transfer tokens");
        require(token.balanceOf(msg.sender) >= amount, "Don't have enough balance for given amount");

        token.transferFrom(msg.sender, address(this), amount);

        listing memory construct = listing(msg.sender, taker, ERC20Token, block.timestamp, amount, requiredEth);
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, taker, ERC20Token));
        listings[salt] = construct;

        emit newListing(msg.sender, salt);
    }

    function claimListing(address maker, address ERC20Token) external payable {
        bytes32 salt = getSalt(maker, msg.sender, ERC20Token);
        listing memory info = listings[salt];

        require(
            info.taker == msg.sender && info.creationTimestamp + THREE_DAYS >= block.timestamp
                && info.ethRequired <= msg.value,
            "Wrong sender, not enough eth or time elapsed"
        );

        delete listings[salt];

        (bool success) = IERC20(info.ERC20Address).transfer(msg.sender, info.amountOfCoins);
        require(success, "Unsuccessful coin transfer");

        (bool successEth,) = info.maker.call{value: info.ethRequired}("");
        require(successEth, "Unsuccessful eth transfer");

        emit claimed(info.maker, salt);
    }

    function refundAndCloseListing(address taker, address ERC20Address) external {
        bytes32 salt = getSalt(msg.sender, taker, ERC20Address);
        listing memory info = listings[salt];

        require(
            info.maker == msg.sender && info.creationTimestamp + THREE_DAYS <= block.timestamp,
            "Cannot cancel after 3 days"
        );

        delete listings[salt];
        emit refunded(msg.sender, taker, ERC20Address);

        (bool success) = IERC20(info.ERC20Address).transfer(msg.sender, info.amountOfCoins);
        require(success, "Unsuccessful coin transfer");
    }

    function getSalt(address maker, address taker, address ERC20Address) public pure returns (bytes32 salt) {
        salt = keccak256(abi.encodePacked(maker, taker, ERC20Address));
    }
}
