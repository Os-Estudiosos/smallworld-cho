\c cho

-- Inserindo as Filiais
INSERT INTO dw_cho.FilialDimension SELECT
    gen_random_uuid(),
    f.FilialID,
    f.FilialRua,
    f.FilialBairro,
    f.FilialMunicipio,
    f.FilialEstado
FROM cho.Filiais f;

-- Inserindo os Clientes
INSERT INTO dw_cho.ClienteDimension SELECT
    gen_random_uuid(),
    c.ClienteCPF,
    c.ClienteNome,
    c.ClienteSobrenome,
    c.ClienteTipoSang,
    c.ClienteRua,
    c.ClienteBairro,
    c.ClienteMunicipio,
    c.ClienteEstado,
    c.ClienteDataNasc,
    cce.ClienteEnfermidade
FROM cho.Clientes c LEFT JOIN cho.ClienteClienteEnfermidade cce ON c.ClienteCPF=cce.ClienteCPF;

-- Inserindo os Itens
INSERT INTO dw_cho.ItemDimension SELECT
    gen_random_uuid(),
    i.ItemCategoria,
    i.ItemNome
FROM cho.Itens i;

-- Inserindo o Calendário
INSERT INTO dw_cho.CalendarDimension SELECT
    gen_random_uuid(),
    d.Dia,
    d.DataCompleta,
    d.DiaSemana,
    d.Mes,
    d.Trimestre,
    d.Ano
FROM (
    SELECT
        EXTRACT(DAY FROM p.PedidoData) AS Dia,
        CAST(p.PedidoData AS DATE) AS DataCompleta,
        CAST(TO_CHAR(p.PedidoData, 'DY') AS WEEKDAY) AS DiaSemana,
        EXTRACT(MONTH FROM p.PedidoData) AS Mes,
        CAST(TO_CHAR(p.PedidoData, 'Q') AS INT) AS Trimestre,
        EXTRACT(YEAR FROM p.PedidoData) AS Ano
    FROM cho.Pedidos p
) d
WHERE CAST(d.DataCompleta AS DATE) NOT IN (SELECT DataCompleta FROM dw_cho.CalendarDimension);

--   CalendarKey TEXT NOT NULL,
--   Dia INT NOT NULL CHECK (Dia BETWEEN 1 AND 31),
--   DataCompleta DATE NOT NULL,
--   DiaSemana WEEKDAY NOT NULL,
--   Mes INT NOT NULL CHECK (Mes BETWEEN 1 AND 12),
--   Trimestre INT NOT NULL CHECK (Trimestre BETWEEN 1 AND 4),
--   Ano INT NOT NULL,
--   PRIMARY KEY (CalendarKey)
