// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["GOLDEN", "FOLDING", "PERNICIOUS", "LETTUCE", "VANILLA", "CHOCOLATE"];
  string[] secondWords = ["BAWLING", "BOOZING", "COPIOUS", "SEABEARING", "WINE", "ICE"];
  string[] thirdWords = ["STRANGER", "BASIN", "GATOR", "TRACTOR", "PACT", "CREAM"];

    constructor() ERC721 ("SquareNFT","SQUARE") {
        console.log("Sorry there just NFTing through!");
    }

    function pickFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];

    }
    function pickSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newitemid = _tokenIds.current();

        string memory first = pickFirstWord(newitemid);
        string memory second = pickFirstWord(newitemid);
        string memory third = pickFirstWord(newitemid);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
        
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}')
                )
            )
        );
        _safeMint(msg.sender,newitemid);
       
        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,",json)
        );

        console.log(
            string(
                abi.encodePacked( 
                    "https://nftpreview.0xdev.codes/?code=",
                    tokenURI
                )
            )
        );

        _setTokenURI(newitemid, tokenURI);
        console.log("NFT %s was minted to %s",newitemid,msg.sender);
        console.log(tokenURI);
        _tokenIds.increment();
    }
}