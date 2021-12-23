// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract ContractNameRegistry
{
    address owner;
    mapping(bytes32 => address) nameRegistry;

    // Owner is defined
    constructor()
    {
        owner = msg.sender;
    }

    modifier onlyOwner()
    {
        if(msg.sender != owner)
        {
            revert();
        }
        _;
    }

    // Whenever a contract is deployed, it is registered with ContractNameRegistry first
    function addContractName(bytes32 name, address contractAddress) onlyOwner public returns (bool response)
    {
        nameRegistry[name] = contractAddress;
        return true;
    }

    // On removing a contract
    function removeContractName(bytes32 name) onlyOwner public returns (bool response)
    {
        nameRegistry[name] = 0;
        return true;
    }

    // Other contracts will call this function to get addresses of needed contracts
    function getContractAddressFromName(bytes32 name) public returns (address contractAddress)
    {
        if(nameRegistry[name] == 0)
        {
            revert();
        }

        return nameRegistry[name];
    }
}

