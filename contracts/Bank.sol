// SPDX-License-Identifier: CC-by-nc-nd-4.0-or-later
pragma solidity 0.8.13;

contract Bank {
    mapping(address => uint256) _balances;

    function deposit(uint256 _amount) public {
        _balances[msg.sender] = (_balances[msg.sender] + _amount);
    }

    function transfer(address _address) public view returns (uint256) {
        return _balances[_address];
    }

    function transfer(uint256 _amount, address _recipient) public {
        _balances[msg.sender] -= _amount;
        _balances[_recipient] += _amount;
    }
}