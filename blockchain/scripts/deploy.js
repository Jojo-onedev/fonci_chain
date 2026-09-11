const hre = require("hardhat");

async function main() {
  console.log("Debut du deploiement du contrat FonciChain...");

  // Recuperation du contrat
  const FonciChain = await hre.ethers.getContractFactory("FonciChain");
  
  // Deploiement
  const fonciChain = await FonciChain.deploy();

  await fonciChain.waitForDeployment();

  const address = await fonciChain.getAddress();

  console.log("-----------------------------------------------");
  console.log(`Contrat FonciChain deploye avec succes !`);
  console.log(`Adresse du contrat : ${address}`);
  console.log("-----------------------------------------------");
  console.log("Gardez cette adresse precieusement, nous en aurons besoin pour le frontend.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});