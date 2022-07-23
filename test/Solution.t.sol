// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";

interface Vault {
    function owner() external returns (uint);
    function setOwner(address) external returns (bool);
    function deposit() payable external;
    function withdraw() external;

    event Deposit(address,uint256);
    event Withdrawal(uint256);
    event OwnerSet(address);

}

contract SolutionTest is Test {
    /// @dev Address of the SimpleStore contract.
    Vault public vault;

    address constant hacker = payable(address(0xbadbabe));
    uint public hackerStartingBal = 1 ether;

    /// @dev Setup the testing environment.
    function setUp() public {
        vm.deal(address(this), 1000 ether);
        // vault = Vault(HuffDeployer.deploy("Vault"));
        // vm.deal(address(vault), 1 ether);
        HuffDeployer.config()
            .with_value(1 ether)
            .deploy{value: 1 ether}("src/Vault");
        hackerStartingBal = hackerStartingBal;
        vm.deal(hacker, hackerStartingBal);

    }

    /// @dev Ensure that you can set and get the value.
    function testHack() public {

        console.log('before hack balance:', address(hacker).balance);
        // assertEq(address(hacker).balance, hackerStartingBal);
        console.log(vault.owner());
        vault.deposit();
        // vm.prank(hacker);
        // vault.deposit{value: 0.1 ether}();
        // bytes memory payload = abi.encodePacked(uint(0x6969696900000000000000000000000000000000000000000000000000000000), uint(0x0000004600000000000000000000000000000000000000000000000000000000));
        // // console.log(uint(bytes32(payload)));
        // (bool success, bytes memory returnData) = address(vault).call{value: 1 ether}(payload);
        // require(success);
        console.log('after hack balance:', address(hacker).balance);
        console.log("hello");
    }
}

