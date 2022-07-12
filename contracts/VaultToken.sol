// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract VaultToken is ERC20, Ownable, ReentrancyGuard {

    address public VaultAddress;  
    uint public VaultActive;
    uint public VaultCurrent;
    uint public VaultNext;
    uint public duration;

    constructor(address _VaultAddress, address[] memory _accounts) ERC20("Vault Token", "VLT") {
        VaultAddress = _VaultAddress;
        for(uint i=0; i < 4; i++) {
            _mint(_accounts[i], 100 * 10 ** 18);
        }
        duration = 50;
        VaultActive = 0;
        VaultCurrent = block.number;
        VaultNext = block.number + duration;
    }

    function rotateVault() external onlyOwner {
        VaultActive = VaultCurrent;
        VaulCurrent = VaultNext;
        VaultNext += duration;
    }

    function mint(uint256 amount, address _receiver) external nonReentrant {
        require(msg.sender==VaultAddress, "Only Vault contract can mint!"); 
        //require(tx.origin==owner(), "Only SWBController can mint!"); 
        _mint(_receiver, amount);
    } 

    function updateVaultAddress(address _VaultAddress) external onlyOwner{
        VaultAddress = _VaultAddress;
    }

    function getVaultAddress() external view returns(address) {
        return VaultAddress;
    }

}
