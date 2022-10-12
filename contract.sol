// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TestNet is ERC1155, Ownable {
    string public name;
    string public symbol;

    uint256 public PRICE = 0.05 ether;

    address treasuryWallet;

    constructor(string memory _uri, address _treasuryWallet) ERC1155(_uri) {
        name = "PrincessDev";
        symbol = "PD";
        treasuryWallet = _treasuryWallet;
    }

    function mintPublic() external payable {
      unchecked {
          require(msg.value >= PRICE, "insufficient eth");
      }
        _mint(msg.sender, 0, 1, "");
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        PRICE = _newPrice;
    }

    function uri(uint256 _tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(super.uri(_tokenId), Strings.toString(_tokenId)));
    }

    function setUri(string memory _uri) external onlyOwner {
        _setURI(_uri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function setTreasuryWallet(address _treasuryWallet) external onlyOwner {
        treasuryWallet = _treasuryWallet;
    }

    function withdraw() external onlyOwner {
        (bool transfer, ) = payable(treasuryWallet).call{value: address(this).balance}("");
        require(transfer);
    }    
}