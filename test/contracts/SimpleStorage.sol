pragma solidity ^0.4.23;

contract SimpleStorage {
    uint data;

    function set(uint _data) public {
        data = _data;
    }

    function get() public view returns (uint) {
        return data;
    }
}
