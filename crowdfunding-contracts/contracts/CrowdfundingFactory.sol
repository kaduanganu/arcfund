// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICampaign {

function initialize(

        address creator,

        address treasury,

        address usdc,

        uint256 targetAmount,

        uint256 deadline,

        string memory title,

        string memory description

    ) external;
}

contract CrowdfundingFactory {

    using Clones for address;

    address public owner;

    address public treasury;

    address public implementation;

    IERC20 public usdc;

    uint256 public creationFee;

    address[] public campaigns;

    mapping(address => address[])
        public campaignsByCreator;

    event CampaignCreated(

        address indexed creator,

        address campaign,

        uint256 createdAt
    );

    modifier onlyTreasury() {

        require(

            msg.sender == treasury,

            "Treasury only"
        );

        _;
    }

    constructor(

        address _implementation,

        address _usdc,

        address _treasury,

        uint256 _creationFee

    ) {

        owner = msg.sender;

        treasury = _treasury;

        implementation =
            _implementation;

        usdc = IERC20(
            _usdc
        );

        creationFee =
            _creationFee;
    }

    function createCampaignFor(

        address creator,

        uint256 targetAmount,

        uint256 deadline,

        string calldata title,

        string calldata description

    )

        external

        onlyTreasury

        returns (address)

    {

        address clone =
            implementation.clone();

ICampaign(clone)
    .initialize(

        creator,

        treasury,

        address(usdc),

        targetAmount,

        deadline,

        title,

        description
    );

        campaigns.push(
            clone
        );

        campaignsByCreator[
            creator
        ].push(
            clone
        );

        emit CampaignCreated(

            creator,

            clone,

            block.timestamp
        );

        return clone;
    }

    function collectCreationFee(
        address payer
    )
        external
        onlyTreasury
    {

        bool success =
            usdc.transferFrom(

                payer,

                treasury,

                creationFee
            );

        require(
            success,
            "Fee failed"
        );
    }

    function getCampaigns()

        external

        view

        returns (

            address[] memory

        )

    {

        return campaigns;
    }

    function getCampaignsByCreator(

        address creator

    )

        external

        view

        returns (

            address[] memory

        )

    {

        return campaignsByCreator[
            creator
        ];
    }

    function updateImplementation(

    address newImplementation

)

    external

{

    require(

        msg.sender == owner,

        "Owner only"

    );

    implementation =
        newImplementation;
}
}