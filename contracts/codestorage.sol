// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/ownable.sol";

contract CodeStorage{
    // Code should bind concrete gas
    struct code{
        string code;
        uint256 gas;
    }

    // constructor() Ownable(msg.sender) {}

    // Algorithm probable corrspond mutiple implementations 
    mapping(string => code) private Codes;

    event CodeUploaded(string name,string code,uint256 gas,uint256 timestamp);
    // Index will make params store in topics as Hash, which will make parse impossible 
    event pullcode(string name);

    function uploadCode(string memory _name,string memory _code,uint256 gas) external  {
        require(bytes(_code).length > 0, "Code cannot be empty"); 
        require(gas>0,"gas is less than 0");
        Codes[_name]=code(_code,gas);
        emit CodeUploaded(_name, _code, gas, block.timestamp);
    }

    function updataGas(string memory _name,uint256 _gas) external {
        require(bytes(Codes[_name].code).length>0,"Code is empty");
        require(_gas>0,"gas is less than 0");
        Codes[_name].gas=_gas;

    }
    // Everyone can pull code, emit @pullcode event to inform client update 
    function pullCode(string memory name) external {
        emit pullcode(name);
    }
    
    function getCode(string memory _name) external view returns(string memory ){
        return Codes[_name].code;
    }

    function getGas(string memory _name) external view returns(uint256){
        return Codes[_name].gas;
    }
}
