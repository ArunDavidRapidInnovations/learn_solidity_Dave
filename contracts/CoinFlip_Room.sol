pragma solidity >=0.7.4;

contract CoinFlipRoom {
    address public player1;
    uint256 public player1Commitment;

    uint256 public betAmount;
    uint256 public pricePool;

    address public player2;
    uint256 public player2Commitment;

    bool public gameActive;
    bool public roomFull;

    address public winner;

    address public houseAccount;
    address public gameMaster;

    constructor(
        address _player1,
        uint256 _player1Commitment,
        address _houseAccount
    ) payable {
        require(_player1Commitment == 0 || _player1Commitment == 1);
        require(msg.value != 0);
        player1 = _player1;
        player1Commitment = _player1Commitment;
        betAmount = msg.value;
        pricePool = msg.value;
        gameActive = true;
        roomFull = false;
        houseAccount = _houseAccount;
        gameMaster = msg.sender;
    }

    function takeBet(address _player2) public payable returns (bool success) {
        require(betAmount != 0);
        require(!roomFull);
        player2 = _player2;
        if (player1Commitment == 0) {
            player2Commitment = 1;
        } else {
            player2Commitment = 0;
        }
        pricePool += msg.value;
        roomFull = true;

        pickWinner();

        return true;
    }

    function pickWinner() public payable returns (bool success) {
        require(roomFull);
        require(gameActive);
        require(msg.sender == gameMaster);

        uint256 winningChoice = FlipCoin();
        // House Percentage
        uint256 houseCut = pricePool / 100;
        payable(houseAccount).transfer(houseCut);
        if (winningChoice == player1Commitment) {
            payable(player1).transfer(pricePool - houseCut);
            winner = player1;
        } else {
            payable(player2).transfer(pricePool - houseCut);
            winner = player2;
        }
        pricePool = 0;
        gameActive = false;
        return true;
    }

    function FlipCoin() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % 2;
    }
}
