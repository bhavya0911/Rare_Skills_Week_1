//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow public escrow;

    function setUp() public {
        escrow = new Escrow();
    }

    function testUpdate() public {
        escrow.createListing(
            0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97, 1, 0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97, 5
        );
    }
}
