\c cho

-- Inserindo as Filiais
INSERT INTO dw_cho.FilialDimension (SELECT
        gen_random_uuid(),
        f.FilialID,
        f.FilialRua,
        f.FilialBairro,
        f.FilialMunicipio,
        f.FilialEstado,
        p.PaisNome,
        bt.APorcentagem,
        bt.BPorcentagem,
        bt.ABPorcentagem,
        bt.OPorcentagem 
FROM cho.Filiais f
        LEFT JOIN cho.Pais p ON p.PaisID = f.PaisID
        LEFT JOIN (
                SELECT
                        country,
                        "O+"+"O-" as OPorcentagem,
                        "A+"+"A-" as APorcentagem,
                        "B+"+"B-" as BPorcentagem,
                        "AB+"+"AB-" as ABPorcentagem
                FROM fontes.bloodtypes_per_country
        ) bt ON bt.country = p.PaisNome
);

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

-- Inserindo os ItensMenu
INSERT INTO dw_cho.ItemMenuDimension (SELECT
        gen_random_uuid(),
        i.ItemID,
        i.ItemCategoria,
        i.ItemNome,
        TRIM(COALESCE(pp.PratoTipoSang, b.BebTipoSangue)) as TipSang
FROM cho.ItensMenu i
        LEFT JOIN cho.PratoPadrao pp ON pp.ItemID  = i.ItemID
        LEFT JOIN cho.Bebida b ON b.ItemID = i.ItemID
);

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
        CAST(TO_CHAR(p.PedidoData, 'DY') AS dw_cho.WEEKDAY) AS DiaSemana,
        EXTRACT(MONTH FROM p.PedidoData) AS Mes,
        CAST(TO_CHAR(p.PedidoData, 'Q') AS INT) AS Trimestre,
        EXTRACT(YEAR FROM p.PedidoData) AS Ano
    FROM cho.Pedidos p
) d
WHERE CAST(d.DataCompleta AS DATE) NOT IN (SELECT DataCompleta FROM dw_cho.CalendarDimension);

-- Inserindo os fatos na tabela ReceitaFato
INSERT INTO dw_cho.ReceitaFato SELECT
    p.PedidoID,
    i.ItemPrecoVenda,
    p.PedidoHorario,
    dwcal.CalendarKey,
    dwi.ItemKey,
    dwf.FilialKey,
    dwc.ClienteKey
FROM
    cho.Pedidos p INNER JOIN cho.PedidoItemMenu pi ON p.PedidoID = pi.PedidoID
    INNER JOIN cho.ItensMenu i ON pi.ItemID = i.ItemID

    INNER JOIN cho.Filiais f ON p.FilialID = f.FilialID
    INNER JOIN cho.Clientes c ON c.ClienteCPF = p.ClienteCPF

    INNER JOIN dw_cho.ClienteDimension dwc ON dwc.ClienteCPF = c.ClienteCPF
    INNER JOIN dw_cho.FilialDimension dwf ON dwf.FilialID = f.FilialID
    INNER JOIN dw_cho.ItemMenuDimension dwi ON dwi.ItemID = i.ItemID
    INNER JOIN dw_cho.CalendarDimension dwcal ON dwcal.DataCompleta = CAST(p.PedidoData AS DATE)
EXCEPT SELECT
    IDPedido,
    ItemPrecoVenda,
    PedidoHorario,
    CalendarKey,
    ItemKey,
    FilialKey,
    ClienteKey
FROM dw_cho.ReceitaFato;
