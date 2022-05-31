import * as dotenv from 'dotenv';
import { HardhatUserConfig, task } from 'hardhat/config';
// import "@nomiclabs/hardhat-ganache";
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
import '@typechain/hardhat';
import 'hardhat-gas-reporter';
import 'solidity-coverage';
import '@openzeppelin/hardhat-upgrades';
import 'hardhat-contract-sizer';

dotenv.config();

interface Etherscan {
  etherscan: { apiKey: string | undefined };
}

type HardhatUserEtherscanConfig = HardhatUserConfig & Etherscan;

const INFURA_API_KEY = process.env.INFURA_API_KEY || '';
const RINKEBY_PRIVATE_KEY =
  process.env.RINKEBY_PRIVATE_KEY! ||
  '0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3'; // well known private key
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserEtherscanConfig = {
  defaultNetwork: 'hardhat',
  solidity: {
    compilers: [{ version: '0.8.1', settings: {} }],
  },
  networks: {
    hardhat: {},
    localhost: {},
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [RINKEBY_PRIVATE_KEY],
    },
    coverage: {
      url: 'http://127.0.0.1:8555', // Coverage launches its own ganache-cli client
    },
  },

  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: 'USD',
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
