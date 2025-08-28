from database.tables import GenerateData
from config.database import *


def main():
    # Inicia a conexão
    dados = GenerateData(DB_NAME, DB_PATH, DB_OWNER, DB_HOST, DB_PASSWORD)
    dados.initialize()
    
    # Gera os dados
    dados.generate_item(N_ITENS)
    dados.generate_clientes(N_CLIENTES)
    dados.generate_filial(N_FILIAIS)
    dados.generate_fornecedores(N_FORNECEDORES)
    dados.generate_ingredientes(N_INGREDIENTES)
    dados.generate_funcionarios(N_FUNCIONARIOS)
    
    # Finaliza as operações
    dados.commit()
    dados.close()


if __name__ == "__main__":
    main()
