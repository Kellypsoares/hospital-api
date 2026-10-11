
import os
import pymssql
from fastapi import FastAPI, HTTPException

app = FastAPI()


def conectar_banco():
    try:
        return pymssql.connect(
            server="127.0.0.1",
            port=1433,
            user="sa",
            password=os.environ["HOSPITAL_DB_PASSWORD"],
            database="HospitalDB"
        )
    except pymssql.Error:
        raise HTTPException(
            status_code=503,
            detail="Banco de dados indisponivel"
        )



@app.get("/")
def inicio():
    return {"mensagem": "API do Hospital funcionando!"}


@app.get("/pacientes")
def listar_pacientes():

    conexao = conectar_banco()

    try:
        cursor = conexao.cursor(as_dict=True)

        cursor.execute("""
            SELECT id_paciente, nome, data_nascimento
            FROM Paciente
        """)

        pacientes = cursor.fetchall()

        return pacientes

    finally:
        conexao.close()

@app.get("/atendimentos")
def listar_atendimentos():

    conexao = conectar_banco()

    try:
        cursor = conexao.cursor(as_dict=True)

        cursor.execute("""
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
                ON a.id_medico = m.id_medico
        """)

        atendimentos = cursor.fetchall()

        return atendimentos

    finally:
        conexao.close()
