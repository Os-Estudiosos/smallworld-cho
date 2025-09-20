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

INSERT INTO dw.ClienteDimension SELECT
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