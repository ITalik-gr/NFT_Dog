const { assert, expect } = require("chai")
const { network, deployments, ethers } = require("hardhat")
const { developmentChains } = require("../../helper-hardhat-config")

!developmentChains.includes(network.name)
  ? describe.skip 
  : describe("Basic NFT Test", function() {

    let BasicNft, basicNft, accounts, deployer;
    beforeEach(async function() {
      accounts = await ethers.getSigners() // could also do with getNamedAccounts
      deployer = accounts[0]

      await deployments.fixture(["basicnft"])
      basicNft = await ethers.getContract("BasicNft")
    })

    it("Constructor", async function() {
      let name = await basicNft.name();
      let symbol = await basicNft.symbol()
      let tokenCounter = (await basicNft.getTokenCounter()).toString()
      assert.equal(name, "Dogie");
      assert.equal(symbol, "DOG");
      assert.equal(tokenCounter, "0");
    })
  })