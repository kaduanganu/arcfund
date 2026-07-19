require("dotenv").config();

const { ethers } = require("hardhat");

async function main() {
    const creationFee = ethers.parseUnits("1", 6);

    const Campaign = await ethers.getContractFactory("Campaign");

    const implementation = await Campaign.deploy();

    await implementation.waitForDeployment();

    const implementationAddress =
        await implementation.getAddress();

    console.log(
        "Campaign implementation:",
        implementationAddress
    );

    const Factory = await ethers.getContractFactory(
        "CrowdfundingFactory"
    );

    const factory = await Factory.deploy(
        implementationAddress,
        process.env.ARC_USDC,
        process.env.TREASURY,
        creationFee
    );

    await factory.waitForDeployment();

    console.log(
        "Factory:",
        await factory.getAddress()
    );
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});