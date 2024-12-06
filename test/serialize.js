const { SignerWithAddress } = require("@nomiclabs/hardhat-ethers/signers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Serialize contract test",function(){

    let owner,sign1,sign2;
    let value=100;
    let code="hello.go";

    beforeEach(async function () {
        [owner,sign1,sign2] = await ethers.getSigners();
        Serialize=await ethers.getContractFactory("Serialize");
        serialize=await Serialize.deploy();
        await serialize.deployed();
    });

    it("Serialize arguments",async function(){
        const addr=await sign1.getAddress();
        packedData = await serialize.pack(value,addr,code);
        console.log(packedData);

        let [value1, addr1, code1] = await serialize.unpack(packedData);
        expect(value1).to.equal(value);
        expect(addr1).to.equal(addr);
        expect(code1).to.equal(code);

    });
});