
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
import "./ERC20.sol";

contract GRIND is ERC20 {
    
    

      address payable public owner;
    address payable public intitalOfferingContract;
    address payable public BurnToStakeContract;
    address payable public GameFundStake;

    bool private setGameFundContractIsSet = false;
    bool private setBurnToStakeContractIsSet = false;
    bool private setICOIsSet = false;
 
    
    
    
    
     constructor(uint256 initsupply) public ERC20 ("grinda", "grnd") {
        _mint(msg.sender, initsupply );
        owner = msg.sender;
      
    }
    
    
    
    modifier onlyOwner{
        require(
            msg.sender == owner,
            "Only the minter contract can call this function."
        );
        _;
    }
    
    modifier canMint {
        require (msg.sender == intitalOfferingContract || msg.sender == BurnToStakeContract || msg.sender == GameFundStake, "not allowed to mint");
        _;
    }
    
    


   
    
 
   


function mint (address payable receiver, uint amount) canMint external {
    _mint(receiver, amount);
}


function setICO (address payable icocontract) onlyOwner public {
     require(!setICOIsSet, 'grind is already set, you trying to scam the people?');
        intitalOfferingContract = icocontract;
  //   setICOIsSet = true;
} 
function setGameFundContract (address payable gamefund) onlyOwner public {
         require(!setGameFundContractIsSet, 'grind is already set, you trying to scam the people?');
    GameFundStake = gamefund;
  //  setGameFundContractIsSet = true;
} 
function setBurnToStakeContract (address payable burn) onlyOwner public {
         require(!setBurnToStakeContractIsSet, 'grind is already set, you trying to scam the people?');
    BurnToStakeContract = burn;
 //   setBurnToStakeContractIsSet = true;
} 


}

