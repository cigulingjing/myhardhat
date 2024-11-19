// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./utils/ownable.sol";

contract MutiVoucher is Ownable {
    struct Voucher {
        uint256 conversionRate;           // exchange rate with ETH
        mapping(address => uint256) balances; 
    }
    
    mapping(string => Voucher) private vouchers;

    event VoucherCreated(string voucherName, uint256 conversionRate);
    event VoucherPurchased(address buyer, string voucherName, uint256 amount);
    event VoucherUsed(address user, string voucherName, uint256 amount);
    
    // Initial 
    constructor(address initialOwner) Ownable(initialOwner) {}

    // Create new voucher and store in vouchers
    function createVoucher(string memory name, uint256 conversionRate) external onlyOwner {
        require(conversionRate > 0, "Conversion rate must be greater than zero");
        require(bytes(name).length > 0, "Voucher name cannot be empty");
        
        Voucher storage newVoucher = vouchers[name];
        newVoucher.conversionRate = conversionRate;
        emit VoucherCreated(name, conversionRate);
    }

    function getVoucherInfo(string memory name) external view returns (uint256 conversionRate) {
        require(vouchers[name].conversionRate > 0, "Voucher doesn't exist");
        return vouchers[name].conversionRate;
    }

    function buy(string memory name, uint256 amount) external payable {
        require(vouchers[name].conversionRate > 0, "Voucher doesn't exist");
        require(amount > 0, "Amount must be greater than zero");
        require(msg.value == amount * vouchers[name].conversionRate, "Incorrect amount sent");
        
        // Add balances
        vouchers[name].balances[msg.sender] += amount;
        emit VoucherPurchased(msg.sender, name, amount);
    }

    function use(string memory name, uint256 amount) external {
        require(vouchers[name].conversionRate > 0, "Voucher doesn't exist");
        require(amount > 0, "Amount must be greater than zero");
        require(vouchers[name].balances[msg.sender] >= amount, "Insufficient balance");
        
        // Reduce balance
        vouchers[name].balances[msg.sender] -= amount;
        emit VoucherUsed(msg.sender, name, amount);
    }

    // Query balance of an address in voucher 
    function balanceOf(string memory name, address user) external view returns (uint256) {
        require(vouchers[name].conversionRate > 0, "Voucher doesn't exist");
        return vouchers[name].balances[user];
    }
}