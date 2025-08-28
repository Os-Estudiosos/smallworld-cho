from tables import GenerateData
from config.database import *


def main():
    # Inicia a conexão
    dados = GenerateData(DB_NAME, DB_PATH, DB_OWNER, DB_HOST, DB_PASSWORD)
    dados.initialize()
    
    # Gera os dados
    dados.generate_clientes()
    dados.generate_filial()
    dados.generate_funcionarios()
    dados.generate_ingredientes()
    dados.generate_item()
    dados.generate_pedido_pedidoitem()
    dados.generate_telefones_enfermidades()
    
    # Finaliza as operações
    dados.commit()
    dados.close()


if __name__ == "__main__":
    main()
