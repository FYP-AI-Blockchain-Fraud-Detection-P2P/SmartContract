// migrations/2_deploy_loan_ledger.js
const LoanLedger = artifacts.require("LoanLedger");

module.exports = function (deployer) {
    deployer.deploy(LoanLedger);
};
