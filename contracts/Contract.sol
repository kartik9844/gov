// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract LicenseContract {
    struct License {
        string fullname;
        uint DOB;
        uint DLno;
        uint validDate;
        string sonOf;
        string homeAddress;
        address payable owner;
    }

    uint public licenseCount;
    mapping(uint => License) public licenses;
    mapping(address => uint) public licenseOwnerIndex;

    event LicenseCreated(
        uint indexed _id,
        string _fullname,
        uint _DOB,
        uint _DLno,
        uint _validDate,
        string _sonOf,
        string _homeAddress,
        address _owner
    );

    function createLicense(
        string memory _fullname,
        uint _DOB,
        uint _DLno,
        uint _validDate,
        string memory _sonOf,
        string memory _homeAddress
    ) public {
        require(bytes(_fullname).length > 0);
        require(bytes(_sonOf).length > 0);
        require(bytes(_homeAddress).length > 0);
        require(_DOB > 0);
        require(_DLno > 0);
        require(_validDate > _DOB);

        licenseCount++;
        licenses[licenseCount] = License(
            _fullname,
            _DOB,
            _DLno,
            _validDate,
            _sonOf,
            _homeAddress,
            payable(msg.sender)
        );
        licenseOwnerIndex[msg.sender] = licenseCount;

        emit LicenseCreated(
            licenseCount,
            _fullname,
            _DOB,
            _DLno,
            _validDate,
            _sonOf,
            _homeAddress,
            msg.sender
        );
    }

    function getLicenseCount() public view returns (uint) {
        return licenseCount;
    }

    function getLicense(uint _id) public view returns (License memory) {
        require(_id > 0 && _id <= licenseCount);
        return licenses[_id];
    }

    function getLicenseByAddress(address _owner) public view returns (License memory) {
        require(licenseOwnerIndex[_owner] != 0);
        return licenses[licenseOwnerIndex[_owner]];
    }

    // function validateLicense(uint _id) public view returns (bool) {
    //     require(_id > 0 && _id <= licenseCount);
    //     License memory license = licenses[_id];
    //     return (license.owner == msg.sender && block.timestamp <= license.validDate);
    // }
}