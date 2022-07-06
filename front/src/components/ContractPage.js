import React, { Component } from 'react';
import { ethers } from 'ethers';

import houseRegistryExtAddress from '../contracts/HouseRegistryExtcontract-address.json';
import houseRegistryExtArtifact from '../contracts/HouseRegistryExt.json';
import { ConnectWallet } from './ConnectWallet';


const HARDHAT_NETWORK_ID = '4';
const ERROR_CIDE_TX_REJECTED_BY_USER = 4001;

export default class ContractPage extends Component{
    constructor(props) {
        super(props)
        
        this.initialstate = {
            selectedAccount: null,
            txBeingSent: null,
            networkError: null,
            transactionError: null,
            balance:null,
            daiAddress: null,
            priceEth: null,
            priceDai: null,
            houseArea: null,
            houseAddress: null,
            newHouseId: null,
            tokenHouseAddress: null,
            tokenHouseId:null
        }
        this.state= this.initialstate
    }
    _connectWallet = async () => {
        if (window.ethereum === undefined) {
            this.setState({
                networkError:'Please install Metamask'
            })
            return
        }
        const [selectedAddress] = await window.ethereum.request({
            method : 'eth_requestAccounts'
        })

        if (!this._checkNetwork()) { return }
        this._initialaze(selectedAddress)
        window.ethereum.on('accountsChanged', ([newAddress]) => {
            if (newAddress === undefined) {
                return this._resetState()
            }
            this._initialaze(newAddress)
        })
        window.ethereum.on('chainChanged', ([networkId]) => {
            this._resetState()
        })
    }
    async _initialaze(selectedAddress) {
        this._provider = new ethers.providers.Web3Provider(window.ethereum)
        this.houseRegistryExt = new ethers.Contract(
            houseRegistryExtAddress.HouseRegistryExt, 
            houseRegistryExtArtifact.abi,
            this._provider.getSigner(0)
        )
        
        this.setState({
            selectedAccount: selectedAddress,
        }, async () => {
            await this.updateBalance()
            await this.updateDaiAddress()
        })
    }

    async updateBalance() {
        const newBalance = (await this._provider.getBalance(this.state.selectedAccount)).toString()
        this.setState({
            balance:newBalance
        })
        
    }

    _formsubmit= async () => {
      const func = (await this.houseRegistryExt.listHouseSimple(this.state.priceEth, this.state.priceDai, this.state.houseArea, this.state.houseAddress))
      const result = await func.wait()
      console.log(result.events[0].args[0].toString().slice(-5))
      this.setState({
         newHouseId:result.events[0].args[0].toString().slice(-5)
      })
      
      this._resetInput();
    }
    
    async updateDaiAddress() {
        const newDaiAddress = (await this.houseRegistryExt.daiAddress()).toString()
        this.setState({
            daiAddress:newDaiAddress
        })
    }

    _resetInput() {
        this.setState({
            priceEth: null,
            priceDai: null,
            houseArea: null,
            houseAddress: null,
            tokenHouseId: null
        })
    }
    _resetState() {
        this.state(this.initialstate)
    }

    _checkNetwork() {
        if (window.ethereum.networkVersion === HARDHAT_NETWORK_ID) { return true }
        this.setState({
            networkError: 'Please connect to Rinkeby'
        })
        return false
    }
    _dismissNetworkError = () => {
        this.setState({
            networkError:null
        })
  }
  
   getHouseAddress= async () =>{
     const HouseAddress = await (this.houseRegistryExt.houses(this.state.tokenHouseId))
     console.log(HouseAddress)
     this.setState({
       tokenHouseAddress: HouseAddress
     })
    this._resetInput();
  }
//     _confirmEdit = (e) => {
//     e.preventDefault();
//     setShowConfirmModal(true)
//     setDeleteConfirmModal(false)
//   }

//    _confirmDelete = () => {
//     setShowConfirmModal(true)
//     setDeleteConfirmModal(true)
//   }

    

 

    _handleInputChange = (e) => {
      e.preventDefault();
    const { name, value } = e.currentTarget;

    switch (name) {
        case "priceETH":
        this.setState({
            priceEth: value
        })
        break;
      case "priceDai":
       this.setState({
            priceDai: value
        })
        break;
      case "houseArea":
        this.setState({
            houseArea: value
        })
        break;
      case "houseAddress":
        this.setState({
            houseAddress: value
        })
        break;
      case "tokenHouseId":
        this.setState({
          tokenHouseId: value
        })
        break;
      default:
        return;
    }
  };

    render() {
        if (!this.state.selectedAccount) {
            return <ConnectWallet
                connectWallet={this._connectWallet}
                networkError={this.state.networkError}
                dismiss={this._dismissNetworkError}/>
        }
        return <>
            {this.state.balance && <p> Your balance: {ethers.utils.formatEther(this.state.balance)} ETH</p>}
            {this.state.daiAddress && <p> DaiAddress: {ethers.utils.formatEther(this.state.daiAddress)}</p>}
          {this.state.newHouseId && <p> Last added House ID : {this.state.newHouseId} </p>}
        <ul className='formInputList'>
          <li className='formInputItem'>
            <label className='label'>
              ETH 
              <input
                className='input'
                type="number"
                name="priceETH"
                value={this.priceEth}
                onChange={this._handleInputChange}
                pattern="^[ 0-9]+$"
                title="Enter price ETH"
                required
              />
            </label>
          </li>
          <li  className='formInputItem'>
            <label className='label'>
              DAI
              <input
                className='input'
                type="number" 
                name="priceDai"
                value={this.proceDai}
                onChange={this._handleInputChange}
                title="Enter price DAI"
                required
              /> 
            </label>
          </li>
          <li  className='formInputItem'>
            <label className='label'>
              Area 
              <input
                className='input'
                type="number"
                name="houseArea"
                value={this.houseArea}
                onChange={this._handleInputChange}
                title="Enter house area"
              />
            </label>
          </li>
           <li  className='formInputItem'>
            <label className='label'>
              Address 
              <input
                className='input'
                type="text"
                name="houseAddress"
                value={this.houseAddress}
                onChange={this._handleInputChange}
                title="Enter phisical address"
              />
            </label>
          </li>
        </ul> 

            <button type="button" onClick={this._formsubmit}>
                Add House
          </button>
          <p>Find House Address by ID</p>
          <label className='label'>
              Address 
              <input
                className='input'
                type="text"
                name="tokenHouseId"
                value={this.tokenHouseId}
                onChange={this._handleInputChange}
                title="Enter House ID"
              />
          </label>
          <button type="button" onClick={this.getHouseAddress}>
                Get Address
          </button>

          {this.state.tokenHouseAddress && <p> The address of the house you are looking for : {this.state.tokenHouseAddress} </p>}

      </>
      
     
        
    }
}


