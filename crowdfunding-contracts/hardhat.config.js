require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
    solidity: "0.8.24",

    networks: {
        arc: {
            url: process.env.ARC_RPC,
            accounts: [process.env.PRIVATE_KEY]
        }
    }
};