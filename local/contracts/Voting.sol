// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
        address registerer;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    address[] private _allVoters;
    mapping(address => Voter) private _whitelist;
    Proposal[] private _proposals;
    address private _owner;
    WorkflowStatus private _workflowStatus = WorkflowStatus.RegisteringVoters;

    event VoterRegistered(address voterAddress);
    event VoterDeleted(address voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event ProposalDeleted(uint proposalId);
    event Voted (address voter, uint proposalId);
    event VoteRemoved (address voter);

    constructor(address _initialOwner) Ownable(_initialOwner) {
        _whitelist[_initialOwner] = Voter(true, false, 0);
        _allVoters.push(_initialOwner);
    }

    modifier workflowStatus(WorkflowStatus _requiredStatus) {
        require(_workflowStatus == _requiredStatus, "The workflow status does not correspond with your request.");
        _;
    }

    modifier workflowStatusUnder(WorkflowStatus _threshold) {
        require(_workflowStatus < _threshold);
        _;
    }

    modifier isVoter {
        require(_whitelist[msg.sender].isRegistered == true, "You are not registered as a voter.");
        _;
    }

    modifier neverVoted {
        require(_whitelist[msg.sender].hasVoted == false, "You already voted.");
        _;
    }

    modifier hasVoted(address _address) {
        require(_whitelist[_address].hasVoted == true, "The voter never voted.");
        _;
    }

    modifier isProposalOwner(uint256 _proposalId) {
        require(msg.sender == _proposals[_proposalId].registerer);
        _;
    }

    function addVoter(address _address) public onlyOwner workflowStatus(WorkflowStatus.RegisteringVoters) {
        _whitelist[_address] = Voter(true, false, 0);
        emit VoterRegistered(_address);
    }

    function addProposal(string memory _description) public isVoter workflowStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        _proposals.push(Proposal(_description, 0, msg.sender));
        emit ProposalRegistered(_proposals.length);
    }

    function updateProposal(string memory _description, uint256 _proposalId) public isProposalOwner(_proposalId) workflowStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        _proposals[_proposalId].description = _description;
        emit ProposalRegistered(_proposals.length);
    }

    function deleteProposal(uint256 _proposalId) public isProposalOwner(_proposalId) workflowStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        delete _proposals[_proposalId];
        emit ProposalRegistered(_proposals.length);
    }

    function removeFromWhitelist(address _address) public onlyOwner workflowStatusUnder(WorkflowStatus.ProposalsRegistrationEnded) {
        for (uint256 i=0; i<_proposals.length; i+=1) {
            if (_proposals[i].registerer == _address) {
                if (_proposals[i].voteCount > 0) {
                    // We must ensure we delete all votes linked to the address to remove (if the owner came back to proposal phase)
                    for (uint256 ii = 0; ii<_allVoters.length; ii+=1) {
                        if (_whitelist[_allVoters[ii]].hasVoted && _whitelist[_allVoters[ii]].votedProposalId == i) {
                            _whitelist[_allVoters[ii]].votedProposalId = 0;
                            _whitelist[_allVoters[ii]].hasVoted = false;
                            emit VoteRemoved(_allVoters[ii]);
                        }
                    }
                }
            }
            delete _proposals[i];
            emit ProposalDeleted(_proposals.length);
        }
        delete _whitelist[_address];
        emit VoterDeleted(_address);
        setWorkflowStatus(WorkflowStatus.ProposalsRegistrationEnded);
    }

    function vote(uint _proposalId) public isVoter neverVoted workflowStatus(WorkflowStatus.VotingSessionStarted) {
        _whitelist[msg.sender] = Voter(true, true, _proposalId);
        _proposals[_proposalId].voteCount += 1;
        emit Voted(msg.sender, _proposalId);
    }

    function setWorkflowStatus(WorkflowStatus _newWorkflowstatus) private {
        WorkflowStatus _previous = _workflowStatus;
        _workflowStatus = _newWorkflowstatus;
        emit WorkflowStatusChange(_previous, WorkflowStatus.RegisteringVoters);
    }

    function startVoterRegistering() public onlyOwner {
        setWorkflowStatus(WorkflowStatus.RegisteringVoters);
    }

    function startProposalRegistering() public onlyOwner {
        setWorkflowStatus(WorkflowStatus.ProposalsRegistrationStarted);
    }

    function stopProposalRegistering() public onlyOwner {
        setWorkflowStatus(WorkflowStatus.ProposalsRegistrationEnded);
    }

    function openVotes() public onlyOwner {
        setWorkflowStatus(WorkflowStatus.VotingSessionStarted);
    }

    function closeVotes() public onlyOwner {
        setWorkflowStatus(WorkflowStatus.VotingSessionEnded);
    }

    function setVoteTallied() public onlyOwner {
        setWorkflowStatus(WorkflowStatus.VotesTallied);
    }

    function getVote(address _address) hasVoted(_address) public view returns (Proposal memory) {
        return _proposals[_whitelist[_address].votedProposalId];
    }

    function getWinner() public view returns (Proposal memory) {
        uint maxVotes = 0;
        uint totalWithMaxVotes = 0;
        Proposal memory winner;
        for (uint i=0; i<_proposals.length; i++) {
            if (_proposals[i].voteCount > maxVotes) {
                totalWithMaxVotes = 1;
                maxVotes = _proposals[i].voteCount;
                winner = _proposals[i];
            } else if (_proposals[i].voteCount == maxVotes) {
                totalWithMaxVotes += 1;
            }
        }

        if (totalWithMaxVotes > 1) {
            revert("The vote is actually ex-aecquo.");
        }
        return winner;
    }

    function hello_world() public pure returns (string memory) {
        return "Hello from contract";
    }
}
