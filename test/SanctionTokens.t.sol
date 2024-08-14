//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/SanctionTokens.sol";

contract SanctionTokenHarness is SanctionTokens {
    function mint(address user, uint256 amount) external onlyOwner {
        _mint(user, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}

contract SanctionTest is Test {
    SanctionTokenHarness public sanctionTokens;
    address public sender = vm.addr(13423152352);
    address public sanction = vm.addr(1);
    uint256 amount = 100;

    function setUp() public {
        vm.prank(sender);
        sanctionTokens = new SanctionTokenHarness();
    }

    function testIsSactioned() public view {
        assertEq(sanctionTokens.isSanctioned(sender), false);
        assertEq(sanctionTokens.isSanctioned(sanction), false);
    }

    function testSetSanction() public {
        sanctionIsSetAsExpected();
        nonOwnerIsReverted();
    }

    function testTokenSanctions() public {
        assertEq(sanctionTokens.owner(), sender);

        vm.startPrank(sender);

        assertEq(sanctionTokens.isSanctioned(sanction), false);

        sanctionTokens.mint(sanction, amount);
        assertEq(sanctionTokens.balanceOf(sanction), amount);

        vm.expectEmit();
        emit sanctionSet(sanction, true);
        sanctionTokens.setSanction(sanction, true);
        assertEq(sanctionTokens.isSanctioned(sanction), true);

        //mint check
        vm.expectRevert("Cannot deal with banned address");
        sanctionTokens.mint(sanction, amount);

        vm.stopPrank();

        vm.startPrank(sanction);

        //burn check
        vm.expectRevert("Cannot deal with banned address");
        sanctionTokens.burn(amount);

        //transfer check
        vm.expectRevert("Cannot deal with banned address");
        sanctionTokens.transfer(sender, amount);
        vm.stopPrank();
    }

    function sanctionIsSetAsExpected() private {
        assertEq(sanctionTokens.owner(), sender);

        vm.startPrank(sender);

        assertEq(sanctionTokens.isSanctioned(sanction), false);
        vm.expectEmit();
        emit sanctionSet(sanction, true);
        sanctionTokens.setSanction(sanction, true);
        assertEq(sanctionTokens.isSanctioned(sanction), true);

        vm.expectEmit();
        emit sanctionSet(sanction, false);
        sanctionTokens.setSanction(sanction, false);
        assertEq(sanctionTokens.isSanctioned(sanction), false);

        vm.stopPrank();
    }

    function nonOwnerIsReverted() private {
        assertNotEq(sanctionTokens.owner(), sanction);

        vm.expectRevert();
        vm.prank(sanction);
        sanctionTokens.setSanction(sender, true);
    }
}
