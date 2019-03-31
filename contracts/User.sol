pragma solidity >=0.4.22 <0.6.0;

contract User {

  //datastructure that stores user

  struct UserPeer {
  string category; /** to qualify user as the owner or the validator */
    uint index; /** to keep track othe index of the user */
  }
  
  // it maps the user address with the user ID
  mapping(address => UserPeer) private users;
  address[] private userIndex;

  event LogNewUser   (address indexed userAddress, uint index, string category);
  
  // Function to check if user is already present
  function isUserPresent(address userAddress)  public view returns(bool) 
  {
    if(userIndex.length == 0) return false;
    return (userIndex[users[userAddress].index] == userAddress);
  }

  
   /**
     *Function to insert user.This function must be private because an user
     * cannot insert another user on behalf of someone else.
     *
     * @param userAddress     The displaying address
     * @param category        The category of the user
     */
  function insertUser(address userAddress, string memory category) private returns(uint index)
  {
    if(isUserPresent(userAddress)) revert(); 
    users[userAddress].category = category;
    users[userAddress].index     = userIndex.push(userAddress)-1;
    emit  LogNewUser(userAddress, users[userAddress].index, users[userAddress].category);
    return userIndex.length-1;
  }
  
  // Function to return user address
  function getUser(address userAddress) public view returns(string memory category, uint index)
  {
    if(!isUserPresent(userAddress)) revert(); 
    return(users[userAddress].category,users[userAddress].index);
  } 

  // Function to get category of user
  function getUserCategory(address userAddress) public view returns(string memory category)
  {
    if(!isUserPresent(userAddress)) revert(); 
    return users[userAddress].category;
  }
  
  // Function to get number of users
  function getUserCount() public view returns(uint)
  {
    return userIndex.length;
  }

  // Function to get user at given index
  function getUserAtIndex(uint index) public view returns(address userAddress)
  {
    return userIndex[index];
  }

}