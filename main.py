import random
from database.tables import GenerateData
from config.database import *


def main():
    locales = random.choices(list(FAKER_LOCALES.keys()), k=N_PAISES)

    pedido_id = 0
    item_id = 0

    # Inicia a conexão
    for locale in locales:
        print(item_id)
        print(pedido_id)
        print(FAKER_LOCALES[locale])
        dados = GenerateData(locale, DB_NAME, DB_PATH, DB_USER, DB_HOST, DB_PASSWORD, DB_PORT)
        dados.initialize()
        dados.get_country_id(FAKER_LOCALES[locale])
        
        # Gera os dados
        item_id = dados.generate_Menu(N_ITENS, item_id)
        dados.generate_clientes(N_CLIENTES, MAX_NUM_TELEFONE, PROB_ENFERMIDADE)
        print("Clientes Inseridos")
        dados.generate_ingredientes(N_INGREDIENTES)
        print("Ingredientes Inseridos")
        dados.generate_filiais(N_FILIAIS)
        print("Filiais Inseridos")
        dados.generate_fornecedores(N_FORNECEDORES)
        print("Fornecedores Inseridos")
        dados.generate_funcionarios(N_FUNCIONARIOS)
        print("Funcionarios Inseridos")
        dados.generate_itemingrediente(MAX_INGREDIENTES)
        print("Itens e Ingredientes Conjuntos Inseridos")
        dados.generate_reservas(N_RESERVAS, MAX_MESAS)
        print("Reservas Inseridss")
        pedido_id = dados.generate_pedidos(N_PEDIDOS, MAX_QTD, MAX_ITENS, pedido_id)
        print("Pedidos Inseridos")
        
        # Gero um arquivo .xlsx
        dados.generate_excel()
        
        # Finaliza as operações
        dados.commit()
        dados.close()
    print("Dados gerados com sucesso!")


if __name__ == "__main__":
    main()