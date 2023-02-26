// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

struct Member {
  uint256 stake;
  uint expiryAt;
}

struct Admin {
  address adminAddress;
  uint addedOn;
  uint expiryAt;
}
