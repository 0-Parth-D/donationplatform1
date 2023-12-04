// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Donation {
    struct Support {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Support) public allSupports;

    uint256 public numberOfSupports = 0;

    function createSupport(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Support storage support = allSupports[numberOfSupports];

        require(_deadline > block.timestamp, "The deadline should be a date in the future.");

        support.owner = _owner;
        support.title = _title;
        support.description = _description;
        support.target = _target;
        support.deadline = _deadline;
        support.amountCollected = 0;
        support.image = _image;

        numberOfSupports++;

        return numberOfSupports - 1;
    }

    function donateToSupport(uint256 _id) public payable {
        uint256 amount = msg.value;

        Support storage support = allSupports[_id];

        require(support.deadline > block.timestamp, "Campaign deadline has passed.");

        // Reentrancy guard
        require(support.amountCollected + amount >= support.amountCollected, "Overflow error");

        support.donators.push(msg.sender);
        support.donations.push(amount);

        support.amountCollected += amount;

        // Use transfer to send Ether and avoid reentrancy issues
        require(payable(support.owner).send(amount), "Transfer failed");
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (allSupports[_id].donators, allSupports[_id].donations);
    }

    function getSupports() public view returns (Support[] memory) {
        Support[] memory supportList = new Support[](numberOfSupports);

        for(uint i = 0; i < numberOfSupports; i++) {
            supportList[i] = allSupports[i];
        }

        return supportList;
    }
}