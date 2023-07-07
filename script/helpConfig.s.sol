// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";

// if we are in anvil we will deploy mocks
// if we on real chains we will grab their addresses from the live network

// deploy mocks when we are on local chain anvil
// keep track of the different price feed address across multipul chains
// ETH/USD    on sepolia
// ETH/USD    on the mainnet
contract HelperConfig is Script {
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;

    struct networkConfig {
        address priceFeed; //ETH/USD
    }

    networkConfig public activeNetWorkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetWorkConfig = getSepoliaPriceFeedAddress();
        } else if (block.chainid == 1) {
            activeNetWorkConfig = getMainnetPriceFeedAddress();
        } else {
            activeNetWorkConfig = getAnvilPriceFeedAddress();
        }
    }

    function getSepoliaPriceFeedAddress()
        public
        pure
        returns (networkConfig memory)
    {
        networkConfig memory sepoliaConfig = networkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetPriceFeedAddress()
        public
        pure
        returns (networkConfig memory)
    {
        networkConfig memory mainnetConfig = networkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    function getAnvilPriceFeedAddress() public returns (networkConfig memory) {
        // deploy the mocks (fake addresses that we own)
        // return the mock address

        if (activeNetWorkConfig.priceFeed != address(0)) {
            // if we have alraedy deploy one we dont need a new one
            return activeNetWorkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_PRICE); // magic numbers is bad
        vm.stopBroadcast();

        networkConfig memory anvilConfig = networkConfig({
            priceFeed: address(mock)
        });
        return (anvilConfig);
    }
}
