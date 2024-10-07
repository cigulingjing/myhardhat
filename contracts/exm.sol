// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// Trading zone tokens
contract EXM  {
    // Basic information 
    string public name = "Example Token";
    string public symbol = "EXM";
    uint8 public decimals = 18;
    // Total number of tokens issued
    uint256 private _totalSupply;
    event Transfer(address indexed from, address indexed to, uint256 value);
    // (user,balances)
    mapping(address => uint256) private _balances;

    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    function totalSupply() public view  returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view  returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public  returns (bool) {
        require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
}
