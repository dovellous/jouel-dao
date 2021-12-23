// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./bank/BankController.sol";

/**
 * @dev BEP20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 */
abstract contract BEP20DappBank is BankController {

    function bankDeposit(address spender, uint256 subtractedValue) public virtual returns (bool) {
        return 1;
    }

    function bankWithdraw(address spender, uint256 subtractedValue) public virtual returns (bool) {
        return 1;
    }

}