<img align="right" width="150" height="150" top="100" src="./assets/blueprint.png">

# SkidsDAO ctf

On 22-July-2022, [@jtriley](https://gist.github.com/JoshuaTrujillo15) [tweeted](https://twitter.com/jtriley_eth/status/1550459124047138819):
```
Vault Deployment:
https://optimistic.etherscan.io/address/0xc9c1f60862cab3aa8081f9a9a3b929ab5ad3d594

Source Code:
https://gist.github.com/JoshuaTrujillo15/f6e76cdb6856eb4f12d5d6778a435d1e

The clock is ticking.

Good hacking.
```

The code for that CTF has been imported here for local testing with Foundry. 
(There is a hint and a solution available, see below)

## Getting Started

Git clone this repo and cd into the folder

```shell
git clone git@github.com:devtooligan/skidsdao-ctf-22-jul-22.git

cd skidsdao-ctf-22-jul-22.git
```

Forge install (if you don't have Forge installed see [installation guide](https://book.getfoundry.sh/getting-started/installation))
```shell
forge install
```

To run tests:

```shell
forge test
```

For more information on how to use Foundry, check out the [Foundry Github Repository](https://github.com/foundry-rs/foundry/tree/master/forge) and the [foundry-huff library repository](https://github.com/huff-language/foundry-huff).

## Instructions
Enter your hacking logic into the `testHack()` function in the `test` folder

If you would like a hint, checkout the branch `feat/hint`

```shell
git checkout feat/hint
```

If you would like the solution:
```shell
git checkout feat/solution
```
Solution writeup in the comments!
