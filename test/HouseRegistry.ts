/* eslint-disable prettier/prettier */
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

describe('HouseRegistry', function () {
  let acc1: any;
  let acc2: any;
  let acc3: any;
  let houseRegistry: any;
  let houseId: any;
  let factoryAddress: any;

  beforeEach(async function () {
    [acc1, acc2, acc3] = await ethers.getSigners();
    const HouseRegistry = await ethers.getContractFactory('HouseRegistry');
    const HouseFactory = await ethers.getContractFactory('HouseFactory', acc3);
    const houseFactory = await HouseFactory.deploy();
    factoryAddress = houseFactory.address;
    await houseFactory.deployed();
    houseRegistry = await upgrades.deployProxy(HouseRegistry, [factoryAddress], {
      initializer: 'initialize',
    });

    await houseRegistry.deployed();
    const func = await houseRegistry.listHouse(103, 103, 103, acc1.address, 'asd');
    const result = await func.wait();
    houseId = result.events[0].args[0];
  });

  it('should return empty list of houses', async function () {
    await expect(await houseRegistry.getCheapHouseIds(100)).to.deep.equal([]);
  });

  it('should return id of new house', async function () {
    const func = await houseRegistry
      .connect(acc2)
      .listHouse(100, 100, 100, '0x5b38da6a701c568545dcfcb03fcb875f56beddc4', 'asd');
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal(20828);
  });

  it('should retirn id of cheepest house', async function () {
    const func = await houseRegistry.getCheapHouseIds(200);
    await expect(func[0]).to.equal(houseId);
  });

  it('should return succes of delisted', async function () {
    const func = await houseRegistry.delistHouse(houseId);
    const result = await func.wait();
    await expect(result.events[0].args[0]).to.equal('delisted was successful');
  });

  it('should return error You do not have access', async function () {
    const message = 'You do not have access';
    expect(houseRegistry.connect(acc2).delistHouse(houseId)).to.be.revertedWith(message);
  });

  it('should return error his houseId already exists', async function () {
    const message = 'this houseId already exists';
    expect(
      houseRegistry.connect(acc3).listHouse(103, 103, 103, acc1.address, 'asd')
    ).to.be.revertedWith(message);
  });

  it('should return error The owner cannot add a new home', async function () {
    const message = 'The owner cannot add a new home';
    expect(houseRegistry.listHouse(103, 103, 103, acc1.address, 'asd')).to.be.revertedWith(message);
  });

  it('should return error value cannot be null', async function () {
    const message = 'value cannot be null';
    expect(houseRegistry.connect(acc3).listHouse(0, 0, 0, acc1.address, 'asd')).to.be.revertedWith(
      message
    );
  });
});
