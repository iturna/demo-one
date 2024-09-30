//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
  function totalSupply() external view returns (uint);
  function balanceOf(address account) external view returns (uint);
  function transfer(address recipient, uint amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint);
  function approve(address spender, uint amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts);
  function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
}

contract InstaArb is Ownable {
  constructor() Ownable(msg.sender) {}

  function swap(address router, address _tokenIn, address _tokenOut, uint256 _amount) private {
    IERC20(_tokenIn).approve(router, _amount);
    address[] memory path;
    path = new address[](2);
    path[0] = _tokenIn;
    path[1] = _tokenOut;
    uint deadline = block.timestamp + 300;
    IUniswapV2Router(router).swapExactTokensForTokens(_amount, 1, path, address(this), deadline);
  }

  //  function getAmountOutMin(address router, address _tokenIn, address _tokenOut, uint256 _amount) public view returns (uint256 ) {
  //   address[] memory path;
  //   path = new address[](2);
  //   path[0] = _tokenIn;
  //   path[1] = _tokenOut;
  //   uint256 result = 0;
  //   try IUniswapV2Router(router).getAmountsOut(_amount, path) returns (uint256[] memory amountOutMins) {
  //     result = amountOutMins[path.length -1];
  //   } catch {
  //   }
  //   return result;
  // }

  // function getBalance (address _tokenContractAddress) external view  returns (uint256) {
  //   uint balance = IERC20(_tokenContractAddress).balanceOf(address(this));
  //   return balance;
  // }

  // function getBalanceOwner_ (address _tokenContractAddress) external view  returns (uint256) {
  //   uint balance = IERC20(_tokenContractAddress).balanceOf(msg.sender);
  //   return balance;
  // }
  
  // function recoverEth() external onlyOwner {
  //   payable(msg.sender).transfer(address(this).balance);
  // }

  // function recoverTokens(address tokenAddress) external onlyOwner {
  //   IERC20 token = IERC20(tokenAddress);
  //   uint balance = token.balanceOf(address(this)); // store in memory
  //   token.transfer(msg.sender, balance);
  // }

  // function depositETH() public payable {
  //   // Bu fonksiyon, kontrata ETH gönderimini kabul eder
  // }

  // function getBalance() external view returns(uint256) {
  //   return address(this).balance;
  // }

}