// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../registry/ContractNameRegistry.sol";

import "../registry/ContractNameRegistrySetter.sol";

abstract contract PermissionController is ContractNameRegistrySetter
{
    bytes32 fundManagerContractName = "FundManager";
    bytes32 permissionDBContractName = "PermissionDB";

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

    // Only fund manager can call this
    function setPermissionLevel(address user, uint permissionLevel) onlyOwner public returns (bool response)
    {
        address permissionDBAddress = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(permissionDBContractName);

        if(permissionDBAddress == 0x0)
        {
            revert();
        }

        bool result = PermissionDB(permissionDBAddress).setPermissionLevel(user, permissionLevel);

        if(!result)
        {
            revert();
        }

        return true;
    }

    // Only fund manager can call this
    function getPermissionLevel(address user) onlyOwner public returns (uint permissionLevel)
    {
        address permissionDBAddress = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(permissionDBContractName);

        if(permissionDBAddress == 0x0)
        {
            revert();
        }

        uint result = PermissionDB(permissionDBAddress).getPermissionLevel(user);

        if(result == 0)
        {
            revert();
        }

        return result;
    }

    // Only fund manager can call this
    function getPermissionLevelForBanking() onlyOwner public returns (uint permissionLevel)
    {
        address permissionDBAddress = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(permissionDBContractName);

        if(permissionDBAddress == 0x0)
        {
            revert();
        }

        uint result = PermissionDB(permissionDBAddress).getPermissionLevelForBanking();

        if(result == 0)
        {
            revert();
        }

        return result;
    }
}
