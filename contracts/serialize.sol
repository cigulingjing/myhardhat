// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


contract Serialize{

    function pack(uint a, address b, string memory c) external pure returns (bytes memory) {
        // Abi 
        bytes memory input=abi.encode(a,b,c);
        return input;
    }

    function unpack(bytes memory input) external pure returns(uint, address, string memory){
        (uint a,address b,string memory c)=abi.decode(input,(uint,address,string));
        return (a,b,c);
    } 

}
