-- 1. Selecionar o banco
USE HospitalDB;
GO

-- 2. Criar a tabela Paciente
CREATE TABLE Paciente (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL
);
GO

-- 3. Consultar a tabela
SELECT * FROM Paciente;

-- 4. Inserir pacientes
INSERT INTO Paciente (nome, cpf, data_nascimento)
VALUES
    ('Ana Souza', '01234567890', '1998-04-15'),
    ('Carlos Lima', '98765432100', '1985-09-22'),
    ('Mariana Costa', '12345678901', '2001-07-10');

-- 5. Consultar os pacientes cadastrados
SELECT * FROM Paciente;


-- Criar tabela de médicos
CREATE TABLE Medico (
    id_medico INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(100) NOT NULL
);
GO

-- Inserir médicos fictícios
INSERT INTO Medico (nome, crm, especialidade)
VALUES
    ('Roberto Almeida', 'RJ-123456', 'Cardiologia'),
    ('Fernanda Oliveira', 'RJ-234567', 'Clínica Geral'),
    ('Paulo Mendes', 'RJ-345678', 'Ortopedia');

-- Consultar médicos cadastrados
SELECT * FROM Medico;


-- Criar tabela de atendimentos
CREATE TABLE Atendimento (
    id_atendimento INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_atendimento DATETIME2 NOT NULL,
    status VARCHAR(30) NOT NULL,

    CONSTRAINT FK_Atendimento_Paciente
        FOREIGN KEY (id_paciente)
        REFERENCES Paciente(id_paciente),

    CONSTRAINT FK_Atendimento_Medico
        FOREIGN KEY (id_medico)
        REFERENCES Medico(id_medico)
);
GO

-- Inserir atendimentos fictícios
INSERT INTO Atendimento
    (id_paciente, id_medico, data_atendimento, status)
VALUES
    (1, 1, '2026-10-10 09:30:00', 'Concluido'),
    (2, 2, '2026-10-10 11:00:00', 'Concluido'),
    (3, 3, '2026-10-11 14:00:00', 'Agendado');

-- Consultar atendimentos
SELECT * FROM Atendimento;

-- Consultar atendimentos com nomes dos pacientes e médicos
SELECT
    a.id_atendimento,
    p.nome AS paciente,
    m.nome AS medico,
    m.especialidade,
    a.data_atendimento,
    a.status
FROM Atendimento a
INNER JOIN Paciente p
    ON a.id_paciente = p.id_paciente
INNER JOIN Medico m
    ON a.id_medico = m.id_medico;


-- Criar tabela de medicamentos
CREATE TABLE Medicamento (
    id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    principio_ativo VARCHAR(100) NOT NULL,
    apresentacao VARCHAR(100) NOT NULL
);
GO

-- Inserir medicamentos fictícios para teste
INSERT INTO Medicamento (nome, principio_ativo, apresentacao)
VALUES
    ('Paracetamol 500 mg', 'Paracetamol', 'Comprimido 500 mg'),
    ('Dipirona 500 mg', 'Dipirona monoidratada', 'Comprimido 500 mg'),
    ('Ibuprofeno 400 mg', 'Ibuprofeno', 'Comprimido 400 mg');

-- Consultar medicamentos cadastrados
SELECT * FROM Medicamento;

-- Criar tabela de prescrições
CREATE TABLE Prescricao (
    id_prescricao INT IDENTITY(1,1) PRIMARY KEY,
    id_atendimento INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosagem VARCHAR(100) NOT NULL,
    frequencia VARCHAR(100) NOT NULL,
    duracao VARCHAR(100) NOT NULL,

    CONSTRAINT FK_Prescricao_Atendimento
        FOREIGN KEY (id_atendimento)
        REFERENCES Atendimento(id_atendimento),

    CONSTRAINT FK_Prescricao_Medicamento
        FOREIGN KEY (id_medicamento)
        REFERENCES Medicamento(id_medicamento)
);
GO

-- Inserir prescrições fictícias para teste
INSERT INTO Prescricao
    (id_atendimento, id_medicamento, dosagem, frequencia, duracao)
VALUES
    (1, 1, '500 mg', 'A cada 8 horas', '3 dias'),
    (2, 2, '500 mg', 'A cada 6 horas', '2 dias');

-- Consultar prescrições cadastradas
SELECT * FROM Prescricao;

USE HospitalDB;
GO

SELECT
    TABLE_NAME AS NomeTabela
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- PROJETO: SISTEMA HOSPITALAR
-- Banco de Dados: HospitalDB
-- SGBD: Microsoft SQL Server 2022
-- Ambiente: macOS + Docker + Visual Studio Code

--
-- RESUMO DO QUE FOI FEITO
--
-- Para desenvolver o banco de dados do sistema hospitalar,
-- utilizei o Docker para executar o SQL Server 2022 no meu
-- Mac, ja que o SQL Server nao possui instalacao nativa
-- para macOS. Primeiro, baixei a imagem do SQL Server e
-- criei um container chamado hospital-sql, configurando
-- a porta 1433 para permitir conexoes locais.
--
-- Depois, instalei a extensao SQL Server (mssql) no VS Code.
-- Essa extensao funciona como um cliente de banco de dados:
-- ela permite que o VS Code se conecte ao SQL Server, envie
-- comandos SQL e visualize os resultados das consultas.
--
-- A extensao nao depende diretamente do Docker. O Docker
-- e responsavel por executar o container onde o SQL Server
-- esta rodando, enquanto a extensao se comunica com esse
-- servidor por meio de uma conexao de rede.
--
-- No nosso caso, essa conexao acontece pelo endereco
-- 127.0.0.1 e pela porta 1433, que foi disponibilizada
-- pelo Docker. Assim, quando executo uma consulta no VS Code,
-- a extensao envia o comando ao SQL Server dentro do container.
-- O SQL Server executa a consulta e devolve os resultados
-- para serem exibidos no VS Code.
--
-- Com a conexao funcionando, criei o banco HospitalDB e
-- as tabelas de pacientes, medicos, atendimentos, medicamentos
-- e prescricoes. Tambem defini os relacionamentos entre
-- as tabelas, inseri dados ficticios e executei consultas
-- para verificar se os registros estavam sendo armazenados
-- e recuperados corretamente.
--
-- A proxima etapa sera desenvolver uma API REST em Python
-- para consultar os dados do HospitalDB e utilizar o Postman
-- para testar as requisicoes HTTP.
--
-- RESUMINDO A FUNCAO DE CADA FERRAMENTA:
--
-- Docker:
-- Executa o container onde esta rodando o SQL Server.
--
-- SQL Server:
-- Gerencia o banco HospitalDB, suas tabelas e seus dados.
--
-- VS Code:
-- Editor utilizado para escrever os comandos SQL.
--
-- Extensao SQL Server (mssql):
-- Conecta o VS Code ao SQL Server, envia as consultas
-- e apresenta os resultados.
--
-- API Python (proxima etapa):
-- Permitira consultar os dados do banco por requisicoes HTTP.
--
-- Postman (proxima etapa):
-- Sera utilizado para enviar requisicoes e testar a API.
--
-- FLUXO ATUAL:
--
-- VS Code + Extensao MSSQL
--           |
--           | Conexao: 127.0.0.1:1433
--           v
-- Docker (container hospital-sql)
--           |
--           v
-- SQL Server 2022
--           |
--           v
-- HospitalDB (tabelas e registros)
--