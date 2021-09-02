const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const { abi, evm } = require('../compile');
const web3 = new Web3(ganache.provider());
// Using ganache GUI and connecting to external networks.
// const web3 = new Web3(new Web3.providers.HttpProvider('HTTP://127.0.0.1:7545'));

let accounts;
let lottery;
beforeEach(async () => {
  // Get a list of all accounts
  accounts = await web3.eth.getAccounts();

  // use one of the accounts to deploy the contract
  //   console.log(evm.bytecode);
  lottery = await new web3.eth.Contract(abi)
    .deploy({
      data: evm.bytecode.object,
    })
    .send({ from: accounts[0], gas: '1000000' });
});

describe('Lottery', async () => {
  it('Deployed a contract', async () => {
    console.log(lottery.options.address);
    assert.ok(lottery.options.address);
  });

  it('Has a default manager', async () => {
    const managerAddress = await lottery.methods.manager().call();
    console.log(managerAddress);
    assert.ok(managerAddress == accounts[0]);
  });
});
