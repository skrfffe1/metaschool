// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public implementation;
    address public admin;

    event Upgraded(address indexed newImplementation);

    modifier onlyAdmin(){
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _implementation){
        implementation = _implementation;
        admin = msg.sender;
    }

    function upgrade(address _newImplemetation) external onlyAdmin{
        require(_newImplemetation != address(0), "Invalid implementation address");
        implementation = _newImplemetation;
        emit Upgraded(_newImplemetation);
    }

    fallback() external {
        // delegatecall to the implemetation contract
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success, "Delegate call failed");
    }

    receive() external payable {}
}