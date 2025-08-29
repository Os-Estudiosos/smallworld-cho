from database.tables import GenerateData
from config.database import *


def main():
    # Inicia a conexão
    dados = GenerateData(DB_NAME, DB_PATH, DB_OWNER, DB_HOST, DB_PASSWORD)
    dados.initialize()
    
    # Gera os dados
    dados.generate_itens(N_ITENS)
    dados.generate_clientes(N_CLIENTES, MAX_NUM_TELEFONE, PROB_ENFERMIDADE)
    dados.generate_ingredientes(N_INGREDIENTES)
    dados.generate_filiais(N_FILIAIS)
    dados.generate_fornecedores(N_FORNECEDORES)
    dados.generate_funcionarios(N_FUNCIONARIOS)
    dados.generate_pedido_pedidoitem(N_PEDIDOS, MAX_QTD)
    dados.generate_itemingrediente(MAX_INGREDIENTES)
    dados.generate_reservas(N_RESERVAS, MAX_MESAS)
    dados.generate_pedidos(N_PEDIDOS, MAX_QTD, MAX_ITENS)
    
    # Finaliza as operações
    dados.commit()
    dados.close()


if __name__ == "__main__":
    main()
