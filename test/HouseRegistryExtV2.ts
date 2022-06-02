/* eslint-disable prettier/prettier */
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

describe('HouseRegistryExtV2', function () {
  let acc1: any;
  let acc2: any;
  let acc3: any;
  let houseRegistryExt: any;
  let houseRegistryExtV2: any;
  let daiToken: any;
  let houseId: any;
  let daiAddress: any;

  beforeEach(async function () {
    [acc1, acc2, acc3] = await ethers.getSigners();
    const HouseRegistryExt = await ethers.getContractFactory('HouseRegistryExt');
    const HouseRegistryExtV2 = await ethers.getContractFactory('HouseRegistryExtV2');
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
    houseRegistryExtV2 = await upgrades.upgradeProxy(houseRegistryExt.address, HouseRegistryExtV2);
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
    const func = await houseRegistryExtV2.buyHouseWithETH(houseId, { value: 103 });
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal('Transactions succesful');
  });

  it('should return insufficient funds', async function () {
    const message = 'value less than cost';
    expect(houseRegistryExtV2.buyHouseWithETH(houseId, { value: 100 })).to.be.revertedWith(message);
  });

  it('should return Transactions succesful', async function () {
    await daiToken.connect(acc3).approve(houseRegistryExtV2.address, 200);
    const func = await houseRegistryExtV2.connect(acc3).buyHouseWithDai(houseId);
    const result = await func.wait();
    await expect(result.events[2].args[0]).to.equal('Transactions succesful');
    await expect(result.events[2].args[1]).to.equal(acc3.address);
    await expect(await daiToken.connect(acc3).balanceOf(acc3.address)).to.equal(99999897);
    await expect(await daiToken.connect(acc3).balanceOf(acc2.address)).to.equal(103);
  });

  it('should return succesful', async function () {
    const func = await houseRegistryExtV2.buyHouseWithETH(houseId, { value: 200 });
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal('Transactions succesful');
  });

  it('should return expensive houseId', async function () {
    const expensiveHouse = await houseRegistryExtV2
      .connect(acc3)
      .listHouseSimple(200, 200, 200, 'asd');
    await houseRegistryExtV2.connect(acc1).listHouseSimple(150, 150, 150, 'asd');
    const result = await expensiveHouse.wait();
    const expensuveHouseId = result.events[0].args[0];
    const func = await houseRegistryExtV2.getExpensiveHouseIds();
    await expect(func).to.equal(expensuveHouseId);
  });

  it('should return cheepest houseId created in V1 Contract', async function () {
    const func = await houseRegistryExtV2.getCheapHouseIds(103);
    await expect(func[0]).to.deep.equal(houseId);
  });
});
