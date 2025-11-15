SELECT
    "Currency",
    COUNT(*) AS total_restaurantes
FROM
    fontes.restaurants_per_country
GROUP BY
    "Currency"
ORDER BY
    total_restaurantes DESC;


/*
  ATENÇÃO: Este comando SÓ GERARÁ DADOS VÁLIDOS se você
  filtrar por UMA ÚNICA MOEDA (ex: 'USD') no JOIN.
*/
/*
  Consulta CORRIGIDA para 'Dollar($)'
  e com filtro de contagem reduzido
*/
-- WITH GastoMedioPorPais AS (
--     SELECT
--         t_cities.country,
--         AVG(t_rest."Average Cost for two") AS avg_cost_for_two,
--         COUNT(t_rest."Restaurant ID") AS restaurant_count
--     FROM
--         fontes.restaurants_per_country AS t_rest
--     JOIN
--         fontes.world_cities AS t_cities ON t_rest."City" = t_cities.city
--     WHERE
--         -- CORREÇÃO 1: Usar o nome exato da moeda
--         t_rest."Currency" = 'Dollar($)'
--     GROUP BY
--         t_cities.country
-- )
-- SELECT
--     country,
--     avg_cost_for_two,
--     restaurant_count,
--     -- Cenário Pessimista (20 pessoas/dia)
--     (avg_cost_for_two * (20.0 / 2.0)) AS faturamento_diario_pessimista,
--     -- Cenário Otimista (200 pessoas/dia)
--     (avg_cost_for_two * (200.0 / 2.0)) AS faturamento_diario_otimista
-- FROM
--     GastoMedioPorPais
-- WHERE
--     -- CORREÇÃO 2: Reduzir a contagem mínima
--     restaurant_count > 5
-- ORDER BY
--     faturamento_diario_otimista DESC;


/*
  PASSO 1:
  Cria uma tabela temporária (GastoMedioPorPais) unindo
  a análise das 5 moedas principais.
  Cada moeda tem sua taxa de câmbio para BRL "embutida".
*/
WITH GastoMedioPorPais AS (
    -- 1. Análise Indian Rupees(Rs.)
    SELECT
        t_cities.country,
        AVG(t_rest."Average Cost for two") AS avg_cost_local,
        t_rest."Currency" AS currency,
        COUNT(t_rest."Restaurant ID") AS restaurant_count,
        0.060 AS taxa_cambio_para_brl -- INR para BRL
    FROM
        fontes.restaurants_per_country AS t_rest
    JOIN
        fontes.world_cities AS t_cities ON t_rest."City" = t_cities.city
    WHERE
        t_rest."Currency" = 'Indian Rupees(Rs.)'
    GROUP BY
        t_cities.country, t_rest."Currency"

    UNION ALL

    -- 2. Análise Dollar($)
    SELECT
        t_cities.country,
        AVG(t_rest."Average Cost for two") AS avg_cost_local,
        t_rest."Currency" AS currency,
        COUNT(t_rest."Restaurant ID") AS restaurant_count,
        5.30 AS taxa_cambio_para_brl -- USD para BRL
    FROM
        fontes.restaurants_per_country AS t_rest
    JOIN
        fontes.world_cities AS t_cities ON t_rest."City" = t_cities.city
    WHERE
        t_rest."Currency" = 'Dollar($)'
    GROUP BY
        t_cities.country, t_rest."Currency"

    UNION ALL

    -- 3. Análise Pounds(£)
    SELECT
        t_cities.country,
        AVG(t_rest."Average Cost for two") AS avg_cost_local,
        t_rest."Currency" AS currency,
        COUNT(t_rest."Restaurant ID") AS restaurant_count,
        6.97 AS taxa_cambio_para_brl -- GBP para BRL
    FROM
        fontes.restaurants_per_country AS t_rest
    JOIN
        fontes.world_cities AS t_cities ON t_rest."City" = t_cities.city
    WHERE
        t_rest."Currency" = 'Pounds(£)'
    GROUP BY
        t_cities.country, t_rest."Currency"

    UNION ALL

    -- 4. Análise Rand(R)
    SELECT
        t_cities.country,
        AVG(t_rest."Average Cost for two") AS avg_cost_local,
        t_rest."Currency" AS currency,
        COUNT(t_rest."Restaurant ID") AS restaurant_count,
        0.31 AS taxa_cambio_para_brl -- ZAR para BRL
    FROM
        fontes.restaurants_per_country AS t_rest
    JOIN
        fontes.world_cities AS t_cities ON t_rest."City" = t_cities.city
    WHERE
        t_rest."Currency" = 'Rand(R)'
    GROUP BY
        t_cities.country, t_rest."Currency"

    UNION ALL

    -- 5. Análise Brazilian Real(R$)
    SELECT
        t_cities.country,
        AVG(t_rest."Average Cost for two") AS avg_cost_local,
        t_rest."Currency" AS currency,
        COUNT(t_rest."Restaurant ID") AS restaurant_count,
        1.0 AS taxa_cambio_para_brl -- BRL para BRL
    FROM
        fontes.restaurants_per_country AS t_rest
    JOIN
        fontes.world_cities AS t_cities ON t_rest."City" = t_cities.city
    WHERE
        t_rest."Currency" = 'Brazilian Real(R$)'
    GROUP BY
        t_cities.country, t_rest."Currency"
),

/*
  PASSO 2:
  Calcula o faturamento com base na tabela unida,
  converte para BRL e aplica o filtro de confiança.
*/
CalculoFaturamento AS (
    SELECT
        country,
        currency,
        avg_cost_local,
        restaurant_count,
        taxa_cambio_para_brl,
        
        -- Faturamento Pessimista (20 pessoas/dia) na MOEDA LOCAL
        (avg_cost_local * (20.0 / 2.0)) AS faturamento_pessimista_local,
        
        -- Faturamento Pessimista (20 pessoas/dia) em BRL
        (avg_cost_local * (20.0 / 2.0) * taxa_cambio_para_brl) AS faturamento_pessimista_brl
    FROM
        GastoMedioPorPais
    WHERE
        -- Filtro de confiança (mínimo de 5 restaurantes para a média ser válida)
        restaurant_count > 5
)

/*
  PASSO 3:
  Seleciona o TOP 10, formatado com 2 casas decimais.
*/
SELECT
    country,
    currency,
    restaurant_count,
    
    -- Formatado para 2 casas decimais
    CAST(faturamento_pessimista_local AS NUMERIC(12, 2)) AS faturamento_pessimista_local,
    
    taxa_cambio_para_brl,
    
    -- Formatado para 2 casas decimais
    CAST(faturamento_pessimista_brl AS NUMERIC(12, 2)) AS faturamento_pessimista_brl
    
FROM
    CalculoFaturamento
ORDER BY
    faturamento_pessimista_brl DESC
LIMIT 10;
