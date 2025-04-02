# On-Chain Piano Tiles 🎵

**On-Chain Piano Tiles** is a blockchain-based rhythm game built on Solidity. Players must press the correct tiles in sequence to increase their score. The game logic is fully on-chain, ensuring transparency and fairness.

## 🚀 How It Works
- Players interact with the smart contract by calling the `pressTile(uint256 tile)` function.
- The game randomly determines the correct tile using a pseudo-random algorithm based on block hashes.
- If the player selects the correct tile, their score increases.
- If the player selects the wrong tile, their score resets, and the game ends.

## 🎮 Game Rules
1. Select a tile (0 to 3).
2. You must wait a few blocks before the next move (game speed controlled by `gameSpeed`).
3. The game checks if your tile matches the correct one.
4. Correct selection: Score increases! ❇️ 
5. Wrong selection: Game over! ❌

## 📜 Smart Contract
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PianoTiles {
    struct Player {
        uint256 score;
        uint256 lastMoveBlock;
    }

    mapping(address => Player) public players;
    uint256 public gameSpeed = 3;
    uint256 public maxTiles = 4;

    event TilePressed(address indexed player, uint256 tile, uint256 score);
    event GameOver(address indexed player, uint256 finalScore);

    function pressTile(uint256 tile) external {
        require(tile < maxTiles, "Invalid tile");
        Player storage player = players[msg.sender];
        require(block.number >= player.lastMoveBlock + gameSpeed, "Too early");
        
        if (isCorrectTile(tile)) {
            player.score++;
            player.lastMoveBlock = block.number;
            emit TilePressed(msg.sender, tile, player.score);
        } else {
            emit GameOver(msg.sender, player.score);
            delete players[msg.sender];
        }
    }

    function isCorrectTile(uint256 tile) internal view returns (bool) {
        return uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender))) % maxTiles == tile;
    }
}
```

## 🔧 Deployment
Deploy the contract on any EVM-compatible blockchain like Ethereum, Polygon, or Arbitrum.

## 📜 License
This project is licensed under the MIT License.

