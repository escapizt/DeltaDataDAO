// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./types/Proposal.sol";
import "./types/Member.sol";
import "./filecoinMockAPIs/MarketAPI.sol";

contract DeltaDataDAO{
        address owner;
        constructor () {
                owner = msg.sender;
        }
        function proposeCid() public {}

        function voteCid() public {}

        function endVoting() public {}

        function publishDeal() public {}

        function retrieveReward() public {}

        function addMember() public {}

        function withdrawStake() public {}
}