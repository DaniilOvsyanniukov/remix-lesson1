/* eslint-disable prettier/prettier */
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('HouseRegistry', function () {
  let acc1: any
  let acc2: any
  let acc3: any
  let houseRegistry: any
  let houseId: any

  beforeEach(async function () {
    [acc1, acc2, acc3] = await ethers.getSigners()
    const HouseRegistry = await ethers.getContractFactory('HouseRegistry');
    houseRegistry = await HouseRegistry.deploy();
    await houseRegistry.deployed();
    const func = await houseRegistry.listHouse(103, 103, 103, acc1.address, "asd");
    const result = await func.wait();
    houseId = result.events[0].args[0];
    

  });

  //   it('return address', async function () {
  //   const func = await houseRegistry.connect(acc2).forTesting(houseId);
  //   // console.log(acc2.address)
  //   console.log(func)
  //   // await expect(func).to.equal(acc2.address);
  // });

  it('should return empty list of houses', async function () {
    await expect(await houseRegistry.getCheapHouseIds(100)).to.deep.equal([]);
  });

  it('should return id of new house', async function () {
    const func = await houseRegistry.connect(acc2).listHouse(
        100,
        100,
        100,
        "0x5b38da6a701c568545dcfcb03fcb875f56beddc4",
        "asd"
    )
    const result = await func.wait()
    await expect(result.events[0].args[0]).to.equal(20828);
  });

  it('should retirn id of cheepest house', async function () {
    const func = await houseRegistry.getCheapHouseIds(200);
    await expect(func[0]).to.equal(houseId);
  });

  // it('testfunc', async function () {
  //   const func = await houseRegistry.connect(acc2).testfunction(houseId)
  //       // const result = await func.wait()
  //       console.log(func)

  //   });

  it('should return succes of delisted', async function () {
    const func = await houseRegistry.delistHouse(houseId)
    const result = await func.wait()
    await expect(result.events[0].args[0]).to.equal('delisted was successful');
  });

   it('should return error You do not have access', async function () {
    const message = "VM Exception while processing transaction: reverted with reason string 'You do not have access'";
    let result:any;

    try {
      await houseRegistry.connect(acc2).delistHouse(houseId)
    } catch(e){
    result = (e as Error).message;
}
    expect(result).to.equal(message)
  });

  it('should return error his houseId already exists', async function () {
    const message = "VM Exception while processing transaction: reverted with reason string 'this houseId already exists'";
    let result:any;

    try {
       await houseRegistry.connect(acc3).listHouse(
      103,
      103,
      103,
      acc1.address,
      "asd"
    );
    } catch(e){
    result = (e as Error).message;
}
    expect(result).to.equal(message)

  });

  it('should return error The owner cannot add a new home', async function () {
    const message = "VM Exception while processing transaction: reverted with reason string 'The owner cannot add a new home'";
    let result:any;

    try {
       await houseRegistry.listHouse(
      103,
      103,
      103,
      acc1.address,
      "asd"
    );
    } catch(e){
    result = (e as Error).message;
}
    expect(result).to.equal(message)

  });

  it('should return error value cannot be null', async function () {
    const message = "VM Exception while processing transaction: reverted with reason string 'value cannot be null'";
    let result:any;

    try {
       await houseRegistry.connect(acc3).listHouse(
      0,
      0,
      0,
      acc1.address,
      "asd"
    );
    } catch(e){
    result = (e as Error).message;
    }
    expect(result).to.equal(message)

  });


});
