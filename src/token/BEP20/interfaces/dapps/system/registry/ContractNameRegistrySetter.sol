// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract ContractNameRegistrySetter
{
    address contractNameRegistry;

    constructor(address nameRegistry)
    {
        contractNameRegistry = nameRegistry;
    }

    modifier onlyRegistry()
    {
        if(msg.sender != contractNameRegistry)
        {
            revert();
        }
        _;
    }

    // Only contractNameRegistry can set up a new registry
    function setContractNameRegistry(address newNameRegistry) onlyRegistry public returns (bool response)
    {
        contractNameRegistry = newNameRegistry;
        return true;
    }
}
