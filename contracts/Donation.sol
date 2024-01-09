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

    mapping(uint256 => Support) public allsupports;

    uint256 public numberOfSupports = 0;

    function createSupport(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Support storage allsupport = allsupports[numberOfSupports];

        require(allsupport.deadline < block.timestamp, "The deadline should be a date in the future.");

        allsupport.owner = _owner;
        allsupport.title = _title;
        allsupport.description = _description;
        allsupport.target = _target;
        allsupport.deadline = _deadline;
        allsupport.amountCollected = 0;
        allsupport.image = _image;

        numberOfSupports++;

        return numberOfSupports - 1;
    }

    function donateToSupport(uint256 _id) public payable {
        uint256 amount = msg.value;

        Support storage allsupport = allsupports[_id];

        allsupport.donators.push(msg.sender);
        allsupport.donations.push(amount);

        (bool sent,) = payable(allsupport.owner).call{value: amount}("");

        if(sent) {
            allsupport.amountCollected = allsupport.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (allsupports[_id].donators, allsupports[_id].donations);
    }

    function getSupports() public view returns (Support[] memory) {
        Support[] memory allSupports = new Support[](numberOfSupports);

        for(uint i = 0; i < numberOfSupports; i++) {
            Support storage item = allsupports[i];

            allSupports[i] = item;
        }

        return allSupports;
    }
}