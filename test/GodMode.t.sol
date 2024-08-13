//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../src/GodMode.sol";

contract GodModeHarness is GodMode {
    function mint(address[] memory users, uint256 amount) external {
        for (uint256 i; i < users.length; i++) {
            _mint(users[i], amount);
        }
    }

    function burn(address user, uint256 amount) external {
        _burn(user, amount);
    }
}

contract GodModeTest is Test {
    GodModeHarness public godMode;
    address sender = vm.addr(113045314135);
    address addr1 = vm.addr(1);
    uint256 baseAmount = 1000000;

    function setUp() public {
        vm.prank(sender);
        godMode = new GodModeHarness();
        address[] memory mintTo = new address[](2);
        mintTo[0] = sender;
        mintTo[1] = addr1;
        godMode.mint(mintTo, baseAmount);
    }

    function testUpdate() public {
        ownerIsAbleToUpdate();
        nonOwnerIsReverted();
    }

    function ownerIsAbleToUpdate() private {
        uint256 amount = 100;
        assertEq(godMode.owner(), sender);

        //transfer to any address
        vm.prank(sender);
        godMode.update(addr1, sender, amount);
        assertEq(godMode.balanceOf(addr1), baseAmount - amount);
        assertEq(godMode.balanceOf(sender), baseAmount + amount);

        //mint to any address
        vm.prank(sender);
        godMode.update(address(0), addr1, amount);
        assertEq(godMode.balanceOf(addr1), baseAmount);

        //burn from any address
        vm.prank(sender);
        godMode.update(addr1, address(0), amount);
        assertEq(godMode.balanceOf(addr1), baseAmount - amount);
    }

    function nonOwnerIsReverted() private {
        uint256 amount = 100;
        assertNotEq(godMode.owner(), addr1);

        vm.expectRevert();
        vm.prank(addr1);
        godMode.update(sender, addr1, amount);
    }
}
