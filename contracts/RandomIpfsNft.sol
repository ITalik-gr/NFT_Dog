// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
 // Коли ми мінтимо нфт то звертаємось до chainlink vrf і отримуємо рандомне число. і за цим числом обираємо нфт яку робить будемо.  У кожної нфт своя рарність  Pug - super rare, Shiba - rare, Bernard - common.  за мінт треба платить

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";


contract RandomIpfsNft is VRFConsumerBaseV2 {

  VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
  uint64 private immutable i_subscribtionId;
  bytes32 private immutable i_gasLane; 
  uint32 private immutable i_callbackGasLimit;
  uint16 private constant REQUEST_CONFIRMATIONS = 3;
  uint32 private constant NUM_WORDS = 1;


  constructor(
      address vrfCoordinatorV2, 
      uint64 subscribtionId, 
      bytes32 gasLane,
      uint32  callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
      i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
      i_subscribtionId = subscribtionId;
      i_gasLane = gasLane;
      i_callbackGasLimit = callbackGasLimit;
  }

  
  function requestNft() public returns(uint requestId) {
    requestId = i_vrfCoordinator.requestRandomWords(
          i_gasLane,
          i_subscribtionId,
          REQUEST_CONFIRMATIONS,
          i_callbackGasLimit,
          NUM_WORDS
      );
  }

  function fulfillRandomWords(uint requestId, uint[] memory randomWords) internal override {

  }

  function tokenUri(uint) public {

  }

}