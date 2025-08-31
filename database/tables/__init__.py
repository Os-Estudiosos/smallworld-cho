import random
from faker import Faker
from datetime import date
from database import Connection


class GenerateData(Connection):
    
    # Super init com a classe de conexão
    def __init__(self, db_name, path, user, host, password, port):
        super().__init__(db_name, path, user, host, password, port)
        self.fake = Faker("pt_BR")
        self.tipos_sangue = ["A", "B", "AB", "O"]
        self.categorias = ["Prato Padrão", "Prato Especial", "Bebida"]

    # Função auxiliar para gerar um cpf aleatório (sem verificar as regras do cpf)
    def gerar_cpf(self):
        return str("".join([str(random.randint(0,9)) for _ in range(11)]))
    
    # Função auxiliar para gerar um cnpj aleatório (sem verificar as regras do cnpj)
    def gerar_cnpj(self):
        return str("".join([str(random.randint(0,9)) for _ in range(14)]))
    
    # Função auxiliar para gerar um telefone aleatório (sem verificar as regras do telefone)
    def gerar_telefone(self):
        return str("".join([str(random.randint(0,9)) for _ in range(9)]))
    
    # Função auxiliar para gerar uma doença aleatória
    def gerar_doenca_falsa(self):
        prefixos = [
            "neuro", "cardio", "hepato", "dermato", "gastro",
            "osteo", "pneumo", "nefr", "psico", "oto", "lipo", "angio"
        ]
        raizes = [
            "mio", "encefal", "bronqu", "vascul", "articul",
            "hemat", "ot", "neur", "gastr", "cut", "retin"
        ]
        sufixos = [
            "ite", "ose", "oma", "emia", "ite crônica", "opatia", "algia", "plasia"
        ]
        return str(random.choice(prefixos) + random.choice(raizes) + random.choice(sufixos))
    
    # Função para gerar um nome de um prato aleatório
    def gerar_prato(self):
        adjetivos = [
            "Delicioso", "Crocante", "Apimentado", "Defumado", "Saboroso", 
            "Exótico", "Cremoso", "Tradicional", "Recheado", "Especial"
        ]
        preparos = [
            "Risoto", "Sopa", "Assado", "Estufado", "Tartar", 
            "Moqueca", "Grelhado", "Ensopado", "Feijoada", "Carpaccio"
        ]
        return str(random.choice(adjetivos) + " " + random.choice(preparos))

    # Função para popular as tabelas ITENS, PRATOPADRAO, PRATOESPECIAL e BEBIDA
    def generate_itens(self, num_itens):
        self.num_itens = num_itens
        for i in range(1, num_itens+1): 
            nome = self.gerar_prato()
            categoria = random.choice(self.categorias)
            sangue = random.choice(self.tipos_sangue)
            enfermidade = self.gerar_doenca_falsa()
            preco = round(random.uniform(5, 80), 2)
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Itens (ItemID, ItemNome, ItemCategoria, ItemPrecoVenda)
                VALUES (%s, %s, %s, %s)
            """, (i, nome, categoria, preco))
            self.commit()
            if categoria == "Prato Padrão":
                with self.conn.cursor() as cur:
                    cur.execute("""
                    INSERT INTO PratoPadrao (PratoTipoSang, ItemID)
                    VALUES (%s, %s)
                """, (sangue, i))
                self.commit()
            elif categoria == "Prato Especial":
                with self.conn.cursor() as cur:
                    cur.execute("""
                    INSERT INTO PratoEspecial (PratoEnfermidade, ItemID)
                    VALUES (%s, %s)
                """, (enfermidade, i))
                self.commit()
            else:
                with self.conn.cursor() as cur:
                    cur.execute("""
                    INSERT INTO Bebida (BebTipoSangue, ItemID)
                    VALUES (%s, %s)
                """, (sangue, i))
                self.commit()
        self.commit()
        
    # Função para popular as tabelas CLIENTES, CLIENTECLIENTETELEFONE CLIENTECLIENTEENFERMIDADE
    def generate_clientes(self, num_clientes, max_num_telefone, prob_enfermidade):
        self.cliente_cpf_nome = []
        self.cliente_cpf = []
        for _ in range(num_clientes):
            nome = self.fake.first_name()
            sobrenome = self.fake.last_name()
            sangue = random.choice(self.tipos_sangue)
            rua = self.fake.street_address()
            bairro = self.fake.bairro()
            municipio = self.fake.city()
            estado = self.fake.estado_sigla()
            cpf = self.gerar_cpf()
            self.cliente_cpf_nome.append((cpf, nome))
            self.cliente_cpf.append(cpf)
            nascimento = self.fake.date_of_birth(minimum_age=18, maximum_age=80)
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Clientes (ClienteNome, ClienteSobrenome, ClienteTipoSang,
                                    ClienteRua, ClienteBairro, ClienteMunicipio, ClienteEstado,
                                    ClienteCPF, ClienteDataNasc)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """, (nome, sobrenome, sangue, rua, bairro, municipio, estado, cpf, nascimento))
            self.commit()
            for _ in range(random.randint(1, max_num_telefone)):
                telefone = self.gerar_telefone()
                with self.conn.cursor() as cur:
                    cur.execute("""
                    INSERT INTO ClienteClienteTelefone (ClienteTelefone, ClienteCPF)
                    VALUES (%s,%s)
                """, (telefone, cpf))
            self.commit()
            if random.random() < prob_enfermidade:
                cliente_enfermidade = self.gerar_doenca_falsa()
                with self.conn.cursor() as cur:
                    cur.execute("""
                    INSERT INTO ClienteClienteEnfermidade (ClienteEnfermidade, ClienteCPF)
                    VALUES (%s,%s)
                """, (cliente_enfermidade, cpf))
            self.commit()
        self.commit()
        
    # Função para popular a tabela INGREDIENTES
    def generate_ingredientes(self, num_ingredientes):
        self.num_ingredientes = num_ingredientes
        for i in range(1, num_ingredientes+1): 
            nome = self.fake.word().capitalize()
            preco = round(random.uniform(1, 30), 2)
            cal = random.randint(1, 1000)
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Ingredientes (IngredNome, IngredID, IngredPrecoCompra, IngredCal)
                VALUES (%s, %s, %s, %s)
            """, (nome, i, preco, cal))
            self.commit()
        self.commit()

    # Função para popular a tabela FILIAIS
    def generate_filiais(self, num_filiais):
        self.num_filiais = num_filiais
        for i in range(1, num_filiais+1):
            rua = self.fake.street_address()
            bairro = self.fake.bairro()
            cidade = self.fake.city()
            estado = self.fake.estado_sigla()
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Filiais (FilialID, FilialRua, FilialBairro, FilialMunicipio, FilialEstado)
                VALUES (%s,%s,%s,%s,%s)
            """, (i, rua, bairro, cidade, estado))
            self.commit()
        self.commit()
        
    # Função para popular a tabela FORNECEDORES    
    def generate_fornecedores(self, num_fornecedores):
        self.fornecedores_cnpjs = []
        for _ in range(num_fornecedores):
            fornecedor_cnpj = self.gerar_cnpj()
            fornecedor_nome = self.fake.name()
            fornecedor_regiao = self.fake.neighborhood()
            self.fornecedores_cnpjs.append(fornecedor_cnpj)
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Fornecedores (FornecedorCNPJ, FornecedorNome, FornecedorRegiao)
                VALUES (%s,%s,%s)
            """, (fornecedor_cnpj, fornecedor_nome, fornecedor_regiao))
            self.commit()
        self.commit()
        
    # Função para popular a tabelaS FUNCIONARIOS e FUNCIONARIOFUNCTELEFONE
    def generate_funcionarios(self, num_funcionarios):
        for _ in range(num_funcionarios):
            cargos = ["Chef", "Administrador", "Atendente"]
            cargo = str(random.choice(cargos))
            if cargo == "Chef":
                salario = round(random.uniform(6000, 12000), 2)
            elif cargo == "Administrador":
                salario = round(random.uniform(8000, 18000), 2)
            else:
                salario = round(random.uniform(1500, 4000), 2)
            nascimento = self.fake.date_of_birth(minimum_age=20, maximum_age=60)
            nome = self.fake.name()
            cpf = self.gerar_cpf()
            filial = random.randint(1, self.num_filiais)
            telefone = self.gerar_telefone()
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Funcionarios (FuncCargo, FuncSalario, FuncDataNasc, FuncNome, FuncCPF, FilialID)
                VALUES (%s,%s,%s,%s,%s,%s)
            """, (cargo, salario, nascimento, nome, cpf, filial))
            self.commit()
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO FuncionarioFuncTelefone (FuncTelefone, FuncCPF)
                VALUES (%s,%s)
            """, (telefone, cpf))
            self.commit()
        self.commit()
        
    # Função para popular as tabelas PEDIDOS e PEDIDOPEDIDOITEM
    def generate_pedido_pedidoitem(self, num_pedidos, max_qtd):
        for pedido_id in range(1, num_pedidos+1):
            cliente_cpf = str(random.choice(self.cliente_cpf))           
            filial = random.randint(1, self.num_filiais)
            data_pedido = self.fake.date_between(start_date="-3y", end_date="today")
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Pedidos (PedidoData, PedidoID, ClienteCPF, FilialID)
                VALUES (%s,%s,%s,%s)
            """, (data_pedido, pedido_id, cliente_cpf, filial))
            item_id = random.randint(1, self.num_itens)
            qtd = random.randint(1, max_qtd)
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO PedidoItem (Quantidade, PedidoID, ItemID, FilialID)
                VALUES (%s,%s,%s)
            """, (qtd, pedido_id, item_id, filial))
            self.commit()
        self.commit()
            
    # Função para popular a tabela ITEMINGREDIENTE
    def generate_itemingrediente(self, max_ingredientes):
        for i in range(1, self.num_itens + 1):
            ingredientes = random.randint(3, max_ingredientes)
            for _ in range(ingredientes):
                ingrediente_id = random.randint(1, self.num_ingredientes)
                fornecedor_cnpj = str(random.choice(self.fornecedores_cnpjs))
                with self.conn.cursor() as cur:
                    cur.execute("""
                INSERT INTO ItemIngrediente (IngredID, ItemID, FornecedorCNPJ)
                VALUES (%s,%s,%s)
            """, (ingrediente_id, i, fornecedor_cnpj))
                self.commit()
            self.commit()
        self.commit()

    # Função para popular a tabela RESERVAS
    def generate_reservas(self, num_reservas, max_mesas):
        self.reserva_datas = []
        for i in range(1, num_reservas + 1):
            data = self.fake.date_between(start_date="-3y", end_date="today")
            filial = random.randint(1, self.num_filiais)
            mesa = random.randint(1, max_mesas)
            cpf, nome = random.choice(self.cliente_cpf_nome)
            cpf = str(cpf)
            nome = str(nome)
            self.reserva_datas.append(data)
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Reservas (ReservaID, ReservaData, FilialID, NumeroMesa, ClienteCPF, ClienteNome)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (i, data, filial, mesa, cpf, nome))
            self.commit()
        self.commit()
        
    # Função para popular as tabelas PEDIDOS e PEDIDOITEM
    def generate_pedidos(self, num_pedidos, max_qtd, max_itens):
        for i in range(num_pedidos):
            data = random.choice(self.reserva_datas)
            cpf = str(random.choice(self.cliente_cpf))
            filial = random.randint(1, self.num_filiais)
            with self.conn.cursor() as cur:
                cur.execute("""
                INSERT INTO Pedidos (PedidoData, PedidoID, ClienteCPF, FilialID)
                VALUES (%s, %s, %s, %s)
            """, (data, i, cpf, filial))
            self.commit()
            itens = random.randint(1, max_itens)            
            for _ in range(itens):
                item_id = random.randint(1, self.num_itens)
                qtd = random.randint(1, max_qtd)
                with self.conn.cursor() as cur:
                    cur.execute("""
                INSERT INTO PedidoItem (Quantidade, PedidoID, ItemID, FilialID)
                VALUES (%s, %s, %s, %s)
            """, (qtd, i, item_id, filial))
            self.commit()
        self.commit()