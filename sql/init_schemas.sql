-- Schemas medalhão
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Tabelas Bronze - Dados brutos do Censo 2022
-- População por sexo
CREATE TABLE IF NOT EXISTS bronze.populacao_sexo (
    sexo VARCHAR(20),
    populacao_pessoas BIGINT,
    recorte_geografico VARCHAR(50),
    ano INTEGER DEFAULT 2022
);

-- População por cor ou raça
CREATE TABLE IF NOT EXISTS bronze.populacao_cor_raca (
    cor_ou_raca VARCHAR(50),
    populacao_pessoas BIGINT,
    recorte_geografico VARCHAR(50),
    ano INTEGER DEFAULT 2022
);

-- Nível de instrução
CREATE TABLE IF NOT EXISTS bronze.nivel_instrucao (
    nivel_instrucao VARCHAR(100),
    populacao_pessoas BIGINT,
    recorte_geografico VARCHAR(50),
    ano INTEGER DEFAULT 2022
);

-- Crescimento populacional
CREATE TABLE IF NOT EXISTS bronze.crescimento_populacional (
    ano_pesquisa INTEGER,
    populacao_pessoas BIGINT,
    recorte_geografico VARCHAR(50)
);

-- População por situação do domicílio
CREATE TABLE IF NOT EXISTS bronze.populacao_situacao_domicilio (
    situacao VARCHAR(20),
    populacao_pessoas BIGINT,
    percentual NUMERIC(5,2),
    recorte_geografico VARCHAR(50),
    ano INTEGER DEFAULT 2022
);

-- Características dos domicílios
CREATE TABLE IF NOT EXISTS bronze.caracteristicas_domicilios (
    caracteristica VARCHAR(100),
    nao_possui_percentual NUMERIC(5,2),
    possui_percentual NUMERIC(5,2),
    recorte_geografico VARCHAR(50),
    ano INTEGER DEFAULT 2022
);

-- Território
CREATE TABLE IF NOT EXISTS bronze.territorio (
    ano_pesquisa INTEGER,
    area_km2 NUMERIC(15,2),
    densidade_demografica NUMERIC(10,2),
    recorte_geografico VARCHAR(50)
);

-- Tabela para dados sintéticos de rendimento (quando necessário)
CREATE TABLE IF NOT EXISTS bronze.censo_trabalhadores (
    uf VARCHAR(2),
    cod_municipio VARCHAR(7),
    sexo VARCHAR(1),
    raca_cor VARCHAR(1),
    faixa_rendimento_sm VARCHAR(20),
    rendimento_mensal_nominal NUMERIC,
    populacao_ocupada INTEGER,
    ano INTEGER
);

-- Silver: Dados limpos e normalizados
-- Dimensão UF/Região
CREATE TABLE IF NOT EXISTS silver.dim_uf (
    uf VARCHAR(2) PRIMARY KEY,
    regiao VARCHAR(2),
    nome_uf VARCHAR(50)
);

-- Dimensão Sexo
CREATE TABLE IF NOT EXISTS silver.dim_sexo (
    sexo_codigo VARCHAR(1) PRIMARY KEY,
    sexo_descricao VARCHAR(20)
);

-- Dimensão Cor/Raça
CREATE TABLE IF NOT EXISTS silver.dim_cor_raca (
    cor_raca_codigo VARCHAR(1) PRIMARY KEY,
    cor_raca_descricao VARCHAR(50)
);

-- Dimensão Nível de Instrução
CREATE TABLE IF NOT EXISTS silver.dim_nivel_instrucao (
    nivel_codigo VARCHAR(1) PRIMARY KEY,
    nivel_descricao VARCHAR(100)
);

-- Fato Demográfico (consolidado)
CREATE TABLE IF NOT EXISTS silver.fato_demografico (
    id SERIAL PRIMARY KEY,
    sexo_codigo VARCHAR(1),
    cor_raca_codigo VARCHAR(1),
    nivel_instrucao_codigo VARCHAR(1),
    populacao_pessoas BIGINT,
    percentual NUMERIC(5,2),
    ano INTEGER,
    recorte_geografico VARCHAR(50)
);

-- Fato Crescimento Populacional
CREATE TABLE IF NOT EXISTS silver.fato_crescimento_populacional (
    ano_pesquisa INTEGER PRIMARY KEY,
    populacao_pessoas BIGINT,
    crescimento_anual BIGINT,
    taxa_crescimento NUMERIC(5,2),
    recorte_geografico VARCHAR(50)
);

-- Fato Características Domiciliares
CREATE TABLE IF NOT EXISTS silver.fato_caracteristicas_domicilio (
    id SERIAL PRIMARY KEY,
    caracteristica VARCHAR(100),
    nao_possui_percentual NUMERIC(5,2),
    possui_percentual NUMERIC(5,2),
    ano INTEGER,
    recorte_geografico VARCHAR(50)
);

