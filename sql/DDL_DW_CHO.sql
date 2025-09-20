CREATE SCHEMA dw_cho;

SET search_path TO dw_cho;

CREATE TABLE CalendarDimension
(
  CalendarKey INT NOT NULL,
  Dia INT NOT NULL,
  DataCompleta DATE NOT NULL,
  DiaSemana INT NOT NULL,
  Mês INT NOT NULL,
  Trimestre INT NOT NULL,
  Ano INT NOT NULL,
  PRIMARY KEY (CalendarKey)
);

CREATE TABLE ItemDimension
(
  ItemKey INT NOT NULL,
  ItemCategoria VARCHAR(100) NOT NULL,
  ItemNome VARCHAR(100) NOT NULL,
  PRIMARY KEY (ItemKey)
);

CREATE TABLE FilialDimension
(
  FilialKey INT NOT NULL,
  FilialID INT NOT NULL,
  FilialRua VARCHAR(100) NOT NULL,
  FilialBairro VARCHAR(100) NOT NULL,
  FilialMunicipio VARCHAR(100) NOT NULL,
  FilialEstado CHAR(2) NOT NULL,
  PRIMARY KEY (FilialKey)
);

CREATE TABLE ClienteDimension
(
  ClienteKey INT NOT NULL,
  ClienteID INT NOT NULL,
  ClienteNome VARCHAR(255) NOT NULL,
  ClienteSobrenome VARCHAR(255) NOT NULL,
  ClienteTipoSang VARCHAR(100) NOT NULL,
  ClienteRua VARCHAR(100) NOT NULL,
  ClienteBairro VARCHAR(100) NOT NULL,
  ClienteMunicipio VARCHAR(100) NOT NULL,
  ClienteEstado CHAR(2) NOT NULL,
  ClienteCPF VARCHAR(11) NOT NULL,
  ClienteDataNasc DATE NOT NULL,
  ClienteEnfermidade VARCHAR(100) NOT NULL,
  PRIMARY KEY (ClienteKey),
  UNIQUE (ClienteCPF)
);

CREATE TABLE ReceitaFato
(
  IDPedido INT NOT NULL,
  ItemPreçoVenda INT NOT NULL,
  Quantidade INT NOT NULL,
  PedidoHora INT NOT NULL,
  CalendarKey INT NOT NULL,
  ItemKey INT NOT NULL,
  FilialKey INT NOT NULL,
  ClienteKey INT NOT NULL,
  PRIMARY KEY (IDPedido, CalendarKey, ItemKey, FilialKey, ClienteKey),
  FOREIGN KEY (CalendarKey) REFERENCES CalendarDimension(CalendarKey),
  FOREIGN KEY (ItemKey) REFERENCES ItemDimension(ItemKey),
  FOREIGN KEY (FilialKey) REFERENCES FilialDimension(FilialKey),
  FOREIGN KEY (ClienteKey) REFERENCES ClienteDimension(ClienteKey)
);
