// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract ArtworkEscrow {
address public buyer;
address public seller;
address public escrowAgent;
uint public amount;
bool public completed;

constructor(address _buyer, address _seller, address _escrowAgent, uint _amount) payable {
    buyer = _buyer;
    seller = _seller;
    escrowAgent = _escrowAgent;
    amount = _amount;
    completed = false;
    require(msg.value == _amount, "The amount transferred must be equal to the transaction amount.");
}

function confirmTransaction() public {
    require(msg.sender == buyer || msg.sender == seller || msg.sender == escrowAgent, "Only the buyer, seller, or escrow agent can confirm the transaction.");
    completed = true;
}

function releaseFunds() public {
    require(msg.sender == escrowAgent, "Only the escrow agent can release funds.");
    require(completed == true, "The transaction must be confirmed before funds can be released.");
    payable(seller).transfer(amount);
}

function refundFunds() public {
    require(msg.sender == escrowAgent, "Only the escrow agent can refund funds.");
    require(completed == false, "The transaction must not be confirmed before funds can be refunded.");
    payable(buyer).transfer(amount);
}
}
