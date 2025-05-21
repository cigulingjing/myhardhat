// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract interCall{
    
    address codeStoraddress=0x0000000000000000000000000000000000000043;
    string codeSorSign="callFunc(string,bytes)";
    uint public balance;
    // payable constructor can reciver ether
    constructor() payable {
        balance = msg.value;
    }

    function testAdd(int256 a, int256 b) external returns(int256){
        string memory funName="add";
        // Encode
        bytes memory input=abi.encode(a,b);
        (bool success,bytes memory output)=codeStoraddress.call(abi.encodeWithSignature(codeSorSign,funName,input));
        require(success,"Low-level call error");
        // Decode
        int256 c=abi.decode(output,(int256));
        return c;
    }

    function testBytes() external returns(bytes memory,bytes memory){
        string memory funcName="addBytes";
        bytes memory a="123"; 
        bytes memory b="456";
         bytes memory input=abi.encode(a,b);
        (bool success,bytes memory output)=codeStoraddress.call(abi.encodeWithSignature(codeSorSign,funcName,input));
        (bytes memory dea, bytes memory deb)=abi.decode(output,(bytes,bytes));
        require(success,"Low-level call error");
        return (dea,deb);
    }

    function testVerifyBallotZKP() external returns(bool){
        bytes memory v1=hex"05df615e3a4aa8660438bdf8c59f28b4b620f37979dccee83b68c0c49b8341185c5e641cd9ccf4db7d7aafaa5cb161f614894eec83ff2d795a83fcef72d005fd84639e7ca2c5f5b63f7cfa5a681ada95e93fc2a48a72b07825b3b3cc3771058f056762ff68584cf565e8be200f5ad7c6146b7cc701382f02c9b2b31b5cb7d8ed380efdce1ccb37b75f432b8912357a7b02af3a9dae56ba656d71815ac6a101b35bc0a1f79c39cb5a13263b0008517d7a7c969bb4ed46121359513ee2e1a30586";
        bytes memory v2=hex"03037c3cd6274f107e5340267910da040f30516090aa296b6753a7d6a1e2d9083505c603fbb31e45008dbdc6322c0145052575a3da7afe3126eb1ec9dfd22e0e57a8220907419af5a05ac7c6ca92db6581f2b6c1395368b3225fe760bc4657de134220d099464d5b8ad028f1ce362449b15aab92d065c19adf2e0ed7d2def0d897c901a762194201c962b1978dde75fa098eebf8f7a8ba503fb2642deb4e2d4aa3b7fd52f71cd3484e688599db3dcb5e8187d409cbf853ec61bbc8341119351e";
        bytes memory v3=hex"17837cf41ffe26c8729d20d592918e0c44e9dcadcb701981ab3f982c925220666a34de263bd4aa9797f46c33ebbe17c41461e70d8937ee4240e2285aebd3960e3172e71a98840074e036af26d8a94b902c97b58b15c42dd4f8e970f1e7925894069c5a2babd4126e8764dda3c6cf7d09723243647dfeac8806a2778062c380ddd6b90b352526da812fe12341107af632152317bcfdf595f23c1d0e6c0561a235e26cd1dd547bf869fc4347e84f96196964ee6d67ab1098bf8f139d43ba8c38fe";
        bytes memory zkp=hex"00000000000000020a964f6d6169254f8d5985b61677bed270f177987a1b81140a2ebb0daf5238902ca7f290a222704cc9973e6c03b3b7111112b8e5e9d46b29fe9977a7087b1b135ae312ed52a74701aefc2d6f5b4de7920743b9cfbee171dca17362c31da2389f07e6bd704aa85cffd2b177dfef61fb309994424ee9154115cf5f3ab1c26af69d17aa8e83a479d865306f15322f7b9f3f08db9e9c39f1081732c64aa223acb4431913cb7f8287101a763ac55ff11d05d3e717412275516d8e424b7ea97f1f40400068f3d4effb807cddc10a8c0a6d13b1fe62f18f41a036c2a25e37e7ba98467ded8540ea42b4f7ea2d7db0bf18ee257e0be530de00c7afa57dc0c08a3e98634297cd1d3742ce77c3c15ea93513370aee77a12d7920e0685d6d078448689fb0770a69a199dbf3965430fcda59f931dd3b05d14d16703dd01375400a8a6dd88effae7fa5a4c0cf500a562c65e0f36fff251542f4c81deec6b33fa8562f69f8141bd8fbc9f3826ed4c11fdc68115980c3286305c7b15c01ac98ec714d0069fba8ab3b3e7691d59c3c06377338b990bffd9e61b3476869c1485f02cbb0b649e4cc3a015f15c8c44d1bddd6821f3e72754adb156c55d488066d4221148f89c0b67daa24685cacbdfa143d810d76c033510eba7b5eff9190650b5f12e269ee8613e9581833dfeada3f9618eaba720c959b4f6525c23281d929e9597b4ff4992f3fe49eae9f4867a6a18ce4838e299be479f6ba10b6805352114890c3adabc46d5546342db11a8b2f829e340f24d39f640c002d55c1ed9302ca183fd18a273f7f300658041fc22e2993ce319eff2529bf9fb75c3691a905c66a31adc54ef2bf631efe4fc9a110059ce21fe510fde498cdbe0db11254080c55481addde78b6302f492c051a7aa0c9607187c77c44bdda9bb07a986f0be918180c93ebf37f0d9f2d8e23091697e602eedfb23c6e158902826837e7c960428231f05bc7ba6fa4f8050407bae19adf6162fdddaa39cd203d6f0bbe870add774e7b3b7b1bf5964af6556052516c3d65fb213af2926ea3a343e69357e1167335f68b116a7fcaa41fec8b10902b0ab34cc1411f21e1e3f8e5f1d477ba3b45ccab93e69c276d042c51560a50b2db621ec951409d03e7e641a08155676ad70640715b0a5141856f0fc6254683411b05b4be9e4002d06f088eb2880ebf92ce5addd0ff74b0be883a2dd61c85faac641726636adcaa94539d144e60878f9581b3956947002439504cc7bbcfff1e1b291d46c20672e158c277a0ad7b8899b24d5015139be3c86482ebeb1ae945b34ed862019a151a70d9b0a37d31204cc831f0dea155f68b7067d3913eeeb27b72dbbd5c266970a7ac9f7741d7d106fb0ded69c71712e3bc19ac32b38b69cdfba84c03";
        bytes memory g=hex"17f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb08b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1";
        bytes memory pk=hex"13dba1a0ae4019652e1e9175cbe19ec4f660edbb596e6c19d4fc6dddbfb81c67c5c0a28d4eb96bd59125b2443db16df801c9abaa3e454cad249a490d46ca2626f1a356dd2ea3d1bb9d0f956d2da20bf25c6ccefe80e42923b704a1d22d78939c";


        bytes memory input=abi.encode(v1,v2,v3,zkp,g,pk);
        string memory funName="verifyBallotZKP";
        (bool success,bytes memory output)=codeStoraddress.call(abi.encodeWithSignature(codeSorSign,funName,input));
        require(success,"Low-level call error");
        // Decode
        bool result=abi.decode(output,(bool));
        return result;
    }

}