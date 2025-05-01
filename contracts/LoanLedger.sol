//// SPDX-License-Identifier: MIT
//pragma solidity ^0.8.0;
//
//contract LoanLedger {
//    struct LoanBasic {
//        uint256 loan_amnt;
//        string term;
//        uint256 int_rate;
//        uint256 installment;
//    }
//
//    struct LoanFinancial {
//        uint8 emp_length;
//        uint256 annual_inc;
//        uint256 dti;
//    }
//
//    struct LoanLocation {
//        string zip_code;
//        string addr_state;
//    }
//
//    struct LoanStatus {
//        string grade;
//        string home_ownership;
//        string verification_status;
//        uint16 issue_year;
//        string job_category;
//        bool isFraud; // New field to store the fraud prediction
//    }
//
//    // Mapping loanId to different aspects of loan data
//    mapping(uint256 => LoanBasic) public loanBasics;
//    mapping(uint256 => LoanFinancial) public loanFinancials;
//    mapping(uint256 => LoanLocation) public loanLocations;
//    mapping(uint256 => LoanStatus) public loanStatuses;
//
//    uint256 public loanCount;
//
//    event LoanCreated(uint256 loanId, string addr_state, string zip_code, bool isFraud, uint256 timestamp);
//
//    function createLoanBasic(
//        uint256 _loan_amnt,
//        string memory _term,
//        uint256 _int_rate,
//        uint256 _installment
//    ) public returns (uint256) {
//        uint256 loanId = loanCount;
//        loanBasics[loanId] = LoanBasic(
//            _loan_amnt,
//            _term,
//            _int_rate,
//            _installment
//        );
//        loanCount++;
//        return loanId;
//    }
//
//    function setLoanFinancial(
//        uint256 _loanId,
//        uint8 _emp_length,
//        uint256 _annual_inc,
//        uint256 _dti
//    ) public {
//        require(_loanId < loanCount, "Invalid loan ID");
//        loanFinancials[_loanId] = LoanFinancial(
//            _emp_length,
//            _annual_inc,
//            _dti
//        );
//    }
//
//    function setLoanLocation(
//        uint256 _loanId,
//        string memory _zip_code,
//        string memory _addr_state
//    ) public {
//        require(_loanId < loanCount, "Invalid loan ID");
//        loanLocations[_loanId] = LoanLocation(
//            _zip_code,
//            _addr_state
//        );
//    }
//
//    function setLoanStatus(
//        uint256 _loanId,
//        string memory _grade,
//        string memory _home_ownership,
//        string memory _verification_status,
//        uint16 _issue_year,
//        string memory _job_category,
//        bool _isFraud
//    ) public {
//        require(_loanId < loanCount, "Invalid loan ID");
//        loanStatuses[_loanId] = LoanStatus(
//            _grade,
//            _home_ownership,
//            _verification_status,
//            _issue_year,
//            _job_category,
//            _isFraud
//        );
//
//        // Emit the LoanCreated event with the fraud prediction
//        // We emit this event in setLoanStatus since it's the last step in setting loan data
//        emit LoanCreated(
//            _loanId,
//            loanLocations[_loanId].addr_state,
//            loanLocations[_loanId].zip_code,
//            _isFraud,
//            block.timestamp
//        );
//    }
//
//    // Helper function to get complete loan data
//    function getLoan(uint256 _loanId) public view returns (
//        LoanBasic memory,
//        LoanFinancial memory,
//        LoanLocation memory,
//        LoanStatus memory
//    ) {
//        require(_loanId < loanCount, "Invalid loan ID");
//        return (
//            loanBasics[_loanId],
//            loanFinancials[_loanId],
//            loanLocations[_loanId],
//            loanStatuses[_loanId]
//        );
//    }
//
//    function getLoanCount() public view returns (uint256) {
//        return loanCount;
//    }
//}
//

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoanLedger {
    struct LoanBasic {
        uint256 loan_amnt;
        string term;
        uint256 int_rate;
        uint256 installment;
    }

    struct LoanFinancial {
        uint8 emp_length;
        uint256 annual_inc;
        uint256 dti;
    }

    struct LoanLocation {
        string zip_code;
        string addr_state;
    }

    struct LoanStatus {
        string grade;
        string home_ownership;
        string verification_status;
        uint16 issue_year;
        string job_category;
        bool isFraud; // New field to store the fraud prediction
    }

    // Mapping loanId to different aspects of loan data
    mapping(uint256 => LoanBasic) public loanBasics;
    mapping(uint256 => LoanFinancial) public loanFinancials;
    mapping(uint256 => LoanLocation) public loanLocations;
    mapping(uint256 => LoanStatus) public loanStatuses;

    uint256 public loanCount;

    // Event to emit when a loan is created (in createLoanBasic)
    event LoanBasicCreated(uint256 loanId, uint256 loan_amnt, uint256 timestamp);

    // Existing event (emitted in setLoanStatus)
    event LoanCreated(uint256 loanId, string addr_state, string zip_code, bool isFraud, uint256 timestamp);

    function createLoanBasic(
        uint256 _loan_amnt
    ) public returns (uint256) {
        uint256 loanId = loanCount;
        loanBasics[loanId] = LoanBasic(
            _loan_amnt,
            "", // term will be set in setLoanFinancial
            0,  // int_rate will be set in setLoanFinancial
            0   // installment will be set in setLoanFinancial
        );
        loanCount++;
        emit LoanBasicCreated(loanId, _loan_amnt, block.timestamp);
        return loanId;
    }

    function setLoanFinancial(
        uint256 _loanId,
        string memory _term,
        uint256 _int_rate,
        uint256 _installment,
        uint8 _emp_length,
        uint256 _annual_inc,
        uint256 _dti
    ) public {
        require(_loanId < loanCount, "Invalid loan ID");
        loanBasics[_loanId].term = _term;
        loanBasics[_loanId].int_rate = _int_rate;
        loanBasics[_loanId].installment = _installment;
        loanFinancials[_loanId] = LoanFinancial(
            _emp_length,
            _annual_inc,
            _dti
        );
    }

    function setLoanLocation(
        uint256 _loanId,
        string memory _zip_code,
        string memory _addr_state
    ) public {
        require(_loanId < loanCount, "Invalid loan ID");
        loanLocations[_loanId] = LoanLocation(
            _zip_code,
            _addr_state
        );
    }

    function setLoanStatus(
        uint256 _loanId,
        string memory _grade,
        string memory _home_ownership,
        string memory _verification_status,
        uint16 _issue_year,
        string memory _job_category,
        bool _isFraud
    ) public {
        require(_loanId < loanCount, "Invalid loan ID");
        loanStatuses[_loanId] = LoanStatus(
            _grade,
            _home_ownership,
            _verification_status,
            _issue_year,
            _job_category,
            _isFraud
        );

        // Emit the LoanCreated event with the fraud prediction
        emit LoanCreated(
            _loanId,
            loanLocations[_loanId].addr_state,
            loanLocations[_loanId].zip_code,
            _isFraud,
            block.timestamp
        );
    }

    // Helper function to get complete loan data
    function getLoan(uint256 _loanId) public view returns (
        LoanBasic memory,
        LoanFinancial memory,
        LoanLocation memory,
        LoanStatus memory
    ) {
        require(_loanId < loanCount, "Invalid loan ID");
        return (
            loanBasics[_loanId],
            loanFinancials[_loanId],
            loanLocations[_loanId],
            loanStatuses[_loanId]
        );
    }

    function getLoanCount() public view returns (uint256) {
        return loanCount;
    }
}