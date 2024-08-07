//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/GodMode.sol";

contract GodModeTest is Test {
    GodMode public godMode;

    function setUp() public {
        godMode = new GodMode();
    }

    function testUpdate() public {}
}
