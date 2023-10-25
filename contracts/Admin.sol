// SPDX-License-Identifier: CC-by-nc-nd-4.0-or-later
pragma solidity 0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Admin is Ownable {
    mapping(address => bool) whitelist;
    mapping(address => bool) blacklist;

    event Whitelisted(address account);
    event Blacklisted(address account);

    modifier onlyAdmin() {
        require(msg.sender == owner(), "Only admin can call this function");
        _;
    }

    function add_to_whitelist(address account) public onlyAdmin {
        whitelist[account] = true;
        emit Whitelisted(account);
    }

    function add_to_blacklist(address account) public onlyAdmin {
        whitelist[account] = false;
        blacklist[account] = true;
        emit Blacklisted(account);
    }

    function isWhitelisted(address account) public view returns (bool) {
        return whitelist[account];
    }

    function isBlacklisted(address account) public view returns (bool) {
        return blacklist[account];
    }
}
