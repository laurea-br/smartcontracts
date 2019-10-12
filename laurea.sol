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
        uint nationalID;
        string countryCode;
        address studentAddress;
        bool active;
    }
    
    struct Course {
        string name;
        string internalID;
        string teacherName;
        string schoolPrincipalName;
        string startDate;
        string finishDate;
        uint cargaHoraria;
        bool exists;
        //mapping(uint256 => Student) studentsList;
    }
    
    event StudentLaurated(uint indexed courseID, uint256 indexed nationalID, uint256 indexed studentID);
    event CourseCreated(uint256 indexed courseID, string courseName);
    event CourseEdited(uint256 indexed courseID, string courseName);
    
    School public school;
    Course[] public courses;
    mapping(uint256 => Student) public students;
    Student[] public arrayStudents;
    
    constructor(string memory _name, string memory _taxID, string memory _countrycode) public {
        school = School(_name, _taxID, _countrycode, msg.sender);
    }
    
    function addCourse(
        string memory _name,
        string memory _internalID,
        string memory _teacherName,
        string memory _schoolPrincipalName,
        uint256 _cargaHoraria,
        string memory _startDate,
        string memory _finishDate
    )
    public
    returns (bool)
    {
        //require (msg.sender == wallets);
        Course memory c = Course( _name, _internalID, _teacherName, _schoolPrincipalName, _startDate, _finishDate, _cargaHoraria, true);
        courses.push(c);
        emit CourseCreated(courses.length-1, _name);
        return true;
    }
    
    function addStudentIntoCourse(
        uint _courseID,
        string memory _name,
        uint _nationalID,
        string memory _countryCode,
        address _studentAddress)
        public
        returns (bool) 
    {
        //require (msg.sender == wallets);
        require(courses[_courseID].exists, "Course ID supplied does not exists");
        Student memory s = Student(_name, _nationalID, _countryCode, _studentAddress, true);
        students[_nationalID] = s;
        arrayStudents.push(s);
        emit StudentLaurated(_courseID, _nationalID, arrayStudents.length);
        return true;
    }
    
    function anonymizeCertificate(uint256 studentID) public returns(bool) 
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
    
    //falta relacionar aluno e curso
    function showCertificate(uint256 studentID, uint256 courseID) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, uint) {
        require (students[studentID].active == true);
        Student storage s = students[studentID];
        Course storage c = courses[courseID];
        return(s.name, c.name, c.schoolPrincipalName, c.teacherName, c.startDate, c.finishDate, c.cargaHoraria);
    }
}
