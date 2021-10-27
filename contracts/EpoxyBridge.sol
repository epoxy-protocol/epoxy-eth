//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";

contract EpoxyBridge {

    struct ERC721ToSIP009Conversion { 
        address erc721;
        bytes32 sip009;
        uint256 tokenId;
        bytes32 _metaSig;
        bytes32 _metaMetaSig;
    }

    using SafeMath for uint256;

    mapping(address => uint256) private _nonces;
    mapping(bytes20 => ERC721ToSIP009Conversion) private _initiatedERC721ToSIP009Conversions;

    /**
     * Event for conversion initiation logging
     * @param _conversionId Lorem ipsum
     * @param _erc721 Lorem ipsum
     * @param _sip009 Lorem ipsum
     * @param _tokenId Lorem ipsum
     * @param _metaSig Lorem ipsum
     * @param _metaMetaSig Lorem ipsum
     */
    event ERC721ToSIP009ConversionInitiated(bytes20 _conversionId, address _erc721, bytes32 _sip009, uint256 _tokenId, bytes32 _metaSig, bytes32 _metaMetaSig);

    /**
     * Event for conversion finalized logging
     * @param _conversionId Lorem ipsum
     */
    event ERC721ToSIP009ConversionFinalized(bytes20 _conversionId);

    constructor() {
    }

    /**
     * @dev Initiate a conversion. Pre-requesite: _sip009 contract must have been deployed.
     * @param _erc721 Lorem ipsum
     * @param _sip009 Lorem ipsum
     * @param _tokenId Lorem ipsum
     * @param _metaSig Lorem ipsum
     * @param _metaMetaSig Lorem ipsum
     */
    function initiateERC721ToSIP009Conversion(address _erc721, bytes32 _sip009, uint256 _tokenId, bytes32 _metaSig, bytes32 _metaMetaSig) public {
        uint256 _nonce = _nonces[msg.sender].add(1);

        // Create a deterministic conversion id, that can also be built offchain
        bytes20 conversionId = ripemd160(abi.encodePacked(_nonce, _erc721, _sip009));

        // Ensure that we're not overwriting an initiated conversion
        require(_initiatedERC721ToSIP009Conversions[conversionId].erc721 == address(0), "Existing _initiatedERC721ToSIP009Conversions");

        // Keep track of the conversion data
        _initiatedERC721ToSIP009Conversions[conversionId] = ERC721ToSIP009Conversion(_erc721, _sip009, _tokenId, _metaSig, _metaMetaSig);

        // Update the nonces
        _nonces[msg.sender] = _nonce;

        // Transfer the token to the bridge
        IERC721(_erc721).transferFrom(msg.sender, address(this), _tokenId);

        // Emit event
        emit ERC721ToSIP009ConversionInitiated(conversionId, _erc721, _sip009, _tokenId, _metaSig, _metaMetaSig);
    }

    /**
     * @dev Finalize a conversion.
     * @param _conversionId Lorem ipsum
     */
    function finalizeERC721ToSIP009Conversion(bytes20 _conversionId) public {
        // Retrieve conversion
        ERC721ToSIP009Conversion storage conversion = _initiatedERC721ToSIP009Conversions[_conversionId];
        
        // Ensure that we have an entry for the _conversionId
        require(conversion.erc721 != address(0), "Existing _initiatedERC721ToSIP009Conversions");

        // TODO(me): Check merckle proofs :/

        // Emit event
        emit ERC721ToSIP009ConversionFinalized(_conversionId);
    }

    function getNextNonce() external view returns (uint256) {
        return _nonces[msg.sender].add(1);
    }

    function lockERC20() public {
    }

    function lockERC721() public {
    }

    function lockETH() public {
    }

    function unlockERC20() public {
    }

    function unlockERC721() public {
    }

    function unlockETH() public {
    }

    function lockSIP010() public {
    }

    function lockSIP009() public {
    }

    function unlockSIP010() public {
    }

    function unlockSIP009() public {
    }
}