-- Fato Território
CREATE TABLE IF NOT EXISTS silver.fato_territorio (
    ano_pesquisa INTEGER PRIMARY KEY,
    area_km2 NUMERIC(15,2),
    densidade_demografica NUMERIC(10,2),
    recorte_geografico VARCHAR(50)
);

-- Tabela para dados de rendimento (quando necessário)
CREATE TABLE IF NOT EXISTS silver.fato_trabalho (
    uf VARCHAR(2) REFERENCES silver.dim_uf(uf),
    sexo VARCHAR(1),
    raca_cor VARCHAR(1),
    faixa_rendimento_sm VARCHAR(20),
    rendimento_mensal_nominal NUMERIC,
    populacao_ocupada INTEGER,
    ano INTEGER
);

-- Gold: Modelo estrela para análise dos indicadores
-- Dimensão Tempo
CREATE TABLE IF NOT EXISTS gold.dim_tempo (
    ano INTEGER PRIMARY KEY,
    decada VARCHAR(10),
    periodo VARCHAR(20)
);

-- Dimensão Localidade
CREATE TABLE IF NOT EXISTS gold.dim_localidade (
    uf VARCHAR(2) PRIMARY KEY,
    regiao VARCHAR(2),
    nome_uf VARCHAR(50),
    nome_regiao VARCHAR(50)
);

-- Dimensão Demográfica
CREATE TABLE IF NOT EXISTS gold.dim_demografica (
    id SERIAL PRIMARY KEY,
    sexo_codigo VARCHAR(1),
    cor_raca_codigo VARCHAR(1),
    nivel_instrucao_codigo VARCHAR(1),
    sexo_descricao VARCHAR(20),
    cor_raca_descricao VARCHAR(50),
    nivel_instrucao_descricao VARCHAR(100)
);

-- Fato Indicadores Demográficos
CREATE TABLE IF NOT EXISTS gold.fato_indicadores_demograficos (
    id SERIAL PRIMARY KEY,
    ano INTEGER REFERENCES gold.dim_tempo(ano),
    uf VARCHAR(2) REFERENCES gold.dim_localidade(uf),
    sexo_codigo VARCHAR(1),
    cor_raca_codigo VARCHAR(1),
    nivel_instrucao_codigo VARCHAR(1),
    populacao_total BIGINT,
    populacao_urbana BIGINT,
    populacao_rural BIGINT,
    percentual_urbana NUMERIC(5,2),
    percentual_rural NUMERIC(5,2),
    densidade_demografica NUMERIC(10,2),
    area_km2 NUMERIC(15,2)
);

-- Fato Indicadores de Renda (quando dados disponíveis)
CREATE TABLE IF NOT EXISTS gold.fato_indicadores_renda (
    id SERIAL PRIMARY KEY,
    ano INTEGER REFERENCES gold.dim_tempo(ano),
    uf VARCHAR(2) REFERENCES gold.dim_localidade(uf),
    sexo_codigo VARCHAR(1),
    cor_raca_codigo VARCHAR(1),
    -- Indicadores solicitados
    percentual_ate_1sm NUMERIC(5,2),
    percentual_mais_5sm NUMERIC(5,2),
    percentual_1_a_2sm NUMERIC(5,2),
    percentual_mais_20sm NUMERIC(5,2),
    rendimento_medio_brasil NUMERIC(10,2),
    rendimento_medio_uf NUMERIC(10,2),
    rendimento_medio_regiao NUMERIC(10,2),
    rendimento_medio_sexo NUMERIC(10,2),
    rendimento_medio_cor_raca NUMERIC(10,2),
    indice_gini NUMERIC(5,4),
    indice_gini_regiao NUMERIC(5,4),
    nivel_ocupacao_14_mais NUMERIC(5,2),
    nivel_ocupacao_uf NUMERIC(5,2)
);

-- Fato Crescimento e Desenvolvimento
CREATE TABLE IF NOT EXISTS gold.fato_crescimento_desenvolvimento (
    id SERIAL PRIMARY KEY,
    ano INTEGER REFERENCES gold.dim_tempo(ano),
    uf VARCHAR(2) REFERENCES gold.dim_localidade(uf),
    populacao_total BIGINT,
    crescimento_anual BIGINT,
    taxa_crescimento_anual NUMERIC(5,2),
    taxa_crescimento_decada NUMERIC(5,2),
    densidade_demografica NUMERIC(10,2),
    area_km2 NUMERIC(15,2)
);

-- Fato Qualidade de Vida
CREATE TABLE IF NOT EXISTS gold.fato_qualidade_vida (
    id SERIAL PRIMARY KEY,
    ano INTEGER REFERENCES gold.dim_tempo(ano),
    uf VARCHAR(2) REFERENCES gold.dim_localidade(uf),
    percentual_esgoto NUMERIC(5,2),
    percentual_agua NUMERIC(5,2),
    percentual_banheiro NUMERIC(5,2),
    percentual_coleta_lixo NUMERIC(5,2),
    indice_saneamento NUMERIC(5,2)
);

