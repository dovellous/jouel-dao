const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BEP20SmartContract", function () {

    const {ethers} = require("hardhat");

    const BEP20SmartContract = await ethers.getContractFactory(process.env.CONTRACT_NAME);
    const bep20SmartContract = await BEP20SmartContract.deploy(
        process.env.TOKEN_NAME,
        process.env.TOKEN_SYMBOL,
        process.env.TOKEN_DECIMALS,
        process.env.TOKEN_CAP_SUPPLY,
        process.env.TOKEN_INI_SUPPLY,
        process.env.ADDRESS_1,
        process.env.ADDRESS_2
    );

    await bep20SmartContract.deployed();

    var x = await bep20SmartContract.address;

    console.log("xxx", x);

    var z = await bep20SmartContract._bankDeposit();

    console.log("zzz", z);

});

test();