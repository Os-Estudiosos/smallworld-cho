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

-- Inserindo os fatos na tabela ReceitaFato
SELECT
    PedidoID,
    i.ItemPrecoVenda,
    p.PedidoHora,
    dwf.FilialKey,
    dwc.ClienteKey,
    dwi.ItemKey,
    dwcal.CalendarKey
FROM
    cho.Pedidos p INNER JOIN cho.PedidoItem pi ON p.PedidoID = pi.PedidoID
    INNER JOIN cho.Itens i ON pi.ItemID = i.ItemID

    INNER JOIN cho.Filiais f ON p.FilialID = f.FilialID
    INNER JOIN cho.Clientes c ON c.ClienteCPF = p.ClienteCPF

    INNER JOIN dw_cho.ClienteDimension dwc ON dwc.ClienteCPF = c.ClienteCPF
    INNER JOIN dw_cho.FilialDimension dwf ON dwf.FilialID = f.FilialID
    INNER JOIN dw_cho.ItemDimension dwi ON dwi.ItemID = i.ItemID
    INNER JOIN dw_cho.CalendarDimension dwcal ON dwcal.DataCompleta = CAST(p.PedidoData AS DATE)
;
