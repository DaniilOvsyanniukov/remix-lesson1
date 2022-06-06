/* eslint-disable prettier/prettier */
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

describe('HouseRegistryExt', function () {
  let acc1: any;
  let acc2: any;
  let acc3: any;
  let houseRegistryExt: any;
  let daiToken: any;
  let houseId: any;
  let daiAddress: any;

  beforeEach(async function () {
    [acc1, acc2, acc3] = await ethers.getSigners();
    const HouseRegistryExt = await ethers.getContractFactory('HouseRegistryExt');
    const DaiToken = await ethers.getContractFactory('DaiToken', acc3);
    daiToken = await DaiToken.deploy();
    daiAddress = daiToken.address;
    houseRegistryExt = await upgrades.deployProxy(HouseRegistryExt, [daiAddress], {
      initializer: 'init',
    });
    await houseRegistryExt.deployed();
    await daiToken.deployed();
    const func = await houseRegistryExt.connect(acc2).listHouseSimple(103, 103, 103, 'asd');
    const result = await func.wait();
    houseId = result.events[0].args[0];
  });

  it('should be deployed', async function () {
    // eslint-disable-next-line no-unused-expressions
    expect(houseRegistryExt.address).to.be.properAddress;
    // eslint-disable-next-line no-unused-expressions
    expect(daiToken.address).to.be.properAddress;
  });

  it('should return id of new house', async function () {
    const func = await houseRegistryExt.connect(acc1).listHouseSimple(100, 100, 100, 'asd');
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal(96932);
  });

  it('should return succesful', async function () {
    const func = await houseRegistryExt.buyHouseWithETH(houseId, { value: 103 });
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal('Transactions succesful');
  });

  it('should return insufficient funds', async function () {
    const message = 'value less than cost';
    expect(houseRegistryExt.buyHouseWithETH(houseId, { value: 100 })).to.be.revertedWith(message);
  });

  it('should return Transactions succesful', async function () {
    await daiToken.connect(acc3).approve(houseRegistryExt.address, 200);
    const func = await houseRegistryExt.connect(acc3).buyHouseWithDai(houseId);
    const result = await func.wait();
    await expect(result.events[2].args[0]).to.equal('Transactions succesful');
    await expect(result.events[2].args[1]).to.equal(acc3.address);
    await expect(await daiToken.connect(acc3).balanceOf(acc3.address)).to.equal(99999897);
    await expect(await daiToken.connect(acc3).balanceOf(acc2.address)).to.equal(103);
  });

  it('should return succesful', async function () {
    const func = await houseRegistryExt.buyHouseWithETH(houseId, { value: 200 });
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal('Transactions succesful');
  });
});
