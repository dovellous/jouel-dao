// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

require("dotenv").config();

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  const BEP20SmartContract = await hre.ethers.getContractFactory(process.env.CONTRACT_NAME);
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

  const verifyContractSourceCode = `npx hardhat verify ${bep20SmartContract.address} \\"${process.env.TOKEN_NAME}\\" \\"${process.env.TOKEN_SYMBOL}\\" ${process.env.TOKEN_DECIMALS} ${process.env.TOKEN_CAP_SUPPLY} ${process.env.TOKEN_INI_SUPPLY} ${process.env.ADDRESS_1} ${process.env.ADDRESS_2}`;

  let bep20SmartContractChainAddress = '';

  switch (process.env.NETWORK) {

    case "bsc_mainnet" : {

      let bep20SmartContractChainAddress = `\n\nhttps://bscscan.com/address/${bep20SmartContract.address}#\n\n`

      break;

    }

    case "bsc_testnet" : {

      let bep20SmartContractChainAddress = `\n\nhttps://testnet.bscscan.com/address/${bep20SmartContract.address}#\n\n`

      break;

    }

    default : {

      let bep20SmartContractChainAddress = `\n\nhttps://etherscan.com/address/${bep20SmartContract.address}#\n\n`

      break;

    }

  }

  console.log(`${process.env.TOKEN_NAME} deployed to:`, bep20SmartContract.address, `\n\n`, bep20SmartContractChainAddress);

  console.log(`Run the code below to verify the contract source code: \n\n${verifyContractSourceCode}`);

  /* TODO
  const editDotenv = require('edit-dotenv');
  if (process.env.TOKEN_VERIFY_AFTER_DEPLOYEMENT){
    const changes = {
      DEPLOYED_CONTRACT: 'new value',
      NEW: 'value'
    };
    editDotenv(envString, changes);
  }
   */

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
