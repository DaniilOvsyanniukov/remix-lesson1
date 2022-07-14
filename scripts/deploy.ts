// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { mkdirSync, existsSync, writeFileSync } from 'fs';
import { ethers, upgrades, artifacts } from 'hardhat';
import path from 'path';

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying with', await deployer.address);

  const HouseFactory = await ethers.getContractFactory('HouseFactory');
  const HouseRegistry = await ethers.getContractFactory('HouseRegistry');
  const DaiToken = await ethers.getContractFactory('DaiToken');
  const HouseRegistryExt = await ethers.getContractFactory('HouseRegistryExt');

  const houseFactory = await HouseFactory.deploy();
  const houseRegistry = await upgrades.deployProxy(HouseRegistry, [await houseFactory.address], {
    initializer: 'initialize',
  });
  const daiToken = await DaiToken.deploy();
  const houseRegistryExt = await upgrades.deployProxy(
    HouseRegistryExt,
    [await daiToken.address, await houseFactory.address],
    {
      initializer: 'init',
    }
  );

  await houseFactory.deployed();
  await houseRegistry.deployed();
  await daiToken.deployed();
  await houseRegistryExt.deployed();

  console.log('HouseFactory deployed to:', houseFactory.address);
  console.log('HouseRegistry deployed to:', houseRegistry.address);
  console.log('DaiToken deployed to:', daiToken.address);
  console.log('HouseRegistryExt deployed to:', houseRegistryExt.address);

  saveFrontendFiles({
    HouseFactory: houseFactory,
    HouseRegistry: houseRegistry,
    DaiToken: daiToken,
    HouseRegistryExt: houseRegistryExt,
  });
}
function saveFrontendFiles(contracts: any) {
  const contractsDir = path.join(__dirname, '/..', 'front/src/contracts');
  if (!existsSync(contractsDir)) {
    mkdirSync(contractsDir);
  }
  Object.entries(contracts).forEach((contractItem) => {
    const name: string = contractItem[0];
    const contract: any = contractItem[1];

    if (contract) {
      writeFileSync(
        path.join(contractsDir, '/', name + 'contract-address.json'),
        JSON.stringify({ [name]: contract.address }, undefined, 2)
      );
    }
    const contractArtifact = artifacts.readArtifactSync(name);
    writeFileSync(
      path.join(contractsDir, '/', name + '.json'),
      JSON.stringify(contractArtifact, null, 2)
    );
  });
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
