const { ethers } = require("hardhat")

const networkConfig = {
    31415: {
        name: "hyperspace",
        tokenToBeMinted: 12000,
    },
}

// const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    // developmentChains,
}
