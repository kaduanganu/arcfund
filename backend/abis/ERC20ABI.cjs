const ERC20_ABI = [

    "function approve(address spender, uint256 amount) returns (bool)",

    "function transfer(address to, uint256 amount) returns (bool)",

    "event Transfer(address indexed from, address indexed to, uint256 value)"
];

  module.exports = { ERC20_ABI };