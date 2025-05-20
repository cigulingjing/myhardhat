// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/ownable.sol";

contract CodeStorage{
    // Code should bind concrete gas
    struct algo{
        string code;    
        uint64 gas;
        string itype; // algorithm's parameter type, 10 char/B
        string otype; // algorithm's return type
    }
    // Algorithm probable corrspond mutiple implementations 
    mapping(string => algo) private Algos;
    string[] private codeNames;
    // Index will make params store in topics as Hash, which will make parse impossible 
    event codeUploaded(string name);

    function uploadCode(string memory name,string memory code,uint64 gas, string memory itype,string memory otype) external  {
        require(bytes(code).length > 0, "Code cannot be empty"); 
        require(gas>0,"gas is less than 0");
        require(Algos[name].gas==0,"algorithm already exist");

        Algos[name]=algo(code,gas,itype,otype);
        codeNames.push(name);
        emit codeUploaded(name);
    }

    function updataGas(string memory name,uint64 _gas) external {
        require(bytes(Algos[name].code).length>0,"Code is empty");
        require(_gas>0,"gas is less than 0");
        Algos[name].gas=_gas;
    }

    // This function implement is empty, only provide an gateway to call algorithm.
    function callFunc(string memory name, bytes memory input) external view returns(bytes memory){
        require(Algos[name].gas>0,"algorithm not exist");
    }

    // Return value must have name, geth use these to decode output.
    function getInfo(string memory name) external view returns(string memory code,uint64 gas, string memory itype,string memory otype){
        return (Algos[name].code,Algos[name].gas,Algos[name].itype,Algos[name].otype);
    }

    function getGas(string memory name) external view returns(uint64){
        return Algos[name].gas;
    }

    function getAllAlgo() external view returns(string[] memory){
        return codeNames;
    }
}
