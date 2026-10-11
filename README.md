# 🏥 Hospital Management API

**API REST para consulta de dados hospitalares utilizando Python, FastAPI e Microsoft SQL Server.**

Este projeto foi desenvolvido como atividade acadêmica de Banco de Dados, com o objetivo de aplicar conceitos de modelagem relacional, consultas SQL e integração entre uma aplicação Python e um banco de dados.

A aplicação permite consultar pacientes e atendimentos hospitalares por meio de endpoints REST, retornando informações em formato JSON.

## Tecnologias utilizadas

| Tecnologia | Finalidade |
|---|---|
| Python | Linguagem de programação da API |
| FastAPI | Framework para desenvolvimento dos endpoints REST |
| Uvicorn | Servidor HTTP para execução da aplicação |
| Microsoft SQL Server 2022 | Sistema gerenciador de banco de dados relacional |
| Docker | Execução do SQL Server em contêiner |
| pymssql | Conexão entre Python e SQL Server |
| Postman | Testes das requisições HTTP |
| Git e GitHub | Versionamento e hospedagem do código |

## Arquitetura da aplicação

A aplicação segue uma arquitetura simples, na qual um cliente HTTP envia uma requisição ao FastAPI, que executa uma consulta no SQL Server e devolve o resultado em JSON.

```text
              Cliente HTTP
            (Postman / Browser)
                    |
                    | GET /pacientes
                    | GET /atendimentos
                    v
              FastAPI (Python)
                 main.py
                    |
                    | pymssql
                    v
             Microsoft SQL Server
              (Docker Container)
                    |
                    v
                HospitalDB
                    |
          +---------+---------+
          |         |         |
       Paciente  Atendimento Medico
                    |
                Prescricao
                    |
                Medicamento
```

O Docker é utilizado para executar o SQL Server localmente, enquanto o FastAPI disponibiliza os dados por meio de requisições HTTP.

## Modelagem do banco de dados

O banco de dados `HospitalDB` contém cinco tabelas relacionadas:

| Tabela | Descrição |
|---|---|
| `Paciente` | Armazena os dados cadastrais dos pacientes |
| `Medico` | Armazena informações dos médicos e suas especialidades |
| `Atendimento` | Registra os atendimentos realizados e relaciona pacientes e médicos |
| `Medicamento` | Contém os medicamentos disponíveis |
| `Prescricao` | Relaciona medicamentos prescritos aos atendimentos |

### Relacionamentos

- Um paciente pode possuir vários atendimentos.
- Um médico pode realizar vários atendimentos.
- Um atendimento pode possuir várias prescrições.
- Um medicamento pode aparecer em várias prescrições.

Esses relacionamentos são implementados utilizando **chaves primárias (PK)** e **chaves estrangeiras (FK)**, garantindo a integridade referencial.

### Consultas com JOIN

Além de consultas simples, o projeto utiliza `INNER JOIN` para combinar informações de diferentes tabelas.

Exemplo utilizado no endpoint de atendimentos:

```sql
SELECT
    a.id_atendimento,
    p.nome AS paciente,
    m.nome AS medico,
    a.data_atendimento,
    a.status
FROM Atendimento AS a
INNER JOIN Paciente AS p
    ON a.id_paciente = p.id_paciente
INNER JOIN Medico AS m
    ON a.id_medico = m.id_medico;
```

Essa consulta permite retornar os nomes do paciente e do médico associados a cada atendimento.

## Endpoints disponíveis

A API disponibiliza três endpoints HTTP do tipo GET.

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/` | Verifica se a aplicação está funcionando |
| GET | `/pacientes` | Retorna os pacientes cadastrados |
| GET | `/atendimentos` | Retorna os atendimentos com informações de pacientes e médicos |

### GET /pacientes

**Requisição**

```http
GET http://127.0.0.1:8000/pacientes
```

**Exemplo de resposta**

```json
[
  {
    "id_paciente": 1,
    "nome": "Ana Souza",
    "data_nascimento": "1998-04-15"
  },
  {
    "id_paciente": 2,
    "nome": "Carlos Lima",
    "data_nascimento": "1985-09-22"
  },
  {
    "id_paciente": 3,
    "nome": "Mariana Costa",
    "data_nascimento": "2001-07-10"
  }
]
```

### GET /atendimentos

**Requisição**

```http
GET http://127.0.0.1:8000/atendimentos
```

**Exemplo de resposta**

```json
[
  {
    "id_atendimento": 1,
    "paciente": "Ana Souza",
    "medico": "Roberto Almeida",
    "data_atendimento": "2026-10-10T09:30:00",
    "status": "Concluido"
  }
]
```

Os exemplos utilizam dados fictícios cadastrados para demonstração.

## Como executar o projeto

### Pré-requisitos

- Python 3
- Docker Desktop
- Microsoft SQL Server 2022
- Git
- Um cliente SQL, como a extensão SQL Server (mssql) do VS Code

### 1. Clonar o repositório

```bash
git clone https://github.com/Kellypsoares/hospital-api.git
cd hospital-api
```

### 2. Configurar o banco de dados

Inicie uma instância local do SQL Server 2022, preferencialmente utilizando Docker, com a porta `1433` disponível em `127.0.0.1`.

Crie o banco de dados:

```sql
CREATE DATABASE HospitalDB;
GO
```

Execute o arquivo `hospital.sql` no SQL Server para criar as tabelas e inserir os registros de exemplo.

O script deve ser executado em um banco ainda não populado com essas tabelas.

### 3. Criar o ambiente virtual

```bash
cd api
python3 -m venv .venv
source .venv/bin/activate
```

### 4. Instalar as dependências

```bash
python -m pip install -r requirements.txt
```

### 5. Configurar a conexão

A API utiliza as seguintes configurações de conexão:

- Servidor: `127.0.0.1`
- Porta: `1433`
- Usuário: `sa`
- Banco: `HospitalDB`

A senha deve ser fornecida pela variável de ambiente `HOSPITAL_DB_PASSWORD`.

No macOS ou Linux:

```bash
export HOSPITAL_DB_PASSWORD="SUA_SENHA_LOCAL"
```

A senha utilizada deve corresponder à configurada na instância do SQL Server. Não inclua senhas reais no código ou no repositório.

### 6. Executar a API

```bash
python -m uvicorn main:app --reload
```

A aplicação ficará disponível em:

- API: http://127.0.0.1:8000
- Documentação Swagger: http://127.0.0.1:8000/docs

## Testes com Postman

Os endpoints foram testados utilizando o Postman, verificando o retorno das consultas SQL e o formato JSON das respostas.

Os testes realizados incluem:

- `GET /pacientes` — retorno dos pacientes cadastrados.
- `GET /atendimentos` — retorno dos atendimentos e dados relacionados.
- Validação do status HTTP `200 OK`.

O FastAPI também disponibiliza automaticamente uma interface interativa para explorar os endpoints por meio do Swagger UI.

## Estrutura do projeto

```text
hospital-api/
├── api/
│   ├── main.py
│   ├── requirements.txt
│   └── teste_conexao.py
├── hospital.sql
├── .gitignore
└── README.md
```
