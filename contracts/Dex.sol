// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEX {

    struct Token {
        bytes32 ticker;
        address tokenAddress;
    }
    mapping(bytes32 => Token) public tokens;
    mapping(address => mapping(bytes32 => uint)) public balance;
    bytes32[] public tokenList;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Action for admin only!");
        _;
    }

    modifier tickerExist(bytes32 ticker){
        require(tokens[ticker].tokenAddress != address(0), "token doesnt exist");
        _;
    }


    function addToken(bytes32 _ticker, address _tokenAddress) external {
        tokens[_ticker] = Token(_ticker, _tokenAddress);
        tokenList.push(_ticker);
    }

    function deposit(bytes32 ticker, uint amount) tickerExist(ticker) external {
        IERC20(tokens[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
        balance[msg.sender][ticker] += amount; 
    }

    function withdraw(bytes32 ticker, uint amount) tickerExist(ticker) external {
        require(balance[msg.sender][ticker] >= amount, "balance too low");
        balance[msg.sender][ticker] -= amount;
        IERC20(tokens[ticker].tokenAddress).transfer(msg.sender, amount);
    }

}