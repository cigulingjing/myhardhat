// test/MutiVoucherTest.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MutiVoucher Contract", function () {
  let MutiVoucher;
  let mutiVoucher;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    // Deploy mutivoucher
    [owner, addr1, addr2] = await ethers.getSigners();

    MutiVoucher = await ethers.getContractFactory("MutiVoucher");
    mutiVoucher = await MutiVoucher.deploy();
    await mutiVoucher.deployed();
  });

  describe("Voucher creation", function () {
    it("should allow the owner to create a voucher", async function () {
      await mutiVoucher.createVoucher("VoucherA", 10);

      const conversionRate = await mutiVoucher.getVoucherInfo("VoucherA");
      expect(conversionRate).to.equal(10);
    });

    it("should fail if someone other than the owner tries to create a voucher", async function () {
      await expect(mutiVoucher.connect(addr1).createVoucher("VoucherB", 20)).to.be.revertedWith("OwnableUnauthorizedAccount");
    });
  });

  describe("Buying vouchers", function () {
    beforeEach(async function () {
      await mutiVoucher.createVoucher("VoucherA", 10);  // Create VoucherA first
    });

    it("should allow a user to buy a voucher", async function () {
      const initialBalance = await mutiVoucher.balanceOf("VoucherA", addr1.address);
      expect(initialBalance).to.equal(0);

      // addr1 buys 5 VoucherA
      await mutiVoucher.connect(addr1).buy("VoucherA", 5, { value: 50 });

      const newBalance = await mutiVoucher.balanceOf("VoucherA", addr1.address);
      expect(newBalance).to.equal(5);
    });

    it("should fail if the wrong amount of ETH is sent", async function () {
      await expect(mutiVoucher.connect(addr1).buy("VoucherA", 5, { value: 40 })).to.be.revertedWith("Incorrect amount sent");
    });

    it("should fail if the voucher does not exist", async function () {
      await expect(mutiVoucher.connect(addr1).buy("VoucherNonExistent", 5, { value: 50 })).to.be.revertedWith("Voucher doesn't exist");
    });
  });

  describe("Using vouchers", function () {
    beforeEach(async function () {
      await mutiVoucher.createVoucher("VoucherA", 10);
      await mutiVoucher.connect(addr1).buy("VoucherA", 5, { value: 50 });
    });

    it("should allow a user to use their voucher", async function () {
      const initialBalance = await mutiVoucher.balanceOf("VoucherA", addr1.address);
      expect(initialBalance).to.equal(5);

      await mutiVoucher.connect(addr1).use("VoucherA", 2);

      const newBalance = await mutiVoucher.balanceOf("VoucherA", addr1.address);
      expect(newBalance).to.equal(3);
    });

    it("should fail if the user does not have enough balance", async function () {
      await expect(mutiVoucher.connect(addr1).use("VoucherA", 6)).to.be.revertedWith("Insufficient balance");
    });
  });

  describe("Renouncing ownership", function () {
    it("should allow the owner to renounce ownership", async function () {
      await mutiVoucher.connect(owner).renounceOwnership();
      
      const currentOwner = await mutiVoucher.owner();
      expect(currentOwner).to.equal(ethers.constants.AddressZero);
    });

    it("should fail if non-owner tries to renounce ownership", async function () {
      await expect(mutiVoucher.connect(addr1).renounceOwnership()).to.be.revertedWith("OwnableUnauthorizedAccount");
    });
  });
});
