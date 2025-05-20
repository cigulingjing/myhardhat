const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("codestorage contract",function(){
    let owner,addr1,addr2;
    let code="Hello world";
    let goFileName="hello.go";
    let gas=10000;
    let itype="uint,string,address";
    let otype="int,string";

    beforeEach(async function () {
        [owner,addr1,addr2] = await ethers.getSigners();
        CodeStorage=await ethers.getContractFactory("CodeStorage");
        codestorage=await CodeStorage.deploy();
        await codestorage.deployed();
        // Upload code 
        await codestorage.uploadCode(goFileName,code,gas,itype,otype);
    });

    it("Get code Info",async function(){
        let [returnCode,returnGas,returnItype,returnOtype]= await codestorage.getInfo(goFileName);
        expect(returnCode).to.equal(code);
        expect(returnGas).to.equal(gas);
        // ReturnItype is Hex string (bytes[10])
        expect(returnItype).to.deep.equal(itype);
        expect(returnOtype).to.deep.equal(otype);
    });

    it("Should not upload same algorithm twice",async function(){
        await expect(
            codestorage.uploadCode(goFileName,code,gas,itype,otype)
        ).to.revertedWith("algorithm already exist");
    });

    it("updata gas", async function () {
        let newGas=100;
        await codestorage.updataGas(goFileName,100);
        returngas=await codestorage.getGas(goFileName);
        expect(returngas).to.equal(newGas);
      });

});

describe("contract benchmark",function(){
    let owner,addr1,addr2;
    let code="Hello world";
    let goFileName="hello.go";
    let gas=10000;
    let itype="uint,string,address";
    let otype="int,string";

    beforeEach(async function () {
        [owner,addr1,addr2] = await ethers.getSigners();
        CodeStorage=await ethers.getContractFactory("CodeStorage");
        codestorage=await CodeStorage.deploy();
        await codestorage.deployed();
        // Upload code 
        // await codestorage.uploadCode(goFileName,code,gas,itype,otype);
    });
    it("upload code time", async function () {
        let startTime = Date.now();
        await codestorage.uploadCode(goFileName,code,gas,itype,otype);
        let endTime = Date.now();
        let duration = endTime - startTime;
        console.log("upload code time: ", duration);
    });
});