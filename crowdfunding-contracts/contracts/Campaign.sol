// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Campaign {

    address public factory;

    address public treasury;

    address public creator;

    IERC20 public usdc;

    uint256 public targetAmount;

    uint256 public currentAmount;

    uint256 public deadline;

    uint256 public createdAt;

    string public title;

    string public description;

    bool public withdrawn;

    bool private initialized;

    mapping(address => uint256) public contributions;

    address[] public contributors;

    event Deposited(
        address indexed contributor,
        uint256 amount
    );

    event Withdrawn(
        address indexed creator,
        uint256 amount
    );

    modifier onlyCreator() {
        require(
            msg.sender == creator,
            "Not creator"
        );
        _;
    }

    function initialize(
        address _creator,
        address _treasury,
        address _usdc,
        uint256 _targetAmount,
        uint256 _deadline,
        string memory _title,
        string memory _description
    ) external {

        require(
            !initialized,
            "Already initialized"
        );

        require(
            _deadline > block.timestamp,
            "Invalid deadline"
        );

        require(
            _targetAmount > 0,
            "Invalid target"
        );

        initialized = true;

        factory = msg.sender;

        creator = _creator;

        treasury = _treasury;

        usdc = IERC20(_usdc);

        targetAmount = _targetAmount;

        deadline = _deadline;

        title = _title;

        description = _description;

        createdAt = block.timestamp;
    }

    function deposit(
        uint256 amount
    ) external {

        require(
            block.timestamp < deadline,
            "Campaign ended"
        );

        require(
            amount > 0,
            "Invalid amount"
        );

        bool success = usdc.transferFrom(
            msg.sender,
            address(this),
            amount
        );

        require(
            success,
            "Transfer failed"
        );

        if (
            contributions[msg.sender] == 0
        ) {
            contributors.push(
                msg.sender
            );
        }

        contributions[msg.sender] += amount;

        currentAmount += amount;

        emit Deposited(
            msg.sender,
            amount
        );
    }

function depositFor(

    address contributor,

    uint256 amount

) external {

    require(
        msg.sender == treasury,
        "Treasury only"
    );

    require(
        block.timestamp < deadline,
        "Campaign ended"
    );

    require(
        amount > 0,
        "Invalid amount"
    );

    bool success = usdc.transferFrom(

        treasury,

        address(this),

        amount
    );

    require(
        success,
        "Transfer failed"
    );

    if (

        contributions[
            contributor
        ] == 0

    ) {

        contributors.push(
            contributor
        );
    }

    contributions[
        contributor
    ] += amount;

    currentAmount += amount;

    emit Deposited(

        contributor,

        amount
    );
}

function creditDeposit(
    address contributor,
    uint256 amount
) external {

    require(
        msg.sender == treasury,
        "Treasury only"
    );

    if (contributions[contributor] == 0) {
        contributors.push(contributor);
    }

    contributions[contributor] += amount;

    currentAmount += amount;

    emit Deposited(
        contributor,
        amount
    );
}

    function canWithdraw()
        public
        view
        returns (bool)
    {
        return
            currentAmount >= targetAmount ||
            block.timestamp >= deadline;
    }

    function withdraw()
        external
        onlyCreator
    {

        require(
            canWithdraw(),
            "Cannot withdraw"
        );

        require(
            !withdrawn,
            "Already withdrawn"
        );

        withdrawn = true;

        uint256 amount =
            currentAmount;

        bool success =
            usdc.transfer(
                creator,
                amount
            );

        require(
            success,
            "Transfer failed"
        );

        emit Withdrawn(
            creator,
            amount
        );
    }

    function getDetails()
        external
        view
        returns (

            address,

            uint256,

            uint256,

            uint256,

            uint256,

            string memory,

            string memory,

            bool,

            uint256

        )
    {
        return (

            creator,

            targetAmount,

            currentAmount,

            deadline,

            createdAt,

            title,

            description,

            withdrawn,

            contributors.length
        );
    }
}