-- Filial
INSERT INTO dw_cho.FilialDimension (FilialKey, FilialID, FilialRua, FilialBairro, FilialMunicipio, FilialEstado)
SELECT
    gen_random_uuid(),
    (dados->>'filialid')::uuid,
    dados->>'filialrua',
    dados->>'filialbairro',
    dados->>'filialmunicipio',
    dados->>'filialestado'
FROM log_cdc
WHERE tabela = 'cho.Filiais' AND operacao IN ('INSERT', 'UPDATE')
ON CONFLICT (FilialID) DO UPDATE SET
    FilialRua = EXCLUDED.FilialRua,
    FilialBairro = EXCLUDED.FilialBairro,
    FilialMunicipio = EXCLUDED.FilialMunicipio,
    FilialEstado = EXCLUDED.FilialEstado;


-- Cliente
INSERT INTO dw_cho.ClienteDimension (ClienteKey, ClienteCPF, ClienteNome, ClienteSobrenome, ClienteTipoSang, ClienteRua, ClienteBairro, ClienteMunicipio, ClienteEstado, ClienteDataNasc, ClienteEnfermidade)
SELECT
    gen_random_uuid(),
    T1.dados->>'clientecpf',
    T1.dados->>'clientenome',
    T1.dados->>'clientesobrenome',
    T1.dados->>'clientetiposang',
    T1.dados->>'clienterua',
    T1.dados->>'clientebairro',
    T1.dados->>'clientemunicipio',
    T1.dados->>'clienteestado',
    (T1.dados->>'clientedatanasc')::date,
    T2.dados->>'clienteEnfermidade'
FROM log_cdc AS T1
LEFT JOIN log_cdc AS T2 ON T1.dados->>'clientecpf' = T2.dados->>'clientecpf' AND T2.tabela = 'cho.ClienteClienteEnfermidade'
WHERE T1.tabela = 'cho.Clientes' AND T1.operacao IN ('INSERT', 'UPDATE')
ON CONFLICT (ClienteCPF) DO UPDATE SET
    ClienteNome = EXCLUDED.ClienteNome,
    ClienteSobrenome = EXCLUDED.ClienteSobrenome,
    ClienteTipoSang = EXCLUDED.ClienteTipoSang,
    ClienteRua = EXCLUDED.ClienteRua,
    ClienteBairro = EXCLUDED.ClienteBairro,
    ClienteMunicipio = EXCLUDED.ClienteMunicipio,
    ClienteEstado = EXCLUDED.ClienteEstado,
    ClienteDataNasc = EXCLUDED.ClienteDataNasc,
    ClienteEnfermidade = EXCLUDED.ClienteEnfermidade;
INSERT INTO dw_cho.ItemDimension (ItemKey, ItemID, ItemCategoria, ItemNome)
SELECT
    gen_random_uuid(),
    (dados->>'itemid')::int,
    dados->>'itemcategoria',
    dados->>'itemnome'
FROM log_cdc
WHERE tabela = 'cho.Itens' AND operacao IN ('INSERT', 'UPDATE')
ON CONFLICT (ItemID) DO UPDATE SET
    ItemCategoria = EXCLUDED.ItemCategoria,
    ItemNome = EXCLUDED.ItemNome;


-- Receita Fato
INSERT INTO dw_cho.ReceitaFato (IDPedido, ItemPrecoVenda, PedidoHorario, CalendarKey, ItemKey, FilialKey, ClienteKey)
SELECT
    (pi_log.dados->>'pedidoid')::int,
    (i_log.dados->>'itemprecovenda')::numeric,
    (pi_log.dados->>'pedidohorario')::time,
    dwcal.CalendarKey,
    dwi.ItemKey,
    dwf.FilialKey,
    dwc.ClienteKey
FROM log_cdc pi_log
INNER JOIN log_cdc i_log ON (i_log.dados->>'itemid')::int = (pi_log.dados->>'itemid')::int AND i_log.tabela = 'cho.Itens'
INNER JOIN log_cdc p_log ON (p_log.dados->>'pedidoid')::int = (pi_log.dados->>'pedidoid')::int AND p_log.tabela = 'cho.Pedidos'
INNER JOIN dw_cho.ClienteDimension dwc ON dwc.ClienteCPF = p_log.dados->>'clientecpf'
INNER JOIN dw_cho.FilialDimension dwf ON dwf.FilialID = (p_log.dados->>'filialid')::uuid
INNER JOIN dw_cho.ItemDimension dwi ON dwi.ItemID = (i_log.dados->>'itemid')::int
INNER JOIN dw_cho.CalendarDimension dwcal ON dwcal.DataCompleta = (p_log.dados->>'pedidodata')::date
WHERE pi_log.tabela = 'cho.PedidoItem' AND pi_log.operacao = 'INSERT'
EXCEPT
SELECT
    IDPedido,
    ItemPrecoVenda,
    PedidoHorario,
    CalendarKey,
    ItemKey,
    FilialKey,
    ClienteKey
FROM dw_cho.ReceitaFato;


