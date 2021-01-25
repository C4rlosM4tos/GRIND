// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;


import "./Grind.sol";
import "../../math/SafeMath.sol";


contract ICO {
    
       using SafeMath for uint256;
       using SafeMath for int;
    uint ethstored =  address(this).balance;
    bool public active;
    uint public totalSold;
    uint public totalEthCollected;
    uint public lastamount;
    
    uint public currentBatchSupply;
   uint public currentBatchPrice;
    bool public check;
    uint public onumber;
    

    uint public SupplyLeftInBatch; //same as balance in poopcoin, double
    uint public currentBatch; //number
    uint public firstBatchTotalSupply; //double
    
    address payable public sendto; 
 
    address payable minterContractAddress;
    address payable owner;
    address public contractadr = address(this);
     address public grindContract;
    GRIND g;
    uint public firstPrice; //should not be changed once set, constant
    uint public basePrice; //used for the raiser
    uint public LastPriceInWei; // price of last order
    uint public firstsupply; //should not be changed
    uint public baseSupply;
    uint[] public ordernumbersarray; 
    
    
      modifier onlyOwner{
        require(
            msg.sender == owner,
            "only the owner can call this function"
        );
        _;
    }
  
    
    
    
    struct order {
        
        uint orderNumber;
        uint amountOfPoopcoin;
        uint priceInWeiPerPoopcoin;
        address ownerOfOrder;
        uint timestamp;
        uint partOfBatch;
        uint ethSend;
        bool filled;
        
        
    }
    
    mapping (uint => order) orders; //ordernumber to order struct 
    mapping (address => uint[] ) ordersByAddressArray;
    
    address[] public ordersByAddress;
    order[] public ordersArray;
    
    
    
    
    
    
    
  constructor(address _grindcontract) public {
        
        owner = msg.sender;
        grindContract = _grindcontract;
        g = GRIND (_grindcontract);
        active = false;
        currentBatch = 0;
  
    }
  function startAcution (uint startPriceFirstCoin, uint firstBatchSupply) onlyOwner  public   {
      firstBatchSupply = firstBatchSupply*10**18;
   require(!active, "already running");
   currentBatch = 1;
   currentBatchPrice = startPriceFirstCoin;
   currentBatchSupply = firstBatchSupply;
   firstPrice = startPriceFirstCoin;
   SupplyLeftInBatch = firstBatchSupply;
   firstBatchTotalSupply = firstBatchSupply;
   firstsupply = firstBatchSupply;
   basePrice = startPriceFirstCoin;
   baseSupply = 10**18; //to lower
   
     firstBatchTotalSupply  = firstBatchSupply ;
    address payable receiver = payable(address(contractadr));
    g.mint(receiver, firstBatchTotalSupply);
    sendto = receiver;
    
   active = true;
   
    
  
}  function createOrder (uint amount) public payable {
    onumber += 1;
    
    ordernumbersarray.push(onumber);
    
    order memory neworder = order(onumber, amount, firstPrice, msg.sender, block.number, currentBatch, msg.value, false ); 
    
    orders[onumber] = neworder;
    ordersArray.push(neworder);
   bool okay = checkIfEnoughMoney(onumber);
    require (okay, "money check failed");
    uint totalToPay = calculatePayment(amount, 0);
    
   lastamount = amount;
  if (amount > tokensleftInBatch()){
      createBatch();
      calculatePayment;
  }
  totalEthCollected += totalToPay;
     
    require(totalToPay <= msg.value, "not enough eth");
    if (msg.value > totalToPay) {
        uint toSendBack = msg.value.sub(totalToPay);
   msg.sender.transfer(toSendBack);
    }
   g.transfer(msg.sender, amount);
   
   
    orders[onumber].filled = true;
    orders[onumber] = neworder;
}

    function checkIfEnoughMoney (uint _onumber) public view returns (bool answer) {
        uint ethReceived = orders[_onumber].ethSend;
        uint moneyNeeded = orders[_onumber].priceInWeiPerPoopcoin.mul(orders[_onumber].amountOfPoopcoin);
        require (ethReceived >= moneyNeeded, 'need more money');
        if (ethReceived >= moneyNeeded) {
            return true;
        }
        

}


function tokensleftInBatch () public view returns (uint) {
    return g.balanceOf(contractadr);
}
function createBatch () private {
       currentBatch += 1;
       currentBatchPrice = currentBatch.mul(basePrice);
       uint subtractor = currentBatch.mul(baseSupply);
       
       if (subtractor > currentBatchSupply) {
           currentBatchSupply = 1000000; // 1 coin with 6 dec
       }else{
           if (currentBatchSupply > subtractor){
                 currentBatchSupply = currentBatchSupply.sub(subtractor);
              }
          
       }
     
       g.mint(contractadr, currentBatchSupply);
       SupplyLeftInBatch = currentBatchSupply;
      check = true;
       
       
}
function setBaseSupply (uint newValue) onlyOwner public  returns (bool) {
    baseSupply = newValue;
    
    return true;
    
}
function setBasePrice (uint newbase) onlyOwner public returns (bool) {
basePrice = newbase;
return true;
    
} 

function calculatePayment (uint _amountOfCoins, uint runningPrice) private returns (uint cost) {
    
    if (_amountOfCoins > SupplyLeftInBatch) {
        uint coinsLeftForNextBatch = _amountOfCoins - (SupplyLeftInBatch);
        uint coinsInCurrentBatch = _amountOfCoins - (coinsLeftForNextBatch);
        uint toPaySoFar = coinsInCurrentBatch.mul(currentBatchPrice);
        toPaySoFar = toPaySoFar.add(runningPrice);
        SupplyLeftInBatch = 0;
        createBatch();
        calculatePayment(coinsLeftForNextBatch, toPaySoFar);
        
    }else{
         if (_amountOfCoins <= SupplyLeftInBatch) {
       SupplyLeftInBatch = SupplyLeftInBatch - _amountOfCoins;
   }
    return runningPrice.add((currentBatchPrice.mul(_amountOfCoins)));
    }
}
function transferFunds (uint amount) onlyOwner public {
    owner.transfer(amount);
}

function showBalance () public view returns (uint _balance) {
return (payable(address(this))).balance;}
}
