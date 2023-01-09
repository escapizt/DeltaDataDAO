// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

struct Proposal {
  uint256 proposalId;
  address assignedStorageProvider;
  bytes cidRaw;
  uint size;
  uint256 upvoteCount;
  uint256 downvoteCount;
  uint256 expiryAt;
  uint256 reward;
}