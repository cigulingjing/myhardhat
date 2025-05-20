// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


contract Serialize{

    function encode(int a, int b) external pure returns (bytes memory) {
        // Abi 
        bytes memory input=abi.encode(a,b);
        return input;
    }

    function encodePacked(uint a, address b, string memory c) external pure returns (bytes memory) {
        // Abi 
        bytes memory input=abi.encodePacked(a,b,c);
        return input;
    }

    function TestBytes(bytes memory a, bytes memory b) external pure returns (bytes memory,bytes memory) {
        // Abi 
        bytes memory input=abi.encode(a,b);
        (bytes memory dea, bytes memory deb)=abi.decode(input,(bytes,bytes));
        return (dea,deb);
    }


    function unpack(bytes memory input) external pure returns(uint, address, string memory){
        (uint a,address b,string memory c)=abi.decode(input,(uint,address,string));
        return (a,b,c);
    } 

    function add(uint a,uint b) public pure returns (uint){
        return a+b;
    }

}
