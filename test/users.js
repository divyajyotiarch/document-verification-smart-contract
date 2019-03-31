var Users = artifacts.require(‘./User.sol’);

contract('Users', function(accounts) {
    var mainAccount = accounts[0];


	 it("should register a user", function() {
        var usersBeforeRegister = null;

        return Users.deployed().then(function(contractInstance) {
            // storing the contract instance so it will be used later on
            instance = contractInstance;
        // calling the smart contract function getUserCount to get the current number of users
        return instance.getUserCount.call();
    }).then(function(result) {
        // storing the current number on the var usersBeforeRegister
        usersBeforeRegister = result.toNumber();

        // registering the user calling the smart contract function insertUser
        return instance.insertUser('Test User Name', 'Test Status', {
            from: mainAccount
        });
    }).then(function(result) {
        return instance.getUserCount.call();
    }).then(function(result) {
        // checking if the total number of user is increased by 1
        assert.equal(result.toNumber(), (usersBeforeRegister+1), "number of users must be (" + usersBeforeRegister + " + 1)");

        // calling the smart contract function isUserPresent to know if the sender is registered.
        return instance.isUserPresent.call();
    }).then(function(result) {
        // we are expecting a boolean in return that it should be TRUE
        assert.isTrue(result);
    });
}); // end of "should register a user"

it("username and status in the blockchian should be the same the one gave on the registration", function() {
    // NOTE: the contract instance has been instantiated before, so no need
    // to do again: return Users.deployed().then(function(contractInstance) { …
    // like before in "should register an user".
    return instance.getUser.call().then(function(result) {
        // the result is an array where in the position 0 there user ID, in
        // the position 1 the user name and in the position 2 the status,
        assert.equal(result[1], 'Test User Name');

        // the status is type of bytes32: converting the status Bytes32 into string
        let newStatusStr = web3.toAscii(result[2]).replace(/\u0000/g, '');
        assert.equal(newStatusStr, 'Test Status');
    });
}); // end testing username and status


    it("a registered user should not be registered twice", function() {
        // we are expecting the call to insertUser to fail since the user account
        // is already registered!
        return instance.insertUser('Test username Twice', 'Test Status Twice', {
            from: mainAccount
        }).then(assert.fail).catch(function(error) { // here we are expecting the exception
            assert(true);
        });
    }); // end testing registration twice


});
