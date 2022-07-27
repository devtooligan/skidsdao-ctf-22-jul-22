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
    }

}

