
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
import "./ERC20.sol";

contract GRIND is ERC20 {
    
    
    address public creator;
    address public minterContract;
   
    
    
    modifier onlyMinterContract{
        require(
            msg.sender == minterContract,
            "Only the minter contract can call this function."
        );
        _;
    }
    
    constructor(uint256 initsupply, address minter) public ERC20 ("grinda", "grind") {
        _mint(msg.sender, initsupply);
        creator = msg.sender;
        minterContract = minter;
    }


function mint (address payable receiver, uint amount) onlyMinterContract external {
    _mint(receiver, amount);
}


}

