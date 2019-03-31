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
  
  // Document structs are mapped to docID values
  mapping(string  => Documents) private docs; /** creates unique id for each document struct */
  string [] public docIdStorage;

  event docAdded(string docID, address userAddress, uint status);
 
   /**
     *Function to insert document.This function must be private because an user
     * cannot insert another document on behalf of someone else.
     *
     * @param userAddress     The displaying address
     * @param docID          The ID of document
     */
  function insertDoc(address userAddress, string memory docID) private 
  {
    require(!isDocPresent(docID));
    emit docAdded(docID, userAddress, 1);
    docIdStorage.push(docID);
    docs[docID].index = userAddress;
    docs[docID].status = 1;
  }

  // Function to check if a document is already present
  function isDocPresent(string memory _docID) public view returns(bool)
  {
    return (docs[_docID].index != address(0));
  }

  // Function to check if given address is owner of document
  function isOwner(address userAddress, string memory docID) public view returns(bool)
  {
    if (docs[docID].index == userAddress) 
    {
      return true;
    }
    return false;
  }  

  // Function to return docID value of document
  function displayDocID(uint num) public view returns(string memory)
  {
    return docIdStorage[num];
  }

  // Function to return status of document
  function displayDocStatus(string memory docID) public view returns(uint)
  {
    return docs[docID].status;
  }

  // Function to return count of uploaded documents
  function displayDocCount() public view returns(uint)
  {
    return docIdStorage.length;
  }
  
  // Function to upvote a document by reviewer
  /**
     *This function must be private because a user
     * cannot vote on behalf of someone else.
     *
     * @param Raddr     The reviewer's address
     * @param _docId          The ID of document
     */
  function upVote(string memory _docId, address Raddr)
  private
  {
    require(!isAudited(_docId) && !isVoted(_docId, Raddr));
    docs[_docId].upvote.push(Raddr);
    
    if(isAudited(_docId))
      {
        if(getUpvoteCount(_docId) > getDownvoteCount(_docId))
          {
            docs[_docId].status = 0;
          }
        else
          {
            docs[_docId].status = 2;
          }
      }
  }
  
  // Function to downvote a document by reviewer
   /**
     *This function must be private because a user
     * cannot vote on behalf of someone else.
     *
     * @param Raddr     The reviewer's address
     * @param _docId          The ID of document
     */
  function downVote(string memory _docId, address Raddr)  private
  {
    require(!isAudited(_docId) && !isVoted(_docId, Raddr));
    docs[_docId].downvote.push(Raddr);
    if(isAudited(_docId))
      {
        if(getUpvoteCount(_docId) > getDownvoteCount(_docId))
          {
            docs[_docId].status = 0;
          }
        else
          {
            docs[_docId].status = 2;
          }
      }
  }
  
  // Function to check if a reviewer has already voted for a document
  function isVoted(string memory _docId, address addr) public view returns(bool)
  {
    for(uint i=0;i<docs[_docId].upvote.length;i++)
      {
        if(docs[_docId].upvote[i] == addr)
          {
            return true;
          }
      }
    for(uint i=0;i<docs[_docId].downvote.length;i++)
      {
        if(docs[_docId].downvote[i] == addr)
          {
            return true;
          }
      }
    return false;
  }
  
  // Function to check if a document has been approved/disapproved
  function isAudited(string memory _docId) public view returns (bool)
  {
    return ((docs[_docId].upvote.length + docs[_docId].downvote.length) >= 9);
  }
  
  // Function to get number of upvotes
  function getUpvoteCount(string memory _docId) public view returns(uint)
  {
    return (docs[_docId].upvote.length);
  }
  
  // Function to get number of downvotes
  function getDownvoteCount(string memory _docId) public view returns(uint)
  {
    return (docs[_docId].downvote.length);
  }
  
  // Function to compare string memory values
   function compareStrings (string memory a, string memory b)  public view returns (bool)
  {
      return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
   }

}

