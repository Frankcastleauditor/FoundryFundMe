// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fund-me.sol";
import {deployFundMe} from "../../script/deployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address network;
    address alice = makeAddr("alice");
    address Bob = makeAddr("Bob");
    uint256 constant GAS_PRICE = 2;

    // us call the test to make a new contract so the test is the owner
    function setUp() external {
        deployFundMe deployfundme = new deployFundMe();
        fundMe = deployfundme.run();
    }

    function testminimum() external {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testownerismsg() external {
        console.log(msg.sender);

        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testTheVersion() external {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailedWithOutEnoughtETH() external {
        vm.expectRevert(bytes("You need to spend more ETH!")); // to pass this test the next call should revert should be failed
        fundMe.fund{value: 1e15}();
    }

    function testfundUpdateStorageVariable() external {
        vm.prank(alice);
        vm.deal(alice, 10 ether);
        fundMe.fund{value: 10e18}();
        vm.prank(Bob);
        vm.deal(Bob, 10 ether);
        fundMe.fund{value: 9e18}();
        assertEq(fundMe.addressToAmountFunded(alice), 10e18);
        assertEq(fundMe.funders(0), alice);
        assertEq(fundMe.addressToAmountFunded(Bob), 9e18);
        assertEq(fundMe.funders(1), Bob);
    }

    modifier funded() {
        vm.prank(alice);
        vm.deal(alice, 10e18);
        fundMe.fund{value: 10e18}();
        _;
    }

    function testWithdraw() external funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }
}
// the owner of fundMe is FundMeTest
