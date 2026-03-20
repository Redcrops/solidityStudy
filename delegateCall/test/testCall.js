
const { BN, expectEvent, constants } = require('@openzeppelin/test-helpers');
require('chai').should();
const CalculatorFactory = artifacts.require('Caculator');
const MachineFactory   = artifacts.require('Machine');
const StorageFactory   = artifacts.require('Storage');

contract('Machine',(accounts)=>{
    const [owner] = accounts;
    let Calculator, Machine, Storage;

    beforeEach(async () => {
        Storage = await StorageFactory.new(new BN('0'));
        Machine = await MachineFactory.new(Storage.address);
    });

    describe('#addValuesWithCall()', () => {
            
        beforeEach(async () => {
            Calculator = await CalculatorFactory.new();
        });
            
        it('should successfully add values with call', async () => {
            const result = await Machine.addValuesWithCall(Calculator.address, new BN('1'), new BN('2'));expectEvent.inLogs(result.logs, 'AddedValuesByCall', {
            a: new BN('1'),
            b: new BN('2'),
            success: true,
            });
            
            (result.receipt.from).should.be.equal(owner.toString().toLowerCase());
            (result.receipt.to).should.be.equal(Machine.address.toString().toLowerCase());
            (await Calculator.calculateResult()).should.be.bignumber.equal(new BN('3'));
            (await Machine.calculateResult()).should.be.bignumber.equal(new BN('0'));
            (await Machine.user()).should.be.equal(constants.ZERO_ADDRESS);
            
            (await Calculator.user()).should.be.equal(Machine.address);
        });
        });

});
