
import os
import pymssql
from getpass import getpass

# Solicita a senha do SQL Server sem exibi-la no terminal
senha = getpass("Senha do usuario sa: ")

# Abre uma conexao com o banco HospitalDB
conexao = pymssql.connect(
    server="127.0.0.1",
    port=1433,
    user="sa",
    password=senha,
    database="HospitalDB"
)

try:
    # Cria um cursor para executar comandos SQL
    cursor = conexao.cursor()

    # Executa uma consulta no banco
    cursor.execute("SELECT nome FROM Paciente")

    # Recupera todos os resultados
    pacientes = cursor.fetchall()

    # Mostra os resultados no terminal
    for paciente in pacientes:
        print(paciente[0])

finally:
    # Fecha a conexao com o banco
    conexao.close()
