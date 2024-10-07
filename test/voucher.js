const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Voucher Contract", function () {

    const EXCHANGE_RATE = 5000; //  Voucher:ETH = 1:1
    const MIN_AMOUNT = ethers.utils.parseEther("0.1");   // 0 ETH equal to 10**18 wei
    const BUY_EXPIRATION = Math.floor(Date.now() / 1000) + 3600; // 1 hour from now
    const USE_EXPIRATION = Math.floor(Date.now() / 1000) + 7200; // 2 hours from now

    beforeEach(async function () {
        [owner, dApp, addr1, addr2] = await ethers.getSigners();

        // Deploy the Voucher contract
        const VoucherFactory = await ethers.getContractFactory("Voucher");
        voucher = await VoucherFactory.deploy("Voucher Token", "VCH", dApp.address, {
            originToken: ethers.constants.AddressZero,
            minAmount: MIN_AMOUNT,
            exchangeRate: EXCHANGE_RATE,
            buyExpiration: BUY_EXPIRATION,
            useExpiration: USE_EXPIRATION,
        });
    });
    
    describe("Deployment", function () {
        it("should set the correct name and symbol", async function () {
            expect(await voucher.name()).to.equal("Voucher Token");
            expect(await voucher.symbol()).to.equal("VCH");
        });

        it("should set the DApp correctly", async function () {
            expect(await voucher.dApps(dApp.address)).to.be.true;
        });
    });

    describe("Buying Vouchers", function () {
        it("should mint tokens when ETH is sent", async function () {
  
            const ethAmount = ethers.utils.parseEther("0.5"); // Transfer 0.5 ETH
            // Construct Transaction, 1. tx.value=eth.Amount 2.Transfer ethAmount to buy
            await voucher.connect(addr1).buy(ethAmount, { value: ethAmount });
            const balance = await voucher.balanceOf(addr1.address);

            expect(balance).to.equal(ethers.utils.parseUnits("0.5", 18)); // 500 tokens assuming 1 ETH = 1000 tokens
        });
    });
});