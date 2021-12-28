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

  console.log(`${process.env.TOKEN_NAME} deployed to:`, bep20SmartContract.address);

  console.log(`Run the code below to verify the contract source code: \n\n${verifyContractSourceCode}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
