pragma solidity >=0.4.17;

contract CampaignFactory{
    address[] public deployedCampaigns;
    constructor(){
        
    }
    function createCampaign(uint256 minimum) public{
        address newCampaign =  address(new Campaign(minimum, msg.sender));    
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint256 public approversCount;
    
    modifier restricted() {
        require((msg.sender == manager));
        _;
    }
    
    constructor(uint256 minimum, address creator)  {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value>minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string memory description, uint  value, address  recipient) public restricted {
        Request storage newRequest = requests.push();
        newRequest.description = description; 
        newRequest.value = value; 
        newRequest.recipient = recipient; 
        newRequest.complete = false; 
        newRequest.approvalCount = 0; 
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint256 index) public payable restricted {
        Request storage request = requests[index];
        
        require(!request.complete);
        require(request.approvalCount > (approversCount/2));
        
        payable(request.recipient).transfer(request.value);
        request.complete = true;
    }
}
