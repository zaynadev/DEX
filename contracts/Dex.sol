// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract DEX {

    struct Token {
        bytes32 tiker;
        address tokenAddress;
    }
    mapping(bytes32 => Token) public tokens;
    bytes32[] public tokenList;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Action for admin only!");
        _;
    }

    function addToken(bytes32 _tiker, address _tokenAddress) external {
        tokens[_tiker] = Token(_tiker, _tokenAddress);
        tokenList.push(_tiker);
    }

}