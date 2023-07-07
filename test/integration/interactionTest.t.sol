// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fund-me.sol";
import {deployFundMe} from "../../script/deployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract interactionsTest is Test {
    FundMe public fundMe;

    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;

    address public constant USER = address(1);

    function setUp() external {
        deployFundMe deploy = new deployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testUserCanFundinteraction() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }
}
