# Document Verification Smart Contract

Verifying the validity of digital assets such as a birth certificate, a pdf document stating your will or a signed legal document specifying a business deal

The DocStorage.sol file is a smart contract that checks whether the document is audited or not. 

A set of validators are chosen to validate the set of documents. 
The validators can either upvote or downvote a document. 
This smart contract needs atleast 9 validators to decide the document status. 
If the upvotes are more than the downvotes, then we can set the status of the document as '0' meaning approved or '2' meaning disapproved. 

User.sol file is a smart contract to keep track of the authentic users. 

It stores the user category whether the user is an Owner or a Validator. Accordingly the user is allowed to vote. To avoid addition of duplicate users or authority mismanagement. 
