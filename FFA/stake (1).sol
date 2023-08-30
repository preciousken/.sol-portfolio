// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface TokenI {
    
    function transfer(address to, uint256 amount) external returns(bool);
    function transferFrom(address from, address to, uint256 amount) external returns(bool);
    function balanceOf(address to) external returns(uint256);
    function approve(address spender, uint256 amount) external returns(bool);
}

//*******************************************************************//
//------------------ Contract to Manage Ownership -------------------//
//*******************************************************************//
    
contract owned {
    address public owner;
    address private newOwner;


    event OwnershipTransferred(uint256 curTime, address indexed _from, address indexed _to);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, 'Only owner can call this function');
        _;
    }


    function onlyOwnerTransferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    //this flow is to prevent transferring ownership to wrong wallet by mistake
    function acceptOwnership() public {
        require(msg.sender == newOwner, 'Only new owner can call this function');
        emit OwnershipTransferred(block.timestamp, owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}




contract Stake is owned { 

    struct _staking{         
        uint _days;
        uint _stakingStarttime;
        uint _stakingEndtime;
        uint _amount;
        uint _profit;
    }
  
    address public RewardPoolAddress;
    address public tokenAddress=address(0);
    mapping(address=>mapping(uint256=>_staking)) public staking; 
    mapping(address=>uint256) private activeStake;
    mapping(address=>uint256) private TotalProfit;   
    mapping(uint256 => uint256) private RewardPercentage; 
    uint256 private lastStake; 
    uint256 private MinAmt=100;
    uint256 private MaxAmt=10000;      
    
    constructor(address _tokenContract) {
        owner=msg.sender;
        tokenAddress= _tokenContract; 

        //Days wise Percentage
        RewardPercentage[30] = 700;
        RewardPercentage[90] = 7500;
        RewardPercentage[180] = 3500;
        RewardPercentage[360] = 160000;
    }  

     
    /**
     * @dev To show contract event  .
     */
    event unstake(address _to, uint _amount);

    /**
     * @dev returns number of stake, done by particular wallet .
     */
    function ActiveStake()public view returns(uint){
        return activeStake[msg.sender]; 
    } 

    /**
     * @dev This wallet is useful for maintain contract token balance.
     * owner can manage profit distribution using rewardPool address.
     */
    function changeRewardPoolAddress( address _rewardaddress) public onlyOwner {
        RewardPoolAddress = _rewardaddress;
    }   

    /**
     * @dev return new days wise staking percentage.
     * owner can change staking _percentage .
     */
    function RewardPercentageChange( uint256 _stakeDays , uint256 _percentage) public onlyOwner returns(uint256) {
        RewardPercentage[_stakeDays] = _percentage;
        return  RewardPercentage[_stakeDays];
    }

    /**
     * @dev return days wise staking percentage.
     * 
     */
    function viewPercentage(uint _stakeDays) public view returns(uint){
        return RewardPercentage[_stakeDays];
    }

    /**
     * @dev set number of token from the RewardPoolAddress
     *
     */
    function setRewardToken(uint _amount) public onlyOwner{        
        TokenI(tokenAddress).transferFrom(RewardPoolAddress,address(this), _amount);       
    }

     /**
     * @dev returns total staking wallet profited amount
     *
     */
    function TotalProfitedAmt() public view returns(uint){
        require(TotalProfit[msg.sender] > 0,"Wallet Address is not Exist");
        uint profit = TotalProfit[msg.sender];
        return profit;
    }

    /**
     * @dev stake amount for particular duration.
     * parameters : _staketime in days (exp: 30, 90, 180 ,360 )
     *              _stakeamount ( need to set token amount for stake)
     * it will increase activeStake result of particular wallet.
     */
    function stake(uint _staketime , uint _stakeamount) public returns (bool){
        require(msg.sender != address(0),"Wallet Address can not be address 0");  
        require(TokenI(tokenAddress).balanceOf(msg.sender) > _stakeamount, "Insufficient tokens");
        require(RewardPercentage[_staketime] > 0,"Please enter valid stack days"); 
        require(_stakeamount >= MinAmt, "Stake amount must be greater then the minimum stake amount!" );
        require( _stakeamount <= MaxAmt, "Stake amount must be under the maximum stake amount!" );       
        
        uint profit = _stakeamount * RewardPercentage[_staketime]/10000;
        
        TotalProfit[msg.sender]=TotalProfit[msg.sender]+profit;

        staking[msg.sender][activeStake[msg.sender]] =  _staking(_staketime,block.timestamp,block.timestamp + (_staketime*(24*60*60)),_stakeamount,profit);       
        
        TokenI(tokenAddress).transferFrom(msg.sender,address(this), _stakeamount);
        
        activeStake[msg.sender]=activeStake[msg.sender]+1;
        
        return true;       
    }

     /**
     * @dev stake amount release.
     * parameters : _stakeid is active stake ids which is getting from activeStake-1
     *              
     * it will decrease activeStake result of particular wallet.
     * result : If unstake happen before time duration it will set 50% penalty on profited amount else it will sent you all stake amount,
     *          to the staking wallet.
     */
    function unStake(uint256 _stakeid) public returns (bool){         
        
        uint totalAmt;
        uint profit;
        uint remainingProfit;
        address user=msg.sender;
        uint locktime=staking[user][_stakeid]._stakingStarttime+600; 

        require(staking[user][_stakeid]._amount > 0,"Wallet Address is not Exist");            

        if(block.timestamp > locktime){
            profit= staking[user][_stakeid]._profit;
            totalAmt= staking[user][_stakeid]._amount+ profit;
        }else{
            profit= staking[user][_stakeid]._profit;
            remainingProfit=profit/2; //penalty
            totalAmt= staking[user][_stakeid]._amount+ remainingProfit;
        }

        activeStake[user]=activeStake[msg.sender]-1;
        lastStake=activeStake[msg.sender];

        staking[user][_stakeid]._days = staking[user][lastStake]._days;
        staking[user][_stakeid]._amount = staking[user][lastStake]._amount;
        staking[user][_stakeid]._stakingStarttime = staking[user][lastStake]._stakingStarttime;
        staking[user][_stakeid]._stakingEndtime = staking[user][lastStake]._stakingEndtime;
        staking[user][_stakeid]._profit = staking[user][lastStake]._profit;
        
        staking[user][lastStake]._days = 0;
        staking[user][lastStake]._amount = 0;
        staking[user][lastStake]._stakingStarttime = 0;
        staking[user][lastStake]._stakingEndtime = 0;
        staking[user][lastStake]._profit = 0;


        TokenI(tokenAddress).transfer(user, totalAmt);
            
        
            
        emit unstake(user,totalAmt);
            
        return true; 
    }
 
}