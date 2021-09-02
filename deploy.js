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
  //   let tx = new Tx({
  //     from: '0x187DEC17d04477AA90a8f9BC263AB40e42e29897',
  //     to: accounts[0],
  //     gasPrice: '0x4a717c800',
  //     gasLimit: '0xc340',
  //     value: '0x' + Number(web3.utils.toWei('0.1', 'ether')).toString(16),
  //     data: '0x',
  //   });
  //   tx.sign(privateKey);
  //   await web3.eth.sendSignedTransaction('0x' + tx.serialize().toString('hex'));
  // use one of the accounts to deploy the contract
  // console.log(evm.bytecode);
  inbox = await new web3.eth.Contract(abi)
    .deploy({
      data: evm.bytecode.object,
    })
    .send({ from: accounts[0], gas: '1000000' });
  fs.writeFileSync('./ABI.json', JSON.stringify(abi));
  console.log(inbox.options.address);
};

deploy();
