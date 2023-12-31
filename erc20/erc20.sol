// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./owner.sol";

contract DWC is Owner {
    // 代币名称
    string private _name;
    // 代币标识
    string private _symbol;
    // 代币小数点位数
    uint8 private _decimals;
    // 代币总发行量
    uint private _totalSupply;
    // 代币数量
    mapping(address => uint) private _balances;
    // 授权代币数量
    mapping(address => mapping(address => uint)) private _allowances;

    constructor(){
        _name = "DogWang Coin";
        _symbol = "DWC";
        _decimals = 18;

        _mint(_getSender(), 10 * 1000 * 10**_decimals);
    }
    // 转账事件
    event Transfer(address from, address to, uint amount);
    // 授权事件
    event Approve(address from ,address to, uint amount);
    // 返回代币名字
    function name() public view returns(string memory){
        return _name;
    }
    // 返回代币标识
    function symbol() public view returns(string memory){
        return _symbol;
    }
    // 返回代币小数点
    function decimals() public view returns(uint8){
        return _decimals;
    }
    // 返回代币总发行量
    function totalSupply() public view returns(uint){
        return _totalSupply;
    }
    // 返回某账号的代币数量
    function balanceOf(address account) public view returns(uint){
        return _balances[account];
    }
    // 返回授权的代币信息
    function allowancesOf(address owner,address spender) public view returns(uint){
        return _allowances[owner][spender];
    }
    // 代币转发
    function transfer(address to, uint amount) public returns(bool){
        address owner = _getSender();
        _transfer(owner, to, amount);
        return true;
    }
    // 代币授权
    function approve(address spender, uint amount) public returns(bool){
        address owner = _getSender();
        _approve(owner, spender, amount);
        return true;
    }
    // 授权转发
    function transferFrom(address from, address to, uint amount) public returns(bool){
        address owner = _getSender();

        _spendAllowance(from, owner, amount);

        _transfer(from, to, amount);

        return true;
    }
    function _mint(address account, uint amount) internal {
        require(account != address(0), "ERC20: account is zero");
        _totalSupply += amount;
        _balances[account] += amount;
    }
    function _transfer(address from, address to, uint amount) internal {
        require(from != address(0),"ERC20: from is zero");
        require(to != address(0),"ERC20: to is zero");

        uint fromBalance = balanceOf(from);

        require(fromBalance > 0, "ERC20: balance is not");

        _balances[from] -= amount;

        _balances[to] += amount;

        emit Transfer(from, to, amount);

    }

    function _approve(address from, address to, uint amount) internal{
        require(from != address(0), "ERC20: from is zero");
        require(to != address(0),"ERC20: to is zero");
        
        _allowances[from][to] = amount;

        emit Approve(from, to, amount);
    }

    function _spendAllowance(address from, address to, uint amount) internal{
        require(from != address(0), "ERC20: from is zero");
        require(to != address(0),"ERC20: to is zero");

        uint reset = allowancesOf(from,to);

        require(reset >= amount, "ERC20: allowance is not");

        _approve(from,to,reset - amount);
    }
}