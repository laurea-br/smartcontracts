pragma solidity 0.5.12;

contract Laurea {
    
    address laurea; 

    struct School {
        string name;
        uint taxID;
        string principalName;
        address schoolAddress1;
        address schoolAddress2;
        address schoolAddress3;
    }
    
    struct CertificadoAluno {
        uint cpf;
        string codigoCurso;
        string nomeAluno;
        string nomeCurso;
        string dataInicio;
        string dataFinal;
        uint cargaHoraria;
        bool exists;
    }
    
    School public school;
    mapping(bytes32 => CertificadoAluno) public certificados;
    
    event StudentLaurated(uint indexed cpf, string indexed codigoCurso, bytes32 hashCertificado);
    
    constructor(string memory _name, 
        uint _taxID, 
        string memory _principalName, 
        address _schoolAddress1, 
        address _schoolAddress2, 
        address _schoolAddress3
    ) 
    public 
    {
        laurea = msg.sender;
        school = School(_name, _taxID, _principalName, _schoolAddress1, _schoolAddress2, _schoolAddress3);
    }
    
    function addCertificado(
        uint _cpf, 
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
        CertificadoAluno memory ca = CertificadoAluno(_cpf, _codigoCurso, _nomeAluno, _nomeCurso, _dataInicio, _dataFinal, _cargaHoraria, true);
        bytes32 hashCertificado = keccak256(abi.encodePacked(_cpf, _codigoCurso));
        certificados[hashCertificado] = ca;
        emit StudentLaurated (ca.cpf,ca.codigoCurso, hashCertificado);
        return hashCertificado;
    }
    
    function alterarEstadoCertificado (uint _cpf, string memory _codigoCurso) public returns(bool) {
        CertificadoAluno memory ca = certificados[keccak256(abi.encodePacked(_cpf, _codigoCurso))];
        if (ca.exists == true) {
            ca.exists = false;
            return (true);
        } 
        else { 
            ca.exists = true;
            return (true);
        }
    }
    
    function buscarCertificado(uint _cpf, string memory _codigoCurso)
        public
        view
        returns (uint, string memory, string memory, string memory, string memory, string memory, uint)
    {
        CertificadoAluno memory ca = certificados[keccak256(abi.encodePacked(_cpf, _codigoCurso))];
        require(ca.exists, "Certificado não localizado");
        return (ca.cpf, ca.codigoCurso, ca.nomeAluno, ca.nomeCurso, ca.dataInicio, ca.dataFinal, ca.cargaHoraria);
    }
}
