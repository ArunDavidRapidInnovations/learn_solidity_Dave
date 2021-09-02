pragma solidity >=0.7.4;

import "./IERC20.sol";

interface TokenMarketEntryInterface {
    // store
    function token1() external view returns (IERC20);

    function token2() external view returns (IERC20);

    function seller() external view returns (address);

    function amount1() external view returns (uint256);

    function amount2() external view returns (uint256);

    function broken() external view returns (bool);

    // methods

    function swap(address buyer) external returns (bool);

    function update(
        uint256 amount1,
        uint256 amount2,
        address funtionCaller
    ) external returns (bool);
}
