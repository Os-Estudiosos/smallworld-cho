CREATE TABLE Item
(
  ItemID INT NOT NULL,
  ItemNome VARCHAR(255) NOT NULL,
  ItemCategoria VARCHAR(200) NOT NULL,
  ItemPrecoVenda FLOAT NOT NULL,
  PRIMARY KEY (ItemID)
);

CREATE TABLE Cliente
(
  ClienteID INT NOT NULL,
  ClienteNome VARCHAR(255) NOT NULL,
  ClienteSobrenome VARCHAR(255) NOT NULL,
  ClienteTipoSang VARCHAR(50) NOT NULL,
  ClienteRua VARCHAR(200) NOT NULL,
  ClienteBairro VARCHAR(100) NOT NULL,
  ClienteMunicipio VARCHAR(100) NOT NULL,
  ClienteEstado VARCHAR(2) NOT NULL,
  ClienteCPF INT NOT NULL,
  ClienteDataNasc DATE NOT NULL,
  PRIMARY KEY (ClienteID),
  UNIQUE (ClienteCPF)
);

CREATE TABLE Ingredientes
(
  IngredNome VARCHAR(255) NOT NULL,
  IngredID INT NOT NULL,
  IngredPrecoCompra FLOAT NOT NULL,
  IngredCal INT NOT NULL,
  PRIMARY KEY (IngredID)
);

CREATE TABLE Filial
(
  FilialID INT NOT NULL,
  FilialRua VARCHAR(255) NOT NULL,
  FilialBairro VARCHAR(100) NOT NULL,
  FilialMunicipio VARCHAR(100) NOT NULL,
  FilialEstado VARCHAR(2) NOT NULL,
  PRIMARY KEY (FilialID)
);

CREATE TABLE Funcionario
(
  FuncID INT NOT NULL,
  FuncCargo VARCHAR(255) NOT NULL,
  FuncSalario FLOAT NOT NULL,
  FuncDataNasc DATE NOT NULL,
  FuncNome VARCHAR(255) NOT NULL,
  FuncCPF INT NOT NULL,
  FilialID INT NOT NULL,
  PRIMARY KEY (FuncID),
  FOREIGN KEY (FilialID) REFERENCES Filial(FilialID),
  UNIQUE (FuncCPF)
);

CREATE TABLE Pedido
(
  PedidoData DATE NOT NULL,
  PedidoID INT NOT NULL,
  ClienteID INT NOT NULL,
  FilialID INT NOT NULL,
  PRIMARY KEY (PedidoID),
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
  FOREIGN KEY (FilialID) REFERENCES Filial(FilialID)
);

CREATE TABLE PratoPadrao
(
  PratoTipoSang VARCHAR(50) NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (ItemID),
  FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE PratoEspecial
(
  PratoEnfermidade VARCHAR(255) NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (ItemID),
  FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE Bebida
(
  BebTipoSangue VARCHAR(50) NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (ItemID),
  FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE ItemIngrediente
(
  IngredID INT NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (IngredID, ItemID),
  FOREIGN KEY (IngredID) REFERENCES Ingredientes(IngredID),
  FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE PedidoItem
(
  Quantidade INT NOT NULL,
  PedidoID INT NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (PedidoID, ItemID),
  FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID),
  FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE ClienteClienteTelefone
(
  ClienteTelefone INT NOT NULL,
  ClienteID INT NOT NULL,
  PRIMARY KEY (ClienteTelefone, ClienteID),
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE ClienteClienteEnfermidade
(
  ClienteEnfermidade INT NOT NULL,
  ClienteID INT NOT NULL,
  PRIMARY KEY (ClienteEnfermidade, ClienteID),
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE FuncionarioFuncTelefone
(
  FuncTelefone INT NOT NULL,
  FuncID INT NOT NULL,
  PRIMARY KEY (FuncTelefone, FuncID),
  FOREIGN KEY (FuncID) REFERENCES Funcionario(FuncID)
);