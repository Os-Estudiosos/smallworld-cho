import psycopg2
import random
from datetime import time

# Função para gerar horário aleatório entre 10:30 e 15:30
def horario_aleatorio():
    # Hora entre 10 e 15
    hora = random.randint(10, 15)
    
    # Minutos
    if hora == 10:
        minuto = random.randint(30, 59)  # de 10:30 a 10:59
    elif hora == 15:
        minuto = random.randint(0, 30)   # de 15:00 a 15:30
    else:
        minuto = random.randint(0, 59)   # entre 11:00 e 14:59
    
    segundo = random.randint(0, 59)
    return time(hora, minuto, segundo)

# Conexão com PostgreSQL
conn = psycopg2.connect(
    host="",
    database="",
    user="",
    password=""
)

cur = conn.cursor()

# Seleciona todos os pedidos
cur.execute("SELECT pedidoid FROM cho.pedidos;")
pedidos = cur.fetchall()

for pedido in pedidos:
    pid = pedido[0]
    hora = horario_aleatorio()
    # Atualiza a coluna horario com o valor gerado
    cur.execute(
        "UPDATE cho.pedidos SET horario = %s WHERE pedidoid = %s;",
        (hora, pid)
    )

# Confirma alterações
conn.commit()

# Fecha conexão
cur.close()
conn.close()

print(f"{len(pedidos)} linhas atualizadas com horários aleatórios.")

