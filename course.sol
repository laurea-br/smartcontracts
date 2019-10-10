pragma solidity 0.5.11.;

pragma experimental ABIEncoderV2;

contract LaureaCourse {
    
    address schoolWallet;
    string schoolName;
    string principalName;
    string courseName;
    string coordinatorName;
    string local;
    string startDate;
    string finishDate;
    uint256 amountOfHours;
    uint256 totalOfClasses;
    uint256 minimumAchievement;
    uint256 numberOfStudents;
    uint256 classesCreated;
    uint256 classesFinished;
    uint256 studentsLaurated;
    bool laurated;
    
    Student[] students;
    Class[] classes;
    
    struct Student {
        address studentWallet;
        string studentName;
        uint256 nationalID;
        uint256 numberOfClasses;
        string evaluation;
        bool active;
        bool laurated;
        bool publicCertificate;
    }
    
    struct Class {
        string className;
        string professorName;
        uint256 classDate;
        uint256 classHours;
        uint256 password;
        uint256 studentsInClass;
        bool active;
        bool finished;
    }
    
    event ClassCreated(uint256 indexed classID, string indexed className);
    event ClassEdited(uint256 indexed classID, string indexed className);
    event ClassOpened(uint256 indexed classID, uint256 now);
    event ClassClosed(uint256 indexed classID, uint256 now);
    event StudentCreated(uint256 indexed studentID, uint256 indexed nationalID, string indexed studentName);
    event StudentEdited(uint256 indexed studentID, uint256 indexed nationalID, string indexed studentName);
    event AttendanceRegistered(uint256 indexed studentID, uint256 indexed classID, uint256 now);
    event AttendanceDeleted(uint256 indexed studentID, uint256 indexed classID, uint256 now);
    event StudentLaurated(string indexed courseName, uint256 indexed nationalID, uint256 now);
    
    constructor(
        string memory _schoolName, 
        string memory _principalName, 
        string memory _courseName,
        string memory _coordinatorName,
        string memory _local,
        string memory _startDate,
        string memory _finishDate,
        uint256 _amountOfHours,
        uint256 _numberOfClasses,
        uint256 _minimumAchievement
    ) public {
        schoolWallet = msg.sender;
        schoolName = _schoolName;
        principalName = _principalName;
        courseName = _courseName;
        coordinatorName = _coordinatorName;
        local = _local;
        startDate = _startDate;
        finishDate = _finishDate;
        amountOfHours = _amountOfHours;
        totalOfClasses = _numberOfClasses;
        minimumAchievement = _minimumAchievement;
        laurated = false;
    }
    
    function editCoursesDetails (
        string memory _courseName,
        string memory _coordinatorName,
        string memory _local,
        string memory _startDate,
        string memory _finishDate,
        uint256 _amountOfHours,
        uint256 _numberOfClasses,
        uint256 _minimumAchievement
        ) public 
    {
        require (msg.sender == schoolWallet);
        courseName = _courseName;
        coordinatorName = _coordinatorName;
        local = _local;
        startDate = _startDate;
        finishDate = _finishDate;
        amountOfHours = _amountOfHours;
        totalOfClasses = _numberOfClasses;
        minimumAchievement = _minimumAchievement;
    }
    
    function addClass (
        string memory _className,
        string memory _professorName,
        uint256 _classDate,
        uint256 _classHours, 
        uint256 _password
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        require (classesCreated <= totalOfClasses);
        Class memory c = Class(_className, _professorName, _classDate, _classHours, _password, 0, false, false);
        classes.push(c);
        classesCreated ++;
        emit ClassCreated(classes.length-1, _className);
        return true;
    }
    
    function editClass (
        uint256 classID,
        string memory _className,
        string memory _professorName,
        uint256 _classDate,
        uint256 _classHours, 
        uint256 _password
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Class storage c = classes[classID];
        c.className = _className;
        c.professorName = _professorName;
        c.classDate = _classDate;
        c.classHours = _classHours;
        c.password = _password;
        emit ClassEdited(classID, _className);
        return true;
    }
    
    function addStudent (
        address _studentWallet,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Student memory s = Student( _studentWallet, _studentName, _nationalID, 0, "Em Andamento", true, false, false);
        students.push(s);
        numberOfStudents ++;
        emit StudentCreated(students.length-1, _nationalID, _studentName);
        return true;
    }
    
    function editStudent (
        uint256 studentID,
        address _studentWallet,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Student memory s = students[studentID];
        s.studentWallet = _studentWallet;
        s.studentName = _studentName;
        s.nationalID = _nationalID;
        emit StudentEdited(studentID, _nationalID, _studentName);
        return true;
    }
    
    function openClass (uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        classes[classID].active = true;
        emit ClassOpened(classID, now);
        return true;
    }
    
    function closeClass (uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        classes[classID].active = false;
        if (classes[classID].finished = true) {
            emit ClassClosed(classID, now);
            return true;
        }
        classes[classID].finished = true;
        classesFinished ++;
        emit ClassClosed(classID, now);
        return true;
    }
    
    function registerAttendance (uint256 studentID, uint256 classID, uint256 _password) public returns(bool) {
        require (msg.sender == students[studentID].studentWallet);
        require (classes[classID].active == true);
        require (classes[classID].password == _password);
        Class storage c = classes[classID];
        c.studentsInClass ++;
        students[studentID].numberOfClasses ++;
        emit AttendanceRegistered(studentID, classID, now);
        return true;
    }
    
    function registerAttendanceForAStudent (uint256 studentID, uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        require (classes[classID].active == true);
        students[studentID].numberOfClasses ++;
        emit AttendanceRegistered(studentID, classID, now);
        return true;
    }
    
    function deleteAttendance (uint256 studentID, uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        students[studentID].numberOfClasses -= 1;
        Class storage c = classes[classID];
        c.studentsInClass -= 1;
        emit AttendanceDeleted(studentID, classID, now);
        return true;
    }
    
    function laurateStudents () public returns(bool)  { 
        require (msg.sender == schoolWallet);
        for (uint i=0; i<students.length; i++) {
            if (students[students.length-1].numberOfClasses < minimumAchievement) {
                return false;
            }
            if (students[students.length-1].laurated == true) {
                return false;
            }
            if(students[students.length-1].numberOfClasses >= minimumAchievement){
                students[students.length-1].evaluation = "Aprovado";
                students[students.length-1].laurated = true;
                studentsLaurated ++;
                emit StudentLaurated(courseName, students[students.length-1].nationalID , now);
                return true;
            }
        }
        laurated = true;
    }
    
    function addCertificate (
        address _studentWallet,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Student memory s = Student( _studentWallet, _studentName, _nationalID, 0, "Aprovado", true, true, true);
        students.push(s);
        numberOfStudents ++;
        studentsLaurated ++;
        emit StudentCreated(students.length-1, _nationalID, _studentName);
        emit StudentLaurated(courseName, students[students.length-1].nationalID , now);
        return true;
    }
    
    function anonymizeCertificate(uint256 studentID) public returns(bool) 
    {
        require (msg.sender == schoolWallet);
        if (students[studentID].publicCertificate == true){
            students[studentID].publicCertificate = false;
            return true;
        }
        if (students[studentID].publicCertificate == false){
            students[studentID].publicCertificate = true;
            return true;
        }
    }
    
    function showDetails() public view returns (string memory, string memory, string memory, string memory, string memory, uint256, uint256, uint256) {
        return(courseName, coordinatorName, local, startDate, finishDate, amountOfHours, totalOfClasses, minimumAchievement);
    }
    
    function showStatus() public view returns (uint256, uint256, uint256, uint256 ) {
        require (msg.sender == schoolWallet);
        return(numberOfStudents, classesCreated, classesFinished, studentsLaurated);
    }
        
    function showStudent(uint256 studentID) public view returns (address, string memory, uint256, uint256, string memory, bool, bool, bool) {
        require (msg.sender == schoolWallet);
        Student memory s = students[studentID];
        return(s.studentWallet, s.studentName, s.nationalID, s.numberOfClasses, s.evaluation, s.active, s.laurated, s.publicCertificate);
    }
    
    
    function getStudentList() public view returns (string[] memory,uint256[] memory, address[] memory)
    {
        address[] memory studentWallet = new address[](students.length);
        string[] memory studentName = new string[](students.length);
        uint256[] memory nationalID = new uint256[](students.length);
        for (uint i = 0; i < students.length; i++) {
            Student storage student = students[i];
            studentWallet[i] = student.studentWallet;
            studentName[i] = student.studentName;
            nationalID[i] = student.nationalID;
        }
        return (studentName, nationalID, studentWallet);
    }
    
    function showClass(uint256 classID) public view returns (string memory, string memory, uint256, uint256, uint256, uint256, bool, bool) {
        Class memory c = classes[classID];
        return(c.className, c.professorName, c.classDate, c.classHours, c.password, c.studentsInClass, c.active, c.finished);
    }
    
    function getClassList() public view returns (string[] memory, string[] memory,uint256[] memory)
    {
        string[] memory className = new string[](classes.length);
        string[] memory professorName = new string[](classes.length);
        uint256[] memory classDate = new uint256[](classes.length);
        for (uint i = 0; i < classes.length; i++) {
            Class storage class = classes[i];
            className[i] = class.className;
            professorName[i] = class.professorName;
            classDate[i] = class.classDate;
        }
        return (className, professorName, classDate);
    }
    
    function showCertificate(uint256 studentID) public view returns (string memory, string memory, string memory, string memory, string memory, uint256, string memory) {
        Student memory s = students[studentID];
        require (students[studentID].publicCertificate == true);
        return(courseName, principalName, coordinatorName, startDate, finishDate, amountOfHours, s.studentName);
    }
    
    function getCertificateList() public view returns (string[] memory,uint256[] memory, address[] memory)
    {
        address[] memory studentWallet = new address[](students.length);
        string[] memory studentName = new string[](students.length);
        uint256[] memory nationalID = new uint256[](students.length);
        bool[] memory publicCertificate = new bool[] (students.length);
        for (uint i = 0; i < students.length; i++) {
            Student storage student = students[i];
            require( publicCertificate[i] == true);
            studentWallet[i] = student.studentWallet;
            studentName[i] = student.studentName;
            nationalID[i] = student.nationalID;
        }
        return (studentName, nationalID, studentWallet);
    }
}
