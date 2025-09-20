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

