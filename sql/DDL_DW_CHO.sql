\c cho

CREATE SCHEMA dw_cho;

CREATE TYPE dw_cho.WEEKDAY AS ENUM('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT');
CREATE TABLE dw_cho.CalendarDimension
(
  CalendarKey TEXT NOT NULL,
  Dia INT NOT NULL CHECK (Dia BETWEEN 1 AND 31),
  DataCompleta DATE NOT NULL,
  DiaSemana dw_cho.WEEKDAY NOT NULL,
  Mes INT NOT NULL CHECK (Mes BETWEEN 1 AND 12),
  Trimestre INT NOT NULL CHECK (Trimestre BETWEEN 1 AND 4),
  Ano INT NOT NULL,
  PRIMARY KEY (CalendarKey)
);

CREATE TABLE dw_cho.ItemDimension
(
  ItemKey TEXT NOT NULL,
  ItemID INT NOT NULL,
  ItemCategoria VARCHAR(100) NOT NULL,
  ItemNome VARCHAR(100) NOT NULL,
  PRIMARY KEY (ItemKey)
);

CREATE TABLE dw_cho.FilialDimension
(
  FilialKey TEXT NOT NULL,
  FilialID INT NOT NULL,
  FilialRua VARCHAR(100) NOT NULL,
  FilialBairro VARCHAR(100) NOT NULL,
  FilialMunicipio VARCHAR(100) NOT NULL,
  FilialEstado CHAR(2) NOT NULL,
  PRIMARY KEY (FilialKey)
);

CREATE TABLE dw_cho.ClienteDimension
(
  ClienteKey TEXT NOT NULL,
  ClienteCPF VARCHAR(11) NOT NULL,
  ClienteNome VARCHAR(255) NOT NULL,
  ClienteSobrenome VARCHAR(255) NOT NULL,
  ClienteTipoSang VARCHAR(100) NOT NULL,
  ClienteRua VARCHAR(100) NOT NULL,
  ClienteBairro VARCHAR(100) NOT NULL,
  ClienteMunicipio VARCHAR(100) NOT NULL,
  ClienteEstado CHAR(2) NOT NULL,
  ClienteDataNasc DATE NOT NULL,
  ClienteEnfermidade VARCHAR(100),
  PRIMARY KEY (ClienteKey),
  UNIQUE (ClienteCPF)
);

CREATE TABLE dw_cho.ReceitaFato
(
  IDPedido INT NOT NULL,
  ItemPrecoVenda INT NOT NULL,
  PedidoHora TIME NOT NULL,
  CalendarKey TEXT NOT NULL,
  ItemKey TEXT NOT NULL,
  FilialKey TEXT NOT NULL,
  ClienteKey TEXT NOT NULL,
  PRIMARY KEY (IDPedido, CalendarKey, ItemKey, FilialKey, ClienteKey),
  FOREIGN KEY (CalendarKey) REFERENCES dw_cho.CalendarDimension(CalendarKey),
  FOREIGN KEY (ItemKey) REFERENCES dw_cho.ItemDimension(ItemKey),
  FOREIGN KEY (FilialKey) REFERENCES dw_cho.FilialDimension(FilialKey),
  FOREIGN KEY (ClienteKey) REFERENCES dw_cho.ClienteDimension(ClienteKey)
);
