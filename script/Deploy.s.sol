// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/Vault.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        Vault vault = new Vault(
            0x3600000000000000000000000000000000000000
        );

        console.log(
            "Vault deployed:",
            address(vault)
        );

        vm.stopBroadcast();
    }
}