/**
  ______      __           __        __            
 /_  __/___ _/ /__  ____  / /_____  / /_____  ____ 
  / / / __ `/ / _ \/ __ \/ __/ __ \/ //_/ _ \/ __ \
 / / / /_/ / /  __/ / / / /_/ /_/ / ,< /  __/ / / /
/_/  \__,_/_/\___/_/ /_/\__/\____/_/|_|\___/_/ /_/ 
*/

pragma solidity ^0.4.18;
import './Owned.sol';

contract TalentUserInfo is Owned {
    
    mapping (address => Leader) public leaderMap;
    mapping (address => Beliver) public beliverMap;

    struct Leader {
        uint beliverNum;
        mapping (uint => address) belivers;
        mapping (address => uint8) beliverInfo;     //1:pending 2:ok 3:reject
        uint8 state;    //1:open 2:close 3:check
        uint8 grade;
    }

    struct Beliver {
        uint leaderNum;
        mapping (uint => address) leaders;
        mapping (address => uint8) leaderState; //1:pending 2:ok 3:reject
    }

    function newLeader(address _address) public onlyOwner {
        leaderMap[_address].grade = 0;
    }

    function apply(address _leader) public {
        address beliver = msg.sender;

        require(beliverMap[beliver].leaderState[_leader] != 1);
        require(beliverMap[beliver].leaderState[_leader] != 2);

        uint leaderNum = beliverMap[beliver].leaderNum;
        beliverMap[beliver].leaders[leaderNum] = _leader;
        leaderNum++;
        beliverMap[beliver].leaderState[_leader] = 1;

        uint beliverNum = leaderMap[_leader].beliverNum;
        leaderMap[_leader].belivers[beliverNum] = beliver;
        beliverNum++;
        leaderMap[_leader].beliverInfo[beliver] = 1;

        if (leaderMap[_leader].state == 1)   //open
        {
            beliverMap[beliver].leaderState[_leader] = 2;
            leaderMap[_leader].beliverInfo[beliver] = 2;
        }

        if (leaderMap[_leader].state == 2)   //close
        {
            beliverMap[beliver].leaderState[_leader] = 3;
            leaderMap[_leader].beliverInfo[beliver] = 3;
        }
    }
}
