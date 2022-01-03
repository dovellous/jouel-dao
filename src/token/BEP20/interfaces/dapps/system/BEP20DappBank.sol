// SPDX-License-Identifier: MIT

/*


pragma solidity ^0.8.0;

/// @title A sample bank contract
/// @author Will Papper and Syndicate Inc.
/// @notice The Bank contract keeps track of the deposits and withdrawals for a
/// single user. The bank takes a 0.3% fee on every withdrawal. The bank contract
/// supports deposits and withdrawals for any ERC-20, but only one ERC-20 token
/// can be used per bank contract.
/// @dev Security for the Bank contract is paramount :) You can assume that the
/// owner of the Bank contract is the first account in Ganache (accounts[0]
/// within Bank.js), and that the user of the bank is not the owner of the Bank
/// contract (e.g. the user of the bank is accounts[1] within Bank.js, not
/// accounts[0]).
abstract contract BEP20DappBank {

    uint public transactions;
    mapping(address=>uint) balances;
    address public BANK_FEE_ADDRESS;

    // The bank should take a fee of 0.3% on every withdrawal. For example, if a
    // user is withdrawing 1000 DAI, the bank should receive 3 DAI. If a user is
    // withdrawing 100 DAI, the bank should receive .3 DAI. The same should hold
    // true for USDC as well.
    // The bankFee is set using setBankFee();
    uint256 bankFee = 0;

    /// @notice Process a deposit to the bank
    /// @return balance The current account balance
    function _bankDeposit() public payable returns (uint256) {

        // Transfer funds from the user to the bank
        balances[msg.sender] += msg.value;
        transactions++;
        // Increase the balance by the deposit amount and return the balance
        return balances[msg.sender];
    }

    /// @notice Process a withdrawal from the bank
    /// @param amount The amount that a user wants to withdraw. The bank takes a
    /// 0.3% fee on every withdrawal
    /// @return balance The current account balance
    function _bankWithdraw(uint256 amount) public returns (uint256) {
        require(balances[msg.sender] >= amount);
        // Calculate the fee that is owed to the bank
        (uint256 amountToUser, uint256 amountToBank) = calculateBankFee(amount);
        // Decrease the balance by the amount sent to the user
        balances[msg.sender] -= amountToUser;
        // Decrease the balance by the amount sent to the bank
        balances[msg.sender] -= amountToBank;
        payable(msg.sender).transfer(amountToUser);
        payable(BANK_FEE_ADDRESS).transfer(amountToBank);
        transactions++;
        return balances[msg.sender];
    }

    /// @notice Calculate the fee that should go to the bank
    /// @param amount The amount that a fee should be deducted from
    /// @return A tuple of (amountToUser, amountToBank)
    function calculateBankFee(uint256 amount)
    public
    view
    returns (uint256, uint256)
    {
        // TODO: Implement the 0.3% fee to the bank here
        uint256 amountToBank = amount * bankFee;
        uint256 amountToUser = amount - amountToBank;
        return (amountToUser, amountToBank);
    }

    /// @notice Set the fee that the bank takes
    /// @param fee The fee that bankFee should be set to
    /// @return bankFee The new value of the bank fee
    function _setBankFee(uint256 fee) public returns (uint256) {
        bankFee = fee;
        return bankFee;
    }

    /// @notice Set the fee that the bank takes
    /// @param bankAddress The address that the bankFee should be sent to
    /// @return BANK_FEE_ADDRESS The new value of the bank fee
    function _setBankFeeAddress(address bankAddress) public returns (address) {
        BANK_FEE_ADDRESS = bankAddress;
        return BANK_FEE_ADDRESS;
    }

    /// @notice Get the user's bank balance
    /// @return balance The balance of the user
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}