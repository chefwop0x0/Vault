// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Vault is Ownable, ReentrancyGuard {
    IERC20 public immutable VaultToken;

    uint public totalSupply;
    mapping(address => uint) public balances; 
    uint public VaultActive;
    uint public VaultCurrent;
    uint public VaultNext;
    uint public duration;

    constructor(address _VaultTokenAddress) {
        VaultToken = IERC20(_VaultTokenAddress);
    }

    function rotateVault() external onlyOwner {
        VaultActive = VaultCurrent;
        VaulCurrent = VaultNext;
        VaultNext += duration;
    }

    function mintShares(address _to, uint _shares) private {
        totalSupply += _shares;
        balances[_to] += _shares;
    }

    function burnShares(address _from, uint _shares) private {
        totalSupply -= _shares;
        balances[_from] -= _shares;
    }

    function deposit(uint _amount) external {
        uint shares;
        require(VaultToken.balanceOf(msg.sender) >= _amount, "Amount is greater than your balance!");
        shares = (totalSupply == 0) ? _amount : (_amount * totalSupply) / VaultToken.balanceOf(address(this));
        mintShares(msg.sender, shares);
        VaultToken.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _shares) external nonReentrant {
        require(balances[msg.sender] >= _shares, "Amount of shares greater than your balance!");
        uint amount = (_shares * VaultToken.balanceOf(address(this))) / totalSupply;
        burnShares(msg.sender, _shares);
        VaultToken.transfer(msg.sender, amount);
    }
}

interface IERC20 {

    function mint(uint256 amount, address _receiver) external;

    function balance(address _address) external returns (uint);

    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

}
