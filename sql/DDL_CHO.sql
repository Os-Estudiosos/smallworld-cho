CREATE DATABASE cho;
\c cho

CREATE SCHEMA cho;
SET search_path=cho; 

CREATE TABLE Itens
(
  ItemID INT NOT NULL,
  ItemNome VARCHAR(255) NOT NULL,
  ItemCategoria VARCHAR(255) NOT NULL,
  ItemPrecoVenda FLOAT NOT NULL,
  PRIMARY KEY (ItemID)
);

CREATE TABLE PratoPadrao
(
  PratoTipoSang VARCHAR(255) NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (ItemID),
  FOREIGN KEY (ItemID) REFERENCES Itens(ItemID)
);

CREATE TABLE PratoEspecial
(
  PratoEnfermidade VARCHAR(255) NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (ItemID),
  FOREIGN KEY (ItemID) REFERENCES Itens(ItemID)
);

CREATE TABLE Bebida
(
  BebTipoSangue VARCHAR(255) NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (ItemID),
  FOREIGN KEY (ItemID) REFERENCES Itens(ItemID)
);

CREATE TABLE Clientes
(
  ClienteNome VARCHAR(255) NOT NULL,
  ClienteSobrenome VARCHAR(255) NOT NULL,
  ClienteTipoSang VARCHAR(50) NOT NULL,
  ClienteRua VARCHAR(255) NOT NULL,
  ClienteBairro VARCHAR(255) NOT NULL,
  ClienteMunicipio VARCHAR(255) NOT NULL,
  ClienteEstado VARCHAR(2) NOT NULL,
  ClienteCPF VARCHAR(11) NOT NULL,
  ClienteDataNasc DATE NOT NULL,
  PRIMARY KEY (ClienteCPF)
);

CREATE TABLE ClienteClienteTelefone
(
  ClienteTelefone VARCHAR(255) NOT NULL,
  ClienteCPF VARCHAR(11) NOT NULL,
  PRIMARY KEY (ClienteTelefone, ClienteCPF),
  FOREIGN KEY (ClienteCPF) REFERENCES Clientes(ClienteCPF)
);

CREATE TABLE ClienteClienteEnfermidade
(
  ClienteEnfermidade VARCHAR(255) NOT NULL,
  ClienteCPF VARCHAR(11) NOT NULL,
  PRIMARY KEY (ClienteEnfermidade, ClienteCPF),
  FOREIGN KEY (ClienteCPF) REFERENCES Clientes(ClienteCPF)
);

CREATE TABLE Ingredientes
(
  IngredNome VARCHAR(255) NOT NULL,
  IngredID INT NOT NULL,
  IngredPrecoCompra FLOAT NOT NULL,
  IngredCal INT NOT NULL,
  PRIMARY KEY (IngredID)
);

CREATE TABLE Filiais
(
  FilialID INT NOT NULL,
  FilialRua VARCHAR(255) NOT NULL,
  FilialBairro VARCHAR(255) NOT NULL,
  FilialMunicipio VARCHAR(255) NOT NULL,
  FilialEstado VARCHAR(2) NOT NULL,
  PRIMARY KEY (FilialID)
);

CREATE TABLE Fornecedores
(
  FornecedorCNPJ VARCHAR(14) NOT NULL,
  FornecedorNome VARCHAR(255) NOT NULL,
  FornecedorRegiao VARCHAR(50) NOT NULL,
  PRIMARY KEY (FornecedorCNPJ)
);

CREATE TABLE ItemIngrediente
(
  IngredID INT NOT NULL,
  ItemID INT NOT NULL,
  FornecedorCNPJ VARCHAR(14) NOT NULL,
  PRIMARY KEY (IngredID, ItemID, FornecedorCNPJ),
  FOREIGN KEY (IngredID) REFERENCES Ingredientes(IngredID),
  FOREIGN KEY (ItemID) REFERENCES Itens(ItemID),
  FOREIGN KEY (FornecedorCNPJ) REFERENCES Fornecedores(FornecedorCNPJ)
);

CREATE TABLE Funcionarios
(
  FuncCargo VARCHAR(255) NOT NULL,
  FuncSalario FLOAT NOT NULL,
  FuncDataNasc DATE NOT NULL,
  FuncNome VARCHAR(255) NOT NULL,
  FuncCPF VARCHAR(11) NOT NULL,
  FilialID INT NOT NULL,
  PRIMARY KEY (FuncCPF),
  FOREIGN KEY (FilialID) REFERENCES Filiais(FilialID)
);

CREATE TABLE FuncionarioFuncTelefone
(
  FuncTelefone VARCHAR(255) NOT NULL,
  FuncCPF VARCHAR(11) NOT NULL,
  PRIMARY KEY (FuncTelefone, FuncCPF),
  FOREIGN KEY (FuncCPF) REFERENCES Funcionarios(FuncCPF)
);

CREATE TABLE Reservas
(
  ReservaID INT NOT NULL,
  ReservaData DATE NOT NULL,
  FilialID INT NOT NULL,
  NumeroMesa INT NOT NULL,
  ClienteCPF VARCHAR(11) NULL,
  ClienteNome VARCHAR(255) NOT NULL,
  PRIMARY KEY (ReservaID),
  FOREIGN KEY (FilialID) REFERENCES Filiais(FilialID),
  FOREIGN KEY (ClienteCPF) REFERENCES Clientes(ClienteCPF)
);

CREATE TABLE Pedidos
(
  PedidoID INT NOT NULL,
  PedidoData DATE NOT NULL,
  ClienteCPF VARCHAR(11) NOT NULL,
  FilialID INT NOT NULL,
  PedidoHorario TIME NOT NULL,
  PRIMARY KEY (PedidoID),
  FOREIGN KEY (ClienteCPF) REFERENCES Clientes(ClienteCPF),
  FOREIGN KEY (FilialID) REFERENCES Filiais(FilialID)
);

CREATE TABLE PedidoItem
(
  PedidoID INT NOT NULL,
  ItemID INT NOT NULL,
  Quantidade INT NOT NULL,
  FilialID INT NOT NULL,
  PRIMARY KEY (PedidoID, ItemID),
  FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
  FOREIGN KEY (ItemID) REFERENCES Itens(ItemID),
  FOREIGN KEY (FilialID) REFERENCES Filiais(FilialID)
);