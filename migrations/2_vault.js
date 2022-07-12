const Vault = artifacts.require("Vault");
const VaultToken = artifacts.require("VaultToken");

module.exports = async (deployer, network, accounts) => { 

    // deploy Vault Token with temporary address 0
    await deployer.deploy(VaultToken, '0x0000000000000000000000000000000000000000', [accounts[0], accounts[1], accounts[2], accounts[3]]);
    VaultTokenInstance = await VaultToken.deployed();
    VaultTokenInstanceAddress = VaultTokenInstance.address;
    // deploy Vault contract
    await deployer.deploy(Vault, VaultTokenInstanceAddress);
    VaultInstance = await Vault.deployed();
    VaultInstanceAddress = VaultInstance.address;

    await VaultTokenInstance.updateVaultAddress(VaultInstanceAddress);

    console.log('Vault: ' + VaultInstanceAddress);
    console.log('Vault Token: ' + VaultTokenInstanceAddress);
    for(var i=0; i < 4; i++) {
      console.log(`Account ${i} VLT Token balance: ${web3.utils.fromWei(await VaultTokenInstance.balanceOf(accounts[i]))}`);
    }

  };
