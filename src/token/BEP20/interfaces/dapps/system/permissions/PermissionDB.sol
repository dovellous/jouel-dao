// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../registry/ContractNameRegistry.sol";

import "../registry/ContractNameRegistrySetter.sol";

abstract contract PermissionDB is ContractNameRegistrySetter
{
    mapping (address => uint) permissions;
    bytes32 permissionControllerContractName = "PermissionController";

    constructor(address nameRegistry)
    {
        contractNameRegistry = nameRegistry;
    }

    modifier onlyOwner()
    {
        address owner = ContractNameRegistry(contractNameRegistry).getContractAddressFromName(permissionControllerContractName);

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

    // Only permissionController can call this
    function setPermissionLevel(address user, uint permissionLevel) onlyOwner public returns (bool response)
    {
        permissions[user] = permissionLevel;
        return true;
    }

    // Only permissionController can call this
    function getPermissionLevel(address user) onlyOwner public returns (uint permissionLevel)
    {
        return permissions[user];
    }

    // Only permissionController can call this
    function getPermissionLevelForBanking() onlyOwner public returns (uint permissionLevel)
    {
        return 1;
    }

}
