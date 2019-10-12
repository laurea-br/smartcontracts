pragma solidity 0.5.11;

contract CertificateDiploma {
    
    //address [] wallets;
    
    struct School {
        string name;
        string taxID;
        string countryCode;
        address schoolAddress;
    }
    
    struct Student {
        string name;
        string nationalID;
        string countryCode;
        address studentAddress;
        bool active;
        bool laurated;
    }
    
    struct Course {
        string name;
        string internalID;
        string description;
        string teacherName;
        string schoolPrincipalName;
        uint startDate;
        uint finishDate;
        uint cargaHoraria;
        bool exists;
    }
    
    event StudentLaurated(uint indexed courseID, bytes32 indexed nationalID, uint256 indexed studentID);
    event CourseCreated(uint256 indexed courseID, string courseName);
    
    School public school;
    Course[] public courses;
    mapping(bytes32 => Student) students;
    Student[] arrayStudents;
    
    constructor(string memory _name, string memory _taxID, string memory _countrycode) public {
        school = School(_name, _taxID, _countrycode, msg.sender);
    }
    
    function addCourse(
        string memory _name,
        string memory _internalID,
        string memory _description,
        string memory _teacherName,
        string memory _schoolPrincipalName,
        uint _cargaHoraria,
        uint _startDate,
        uint _finishDate
    )
    public
    returns (bool)
    {
        
        Course memory c = Course( _name, _internalID, _description, _teacherName, _schoolPrincipalName, _cargaHoraria, _startDate, _finishDate, true);
        courses.push(c);
        emit CourseCreated(courses.length-1, _name);
        return true;
    }
    
    function addStudentIntoCourse(
        uint _courseID,
        string memory _name,
        string memory _nationalID,
        string memory _countryCode,
        address _studentAddress)
        public
        returns (bool) 
    {
        //require (msg.sender == wallets);
        require(courses[_courseID].exists, "Course ID supplied does not exists");
        Student memory s = Student(_name, _nationalID, _countryCode, _studentAddress, false, false);
        students[stringToBytes32(_nationalID)] = s;
        arrayStudents.push(s);
        emit StudentLaurated(_courseID, stringToBytes32(_nationalID), arrayStudents.length);
        return true;
    }
    
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
    
        assembly {
            result := mload(add(source, 32))
        }
    }
    
    
    function anonymizeCertificate(bytes32 studentID) public returns(bool) 
    {
        //require (msg.sender == wallets);
        if (students[studentID].active == true){
            students[studentID].active = false;
            return true;
        }
        else {
            students[studentID].active = true;
            return true;
        }
    }
    
    function showCertificate(bytes32 studentID, uint256 courseID) public view returns (string memory, string memory, string memory, string memory, uint, uint, uint) {
        require (students[studentID].active == true);
        Student memory s = students[studentID];
        Course memory c = courses[courseID];
        return(s.name, c.name, c.schoolPrincipalName, c.teacherName, c.startDate, c.finishDate, c.cargaHoraria);
    }
}
