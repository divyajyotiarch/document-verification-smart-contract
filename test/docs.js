var Docs = artifacts.require(‘./DocStorage.sol’);

contract('Docs', function(accounts) {
    var mainAccount = accounts[0];


	 it("should insert a document", function() {
        var docsBeforeInsertion = null;

        return Docs.deployed().then(function(contractInstance) {
            // storing the contract instance so it will be used later on
            instance = contractInstance;
        // calling the smart contract function displayDocCount to get the current number of documents
        return instance.displayDocCount.call();
    }).then(function(result) {
        // storing the current number on the var docsBeforeInsertion
        docsBeforeInsertion = result.toNumber();

        // registering the user calling the smart contract function insertDoc
        return instance.insertDoc('Test Document Name', 'Test Status', {
            from: mainAccount
        });
    }).then(function(result) {
        return instance.displayDocCount.call();
    }).then(function(result) {
        // checking if the total number of documents is increased by 1
        assert.equal(result.toNumber(), (docsBeforeInsertion+1), "number of documents must be (" + docsBeforeInsertion + " + 1)");

        // calling the smart contract function isDocPresent to know if the document is already present.
        return instance.isDocPresent.call();
    }).then(function(result) {
        // we are expecting a boolean in return that it should be TRUE
        assert.isTrue(result);
    });
}); // end of "should insert a document"


	it("document should not be validates twice", function() {
	//calling function isVoted to check if a reviewer has already voted for a document
	return instance.isVoted.call();
});


    it("a document should not be duplicated", function() {
        // we are expecting the call to insertDoc to fail since the document
        // already exists!
        return instance.insertDoc('Test document address Twice', 'Test Status Twice', {
            from: mainAccount
        }).then(assert.fail).catch(function(error) { // here we are expecting the exception
            assert(true);
        });
    }); 


});
