//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/SanctionTokens.sol";

contract SanctionTest is Test {
    SanctionTokens public sactionTokens;
    address public randomWallet;

    function setUp() public {
        sactionTokens = new SanctionTokens();

        randomWallet = vm.addr(1);

        vm.deal(randomWallet, 1000 ether);
    }

    function testIsSactioned() public {}

    function testSetSanction() public {}

    function testTokenSanctions() public {}
}
