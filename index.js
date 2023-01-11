const Web3 = require("web3");
const {ToHex,ToWei} = require('web3-utils')
const program = require("commander");
const web3 = new Web3("ws://localhost:8546"); 
//connecting to the local node

const contractAddress = "0x.........."; // replace with your contract's address
const abi = [{}]; // replace with your contract's ABI

// create a contract object
const contract = new web3.eth.Contract(abi, contractAddress);

program
  .version("0.0.1")
  .description("DeltaDataDAO CLI")

program
  .command("proposeCid <assignedStorageProvider> <cidRaw> <size> <expiryAt> <reward>")
  .alias("p")
  .description("Propose new CID")
  .action(async (assignedStorageProvider, cidRaw, size, expiryAt, reward) => {
    // Prepare input data
    expiryAt = Math.floor(expiryAt/1000)
    reward = ToWei(reward,"ether")
    // Call the proposeCid function and pass in the input data
    const receipt = await contract.methods.proposeCid(assignedStorageProvider,cidRaw,size,expiryAt,reward).send({
        from:web3.eth.defaultAccount,
        gas:3000000
    });
    console.log("Proposal created:", receipt);
  });

program
  .command("voteCid <proposalId> <vote>")
  .alias("v")
  .description("Vote on a proposal")
  .action(async (proposalId, vote) => {
    // Prepare input data
    vote = vote == true? true : false // vote should be either true or false
    // Call the voteCid function and pass in the input data
    const receipt = await contract.methods.voteCid(proposalId,vote).send({
        from:web3.eth.defaultAccount,
        gas:3000000
    });
    console.log("Vote casted:", receipt);
  });

program
  .command("endVoting <proposalId>")
  .alias("e")
  .description("End voting for a proposal")
  .action(async (proposalId) => {
    // Call the endVoting function 
    const receipt = await contract.methods.endVoting(proposalId).send({
        from:web3.eth.defaultAccount,
        gas:3000000
    });
    console.log("Voting ended:", receipt);
  });

program.parse(process.argv);
