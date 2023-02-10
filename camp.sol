pragma solidity 0.5.17;

contract factorycampign{
    address payable founder;
    address[] public allcampign;
    address[] public alldonation;
    constructor() public{
        founder=msg.sender;
    }
    function createCampign(string memory title,string memory description,string memory image,uint mincontribution) public{
        Campign camp=new Campign(address(msg.sender),title,description,image,mincontribution,founder);
        allcampign.push(address(camp));

    }
     function createDonation(string memory title,string memory description,string memory image) public{
        Donation camp=new Donation(address(msg.sender),title,description,image);
        alldonation.push(address(camp));
     }


}

contract Campign{
 address payable public founder;
 address payable public owner;
 string public title;
 string public description;
 string public image;
 uint public mincontribution;
 uint public premiumprice;
uint contributerscount=0;
uint heroCount=0;
mapping(address=>bool) public heros;
mapping(address=>bool) public contributers;
 struct Request{
     string reqdescription;
    mapping(address=>bool) approvals;
    uint16 approvalscount;
 }
 Request[] requests;
uint public noConfidenceCount;

constructor(address payable  Owner,string memory Title,string memory Description,string memory Image,uint Min,address payable Founder)public{
owner=Owner;title=Title;description=Description;image=Image;mincontribution=Min;founder=Founder;
}

modifier OnlyOwner{
    require(msg.sender==owner,"You Are Not Ownner");
    _;
}



 
function backproject() public payable{
    require(msg.value>=mincontribution );
    require(!contributers[msg.sender]);
    contributers[msg.sender]=true;
    contributerscount++;



}
function createRequest(string memory reason)public OnlyOwner{
Request memory req;
req.reqdescription=reason;
requests.push(req);

}

function withdrawal(uint8 reqindex,uint16 amount) public OnlyOwner{
 Request memory req=requests[reqindex];
// require(req.approvalscount>=contributerscount/2);
require(address(this).balance>=amount);
owner.transfer(address(this).balance);

}
function approverequest(uint index)public{
    Request storage req=requests[index];
    require(contributers[msg.sender]||heros[msg.sender]);
    require(!(req.approvals[msg.sender]));
    req.approvals[msg.sender]=true;
    if(req.approvalscount==0)
      req.approvalscount=0 ;
     else
      req.approvalscount++;


} 
function becomehero() payable public{
    require(premiumprice<=msg.value);
    heros[msg.sender]=true;
    heroCount++;
}





function noConfidence() public{ 
require(heros[msg.sender]);
noConfidenceCount++;

}

function closecampign() public{
    require(msg.sender==founder);
    founder.transfer(address(this).balance);
}

}
contract Donation{
    address payable owner;
 string public title;
 string public description;
 string public image;


constructor(address payable Owner,string memory Title,string memory Description,string memory Image)public{
owner=Owner;title=Title;description=Description;image=Image;
}

    function donate() public payable{
        require(msg.value>=2 wei);

    }
    function withdrawal() public{
        require(msg.sender==owner);
        owner.transfer(address(this).balance);
    }
}