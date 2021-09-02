const path = require('path');
const fs = require('fs');
const solc = require('solc');
const inboxPath = path.resolve(__dirname, 'contracts', 'Inbox.sol');

const source = fs.readFileSync(inboxPath, 'utf8');

var input = {
  language: 'Solidity',
  sources: {
    Inbox: {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['*'],
      },
    },
  },
};

// console.log(

// );
module.exports = JSON.parse(
  solc.compile(JSON.stringify(input)),
).contracts.Inbox.Inbox;
