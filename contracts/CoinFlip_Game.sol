pragma solidity >=0.7.4;

import "./market.sol";
import "./token.sol";
import "./CoinFlip_Room.sol";

contract CoinFlipGame {
    uint256 public numberOfGameRooms;
    uint256 public numberOfActiveGameRooms;
    mapping(address => CoinFlipRoom) public GameRooms;
    DaveTokenMarket public tokenMarket;
    DaveToken public DAVE_token;

    address public houseAddress;

    constructor(uint256 _initialTokenSupply) {
        address _tokenMarket_address = address(new DaveTokenMarket());
        tokenMarket = DaveTokenMarket(_tokenMarket_address);

        address _DAVE_token_address = address(
            new DaveToken(_initialTokenSupply)
        );
        DAVE_token = DaveToken(_DAVE_token_address);

        houseAddress = msg.sender;
    }

    event GameRoomCreated(
        address _by,
        uint256 _player1Commitment,
        uint256 _betAmount,
        address _gameRoomAddress
    );

    event GameWinnerPicked(
        address _gameRoomAddress,
        address winnerAddress,
        uint256 pricePool
    );

    function createGameRoom(uint256 _player1Commitment)
        public
        payable
        returns (bool success)
    {
        address _gameRoom_address = address(
            (new CoinFlipRoom){value: msg.value}(
                msg.sender,
                _player1Commitment,
                houseAddress
            )
        );

        require(CoinFlipRoom(_gameRoom_address).player1() == msg.sender);
        GameRooms[_gameRoom_address] = CoinFlipRoom(_gameRoom_address);
        numberOfGameRooms++;
        numberOfActiveGameRooms++;
        emit GameRoomCreated(
            msg.sender,
            _player1Commitment,
            msg.value,
            _gameRoom_address
        );

        return true;
    }

    function takeBetForGameRoom(address _gameRoom)
        public
        payable
        returns (bool success)
    {
        require(GameRooms[_gameRoom].gameActive());
        require(GameRooms[_gameRoom].betAmount() == msg.value);

        bool betSuccess = GameRooms[_gameRoom].takeBet{value: msg.value}(
            msg.sender
        );

        require(betSuccess);

        bool winnerPickSuccess = GameRooms[_gameRoom].pickWinner();

        require(winnerPickSuccess);

        DAVE_token.transfer(
            GameRooms[_gameRoom].player1(),
            GameRooms[_gameRoom].betAmount()
        );

        DAVE_token.transfer(
            GameRooms[_gameRoom].player2(),
            GameRooms[_gameRoom].betAmount()
        );

        emit GameWinnerPicked(
            _gameRoom,
            GameRooms[_gameRoom].winner(),
            GameRooms[_gameRoom].betAmount() * 2
        );

        return true;
    }
}
