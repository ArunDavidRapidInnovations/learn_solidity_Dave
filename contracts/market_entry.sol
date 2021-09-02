pragma solidity >=0.7.4;

import "./interfaces/IERC20.sol";

contract TokenMarketEntry {
    IERC20 public token1;
    address public seller;
    IERC20 public token2;
    uint256 public amount1;
    uint256 public amount2;
    bool public broken;

    constructor(
        address _token1,
        address _token2,
        address _seller,
        uint256 _amount1,
        uint256 _amount2
    ) {
        require(token1.allowance(seller, address(this)) >= _amount1);
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        amount1 = _amount1;
        amount2 = _amount2;
        seller = _seller;
        broken = false;
    }

    function swap(address buyer) public returns (bool success) {
        if (token1.allowance(seller, address(this)) >= amount1) {
            broken = true;
        }
        require(token1.allowance(seller, address(this)) >= amount1);
        require(token2.allowance(buyer, address(this)) >= amount2);

        _safeTransferFrom(token1, seller, buyer, amount1);
        _safeTransferFrom(token2, buyer, seller, amount2);

        broken = true;

        return true;
    }

    function update(
        uint256 _amount1,
        uint256 _amount2,
        address _token1,
        address _token2,
        address _funtionCaller
    ) public returns (bool success) {
        require(_funtionCaller == seller);
        require(token1.allowance(seller, address(this)) >= amount1);

        amount1 = _amount1;
        amount2 = _amount2;
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        broken = false;

        return true;
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token Transfer Failed");
    }
}
