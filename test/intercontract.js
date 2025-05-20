const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("interCall", function () {
  let interCall;
  let owner;
  const initialValue = ethers.utils.parseEther("1");

  beforeEach(async function () {
    [owner] = await ethers.getSigners();
    const InterCall = await ethers.getContractFactory("interCall");
    interCall = await InterCall.deploy({ value: initialValue });
    await interCall.deployed();
  });

  it("Should set the correct balance on deployment", async function () {
    const contractBalance = await interCall.balance();
    expect(contractBalance).to.equal(initialValue);
  });
});