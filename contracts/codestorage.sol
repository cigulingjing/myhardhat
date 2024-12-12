// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/ownable.sol";

contract CodeStorage{
    // Code should bind concrete gas
    struct Code{
        string code;    
        uint64 gas;
        string itype; // algorithm's parameter type, 10 char/B
        string otype; // algorithm's return type
    }
    // Algorithm probable corrspond mutiple implementations 
    mapping(string => Code) private Codes;

    event CodeUploaded(string name,string code,uint64 gas,uint256 timestamp);
    // Index will make params store in topics as Hash, which will make parse impossible 
    event pullcode(string name);

    function uploadCode(string memory name,string memory code,uint64 gas, string memory itype,string memory otype) external  {
        require(bytes(code).length > 0, "Code cannot be empty"); 
        require(gas>0,"gas is less than 0");
        Codes[name]=Code(code,gas,itype,otype);
        emit CodeUploaded(name, code, gas, block.timestamp);
    }

    function updataGas(string memory name,uint64 _gas) external {
        require(bytes(Codes[name].code).length>0,"Code is empty");
        require(_gas>0,"gas is less than 0");
        Codes[name].gas=_gas;
    }
    // Everyone can pull code, emit @pullcode event to inform client update 
    function pullCode(string memory name) external {
        emit pullcode(name);
    }

    // This function implement is empty, only provide an gateway to call algorithm.
    function callFunc(string memory name, bytes memory input) external view returns(bytes memory){
        require(Codes[name].gas>0,"algorithm not exist");
    }

    // Return value must have name, geth use these to decode output.
    function getInfo(string memory name) external view returns(string memory code,uint64 gas, string memory itype,string memory otype){
        return (Codes[name].code,Codes[name].gas,Codes[name].itype,Codes[name].otype);
    }

    function getCode(string memory name) external view returns(string memory){
        return Codes[name].code;
    }

    function getGas(string memory name) external view returns(uint64){
        return Codes[name].gas;
    }
}
