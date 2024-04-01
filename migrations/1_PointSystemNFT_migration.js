const PointSystemNFT = artifacts.require("PointSystemNFT");

module.exports = function (deployer) {
    // Adjust the value of requiredPoints as needed
    deployer.deploy(PointSystemNFT, "PointSystemNFT", "PSNFT", 100); // Deploying with requiredPoints = 100
};
