// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
 // Коли ми мінтимо нфт то звертаємось до chainlink vrf і отримуємо рандомне число. і за цим числом обираємо нфт яку робить будемо.  У кожної нфт своя рарність  Pug - super rare, Shiba - rare, Bernard - common.  за мінт треба платить

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract RandomIpfsNft is VRFConsumerBaseV2, ERC721  {

  VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
  uint64 private immutable i_subscribtionId;
  bytes32 private immutable i_gasLane; 
  uint32 private immutable i_callbackGasLimit;
  uint16 private constant REQUEST_CONFIRMATIONS = 3;
  uint32 private constant NUM_WORDS = 1;

  mapping (uint => address) public s_requestIdToSender;

  uint256 public s_tokenCounter;
  uint internal constant MAX_CHANCE_VALUE = 100;

  enum Breed {
    PUG,
    SHIBA,
    BERNARD
  }


  constructor(
      address vrfCoordinatorV2, 
      uint64 subscribtionId, 
      bytes32 gasLane,
      uint32  callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) 
      ERC721("RandomIpfsNft", "RIN")
    {
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
      s_requestIdToSender[requestId] = msg.sender;
  }

  function fulfillRandomWords(uint requestId, uint[] memory randomWords) internal override {
    address dogOwner = s_requestIdToSender[requestId];
    uint newTokenId = s_tokenCounter;

    uint moddedRng = randomWords[0] % MAX_CHANCE_VALUE;
    // 0-99; 7 - PUG, 88 - Bernard, ...

    Breed dogBreed = getBreedFromModdedRng(moddedRng);
    _safeMint(dogOwner, newTokenId);
  }

  function getBreedFromModdedRng(uint moddedRng) public pure returns(Breed) {
    uint comulativeSum = 0;
    uint[3] memory chanceArray = getChanceArray();
    for (uint i = 0; i < chanceArray.length; i++) {
      if(moddedRng >= comulativeSum && moddedRng < comulativeSum + chanceArray[i]) {
        return Breed(i);
      }
      comulativeSum +=  chanceArray[i];
    }
  }

  function getChanceArray() pure public returns(uint[3] memory) {
    return [10, 30, MAX_CHANCE_VALUE];
  }

  function tokenURI(uint) public view override returns(string memory) {

  }

}