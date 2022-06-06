/* eslint-disable prettier/prettier */
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

describe('HouseRegistryExtV2', function () {
  let acc1: any;
  let acc2: any;
  let houseRegistryExt: any;
  let houseRegistryExtV2: any;
  let daiToken: any;
  let houseId: any;
  let daiAddress: any;
  let beacon: any;

  beforeEach(async function () {
    [acc1, acc2] = await ethers.getSigners();
    const HouseRegistryExt = await ethers.getContractFactory('HouseRegistryExt');
    const DaiToken = await ethers.getContractFactory('DaiToken', acc2);
    daiToken = await DaiToken.deploy();
    daiAddress = daiToken.address;
    await daiToken.deployed();
    beacon = await upgrades.deployBeacon(HouseRegistryExt);
    houseRegistryExt = await upgrades.deployBeaconProxy(beacon, HouseRegistryExt, [daiAddress], {
      initializer: 'init',
    });

    const func = await houseRegistryExt.connect(acc2).listHouseSimple(103, 103, 103, 'asd');
    const result = await func.wait();
    houseId = result.events[0].args[0];
    // const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
    // await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
    // houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);
  });

  // it('should be deployed', async function () {
  //   // eslint-disable-next-line no-unused-expressions
  //   expect(houseRegistryExt.address).to.be.properAddress;
  //   // eslint-disable-next-line no-unused-expressions
  //   expect(daiToken.address).to.be.properAddress;
  // });

  it('should return id of new house', async function () {
    const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
    await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
    houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);
    const func = await houseRegistryExtV2.connect(acc1).listHouseSimple(100, 100, 100, 'asd');
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal(96932);
  });

  // it('should return succesful', async function () {
  //   const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
  //   await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
  //   houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);
  //   const func = await houseRegistryExtV2.buyHouseWithETH(houseId, { value: 103 });
  //   const result = await func.wait();
  //   await expect(result.events[0].args[0]).to.equal('Transactions succesful');
  // });

  // it('should return insufficient funds', async function () {
  //   const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
  //   await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
  //   houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);
  //   const message = 'value less than cost';
  //   expect(houseRegistryExtV2.buyHouseWithETH(houseId, { value: 100 })).to.be.revertedWith(message);
  // });

  // it('should return Transactions succesful', async function () {
  //   const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
  //   await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
  //   houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);
  //   await daiToken.connect(acc3).approve(houseRegistryExtV2.address, 200);
  //   const func = await houseRegistryExtV2.connect(acc3).buyHouseWithDai(houseId);
  //   const result = await func.wait();
  //   await expect(result.events[2].args[0]).to.equal('Transactions succesful');
  //   await expect(result.events[2].args[1]).to.equal(acc3.address);
  //   await expect(await daiToken.connect(acc3).balanceOf(acc3.address)).to.equal(99999897);
  //   await expect(await daiToken.connect(acc3).balanceOf(acc2.address)).to.equal(103);
  // });

  // it('should return succesful', async function () {
  //   const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
  //   await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
  //   console.log(houseRegistryExt.address)
  //   houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);

  //   const func = await houseRegistryExtV2.buyHouseWithETH(houseId, { value: 200 });
  //   const result = await func.wait();
  //   await expect(result.events[0].args[0]).to.equal('Transactions succesful');
  // });

  it('should update contract and return houseId from first contract', async function () {
    const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
    await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
    houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);
    const func = await houseRegistryExtV2.getExpensiveHouseIds();
    await expect(await func).to.equal(houseId);
  });

  it('should return expensive houseId', async function () {
    const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
    await upgrades.upgradeBeacon(beacon, HouseRegistryExtV2);
    houseRegistryExtV2 = HouseRegistryExtV2.attach(houseRegistryExt.address);
    await houseRegistryExtV2.connect(acc2).listHouseSimple(100, 100, 100, 'asd');
    const expensiveHouse = await houseRegistryExtV2
      .connect(acc1)
      .listHouseSimple(200, 200, 200, 'asd');
    const result = await expensiveHouse.wait();
    const expensuveHouseId = result.events[0].args[0];
    const func = await houseRegistryExtV2.getExpensiveHouseIds();
    await expect(func).to.equal(expensuveHouseId);
  });
});
