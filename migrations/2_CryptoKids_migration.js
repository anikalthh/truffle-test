const Migrations = artifacts.require("CryptoKids");
module.exports = function (deployer) {
    deployer.deploy(Migrations);
}