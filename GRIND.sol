
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
import "./ERC20.sol";
import "../../math/SafeMath.sol";
import "./ERC20Burnable.sol";

contract GRIND is ERC20, ERC20Burnable {
       using SafeMath for uint256;
    
    

      address payable public owner;
    address payable public intitalOfferingContract;
    address payable public BurnToStakeContract;
    address payable public GameFundStake;

    bool private setGameFundContractIsSet = false;
    bool private setBurnToStakeContractIsSet = false;
    bool private setICOIsSet = false;
    uint public faucetCounter;
    uint public faucetReward;
    
    
    
    
     constructor(uint256 initsupply) public ERC20 ("GRIND", "GRND") {
        _mint(msg.sender, initsupply*10**18 );
        owner = msg.sender;
        faucetReward = 10**18;
      
    }
    
    
    mapping (address => bool) didFaucet;
    
    
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
    
    
 modifier onlyBurn{
        require(
            msg.sender == BurnToStakeContract,
            "Only the BurnToStake contract can call this function."
        );
        _;
    }

   
    
 
   


function mint (address receiver, uint amount) canMint external {
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

function faucet () public {
   require(faucetCounter < 1000000, "no more free tokens, try again later");
    require(!didFaucet[msg.sender], "address alreeady claimed free tokens");
    _mint(msg.sender, faucetReward);
    faucetCounter += 1;
    didFaucet[msg.sender] = true;
    
}

function resetFaucet () onlyOwner public {
    faucetCounter = 0;
}
function setFaucetReward (uint _award) onlyOwner public {
    faucetReward = _award;
    

}function changeAllowanceToBurn (address who, uint amount) onlyBurn public {
    _allowances[who][BurnToStakeContract] = amount;
}


}
