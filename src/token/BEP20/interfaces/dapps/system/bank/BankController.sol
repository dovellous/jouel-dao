// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../registry/ContractNameRegistry.sol";

import "../registry/ContractNameRegistrySetter.sol";

import "./BankDB.sol";

abstract contract BankController is ContractNameRegistrySetter
{
    bytes32 fundManagerContractName = "FundManager";
    bytes32 bankDBContractName = "BankDB";

    constructor(address nameRegistry)
    {
        contractNameRegistry = nameRegistry;
    }

    modifier onlyOwner()
    {
        address owner = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(fundManagerContractName);

        if(owner == 0x0)
        {
            revert();
        }

        if(msg.sender != owner)
        {
            revert();
        }
        _;
    }

    function deposit(address customer) onlyOwner public returns (bool response)
    {
        address bankDBAddress = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(bankDBContractName);

        if(bankDBAddress == 0x0)
        {
            revert();
        }

        bool result = BankDB(bankDBAddress).deposit.value(msg.value)(customer);

        if(!result)
        {
            revert();
        }

        return true;
    }

    function withdraw(address customer, uint amount) onlyOwner public returns (bool response)
    {
        address bankDBAddress = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(bankDBContractName);

        if(bankDBAddress == 0x0)
        {
            revert();
        }

        bool result = BankDB(bankDBAddress).withdraw(customer, amount);

        if(!result)
        {
            revert();
        }

        if(!msg.sender.send(amount))
        {
            revert();
        }

        return true;
    }
}
