// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;


import "./Grind.sol";
import "../../math/SafeMath.sol";

    

contract BurnToStake {
    
   using SafeMath for uint256;
    
 
    
    
    address grindcontract;
    GRIND g;
    address owner;
    uint public reward = 1;
    uint public stakeCounter;
    uint public totalBurned;
    uint public totalMinted;
    
    
    mapping (address => bool) public isStaker;
    mapping (address => uint) public amountBurnedByAddress;
    mapping (address => staker) public stakers;
    mapping (address => uint) public totalClaimedBy;
    
      modifier onlyOwner{
        require(
            msg.sender == owner,
            "only the owner can call this function"
        );
        _;
    }
  
    staker[] public allStakers;
    
    
    struct staker {
        uint stakeNumber;
        address stakersAddress;
        uint amountStaked;
        uint lastClaimedRewardBlocknumber;
        uint claimedRewards;
        
        
    }

  
    
      constructor(address _grindcontract) public {
        
        owner = msg.sender;
        grindcontract = _grindcontract;
        g = GRIND (_grindcontract);
     
  
    }
    
function Burn (uint amount) public {
    amount = amount*10**18;
    stakeCounter ++;
    uint claimedRewards = 0;
    g.changeAllowanceToBurn (msg.sender, amount);
    g.burnFrom(msg.sender, amount); //the burning itself
    totalBurned += amount;
    if (isStaker[msg.sender]){
        claimRewards();
        uint oldBurn = amountBurnedByAddress[msg.sender];
        stakeCounter ++;
        uint newBurn = oldBurn + amount;
        amountBurnedByAddress[msg.sender] = newBurn;
        amount = newBurn;
        
        
        
    }else {
        isStaker[msg.sender] = true;
        amountBurnedByAddress[msg.sender] = amount;
        
    }
    
    staker memory newstaker = staker(stakeCounter,msg.sender, amount, block.number, claimedRewards);
    allStakers.push(newstaker);
    stakers[msg.sender] = newstaker;
    
    
    
    
}
function claimRewards () public {
    require(isStaker[msg.sender], "no stake found on this account");
    staker memory oldstaker = stakers[msg.sender];
    uint blockrewards = block.number.sub(oldstaker.lastClaimedRewardBlocknumber);
    uint rewardUnits = blockrewards.mul(reward);
    uint stake = oldstaker.amountStaked.div(10**18);
    uint toClaim = stake.mul(rewardUnits);
    g.mint(msg.sender, toClaim);
    totalMinted += toClaim;
    oldstaker.claimedRewards += 1;
    oldstaker.lastClaimedRewardBlocknumber = block.number;
    stakers[msg.sender] = oldstaker;
    totalClaimedBy[msg.sender] += toClaim;
    

    //update data
}
function setReward (uint newReward) onlyOwner public {
    reward = newReward;
}
function showblocknumber () public view returns (uint _blockknumber) {
    return block.number;
}
    
}
