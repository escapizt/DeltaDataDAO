// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./types/Proposal.sol";
import "./types/Member.sol";
import "./filecoinMockAPIs/MarketAPI.sol";

contract DeltaDataDAO{
        address owner;
        mapping (uint256 => Proposal) public proposals;
        mapping (address => Member) public members;
        mapping (bytes => address) public deals;
        uint256 public proposalsLength;

        event ProposalCreated(uint256 proposalId);
        event VoteCast(uint256 proposalId, address member, bool vote);
        event VotingEnded(uint256 proposalId, address winner);
        event DealPublished(bytes cidRaw, address storageProvider);
        event MemberAdded(address member, uint256 stake, uint256 expiryAt);
        event StakeWithdrawn(address member, uint256 stake);

        constructor () {
                owner = msg.sender;
        }
        function proposeCid(address assignedStorageProvider, bytes cidRaw, uint size, uint256 expiryAt, uint256 reward) public {
                // Generate unique proposalId
                uint256 proposalId = proposals.length++;
                // Create new proposal
                Proposal storage proposal = proposals[proposalId];
                proposal.proposalId = proposalId;
                proposal.assignedStorageProvider = assignedStorageProvider;
                proposal.cidRaw = cidRaw;
                proposal.size = size;
                proposal.upvoteCount = 0;
                proposal.downvoteCount = 0;
                proposal.expiryAt = expiryAt;
                proposal.reward = reward;
                // Emit event
                emit ProposalCreated(proposalId);
        }

        function voteCid(uint256 proposalId, bool vote) public {
                require(proposalId < proposals.length, "Invalid proposalId");
                Proposal storage proposal = proposals[proposalId];
                require(now < proposal.expiryAt, "Voting period has expired");

                Member storage member = members[msg.sender];
                require(now < member.expiryAt, "Membership has expired");

                if (vote) {
                        proposal.upvoteCount += member.stake;
                } else {
                        proposal.downvoteCount += member.stake;
                }
                emit VoteCast(proposalId, msg.sender, vote);
        }


        function endVoting(uint256 proposalId) public {
                require(msg.sender == owner, "Only owner can end voting");
                require(proposalId < proposals.length, "Invalid proposalId");
                Proposal storage proposal = proposals[proposalId];
                require(now > proposal.expiryAt, "Voting period has not expired yet");
                // Determine winner
                // make sure this is local
                address winner;
                if (proposal.upvoteCount > proposal.downvoteCount) {
                        winner = proposal.assignedStorageProvider;
                } else {
                        winner = address(0);
                }
                emit VotingEnded(proposalId, winner);
        }


        function publishDeal(uint256 proposalId) public {
                require(msg.sender == owner, "Only owner can publish a deal");
                require(proposalId < proposals.length, "Invalid proposalId");
                Proposal storage proposal = proposals[proposalId];
                require(proposal.upvoteCount > proposal.downvoteCount, "Proposal did not pass voting");
                require(deals[proposal.cidRaw] == address(0), "Deal has already been published");
                deals[proposal.cidRaw] = proposal.assignedStorageProvider;
                emit DealPublished(proposal.cidRaw, proposal.assignedStorageProvider);
        }


        function retrieveReward() public {}

        function addMember(address member, uint256 stake, uint256 expiryAt) public {
                require(members[member] == Member({}), "Member already exists");
                require(stake > 0, "Stake must be greater than zero");

                members[member].stake = stake;
                members[member].expiryAt = expiryAt;
                emit MemberAdded(member, stake, expiryAt);
        }


        function withdrawStake(address member) public {
                require(msg.sender == member, "Only member can withdraw stake");
                require(now < members[member].expiryAt, "Membership has expired");
                require(members[member].stake > 0, "Stake is zero");

                uint256 stake = members[member].stake;
                members[member].stake = 0;
                msg.sender.transfer(stake);

                emit StakeWithdrawn(member, stake);
        }
}
