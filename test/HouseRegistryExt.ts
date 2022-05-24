/* eslint-disable prettier/prettier */
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('HouseRegistryExt', function () {
    let acc1: any
    let acc2: any
    let acc3: any
    let houseRegistryExt: any
    let daiToken: any
    let houseId: any
    let daiAddress: any

    beforeEach(async function () {
        [acc1, acc2, acc3] = await ethers.getSigners()
        const HouseRegistryExt = await ethers.getContractFactory('HouseRegistryExt', acc1)
        const DaiToken = await ethers.getContractFactory('DaiToken', acc3)
        houseRegistryExt = await HouseRegistryExt.deploy()
        daiToken = await DaiToken.deploy()
        await houseRegistryExt.deployed()
        await daiToken.deployed()
        const func = await houseRegistryExt.connect(acc2).listHouseSimple(103, 103, 103, "asd");
        const result = await func.wait();
        houseId = result.events[0].args[0];
        daiAddress = daiToken.address

    });

    it('should be deployed', async function () {
        expect(houseRegistryExt.address).to.be.properAddress
        expect(daiToken.address).to.be.properAddress
    });
    

    it('should return id of new house', async function () {
        const func = await houseRegistryExt.connect(acc1).listHouseSimple(
            100,
            100,
            100,
            "asd"
        )
        const result = await func.wait()
        await expect(result.events[0].args[0]).to.equal(96932);
    });

    it('should return succesful', async function () {
        const func = await houseRegistryExt.buyHouseWithETH(
            houseId, {value: 103}
            )
        const result = await func.wait()
        await expect(result.events[0].args[0]).to.equal('Transactions succesful');
    });
// 
    // it('testfunc', async function () {
    //     const ololo = await houseRegistryExt.connect(acc3).approveTransaction(houseRegistryExt.address, 103, daiAddress)
    //     await ololo.wait();
         
    //     const func = await houseRegistryExt.connect(acc3).testfunctionext(acc3.address, houseRegistryExt.address, daiAddress)
    //     const result = await func.wait()
    //     console.log(result.events)

    // });
// 
    it('should return insufficient funds', async function () {
        const message = "VM Exception while processing transaction: reverted with reason string 'value less than cost'";
        let result:any;

        try {
            await houseRegistryExt.buyHouseWithETH(
            houseId, {value: 100}
            )
        } catch(e){
            result = (e as Error).message;
        }
        expect(result).to.equal(message)
    });

    it('should return approved', async function () {
        const func = await houseRegistryExt.connect(acc1).approveTransaction(acc3.address, 103, daiAddress)
        const result = await func.wait();
        await expect(result.events[1].args[0]).to.equal('transaction approved');
        
    });

    it('should return insufficient funds', async function () {
        const message = "VM Exception while processing transaction: reverted with reason string 'transaction dont approve'";
        let result: any;
        try {
            await houseRegistryExt.connect(acc3).buyHouseWithDai(
            houseId)
        } catch(e){
            result = (e as Error).message;
        }
        expect(result).to.equal(message)
    });

    it('should return Transactions succesful', async function () {
        const approveFunc = await houseRegistryExt.connect(acc3).approveTransaction(houseRegistryExt.address, 200, daiAddress)
        await approveFunc.wait()
        const func = await houseRegistryExt.connect(acc3).buyHouseWithDai(
            houseId
        )
        const result = func.wait()
        await expect(result.events[0].args[0]).to.equal('Transactions succesful')
    });

   it('should return succesful', async function () {
        const func = await houseRegistryExt.buyHouseWithETH(
            houseId, {value: 200}
        )
        const result = await func.wait()
        await expect(result.events[0].args[0]).to.equal('Transactions succesful');
    });

});