// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//import "./bank/BankController.sol";

/**
 * @dev BEP20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 */
abstract contract BEP20DappBank {

    function _bankDeposit(address sender, address recipient, uint256 amount) public pure returns (bool) {
        (sender, recipient, amount);
        return true;
    }

    function _bankWithdraw(address sender, address recipient, uint256 amount) public pure returns (bool) {
        (sender, recipient, amount);
        return true;
    }

}