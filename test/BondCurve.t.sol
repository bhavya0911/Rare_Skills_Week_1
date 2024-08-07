//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/BondCurve.sol";

contract BondCurveTest is Test {
    BondCurve public bondCurve;

    function setUp() public {
        bondCurve = new BondCurve();
    }

    function testBuy() public {}

    function testSell() public {}

    function testCalculateBuyPrice() public {}

    function testCalculateSellPrice() public {}
}
