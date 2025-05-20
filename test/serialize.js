const { SignerWithAddress } = require("@nomiclabs/hardhat-ethers/signers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Serialize contract test",function(){

    let owner,sign1,sign2;
    let value1=100;
    let value2=100;

    beforeEach(async function () {
        [owner,sign1,sign2] = await ethers.getSigners();
        Serialize=await ethers.getContractFactory("Serialize");
        serialize=await Serialize.deploy();
        await serialize.deployed();
    });

    it("Serialize arguments, Using abi.encode",async function(){
        const addr=await sign1.getAddress();
        packedData = await serialize.encode(value1,value2);
        console.log(packedData);
    });

    it("Serialize arguments, Using abi.encodePacked",async function(){
        const addr=await sign1.getAddress();
        packedData = await serialize.encodePacked(value1,addr,code);
        console.log(packedData);

        // let [value1, addr1, code1] = await serialize.unpack(packedData);
        // expect(value1).to.equal(value);
        // expect(addr1).to.equal(addr);
        // expect(code1).to.equal(code);
    });

    it("Serialize bytes, including encode and decode",async function(){
        const addr=await sign1.getAddress();

        const a= ethers.utils.toUtf8Bytes("123");
        const b= ethers.utils.toUtf8Bytes("456");
        let result = await serialize.TestBytes(a,b);
        console.log("dea",result[0]);
        console.log("deb",result[1]);
    })
});