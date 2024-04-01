const Migrations = artifacts.require("PointSystem");
module.exports = function (deployer) {
    deployer.deploy(Migrations, 100);
}