pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

contract Laurea {
    
    address laurea; 

    struct School {
        address schoolAddress;
        string name;
        string taxID;
        bool status;
    }
    
    struct CertificadoEscola {
        address schoolAddress;
        bytes32 hashCertificado;
    }
    
    struct CertificadoAluno {
        address schoolAddress;
        string codigoAluno;
        string codigoCurso;
        string nomeAluno;
        string nomeCurso;
        string dataInicioFim;
        uint8 cargaHoraria;
        bytes32 hashCertificado;
        bool exists;
    }
    
    mapping(address => School) public escolas;
    mapping(uint256 => CertificadoEscola) private listaCertificados;
    mapping(bytes32 => CertificadoEscola[]) private certificadosEscolas;
    mapping(bytes32 => CertificadoAluno) public certificados;
    
    event SchoolCreated(address indexed schoolAddress, string name, string taxID);
    event StudentLaurated(address indexed schoolAddress, string indexed codigoCurso, string indexed codigoAluno, bytes32 hashCertificado);
    
    constructor() public {
        laurea = msg.sender;
    }
    
    function addSchool(address _schoolAddress, string memory _name, string memory _taxID) public returns(bool) {
        require (msg.sender == laurea);
        School memory s = School(_schoolAddress, _name, _taxID, true);
        escolas[_schoolAddress] = s;
        emit SchoolCreated (s.schoolAddress, s.name, s.taxID);
        return true;
    }
    
    function editSchool(address _schoolAddress, string memory _name, string memory _taxID) public returns(bool) {
        require (msg.sender == laurea);
        School storage s = escolas[_schoolAddress];
        s.schoolAddress = _schoolAddress;
        s.name = _name;
        s.taxID = _taxID;
        return true;
    }
    
    function alterarEstadoEscola (address _schoolAddress) public returns(bool) {
        require (msg.sender == laurea);
        School storage s = escolas[_schoolAddress];
        if (s.status == true) {
            s.status = false;
            return true;
        } 
        else { 
            s.status = true;
            return true;
        }
    }
    
    function addCertificado(address _schoolAddress, string memory _codigoAluno, string memory _codigoCurso, string memory _nomeAluno, string memory _nomeCurso, string memory  _dataInicioFim,  uint8 _cargaHoraria) public returns (bytes32) {
        require (msg.sender == laurea);
        bytes32 hashCertificado = keccak256(abi.encodePacked(_schoolAddress,_codigoAluno, _codigoCurso));
        CertificadoAluno memory ca = CertificadoAluno(_schoolAddress, _codigoAluno, _codigoCurso, _nomeAluno, _nomeCurso, _dataInicioFim, _cargaHoraria, hashCertificado, true);
        certificados[hashCertificado] = ca;
        emit StudentLaurated (ca.schoolAddress, ca.codigoCurso, ca.codigoAluno, hashCertificado);
        return hashCertificado;
    }
    
    function alterarCertificado (bytes32 _hash, string memory _nomeAluno, string memory _nomeCurso, string memory  _dataInicioFim,  uint8 _cargaHoraria ) public returns(bool) {
        require (msg.sender == laurea);
        CertificadoAluno storage ca = certificados[_hash];
        ca.nomeAluno = _nomeAluno;
        ca.nomeCurso = _nomeCurso;
        ca.dataInicioFim = _dataInicioFim;
        ca.cargaHoraria = _cargaHoraria;
        emit StudentLaurated (ca.schoolAddress, ca.codigoCurso, ca.codigoAluno, _hash);
        return true;
    }
    
    function alterarEstadoCertificado (bytes32 _hash) public returns(bool) {
        require (msg.sender == laurea);
        CertificadoAluno storage ca = certificados[_hash];
        if (ca.exists == true) {
            ca.exists = false;
            return true;
        } 
        else { 
            ca.exists = true;
            return true;
        }
    }
    
    function buscarCertificadoEscola(address _schoolAddress) public view returns (bytes32[] memory policyAddress){
        
    }
    
    function buscarEscola(address _schoolAddress) public view returns (address, string memory, string memory) {
        School memory s = escolas[_schoolAddress];
        return (s.schoolAddress, s.name, s.taxID); 
    }
    
    function buscarCertificado(address _schoolAddress, string memory _codigoAluno, string memory _codigoCurso) public view returns (string memory, string memory, string memory, string memory, string memory, uint, bytes32) {
        CertificadoAluno memory ca = certificados[keccak256(abi.encodePacked(_schoolAddress, _codigoAluno, _codigoCurso))];
        require(ca.exists == true, "Certificado não localizado");
        return (ca.codigoAluno, ca.codigoCurso, ca.nomeAluno, ca.nomeCurso, ca.dataInicioFim, ca.cargaHoraria, ca.hashCertificado);
    }
    
    function buscarCertificadoHash(bytes32 _hash) public view returns (string memory, string memory, string memory, string memory, string memory, uint, bytes32) {
        CertificadoAluno memory ca = certificados[_hash];
        require(ca.exists == true, "Certificado não localizado");
        return (ca.codigoAluno, ca.codigoCurso, ca.nomeAluno, ca.nomeCurso, ca.dataInicioFim, ca.cargaHoraria, ca.hashCertificado);
    }
}
