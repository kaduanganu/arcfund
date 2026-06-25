// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/Vault.sol";

contract DeployVault is Script {

    function run() external returns (Vault vault) {

        uint256 privateKey =
            vm.envUint("PRIVATE_KEY");

        address usdcAddress =
            vm.envAddress("USDC_ADDRESS");

        vm.startBroadcast(privateKey);

        vault = new Vault(
            usdcAddress
        );

        vm.stopBroadcast();

        console.log(
            "Vault deployed at:",
            address(vault)
        );

        console.log(
            "USDC:",
            usdcAddress
        );

        console.log(
            "Owner:",
            vault.owner()
        );
    }
}