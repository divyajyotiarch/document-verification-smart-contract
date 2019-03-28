pragma solidity >=0.4.22 <0.6.0;

/** @title Document Storage. */
contract DocStorage {
  
  /** @dev Audits the document uploaded.      */

  struct Documents {
    address index;  /** for keeping track of the index of the owner of document. */
    uint status;    /** status of the document */
    address[] upvote; /** keeps track of the number of upvotes for the document */ 
    address[] downvote; /** keeps track of the number of downvotes for the document. */
  }
  
  // Document structs are mapped to hash values
  mapping(string  => Documents) private docs; /** creates unique id for each document struct */
  string [] public docHashes;

  event AddNewDoc(string hash, address userAddress, uint status);
 
  // Function to insert a document in mapping
  function insertDoc(address userAddress, string memory hash) public 
  {
    require(!isDocPresent(hash));
    emit AddNewDoc(hash, userAddress, 1);
    docHashes.push(hash);
    docs[hash].index = userAddress;
    docs[hash].status = 1;
  }

  // Function to check if a document is already present
  function isDocPresent(string memory hashval) public view returns(bool)
  {
    return (docs[hashval].index != address(0));
  }

  // Function to check if given address is owner of document
  function isOwner(address userAddress, string memory hash) public view returns(bool)
  {
    if (docs[hash].index == userAddress) 
    {
      return true;
    }
    return false;
  }  

  // Function to return hash value of document
  function displayHash(uint num) public view returns(string memory)
  {
    return docHashes[num];
  }

  // Function to return status of document
  function displayDocStatus(string memory hash) public view returns(uint)
  {
    return docs[hash].status;
  }

  // Function to return count of uploaded documents
  function displayDocCount() public view returns(uint)
  {
    return docHashes.length;
  }
  
  // Function to upvote a document by reviewer
  function upVote(string memory docHash, address Raddr)
  public
  {
    require(!isAudited(docHash) && !isVoted(docHash, Raddr));
    docs[docHash].upvote.push(Raddr);
    
    if(isAudited(docHash))
      {
        if(getUpvoteCount(docHash) > getDownvoteCount(docHash))
          {
            docs[docHash].status = 0;
          }
        else
          {
            docs[docHash].status = 2;
          }
      }
  }
  
  // Function to downvote a document by reviewer
  function downVote(string memory docHash, address Raddr)  public
  {
    require(!isAudited(docHash) && !isVoted(docHash, Raddr));
    docs[docHash].downvote.push(Raddr);
    if(isAudited(docHash))
      {
        if(getUpvoteCount(docHash) > getDownvoteCount(docHash))
          {
            docs[docHash].status = 0;
          }
        else
          {
            docs[docHash].status = 2;
          }
      }
  }
  
  // Function to check if a reviewer has already voted for a document
  function isVoted(string memory docHash, address addr) public view returns(bool)
  {
    for(uint i=0;i<docs[docHash].upvote.length;i++)
      {
        if(docs[docHash].upvote[i] == addr)
          {
            return true;
          }
      }
    for(uint i=0;i<docs[docHash].downvote.length;i++)
      {
        if(docs[docHash].downvote[i] == addr)
          {
            return true;
          }
      }
    return false;
  }
  
  // Function to check if a document has been approved/disapproved
  function isAudited(string memory docHash) public view returns (bool)
  {
    return ((docs[docHash].upvote.length + docs[docHash].downvote.length) >= 9);
  }
  
  // Function to get number of upvotes
  function getUpvoteCount(string memory docHash) public view returns(uint)
  {
    return (docs[docHash].upvote.length);
  }
  
  // Function to get number of downvotes
  function getDownvoteCount(string memory docHash) public view returns(uint)
  {
    return (docs[docHash].downvote.length);
  }
  
  // Function to compare string memory values
   function compareStrings (string memory a, string memory b)  public view returns (bool)
  {
      return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
   }

}

