const Web3 = require('web3');
const { abi, evm } = require('./compile');
const fs = require('fs');
var Tx = require('ethereumjs-tx').Transaction;
// Using ganache GUI and connecting to external networks.
const web3 = new Web3(new Web3.providers.HttpProvider('HTTP://127.0.0.1:7545'));

let accounts;
let inbox;

// const privateKey = Buffer.from(
//   '2341f7fa380430821118b238f0b2228de652812af0fdf7ce273c92627d9bcecf',
//   'hex',
// );

// console.log();
const deploy = async () => {
  // Get a list of all accounts
  accounts = await web3.eth.getAccounts();

  inbox = await new web3.eth.Contract(abi)
    .deploy({
      data: evm.bytecode.object,
    })
    .send({ from: accounts[0], gas: '1000000' });
  fs.writeFileSync('./ABI.json', JSON.stringify(abi));
  console.log(inbox.options.address);
};

deploy();
