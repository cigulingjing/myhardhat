// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract interCall{
    
    address codeStoraddress=0x0000000000000000000000000000000000000043;
    string codeSorSign="callFunc(string,bytes)";

    function test(int256 a, int256 b) external returns(int256){
        string memory funName="add";
        // Encode
        bytes memory input=abi.encode(a,b);
        (bool success,bytes memory output)=codeStoraddress.call(abi.encodeWithSignature(codeSorSign,funName,input));
        require(success,"Low-level call error");
        // Decode
        int256 c=abi.decode(output,(int256));
        return c;
    }

}