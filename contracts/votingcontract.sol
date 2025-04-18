//SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract SimpleVoting {
    address public owner;

    struct proposal {
        string name;
        uint id;
        uint votecount;
    }

    struct voter {
        uint id;
        bool hasvoted;
    }

    mapping(address => voter) public voters;
    mapping(address => proposal) public proposals;
    proposal public Proposal;
    voter public Voter;
    address[] public validvoter;
    proposal[] public proposal_details;

    error notvalidvoter(address voteraddress, string authorizedvoter);

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "unauthorized to push changes");
        _;
    }

    function addProposal(address _addr, string memory _name, uint _id) public OnlyOwner {
        Proposal.name = _name;
        Proposal.id = _id;
        proposals[_addr] = Proposal;
        proposal_details.push(Proposal);
    }

    function addVoter(address _voteraddress, uint _id, bool _hasvoted) public OnlyOwner {
        Voter.id = _id;
        Voter.hasvoted = _hasvoted;
        voters[_voteraddress] = Voter;
        validvoter.push(_voteraddress);
    }

    function castVote(address _voteraddress, address proposaladdress) public {
        for (uint i = 0; i < validvoter.length; i++) {
            if (_voteraddress == validvoter[i]) {
                require(!voters[_voteraddress].hasvoted, "already voted");
                proposals[proposaladdress].votecount += 1;
                voters[_voteraddress].hasvoted = true;
            }
        }
    }

    function getWinningProposal() public view returns (string memory winnername, uint votecount) {
        uint winnervotecount = 0;
        uint winnerid;

        for (uint i = 0; i < proposal_details.length; i++) {
            if (proposal_details[i].votecount > winnervotecount) {
                winnervotecount = proposal_details[i].votecount;
                winnerid = proposal_details[i].id;
            }
        }

        return (proposal_details[winnerid].name, proposal_details[winnerid].votecount);
    }
}
