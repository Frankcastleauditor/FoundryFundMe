// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol"; // import the script

import {FundMe} from "../src/fund-me.sol"; // import our contract that we need to deploy

import {HelperConfig} from "./helpConfig.s.sol"; // import helperconfig to configerate the network

contract deployFundMe is Script {
    address network;
    address addressConfig;

    function run() external returns (FundMe) {
        // this befor the broadcast beacuse we dont need to send tx that cost gas to select the network
        HelperConfig helperConfig = new HelperConfig();
        addressConfig = helperConfig.activeNetWorkConfig();
        vm.startBroadcast(); //start broadcast
        // we dont want to hard code this address beacuse this work only with sepolia
        // we will mock this

        FundMe fundMe = new FundMe(addressConfig); // create an instance from our contract

        vm.stopBroadcast(); // you should inherit the script contract to identify vm
        return fundMe;
    }
}
