// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract AwesomeNFTCollection is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address chairman;
    bool private isRevealed = false;
    string private baseURI = "https://ipfs.io/ipfs/QmWDkyzRH1BhegbWF7vQnQ1YTuDYu1EyUM6BkJpGsvESTj/";


    constructor() ERC721("AwesomeNFTCollection", "ANC") {
        chairman = msg.sender;
    }

    function mint(address owner) public onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(owner, newItemId);

        return newItemId;
    }

    function reveal(string memory revealBaseURI) public onlyOwner {
        if (isRevealed == false) {
            baseURI = revealBaseURI;
            isRevealed = true;
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (isRevealed == false) {
            return string("https://ipfs.io/ipfs/QmWDkyzRH1BhegbWF7vQnQ1YTuDYu1EyUM6BkJpGsvESTj/placeholder.json");
        } else {
            return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
        }
    }

    modifier onlyOwner {
        require(msg.sender == chairman, "Only owner can call this function.");
        _;
    }
}
