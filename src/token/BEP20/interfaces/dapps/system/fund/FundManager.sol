// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../registry/ContractNameRegistry.sol";

import "../registry/ContractNameRegistrySetter.sol";

abstract contract FundManager is ContractNameRegistrySetter
{

    address owner;
    bytes32 permissionControllerContractName = "PermissionController";
    bytes32 bankControllerContractName = "BankController";

    constructor(address nameRegistry)
    {
        owner = msg.sender;
        contractNameRegistry = nameRegistry;
    }

    modifier onlyOwner()
    {
        if(msg.sender != owner)
        {
            revert();
        }
        _;
    }

    function setPermissionLevel(address user, uint permissionLevel) onlyOwner public returns (bool response)
    {
        address permissionController = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(permissionControllerContractName);

        if(permissionController == 0x0)
        {
            revert();
        }

        bool result = PermissionController(permissionController).setPermissionLevel(user, permissionLevel);

        if(!result)
        {
            revert();
        }

        return true;
    }

    function deposit() onlyOwner public returns (bool response)
    {
        address permissionController = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(permissionControllerContractName);

        if(permissionController == 0x0)
        {
            revert();
        }

        uint permissionLevel = PermissionController(permissionController).getPermissionLevel(msg.sender);

        uint permissionLevelForBanking = PermissionController(permissionController).getPermissionLevelForBanking();

        if(permissionLevel != permissionLevelForBanking)
        {
            revert();
        }

        address bankController = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(bankControllerContractName);

        if(bankController == 0x0)
        {
            revert();
        }

        bool result = BankController(bankController).deposit.value(msg.value)(msg.sender);

        if(!result)
        {
            revert();
        }

        return true;
    }

    function withdraw(uint amount) onlyOwner public returns (bool response)
    {
        address permissionController = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(permissionControllerContractName);

        if(permissionController == 0x0)
        {
            revert();
        }

        uint permissionLevel = PermissionController(permissionController).getPermissionLevel(msg.sender);

        uint permissionLevelForBanking = PermissionController(permissionController).getPermissionLevelForBanking();

        if(permissionLevel != permissionLevelForBanking)
        {
            revert();
        }

        address bankController = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(bankControllerContractName);

        if(bankController == 0x0)
        {
            revert();
        }

        bool result = BankController(bankController).withdraw(msg.sender, amount);

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
