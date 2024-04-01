const PointSystemNFT = artifacts.require("PointSystemNFT");

contract("PointSystemNFT", (accounts) => {
    let pointSystemNFTInstance;

    before(async () => {
        // Deploy the PointSystemNFT contract
        pointSystemNFTInstance = await PointSystemNFT.new(100); // Set requiredPoints to 100
    });

    it("should deploy the PointSystemNFT contract with the correct requiredPoints", async () => {
        const requiredPoints = await pointSystemNFTInstance.requiredPoints();
        assert.equal(requiredPoints, 100, "requiredPoints should be 100");
    });

    it("should allow the owner to set user points", async () => {
        const user = accounts[1];
        const points = 50;
        await pointSystemNFTInstance.setUserPoints(user, points, { from: accounts[0] });
        const userPoints = await pointSystemNFTInstance.userPoints(user);
        assert.equal(userPoints, points, "User points should be set correctly");
    });

    it("should allow a user to claim an NFT when they have enough points", async () => {
        const user = accounts[1];
        const points = 100; // Set user points to meet the requiredPoints
        await pointSystemNFTInstance.setUserPoints(user, points, { from: accounts[0] });
        
        // Claim NFT and check if event is emitted
        const tx = await pointSystemNFTInstance.claimNFT({ from: user });
        assert.equal(tx.logs[0].event, "NFTClaimed", "NFTClaimed event should be emitted");
        assert.equal(tx.logs[0].args.user, user, "NFTClaimed event should include the correct user");
    });

    it("should not allow a user to claim an NFT when they do not have enough points", async () => {
        const user = accounts[1];
        const points = 50; // Set user points below the requiredPoints
        await pointSystemNFTInstance.setUserPoints(user, points, { from: accounts[0] });

        // Try to claim NFT and expect a revert
        try {
            await pointSystemNFTInstance.claimNFT({ from: user });
            assert.fail("Expected revert not received");
        } catch (error) {
            assert.include(error.message, "User does not have enough points to claim NFT", "Incorrect revert message");
        }
    });
});
