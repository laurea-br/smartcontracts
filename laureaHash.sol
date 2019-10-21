pragma solidity 0.5.12;

contract Laurea {

    struct School {
        string name;
        string taxID;
        address schoolAddress;
    }
    
    struct CertificadoAluno {
        string cpf;
        string codigoCurso;
        string nomeAluno;
        string nomeCurso;
        string dataInicio;
        string dataFinal;
        uint cargaHoraria;
        bytes32 hashCertificado;
        bool exists;
    }
    
    School public school;
    mapping(bytes32 => CertificadoAluno) public certificados;
    
    event StudentLaurated(string indexed codigoCurso, string indexed cpf, string nomeCurso, string nomeAluno, bytes32 hashCertificado);
    
    constructor(
        string memory _name, 
        string memory _taxID, 
        address _schoolAddress
    ) 
    public 
    {
        school = School(_name, _taxID, _schoolAddress);
    }
    
    function editSchool(
        string memory _name, 
        string memory _taxID, 
        address _schoolAddress
        ) public {
        school = School(_name, _taxID, _schoolAddress);
    }
    
    function addCertificado(
        string memory _cpf, 
        string memory _codigoCurso, 
        string memory _nomeAluno, 
        string memory _nomeCurso,
        string memory  _dataInicio,  
        string memory  _dataFinal,
        uint _cargaHoraria
        )
        public
        returns (bytes32)
    {
        bytes32 hashCertificado = keccak256(abi.encodePacked(_cpf, _codigoCurso));
        CertificadoAluno memory ca = CertificadoAluno(_cpf, _codigoCurso, _nomeAluno, _nomeCurso, _dataInicio, _dataFinal, _cargaHoraria, hashCertificado, true);
        certificados[hashCertificado] = ca;
        emit StudentLaurated (ca.codigoCurso, ca.cpf, ca.nomeAluno, ca.nomeCurso, hashCertificado);
        return hashCertificado;
    }
    
    function alterarEstadoCertificado (string memory _cpf, string memory _codigoCurso) public returns(bool) {
        CertificadoAluno storage ca = certificados[keccak256(abi.encodePacked(_cpf, _codigoCurso))];
        if (ca.exists == true) {
            ca.exists = false;
            return (true);
        } 
        else { 
            ca.exists = true;
            return (true);
        }
    }
    
    function buscarCertificado(string memory _cpf, string memory _codigoCurso)
        public
        view
        returns (string memory, string memory, string memory, string memory, string memory, string memory, uint, bytes32)
    {
        CertificadoAluno memory ca = certificados[keccak256(abi.encodePacked(_cpf, _codigoCurso))];
        require(ca.exists, "Certificado não localizado");
        return (ca.cpf, ca.codigoCurso, ca.nomeAluno, ca.nomeCurso, ca.dataInicio, ca.dataFinal, ca.cargaHoraria, ca.hashCertificado);
    }
}
