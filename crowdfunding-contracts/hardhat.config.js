require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",

  networks: {
    arc: {
      url: process.env.ARC_RPC,
      chainId: 5042,
      accounts: [process.env.PRIVATE_KEY]
    }
  },

  etherscan: {
    apiKey: {
      arc: "proapi_GLHMWKBb6Cmk6NdLqLF7byt5Yd5DItotyYsp2dC57XsDNBQVRsiIG36op5Etd1eO_dhp952" // Blockscout ignores the value, but Hardhat requires one
    },
    customChains: [
      {
        network: "arc",
        chainId: 5042,
        urls: {
          apiURL: "https://api.blockscout.com/v2/api?chain_id=5042",
          browserURL: "https://explorer.arc.io"
        }
      }
    ]
  }
};