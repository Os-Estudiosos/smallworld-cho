import random
from faker import Faker
from datetime import date
from database import Connection


class GenerateData(Connection):
    
    # Super init com a classe de conexão
    def __init__(self, db_name, path, user, host, password):
        super().__init__(db_name, path, user, host, password)
        self.faker = Faker("pt_BR")
    
    # Função auxiliar para gerar um cpf aleatório (sem verificar as regras do cpf)
    def gerar_cpf():
        return str("".join([str(random.randint(0,9)) for _ in range(11)]))
    
    # Função auxiliar para gerar um cnpj aleatório (sem verificar as regras do cnpj)
    def gerar_cnpj():
        return str("".join([str(random.randint(0,9)) for _ in range(14)]))

    # Função para popular a tabela ITEM
    def generate_item(self, n):
        for i in range(1, n+1): 
            categorias = ["Prato Padrão", "Prato Especial", "Bebida"]
            nome = self.fake.word().capitalize() + " " + self.fake.word().capitalize()
            categoria = random.choice(categorias)
            preco = round(random.uniform(5, 80), 2)
            Connection.cur.execute("""
                INSERT INTO Item (ItemID, ItemNome, ItemCategoria, ItemPrecoVenda)
                VALUES (%s, %s, %s, %s)
            """, (i, nome, categoria, preco))
        self.commit()

    # Função para popular a tabela CLIENTES
    def generate_clientes(self, n):
        for i in range(1, n+1):
            nome = self.fake.first_name()
            sobrenome = self.fake.last_name()
            tipos_sangue = ["A", "B", "AB", "O"]
            sangue = random.choice(tipos_sangue)
            rua = self.fake.street_address()
            bairro = self.fake.bairro()
            cidade = self.fake.city()
            estado = self.fake.estado_sigla()
            cpf = self.gerar_cpf()
            nascimento = self.fake.date_of_birth(minimum_age=18, maximum_age=80)
            Connection.cur.execute("""
                INSERT INTO Cliente (ClienteID, ClienteNome, ClienteSobrenome, ClienteTipoSang,
                                    ClienteRua, ClienteBairro, ClienteMunicipio, ClienteEstado,
                                    ClienteCPF, ClienteDataNasc)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """, (i, nome, sobrenome, sangue, rua, bairro, cidade, estado, cpf, nascimento))
        self.commit()

    # Função para popular a tabela INGREDIENTES
    def generate_ingredientes(self, n):
        for i in range(1, n+1): 
            nome = self.fake.word().capitalize()
            preco = round(random.uniform(1, 30), 2)
            cal = random.randint(10, 500)
            Connection.cur.execute("""
                INSERT INTO Ingredientes (IngredNome, IngredID, IngredPrecoCompra, IngredCal)
                VALUES (%s, %s, %s, %s)
            """, (nome, i, preco, cal))
        self.commit()

    # Função para popular a tabela FILIAL
    def generate_filial(self, n):
        for i in range(1, n+1):
            rua = self.fake.street_address()
            bairro = self.fake.bairro()
            cidade = self.fake.city()
            estado = self.fake.estado_sigla()
            Connection.cur.execute("""
                INSERT INTO Filial (FilialID, FilialRua, FilialBairro, FilialMunicipio, FilialEstado)
                VALUES (%s,%s,%s,%s,%s)
            """, (i, rua, bairro, cidade, estado))
        self.commit()

    # Função para popular a tabela FUNCIONÁRIOS
    def generate_funcionarios(self, n):
        for i in range(1, n+1):
            cargos = ["Cozinheiro", "Garçom", "Gerente", "Atendente"]
            cargo = random.choice(cargos)
            salario = round(random.uniform(1500, 6000), 2)
            nascimento = self.fake.date_of_birth(minimum_age=20, maximum_age=60)
            nome = self.fake.name()
            cpf = self.gerar_cpf()
            filial = random.randint(1, 5)
            Connection.cur.execute("""
                INSERT INTO Funcionario (FuncID, FuncCargo, FuncSalario, FuncDataNasc, FuncNome, FuncCPF, FilialID)
                VALUES (%s,%s,%s,%s,%s,%s,%s)
            """, (i, cargo, salario, nascimento, nome, cpf, filial))
        self.commit()

    # Função para popular as tabelas PEDIDO e PEDIDOITEM
    def generate_pedido_pedidoitem(self, n, m):
        pedido_id = 1
        for cliente_id in range(1, n+1):
            for _ in range(random.randint(1, m)):
                filial = random.randint(1, 5)
                data_pedido = self.fake.date_between(start_date="-1y", end_date="today")
                Connection.cur.execute("""
                    INSERT INTO Pedido (PedidoData, PedidoID, ClienteID, FilialID)
                    VALUES (%s,%s,%s,%s)
                """, (data_pedido, pedido_id, cliente_id, filial))
                for _ in range(random.randint(1, 5)):
                    item_id = random.randint(1, 50)
                    qtd = random.randint(1, 3)
                    Connection.cur.execute("""
                        INSERT INTO PedidoItem (Quantidade, PedidoID, ItemID)
                        VALUES (%s,%s,%s)
                    """, (qtd, pedido_id, item_id))
                pedido_id += 1
        self.commit()

    # Função para popular as tabelas CLIENTECLIENTETELEFONE e CLIENTECLIENTEENFERMIDADE
    def generate_telefones_enfermidades(self, n, m, p):
        for cliente_id in range(1, n+1):
            for _ in range(random.randint(1, 2)):
                telefone = int(self.fake.msisdn()[:11])
                Connection.cur.execute("""
                    INSERT INTO ClienteClienteTelefone (ClienteTelefone, ClienteID)
                    VALUES (%s,%s)
                """, (telefone, cliente_id))
            if random.random() < p:
                enfermidade_id = random.randint(1, m)
                Connection.cur.execute("""
                    INSERT INTO ClienteClienteEnfermidade (ClienteEnfermidade, ClienteID)
                    VALUES (%s,%s)
                """, (enfermidade_id, cliente_id))
        self.commit()
