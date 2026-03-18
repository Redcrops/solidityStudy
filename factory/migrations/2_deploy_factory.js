const Child = artifacts.require("Child");
const Factory = artifacts.require("Factory"); 
module.exports = function (_deployer) {

  _deployer.deploy(Child).then(() => _deployer.deploy(Factory, Child.address)); 
};