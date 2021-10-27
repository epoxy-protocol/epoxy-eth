//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract EpoxyBridge {
    using SafeMath for uint256;

    uint256 private _lastLockId = 0;

    mapping(uint256 => address) private _initiatedLocks;

    /**
     * Event for lock creation logging
     */
    event LockInitiated();

    constructor() {
    }

    /**
     * @dev Lorem ipsum
     * @param _token Lorem ipsum
     */
    function initiateLock(address _token) public {
        _lastLockId = _lastLockId.add(1);
        _initiatedLocks[_lastLockId] = _token;
// ;;;;    -> clear out ownership
// ;;;;    -> transfer the token to the contract.
// ;;;;    -> emit an event { lock-id }

    }

    function getNextLockId() external view returns (uint256) {
        return _lastLockId;
    }

    function lockERC20() public {
    }

    function lockERC721() public {
    }

    function lockETH() public {
    }

    function unlockERC20() public {
    }

    function unlockERC721() public {
    }

    function unlockETH() public {
    }

    function lockSIP010() public {
    }

    function lockSIP009() public {
    }

    function unlockSIP010() public {
    }

    function unlockSIP009() public {
    }
}
