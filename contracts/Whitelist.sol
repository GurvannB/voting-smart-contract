// SPDX-License-Identifier: CC-by-nc-nd-4.0-or-later
pragma solidity 0.8.13;

contract Whitelist {

    modifier check() {
        require(whitelist[msg.sender] == true, "nop");
        _;
    }

    mapping(address => bool) public whitelist;

    event Authorized(address _address);

    function authorize (address _address) public check() {
        whitelist[_address] = true;
        emit Authorized(_address);
    }

}