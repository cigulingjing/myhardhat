const { expect } = require("chai");
const { ethers } = require("hardhat");

// Convert str to UTF-8
function stringToBytes10(str) {
    let encoded = new TextEncoder().encode(str);
    if (encoded.length > 10) {
        encoded = encoded.slice(0, 10);
    }
    // Zero padding 
    const padded = new Uint8Array(10); // Create a new array of length 10
    padded.set(encoded); // Copy the encoded array into the new array
    return padded; // Return the padded result
}

function uint8ArrayToHex(arr) {
    return '0x' + Array.from(arr, byte => byte.toString(16).padStart(2, '0')).join('');
}


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

    it("Get code and gas",async function(){
        returncode=await codestorage.getCode(goFileName);
        returngas=await codestorage.getGas(goFileName);
        expect(code).to.equal(returncode);
        expect(returngas).to.equal(returngas);
        // Ownable is removed 
        // await expect(codestorage.connect(addr1).uploadCode(goFileName,code,gas)).to.be.revertedWith("OwnableUnauthorizedAccount");
    });

    it("Get code Info",async function(){
        let [returnCode,returnGas,returnItype,returnOtype]= await codestorage.getInfo(goFileName);
        expect(code).to.equal(returnCode);
        expect(returngas).to.equal(returnGas);
        // ReturnItype is Hex string (bytes[10])
        expect(returnItype).to.deep.equal(itype);
        expect(returnOtype).to.deep.equal(otype);

    });

    it("updata gas", async function () {
        let newGas=100;
        await codestorage.updataGas(goFileName,100);
        returngas=await codestorage.getGas(goFileName);
        expect(returngas).to.equal(newGas);
      });

});