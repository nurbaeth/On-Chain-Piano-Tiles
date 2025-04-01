// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PianoTiles {
    struct Player {
        uint256 score;
        uint256 lastMoveBlock;
    }

    mapping(address => Player) public players;
    uint256 public gameSpeed = 3; // Blocks required for next move
    uint256 public maxTiles = 4; // Number of tile options

    event TilePressed(address indexed player, uint256 tile, uint256 score);
    event GameOver(address indexed player, uint256 finalScore);

    function pressTile(uint256 tile) external {
        require(tile < maxTiles, "Invalid tile");
        Player storage player = players[msg.sender];
        
        if (player.lastMoveBlock != 0) {
            require(block.number >= player.lastMoveBlock + gameSpeed, "Too early");
        }
        
        if (isCorrectTile(tile)) {
            player.score++;
            player.lastMoveBlock = block.number;
            emit TilePressed(msg.sender, tile, player.score);
        } else {
            emit GameOver(msg.sender, player.score);
            delete players[msg.sender]; // Reset score on failure
        }
    }

    function isCorrectTile(uint256 tile) internal view returns (bool) {
        return uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender))) % maxTiles == tile;
    }
}
