/* eslint-disable prettier/prettier */
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('DaiToken', function () {
  let acc1: any;
  let daiToken: any;

  beforeEach(async function () {
    [acc1] = await ethers.getSigners();
    const DaiToken = await ethers.getContractFactory('DaiToken', acc1);
    daiToken = await DaiToken.deploy();
    await daiToken.deployed();
  });

  it('should be deployed', async function () {
    // eslint-disable-next-line no-unused-expressions
    expect(daiToken.address).to.be.properAddress;
  });
});
