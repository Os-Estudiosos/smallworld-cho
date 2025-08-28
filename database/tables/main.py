from tables import GenerateData


def main():
    # Inicia a conexão
    dados = GenerateData()
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
