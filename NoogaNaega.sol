// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import '@openzeppelin/contracts/finance/PaymentSplitter.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NoogaNaega is 
    ERC721,
    Ownable, 
    ReentrancyGuard, 
    PaymentSplitter 
{
    using Strings for uint256;
    using Counters for Counters.Counter;
    
    address proxyRegistryAddress;

    uint256 public maxSupply = 9001;
    uint8 constant maxTokensPerTx = 10;

    string public baseURI;
    string public baseExtension = ".json";

    bool public paused = false;

    uint256 _price = 10000000000000000; // 0.01 ETH for testing

    Counters.Counter private _tokenIds;

    uint256[] private _walletAllocations = [50, 50];
    address[] private _wallet = [
        0xNotReal59cc9e0d6688524aAC078B01DC2327555, 
        0xNotReal15F10466B9F0C85d44FeD5C10B01CF555
    ];

    constructor(string memory uri)
        ERC721("Jempsey", "J_J")
        PaymentSplitter(_wallet, _walletAllocations)
        ReentrancyGuard()
    {
        setBaseURI(uri);
    }

    function setBaseURI(string memory _tokenBaseURI) public onlyOwner {
        baseURI = _tokenBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    modifier onlyAccounts () {
        require(msg.sender == tx.origin, "Not allowed origin");
        _;
    }

    function togglePause() public onlyOwner {
        paused = !paused;
    }

    function publicMint(uint256 amount) 
    external 
    payable
    onlyAccounts
    {
        require(!paused, "NoogaNaega: Contract is paused");
        require(amount > 0, "NoogaNaega: Mint cannot be 0 amount");

        uint current = _tokenIds.current();

        require(amount <= maxTokensPerTx, "NoogaNaega: Maximum mint amount is set to 10 at a time.");

        require(
            current + amount <= maxSupply,
            "NoogaNaega: Max supply exceeded"
        );
        require(
            _price * amount <= msg.value,
            "NoogaNaega: Not enough ethers sent"
        );

        for (uint i = 0; i < amount; i++) {
            mintInternal();
        }
    }

    function mintInternal() internal nonReentrant {
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
    
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function totalSupply() public view returns (uint) {
        return _tokenIds.current();
    }
}

