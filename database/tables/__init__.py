import random
from faker import Faker
from datetime import timedelta, datetime
from database import Connection
from config.database import *
import pandas as pd


class GenerateData(Connection):
    
    # Super init com a classe de conexão
    def __init__(self, locale, db_name, path, user, host, password, port):
        super().__init__(db_name, path, user, host, password, port)
        self.pais_id = None
        self.fake = Faker(locale)
        self.tipos_sangue = ["A", "B", "AB", "O"]
        self.categorias = ["Prato Padrão", "Prato Especial", "Bebida"]
        self.tabelas =  [
                        "ItensMenu",
                        "PratoPadrao",
                        "PratoEspecial",
                        "Bebida",
                        "Clientes",
                        "ClienteClienteTelefone",
                        "ClienteClienteEnfermidade",
                        "Ingredientes",
                        "Filiais",
                        "Fornecedores",
                        "ItemMenuIngrediente",
                        "Funcionarios",
                        "FuncionarioFuncTelefone",
                        "Reservas",
                        "Pedidos",
                        "PedidoItemMenu"
                    ]
    
    # Funções auxiliares de endereço
    def get_rua(self):
        if hasattr(self.fake, "street_address"):
            return self.fake.street_address()
        if hasattr(self.fake, "street_name"):
            return self.fake.street_name()
        return f"{self.fake.word().title()} Street"


    def get_bairro(self):
        if hasattr(self.fake, "bairro"):                 # Brasil (faker-br)
            return self.fake.bairro()
        if hasattr(self.fake, "neighborhood"):           # EUA (alguns locais)
            return self.fake.neighborhood()
        # Universal fallback
        return f"District {self.fake.word().title()}"


    def get_municipio(self):
        if hasattr(self.fake, "city"):
            return self.fake.city()
        if hasattr(self.fake, "town"):
            return self.fake.town()
        return f"{self.fake.word().title()} City"


    def get_estado(self):
        if hasattr(self.fake, "estado_sigla"):           # Brasil
            return self.fake.estado_sigla()
        if hasattr(self.fake, "state_abbr"):             # EUA
            return self.fake.state_abbr()
        if hasattr(self.fake, "province_abbr"):
            return self.fake.province_abbr()
        if hasattr(self.fake, "state"):
            return self.fake.state()
        return self.fake.country_code()


    # Função auxiliar para pegar o ID do país pelo nome
    def get_country_id(self, country_name):
        with self.conn.cursor() as cur:
            cur.execute(
                "SELECT PaisID FROM cho.Pais WHERE PaisNome = %s",
                (country_name,)
            )
            row = cur.fetchone()
            self.pais_id = row[0] if row else None

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
    
    # Função para gerar horário aleatório entre low:30 e high:30
    def gerar_horario(self, low=10, high=15):
        if not (0 <= low < high <= 23):
            return "Intervalo inválido"
        inicio = datetime(2000, 1, 1, low, 30, 0)
        fim = datetime(2000, 1, 1, high, 30, 0)
        delta = int((fim - inicio).total_seconds())
        segundos_aleatorios = random.randint(0, delta)
        horario_resultado = inicio + timedelta(seconds=segundos_aleatorios)
        return horario_resultado.time()

    # Função para popular as tabelas Menu, PRATOPADRAO, PRATOESPECIAL e BEBIDA
    def generate_Menu(self, num_itens, last_item_id):
        self.num_itens = num_itens
        item_id = last_item_id
        for i in range(1, num_itens+1): 
            nome = self.gerar_prato()
            categoria = random.choice(self.categorias)
            sangue = random.choice(self.tipos_sangue)
            enfermidade = self.gerar_doenca_falsa()
            preco = round(random.uniform(5, 80), 2)
            with self.conn.cursor() as cur:
                cur.execute("INSERT INTO ItensMenu (ItemNome, ItemCategoria, ItemPrecoVenda) VALUES (%s, %s, %s)",
                            (nome, categoria, preco))
                item_id += 1
                if categoria == "Prato Padrão":
                    cur.execute("INSERT INTO PratoPadrao (PratoTipoSang, ItemID) VALUES (%s, %s)", 
                                (sangue, item_id))
                elif categoria == "Prato Especial":
                    cur.execute("INSERT INTO PratoEspecial (PratoEnfermidade, ItemID) VALUES (%s, %s)", 
                                (enfermidade, item_id))
                else:
                    cur.execute("INSERT INTO Bebida (BebTipoSangue, ItemID) VALUES (%s, %s)",
                                (sangue, item_id))
        self.commit()
        return item_id
        
    # Função para popular as tabelas CLIENTES, CLIENTECLIENTETELEFONE CLIENTECLIENTEENFERMIDADE
    def generate_clientes(self, num_clientes, max_num_telefone, prob_enfermidade):
        self.cliente_cpf_nome = []
        self.cliente_cpf = []
        for _ in range(num_clientes):
            nome = self.fake.first_name()
            sobrenome = self.fake.last_name()
            sangue = random.choice(self.tipos_sangue)
            rua = self.get_rua()
            bairro = self.get_bairro()
            municipio = self.get_municipio()
            estado = self.get_estado()
            cpf = self.gerar_cpf()
            self.cliente_cpf_nome.append((cpf, nome))
            self.cliente_cpf.append(cpf)
            nascimento = self.fake.date_of_birth(minimum_age=18, maximum_age=80)
            with self.conn.cursor() as cur:
                cur.execute("INSERT INTO Clientes (ClienteNome, ClienteSobrenome, ClienteTipoSang, ClienteRua, ClienteBairro, ClienteMunicipio, ClienteEstado, ClienteCPF, ClienteDataNasc) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (nome, sobrenome, sangue, rua, bairro, municipio, estado, cpf, nascimento))
            for _ in range(random.randint(1, max_num_telefone)):
                telefone = self.gerar_telefone()
                with self.conn.cursor() as cur:
                    cur.execute("INSERT INTO ClienteClienteTelefone (ClienteTelefone, ClienteCPF) VALUES (%s, %s)", 
                                (telefone, cpf))
            if random.random() < prob_enfermidade:
                cliente_enfermidade = self.gerar_doenca_falsa()
                with self.conn.cursor() as cur:
                    cur.execute("INSERT INTO ClienteClienteEnfermidade (ClienteEnfermidade, ClienteCPF) VALUES (%s, %s)", 
                                (cliente_enfermidade, cpf))
        self.commit()
        
    # Função para popular a tabela INGREDIENTES
    def generate_ingredientes(self, num_ingredientes):
        self.num_ingredientes = num_ingredientes
        for i in range(1, num_ingredientes+1): 
            nome = self.fake.word().capitalize()
            preco = round(random.uniform(1, 30), 2)
            cal = random.randint(1, 1000)
            with self.conn.cursor() as cur:
                cur.execute("INSERT INTO Ingredientes (IngredNome, IngredPrecoCompra, IngredCal) VALUES (%s, %s, %s)", 
                            (nome, preco, cal))
        self.commit()

    # Função para popular a tabela FILIAIS
    def generate_filiais(self, num_filiais):
        self.num_filiais = num_filiais
        for i in range(1, num_filiais+1):
            rua = self.get_rua()
            bairro = self.get_bairro()
            cidade = self.get_municipio()
            estado = self.get_estado()
            with self.conn.cursor() as cur:
                cur.execute("INSERT INTO Filiais (FilialRua, FilialBairro, FilialMunicipio, FilialEstado, PaisID) VALUES (%s, %s, %s, %s, %s)", 
                            (rua, bairro, cidade, estado, self.pais_id))
        self.commit()
        
    # Função para popular a tabela FORNECEDORES    
    def generate_fornecedores(self, num_fornecedores):
        self.fornecedores_cnpjs = []
        for _ in range(num_fornecedores):
            fornecedor_cnpj = self.gerar_cnpj()
            fornecedor_nome = self.fake.name()
            fornecedor_regiao = self.get_bairro()
            self.fornecedores_cnpjs.append(fornecedor_cnpj)
            with self.conn.cursor() as cur:
                cur.execute("INSERT INTO Fornecedores (FornecedorCNPJ, FornecedorNome, FornecedorRegiao) VALUES (%s, %s, %s)", 
                            (fornecedor_cnpj, fornecedor_nome, fornecedor_regiao))
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
                cur.execute("INSERT INTO Funcionarios (FuncCargo, FuncSalario, FuncDataNasc, FuncNome, FuncCPF, FilialID) VALUES (%s, %s, %s, %s, %s, %s)", 
                            (cargo, salario, nascimento, nome, cpf, filial))
            with self.conn.cursor() as cur:
                cur.execute("INSERT INTO FuncionarioFuncTelefone (FuncTelefone, FuncCPF) VALUES (%s, %s)", 
                            (telefone, cpf))
        self.commit()
        
    # Função para popular a tabela ITEMMENUINGREDIENTE    
    def generate_itemingrediente(self, max_ingredientes):
        inseridos = set()  # guarda tuplas únicas
        for i in range(1, self.num_itens + 1):
            ingredientes = random.randint(3, max_ingredientes)
            for ingrediente_id in range(1, self.num_ingredientes):
                for _ in range(ingredientes):
                    fornecedor_cnpj = str(random.choice(self.fornecedores_cnpjs))
                    chave = (ingrediente_id, i, fornecedor_cnpj)
                    if chave not in inseridos:
                        with self.conn.cursor() as cur:
                            cur.execute("""
                                INSERT INTO ItemMenuIngrediente (IngredID, ItemID, FornecedorCNPJ)
                                VALUES (%s, %s, %s)
                            """, chave)
                        inseridos.add(chave)
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
                cur.execute("INSERT INTO Reservas (ReservaData, FilialID, NumeroMesa, ClienteCPF, ClienteNome) VALUES (%s, %s, %s, %s, %s)", 
                            (data, filial, mesa, cpf, nome))
        self.commit()
        
    # Função para popular as tabelas PEDIDOS e PEDIDOITEMMENU
    def generate_pedidos(self, num_pedidos, max_qtd, max_itens, last_pedido_id):
        pedido_id = last_pedido_id
        for i in range(1, num_pedidos+1):
            data = random.choice(self.reserva_datas)
            cpf = str(random.choice(self.cliente_cpf))
            filial = random.randint(1, self.num_filiais)
            horario = self.gerar_horario()
            with self.conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO Pedidos (PedidoData, ClienteCPF, FilialID, PedidoHorario)
                    VALUES (%s, %s, %s, %s)
                """, (data, cpf, filial, horario))
                pedido_id += 1
            itens = random.randint(1, max_itens)
            itens_unicos = random.sample(range(1, self.num_itens + 1), itens)
            for item_id in itens_unicos:
                qtd = random.randint(1, max_qtd)
                with self.conn.cursor() as cur:
                    cur.execute("""
                        INSERT INTO PedidoItemMenu (Quantidade, PedidoID, ItemID, FilialID)
                        VALUES (%s, %s, %s, %s)
                    """, (qtd, pedido_id, item_id, filial))
            self.conn.commit()
        return pedido_id

    # Função par gerar um excel com o DML
    def generate_excel(self, nome_arquivo="database/DML_CHO"):
        with pd.ExcelWriter(f"{nome_arquivo}.xlsx", engine="openpyxl") as writer:
            for tabela in self.tabelas:
                query = f"SELECT * FROM {tabela};"
                df = pd.read_sql(query, self.conn)
                df.to_excel(writer, sheet_name=tabela, index=False)