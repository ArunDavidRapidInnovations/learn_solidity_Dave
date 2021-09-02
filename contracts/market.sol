pragma solidity >=0.7.4;

import "./market_entry.sol";

contract DaveTokenMarket {
    uint256 public numberOfMarketEntries;
    // user address => market entry contract address
    mapping(address => TokenMarketEntry) MarketEntries;

    event MarketEntryCreated(
        address _by,
        address _haveToken,
        address _wantToken,
        uint256 _haveTokenAmount,
        uint256 _wantTokenAmount
    );

    event MarketEntryUpdated(
        address _by,
        address _haveToken,
        address _wantToken,
        uint256 _haveTokenAmount,
        uint256 _wantTokenAmount
    );

    event MarketEntryAccepted(address _by, address _MarketEntryAddress);

    function createMarketEntry(
        address _haveToken,
        address _wantToken,
        uint256 _haveTokenAmount,
        uint256 _wantTokenAmount
    ) public returns (bool success) {
        address newEntry = address(
            new TokenMarketEntry(
                _haveToken,
                _wantToken,
                msg.sender,
                _haveTokenAmount,
                _wantTokenAmount
            )
        );
        require(TokenMarketEntry(newEntry).seller() == msg.sender);
        MarketEntries[newEntry] = TokenMarketEntry(newEntry);
        numberOfMarketEntries++;

        emit MarketEntryCreated(
            msg.sender,
            _haveToken,
            _wantToken,
            _haveTokenAmount,
            _wantTokenAmount
        );

        return true;
    }

    function updateMarketEntry(
        address _entryAddress,
        uint256 _haveTokenAmount,
        uint256 _wantTokenAmount,
        address _haveToken,
        address _wantToken
    ) public returns (bool success) {
        bool updateSuccess = MarketEntries[_entryAddress].update(
            _haveTokenAmount,
            _wantTokenAmount,
            _haveToken,
            _wantToken,
            msg.sender
        );

        require(updateSuccess, "Error while updating Market Entry");

        emit MarketEntryUpdated(
            msg.sender,
            _haveToken,
            _wantToken,
            _haveTokenAmount,
            _wantTokenAmount
        );

        return true;
    }

    function acceptMarketEntry(address marketEntryAddress)
        public
        returns (bool success)
    {
        bool acceptSuccess = MarketEntries[marketEntryAddress].swap(msg.sender);

        require(acceptSuccess);

        emit MarketEntryAccepted(msg.sender, marketEntryAddress);
        return true;
    }
}
