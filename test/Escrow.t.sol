//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow public escrow;

    function setUp() public {
        escrow = new Escrow();
    }

    function testUpdate() public {}
}
