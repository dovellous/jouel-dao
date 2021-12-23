// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../registry/ContractNameRegistry.sol";

import "../registry/ContractNameRegistrySetter.sol";

abstract contract BankDB is ContractNameRegistrySetter
{
    mapping (address => uint) balances;
    bytes32 bankControllerContractName = "BankController";

    constructor(address nameRegistry)
    {
        contractNameRegistry = nameRegistry;
    }

    modifier onlyOwner()
    {
        address owner = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(bankControllerContractName);

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
        balances[customer] += msg.value;
        return true;
    }

    function withdraw(address customer, uint amount) onlyOwner public returns (bool response)
    {
        if(balances[customer] < amount)
        {
            revert();
        }

        balances[customer] -= amount;

        if(!msg.sender.send(amount))
        {
            revert();
        }

        return true;
    }
}