// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/ERC20.sol";
import "./utils/ownable.sol";

contract Voucher is ERC20, Ownable {
    // Token to wei conversion rate
    uint256 constant EXCHANGE_SCALE = 5000;

    // ref: http://www.gupowang.com/article/view/10755
    struct VoucherInfos {
        address originToken;
        // Minimum number of original tokens required to redeem a voucher
        uint256 minAmount;
        uint256 exchangeRate;
        // Validity period of purchased vouchers. Before this point in time, users can redeem vouchers
        uint256 buyExpiration;
        // Validity period of voucher,
        uint256 useExpiration;
    }

    // address public dApp;
    mapping(address => bool) public dApps;
    VoucherInfos public infos;

    constructor(string memory name, string memory symbol, address _dApp, VoucherInfos memory _infos) 
        ERC20(name, symbol) 
        Ownable(msg.sender)
    {
        // dApp = _dApp;
        dApps[_dApp] = true;
        infos = _infos;
    }

    // Modifier to restrict access to DApp only
    modifier onlyDApp() {
        // require(msg.sender == dApp, "Only the dApp can call this function");
        require(dApps[msg.sender], "Only the dApp can call this function");
        _;
    }


    // -------------------------- Query Functions ------------------------------------

    // used for other dapp to spend voucher
    function original() public view returns (address) {
        return infos.originToken;
    }

    // -------------------------- Write Functions ------------------------------------

    function addDApp(address _dApp) public onlyOwner {
        dApps[_dApp] = true;
    }

    function removeDApp(address _dApp) public onlyOwner {
        delete dApps[_dApp];
    }

    // Function to mint tokens by paying ETH
    function buy(uint256 amount) external payable {
        require(infos.buyExpiration > block.timestamp, "The voucher is expired");

        if (infos.originToken == address(0)) {
            amount = msg.value; 
        }

        require(amount > infos.minAmount, "Amount to buy voucher must be greater than the minimum allowed");
        uint256 value = amount * infos.exchangeRate / EXCHANGE_SCALE; 
        _mint(msg.sender, value);
        // _approve(msg.sender, dApp, value);
    }

    function donate(uint256 amount, address receiver) 
        public 
        payable 
        returns (uint256)
    {
        require(infos.buyExpiration > block.timestamp, "The voucher is expired");

        if (infos.originToken == address(0)) {
            amount = msg.value; 
        }

        require(amount > infos.minAmount, "Amount to buy voucher must be greater than the minimum allowed");
        uint256 value = amount * infos.exchangeRate / EXCHANGE_SCALE; 
        _mint(receiver, value);
        return value;
    }

    function donateWithApprove(uint256 amount, address receiver) 
        external 
        payable 
        onlyDApp
    {
        uint256 value = donate(amount, receiver);
        _approve(receiver, msg.sender, value);
    }

    // Override transfer to enforce transfer rules
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        // Restrict transfers to empty address only 
        require(recipient == address(0), "Transfer not allowed");
        super._transfer(msg.sender, recipient, amount);
        return true;
    }

    // Override transferFrom to enforce transfer rules
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        // require(recipient == dApp, "TransferFrom not allowed");
        require(dApps[recipient], "TransferFrom not allowed");
        require(infos.useExpiration > block.timestamp, "The voucher is expired");

        return super.transferFrom(sender, recipient, amount);
    }

    // Override approve to enforce approval rules
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        // require(spender == dApp, "Approval only allowed to the dApp");
        require(dApps[spender], "Approval only allowed to the dApp");
        return super.approve(spender, amount);
    }

    // Function for DApp to burn tokens and withdraw ETH
    function withdraw(uint256 amount) external onlyDApp {
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
    }
}