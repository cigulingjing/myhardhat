const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("codestorage contract",function(){

    let owner,addr1,addr2;
    let code="Hello world";
    let goFileName="hello.go";
    let gas=10000;

    beforeEach(async function () {
        [owner,addr1,addr2] = await ethers.getSigners();
        CodeStorage=await ethers.getContractFactory("CodeStorage");
        codestorage=await CodeStorage.deploy();
        await codestorage.deployed();
    });

    it("upload and get code",async function(){
        
        codestorage.uploadCode(goFileName,code,gas);

        returncode=await codestorage.getCode(goFileName)
        returngas=await codestorage.getGas(goFileName)
        
        expect(code).to.equal(returncode);
        expect(returngas).to.equal(returngas);
        await expect(codestorage.connect(addr1).uploadCode(goFileName,code,gas)).to.be.revertedWith("OwnableUnauthorizedAccount");
    });

    it("updata gas", async function () {
        let newGas=100;
        await codestorage.uploadCode(goFileName,code,gas);
        
        await codestorage.updataGas(goFileName,100)
        returngas=await codestorage.getGas(goFileName)
        expect(returngas).to.equal(newGas)
        await expect(codestorage.connect(addr1).updataGas(goFileNafme,100)).to.be.revertedWith("OwnableUnauthorizedAccount");
      });

});