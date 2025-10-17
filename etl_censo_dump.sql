--
-- PostgreSQL database dump
--

\restrict mheLbjiQoTFiFuc3HJpsWVbZ0chk67aTlsCKdBDzLJJNNkWRjgBpFdfoCuKScXW

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS etl_censo;
--
-- Name: etl_censo; Type: DATABASE; Schema: -; Owner: etl_user
--

CREATE DATABASE etl_censo WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE etl_censo OWNER TO etl_user;

\unrestrict mheLbjiQoTFiFuc3HJpsWVbZ0chk67aTlsCKdBDzLJJNNkWRjgBpFdfoCuKScXW
\connect etl_censo
\restrict mheLbjiQoTFiFuc3HJpsWVbZ0chk67aTlsCKdBDzLJJNNkWRjgBpFdfoCuKScXW

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bronze; Type: SCHEMA; Schema: -; Owner: etl_user
--

CREATE SCHEMA bronze;


ALTER SCHEMA bronze OWNER TO etl_user;

--
-- Name: gold; Type: SCHEMA; Schema: -; Owner: etl_user
--

CREATE SCHEMA gold;


ALTER SCHEMA gold OWNER TO etl_user;

--
-- Name: silver; Type: SCHEMA; Schema: -; Owner: etl_user
--

CREATE SCHEMA silver;


ALTER SCHEMA silver OWNER TO etl_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: caracteristicas_domicilios; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.caracteristicas_domicilios (
    caracteristica text,
    nao_possui_percentual text,
    possui_percentual text,
    recorte_geografico text,
    ano integer
);


ALTER TABLE bronze.caracteristicas_domicilios OWNER TO etl_user;

--
-- Name: censo_trabalhadores; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.censo_trabalhadores (
    uf text,
    cod_municipio text,
    sexo text,
    raca_cor text,
    faixa_rendimento_sm text,
    rendimento_mensal_nominal double precision,
    populacao_ocupada bigint,
    ano bigint
);


ALTER TABLE bronze.censo_trabalhadores OWNER TO etl_user;

--
-- Name: crescimento_populacional; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.crescimento_populacional (
    ano_pesquisa integer,
    populacao_pessoas bigint,
    recorte_geografico text
);


ALTER TABLE bronze.crescimento_populacional OWNER TO etl_user;

--
-- Name: nivel_instrucao; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.nivel_instrucao (
    nivel_instrucao text,
    populacao_pessoas bigint,
    recorte_geografico text,
    ano integer
);


ALTER TABLE bronze.nivel_instrucao OWNER TO etl_user;

--
-- Name: populacao_cor_raca; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.populacao_cor_raca (
    cor_ou_raca text,
    populacao_pessoas bigint,
    recorte_geografico text,
    ano integer
);


ALTER TABLE bronze.populacao_cor_raca OWNER TO etl_user;

--
-- Name: populacao_sexo; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.populacao_sexo (
    sexo text,
    populacao_pessoas bigint,
    recorte_geografico text,
    ano integer
);


ALTER TABLE bronze.populacao_sexo OWNER TO etl_user;

--
-- Name: populacao_situacao_domicilio; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.populacao_situacao_domicilio (
    situacao text,
    populacao_pessoas bigint,
    percentual text,
    recorte_geografico text,
    ano integer
);


ALTER TABLE bronze.populacao_situacao_domicilio OWNER TO etl_user;

--
-- Name: territorio; Type: TABLE; Schema: bronze; Owner: etl_user
--

CREATE TABLE bronze.territorio (
    ano_pesquisa integer,
    area_km2 text,
    densidade_demografica text,
    recorte_geografico text
);


ALTER TABLE bronze.territorio OWNER TO etl_user;

--
-- Name: dim_demografica; Type: TABLE; Schema: gold; Owner: etl_user
--

CREATE TABLE gold.dim_demografica (
    id integer NOT NULL,
    sexo_codigo character varying(1),
    cor_raca_codigo character varying(1),
    nivel_instrucao_codigo character varying(1),
    sexo_descricao character varying(20),
    cor_raca_descricao character varying(50),
    nivel_instrucao_descricao character varying(100)
);


ALTER TABLE gold.dim_demografica OWNER TO etl_user;

--
-- Name: dim_demografica_id_seq; Type: SEQUENCE; Schema: gold; Owner: etl_user
--

CREATE SEQUENCE gold.dim_demografica_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gold.dim_demografica_id_seq OWNER TO etl_user;

--
-- Name: dim_demografica_id_seq; Type: SEQUENCE OWNED BY; Schema: gold; Owner: etl_user
--

ALTER SEQUENCE gold.dim_demografica_id_seq OWNED BY gold.dim_demografica.id;


--
-- Name: dim_localidade; Type: TABLE; Schema: gold; Owner: etl_user
--

CREATE TABLE gold.dim_localidade (
    uf text,
    regiao text,
    nome_uf text,
    nome_regiao text
);


ALTER TABLE gold.dim_localidade OWNER TO etl_user;

--
-- Name: dim_tempo; Type: TABLE; Schema: gold; Owner: etl_user
--

CREATE TABLE gold.dim_tempo (
    ano bigint,
    decada text,
    periodo text
);


ALTER TABLE gold.dim_tempo OWNER TO etl_user;

--
-- Name: fato_crescimento_desenvolvimento; Type: TABLE; Schema: gold; Owner: etl_user
--

CREATE TABLE gold.fato_crescimento_desenvolvimento (
    id integer NOT NULL,
    ano integer,
    uf character varying(2),
    populacao_total bigint,
    crescimento_anual bigint,
    taxa_crescimento_anual numeric(5,2),
    taxa_crescimento_decada numeric(5,2),
    densidade_demografica numeric(10,2),
    area_km2 numeric(15,2)
);


ALTER TABLE gold.fato_crescimento_desenvolvimento OWNER TO etl_user;

--
-- Name: fato_crescimento_desenvolvimento_id_seq; Type: SEQUENCE; Schema: gold; Owner: etl_user
--

CREATE SEQUENCE gold.fato_crescimento_desenvolvimento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gold.fato_crescimento_desenvolvimento_id_seq OWNER TO etl_user;

--
-- Name: fato_crescimento_desenvolvimento_id_seq; Type: SEQUENCE OWNED BY; Schema: gold; Owner: etl_user
--

ALTER SEQUENCE gold.fato_crescimento_desenvolvimento_id_seq OWNED BY gold.fato_crescimento_desenvolvimento.id;


--
-- Name: fato_indicadores_demograficos; Type: TABLE; Schema: gold; Owner: etl_user
--

CREATE TABLE gold.fato_indicadores_demograficos (
    id integer NOT NULL,
    ano integer,
    uf character varying(2),
    sexo_codigo character varying(1),
    cor_raca_codigo character varying(1),
    nivel_instrucao_codigo character varying(1),
    populacao_total bigint,
    populacao_urbana bigint,
    populacao_rural bigint,
    percentual_urbana numeric(5,2),
    percentual_rural numeric(5,2),
    densidade_demografica numeric(10,2),
    area_km2 numeric(15,2)
);


ALTER TABLE gold.fato_indicadores_demograficos OWNER TO etl_user;

--
-- Name: fato_indicadores_demograficos_id_seq; Type: SEQUENCE; Schema: gold; Owner: etl_user
--

CREATE SEQUENCE gold.fato_indicadores_demograficos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gold.fato_indicadores_demograficos_id_seq OWNER TO etl_user;

--
-- Name: fato_indicadores_demograficos_id_seq; Type: SEQUENCE OWNED BY; Schema: gold; Owner: etl_user
--

ALTER SEQUENCE gold.fato_indicadores_demograficos_id_seq OWNED BY gold.fato_indicadores_demograficos.id;


--
-- Name: fato_indicadores_renda; Type: TABLE; Schema: gold; Owner: etl_user
--

CREATE TABLE gold.fato_indicadores_renda (
    ano bigint,
    uf text,
    sexo_codigo text,
    cor_raca_codigo text,
    percentual_ate_1sm double precision,
    percentual_mais_5sm double precision,
    percentual_1_a_2sm double precision,
    percentual_mais_20sm double precision,
    rendimento_medio_brasil double precision,
    rendimento_medio_uf double precision,
    rendimento_medio_regiao text,
    rendimento_medio_sexo text,
    rendimento_medio_cor_raca text,
    indice_gini double precision,
    indice_gini_regiao text,
    nivel_ocupacao_14_mais double precision,
    nivel_ocupacao_uf double precision
);


ALTER TABLE gold.fato_indicadores_renda OWNER TO etl_user;

--
-- Name: fato_qualidade_vida; Type: TABLE; Schema: gold; Owner: etl_user
--

CREATE TABLE gold.fato_qualidade_vida (
    id integer NOT NULL,
    ano integer,
    uf character varying(2),
    percentual_esgoto numeric(5,2),
    percentual_agua numeric(5,2),
    percentual_banheiro numeric(5,2),
    percentual_coleta_lixo numeric(5,2),
    indice_saneamento numeric(5,2)
);


ALTER TABLE gold.fato_qualidade_vida OWNER TO etl_user;

--
-- Name: fato_qualidade_vida_id_seq; Type: SEQUENCE; Schema: gold; Owner: etl_user
--

CREATE SEQUENCE gold.fato_qualidade_vida_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gold.fato_qualidade_vida_id_seq OWNER TO etl_user;

--
-- Name: fato_qualidade_vida_id_seq; Type: SEQUENCE OWNED BY; Schema: gold; Owner: etl_user
--

ALTER SEQUENCE gold.fato_qualidade_vida_id_seq OWNED BY gold.fato_qualidade_vida.id;


--
-- Name: ab_permission; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_permission (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.ab_permission OWNER TO etl_user;

--
-- Name: ab_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_permission_id_seq OWNER TO etl_user;

--
-- Name: ab_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_permission_id_seq OWNED BY public.ab_permission.id;


--
-- Name: ab_permission_view; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_permission_view (
    id integer NOT NULL,
    permission_id integer,
    view_menu_id integer
);


ALTER TABLE public.ab_permission_view OWNER TO etl_user;

--
-- Name: ab_permission_view_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_permission_view_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_permission_view_id_seq OWNER TO etl_user;

--
-- Name: ab_permission_view_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_permission_view_id_seq OWNED BY public.ab_permission_view.id;


--
-- Name: ab_permission_view_role; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_permission_view_role (
    id integer NOT NULL,
    permission_view_id integer,
    role_id integer
);


ALTER TABLE public.ab_permission_view_role OWNER TO etl_user;

--
-- Name: ab_permission_view_role_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_permission_view_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_permission_view_role_id_seq OWNER TO etl_user;

--
-- Name: ab_permission_view_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_permission_view_role_id_seq OWNED BY public.ab_permission_view_role.id;


--
-- Name: ab_register_user; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_register_user (
    id integer NOT NULL,
    first_name character varying(256) NOT NULL,
    last_name character varying(256) NOT NULL,
    username character varying(512) NOT NULL,
    password character varying(256),
    email character varying(512) NOT NULL,
    registration_date timestamp without time zone,
    registration_hash character varying(256)
);


ALTER TABLE public.ab_register_user OWNER TO etl_user;

--
-- Name: ab_register_user_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_register_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_register_user_id_seq OWNER TO etl_user;

--
-- Name: ab_register_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_register_user_id_seq OWNED BY public.ab_register_user.id;


--
-- Name: ab_role; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_role (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.ab_role OWNER TO etl_user;

--
-- Name: ab_role_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_role_id_seq OWNER TO etl_user;

--
-- Name: ab_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_role_id_seq OWNED BY public.ab_role.id;


--
-- Name: ab_user; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_user (
    id integer NOT NULL,
    first_name character varying(256) NOT NULL,
    last_name character varying(256) NOT NULL,
    username character varying(512) NOT NULL,
    password character varying(256),
    active boolean,
    email character varying(512) NOT NULL,
    last_login timestamp without time zone,
    login_count integer,
    fail_login_count integer,
    created_on timestamp without time zone,
    changed_on timestamp without time zone,
    created_by_fk integer,
    changed_by_fk integer
);


ALTER TABLE public.ab_user OWNER TO etl_user;

--
-- Name: ab_user_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_user_id_seq OWNER TO etl_user;

--
-- Name: ab_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_user_id_seq OWNED BY public.ab_user.id;


--
-- Name: ab_user_role; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_user_role (
    id integer NOT NULL,
    user_id integer,
    role_id integer
);


ALTER TABLE public.ab_user_role OWNER TO etl_user;

--
-- Name: ab_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_user_role_id_seq OWNER TO etl_user;

--
-- Name: ab_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_user_role_id_seq OWNED BY public.ab_user_role.id;


--
-- Name: ab_view_menu; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.ab_view_menu (
    id integer NOT NULL,
    name character varying(250) NOT NULL
);


ALTER TABLE public.ab_view_menu OWNER TO etl_user;

--
-- Name: ab_view_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.ab_view_menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_view_menu_id_seq OWNER TO etl_user;

--
-- Name: ab_view_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.ab_view_menu_id_seq OWNED BY public.ab_view_menu.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO etl_user;

--
-- Name: callback_request; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.callback_request (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    priority_weight integer NOT NULL,
    callback_data json NOT NULL,
    callback_type character varying(20) NOT NULL,
    processor_subdir character varying(2000)
);


ALTER TABLE public.callback_request OWNER TO etl_user;

--
-- Name: callback_request_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.callback_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.callback_request_id_seq OWNER TO etl_user;

--
-- Name: callback_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.callback_request_id_seq OWNED BY public.callback_request.id;


--
-- Name: connection; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.connection (
    id integer NOT NULL,
    conn_id character varying(250) NOT NULL,
    conn_type character varying(500) NOT NULL,
    description text,
    host character varying(500),
    schema character varying(500),
    login text,
    password text,
    port integer,
    is_encrypted boolean,
    is_extra_encrypted boolean,
    extra text
);


ALTER TABLE public.connection OWNER TO etl_user;

--
-- Name: connection_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.connection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.connection_id_seq OWNER TO etl_user;

--
-- Name: connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.connection_id_seq OWNED BY public.connection.id;


--
-- Name: dag; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag (
    dag_id character varying(250) NOT NULL,
    root_dag_id character varying(250),
    is_paused boolean,
    is_subdag boolean,
    is_active boolean,
    last_parsed_time timestamp with time zone,
    last_pickled timestamp with time zone,
    last_expired timestamp with time zone,
    scheduler_lock boolean,
    pickle_id integer,
    fileloc character varying(2000),
    processor_subdir character varying(2000),
    owners character varying(2000),
    description text,
    default_view character varying(25),
    schedule_interval text,
    timetable_description character varying(1000),
    max_active_tasks integer NOT NULL,
    max_active_runs integer,
    has_task_concurrency_limits boolean NOT NULL,
    has_import_errors boolean DEFAULT false,
    next_dagrun timestamp with time zone,
    next_dagrun_data_interval_start timestamp with time zone,
    next_dagrun_data_interval_end timestamp with time zone,
    next_dagrun_create_after timestamp with time zone
);


ALTER TABLE public.dag OWNER TO etl_user;

--
-- Name: dag_code; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_code (
    fileloc_hash bigint NOT NULL,
    fileloc character varying(2000) NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    source_code text NOT NULL
);


ALTER TABLE public.dag_code OWNER TO etl_user;

--
-- Name: dag_owner_attributes; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_owner_attributes (
    dag_id character varying(250) NOT NULL,
    owner character varying(500) NOT NULL,
    link character varying(500) NOT NULL
);


ALTER TABLE public.dag_owner_attributes OWNER TO etl_user;

--
-- Name: dag_pickle; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_pickle (
    id integer NOT NULL,
    pickle bytea,
    created_dttm timestamp with time zone,
    pickle_hash bigint
);


ALTER TABLE public.dag_pickle OWNER TO etl_user;

--
-- Name: dag_pickle_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.dag_pickle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dag_pickle_id_seq OWNER TO etl_user;

--
-- Name: dag_pickle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.dag_pickle_id_seq OWNED BY public.dag_pickle.id;


--
-- Name: dag_run; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_run (
    id integer NOT NULL,
    dag_id character varying(250) NOT NULL,
    queued_at timestamp with time zone,
    execution_date timestamp with time zone NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    state character varying(50),
    run_id character varying(250) NOT NULL,
    creating_job_id integer,
    external_trigger boolean,
    run_type character varying(50) NOT NULL,
    conf bytea,
    data_interval_start timestamp with time zone,
    data_interval_end timestamp with time zone,
    last_scheduling_decision timestamp with time zone,
    dag_hash character varying(32),
    log_template_id integer,
    updated_at timestamp with time zone,
    clear_number integer NOT NULL
);


ALTER TABLE public.dag_run OWNER TO etl_user;

--
-- Name: dag_run_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.dag_run_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dag_run_id_seq OWNER TO etl_user;

--
-- Name: dag_run_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.dag_run_id_seq OWNED BY public.dag_run.id;


--
-- Name: dag_run_note; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_run_note (
    user_id integer,
    dag_run_id integer NOT NULL,
    content character varying(1000),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dag_run_note OWNER TO etl_user;

--
-- Name: dag_schedule_dataset_reference; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_schedule_dataset_reference (
    dataset_id integer NOT NULL,
    dag_id character varying(250) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dag_schedule_dataset_reference OWNER TO etl_user;

--
-- Name: dag_tag; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_tag (
    name character varying(100) NOT NULL,
    dag_id character varying(250) NOT NULL
);


ALTER TABLE public.dag_tag OWNER TO etl_user;

--
-- Name: dag_warning; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dag_warning (
    dag_id character varying(250) NOT NULL,
    warning_type character varying(50) NOT NULL,
    message text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.dag_warning OWNER TO etl_user;

--
-- Name: dagrun_dataset_event; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dagrun_dataset_event (
    dag_run_id integer NOT NULL,
    event_id integer NOT NULL
);


ALTER TABLE public.dagrun_dataset_event OWNER TO etl_user;

--
-- Name: dataset; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dataset (
    id integer NOT NULL,
    uri character varying(3000) NOT NULL,
    extra json NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    is_orphaned boolean DEFAULT false NOT NULL
);


ALTER TABLE public.dataset OWNER TO etl_user;

--
-- Name: dataset_dag_run_queue; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dataset_dag_run_queue (
    dataset_id integer NOT NULL,
    target_dag_id character varying(250) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dataset_dag_run_queue OWNER TO etl_user;

--
-- Name: dataset_event; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.dataset_event (
    id integer NOT NULL,
    dataset_id integer NOT NULL,
    extra json NOT NULL,
    source_task_id character varying(250),
    source_dag_id character varying(250),
    source_run_id character varying(250),
    source_map_index integer DEFAULT '-1'::integer,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.dataset_event OWNER TO etl_user;

--
-- Name: dataset_event_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.dataset_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dataset_event_id_seq OWNER TO etl_user;

--
-- Name: dataset_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.dataset_event_id_seq OWNED BY public.dataset_event.id;


--
-- Name: dataset_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.dataset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dataset_id_seq OWNER TO etl_user;

--
-- Name: dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.dataset_id_seq OWNED BY public.dataset.id;


--
-- Name: import_error; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.import_error (
    id integer NOT NULL,
    "timestamp" timestamp with time zone,
    filename character varying(1024),
    stacktrace text,
    processor_subdir character varying(2000)
);


ALTER TABLE public.import_error OWNER TO etl_user;

--
-- Name: import_error_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.import_error_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.import_error_id_seq OWNER TO etl_user;

--
-- Name: import_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.import_error_id_seq OWNED BY public.import_error.id;


--
-- Name: job; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.job (
    id integer NOT NULL,
    dag_id character varying(250),
    state character varying(20),
    job_type character varying(30),
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    latest_heartbeat timestamp with time zone,
    executor_class character varying(500),
    hostname character varying(500),
    unixname character varying(1000)
);


ALTER TABLE public.job OWNER TO etl_user;

--
-- Name: job_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_id_seq OWNER TO etl_user;

--
-- Name: job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.job_id_seq OWNED BY public.job.id;


--
-- Name: log; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.log (
    id integer NOT NULL,
    dttm timestamp with time zone,
    dag_id character varying(250),
    task_id character varying(250),
    map_index integer,
    event character varying(30),
    execution_date timestamp with time zone,
    owner character varying(500),
    owner_display_name character varying(500),
    extra text
);


ALTER TABLE public.log OWNER TO etl_user;

--
-- Name: log_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_id_seq OWNER TO etl_user;

--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.log_id_seq OWNED BY public.log.id;


--
-- Name: log_template; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.log_template (
    id integer NOT NULL,
    filename text NOT NULL,
    elasticsearch_id text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.log_template OWNER TO etl_user;

--
-- Name: log_template_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.log_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_template_id_seq OWNER TO etl_user;

--
-- Name: log_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.log_template_id_seq OWNED BY public.log_template.id;


--
-- Name: rendered_task_instance_fields; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.rendered_task_instance_fields (
    dag_id character varying(250) NOT NULL,
    task_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    rendered_fields json NOT NULL,
    k8s_pod_yaml json
);


ALTER TABLE public.rendered_task_instance_fields OWNER TO etl_user;

--
-- Name: serialized_dag; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.serialized_dag (
    dag_id character varying(250) NOT NULL,
    fileloc character varying(2000) NOT NULL,
    fileloc_hash bigint NOT NULL,
    data json,
    data_compressed bytea,
    last_updated timestamp with time zone NOT NULL,
    dag_hash character varying(32) NOT NULL,
    processor_subdir character varying(2000)
);


ALTER TABLE public.serialized_dag OWNER TO etl_user;

--
-- Name: session; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.session (
    id integer NOT NULL,
    session_id character varying(255),
    data bytea,
    expiry timestamp without time zone
);


ALTER TABLE public.session OWNER TO etl_user;

--
-- Name: session_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.session_id_seq OWNER TO etl_user;

--
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.session_id_seq OWNED BY public.session.id;


--
-- Name: sla_miss; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.sla_miss (
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    execution_date timestamp with time zone NOT NULL,
    email_sent boolean,
    "timestamp" timestamp with time zone,
    description text,
    notification_sent boolean
);


ALTER TABLE public.sla_miss OWNER TO etl_user;

--
-- Name: slot_pool; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.slot_pool (
    id integer NOT NULL,
    pool character varying(256),
    slots integer,
    description text,
    include_deferred boolean NOT NULL
);


ALTER TABLE public.slot_pool OWNER TO etl_user;

--
-- Name: slot_pool_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.slot_pool_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.slot_pool_id_seq OWNER TO etl_user;

--
-- Name: slot_pool_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.slot_pool_id_seq OWNED BY public.slot_pool.id;


--
-- Name: task_fail; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.task_fail (
    id integer NOT NULL,
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    duration integer
);


ALTER TABLE public.task_fail OWNER TO etl_user;

--
-- Name: task_fail_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.task_fail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_fail_id_seq OWNER TO etl_user;

--
-- Name: task_fail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.task_fail_id_seq OWNED BY public.task_fail.id;


--
-- Name: task_instance; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.task_instance (
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    duration double precision,
    state character varying(20),
    try_number integer,
    max_tries integer DEFAULT '-1'::integer,
    hostname character varying(1000),
    unixname character varying(1000),
    job_id integer,
    pool character varying(256) NOT NULL,
    pool_slots integer NOT NULL,
    queue character varying(256),
    priority_weight integer,
    operator character varying(1000),
    custom_operator_name character varying(1000),
    queued_dttm timestamp with time zone,
    queued_by_job_id integer,
    pid integer,
    executor_config bytea,
    updated_at timestamp with time zone,
    external_executor_id character varying(250),
    trigger_id integer,
    trigger_timeout timestamp without time zone,
    next_method character varying(1000),
    next_kwargs json
);


ALTER TABLE public.task_instance OWNER TO etl_user;

--
-- Name: task_instance_note; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.task_instance_note (
    user_id integer,
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer NOT NULL,
    content character varying(1000),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.task_instance_note OWNER TO etl_user;

--
-- Name: task_map; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.task_map (
    dag_id character varying(250) NOT NULL,
    task_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer NOT NULL,
    length integer NOT NULL,
    keys json,
    CONSTRAINT ck_task_map_task_map_length_not_negative CHECK ((length >= 0))
);


ALTER TABLE public.task_map OWNER TO etl_user;

--
-- Name: task_outlet_dataset_reference; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.task_outlet_dataset_reference (
    dataset_id integer NOT NULL,
    dag_id character varying(250) NOT NULL,
    task_id character varying(250) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.task_outlet_dataset_reference OWNER TO etl_user;

--
-- Name: task_reschedule; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.task_reschedule (
    id integer NOT NULL,
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    try_number integer NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    reschedule_date timestamp with time zone NOT NULL
);


ALTER TABLE public.task_reschedule OWNER TO etl_user;

--
-- Name: task_reschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.task_reschedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_reschedule_id_seq OWNER TO etl_user;

--
-- Name: task_reschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.task_reschedule_id_seq OWNED BY public.task_reschedule.id;


--
-- Name: trigger; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.trigger (
    id integer NOT NULL,
    classpath character varying(1000) NOT NULL,
    kwargs json NOT NULL,
    created_date timestamp with time zone NOT NULL,
    triggerer_id integer
);


ALTER TABLE public.trigger OWNER TO etl_user;

--
-- Name: trigger_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.trigger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trigger_id_seq OWNER TO etl_user;

--
-- Name: trigger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.trigger_id_seq OWNED BY public.trigger.id;


--
-- Name: variable; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.variable (
    id integer NOT NULL,
    key character varying(250),
    val text,
    description text,
    is_encrypted boolean
);


ALTER TABLE public.variable OWNER TO etl_user;

--
-- Name: variable_id_seq; Type: SEQUENCE; Schema: public; Owner: etl_user
--

CREATE SEQUENCE public.variable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.variable_id_seq OWNER TO etl_user;

--
-- Name: variable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etl_user
--

ALTER SEQUENCE public.variable_id_seq OWNED BY public.variable.id;


--
-- Name: xcom; Type: TABLE; Schema: public; Owner: etl_user
--

CREATE TABLE public.xcom (
    dag_run_id integer NOT NULL,
    task_id character varying(250) NOT NULL,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    key character varying(512) NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    value bytea,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.xcom OWNER TO etl_user;

--
-- Name: dim_cor_raca; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.dim_cor_raca (
    cor_raca_codigo text,
    cor_raca_descricao text
);


ALTER TABLE silver.dim_cor_raca OWNER TO etl_user;

--
-- Name: dim_nivel_instrucao; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.dim_nivel_instrucao (
    nivel_codigo text,
    nivel_descricao text
);


ALTER TABLE silver.dim_nivel_instrucao OWNER TO etl_user;

--
-- Name: dim_sexo; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.dim_sexo (
    sexo_codigo text,
    sexo_descricao text
);


ALTER TABLE silver.dim_sexo OWNER TO etl_user;

--
-- Name: dim_uf; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.dim_uf (
    uf text,
    regiao text,
    nome_uf text
);


ALTER TABLE silver.dim_uf OWNER TO etl_user;

--
-- Name: fato_caracteristicas_domicilio; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.fato_caracteristicas_domicilio (
    caracteristica text,
    nao_possui_percentual text,
    possui_percentual text,
    recorte_geografico text,
    ano bigint
);


ALTER TABLE silver.fato_caracteristicas_domicilio OWNER TO etl_user;

--
-- Name: fato_crescimento_populacional; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.fato_crescimento_populacional (
    ano_pesquisa bigint,
    populacao_pessoas bigint,
    recorte_geografico text,
    crescimento_anual double precision,
    taxa_crescimento double precision
);


ALTER TABLE silver.fato_crescimento_populacional OWNER TO etl_user;

--
-- Name: fato_demografico; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.fato_demografico (
    id integer NOT NULL,
    sexo_codigo character varying(1),
    cor_raca_codigo character varying(1),
    nivel_instrucao_codigo character varying(1),
    populacao_pessoas bigint,
    percentual numeric(5,2),
    ano integer,
    recorte_geografico character varying(50)
);


ALTER TABLE silver.fato_demografico OWNER TO etl_user;

--
-- Name: fato_demografico_id_seq; Type: SEQUENCE; Schema: silver; Owner: etl_user
--

CREATE SEQUENCE silver.fato_demografico_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE silver.fato_demografico_id_seq OWNER TO etl_user;

--
-- Name: fato_demografico_id_seq; Type: SEQUENCE OWNED BY; Schema: silver; Owner: etl_user
--

ALTER SEQUENCE silver.fato_demografico_id_seq OWNED BY silver.fato_demografico.id;


--
-- Name: fato_territorio; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.fato_territorio (
    ano_pesquisa bigint,
    area_km2 text,
    densidade_demografica text,
    recorte_geografico text
);


ALTER TABLE silver.fato_territorio OWNER TO etl_user;

--
-- Name: fato_trabalho; Type: TABLE; Schema: silver; Owner: etl_user
--

CREATE TABLE silver.fato_trabalho (
    uf text,
    cod_municipio text,
    sexo text,
    raca_cor text,
    faixa_rendimento_sm text,
    rendimento_mensal_nominal double precision,
    populacao_ocupada bigint,
    ano bigint
);


ALTER TABLE silver.fato_trabalho OWNER TO etl_user;

--
-- Name: dim_demografica id; Type: DEFAULT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.dim_demografica ALTER COLUMN id SET DEFAULT nextval('gold.dim_demografica_id_seq'::regclass);


--
-- Name: fato_crescimento_desenvolvimento id; Type: DEFAULT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.fato_crescimento_desenvolvimento ALTER COLUMN id SET DEFAULT nextval('gold.fato_crescimento_desenvolvimento_id_seq'::regclass);


--
-- Name: fato_indicadores_demograficos id; Type: DEFAULT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.fato_indicadores_demograficos ALTER COLUMN id SET DEFAULT nextval('gold.fato_indicadores_demograficos_id_seq'::regclass);


--
-- Name: fato_qualidade_vida id; Type: DEFAULT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.fato_qualidade_vida ALTER COLUMN id SET DEFAULT nextval('gold.fato_qualidade_vida_id_seq'::regclass);


--
-- Name: ab_permission id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission ALTER COLUMN id SET DEFAULT nextval('public.ab_permission_id_seq'::regclass);


--
-- Name: ab_permission_view id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view ALTER COLUMN id SET DEFAULT nextval('public.ab_permission_view_id_seq'::regclass);


--
-- Name: ab_permission_view_role id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view_role ALTER COLUMN id SET DEFAULT nextval('public.ab_permission_view_role_id_seq'::regclass);


--
-- Name: ab_register_user id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_register_user ALTER COLUMN id SET DEFAULT nextval('public.ab_register_user_id_seq'::regclass);


--
-- Name: ab_role id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_role ALTER COLUMN id SET DEFAULT nextval('public.ab_role_id_seq'::regclass);


--
-- Name: ab_user id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user ALTER COLUMN id SET DEFAULT nextval('public.ab_user_id_seq'::regclass);


--
-- Name: ab_user_role id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user_role ALTER COLUMN id SET DEFAULT nextval('public.ab_user_role_id_seq'::regclass);


--
-- Name: ab_view_menu id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_view_menu ALTER COLUMN id SET DEFAULT nextval('public.ab_view_menu_id_seq'::regclass);


--
-- Name: callback_request id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.callback_request ALTER COLUMN id SET DEFAULT nextval('public.callback_request_id_seq'::regclass);


--
-- Name: connection id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.connection ALTER COLUMN id SET DEFAULT nextval('public.connection_id_seq'::regclass);


--
-- Name: dag_pickle id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_pickle ALTER COLUMN id SET DEFAULT nextval('public.dag_pickle_id_seq'::regclass);


--
-- Name: dag_run id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run ALTER COLUMN id SET DEFAULT nextval('public.dag_run_id_seq'::regclass);


--
-- Name: dataset id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dataset ALTER COLUMN id SET DEFAULT nextval('public.dataset_id_seq'::regclass);


--
-- Name: dataset_event id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dataset_event ALTER COLUMN id SET DEFAULT nextval('public.dataset_event_id_seq'::regclass);


--
-- Name: import_error id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.import_error ALTER COLUMN id SET DEFAULT nextval('public.import_error_id_seq'::regclass);


--
-- Name: job id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.job ALTER COLUMN id SET DEFAULT nextval('public.job_id_seq'::regclass);


--
-- Name: log id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.log ALTER COLUMN id SET DEFAULT nextval('public.log_id_seq'::regclass);


--
-- Name: log_template id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.log_template ALTER COLUMN id SET DEFAULT nextval('public.log_template_id_seq'::regclass);


--
-- Name: session id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.session ALTER COLUMN id SET DEFAULT nextval('public.session_id_seq'::regclass);


--
-- Name: slot_pool id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.slot_pool ALTER COLUMN id SET DEFAULT nextval('public.slot_pool_id_seq'::regclass);


--
-- Name: task_fail id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_fail ALTER COLUMN id SET DEFAULT nextval('public.task_fail_id_seq'::regclass);


--
-- Name: task_reschedule id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_reschedule ALTER COLUMN id SET DEFAULT nextval('public.task_reschedule_id_seq'::regclass);


--
-- Name: trigger id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.trigger ALTER COLUMN id SET DEFAULT nextval('public.trigger_id_seq'::regclass);


--
-- Name: variable id; Type: DEFAULT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.variable ALTER COLUMN id SET DEFAULT nextval('public.variable_id_seq'::regclass);


--
-- Name: fato_demografico id; Type: DEFAULT; Schema: silver; Owner: etl_user
--

ALTER TABLE ONLY silver.fato_demografico ALTER COLUMN id SET DEFAULT nextval('silver.fato_demografico_id_seq'::regclass);


--
-- Data for Name: caracteristicas_domicilios; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.caracteristicas_domicilios (caracteristica, nao_possui_percentual, possui_percentual, recorte_geografico, ano) FROM stdin;
Conectados à rede de esgoto	\N	\N	Brasil	2022
Abastecidos pela rede geral de água	\N	\N	Brasil	2022
Têm banheiro de uso exclusivo	\N	\N	Brasil	2022
Têm coleta de lixo	\N	\N	Brasil	2022
\.


--
-- Data for Name: censo_trabalhadores; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.censo_trabalhadores (uf, cod_municipio, sexo, raca_cor, faixa_rendimento_sm, rendimento_mensal_nominal, populacao_ocupada, ano) FROM stdin;
AC	0000000	M	B	ate_1sm	520.8	213246	2022
AC	0000000	M	P	ate_1sm	390.6	223164	2022
AC	0000000	M	N	ate_1sm	390.6	49592	2022
AC	0000000	M	A	ate_1sm	520.8	4959	2022
AC	0000000	M	I	ate_1sm	520.8	4959	2022
AC	0000000	F	B	ate_1sm	416.64	174474	2022
AC	0000000	F	P	ate_1sm	312.48	182589	2022
AC	0000000	F	N	ate_1sm	312.48	40575	2022
AC	0000000	F	A	ate_1sm	416.64	4057	2022
AC	0000000	F	I	ate_1sm	416.64	4057	2022
AC	0000000	M	B	1_a_2sm	1562.4	144085	2022
AC	0000000	M	P	1_a_2sm	1171.8	150787	2022
AC	0000000	M	N	1_a_2sm	1171.8	33508	2022
AC	0000000	M	A	1_a_2sm	1562.4	3350	2022
AC	0000000	M	I	1_a_2sm	1562.4	3350	2022
AC	0000000	F	B	1_a_2sm	1249.92	117887	2022
AC	0000000	F	P	1_a_2sm	937.44	123371	2022
AC	0000000	F	N	1_a_2sm	937.44	27415	2022
AC	0000000	F	A	1_a_2sm	1249.92	2741	2022
AC	0000000	F	I	1_a_2sm	1249.92	2741	2022
AC	0000000	M	B	2_a_5sm	3645.6	103741	2022
AC	0000000	M	P	2_a_5sm	2734.2	108566	2022
AC	0000000	M	N	2_a_5sm	2734.2	24125	2022
AC	0000000	M	A	2_a_5sm	3645.6	2412	2022
AC	0000000	M	I	2_a_5sm	3645.6	2412	2022
AC	0000000	F	B	2_a_5sm	2916.48	84879	2022
AC	0000000	F	P	2_a_5sm	2187.36	88827	2022
AC	0000000	F	N	2_a_5sm	2187.36	19739	2022
AC	0000000	F	A	2_a_5sm	2916.48	1973	2022
AC	0000000	F	I	2_a_5sm	2916.48	1973	2022
AC	0000000	M	B	5_a_20sm	13020	86451	2022
AC	0000000	M	P	5_a_20sm	9765	90472	2022
AC	0000000	M	N	5_a_20sm	9765	20104	2022
AC	0000000	M	A	5_a_20sm	13020	2010	2022
AC	0000000	M	I	5_a_20sm	13020	2010	2022
AC	0000000	F	B	5_a_20sm	10416	70732	2022
AC	0000000	F	P	5_a_20sm	7812	74022	2022
AC	0000000	F	N	5_a_20sm	7812	16449	2022
AC	0000000	F	A	5_a_20sm	10416	1644	2022
AC	0000000	F	I	5_a_20sm	10416	1644	2022
AC	0000000	M	B	mais_20sm	36456	28816	2022
AC	0000000	M	P	mais_20sm	27342	30157	2022
AC	0000000	M	N	mais_20sm	27342	6701	2022
AC	0000000	M	A	mais_20sm	36456	670	2022
AC	0000000	M	I	mais_20sm	36456	670	2022
AC	0000000	F	B	mais_20sm	29164.8	23577	2022
AC	0000000	F	P	mais_20sm	21873.6	24673	2022
AC	0000000	F	N	mais_20sm	21873.6	5483	2022
AC	0000000	F	A	mais_20sm	29164.8	548	2022
AC	0000000	F	I	mais_20sm	29164.8	548	2022
AM	0000000	M	B	ate_1sm	520.8	213246	2022
AM	0000000	M	P	ate_1sm	390.6	223164	2022
AM	0000000	M	N	ate_1sm	390.6	49592	2022
AM	0000000	M	A	ate_1sm	520.8	4959	2022
AM	0000000	M	I	ate_1sm	520.8	4959	2022
AM	0000000	F	B	ate_1sm	416.64	174474	2022
AM	0000000	F	P	ate_1sm	312.48	182589	2022
AM	0000000	F	N	ate_1sm	312.48	40575	2022
AM	0000000	F	A	ate_1sm	416.64	4057	2022
AM	0000000	F	I	ate_1sm	416.64	4057	2022
AM	0000000	M	B	1_a_2sm	1562.4	144085	2022
AM	0000000	M	P	1_a_2sm	1171.8	150787	2022
AM	0000000	M	N	1_a_2sm	1171.8	33508	2022
AM	0000000	M	A	1_a_2sm	1562.4	3350	2022
AM	0000000	M	I	1_a_2sm	1562.4	3350	2022
AM	0000000	F	B	1_a_2sm	1249.92	117887	2022
AM	0000000	F	P	1_a_2sm	937.44	123371	2022
AM	0000000	F	N	1_a_2sm	937.44	27415	2022
AM	0000000	F	A	1_a_2sm	1249.92	2741	2022
AM	0000000	F	I	1_a_2sm	1249.92	2741	2022
AM	0000000	M	B	2_a_5sm	3645.6	103741	2022
AM	0000000	M	P	2_a_5sm	2734.2	108566	2022
AM	0000000	M	N	2_a_5sm	2734.2	24125	2022
AM	0000000	M	A	2_a_5sm	3645.6	2412	2022
AM	0000000	M	I	2_a_5sm	3645.6	2412	2022
AM	0000000	F	B	2_a_5sm	2916.48	84879	2022
AM	0000000	F	P	2_a_5sm	2187.36	88827	2022
AM	0000000	F	N	2_a_5sm	2187.36	19739	2022
AM	0000000	F	A	2_a_5sm	2916.48	1973	2022
AM	0000000	F	I	2_a_5sm	2916.48	1973	2022
AM	0000000	M	B	5_a_20sm	13020	86451	2022
AM	0000000	M	P	5_a_20sm	9765	90472	2022
AM	0000000	M	N	5_a_20sm	9765	20104	2022
AM	0000000	M	A	5_a_20sm	13020	2010	2022
AM	0000000	M	I	5_a_20sm	13020	2010	2022
AM	0000000	F	B	5_a_20sm	10416	70732	2022
AM	0000000	F	P	5_a_20sm	7812	74022	2022
AM	0000000	F	N	5_a_20sm	7812	16449	2022
AM	0000000	F	A	5_a_20sm	10416	1644	2022
AM	0000000	F	I	5_a_20sm	10416	1644	2022
AM	0000000	M	B	mais_20sm	36456	28816	2022
AM	0000000	M	P	mais_20sm	27342	30157	2022
AM	0000000	M	N	mais_20sm	27342	6701	2022
AM	0000000	M	A	mais_20sm	36456	670	2022
AM	0000000	M	I	mais_20sm	36456	670	2022
AM	0000000	F	B	mais_20sm	29164.8	23577	2022
AM	0000000	F	P	mais_20sm	21873.6	24673	2022
AM	0000000	F	N	mais_20sm	21873.6	5483	2022
AM	0000000	F	A	mais_20sm	29164.8	548	2022
AM	0000000	F	I	mais_20sm	29164.8	548	2022
AP	0000000	M	B	ate_1sm	520.8	213246	2022
AP	0000000	M	P	ate_1sm	390.6	223164	2022
AP	0000000	M	N	ate_1sm	390.6	49592	2022
AP	0000000	M	A	ate_1sm	520.8	4959	2022
AP	0000000	M	I	ate_1sm	520.8	4959	2022
AP	0000000	F	B	ate_1sm	416.64	174474	2022
AP	0000000	F	P	ate_1sm	312.48	182589	2022
AP	0000000	F	N	ate_1sm	312.48	40575	2022
AP	0000000	F	A	ate_1sm	416.64	4057	2022
AP	0000000	F	I	ate_1sm	416.64	4057	2022
AP	0000000	M	B	1_a_2sm	1562.4	144085	2022
AP	0000000	M	P	1_a_2sm	1171.8	150787	2022
AP	0000000	M	N	1_a_2sm	1171.8	33508	2022
AP	0000000	M	A	1_a_2sm	1562.4	3350	2022
AP	0000000	M	I	1_a_2sm	1562.4	3350	2022
AP	0000000	F	B	1_a_2sm	1249.92	117887	2022
AP	0000000	F	P	1_a_2sm	937.44	123371	2022
AP	0000000	F	N	1_a_2sm	937.44	27415	2022
AP	0000000	F	A	1_a_2sm	1249.92	2741	2022
AP	0000000	F	I	1_a_2sm	1249.92	2741	2022
AP	0000000	M	B	2_a_5sm	3645.6	103741	2022
AP	0000000	M	P	2_a_5sm	2734.2	108566	2022
AP	0000000	M	N	2_a_5sm	2734.2	24125	2022
AP	0000000	M	A	2_a_5sm	3645.6	2412	2022
AP	0000000	M	I	2_a_5sm	3645.6	2412	2022
AP	0000000	F	B	2_a_5sm	2916.48	84879	2022
AP	0000000	F	P	2_a_5sm	2187.36	88827	2022
AP	0000000	F	N	2_a_5sm	2187.36	19739	2022
AP	0000000	F	A	2_a_5sm	2916.48	1973	2022
AP	0000000	F	I	2_a_5sm	2916.48	1973	2022
AP	0000000	M	B	5_a_20sm	13020	86451	2022
AP	0000000	M	P	5_a_20sm	9765	90472	2022
AP	0000000	M	N	5_a_20sm	9765	20104	2022
AP	0000000	M	A	5_a_20sm	13020	2010	2022
AP	0000000	M	I	5_a_20sm	13020	2010	2022
AP	0000000	F	B	5_a_20sm	10416	70732	2022
AP	0000000	F	P	5_a_20sm	7812	74022	2022
AP	0000000	F	N	5_a_20sm	7812	16449	2022
AP	0000000	F	A	5_a_20sm	10416	1644	2022
AP	0000000	F	I	5_a_20sm	10416	1644	2022
AP	0000000	M	B	mais_20sm	36456	28816	2022
AP	0000000	M	P	mais_20sm	27342	30157	2022
AP	0000000	M	N	mais_20sm	27342	6701	2022
AP	0000000	M	A	mais_20sm	36456	670	2022
AP	0000000	M	I	mais_20sm	36456	670	2022
AP	0000000	F	B	mais_20sm	29164.8	23577	2022
AP	0000000	F	P	mais_20sm	21873.6	24673	2022
AP	0000000	F	N	mais_20sm	21873.6	5483	2022
AP	0000000	F	A	mais_20sm	29164.8	548	2022
AP	0000000	F	I	mais_20sm	29164.8	548	2022
PA	0000000	M	B	ate_1sm	520.8	213246	2022
PA	0000000	M	P	ate_1sm	390.6	223164	2022
PA	0000000	M	N	ate_1sm	390.6	49592	2022
PA	0000000	M	A	ate_1sm	520.8	4959	2022
PA	0000000	M	I	ate_1sm	520.8	4959	2022
PA	0000000	F	B	ate_1sm	416.64	174474	2022
PA	0000000	F	P	ate_1sm	312.48	182589	2022
PA	0000000	F	N	ate_1sm	312.48	40575	2022
PA	0000000	F	A	ate_1sm	416.64	4057	2022
PA	0000000	F	I	ate_1sm	416.64	4057	2022
PA	0000000	M	B	1_a_2sm	1562.4	144085	2022
PA	0000000	M	P	1_a_2sm	1171.8	150787	2022
PA	0000000	M	N	1_a_2sm	1171.8	33508	2022
PA	0000000	M	A	1_a_2sm	1562.4	3350	2022
PA	0000000	M	I	1_a_2sm	1562.4	3350	2022
PA	0000000	F	B	1_a_2sm	1249.92	117887	2022
PA	0000000	F	P	1_a_2sm	937.44	123371	2022
PA	0000000	F	N	1_a_2sm	937.44	27415	2022
PA	0000000	F	A	1_a_2sm	1249.92	2741	2022
PA	0000000	F	I	1_a_2sm	1249.92	2741	2022
PA	0000000	M	B	2_a_5sm	3645.6	103741	2022
PA	0000000	M	P	2_a_5sm	2734.2	108566	2022
PA	0000000	M	N	2_a_5sm	2734.2	24125	2022
PA	0000000	M	A	2_a_5sm	3645.6	2412	2022
PA	0000000	M	I	2_a_5sm	3645.6	2412	2022
PA	0000000	F	B	2_a_5sm	2916.48	84879	2022
PA	0000000	F	P	2_a_5sm	2187.36	88827	2022
PA	0000000	F	N	2_a_5sm	2187.36	19739	2022
PA	0000000	F	A	2_a_5sm	2916.48	1973	2022
PA	0000000	F	I	2_a_5sm	2916.48	1973	2022
PA	0000000	M	B	5_a_20sm	13020	86451	2022
PA	0000000	M	P	5_a_20sm	9765	90472	2022
PA	0000000	M	N	5_a_20sm	9765	20104	2022
PA	0000000	M	A	5_a_20sm	13020	2010	2022
PA	0000000	M	I	5_a_20sm	13020	2010	2022
PA	0000000	F	B	5_a_20sm	10416	70732	2022
PA	0000000	F	P	5_a_20sm	7812	74022	2022
PA	0000000	F	N	5_a_20sm	7812	16449	2022
PA	0000000	F	A	5_a_20sm	10416	1644	2022
PA	0000000	F	I	5_a_20sm	10416	1644	2022
PA	0000000	M	B	mais_20sm	36456	28816	2022
PA	0000000	M	P	mais_20sm	27342	30157	2022
PA	0000000	M	N	mais_20sm	27342	6701	2022
PA	0000000	M	A	mais_20sm	36456	670	2022
PA	0000000	M	I	mais_20sm	36456	670	2022
PA	0000000	F	B	mais_20sm	29164.8	23577	2022
PA	0000000	F	P	mais_20sm	21873.6	24673	2022
PA	0000000	F	N	mais_20sm	21873.6	5483	2022
PA	0000000	F	A	mais_20sm	29164.8	548	2022
PA	0000000	F	I	mais_20sm	29164.8	548	2022
RO	0000000	M	B	ate_1sm	520.8	213246	2022
RO	0000000	M	P	ate_1sm	390.6	223164	2022
RO	0000000	M	N	ate_1sm	390.6	49592	2022
RO	0000000	M	A	ate_1sm	520.8	4959	2022
RO	0000000	M	I	ate_1sm	520.8	4959	2022
RO	0000000	F	B	ate_1sm	416.64	174474	2022
RO	0000000	F	P	ate_1sm	312.48	182589	2022
RO	0000000	F	N	ate_1sm	312.48	40575	2022
RO	0000000	F	A	ate_1sm	416.64	4057	2022
RO	0000000	F	I	ate_1sm	416.64	4057	2022
RO	0000000	M	B	1_a_2sm	1562.4	144085	2022
RO	0000000	M	P	1_a_2sm	1171.8	150787	2022
RO	0000000	M	N	1_a_2sm	1171.8	33508	2022
RO	0000000	M	A	1_a_2sm	1562.4	3350	2022
RO	0000000	M	I	1_a_2sm	1562.4	3350	2022
RO	0000000	F	B	1_a_2sm	1249.92	117887	2022
RO	0000000	F	P	1_a_2sm	937.44	123371	2022
RO	0000000	F	N	1_a_2sm	937.44	27415	2022
RO	0000000	F	A	1_a_2sm	1249.92	2741	2022
RO	0000000	F	I	1_a_2sm	1249.92	2741	2022
RO	0000000	M	B	2_a_5sm	3645.6	103741	2022
RO	0000000	M	P	2_a_5sm	2734.2	108566	2022
RO	0000000	M	N	2_a_5sm	2734.2	24125	2022
RO	0000000	M	A	2_a_5sm	3645.6	2412	2022
RO	0000000	M	I	2_a_5sm	3645.6	2412	2022
RO	0000000	F	B	2_a_5sm	2916.48	84879	2022
RO	0000000	F	P	2_a_5sm	2187.36	88827	2022
RO	0000000	F	N	2_a_5sm	2187.36	19739	2022
RO	0000000	F	A	2_a_5sm	2916.48	1973	2022
RO	0000000	F	I	2_a_5sm	2916.48	1973	2022
RO	0000000	M	B	5_a_20sm	13020	86451	2022
RO	0000000	M	P	5_a_20sm	9765	90472	2022
RO	0000000	M	N	5_a_20sm	9765	20104	2022
RO	0000000	M	A	5_a_20sm	13020	2010	2022
RO	0000000	M	I	5_a_20sm	13020	2010	2022
RO	0000000	F	B	5_a_20sm	10416	70732	2022
RO	0000000	F	P	5_a_20sm	7812	74022	2022
RO	0000000	F	N	5_a_20sm	7812	16449	2022
RO	0000000	F	A	5_a_20sm	10416	1644	2022
RO	0000000	F	I	5_a_20sm	10416	1644	2022
RO	0000000	M	B	mais_20sm	36456	28816	2022
RO	0000000	M	P	mais_20sm	27342	30157	2022
RO	0000000	M	N	mais_20sm	27342	6701	2022
RO	0000000	M	A	mais_20sm	36456	670	2022
RO	0000000	M	I	mais_20sm	36456	670	2022
RO	0000000	F	B	mais_20sm	29164.8	23577	2022
RO	0000000	F	P	mais_20sm	21873.6	24673	2022
RO	0000000	F	N	mais_20sm	21873.6	5483	2022
RO	0000000	F	A	mais_20sm	29164.8	548	2022
RO	0000000	F	I	mais_20sm	29164.8	548	2022
RR	0000000	M	B	ate_1sm	520.8	213246	2022
RR	0000000	M	P	ate_1sm	390.6	223164	2022
RR	0000000	M	N	ate_1sm	390.6	49592	2022
RR	0000000	M	A	ate_1sm	520.8	4959	2022
RR	0000000	M	I	ate_1sm	520.8	4959	2022
RR	0000000	F	B	ate_1sm	416.64	174474	2022
RR	0000000	F	P	ate_1sm	312.48	182589	2022
RR	0000000	F	N	ate_1sm	312.48	40575	2022
RR	0000000	F	A	ate_1sm	416.64	4057	2022
RR	0000000	F	I	ate_1sm	416.64	4057	2022
RR	0000000	M	B	1_a_2sm	1562.4	144085	2022
RR	0000000	M	P	1_a_2sm	1171.8	150787	2022
RR	0000000	M	N	1_a_2sm	1171.8	33508	2022
RR	0000000	M	A	1_a_2sm	1562.4	3350	2022
RR	0000000	M	I	1_a_2sm	1562.4	3350	2022
RR	0000000	F	B	1_a_2sm	1249.92	117887	2022
RR	0000000	F	P	1_a_2sm	937.44	123371	2022
RR	0000000	F	N	1_a_2sm	937.44	27415	2022
RR	0000000	F	A	1_a_2sm	1249.92	2741	2022
RR	0000000	F	I	1_a_2sm	1249.92	2741	2022
RR	0000000	M	B	2_a_5sm	3645.6	103741	2022
RR	0000000	M	P	2_a_5sm	2734.2	108566	2022
RR	0000000	M	N	2_a_5sm	2734.2	24125	2022
RR	0000000	M	A	2_a_5sm	3645.6	2412	2022
RR	0000000	M	I	2_a_5sm	3645.6	2412	2022
RR	0000000	F	B	2_a_5sm	2916.48	84879	2022
RR	0000000	F	P	2_a_5sm	2187.36	88827	2022
RR	0000000	F	N	2_a_5sm	2187.36	19739	2022
RR	0000000	F	A	2_a_5sm	2916.48	1973	2022
RR	0000000	F	I	2_a_5sm	2916.48	1973	2022
RR	0000000	M	B	5_a_20sm	13020	86451	2022
RR	0000000	M	P	5_a_20sm	9765	90472	2022
RR	0000000	M	N	5_a_20sm	9765	20104	2022
RR	0000000	M	A	5_a_20sm	13020	2010	2022
RR	0000000	M	I	5_a_20sm	13020	2010	2022
RR	0000000	F	B	5_a_20sm	10416	70732	2022
RR	0000000	F	P	5_a_20sm	7812	74022	2022
RR	0000000	F	N	5_a_20sm	7812	16449	2022
RR	0000000	F	A	5_a_20sm	10416	1644	2022
RR	0000000	F	I	5_a_20sm	10416	1644	2022
RR	0000000	M	B	mais_20sm	36456	28816	2022
RR	0000000	M	P	mais_20sm	27342	30157	2022
RR	0000000	M	N	mais_20sm	27342	6701	2022
RR	0000000	M	A	mais_20sm	36456	670	2022
RR	0000000	M	I	mais_20sm	36456	670	2022
RR	0000000	F	B	mais_20sm	29164.8	23577	2022
RR	0000000	F	P	mais_20sm	21873.6	24673	2022
RR	0000000	F	N	mais_20sm	21873.6	5483	2022
RR	0000000	F	A	mais_20sm	29164.8	548	2022
RR	0000000	F	I	mais_20sm	29164.8	548	2022
TO	0000000	M	B	ate_1sm	520.8	213246	2022
TO	0000000	M	P	ate_1sm	390.6	223164	2022
TO	0000000	M	N	ate_1sm	390.6	49592	2022
TO	0000000	M	A	ate_1sm	520.8	4959	2022
TO	0000000	M	I	ate_1sm	520.8	4959	2022
TO	0000000	F	B	ate_1sm	416.64	174474	2022
TO	0000000	F	P	ate_1sm	312.48	182589	2022
TO	0000000	F	N	ate_1sm	312.48	40575	2022
TO	0000000	F	A	ate_1sm	416.64	4057	2022
TO	0000000	F	I	ate_1sm	416.64	4057	2022
TO	0000000	M	B	1_a_2sm	1562.4	144085	2022
TO	0000000	M	P	1_a_2sm	1171.8	150787	2022
TO	0000000	M	N	1_a_2sm	1171.8	33508	2022
TO	0000000	M	A	1_a_2sm	1562.4	3350	2022
TO	0000000	M	I	1_a_2sm	1562.4	3350	2022
TO	0000000	F	B	1_a_2sm	1249.92	117887	2022
TO	0000000	F	P	1_a_2sm	937.44	123371	2022
TO	0000000	F	N	1_a_2sm	937.44	27415	2022
TO	0000000	F	A	1_a_2sm	1249.92	2741	2022
TO	0000000	F	I	1_a_2sm	1249.92	2741	2022
TO	0000000	M	B	2_a_5sm	3645.6	103741	2022
TO	0000000	M	P	2_a_5sm	2734.2	108566	2022
TO	0000000	M	N	2_a_5sm	2734.2	24125	2022
TO	0000000	M	A	2_a_5sm	3645.6	2412	2022
TO	0000000	M	I	2_a_5sm	3645.6	2412	2022
TO	0000000	F	B	2_a_5sm	2916.48	84879	2022
TO	0000000	F	P	2_a_5sm	2187.36	88827	2022
TO	0000000	F	N	2_a_5sm	2187.36	19739	2022
TO	0000000	F	A	2_a_5sm	2916.48	1973	2022
TO	0000000	F	I	2_a_5sm	2916.48	1973	2022
TO	0000000	M	B	5_a_20sm	13020	86451	2022
TO	0000000	M	P	5_a_20sm	9765	90472	2022
TO	0000000	M	N	5_a_20sm	9765	20104	2022
TO	0000000	M	A	5_a_20sm	13020	2010	2022
TO	0000000	M	I	5_a_20sm	13020	2010	2022
TO	0000000	F	B	5_a_20sm	10416	70732	2022
TO	0000000	F	P	5_a_20sm	7812	74022	2022
TO	0000000	F	N	5_a_20sm	7812	16449	2022
TO	0000000	F	A	5_a_20sm	10416	1644	2022
TO	0000000	F	I	5_a_20sm	10416	1644	2022
TO	0000000	M	B	mais_20sm	36456	28816	2022
TO	0000000	M	P	mais_20sm	27342	30157	2022
TO	0000000	M	N	mais_20sm	27342	6701	2022
TO	0000000	M	A	mais_20sm	36456	670	2022
TO	0000000	M	I	mais_20sm	36456	670	2022
TO	0000000	F	B	mais_20sm	29164.8	23577	2022
TO	0000000	F	P	mais_20sm	21873.6	24673	2022
TO	0000000	F	N	mais_20sm	21873.6	5483	2022
TO	0000000	F	A	mais_20sm	29164.8	548	2022
TO	0000000	F	I	mais_20sm	29164.8	548	2022
AL	0000000	M	B	ate_1sm	520.8	213246	2022
AL	0000000	M	P	ate_1sm	390.6	223164	2022
AL	0000000	M	N	ate_1sm	390.6	49592	2022
AL	0000000	M	A	ate_1sm	520.8	4959	2022
AL	0000000	M	I	ate_1sm	520.8	4959	2022
AL	0000000	F	B	ate_1sm	416.64	174474	2022
AL	0000000	F	P	ate_1sm	312.48	182589	2022
AL	0000000	F	N	ate_1sm	312.48	40575	2022
AL	0000000	F	A	ate_1sm	416.64	4057	2022
AL	0000000	F	I	ate_1sm	416.64	4057	2022
AL	0000000	M	B	1_a_2sm	1562.4	144085	2022
AL	0000000	M	P	1_a_2sm	1171.8	150787	2022
AL	0000000	M	N	1_a_2sm	1171.8	33508	2022
AL	0000000	M	A	1_a_2sm	1562.4	3350	2022
AL	0000000	M	I	1_a_2sm	1562.4	3350	2022
AL	0000000	F	B	1_a_2sm	1249.92	117887	2022
AL	0000000	F	P	1_a_2sm	937.44	123371	2022
AL	0000000	F	N	1_a_2sm	937.44	27415	2022
AL	0000000	F	A	1_a_2sm	1249.92	2741	2022
AL	0000000	F	I	1_a_2sm	1249.92	2741	2022
AL	0000000	M	B	2_a_5sm	3645.6	103741	2022
AL	0000000	M	P	2_a_5sm	2734.2	108566	2022
AL	0000000	M	N	2_a_5sm	2734.2	24125	2022
AL	0000000	M	A	2_a_5sm	3645.6	2412	2022
AL	0000000	M	I	2_a_5sm	3645.6	2412	2022
AL	0000000	F	B	2_a_5sm	2916.48	84879	2022
AL	0000000	F	P	2_a_5sm	2187.36	88827	2022
AL	0000000	F	N	2_a_5sm	2187.36	19739	2022
AL	0000000	F	A	2_a_5sm	2916.48	1973	2022
AL	0000000	F	I	2_a_5sm	2916.48	1973	2022
AL	0000000	M	B	5_a_20sm	13020	86451	2022
AL	0000000	M	P	5_a_20sm	9765	90472	2022
AL	0000000	M	N	5_a_20sm	9765	20104	2022
AL	0000000	M	A	5_a_20sm	13020	2010	2022
AL	0000000	M	I	5_a_20sm	13020	2010	2022
AL	0000000	F	B	5_a_20sm	10416	70732	2022
AL	0000000	F	P	5_a_20sm	7812	74022	2022
AL	0000000	F	N	5_a_20sm	7812	16449	2022
AL	0000000	F	A	5_a_20sm	10416	1644	2022
AL	0000000	F	I	5_a_20sm	10416	1644	2022
AL	0000000	M	B	mais_20sm	36456	28816	2022
AL	0000000	M	P	mais_20sm	27342	30157	2022
AL	0000000	M	N	mais_20sm	27342	6701	2022
AL	0000000	M	A	mais_20sm	36456	670	2022
AL	0000000	M	I	mais_20sm	36456	670	2022
AL	0000000	F	B	mais_20sm	29164.8	23577	2022
AL	0000000	F	P	mais_20sm	21873.6	24673	2022
AL	0000000	F	N	mais_20sm	21873.6	5483	2022
AL	0000000	F	A	mais_20sm	29164.8	548	2022
AL	0000000	F	I	mais_20sm	29164.8	548	2022
BA	0000000	M	B	ate_1sm	520.8	639740	2022
BA	0000000	M	P	ate_1sm	390.6	669496	2022
BA	0000000	M	N	ate_1sm	390.6	148776	2022
BA	0000000	M	A	ate_1sm	520.8	14877	2022
BA	0000000	M	I	ate_1sm	520.8	14877	2022
BA	0000000	F	B	ate_1sm	416.64	523423	2022
BA	0000000	F	P	ate_1sm	312.48	547769	2022
BA	0000000	F	N	ate_1sm	312.48	121726	2022
BA	0000000	F	A	ate_1sm	416.64	12172	2022
BA	0000000	F	I	ate_1sm	416.64	12172	2022
BA	0000000	M	B	1_a_2sm	1562.4	432257	2022
BA	0000000	M	P	1_a_2sm	1171.8	452362	2022
BA	0000000	M	N	1_a_2sm	1171.8	100524	2022
BA	0000000	M	A	1_a_2sm	1562.4	10052	2022
BA	0000000	M	I	1_a_2sm	1562.4	10052	2022
BA	0000000	F	B	1_a_2sm	1249.92	353664	2022
BA	0000000	F	P	1_a_2sm	937.44	370114	2022
BA	0000000	F	N	1_a_2sm	937.44	82247	2022
BA	0000000	F	A	1_a_2sm	1249.92	8224	2022
BA	0000000	F	I	1_a_2sm	1249.92	8224	2022
BA	0000000	M	B	2_a_5sm	3645.6	311224	2022
BA	0000000	M	P	2_a_5sm	2734.2	325700	2022
BA	0000000	M	N	2_a_5sm	2734.2	72377	2022
BA	0000000	M	A	2_a_5sm	3645.6	7237	2022
BA	0000000	M	I	2_a_5sm	3645.6	7237	2022
BA	0000000	F	B	2_a_5sm	2916.48	254638	2022
BA	0000000	F	P	2_a_5sm	2187.36	266482	2022
BA	0000000	F	N	2_a_5sm	2187.36	59218	2022
BA	0000000	F	A	2_a_5sm	2916.48	5921	2022
BA	0000000	F	I	2_a_5sm	2916.48	5921	2022
BA	0000000	M	B	5_a_20sm	13020	259354	2022
BA	0000000	M	P	5_a_20sm	9765	271417	2022
BA	0000000	M	N	5_a_20sm	9765	60314	2022
BA	0000000	M	A	5_a_20sm	13020	6031	2022
BA	0000000	M	I	5_a_20sm	13020	6031	2022
BA	0000000	F	B	5_a_20sm	10416	212198	2022
BA	0000000	F	P	5_a_20sm	7812	222068	2022
BA	0000000	F	N	5_a_20sm	7812	49348	2022
BA	0000000	F	A	5_a_20sm	10416	4934	2022
BA	0000000	F	I	5_a_20sm	10416	4934	2022
BA	0000000	M	B	mais_20sm	36456	86451	2022
BA	0000000	M	P	mais_20sm	27342	90472	2022
BA	0000000	M	N	mais_20sm	27342	20104	2022
BA	0000000	M	A	mais_20sm	36456	2010	2022
BA	0000000	M	I	mais_20sm	36456	2010	2022
BA	0000000	F	B	mais_20sm	29164.8	70732	2022
BA	0000000	F	P	mais_20sm	21873.6	74022	2022
BA	0000000	F	N	mais_20sm	21873.6	16449	2022
BA	0000000	F	A	mais_20sm	29164.8	1644	2022
BA	0000000	F	I	mais_20sm	29164.8	1644	2022
CE	0000000	M	B	ate_1sm	520.8	213246	2022
CE	0000000	M	P	ate_1sm	390.6	223164	2022
CE	0000000	M	N	ate_1sm	390.6	49592	2022
CE	0000000	M	A	ate_1sm	520.8	4959	2022
CE	0000000	M	I	ate_1sm	520.8	4959	2022
CE	0000000	F	B	ate_1sm	416.64	174474	2022
CE	0000000	F	P	ate_1sm	312.48	182589	2022
CE	0000000	F	N	ate_1sm	312.48	40575	2022
CE	0000000	F	A	ate_1sm	416.64	4057	2022
CE	0000000	F	I	ate_1sm	416.64	4057	2022
CE	0000000	M	B	1_a_2sm	1562.4	144085	2022
CE	0000000	M	P	1_a_2sm	1171.8	150787	2022
CE	0000000	M	N	1_a_2sm	1171.8	33508	2022
CE	0000000	M	A	1_a_2sm	1562.4	3350	2022
CE	0000000	M	I	1_a_2sm	1562.4	3350	2022
CE	0000000	F	B	1_a_2sm	1249.92	117887	2022
CE	0000000	F	P	1_a_2sm	937.44	123371	2022
CE	0000000	F	N	1_a_2sm	937.44	27415	2022
CE	0000000	F	A	1_a_2sm	1249.92	2741	2022
CE	0000000	F	I	1_a_2sm	1249.92	2741	2022
CE	0000000	M	B	2_a_5sm	3645.6	103741	2022
CE	0000000	M	P	2_a_5sm	2734.2	108566	2022
CE	0000000	M	N	2_a_5sm	2734.2	24125	2022
CE	0000000	M	A	2_a_5sm	3645.6	2412	2022
CE	0000000	M	I	2_a_5sm	3645.6	2412	2022
CE	0000000	F	B	2_a_5sm	2916.48	84879	2022
CE	0000000	F	P	2_a_5sm	2187.36	88827	2022
CE	0000000	F	N	2_a_5sm	2187.36	19739	2022
CE	0000000	F	A	2_a_5sm	2916.48	1973	2022
CE	0000000	F	I	2_a_5sm	2916.48	1973	2022
CE	0000000	M	B	5_a_20sm	13020	86451	2022
CE	0000000	M	P	5_a_20sm	9765	90472	2022
CE	0000000	M	N	5_a_20sm	9765	20104	2022
CE	0000000	M	A	5_a_20sm	13020	2010	2022
CE	0000000	M	I	5_a_20sm	13020	2010	2022
CE	0000000	F	B	5_a_20sm	10416	70732	2022
CE	0000000	F	P	5_a_20sm	7812	74022	2022
CE	0000000	F	N	5_a_20sm	7812	16449	2022
CE	0000000	F	A	5_a_20sm	10416	1644	2022
CE	0000000	F	I	5_a_20sm	10416	1644	2022
CE	0000000	M	B	mais_20sm	36456	28816	2022
CE	0000000	M	P	mais_20sm	27342	30157	2022
CE	0000000	M	N	mais_20sm	27342	6701	2022
CE	0000000	M	A	mais_20sm	36456	670	2022
CE	0000000	M	I	mais_20sm	36456	670	2022
CE	0000000	F	B	mais_20sm	29164.8	23577	2022
CE	0000000	F	P	mais_20sm	21873.6	24673	2022
CE	0000000	F	N	mais_20sm	21873.6	5483	2022
CE	0000000	F	A	mais_20sm	29164.8	548	2022
CE	0000000	F	I	mais_20sm	29164.8	548	2022
MA	0000000	M	B	ate_1sm	520.8	213246	2022
MA	0000000	M	P	ate_1sm	390.6	223164	2022
MA	0000000	M	N	ate_1sm	390.6	49592	2022
MA	0000000	M	A	ate_1sm	520.8	4959	2022
MA	0000000	M	I	ate_1sm	520.8	4959	2022
MA	0000000	F	B	ate_1sm	416.64	174474	2022
MA	0000000	F	P	ate_1sm	312.48	182589	2022
MA	0000000	F	N	ate_1sm	312.48	40575	2022
MA	0000000	F	A	ate_1sm	416.64	4057	2022
MA	0000000	F	I	ate_1sm	416.64	4057	2022
MA	0000000	M	B	1_a_2sm	1562.4	144085	2022
MA	0000000	M	P	1_a_2sm	1171.8	150787	2022
MA	0000000	M	N	1_a_2sm	1171.8	33508	2022
MA	0000000	M	A	1_a_2sm	1562.4	3350	2022
MA	0000000	M	I	1_a_2sm	1562.4	3350	2022
MA	0000000	F	B	1_a_2sm	1249.92	117887	2022
MA	0000000	F	P	1_a_2sm	937.44	123371	2022
MA	0000000	F	N	1_a_2sm	937.44	27415	2022
MA	0000000	F	A	1_a_2sm	1249.92	2741	2022
MA	0000000	F	I	1_a_2sm	1249.92	2741	2022
MA	0000000	M	B	2_a_5sm	3645.6	103741	2022
MA	0000000	M	P	2_a_5sm	2734.2	108566	2022
MA	0000000	M	N	2_a_5sm	2734.2	24125	2022
MA	0000000	M	A	2_a_5sm	3645.6	2412	2022
MA	0000000	M	I	2_a_5sm	3645.6	2412	2022
MA	0000000	F	B	2_a_5sm	2916.48	84879	2022
MA	0000000	F	P	2_a_5sm	2187.36	88827	2022
MA	0000000	F	N	2_a_5sm	2187.36	19739	2022
MA	0000000	F	A	2_a_5sm	2916.48	1973	2022
MA	0000000	F	I	2_a_5sm	2916.48	1973	2022
MA	0000000	M	B	5_a_20sm	13020	86451	2022
MA	0000000	M	P	5_a_20sm	9765	90472	2022
MA	0000000	M	N	5_a_20sm	9765	20104	2022
MA	0000000	M	A	5_a_20sm	13020	2010	2022
MA	0000000	M	I	5_a_20sm	13020	2010	2022
MA	0000000	F	B	5_a_20sm	10416	70732	2022
MA	0000000	F	P	5_a_20sm	7812	74022	2022
MA	0000000	F	N	5_a_20sm	7812	16449	2022
MA	0000000	F	A	5_a_20sm	10416	1644	2022
MA	0000000	F	I	5_a_20sm	10416	1644	2022
MA	0000000	M	B	mais_20sm	36456	28816	2022
MA	0000000	M	P	mais_20sm	27342	30157	2022
MA	0000000	M	N	mais_20sm	27342	6701	2022
MA	0000000	M	A	mais_20sm	36456	670	2022
MA	0000000	M	I	mais_20sm	36456	670	2022
MA	0000000	F	B	mais_20sm	29164.8	23577	2022
MA	0000000	F	P	mais_20sm	21873.6	24673	2022
MA	0000000	F	N	mais_20sm	21873.6	5483	2022
MA	0000000	F	A	mais_20sm	29164.8	548	2022
MA	0000000	F	I	mais_20sm	29164.8	548	2022
PB	0000000	M	B	ate_1sm	520.8	213246	2022
PB	0000000	M	P	ate_1sm	390.6	223164	2022
PB	0000000	M	N	ate_1sm	390.6	49592	2022
PB	0000000	M	A	ate_1sm	520.8	4959	2022
PB	0000000	M	I	ate_1sm	520.8	4959	2022
PB	0000000	F	B	ate_1sm	416.64	174474	2022
PB	0000000	F	P	ate_1sm	312.48	182589	2022
PB	0000000	F	N	ate_1sm	312.48	40575	2022
PB	0000000	F	A	ate_1sm	416.64	4057	2022
PB	0000000	F	I	ate_1sm	416.64	4057	2022
PB	0000000	M	B	1_a_2sm	1562.4	144085	2022
PB	0000000	M	P	1_a_2sm	1171.8	150787	2022
PB	0000000	M	N	1_a_2sm	1171.8	33508	2022
PB	0000000	M	A	1_a_2sm	1562.4	3350	2022
PB	0000000	M	I	1_a_2sm	1562.4	3350	2022
PB	0000000	F	B	1_a_2sm	1249.92	117887	2022
PB	0000000	F	P	1_a_2sm	937.44	123371	2022
PB	0000000	F	N	1_a_2sm	937.44	27415	2022
PB	0000000	F	A	1_a_2sm	1249.92	2741	2022
PB	0000000	F	I	1_a_2sm	1249.92	2741	2022
PB	0000000	M	B	2_a_5sm	3645.6	103741	2022
PB	0000000	M	P	2_a_5sm	2734.2	108566	2022
PB	0000000	M	N	2_a_5sm	2734.2	24125	2022
PB	0000000	M	A	2_a_5sm	3645.6	2412	2022
PB	0000000	M	I	2_a_5sm	3645.6	2412	2022
PB	0000000	F	B	2_a_5sm	2916.48	84879	2022
PB	0000000	F	P	2_a_5sm	2187.36	88827	2022
PB	0000000	F	N	2_a_5sm	2187.36	19739	2022
PB	0000000	F	A	2_a_5sm	2916.48	1973	2022
PB	0000000	F	I	2_a_5sm	2916.48	1973	2022
PB	0000000	M	B	5_a_20sm	13020	86451	2022
PB	0000000	M	P	5_a_20sm	9765	90472	2022
PB	0000000	M	N	5_a_20sm	9765	20104	2022
PB	0000000	M	A	5_a_20sm	13020	2010	2022
PB	0000000	M	I	5_a_20sm	13020	2010	2022
PB	0000000	F	B	5_a_20sm	10416	70732	2022
PB	0000000	F	P	5_a_20sm	7812	74022	2022
PB	0000000	F	N	5_a_20sm	7812	16449	2022
PB	0000000	F	A	5_a_20sm	10416	1644	2022
PB	0000000	F	I	5_a_20sm	10416	1644	2022
PB	0000000	M	B	mais_20sm	36456	28816	2022
PB	0000000	M	P	mais_20sm	27342	30157	2022
PB	0000000	M	N	mais_20sm	27342	6701	2022
PB	0000000	M	A	mais_20sm	36456	670	2022
PB	0000000	M	I	mais_20sm	36456	670	2022
PB	0000000	F	B	mais_20sm	29164.8	23577	2022
PB	0000000	F	P	mais_20sm	21873.6	24673	2022
PB	0000000	F	N	mais_20sm	21873.6	5483	2022
PB	0000000	F	A	mais_20sm	29164.8	548	2022
PB	0000000	F	I	mais_20sm	29164.8	548	2022
PE	0000000	M	B	ate_1sm	520.8	213246	2022
PE	0000000	M	P	ate_1sm	390.6	223164	2022
PE	0000000	M	N	ate_1sm	390.6	49592	2022
PE	0000000	M	A	ate_1sm	520.8	4959	2022
PE	0000000	M	I	ate_1sm	520.8	4959	2022
PE	0000000	F	B	ate_1sm	416.64	174474	2022
PE	0000000	F	P	ate_1sm	312.48	182589	2022
PE	0000000	F	N	ate_1sm	312.48	40575	2022
PE	0000000	F	A	ate_1sm	416.64	4057	2022
PE	0000000	F	I	ate_1sm	416.64	4057	2022
PE	0000000	M	B	1_a_2sm	1562.4	144085	2022
PE	0000000	M	P	1_a_2sm	1171.8	150787	2022
PE	0000000	M	N	1_a_2sm	1171.8	33508	2022
PE	0000000	M	A	1_a_2sm	1562.4	3350	2022
PE	0000000	M	I	1_a_2sm	1562.4	3350	2022
PE	0000000	F	B	1_a_2sm	1249.92	117887	2022
PE	0000000	F	P	1_a_2sm	937.44	123371	2022
PE	0000000	F	N	1_a_2sm	937.44	27415	2022
PE	0000000	F	A	1_a_2sm	1249.92	2741	2022
PE	0000000	F	I	1_a_2sm	1249.92	2741	2022
PE	0000000	M	B	2_a_5sm	3645.6	103741	2022
PE	0000000	M	P	2_a_5sm	2734.2	108566	2022
PE	0000000	M	N	2_a_5sm	2734.2	24125	2022
PE	0000000	M	A	2_a_5sm	3645.6	2412	2022
PE	0000000	M	I	2_a_5sm	3645.6	2412	2022
PE	0000000	F	B	2_a_5sm	2916.48	84879	2022
PE	0000000	F	P	2_a_5sm	2187.36	88827	2022
PE	0000000	F	N	2_a_5sm	2187.36	19739	2022
PE	0000000	F	A	2_a_5sm	2916.48	1973	2022
PE	0000000	F	I	2_a_5sm	2916.48	1973	2022
PE	0000000	M	B	5_a_20sm	13020	86451	2022
PE	0000000	M	P	5_a_20sm	9765	90472	2022
PE	0000000	M	N	5_a_20sm	9765	20104	2022
PE	0000000	M	A	5_a_20sm	13020	2010	2022
PE	0000000	M	I	5_a_20sm	13020	2010	2022
PE	0000000	F	B	5_a_20sm	10416	70732	2022
PE	0000000	F	P	5_a_20sm	7812	74022	2022
PE	0000000	F	N	5_a_20sm	7812	16449	2022
PE	0000000	F	A	5_a_20sm	10416	1644	2022
PE	0000000	F	I	5_a_20sm	10416	1644	2022
PE	0000000	M	B	mais_20sm	36456	28816	2022
PE	0000000	M	P	mais_20sm	27342	30157	2022
PE	0000000	M	N	mais_20sm	27342	6701	2022
PE	0000000	M	A	mais_20sm	36456	670	2022
PE	0000000	M	I	mais_20sm	36456	670	2022
PE	0000000	F	B	mais_20sm	29164.8	23577	2022
PE	0000000	F	P	mais_20sm	21873.6	24673	2022
PE	0000000	F	N	mais_20sm	21873.6	5483	2022
PE	0000000	F	A	mais_20sm	29164.8	548	2022
PE	0000000	F	I	mais_20sm	29164.8	548	2022
PI	0000000	M	B	ate_1sm	520.8	213246	2022
PI	0000000	M	P	ate_1sm	390.6	223164	2022
PI	0000000	M	N	ate_1sm	390.6	49592	2022
PI	0000000	M	A	ate_1sm	520.8	4959	2022
PI	0000000	M	I	ate_1sm	520.8	4959	2022
PI	0000000	F	B	ate_1sm	416.64	174474	2022
PI	0000000	F	P	ate_1sm	312.48	182589	2022
PI	0000000	F	N	ate_1sm	312.48	40575	2022
PI	0000000	F	A	ate_1sm	416.64	4057	2022
PI	0000000	F	I	ate_1sm	416.64	4057	2022
PI	0000000	M	B	1_a_2sm	1562.4	144085	2022
PI	0000000	M	P	1_a_2sm	1171.8	150787	2022
PI	0000000	M	N	1_a_2sm	1171.8	33508	2022
PI	0000000	M	A	1_a_2sm	1562.4	3350	2022
PI	0000000	M	I	1_a_2sm	1562.4	3350	2022
PI	0000000	F	B	1_a_2sm	1249.92	117887	2022
PI	0000000	F	P	1_a_2sm	937.44	123371	2022
PI	0000000	F	N	1_a_2sm	937.44	27415	2022
PI	0000000	F	A	1_a_2sm	1249.92	2741	2022
PI	0000000	F	I	1_a_2sm	1249.92	2741	2022
PI	0000000	M	B	2_a_5sm	3645.6	103741	2022
PI	0000000	M	P	2_a_5sm	2734.2	108566	2022
PI	0000000	M	N	2_a_5sm	2734.2	24125	2022
PI	0000000	M	A	2_a_5sm	3645.6	2412	2022
PI	0000000	M	I	2_a_5sm	3645.6	2412	2022
PI	0000000	F	B	2_a_5sm	2916.48	84879	2022
PI	0000000	F	P	2_a_5sm	2187.36	88827	2022
PI	0000000	F	N	2_a_5sm	2187.36	19739	2022
PI	0000000	F	A	2_a_5sm	2916.48	1973	2022
PI	0000000	F	I	2_a_5sm	2916.48	1973	2022
PI	0000000	M	B	5_a_20sm	13020	86451	2022
PI	0000000	M	P	5_a_20sm	9765	90472	2022
PI	0000000	M	N	5_a_20sm	9765	20104	2022
PI	0000000	M	A	5_a_20sm	13020	2010	2022
PI	0000000	M	I	5_a_20sm	13020	2010	2022
PI	0000000	F	B	5_a_20sm	10416	70732	2022
PI	0000000	F	P	5_a_20sm	7812	74022	2022
PI	0000000	F	N	5_a_20sm	7812	16449	2022
PI	0000000	F	A	5_a_20sm	10416	1644	2022
PI	0000000	F	I	5_a_20sm	10416	1644	2022
PI	0000000	M	B	mais_20sm	36456	28816	2022
PI	0000000	M	P	mais_20sm	27342	30157	2022
PI	0000000	M	N	mais_20sm	27342	6701	2022
PI	0000000	M	A	mais_20sm	36456	670	2022
PI	0000000	M	I	mais_20sm	36456	670	2022
PI	0000000	F	B	mais_20sm	29164.8	23577	2022
PI	0000000	F	P	mais_20sm	21873.6	24673	2022
PI	0000000	F	N	mais_20sm	21873.6	5483	2022
PI	0000000	F	A	mais_20sm	29164.8	548	2022
PI	0000000	F	I	mais_20sm	29164.8	548	2022
RN	0000000	M	B	ate_1sm	520.8	213246	2022
RN	0000000	M	P	ate_1sm	390.6	223164	2022
RN	0000000	M	N	ate_1sm	390.6	49592	2022
RN	0000000	M	A	ate_1sm	520.8	4959	2022
RN	0000000	M	I	ate_1sm	520.8	4959	2022
RN	0000000	F	B	ate_1sm	416.64	174474	2022
RN	0000000	F	P	ate_1sm	312.48	182589	2022
RN	0000000	F	N	ate_1sm	312.48	40575	2022
RN	0000000	F	A	ate_1sm	416.64	4057	2022
RN	0000000	F	I	ate_1sm	416.64	4057	2022
RN	0000000	M	B	1_a_2sm	1562.4	144085	2022
RN	0000000	M	P	1_a_2sm	1171.8	150787	2022
RN	0000000	M	N	1_a_2sm	1171.8	33508	2022
RN	0000000	M	A	1_a_2sm	1562.4	3350	2022
RN	0000000	M	I	1_a_2sm	1562.4	3350	2022
RN	0000000	F	B	1_a_2sm	1249.92	117887	2022
RN	0000000	F	P	1_a_2sm	937.44	123371	2022
RN	0000000	F	N	1_a_2sm	937.44	27415	2022
RN	0000000	F	A	1_a_2sm	1249.92	2741	2022
RN	0000000	F	I	1_a_2sm	1249.92	2741	2022
RN	0000000	M	B	2_a_5sm	3645.6	103741	2022
RN	0000000	M	P	2_a_5sm	2734.2	108566	2022
RN	0000000	M	N	2_a_5sm	2734.2	24125	2022
RN	0000000	M	A	2_a_5sm	3645.6	2412	2022
RN	0000000	M	I	2_a_5sm	3645.6	2412	2022
RN	0000000	F	B	2_a_5sm	2916.48	84879	2022
RN	0000000	F	P	2_a_5sm	2187.36	88827	2022
RN	0000000	F	N	2_a_5sm	2187.36	19739	2022
RN	0000000	F	A	2_a_5sm	2916.48	1973	2022
RN	0000000	F	I	2_a_5sm	2916.48	1973	2022
RN	0000000	M	B	5_a_20sm	13020	86451	2022
RN	0000000	M	P	5_a_20sm	9765	90472	2022
RN	0000000	M	N	5_a_20sm	9765	20104	2022
RN	0000000	M	A	5_a_20sm	13020	2010	2022
RN	0000000	M	I	5_a_20sm	13020	2010	2022
RN	0000000	F	B	5_a_20sm	10416	70732	2022
RN	0000000	F	P	5_a_20sm	7812	74022	2022
RN	0000000	F	N	5_a_20sm	7812	16449	2022
RN	0000000	F	A	5_a_20sm	10416	1644	2022
RN	0000000	F	I	5_a_20sm	10416	1644	2022
RN	0000000	M	B	mais_20sm	36456	28816	2022
RN	0000000	M	P	mais_20sm	27342	30157	2022
RN	0000000	M	N	mais_20sm	27342	6701	2022
RN	0000000	M	A	mais_20sm	36456	670	2022
RN	0000000	M	I	mais_20sm	36456	670	2022
RN	0000000	F	B	mais_20sm	29164.8	23577	2022
RN	0000000	F	P	mais_20sm	21873.6	24673	2022
RN	0000000	F	N	mais_20sm	21873.6	5483	2022
RN	0000000	F	A	mais_20sm	29164.8	548	2022
RN	0000000	F	I	mais_20sm	29164.8	548	2022
SE	0000000	M	B	ate_1sm	520.8	213246	2022
SE	0000000	M	P	ate_1sm	390.6	223164	2022
SE	0000000	M	N	ate_1sm	390.6	49592	2022
SE	0000000	M	A	ate_1sm	520.8	4959	2022
SE	0000000	M	I	ate_1sm	520.8	4959	2022
SE	0000000	F	B	ate_1sm	416.64	174474	2022
SE	0000000	F	P	ate_1sm	312.48	182589	2022
SE	0000000	F	N	ate_1sm	312.48	40575	2022
SE	0000000	F	A	ate_1sm	416.64	4057	2022
SE	0000000	F	I	ate_1sm	416.64	4057	2022
SE	0000000	M	B	1_a_2sm	1562.4	144085	2022
SE	0000000	M	P	1_a_2sm	1171.8	150787	2022
SE	0000000	M	N	1_a_2sm	1171.8	33508	2022
SE	0000000	M	A	1_a_2sm	1562.4	3350	2022
SE	0000000	M	I	1_a_2sm	1562.4	3350	2022
SE	0000000	F	B	1_a_2sm	1249.92	117887	2022
SE	0000000	F	P	1_a_2sm	937.44	123371	2022
SE	0000000	F	N	1_a_2sm	937.44	27415	2022
SE	0000000	F	A	1_a_2sm	1249.92	2741	2022
SE	0000000	F	I	1_a_2sm	1249.92	2741	2022
SE	0000000	M	B	2_a_5sm	3645.6	103741	2022
SE	0000000	M	P	2_a_5sm	2734.2	108566	2022
SE	0000000	M	N	2_a_5sm	2734.2	24125	2022
SE	0000000	M	A	2_a_5sm	3645.6	2412	2022
SE	0000000	M	I	2_a_5sm	3645.6	2412	2022
SE	0000000	F	B	2_a_5sm	2916.48	84879	2022
SE	0000000	F	P	2_a_5sm	2187.36	88827	2022
SE	0000000	F	N	2_a_5sm	2187.36	19739	2022
SE	0000000	F	A	2_a_5sm	2916.48	1973	2022
SE	0000000	F	I	2_a_5sm	2916.48	1973	2022
SE	0000000	M	B	5_a_20sm	13020	86451	2022
SE	0000000	M	P	5_a_20sm	9765	90472	2022
SE	0000000	M	N	5_a_20sm	9765	20104	2022
SE	0000000	M	A	5_a_20sm	13020	2010	2022
SE	0000000	M	I	5_a_20sm	13020	2010	2022
SE	0000000	F	B	5_a_20sm	10416	70732	2022
SE	0000000	F	P	5_a_20sm	7812	74022	2022
SE	0000000	F	N	5_a_20sm	7812	16449	2022
SE	0000000	F	A	5_a_20sm	10416	1644	2022
SE	0000000	F	I	5_a_20sm	10416	1644	2022
SE	0000000	M	B	mais_20sm	36456	28816	2022
SE	0000000	M	P	mais_20sm	27342	30157	2022
SE	0000000	M	N	mais_20sm	27342	6701	2022
SE	0000000	M	A	mais_20sm	36456	670	2022
SE	0000000	M	I	mais_20sm	36456	670	2022
SE	0000000	F	B	mais_20sm	29164.8	23577	2022
SE	0000000	F	P	mais_20sm	21873.6	24673	2022
SE	0000000	F	N	mais_20sm	21873.6	5483	2022
SE	0000000	F	A	mais_20sm	29164.8	548	2022
SE	0000000	F	I	mais_20sm	29164.8	548	2022
ES	0000000	M	B	ate_1sm	781.2	213246	2022
ES	0000000	M	P	ate_1sm	585.9	223164	2022
ES	0000000	M	N	ate_1sm	585.9	49592	2022
ES	0000000	M	A	ate_1sm	781.2	4959	2022
ES	0000000	M	I	ate_1sm	781.2	4959	2022
ES	0000000	F	B	ate_1sm	624.96	174474	2022
ES	0000000	F	P	ate_1sm	468.72	182589	2022
ES	0000000	F	N	ate_1sm	468.72	40575	2022
ES	0000000	F	A	ate_1sm	624.96	4057	2022
ES	0000000	F	I	ate_1sm	624.96	4057	2022
ES	0000000	M	B	1_a_2sm	2343.6	144085	2022
ES	0000000	M	P	1_a_2sm	1757.7	150787	2022
ES	0000000	M	N	1_a_2sm	1757.7	33508	2022
ES	0000000	M	A	1_a_2sm	2343.6	3350	2022
ES	0000000	M	I	1_a_2sm	2343.6	3350	2022
ES	0000000	F	B	1_a_2sm	1874.88	117887	2022
ES	0000000	F	P	1_a_2sm	1406.16	123371	2022
ES	0000000	F	N	1_a_2sm	1406.16	27415	2022
ES	0000000	F	A	1_a_2sm	1874.88	2741	2022
ES	0000000	F	I	1_a_2sm	1874.88	2741	2022
ES	0000000	M	B	2_a_5sm	5468.4	103741	2022
ES	0000000	M	P	2_a_5sm	4101.3	108566	2022
ES	0000000	M	N	2_a_5sm	4101.3	24125	2022
ES	0000000	M	A	2_a_5sm	5468.4	2412	2022
ES	0000000	M	I	2_a_5sm	5468.4	2412	2022
ES	0000000	F	B	2_a_5sm	4374.72	84879	2022
ES	0000000	F	P	2_a_5sm	3281.04	88827	2022
ES	0000000	F	N	2_a_5sm	3281.04	19739	2022
ES	0000000	F	A	2_a_5sm	4374.72	1973	2022
ES	0000000	F	I	2_a_5sm	4374.72	1973	2022
ES	0000000	M	B	5_a_20sm	19530	86451	2022
ES	0000000	M	P	5_a_20sm	14647.5	90472	2022
ES	0000000	M	N	5_a_20sm	14647.5	20104	2022
ES	0000000	M	A	5_a_20sm	19530	2010	2022
ES	0000000	M	I	5_a_20sm	19530	2010	2022
ES	0000000	F	B	5_a_20sm	15624	70732	2022
ES	0000000	F	P	5_a_20sm	11718	74022	2022
ES	0000000	F	N	5_a_20sm	11718	16449	2022
ES	0000000	F	A	5_a_20sm	15624	1644	2022
ES	0000000	F	I	5_a_20sm	15624	1644	2022
ES	0000000	M	B	mais_20sm	54684	28816	2022
ES	0000000	M	P	mais_20sm	41013	30157	2022
ES	0000000	M	N	mais_20sm	41013	6701	2022
ES	0000000	M	A	mais_20sm	54684	670	2022
ES	0000000	M	I	mais_20sm	54684	670	2022
ES	0000000	F	B	mais_20sm	43747.2	23577	2022
ES	0000000	F	P	mais_20sm	32810.4	24673	2022
ES	0000000	F	N	mais_20sm	32810.4	5483	2022
ES	0000000	F	A	mais_20sm	43747.2	548	2022
ES	0000000	F	I	mais_20sm	43747.2	548	2022
MG	0000000	M	B	ate_1sm	781.2	1066234	2022
MG	0000000	M	P	ate_1sm	585.9	1115826	2022
MG	0000000	M	N	ate_1sm	585.9	247961	2022
MG	0000000	M	A	ate_1sm	781.2	24796	2022
MG	0000000	M	I	ate_1sm	781.2	24796	2022
MG	0000000	F	B	ate_1sm	624.96	872373	2022
MG	0000000	F	P	ate_1sm	468.72	912949	2022
MG	0000000	F	N	ate_1sm	468.72	202877	2022
MG	0000000	F	A	ate_1sm	624.96	20287	2022
MG	0000000	F	I	ate_1sm	624.96	20287	2022
MG	0000000	M	B	1_a_2sm	2343.6	720428	2022
MG	0000000	M	P	1_a_2sm	1757.7	753937	2022
MG	0000000	M	N	1_a_2sm	1757.7	167541	2022
MG	0000000	M	A	1_a_2sm	2343.6	16754	2022
MG	0000000	M	I	1_a_2sm	2343.6	16754	2022
MG	0000000	F	B	1_a_2sm	1874.88	589441	2022
MG	0000000	F	P	1_a_2sm	1406.16	616857	2022
MG	0000000	F	N	1_a_2sm	1406.16	137079	2022
MG	0000000	F	A	1_a_2sm	1874.88	13707	2022
MG	0000000	F	I	1_a_2sm	1874.88	13707	2022
MG	0000000	M	B	2_a_5sm	5468.4	518708	2022
MG	0000000	M	P	2_a_5sm	4101.3	542834	2022
MG	0000000	M	N	2_a_5sm	4101.3	120629	2022
MG	0000000	M	A	2_a_5sm	5468.4	12062	2022
MG	0000000	M	I	2_a_5sm	5468.4	12062	2022
MG	0000000	F	B	2_a_5sm	4374.72	424397	2022
MG	0000000	F	P	2_a_5sm	3281.04	444137	2022
MG	0000000	F	N	2_a_5sm	3281.04	98697	2022
MG	0000000	F	A	2_a_5sm	4374.72	9869	2022
MG	0000000	F	I	2_a_5sm	4374.72	9869	2022
MG	0000000	M	B	5_a_20sm	19530	432257	2022
MG	0000000	M	P	5_a_20sm	14647.5	452362	2022
MG	0000000	M	N	5_a_20sm	14647.5	100524	2022
MG	0000000	M	A	5_a_20sm	19530	10052	2022
MG	0000000	M	I	5_a_20sm	19530	10052	2022
MG	0000000	F	B	5_a_20sm	15624	353664	2022
MG	0000000	F	P	5_a_20sm	11718	370114	2022
MG	0000000	F	N	5_a_20sm	11718	82247	2022
MG	0000000	F	A	5_a_20sm	15624	8224	2022
MG	0000000	F	I	5_a_20sm	15624	8224	2022
MG	0000000	M	B	mais_20sm	54684	144085	2022
MG	0000000	M	P	mais_20sm	41013	150787	2022
MG	0000000	M	N	mais_20sm	41013	33508	2022
MG	0000000	M	A	mais_20sm	54684	3350	2022
MG	0000000	M	I	mais_20sm	54684	3350	2022
MG	0000000	F	B	mais_20sm	43747.2	117887	2022
MG	0000000	F	P	mais_20sm	32810.4	123371	2022
MG	0000000	F	N	mais_20sm	32810.4	27415	2022
MG	0000000	F	A	mais_20sm	43747.2	2741	2022
MG	0000000	F	I	mais_20sm	43747.2	2741	2022
RJ	0000000	M	B	ate_1sm	781.2	1066234	2022
RJ	0000000	M	P	ate_1sm	585.9	1115826	2022
RJ	0000000	M	N	ate_1sm	585.9	247961	2022
RJ	0000000	M	A	ate_1sm	781.2	24796	2022
RJ	0000000	M	I	ate_1sm	781.2	24796	2022
RJ	0000000	F	B	ate_1sm	624.96	872373	2022
RJ	0000000	F	P	ate_1sm	468.72	912949	2022
RJ	0000000	F	N	ate_1sm	468.72	202877	2022
RJ	0000000	F	A	ate_1sm	624.96	20287	2022
RJ	0000000	F	I	ate_1sm	624.96	20287	2022
RJ	0000000	M	B	1_a_2sm	2343.6	720428	2022
RJ	0000000	M	P	1_a_2sm	1757.7	753937	2022
RJ	0000000	M	N	1_a_2sm	1757.7	167541	2022
RJ	0000000	M	A	1_a_2sm	2343.6	16754	2022
RJ	0000000	M	I	1_a_2sm	2343.6	16754	2022
RJ	0000000	F	B	1_a_2sm	1874.88	589441	2022
RJ	0000000	F	P	1_a_2sm	1406.16	616857	2022
RJ	0000000	F	N	1_a_2sm	1406.16	137079	2022
RJ	0000000	F	A	1_a_2sm	1874.88	13707	2022
RJ	0000000	F	I	1_a_2sm	1874.88	13707	2022
RJ	0000000	M	B	2_a_5sm	5468.4	518708	2022
RJ	0000000	M	P	2_a_5sm	4101.3	542834	2022
RJ	0000000	M	N	2_a_5sm	4101.3	120629	2022
RJ	0000000	M	A	2_a_5sm	5468.4	12062	2022
RJ	0000000	M	I	2_a_5sm	5468.4	12062	2022
RJ	0000000	F	B	2_a_5sm	4374.72	424397	2022
RJ	0000000	F	P	2_a_5sm	3281.04	444137	2022
RJ	0000000	F	N	2_a_5sm	3281.04	98697	2022
RJ	0000000	F	A	2_a_5sm	4374.72	9869	2022
RJ	0000000	F	I	2_a_5sm	4374.72	9869	2022
RJ	0000000	M	B	5_a_20sm	19530	432257	2022
RJ	0000000	M	P	5_a_20sm	14647.5	452362	2022
RJ	0000000	M	N	5_a_20sm	14647.5	100524	2022
RJ	0000000	M	A	5_a_20sm	19530	10052	2022
RJ	0000000	M	I	5_a_20sm	19530	10052	2022
RJ	0000000	F	B	5_a_20sm	15624	353664	2022
RJ	0000000	F	P	5_a_20sm	11718	370114	2022
RJ	0000000	F	N	5_a_20sm	11718	82247	2022
RJ	0000000	F	A	5_a_20sm	15624	8224	2022
RJ	0000000	F	I	5_a_20sm	15624	8224	2022
RJ	0000000	M	B	mais_20sm	54684	144085	2022
RJ	0000000	M	P	mais_20sm	41013	150787	2022
RJ	0000000	M	N	mais_20sm	41013	33508	2022
RJ	0000000	M	A	mais_20sm	54684	3350	2022
RJ	0000000	M	I	mais_20sm	54684	3350	2022
RJ	0000000	F	B	mais_20sm	43747.2	117887	2022
RJ	0000000	F	P	mais_20sm	32810.4	123371	2022
RJ	0000000	F	N	mais_20sm	32810.4	27415	2022
RJ	0000000	F	A	mais_20sm	43747.2	2741	2022
RJ	0000000	F	I	mais_20sm	43747.2	2741	2022
SP	0000000	M	B	ate_1sm	781.2	2345716	2022
SP	0000000	M	P	ate_1sm	585.9	2454819	2022
SP	0000000	M	N	ate_1sm	585.9	545515	2022
SP	0000000	M	A	ate_1sm	781.2	54551	2022
SP	0000000	M	I	ate_1sm	781.2	54551	2022
SP	0000000	F	B	ate_1sm	624.96	1919222	2022
SP	0000000	F	P	ate_1sm	468.72	2008488	2022
SP	0000000	F	N	ate_1sm	468.72	446330	2022
SP	0000000	F	A	ate_1sm	624.96	44633	2022
SP	0000000	F	I	ate_1sm	624.96	44633	2022
SP	0000000	M	B	1_a_2sm	2343.6	1584943	2022
SP	0000000	M	P	1_a_2sm	1757.7	1658661	2022
SP	0000000	M	N	1_a_2sm	1757.7	368591	2022
SP	0000000	M	A	1_a_2sm	2343.6	36859	2022
SP	0000000	M	I	1_a_2sm	2343.6	36859	2022
SP	0000000	F	B	1_a_2sm	1874.88	1296771	2022
SP	0000000	F	P	1_a_2sm	1406.16	1357086	2022
SP	0000000	F	N	1_a_2sm	1406.16	301574	2022
SP	0000000	F	A	1_a_2sm	1874.88	30157	2022
SP	0000000	F	I	1_a_2sm	1874.88	30157	2022
SP	0000000	M	B	2_a_5sm	5468.4	1141158	2022
SP	0000000	M	P	2_a_5sm	4101.3	1194236	2022
SP	0000000	M	N	2_a_5sm	4101.3	265385	2022
SP	0000000	M	A	2_a_5sm	5468.4	26538	2022
SP	0000000	M	I	2_a_5sm	5468.4	26538	2022
SP	0000000	F	B	2_a_5sm	4374.72	933675	2022
SP	0000000	F	P	2_a_5sm	3281.04	977102	2022
SP	0000000	F	N	2_a_5sm	3281.04	217133	2022
SP	0000000	F	A	2_a_5sm	4374.72	21713	2022
SP	0000000	F	I	2_a_5sm	4374.72	21713	2022
SP	0000000	M	B	5_a_20sm	19530	950965	2022
SP	0000000	M	P	5_a_20sm	14647.5	995196	2022
SP	0000000	M	N	5_a_20sm	14647.5	221154	2022
SP	0000000	M	A	5_a_20sm	19530	22115	2022
SP	0000000	M	I	5_a_20sm	19530	22115	2022
SP	0000000	F	B	5_a_20sm	15624	778063	2022
SP	0000000	F	P	5_a_20sm	11718	814252	2022
SP	0000000	F	N	5_a_20sm	11718	180944	2022
SP	0000000	F	A	5_a_20sm	15624	18094	2022
SP	0000000	F	I	5_a_20sm	15624	18094	2022
SP	0000000	M	B	mais_20sm	54684	316988	2022
SP	0000000	M	P	mais_20sm	41013	331731	2022
SP	0000000	M	N	mais_20sm	41013	73718	2022
SP	0000000	M	A	mais_20sm	54684	7371	2022
SP	0000000	M	I	mais_20sm	54684	7371	2022
SP	0000000	F	B	mais_20sm	43747.2	259354	2022
SP	0000000	F	P	mais_20sm	32810.4	271417	2022
SP	0000000	F	N	mais_20sm	32810.4	60314	2022
SP	0000000	F	A	mais_20sm	43747.2	6031	2022
SP	0000000	F	I	mais_20sm	43747.2	6031	2022
PR	0000000	M	B	ate_1sm	781.2	639740	2022
PR	0000000	M	P	ate_1sm	585.9	669496	2022
PR	0000000	M	N	ate_1sm	585.9	148776	2022
PR	0000000	M	A	ate_1sm	781.2	14877	2022
PR	0000000	M	I	ate_1sm	781.2	14877	2022
PR	0000000	F	B	ate_1sm	624.96	523423	2022
PR	0000000	F	P	ate_1sm	468.72	547769	2022
PR	0000000	F	N	ate_1sm	468.72	121726	2022
PR	0000000	F	A	ate_1sm	624.96	12172	2022
PR	0000000	F	I	ate_1sm	624.96	12172	2022
PR	0000000	M	B	1_a_2sm	2343.6	432257	2022
PR	0000000	M	P	1_a_2sm	1757.7	452362	2022
PR	0000000	M	N	1_a_2sm	1757.7	100524	2022
PR	0000000	M	A	1_a_2sm	2343.6	10052	2022
PR	0000000	M	I	1_a_2sm	2343.6	10052	2022
PR	0000000	F	B	1_a_2sm	1874.88	353664	2022
PR	0000000	F	P	1_a_2sm	1406.16	370114	2022
PR	0000000	F	N	1_a_2sm	1406.16	82247	2022
PR	0000000	F	A	1_a_2sm	1874.88	8224	2022
PR	0000000	F	I	1_a_2sm	1874.88	8224	2022
PR	0000000	M	B	2_a_5sm	5468.4	311224	2022
PR	0000000	M	P	2_a_5sm	4101.3	325700	2022
PR	0000000	M	N	2_a_5sm	4101.3	72377	2022
PR	0000000	M	A	2_a_5sm	5468.4	7237	2022
PR	0000000	M	I	2_a_5sm	5468.4	7237	2022
PR	0000000	F	B	2_a_5sm	4374.72	254638	2022
PR	0000000	F	P	2_a_5sm	3281.04	266482	2022
PR	0000000	F	N	2_a_5sm	3281.04	59218	2022
PR	0000000	F	A	2_a_5sm	4374.72	5921	2022
PR	0000000	F	I	2_a_5sm	4374.72	5921	2022
PR	0000000	M	B	5_a_20sm	19530	259354	2022
PR	0000000	M	P	5_a_20sm	14647.5	271417	2022
PR	0000000	M	N	5_a_20sm	14647.5	60314	2022
PR	0000000	M	A	5_a_20sm	19530	6031	2022
PR	0000000	M	I	5_a_20sm	19530	6031	2022
PR	0000000	F	B	5_a_20sm	15624	212198	2022
PR	0000000	F	P	5_a_20sm	11718	222068	2022
PR	0000000	F	N	5_a_20sm	11718	49348	2022
PR	0000000	F	A	5_a_20sm	15624	4934	2022
PR	0000000	F	I	5_a_20sm	15624	4934	2022
PR	0000000	M	B	mais_20sm	54684	86451	2022
PR	0000000	M	P	mais_20sm	41013	90472	2022
PR	0000000	M	N	mais_20sm	41013	20104	2022
PR	0000000	M	A	mais_20sm	54684	2010	2022
PR	0000000	M	I	mais_20sm	54684	2010	2022
PR	0000000	F	B	mais_20sm	43747.2	70732	2022
PR	0000000	F	P	mais_20sm	32810.4	74022	2022
PR	0000000	F	N	mais_20sm	32810.4	16449	2022
PR	0000000	F	A	mais_20sm	43747.2	1644	2022
PR	0000000	F	I	mais_20sm	43747.2	1644	2022
RS	0000000	M	B	ate_1sm	781.2	639740	2022
RS	0000000	M	P	ate_1sm	585.9	669496	2022
RS	0000000	M	N	ate_1sm	585.9	148776	2022
RS	0000000	M	A	ate_1sm	781.2	14877	2022
RS	0000000	M	I	ate_1sm	781.2	14877	2022
RS	0000000	F	B	ate_1sm	624.96	523423	2022
RS	0000000	F	P	ate_1sm	468.72	547769	2022
RS	0000000	F	N	ate_1sm	468.72	121726	2022
RS	0000000	F	A	ate_1sm	624.96	12172	2022
RS	0000000	F	I	ate_1sm	624.96	12172	2022
RS	0000000	M	B	1_a_2sm	2343.6	432257	2022
RS	0000000	M	P	1_a_2sm	1757.7	452362	2022
RS	0000000	M	N	1_a_2sm	1757.7	100524	2022
RS	0000000	M	A	1_a_2sm	2343.6	10052	2022
RS	0000000	M	I	1_a_2sm	2343.6	10052	2022
RS	0000000	F	B	1_a_2sm	1874.88	353664	2022
RS	0000000	F	P	1_a_2sm	1406.16	370114	2022
RS	0000000	F	N	1_a_2sm	1406.16	82247	2022
RS	0000000	F	A	1_a_2sm	1874.88	8224	2022
RS	0000000	F	I	1_a_2sm	1874.88	8224	2022
RS	0000000	M	B	2_a_5sm	5468.4	311224	2022
RS	0000000	M	P	2_a_5sm	4101.3	325700	2022
RS	0000000	M	N	2_a_5sm	4101.3	72377	2022
RS	0000000	M	A	2_a_5sm	5468.4	7237	2022
RS	0000000	M	I	2_a_5sm	5468.4	7237	2022
RS	0000000	F	B	2_a_5sm	4374.72	254638	2022
RS	0000000	F	P	2_a_5sm	3281.04	266482	2022
RS	0000000	F	N	2_a_5sm	3281.04	59218	2022
RS	0000000	F	A	2_a_5sm	4374.72	5921	2022
RS	0000000	F	I	2_a_5sm	4374.72	5921	2022
RS	0000000	M	B	5_a_20sm	19530	259354	2022
RS	0000000	M	P	5_a_20sm	14647.5	271417	2022
RS	0000000	M	N	5_a_20sm	14647.5	60314	2022
RS	0000000	M	A	5_a_20sm	19530	6031	2022
RS	0000000	M	I	5_a_20sm	19530	6031	2022
RS	0000000	F	B	5_a_20sm	15624	212198	2022
RS	0000000	F	P	5_a_20sm	11718	222068	2022
RS	0000000	F	N	5_a_20sm	11718	49348	2022
RS	0000000	F	A	5_a_20sm	15624	4934	2022
RS	0000000	F	I	5_a_20sm	15624	4934	2022
RS	0000000	M	B	mais_20sm	54684	86451	2022
RS	0000000	M	P	mais_20sm	41013	90472	2022
RS	0000000	M	N	mais_20sm	41013	20104	2022
RS	0000000	M	A	mais_20sm	54684	2010	2022
RS	0000000	M	I	mais_20sm	54684	2010	2022
RS	0000000	F	B	mais_20sm	43747.2	70732	2022
RS	0000000	F	P	mais_20sm	32810.4	74022	2022
RS	0000000	F	N	mais_20sm	32810.4	16449	2022
RS	0000000	F	A	mais_20sm	43747.2	1644	2022
RS	0000000	F	I	mais_20sm	43747.2	1644	2022
SC	0000000	M	B	ate_1sm	781.2	213246	2022
SC	0000000	M	P	ate_1sm	585.9	223164	2022
SC	0000000	M	N	ate_1sm	585.9	49592	2022
SC	0000000	M	A	ate_1sm	781.2	4959	2022
SC	0000000	M	I	ate_1sm	781.2	4959	2022
SC	0000000	F	B	ate_1sm	624.96	174474	2022
SC	0000000	F	P	ate_1sm	468.72	182589	2022
SC	0000000	F	N	ate_1sm	468.72	40575	2022
SC	0000000	F	A	ate_1sm	624.96	4057	2022
SC	0000000	F	I	ate_1sm	624.96	4057	2022
SC	0000000	M	B	1_a_2sm	2343.6	144085	2022
SC	0000000	M	P	1_a_2sm	1757.7	150787	2022
SC	0000000	M	N	1_a_2sm	1757.7	33508	2022
SC	0000000	M	A	1_a_2sm	2343.6	3350	2022
SC	0000000	M	I	1_a_2sm	2343.6	3350	2022
SC	0000000	F	B	1_a_2sm	1874.88	117887	2022
SC	0000000	F	P	1_a_2sm	1406.16	123371	2022
SC	0000000	F	N	1_a_2sm	1406.16	27415	2022
SC	0000000	F	A	1_a_2sm	1874.88	2741	2022
SC	0000000	F	I	1_a_2sm	1874.88	2741	2022
SC	0000000	M	B	2_a_5sm	5468.4	103741	2022
SC	0000000	M	P	2_a_5sm	4101.3	108566	2022
SC	0000000	M	N	2_a_5sm	4101.3	24125	2022
SC	0000000	M	A	2_a_5sm	5468.4	2412	2022
SC	0000000	M	I	2_a_5sm	5468.4	2412	2022
SC	0000000	F	B	2_a_5sm	4374.72	84879	2022
SC	0000000	F	P	2_a_5sm	3281.04	88827	2022
SC	0000000	F	N	2_a_5sm	3281.04	19739	2022
SC	0000000	F	A	2_a_5sm	4374.72	1973	2022
SC	0000000	F	I	2_a_5sm	4374.72	1973	2022
SC	0000000	M	B	5_a_20sm	19530	86451	2022
SC	0000000	M	P	5_a_20sm	14647.5	90472	2022
SC	0000000	M	N	5_a_20sm	14647.5	20104	2022
SC	0000000	M	A	5_a_20sm	19530	2010	2022
SC	0000000	M	I	5_a_20sm	19530	2010	2022
SC	0000000	F	B	5_a_20sm	15624	70732	2022
SC	0000000	F	P	5_a_20sm	11718	74022	2022
SC	0000000	F	N	5_a_20sm	11718	16449	2022
SC	0000000	F	A	5_a_20sm	15624	1644	2022
SC	0000000	F	I	5_a_20sm	15624	1644	2022
SC	0000000	M	B	mais_20sm	54684	28816	2022
SC	0000000	M	P	mais_20sm	41013	30157	2022
SC	0000000	M	N	mais_20sm	41013	6701	2022
SC	0000000	M	A	mais_20sm	54684	670	2022
SC	0000000	M	I	mais_20sm	54684	670	2022
SC	0000000	F	B	mais_20sm	43747.2	23577	2022
SC	0000000	F	P	mais_20sm	32810.4	24673	2022
SC	0000000	F	N	mais_20sm	32810.4	5483	2022
SC	0000000	F	A	mais_20sm	43747.2	548	2022
SC	0000000	F	I	mais_20sm	43747.2	548	2022
DF	0000000	M	B	ate_1sm	651	213246	2022
DF	0000000	M	P	ate_1sm	488.25	223164	2022
DF	0000000	M	N	ate_1sm	488.25	49592	2022
DF	0000000	M	A	ate_1sm	651	4959	2022
DF	0000000	M	I	ate_1sm	651	4959	2022
DF	0000000	F	B	ate_1sm	520.8	174474	2022
DF	0000000	F	P	ate_1sm	390.6	182589	2022
DF	0000000	F	N	ate_1sm	390.6	40575	2022
DF	0000000	F	A	ate_1sm	520.8	4057	2022
DF	0000000	F	I	ate_1sm	520.8	4057	2022
DF	0000000	M	B	1_a_2sm	1953	144085	2022
DF	0000000	M	P	1_a_2sm	1464.75	150787	2022
DF	0000000	M	N	1_a_2sm	1464.75	33508	2022
DF	0000000	M	A	1_a_2sm	1953	3350	2022
DF	0000000	M	I	1_a_2sm	1953	3350	2022
DF	0000000	F	B	1_a_2sm	1562.4	117887	2022
DF	0000000	F	P	1_a_2sm	1171.8	123371	2022
DF	0000000	F	N	1_a_2sm	1171.8	27415	2022
DF	0000000	F	A	1_a_2sm	1562.4	2741	2022
DF	0000000	F	I	1_a_2sm	1562.4	2741	2022
DF	0000000	M	B	2_a_5sm	4557	103741	2022
DF	0000000	M	P	2_a_5sm	3417.75	108566	2022
DF	0000000	M	N	2_a_5sm	3417.75	24125	2022
DF	0000000	M	A	2_a_5sm	4557	2412	2022
DF	0000000	M	I	2_a_5sm	4557	2412	2022
DF	0000000	F	B	2_a_5sm	3645.6	84879	2022
DF	0000000	F	P	2_a_5sm	2734.2	88827	2022
DF	0000000	F	N	2_a_5sm	2734.2	19739	2022
DF	0000000	F	A	2_a_5sm	3645.6	1973	2022
DF	0000000	F	I	2_a_5sm	3645.6	1973	2022
DF	0000000	M	B	5_a_20sm	16275	86451	2022
DF	0000000	M	P	5_a_20sm	12206.25	90472	2022
DF	0000000	M	N	5_a_20sm	12206.25	20104	2022
DF	0000000	M	A	5_a_20sm	16275	2010	2022
DF	0000000	M	I	5_a_20sm	16275	2010	2022
DF	0000000	F	B	5_a_20sm	13020	70732	2022
DF	0000000	F	P	5_a_20sm	9765	74022	2022
DF	0000000	F	N	5_a_20sm	9765	16449	2022
DF	0000000	F	A	5_a_20sm	13020	1644	2022
DF	0000000	F	I	5_a_20sm	13020	1644	2022
DF	0000000	M	B	mais_20sm	45570	28816	2022
DF	0000000	M	P	mais_20sm	34177.5	30157	2022
DF	0000000	M	N	mais_20sm	34177.5	6701	2022
DF	0000000	M	A	mais_20sm	45570	670	2022
DF	0000000	M	I	mais_20sm	45570	670	2022
DF	0000000	F	B	mais_20sm	36456	23577	2022
DF	0000000	F	P	mais_20sm	27342	24673	2022
DF	0000000	F	N	mais_20sm	27342	5483	2022
DF	0000000	F	A	mais_20sm	36456	548	2022
DF	0000000	F	I	mais_20sm	36456	548	2022
GO	0000000	M	B	ate_1sm	651	213246	2022
GO	0000000	M	P	ate_1sm	488.25	223164	2022
GO	0000000	M	N	ate_1sm	488.25	49592	2022
GO	0000000	M	A	ate_1sm	651	4959	2022
GO	0000000	M	I	ate_1sm	651	4959	2022
GO	0000000	F	B	ate_1sm	520.8	174474	2022
GO	0000000	F	P	ate_1sm	390.6	182589	2022
GO	0000000	F	N	ate_1sm	390.6	40575	2022
GO	0000000	F	A	ate_1sm	520.8	4057	2022
GO	0000000	F	I	ate_1sm	520.8	4057	2022
GO	0000000	M	B	1_a_2sm	1953	144085	2022
GO	0000000	M	P	1_a_2sm	1464.75	150787	2022
GO	0000000	M	N	1_a_2sm	1464.75	33508	2022
GO	0000000	M	A	1_a_2sm	1953	3350	2022
GO	0000000	M	I	1_a_2sm	1953	3350	2022
GO	0000000	F	B	1_a_2sm	1562.4	117887	2022
GO	0000000	F	P	1_a_2sm	1171.8	123371	2022
GO	0000000	F	N	1_a_2sm	1171.8	27415	2022
GO	0000000	F	A	1_a_2sm	1562.4	2741	2022
GO	0000000	F	I	1_a_2sm	1562.4	2741	2022
GO	0000000	M	B	2_a_5sm	4557	103741	2022
GO	0000000	M	P	2_a_5sm	3417.75	108566	2022
GO	0000000	M	N	2_a_5sm	3417.75	24125	2022
GO	0000000	M	A	2_a_5sm	4557	2412	2022
GO	0000000	M	I	2_a_5sm	4557	2412	2022
GO	0000000	F	B	2_a_5sm	3645.6	84879	2022
GO	0000000	F	P	2_a_5sm	2734.2	88827	2022
GO	0000000	F	N	2_a_5sm	2734.2	19739	2022
GO	0000000	F	A	2_a_5sm	3645.6	1973	2022
GO	0000000	F	I	2_a_5sm	3645.6	1973	2022
GO	0000000	M	B	5_a_20sm	16275	86451	2022
GO	0000000	M	P	5_a_20sm	12206.25	90472	2022
GO	0000000	M	N	5_a_20sm	12206.25	20104	2022
GO	0000000	M	A	5_a_20sm	16275	2010	2022
GO	0000000	M	I	5_a_20sm	16275	2010	2022
GO	0000000	F	B	5_a_20sm	13020	70732	2022
GO	0000000	F	P	5_a_20sm	9765	74022	2022
GO	0000000	F	N	5_a_20sm	9765	16449	2022
GO	0000000	F	A	5_a_20sm	13020	1644	2022
GO	0000000	F	I	5_a_20sm	13020	1644	2022
GO	0000000	M	B	mais_20sm	45570	28816	2022
GO	0000000	M	P	mais_20sm	34177.5	30157	2022
GO	0000000	M	N	mais_20sm	34177.5	6701	2022
GO	0000000	M	A	mais_20sm	45570	670	2022
GO	0000000	M	I	mais_20sm	45570	670	2022
GO	0000000	F	B	mais_20sm	36456	23577	2022
GO	0000000	F	P	mais_20sm	27342	24673	2022
GO	0000000	F	N	mais_20sm	27342	5483	2022
GO	0000000	F	A	mais_20sm	36456	548	2022
GO	0000000	F	I	mais_20sm	36456	548	2022
MS	0000000	M	B	ate_1sm	651	213246	2022
MS	0000000	M	P	ate_1sm	488.25	223164	2022
MS	0000000	M	N	ate_1sm	488.25	49592	2022
MS	0000000	M	A	ate_1sm	651	4959	2022
MS	0000000	M	I	ate_1sm	651	4959	2022
MS	0000000	F	B	ate_1sm	520.8	174474	2022
MS	0000000	F	P	ate_1sm	390.6	182589	2022
MS	0000000	F	N	ate_1sm	390.6	40575	2022
MS	0000000	F	A	ate_1sm	520.8	4057	2022
MS	0000000	F	I	ate_1sm	520.8	4057	2022
MS	0000000	M	B	1_a_2sm	1953	144085	2022
MS	0000000	M	P	1_a_2sm	1464.75	150787	2022
MS	0000000	M	N	1_a_2sm	1464.75	33508	2022
MS	0000000	M	A	1_a_2sm	1953	3350	2022
MS	0000000	M	I	1_a_2sm	1953	3350	2022
MS	0000000	F	B	1_a_2sm	1562.4	117887	2022
MS	0000000	F	P	1_a_2sm	1171.8	123371	2022
MS	0000000	F	N	1_a_2sm	1171.8	27415	2022
MS	0000000	F	A	1_a_2sm	1562.4	2741	2022
MS	0000000	F	I	1_a_2sm	1562.4	2741	2022
MS	0000000	M	B	2_a_5sm	4557	103741	2022
MS	0000000	M	P	2_a_5sm	3417.75	108566	2022
MS	0000000	M	N	2_a_5sm	3417.75	24125	2022
MS	0000000	M	A	2_a_5sm	4557	2412	2022
MS	0000000	M	I	2_a_5sm	4557	2412	2022
MS	0000000	F	B	2_a_5sm	3645.6	84879	2022
MS	0000000	F	P	2_a_5sm	2734.2	88827	2022
MS	0000000	F	N	2_a_5sm	2734.2	19739	2022
MS	0000000	F	A	2_a_5sm	3645.6	1973	2022
MS	0000000	F	I	2_a_5sm	3645.6	1973	2022
MS	0000000	M	B	5_a_20sm	16275	86451	2022
MS	0000000	M	P	5_a_20sm	12206.25	90472	2022
MS	0000000	M	N	5_a_20sm	12206.25	20104	2022
MS	0000000	M	A	5_a_20sm	16275	2010	2022
MS	0000000	M	I	5_a_20sm	16275	2010	2022
MS	0000000	F	B	5_a_20sm	13020	70732	2022
MS	0000000	F	P	5_a_20sm	9765	74022	2022
MS	0000000	F	N	5_a_20sm	9765	16449	2022
MS	0000000	F	A	5_a_20sm	13020	1644	2022
MS	0000000	F	I	5_a_20sm	13020	1644	2022
MS	0000000	M	B	mais_20sm	45570	28816	2022
MS	0000000	M	P	mais_20sm	34177.5	30157	2022
MS	0000000	M	N	mais_20sm	34177.5	6701	2022
MS	0000000	M	A	mais_20sm	45570	670	2022
MS	0000000	M	I	mais_20sm	45570	670	2022
MS	0000000	F	B	mais_20sm	36456	23577	2022
MS	0000000	F	P	mais_20sm	27342	24673	2022
MS	0000000	F	N	mais_20sm	27342	5483	2022
MS	0000000	F	A	mais_20sm	36456	548	2022
MS	0000000	F	I	mais_20sm	36456	548	2022
MT	0000000	M	B	ate_1sm	651	213246	2022
MT	0000000	M	P	ate_1sm	488.25	223164	2022
MT	0000000	M	N	ate_1sm	488.25	49592	2022
MT	0000000	M	A	ate_1sm	651	4959	2022
MT	0000000	M	I	ate_1sm	651	4959	2022
MT	0000000	F	B	ate_1sm	520.8	174474	2022
MT	0000000	F	P	ate_1sm	390.6	182589	2022
MT	0000000	F	N	ate_1sm	390.6	40575	2022
MT	0000000	F	A	ate_1sm	520.8	4057	2022
MT	0000000	F	I	ate_1sm	520.8	4057	2022
MT	0000000	M	B	1_a_2sm	1953	144085	2022
MT	0000000	M	P	1_a_2sm	1464.75	150787	2022
MT	0000000	M	N	1_a_2sm	1464.75	33508	2022
MT	0000000	M	A	1_a_2sm	1953	3350	2022
MT	0000000	M	I	1_a_2sm	1953	3350	2022
MT	0000000	F	B	1_a_2sm	1562.4	117887	2022
MT	0000000	F	P	1_a_2sm	1171.8	123371	2022
MT	0000000	F	N	1_a_2sm	1171.8	27415	2022
MT	0000000	F	A	1_a_2sm	1562.4	2741	2022
MT	0000000	F	I	1_a_2sm	1562.4	2741	2022
MT	0000000	M	B	2_a_5sm	4557	103741	2022
MT	0000000	M	P	2_a_5sm	3417.75	108566	2022
MT	0000000	M	N	2_a_5sm	3417.75	24125	2022
MT	0000000	M	A	2_a_5sm	4557	2412	2022
MT	0000000	M	I	2_a_5sm	4557	2412	2022
MT	0000000	F	B	2_a_5sm	3645.6	84879	2022
MT	0000000	F	P	2_a_5sm	2734.2	88827	2022
MT	0000000	F	N	2_a_5sm	2734.2	19739	2022
MT	0000000	F	A	2_a_5sm	3645.6	1973	2022
MT	0000000	F	I	2_a_5sm	3645.6	1973	2022
MT	0000000	M	B	5_a_20sm	16275	86451	2022
MT	0000000	M	P	5_a_20sm	12206.25	90472	2022
MT	0000000	M	N	5_a_20sm	12206.25	20104	2022
MT	0000000	M	A	5_a_20sm	16275	2010	2022
MT	0000000	M	I	5_a_20sm	16275	2010	2022
MT	0000000	F	B	5_a_20sm	13020	70732	2022
MT	0000000	F	P	5_a_20sm	9765	74022	2022
MT	0000000	F	N	5_a_20sm	9765	16449	2022
MT	0000000	F	A	5_a_20sm	13020	1644	2022
MT	0000000	F	I	5_a_20sm	13020	1644	2022
MT	0000000	M	B	mais_20sm	45570	28816	2022
MT	0000000	M	P	mais_20sm	34177.5	30157	2022
MT	0000000	M	N	mais_20sm	34177.5	6701	2022
MT	0000000	M	A	mais_20sm	45570	670	2022
MT	0000000	M	I	mais_20sm	45570	670	2022
MT	0000000	F	B	mais_20sm	36456	23577	2022
MT	0000000	F	P	mais_20sm	27342	24673	2022
MT	0000000	F	N	mais_20sm	27342	5483	2022
MT	0000000	F	A	mais_20sm	36456	548	2022
MT	0000000	F	I	mais_20sm	36456	548	2022
\.


--
-- Data for Name: crescimento_populacional; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.crescimento_populacional (ano_pesquisa, populacao_pessoas, recorte_geografico) FROM stdin;
1872	9930478	Brasil
1890	14333915	Brasil
1900	17438434	Brasil
1920	30635605	Brasil
1940	41236315	Brasil
1950	51944397	Brasil
1960	70992343	Brasil
1970	94508583	Brasil
1980	121150573	Brasil
1991	146917459	Brasil
2000	169872856	Brasil
2010	190755799	Brasil
2022	203080756	Brasil
\.


--
-- Data for Name: nivel_instrucao; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.nivel_instrucao (nivel_instrucao, populacao_pessoas, recorte_geografico, ano) FROM stdin;
Sem instrução e fundamental incompleto	49352917	Brasil	2022
Fundamental completo e médio incompleto	23796661	Brasil	2022
Médio completo e superior incompleto	55305618	Brasil	2022
Superior completo	25854291	Brasil	2022
\.


--
-- Data for Name: populacao_cor_raca; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.populacao_cor_raca (cor_ou_raca, populacao_pessoas, recorte_geografico, ano) FROM stdin;
Branca	88252121	Brasil	2022
Preta	20656458	Brasil	2022
Amarela	850130	Brasil	2022
Parda	92083286	Brasil	2022
Indígena	1227642	Brasil	2022
\.


--
-- Data for Name: populacao_sexo; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.populacao_sexo (sexo, populacao_pessoas, recorte_geografico, ano) FROM stdin;
Mulheres	104548325	Brasil	2022
Homens	98532431	Brasil	2022
\.


--
-- Data for Name: populacao_situacao_domicilio; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.populacao_situacao_domicilio (situacao, populacao_pessoas, percentual, recorte_geografico, ano) FROM stdin;
Urbana	177508417	\N	Brasil	2022
Rural	25572339	\N	Brasil	2022
\.


--
-- Data for Name: territorio; Type: TABLE DATA; Schema: bronze; Owner: etl_user
--

COPY bronze.territorio (ano_pesquisa, area_km2, densidade_demografica, recorte_geografico) FROM stdin;
2022	8510417.77	23.86	Brasil
\.


--
-- Data for Name: dim_demografica; Type: TABLE DATA; Schema: gold; Owner: etl_user
--

COPY gold.dim_demografica (id, sexo_codigo, cor_raca_codigo, nivel_instrucao_codigo, sexo_descricao, cor_raca_descricao, nivel_instrucao_descricao) FROM stdin;
\.


--
-- Data for Name: dim_localidade; Type: TABLE DATA; Schema: gold; Owner: etl_user
--

COPY gold.dim_localidade (uf, regiao, nome_uf, nome_regiao) FROM stdin;
AC	N	Acre	Norte
AM	N	Amazonas	Norte
AP	N	Amapá	Norte
PA	N	Pará	Norte
RO	N	Rondônia	Norte
RR	N	Roraima	Norte
TO	N	Tocantins	Norte
AL	NE	Alagoas	Nordeste
BA	NE	Bahia	Nordeste
CE	NE	Ceará	Nordeste
MA	NE	Maranhão	Nordeste
PB	NE	Paraíba	Nordeste
PE	NE	Pernambuco	Nordeste
PI	NE	Piauí	Nordeste
RN	NE	Rio Grande do Norte	Nordeste
SE	NE	Sergipe	Nordeste
ES	SE	Espírito Santo	Sudeste
MG	SE	Minas Gerais	Sudeste
RJ	SE	Rio de Janeiro	Sudeste
SP	SE	São Paulo	Sudeste
PR	S	Paraná	Sul
RS	S	Rio Grande do Sul	Sul
SC	S	Santa Catarina	Sul
DF	CO	Distrito Federal	Centro-Oeste
GO	CO	Goiás	Centro-Oeste
MS	CO	Mato Grosso do Sul	Centro-Oeste
MT	CO	Mato Grosso	Centro-Oeste
\.


--
-- Data for Name: dim_tempo; Type: TABLE DATA; Schema: gold; Owner: etl_user
--

COPY gold.dim_tempo (ano, decada, periodo) FROM stdin;
2022	2020-2029	Pós-pandemia
\.


--
-- Data for Name: fato_crescimento_desenvolvimento; Type: TABLE DATA; Schema: gold; Owner: etl_user
--

COPY gold.fato_crescimento_desenvolvimento (id, ano, uf, populacao_total, crescimento_anual, taxa_crescimento_anual, taxa_crescimento_decada, densidade_demografica, area_km2) FROM stdin;
\.


--
-- Data for Name: fato_indicadores_demograficos; Type: TABLE DATA; Schema: gold; Owner: etl_user
--

COPY gold.fato_indicadores_demograficos (id, ano, uf, sexo_codigo, cor_raca_codigo, nivel_instrucao_codigo, populacao_total, populacao_urbana, populacao_rural, percentual_urbana, percentual_rural, densidade_demografica, area_km2) FROM stdin;
\.


--
-- Data for Name: fato_indicadores_renda; Type: TABLE DATA; Schema: gold; Owner: etl_user
--

COPY gold.fato_indicadores_renda (ano, uf, sexo_codigo, cor_raca_codigo, percentual_ate_1sm, percentual_mais_5sm, percentual_1_a_2sm, percentual_mais_20sm, rendimento_medio_brasil, rendimento_medio_uf, rendimento_medio_regiao, rendimento_medio_sexo, rendimento_medio_cor_raca, indice_gini, indice_gini_regiao, nivel_ocupacao_14_mais, nivel_ocupacao_uf) FROM stdin;
2022	AC	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	AM	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	AP	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	PA	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	RO	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	RR	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	TO	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	AL	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	BA	\N	\N	37	20	25	5	5132.71	3936.36	\N	\N	\N	0.6875	\N	72.26	114.76
2022	CE	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	MA	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	PB	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	PE	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	PI	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	RN	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	SE	\N	\N	37	20	25	5	5132.71	3936.33	\N	\N	\N	0.6875	\N	72.26	38.25
2022	ES	\N	\N	37	20	25	5	5132.71	5904.5	\N	\N	\N	0.6875	\N	72.26	38.25
2022	MG	\N	\N	37	20	25	5	5132.71	5904.56	\N	\N	\N	0.6875	\N	72.26	191.27
2022	RJ	\N	\N	37	20	25	5	5132.71	5904.56	\N	\N	\N	0.6875	\N	72.26	191.27
2022	SP	\N	\N	37	20	25	5	5132.71	5904.57	\N	\N	\N	0.6875	\N	72.26	420.8
2022	PR	\N	\N	37	20	25	5	5132.71	5904.54	\N	\N	\N	0.6875	\N	72.26	114.76
2022	RS	\N	\N	37	20	25	5	5132.71	5904.54	\N	\N	\N	0.6875	\N	72.26	114.76
2022	SC	\N	\N	37	20	25	5	5132.71	5904.5	\N	\N	\N	0.6875	\N	72.26	38.25
2022	DF	\N	\N	37	20	25	5	5132.71	4920.42	\N	\N	\N	0.6875	\N	72.26	38.25
2022	GO	\N	\N	37	20	25	5	5132.71	4920.42	\N	\N	\N	0.6875	\N	72.26	38.25
2022	MS	\N	\N	37	20	25	5	5132.71	4920.42	\N	\N	\N	0.6875	\N	72.26	38.25
2022	MT	\N	\N	37	20	25	5	5132.71	4920.42	\N	\N	\N	0.6875	\N	72.26	38.25
\.


--
-- Data for Name: fato_qualidade_vida; Type: TABLE DATA; Schema: gold; Owner: etl_user
--

COPY gold.fato_qualidade_vida (id, ano, uf, percentual_esgoto, percentual_agua, percentual_banheiro, percentual_coleta_lixo, indice_saneamento) FROM stdin;
\.


--
-- Data for Name: ab_permission; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_permission (id, name) FROM stdin;
1	can_edit
2	can_read
3	can_create
4	can_delete
5	menu_access
\.


--
-- Data for Name: ab_permission_view; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_permission_view (id, permission_id, view_menu_id) FROM stdin;
1	1	4
2	2	4
3	1	5
4	2	5
5	1	6
6	2	6
7	3	8
8	2	8
9	1	8
10	4	8
11	5	9
12	5	10
13	3	11
14	2	11
15	1	11
16	4	11
17	5	12
18	2	13
19	5	14
20	2	15
21	5	16
22	2	17
23	5	18
25	2	20
27	5	22
29	4	23
30	1	23
31	2	23
32	3	26
33	2	26
34	1	26
35	4	26
36	5	26
37	5	27
38	2	28
39	5	28
40	2	29
41	5	29
42	3	30
43	2	30
44	1	30
45	4	30
46	5	30
47	5	31
48	3	32
49	2	32
50	1	32
51	4	32
52	5	32
53	2	33
54	5	33
55	2	34
56	5	34
57	2	35
58	5	35
59	3	36
60	2	36
61	1	36
62	4	36
63	4	37
64	5	36
65	1	37
66	2	37
67	2	38
68	5	38
69	4	38
70	1	38
71	2	39
72	5	39
73	2	40
74	5	40
75	3	41
76	2	41
77	1	41
78	4	41
79	5	41
80	2	42
81	4	42
82	5	42
83	5	44
84	5	48
85	5	49
86	5	50
87	5	51
88	5	52
89	1	48
90	4	48
91	2	48
92	2	44
93	2	53
94	2	50
95	2	49
96	2	54
97	2	55
98	2	56
99	2	57
\.


--
-- Data for Name: ab_permission_view_role; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_permission_view_role (id, permission_view_id, role_id) FROM stdin;
1	1	1
2	2	1
3	3	1
4	4	1
5	5	1
6	6	1
7	7	1
8	8	1
9	9	1
10	10	1
11	11	1
12	12	1
13	13	1
14	14	1
15	15	1
16	16	1
17	17	1
18	18	1
19	19	1
20	20	1
21	21	1
22	22	1
24	23	1
25	25	1
26	27	1
28	32	1
29	33	1
30	34	1
31	35	1
32	36	1
33	37	1
34	38	1
35	39	1
36	40	1
37	41	1
38	42	1
39	43	1
40	44	1
41	45	1
42	46	1
43	47	1
44	48	1
45	49	1
46	50	1
47	51	1
48	52	1
49	53	1
50	54	1
51	55	1
52	56	1
53	57	1
54	58	1
55	59	1
56	60	1
57	61	1
58	62	1
59	64	1
60	67	1
61	68	1
62	69	1
63	70	1
64	71	1
65	72	1
66	73	1
67	74	1
68	75	1
69	76	1
70	77	1
71	78	1
72	79	1
73	80	1
74	81	1
75	82	1
76	83	1
77	84	1
78	85	1
79	86	1
80	87	1
81	88	1
82	40	3
83	91	3
84	92	3
85	93	3
86	33	3
87	94	3
88	95	3
89	76	3
90	96	3
91	97	3
92	38	3
93	4	3
94	3	3
95	6	3
96	5	3
97	71	3
98	67	3
99	49	3
100	98	3
101	80	3
102	99	3
103	37	3
104	84	3
105	83	3
106	36	3
107	86	3
108	85	3
109	87	3
110	88	3
111	39	3
112	41	3
113	72	3
114	68	3
115	52	3
116	40	4
117	91	4
118	92	4
119	93	4
120	33	4
121	94	4
122	95	4
123	76	4
124	96	4
125	97	4
126	38	4
127	4	4
128	3	4
129	6	4
130	5	4
131	71	4
132	67	4
133	49	4
134	98	4
135	80	4
136	99	4
137	37	4
138	84	4
139	83	4
140	36	4
141	86	4
142	85	4
143	87	4
144	88	4
145	39	4
146	41	4
147	72	4
148	68	4
149	52	4
150	89	4
151	90	4
152	48	4
153	50	4
154	51	4
155	32	4
156	34	4
157	35	4
158	40	5
159	91	5
160	92	5
161	93	5
162	33	5
163	94	5
164	95	5
165	76	5
166	96	5
167	97	5
168	38	5
169	4	5
170	3	5
171	6	5
172	5	5
173	71	5
174	67	5
175	49	5
176	98	5
177	80	5
178	99	5
179	37	5
180	84	5
181	83	5
182	36	5
183	86	5
184	85	5
185	87	5
186	88	5
187	39	5
188	41	5
189	72	5
190	68	5
191	52	5
192	89	5
193	90	5
194	48	5
195	50	5
196	51	5
197	32	5
198	34	5
199	35	5
200	57	5
201	47	5
202	58	5
203	64	5
204	79	5
205	46	5
206	74	5
207	82	5
208	59	5
209	60	5
210	61	5
211	62	5
212	75	5
213	77	5
214	78	5
215	73	5
216	42	5
217	43	5
218	44	5
219	45	5
220	81	5
221	91	1
222	92	1
223	93	1
224	94	1
225	95	1
226	96	1
227	97	1
228	98	1
229	99	1
230	89	1
231	90	1
\.


--
-- Data for Name: ab_register_user; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_register_user (id, first_name, last_name, username, password, email, registration_date, registration_hash) FROM stdin;
\.


--
-- Data for Name: ab_role; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_role (id, name) FROM stdin;
1	Admin
2	Public
3	Viewer
4	User
5	Op
\.


--
-- Data for Name: ab_user; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_user (id, first_name, last_name, username, password, active, email, last_login, login_count, fail_login_count, created_on, changed_on, created_by_fk, changed_by_fk) FROM stdin;
1	Admin	User	admin	pbkdf2:sha256:260000$GAYagvjJKwfNOKB6$33fb5b8ca94031296999c678c7a7d055bf219ed72f2b292c391d996eaf70f31f	t	admin@example.com	2025-10-17 02:35:35.722159	1	0	2025-10-17 02:16:00.789952	2025-10-17 02:16:00.789965	\N	\N
\.


--
-- Data for Name: ab_user_role; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_user_role (id, user_id, role_id) FROM stdin;
1	1	1
\.


--
-- Data for Name: ab_view_menu; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.ab_view_menu (id, name) FROM stdin;
1	IndexView
2	UtilView
3	LocaleView
4	Passwords
5	My Password
6	My Profile
7	AuthDBView
8	Users
9	List Users
10	Security
11	Roles
12	List Roles
13	User Stats Chart
14	User's Statistics
15	Permissions
16	Actions
17	View Menus
18	Resources
20	Permission Views
22	Permission Pairs
23	DAG:censo_etl_pipeline
24	AutocompleteView
25	Airflow
26	DAG Runs
27	Browse
28	Jobs
29	Audit Logs
30	Variables
31	Admin
32	Task Instances
33	Task Reschedules
34	Triggers
35	Configurations
36	Connections
37	DAG:censo_monitoring
38	SLA Misses
39	Plugins
40	Providers
41	Pools
42	XComs
43	DagDependenciesView
44	DAG Dependencies
45	RedocView
46	DevView
47	DocsView
48	DAGs
49	Cluster Activity
50	Datasets
51	Documentation
52	Docs
53	DAG Code
54	ImportError
55	DAG Warnings
56	Task Logs
57	Website
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.alembic_version (version_num) FROM stdin;
88344c1d9134
\.


--
-- Data for Name: callback_request; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.callback_request (id, created_at, priority_weight, callback_data, callback_type, processor_subdir) FROM stdin;
\.


--
-- Data for Name: connection; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.connection (id, conn_id, conn_type, description, host, schema, login, password, port, is_encrypted, is_extra_encrypted, extra) FROM stdin;
1	airflow_db	mysql	\N	mysql	airflow	root	\N	\N	f	f	\N
2	aws_default	aws	\N	\N	\N	\N	\N	\N	f	f	\N
3	azure_batch_default	azure_batch	\N	\N	\N	<ACCOUNT_NAME>	\N	\N	f	f	{"account_url": "<ACCOUNT_URL>"}
4	azure_cosmos_default	azure_cosmos	\N	\N	\N	\N	\N	\N	f	f	{"database_name": "<DATABASE_NAME>", "collection_name": "<COLLECTION_NAME>" }
5	azure_data_explorer_default	azure_data_explorer	\N	https://<CLUSTER>.kusto.windows.net	\N	\N	\N	\N	f	f	{"auth_method": "<AAD_APP | AAD_APP_CERT | AAD_CREDS | AAD_DEVICE>",\n                    "tenant": "<TENANT ID>", "certificate": "<APPLICATION PEM CERTIFICATE>",\n                    "thumbprint": "<APPLICATION CERTIFICATE THUMBPRINT>"}
6	azure_data_lake_default	azure_data_lake	\N	\N	\N	\N	\N	\N	f	f	{"tenant": "<TENANT>", "account_name": "<ACCOUNTNAME>" }
7	azure_default	azure	\N	\N	\N	\N	\N	\N	f	f	\N
8	cassandra_default	cassandra	\N	cassandra	\N	\N	\N	9042	f	f	\N
9	databricks_default	databricks	\N	localhost	\N	\N	\N	\N	f	f	\N
10	dingding_default	http	\N		\N	\N	\N	\N	f	f	\N
11	drill_default	drill	\N	localhost	\N	\N	\N	8047	f	f	{"dialect_driver": "drill+sadrill", "storage_plugin": "dfs"}
12	druid_broker_default	druid	\N	druid-broker	\N	\N	\N	8082	f	f	{"endpoint": "druid/v2/sql"}
13	druid_ingest_default	druid	\N	druid-overlord	\N	\N	\N	8081	f	f	{"endpoint": "druid/indexer/v1/task"}
14	elasticsearch_default	elasticsearch	\N	localhost	http	\N	\N	9200	f	f	\N
15	emr_default	emr	\N	\N	\N	\N	\N	\N	f	f	\n                {   "Name": "default_job_flow_name",\n                    "LogUri": "s3://my-emr-log-bucket/default_job_flow_location",\n                    "ReleaseLabel": "emr-4.6.0",\n                    "Instances": {\n                        "Ec2KeyName": "mykey",\n                        "Ec2SubnetId": "somesubnet",\n                        "InstanceGroups": [\n                            {\n                                "Name": "Master nodes",\n                                "Market": "ON_DEMAND",\n                                "InstanceRole": "MASTER",\n                                "InstanceType": "r3.2xlarge",\n                                "InstanceCount": 1\n                            },\n                            {\n                                "Name": "Core nodes",\n                                "Market": "ON_DEMAND",\n                                "InstanceRole": "CORE",\n                                "InstanceType": "r3.2xlarge",\n                                "InstanceCount": 1\n                            }\n                        ],\n                        "TerminationProtected": false,\n                        "KeepJobFlowAliveWhenNoSteps": false\n                    },\n                    "Applications":[\n                        { "Name": "Spark" }\n                    ],\n                    "VisibleToAllUsers": true,\n                    "JobFlowRole": "EMR_EC2_DefaultRole",\n                    "ServiceRole": "EMR_DefaultRole",\n                    "Tags": [\n                        {\n                            "Key": "app",\n                            "Value": "analytics"\n                        },\n                        {\n                            "Key": "environment",\n                            "Value": "development"\n                        }\n                    ]\n                }\n            
16	facebook_default	facebook_social	\N	\N	\N	\N	\N	\N	f	f	\n                {   "account_id": "<AD_ACCOUNT_ID>",\n                    "app_id": "<FACEBOOK_APP_ID>",\n                    "app_secret": "<FACEBOOK_APP_SECRET>",\n                    "access_token": "<FACEBOOK_AD_ACCESS_TOKEN>"\n                }\n            
17	fs_default	fs	\N	\N	\N	\N	\N	\N	f	f	{"path": "/"}
18	ftp_default	ftp	\N	localhost	\N	airflow	airflow	21	f	f	{"key_file": "~/.ssh/id_rsa", "no_host_key_check": true}
19	google_cloud_default	google_cloud_platform	\N	\N	default	\N	\N	\N	f	f	\N
20	hive_cli_default	hive_cli	\N	localhost	default	\N	\N	10000	f	f	{"use_beeline": true, "auth": ""}
21	hiveserver2_default	hiveserver2	\N	localhost	default	\N	\N	10000	f	f	\N
22	http_default	http	\N	https://www.httpbin.org/	\N	\N	\N	\N	f	f	\N
23	impala_default	impala	\N	localhost	\N	\N	\N	21050	f	f	\N
24	kafka_default	kafka	\N	\N	\N	\N	\N	\N	f	f	{"bootstrap.servers": "broker:29092"}
25	kubernetes_default	kubernetes	\N	\N	\N	\N	\N	\N	f	f	\N
26	kylin_default	kylin	\N	localhost	\N	ADMIN	KYLIN	7070	f	f	\N
27	leveldb_default	leveldb	\N	localhost	\N	\N	\N	\N	f	f	\N
28	livy_default	livy	\N	livy	\N	\N	\N	8998	f	f	\N
29	local_mysql	mysql	\N	localhost	airflow	airflow	airflow	\N	f	f	\N
30	metastore_default	hive_metastore	\N	localhost	\N	\N	\N	9083	f	f	{"authMechanism": "PLAIN"}
31	mongo_default	mongo	\N	mongo	\N	\N	\N	27017	f	f	\N
32	mssql_default	mssql	\N	localhost	\N	\N	\N	1433	f	f	\N
33	mysql_default	mysql	\N	mysql	airflow	root	\N	\N	f	f	\N
34	opsgenie_default	http	\N		\N	\N	\N	\N	f	f	\N
35	oracle_default	oracle	\N	localhost	schema	root	password	1521	f	f	\N
36	oss_default	oss	\N	\N	\N	\N	\N	\N	f	f	{\n                "auth_type": "AK",\n                "access_key_id": "<ACCESS_KEY_ID>",\n                "access_key_secret": "<ACCESS_KEY_SECRET>",\n                "region": "<YOUR_OSS_REGION>"}\n                
37	pig_cli_default	pig_cli	\N	\N	default	\N	\N	\N	f	f	\N
38	pinot_admin_default	pinot	\N	localhost	\N	\N	\N	9000	f	f	\N
39	pinot_broker_default	pinot	\N	localhost	\N	\N	\N	9000	f	f	{"endpoint": "/query", "schema": "http"}
40	postgres_default	postgres	\N	postgres	airflow	postgres	airflow	\N	f	f	\N
41	presto_default	presto	\N	localhost	hive	\N	\N	3400	f	f	\N
42	redis_default	redis	\N	redis	\N	\N	\N	6379	f	f	{"db": 0}
43	redshift_default	redshift	\N	\N	\N	\N	\N	\N	f	f	{\n    "iam": true,\n    "cluster_identifier": "<REDSHIFT_CLUSTER_IDENTIFIER>",\n    "port": 5439,\n    "profile": "default",\n    "db_user": "awsuser",\n    "database": "dev",\n    "region": ""\n}
44	salesforce_default	salesforce	\N	\N	\N	username	password	\N	f	f	{"security_token": "security_token"}
45	segment_default	segment	\N	\N	\N	\N	\N	\N	f	f	{"write_key": "my-segment-write-key"}
46	sftp_default	sftp	\N	localhost	\N	airflow	\N	22	f	f	{"key_file": "~/.ssh/id_rsa", "no_host_key_check": true}
47	spark_default	spark	\N	yarn	\N	\N	\N	\N	f	f	{"queue": "root.default"}
48	sqlite_default	sqlite	\N	/tmp/sqlite_default.db	\N	\N	\N	\N	f	f	\N
49	sqoop_default	sqoop	\N	rdbms	\N	\N	\N	\N	f	f	\N
50	ssh_default	ssh	\N	localhost	\N	\N	\N	\N	f	f	\N
51	tableau_default	tableau	\N	https://tableau.server.url	\N	user	password	\N	f	f	{"site_id": "my_site"}
52	tabular_default	tabular	\N	https://api.tabulardata.io/ws/v1	\N	\N	\N	\N	f	f	\N
53	trino_default	trino	\N	localhost	hive	\N	\N	3400	f	f	\N
54	vertica_default	vertica	\N	localhost	\N	\N	\N	5433	f	f	\N
55	wasb_default	wasb	\N	\N	\N	\N	\N	\N	f	f	{"sas_token": null}
56	webhdfs_default	hdfs	\N	localhost	\N	\N	\N	50070	f	f	\N
57	yandexcloud_default	yandexcloud	\N	\N	default	\N	\N	\N	f	f	\N
\.


--
-- Data for Name: dag; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag (dag_id, root_dag_id, is_paused, is_subdag, is_active, last_parsed_time, last_pickled, last_expired, scheduler_lock, pickle_id, fileloc, processor_subdir, owners, description, default_view, schedule_interval, timetable_description, max_active_tasks, max_active_runs, has_task_concurrency_limits, has_import_errors, next_dagrun, next_dagrun_data_interval_start, next_dagrun_data_interval_end, next_dagrun_create_after) FROM stdin;
censo_etl_pipeline	\N	t	f	t	2025-10-17 21:42:26.722174+00	\N	\N	\N	\N	/opt/airflow/dags/censo_etl_pipeline.py	/opt/airflow/dags	etl_team	Pipeline ETL para dados do Censo 2022	grid	"@daily"	At 00:00	16	1	f	f	2025-01-01 00:00:00+00	2025-01-01 00:00:00+00	2025-01-02 00:00:00+00	2025-01-02 00:00:00+00
censo_monitoring	\N	t	f	t	2025-10-17 21:42:28.067072+00	\N	\N	\N	\N	/opt/airflow/dags/censo_monitoring.py	/opt/airflow/dags	etl_team	Monitoramento e alertas do pipeline ETL Censo 2022	grid	"0 6 * * *"	At 06:00	16	1	f	f	2025-01-01 06:00:00+00	2025-01-01 06:00:00+00	2025-01-02 06:00:00+00	2025-01-02 06:00:00+00
\.


--
-- Data for Name: dag_code; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_code (fileloc_hash, fileloc, last_updated, source_code) FROM stdin;
819038133344957	/opt/airflow/dags/censo_etl_pipeline.py	2025-10-17 20:02:33.767053+00	"""\nDAG para Pipeline ETL Censo 2022\nOrquestra a execução dos notebooks Bronze, Silver e Gold\n"""\n\nfrom datetime import datetime, timedelta\nfrom airflow import DAG\nfrom airflow.operators.bash import BashOperator\nfrom airflow.operators.python import PythonOperator\nfrom airflow.operators.dummy import DummyOperator\nfrom airflow.sensors.filesystem import FileSensor\nimport os\n\n# Configurações padrão do DAG\ndefault_args = {\n    'owner': 'etl_team',\n    'depends_on_past': False,\n    'start_date': datetime(2025, 1, 1),\n    'email_on_failure': False,\n    'email_on_retry': False,\n    'retries': 1,\n    'retry_delay': timedelta(minutes=5),\n    'catchup': False\n}\n\n# Definição do DAG\ndag = DAG(\n    'censo_etl_pipeline',\n    default_args=default_args,\n    description='Pipeline ETL para dados do Censo 2022',\n    schedule_interval='@daily',  # Executa diariamente\n    max_active_runs=1,\n    tags=['censo', 'etl', 'brasil']\n)\n\n# Função para verificar se os dados estão disponíveis\ndef check_data_availability():\n    """Verifica se os arquivos CSV estão disponíveis"""\n    data_dir = "/app/data"\n    required_files = [\n        "Censo 2022 - População por sexo - Brasil.csv",\n        "Censo 2022 - População por cor ou raça - Brasil.csv",\n        "Censo 2022 - Nível de instrução - Brasil.csv"\n    ]\n    \n    missing_files = []\n    for file in required_files:\n        if not os.path.exists(os.path.join(data_dir, file)):\n            missing_files.append(file)\n    \n    if missing_files:\n        raise FileNotFoundError(f"Arquivos não encontrados: {missing_files}")\n    \n    print("✅ Todos os arquivos de dados estão disponíveis")\n    return True\n\n# Função para executar teste do pipeline\ndef test_pipeline():\n    """Executa o teste do pipeline"""\n    import subprocess\n    result = subprocess.run(\n        ["python", "/app/test_pipeline.py"],\n        capture_output=True,\n        text=True,\n        cwd="/app"\n    )\n    \n    if result.returncode != 0:\n        raise Exception(f"Teste do pipeline falhou: {result.stderr}")\n    \n    print("✅ Pipeline testado com sucesso")\n    return True\n\n# Tarefas do DAG\n\n# 1. Verificação inicial\nstart_task = DummyOperator(\n    task_id='start',\n    dag=dag\n)\n\n# 2. Verificar disponibilidade dos dados\ncheck_data = PythonOperator(\n    task_id='check_data_availability',\n    python_callable=check_data_availability,\n    dag=dag\n)\n\n# 3. Executar notebook Bronze\nbronze_task = BashOperator(\n    task_id='execute_bronze_layer',\n    bash_command="""\n    cd /app && \\\n    jupyter nbconvert --to notebook --execute notebooks/bronze.ipynb \\\n    --output bronze_executed.ipynb \\\n    --ExecutePreprocessor.timeout=600\n    """,\n    dag=dag\n)\n\n# 4. Executar notebook Silver\nsilver_task = BashOperator(\n    task_id='execute_silver_layer',\n    bash_command="""\n    cd /app && \\\n    jupyter nbconvert --to notebook --execute notebooks/silver.ipynb \\\n    --output silver_executed.ipynb \\\n    --ExecutePreprocessor.timeout=600\n    """,\n    dag=dag\n)\n\n# 5. Executar notebook Gold\ngold_task = BashOperator(\n    task_id='execute_gold_layer',\n    bash_command="""\n    cd /app && \\\n    jupyter nbconvert --to notebook --execute notebooks/gold.ipynb \\\n    --output gold_executed.ipynb \\\n    --ExecutePreprocessor.timeout=600\n    """,\n    dag=dag\n)\n\n# 6. Testar pipeline completo\ntest_pipeline_task = PythonOperator(\n    task_id='test_pipeline',\n    python_callable=test_pipeline,\n    dag=dag\n)\n\n# 7. Limpeza de arquivos temporários\ncleanup_task = BashOperator(\n    task_id='cleanup_temp_files',\n    bash_command="""\n    cd /app && \\\n    rm -f *_executed.ipynb && \\\n    echo "✅ Arquivos temporários removidos"\n    """,\n    dag=dag\n)\n\n# 8. Finalização\nend_task = DummyOperator(\n    task_id='end',\n    dag=dag\n)\n\n# Definição das dependências\nstart_task >> check_data >> bronze_task >> silver_task >> gold_task >> test_pipeline_task >> cleanup_task >> end_task\n\n
41038294247628675	/opt/airflow/dags/censo_monitoring.py	2025-10-17 20:02:33.827046+00	"""\nDAG para Monitoramento do Pipeline ETL Censo 2022\nVerifica a saúde dos dados e gera alertas\n"""\n\nfrom datetime import datetime, timedelta\nfrom airflow import DAG\nfrom airflow.operators.python import PythonOperator\nfrom airflow.operators.dummy import DummyOperator\nfrom airflow.operators.email import EmailOperator\nimport pandas as pd\nfrom sqlalchemy import create_engine, text\n\n# Configurações padrão do DAG\ndefault_args = {\n    'owner': 'etl_team',\n    'depends_on_past': False,\n    'start_date': datetime(2025, 1, 1),\n    'email_on_failure': True,\n    'email_on_retry': False,\n    'retries': 1,\n    'retry_delay': timedelta(minutes=5),\n    'catchup': False\n}\n\n# Definição do DAG\ndag = DAG(\n    'censo_monitoring',\n    default_args=default_args,\n    description='Monitoramento e alertas do pipeline ETL Censo 2022',\n    schedule_interval='0 6 * * *',  # Executa às 6h da manhã\n    max_active_runs=1,\n    tags=['censo', 'monitoring', 'alerts']\n)\n\ndef check_data_quality():\n    """Verifica a qualidade dos dados"""\n    engine = create_engine('postgresql+psycopg2://etl_user:etl_password@db:5432/etl_censo')\n    \n    issues = []\n    \n    with engine.connect() as conn:\n        # Verificar se as tabelas têm dados\n        tables_to_check = [\n            ('bronze', 'populacao_sexo'),\n            ('silver', 'fato_trabalho'),\n            ('gold', 'fato_indicadores_renda')\n        ]\n        \n        for schema, table in tables_to_check:\n            result = conn.execute(text(f"SELECT COUNT(*) FROM {schema}.{table}")).fetchone()\n            count = result[0]\n            \n            if count == 0:\n                issues.append(f"Tabela {schema}.{table} está vazia")\n            else:\n                print(f"✅ {schema}.{table}: {count} registros")\n        \n        # Verificar indicadores críticos\n        result = conn.execute(text("""\n            SELECT \n                AVG(percentual_ate_1sm) as avg_ate_1sm,\n                AVG(rendimento_medio_uf) as avg_rendimento\n            FROM gold.fato_indicadores_renda\n        """)).fetchone()\n        \n        if result:\n            avg_ate_1sm, avg_rendimento = result\n            if avg_ate_1sm > 50:\n                issues.append(f"Percentual de trabalhadores até 1 SM muito alto: {avg_ate_1sm:.2f}%")\n            if avg_rendimento < 1000:\n                issues.append(f"Rendimento médio muito baixo: R$ {avg_rendimento:.2f}")\n    \n    if issues:\n        raise Exception(f"Problemas de qualidade encontrados: {'; '.join(issues)}")\n    \n    print("✅ Qualidade dos dados verificada com sucesso")\n    return True\n\ndef generate_daily_report():\n    """Gera relatório diário dos indicadores"""\n    engine = create_engine('postgresql+psycopg2://etl_user:etl_password@db:5432/etl_censo')\n    \n    with engine.connect() as conn:\n        # Buscar indicadores principais\n        result = conn.execute(text("""\n            SELECT \n                uf,\n                percentual_ate_1sm,\n                percentual_mais_5sm,\n                rendimento_medio_uf,\n                indice_gini\n            FROM gold.fato_indicadores_renda\n            ORDER BY rendimento_medio_uf DESC\n            LIMIT 10\n        """)).fetchall()\n        \n        print("\\n📊 TOP 10 UFs POR RENDIMENTO MÉDIO:")\n        print("=" * 80)\n        for row in result:\n            print(f"{row[0]:2s} | {row[1]:6.2f}% | {row[2]:6.2f}% | R$ {row[3]:8,.2f} | {row[4]:.4f}")\n        \n        # Estatísticas gerais\n        stats = conn.execute(text("""\n            SELECT \n                AVG(percentual_ate_1sm) as avg_ate_1sm,\n                AVG(percentual_mais_5sm) as avg_mais_5sm,\n                AVG(rendimento_medio_uf) as avg_rendimento,\n                AVG(indice_gini) as avg_gini\n            FROM gold.fato_indicadores_renda\n        """)).fetchone()\n        \n        print(f"\\n📈 ESTATÍSTICAS GERAIS:")\n        print(f"Trabalhadores até 1 SM: {stats[0]:.2f}%")\n        print(f"Trabalhadores > 5 SM: {stats[1]:.2f}%")\n        print(f"Rendimento médio: R$ {stats[2]:,.2f}")\n        print(f"Índice de Gini médio: {stats[3]:.4f}")\n    \n    return True\n\n# Tarefas do DAG\n\nstart_monitoring = DummyOperator(\n    task_id='start_monitoring',\n    dag=dag\n)\n\ncheck_quality = PythonOperator(\n    task_id='check_data_quality',\n    python_callable=check_data_quality,\n    dag=dag\n)\n\ngenerate_report = PythonOperator(\n    task_id='generate_daily_report',\n    python_callable=generate_daily_report,\n    dag=dag\n)\n\nend_monitoring = DummyOperator(\n    task_id='end_monitoring',\n    dag=dag\n)\n\n# Dependências\nstart_monitoring >> check_quality >> generate_report >> end_monitoring\n\n
\.


--
-- Data for Name: dag_owner_attributes; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_owner_attributes (dag_id, owner, link) FROM stdin;
\.


--
-- Data for Name: dag_pickle; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_pickle (id, pickle, created_dttm, pickle_hash) FROM stdin;
\.


--
-- Data for Name: dag_run; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_run (id, dag_id, queued_at, execution_date, start_date, end_date, state, run_id, creating_job_id, external_trigger, run_type, conf, data_interval_start, data_interval_end, last_scheduling_decision, dag_hash, log_template_id, updated_at, clear_number) FROM stdin;
\.


--
-- Data for Name: dag_run_note; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_run_note (user_id, dag_run_id, content, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dag_schedule_dataset_reference; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_schedule_dataset_reference (dataset_id, dag_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dag_tag; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_tag (name, dag_id) FROM stdin;
etl	censo_etl_pipeline
censo	censo_etl_pipeline
brasil	censo_etl_pipeline
alerts	censo_monitoring
censo	censo_monitoring
monitoring	censo_monitoring
\.


--
-- Data for Name: dag_warning; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dag_warning (dag_id, warning_type, message, "timestamp") FROM stdin;
\.


--
-- Data for Name: dagrun_dataset_event; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dagrun_dataset_event (dag_run_id, event_id) FROM stdin;
\.


--
-- Data for Name: dataset; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dataset (id, uri, extra, created_at, updated_at, is_orphaned) FROM stdin;
\.


--
-- Data for Name: dataset_dag_run_queue; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dataset_dag_run_queue (dataset_id, target_dag_id, created_at) FROM stdin;
\.


--
-- Data for Name: dataset_event; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.dataset_event (id, dataset_id, extra, source_task_id, source_dag_id, source_run_id, source_map_index, "timestamp") FROM stdin;
\.


--
-- Data for Name: import_error; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.import_error (id, "timestamp", filename, stacktrace, processor_subdir) FROM stdin;
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.job (id, dag_id, state, job_type, start_date, end_date, latest_heartbeat, executor_class, hostname, unixname) FROM stdin;
2	\N	running	SchedulerJob	2025-10-17 20:59:06.158093+00	\N	2025-10-17 21:42:26.556097+00	\N	e779432b0bf7	airflow
1	\N	failed	SchedulerJob	2025-10-17 02:15:54.808443+00	\N	2025-10-17 12:37:24.463926+00	\N	e779432b0bf7	airflow
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.log (id, dttm, dag_id, task_id, map_index, event, execution_date, owner, owner_display_name, extra) FROM stdin;
1	2025-10-17 02:15:50.417644+00	\N	\N	\N	cli_scheduler	\N	airflow	\N	{"host_name": "e779432b0bf7", "full_command": "['/home/airflow/.local/bin/airflow', 'scheduler']"}
2	2025-10-17 02:15:53.727192+00	\N	\N	\N	cli_users_create	\N	airflow	\N	{"host_name": "2dc60844097f", "full_command": "['/home/airflow/.local/bin/airflow', 'users', 'create', '--username', 'admin', '--firstname', 'Admin', '--lastname', 'User', '--role', 'Admin', '--email', 'admin@example.com', '--password', '********']"}
3	2025-10-17 20:58:41.520679+00	\N	\N	\N	cli_check	\N	airflow	\N	{"host_name": "fb9db73160c5", "full_command": "['/home/airflow/.local/bin/airflow', 'db', 'check']"}
5	2025-10-17 20:58:41.521187+00	\N	\N	\N	cli_check	\N	airflow	\N	{"host_name": "2dc60844097f", "full_command": "['/home/airflow/.local/bin/airflow', 'db', 'check']"}
4	2025-10-17 20:58:41.520981+00	\N	\N	\N	cli_check	\N	airflow	\N	{"host_name": "e779432b0bf7", "full_command": "['/home/airflow/.local/bin/airflow', 'db', 'check']"}
6	2025-10-17 20:58:59.72243+00	\N	\N	\N	cli_webserver	\N	airflow	\N	{"host_name": "fb9db73160c5", "full_command": "['/home/airflow/.local/bin/airflow', 'webserver']"}
7	2025-10-17 20:59:04.833302+00	\N	\N	\N	cli_scheduler	\N	airflow	\N	{"host_name": "e779432b0bf7", "full_command": "['/home/airflow/.local/bin/airflow', 'scheduler']"}
8	2025-10-17 20:59:11.470091+00	\N	\N	\N	cli_users_create	\N	airflow	\N	{"host_name": "2dc60844097f", "full_command": "['/home/airflow/.local/bin/airflow', 'users', 'create', '--username', 'admin', '--firstname', 'Admin', '--lastname', 'User', '--role', 'Admin', '--email', 'admin@example.com', '--password', '********']"}
\.


--
-- Data for Name: log_template; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.log_template (id, filename, elasticsearch_id, created_at) FROM stdin;
1	{{ ti.dag_id }}/{{ ti.task_id }}/{{ ts }}/{{ try_number }}.log	{dag_id}-{task_id}-{execution_date}-{try_number}	2025-10-17 02:15:47.514158+00
2	dag_id={{ ti.dag_id }}/run_id={{ ti.run_id }}/task_id={{ ti.task_id }}/{% if ti.map_index >= 0 %}map_index={{ ti.map_index }}/{% endif %}attempt={{ try_number }}.log	{dag_id}-{task_id}-{run_id}-{map_index}-{try_number}	2025-10-17 02:15:47.514179+00
3	{{ ti.dag_id }}/{{ ti.task_id }}/{{ ts }}/{{ try_number }}.log	{dag_id}-{task_id}-{execution_date}-{try_number}	2025-10-17 02:15:47.831941+00
4	dag_id={{ ti.dag_id }}/run_id={{ ti.run_id }}/task_id={{ ti.task_id }}/{% if ti.map_index >= 0 %}map_index={{ ti.map_index }}/{% endif %}attempt={{ try_number }}.log	{dag_id}-{task_id}-{run_id}-{map_index}-{try_number}	2025-10-17 02:15:47.831954+00
\.


--
-- Data for Name: rendered_task_instance_fields; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.rendered_task_instance_fields (dag_id, task_id, run_id, map_index, rendered_fields, k8s_pod_yaml) FROM stdin;
\.


--
-- Data for Name: serialized_dag; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.serialized_dag (dag_id, fileloc, fileloc_hash, data, data_compressed, last_updated, dag_hash, processor_subdir) FROM stdin;
censo_etl_pipeline	/opt/airflow/dags/censo_etl_pipeline.py	819038133344957	{"__version": 1, "dag": {"fileloc": "/opt/airflow/dags/censo_etl_pipeline.py", "schedule_interval": "@daily", "_dag_id": "censo_etl_pipeline", "default_args": {"__var": {"owner": "etl_team", "depends_on_past": false, "start_date": {"__var": 1735689600.0, "__type": "datetime"}, "email_on_failure": false, "email_on_retry": false, "retries": 1, "retry_delay": {"__var": 300.0, "__type": "timedelta"}, "catchup": false}, "__type": "dict"}, "_task_group": {"_group_id": null, "prefix_group_id": true, "tooltip": "", "ui_color": "CornflowerBlue", "ui_fgcolor": "#000", "children": {"start": ["operator", "start"], "check_data_availability": ["operator", "check_data_availability"], "execute_bronze_layer": ["operator", "execute_bronze_layer"], "execute_silver_layer": ["operator", "execute_silver_layer"], "execute_gold_layer": ["operator", "execute_gold_layer"], "test_pipeline": ["operator", "test_pipeline"], "cleanup_temp_files": ["operator", "cleanup_temp_files"], "end": ["operator", "end"]}, "upstream_group_ids": [], "downstream_group_ids": [], "upstream_task_ids": [], "downstream_task_ids": []}, "edge_info": {}, "timezone": "UTC", "max_active_runs": 1, "dataset_triggers": [], "tags": ["censo", "etl", "brasil"], "_description": "Pipeline ETL para dados do Censo 2022", "_processor_dags_folder": "/opt/airflow/dags", "tasks": [{"start_date": 1735689600.0, "template_fields": [], "email_on_retry": false, "template_fields_renderers": {}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#e8f7e4", "email_on_failure": false, "downstream_task_ids": ["check_data_availability"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "start", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "EmptyOperator", "_task_module": "airflow.operators.empty", "_is_empty": true}, {"start_date": 1735689600.0, "template_fields": ["templates_dict", "op_args", "op_kwargs"], "email_on_retry": false, "template_fields_renderers": {"templates_dict": "json", "op_args": "py", "op_kwargs": "py"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#ffefeb", "email_on_failure": false, "downstream_task_ids": ["execute_bronze_layer"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "check_data_availability", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "PythonOperator", "_task_module": "airflow.operators.python", "_is_empty": false, "op_args": [], "op_kwargs": {}}, {"start_date": 1735689600.0, "template_fields": ["bash_command", "env"], "email_on_retry": false, "template_fields_renderers": {"bash_command": "bash", "env": "json"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#f0ede4", "email_on_failure": false, "downstream_task_ids": ["execute_silver_layer"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [".sh", ".bash"], "retry_delay": 300.0, "task_id": "execute_bronze_layer", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "BashOperator", "_task_module": "airflow.operators.bash", "_is_empty": false, "bash_command": "\\n    cd /app &&     jupyter nbconvert --to notebook --execute notebooks/bronze.ipynb     --output bronze_executed.ipynb     --ExecutePreprocessor.timeout=600\\n    "}, {"start_date": 1735689600.0, "template_fields": ["bash_command", "env"], "email_on_retry": false, "template_fields_renderers": {"bash_command": "bash", "env": "json"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#f0ede4", "email_on_failure": false, "downstream_task_ids": ["execute_gold_layer"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [".sh", ".bash"], "retry_delay": 300.0, "task_id": "execute_silver_layer", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "BashOperator", "_task_module": "airflow.operators.bash", "_is_empty": false, "bash_command": "\\n    cd /app &&     jupyter nbconvert --to notebook --execute notebooks/silver.ipynb     --output silver_executed.ipynb     --ExecutePreprocessor.timeout=600\\n    "}, {"start_date": 1735689600.0, "template_fields": ["bash_command", "env"], "email_on_retry": false, "template_fields_renderers": {"bash_command": "bash", "env": "json"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#f0ede4", "email_on_failure": false, "downstream_task_ids": ["test_pipeline"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [".sh", ".bash"], "retry_delay": 300.0, "task_id": "execute_gold_layer", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "BashOperator", "_task_module": "airflow.operators.bash", "_is_empty": false, "bash_command": "\\n    cd /app &&     jupyter nbconvert --to notebook --execute notebooks/gold.ipynb     --output gold_executed.ipynb     --ExecutePreprocessor.timeout=600\\n    "}, {"start_date": 1735689600.0, "template_fields": ["templates_dict", "op_args", "op_kwargs"], "email_on_retry": false, "template_fields_renderers": {"templates_dict": "json", "op_args": "py", "op_kwargs": "py"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#ffefeb", "email_on_failure": false, "downstream_task_ids": ["cleanup_temp_files"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "test_pipeline", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "PythonOperator", "_task_module": "airflow.operators.python", "_is_empty": false, "op_args": [], "op_kwargs": {}}, {"start_date": 1735689600.0, "template_fields": ["bash_command", "env"], "email_on_retry": false, "template_fields_renderers": {"bash_command": "bash", "env": "json"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#f0ede4", "email_on_failure": false, "downstream_task_ids": ["end"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [".sh", ".bash"], "retry_delay": 300.0, "task_id": "cleanup_temp_files", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "BashOperator", "_task_module": "airflow.operators.bash", "_is_empty": false, "bash_command": "\\n    cd /app &&     rm -f *_executed.ipynb &&     echo \\"\\u2705 Arquivos tempor\\u00e1rios removidos\\"\\n    "}, {"start_date": 1735689600.0, "template_fields": [], "email_on_retry": false, "template_fields_renderers": {}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#e8f7e4", "email_on_failure": false, "downstream_task_ids": [], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "end", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "EmptyOperator", "_task_module": "airflow.operators.empty", "_is_empty": true}], "dag_dependencies": [], "params": {}}}	\N	2025-10-17 20:59:37.963561+00	fe3b85ba32d475ae7e479b142ed50e2d	/opt/airflow/dags
censo_monitoring	/opt/airflow/dags/censo_monitoring.py	41038294247628675	{"__version": 1, "dag": {"fileloc": "/opt/airflow/dags/censo_monitoring.py", "_dag_id": "censo_monitoring", "default_args": {"__var": {"owner": "etl_team", "depends_on_past": false, "start_date": {"__var": 1735689600.0, "__type": "datetime"}, "email_on_failure": true, "email_on_retry": false, "retries": 1, "retry_delay": {"__var": 300.0, "__type": "timedelta"}, "catchup": false}, "__type": "dict"}, "_task_group": {"_group_id": null, "prefix_group_id": true, "tooltip": "", "ui_color": "CornflowerBlue", "ui_fgcolor": "#000", "children": {"start_monitoring": ["operator", "start_monitoring"], "check_data_quality": ["operator", "check_data_quality"], "generate_daily_report": ["operator", "generate_daily_report"], "end_monitoring": ["operator", "end_monitoring"]}, "upstream_group_ids": [], "downstream_group_ids": [], "upstream_task_ids": [], "downstream_task_ids": []}, "edge_info": {}, "timezone": "UTC", "max_active_runs": 1, "dataset_triggers": [], "timetable": {"__type": "airflow.timetables.interval.CronDataIntervalTimetable", "__var": {"expression": "0 6 * * *", "timezone": "UTC"}}, "tags": ["censo", "monitoring", "alerts"], "_description": "Monitoramento e alertas do pipeline ETL Censo 2022", "_processor_dags_folder": "/opt/airflow/dags", "tasks": [{"start_date": 1735689600.0, "template_fields": [], "email_on_retry": false, "template_fields_renderers": {}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#e8f7e4", "downstream_task_ids": ["check_data_quality"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "start_monitoring", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "EmptyOperator", "_task_module": "airflow.operators.empty", "_is_empty": true}, {"start_date": 1735689600.0, "template_fields": ["templates_dict", "op_args", "op_kwargs"], "email_on_retry": false, "template_fields_renderers": {"templates_dict": "json", "op_args": "py", "op_kwargs": "py"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#ffefeb", "downstream_task_ids": ["generate_daily_report"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "check_data_quality", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "PythonOperator", "_task_module": "airflow.operators.python", "_is_empty": false, "op_args": [], "op_kwargs": {}}, {"start_date": 1735689600.0, "template_fields": ["templates_dict", "op_args", "op_kwargs"], "email_on_retry": false, "template_fields_renderers": {"templates_dict": "json", "op_args": "py", "op_kwargs": "py"}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#ffefeb", "downstream_task_ids": ["end_monitoring"], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "generate_daily_report", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "PythonOperator", "_task_module": "airflow.operators.python", "_is_empty": false, "op_args": [], "op_kwargs": {}}, {"start_date": 1735689600.0, "template_fields": [], "email_on_retry": false, "template_fields_renderers": {}, "on_failure_fail_dagrun": false, "retries": 1, "ui_color": "#e8f7e4", "downstream_task_ids": [], "owner": "etl_team", "_log_config_logger_name": "airflow.task.operators", "is_teardown": false, "template_ext": [], "retry_delay": 300.0, "task_id": "end_monitoring", "pool": "default_pool", "ui_fgcolor": "#000", "is_setup": false, "_task_type": "EmptyOperator", "_task_module": "airflow.operators.empty", "_is_empty": true}], "dag_dependencies": [], "params": {}}}	\N	2025-10-17 20:59:43.701224+00	ca5b0e74ce81864cb0c0e2254341ea64	/opt/airflow/dags
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.session (id, session_id, data, expiry) FROM stdin;
2	cfeb952b-e82e-47ed-91f1-4cc77ac4f282	\\x80049513010000000000007d94288c0a5f7065726d616e656e7494888c065f667265736894888c0a637372665f746f6b656e948c2834303337346536326539313237343962396336626631666561353162303733386264363332636435948c066c6f63616c65948c02656e948c085f757365725f6964944b018c035f6964948c803663363537333063323261366132663135623061393261396566633636326632343236623434336631363261663662326334636563383538623264396663303538306435343765313264333837383063323662373965613932353263613330303564326364396239633833363361663131666262366431323237303831633038948c116461675f7374617475735f66696c746572948c03616c6c94752e	2025-11-16 20:59:59.769454
1	8e2ff629-8d9f-4411-8537-a76d8b569b0f	\\x80049563000000000000007d94288c0a5f7065726d616e656e7494888c065f667265736894898c0a637372665f746f6b656e948c2834303337346536326539313237343962396336626631666561353162303733386264363332636435948c066c6f63616c65948c02656e94752e	2025-11-16 02:35:31.601207
\.


--
-- Data for Name: sla_miss; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.sla_miss (task_id, dag_id, execution_date, email_sent, "timestamp", description, notification_sent) FROM stdin;
\.


--
-- Data for Name: slot_pool; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.slot_pool (id, pool, slots, description, include_deferred) FROM stdin;
1	default_pool	128	Default pool	f
\.


--
-- Data for Name: task_fail; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.task_fail (id, task_id, dag_id, run_id, map_index, start_date, end_date, duration) FROM stdin;
\.


--
-- Data for Name: task_instance; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.task_instance (task_id, dag_id, run_id, map_index, start_date, end_date, duration, state, try_number, max_tries, hostname, unixname, job_id, pool, pool_slots, queue, priority_weight, operator, custom_operator_name, queued_dttm, queued_by_job_id, pid, executor_config, updated_at, external_executor_id, trigger_id, trigger_timeout, next_method, next_kwargs) FROM stdin;
\.


--
-- Data for Name: task_instance_note; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.task_instance_note (user_id, task_id, dag_id, run_id, map_index, content, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: task_map; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.task_map (dag_id, task_id, run_id, map_index, length, keys) FROM stdin;
\.


--
-- Data for Name: task_outlet_dataset_reference; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.task_outlet_dataset_reference (dataset_id, dag_id, task_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: task_reschedule; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.task_reschedule (id, task_id, dag_id, run_id, map_index, try_number, start_date, end_date, duration, reschedule_date) FROM stdin;
\.


--
-- Data for Name: trigger; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.trigger (id, classpath, kwargs, created_date, triggerer_id) FROM stdin;
\.


--
-- Data for Name: variable; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.variable (id, key, val, description, is_encrypted) FROM stdin;
\.


--
-- Data for Name: xcom; Type: TABLE DATA; Schema: public; Owner: etl_user
--

COPY public.xcom (dag_run_id, task_id, map_index, key, dag_id, run_id, value, "timestamp") FROM stdin;
\.


--
-- Data for Name: dim_cor_raca; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.dim_cor_raca (cor_raca_codigo, cor_raca_descricao) FROM stdin;
B	Branca
P	Parda
N	Preta
A	Amarela
I	Indígena
\.


--
-- Data for Name: dim_nivel_instrucao; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.dim_nivel_instrucao (nivel_codigo, nivel_descricao) FROM stdin;
0	Sem instrução
1	Fundamental incompleto
2	Fundamental completo
3	Médio incompleto
4	Médio completo
5	Superior incompleto
6	Superior completo
7	Pós-graduação
\.


--
-- Data for Name: dim_sexo; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.dim_sexo (sexo_codigo, sexo_descricao) FROM stdin;
M	Masculino
F	Feminino
\.


--
-- Data for Name: dim_uf; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.dim_uf (uf, regiao, nome_uf) FROM stdin;
AC	N	Acre
AM	N	Amazonas
AP	N	Amapá
PA	N	Pará
RO	N	Rondônia
RR	N	Roraima
TO	N	Tocantins
AL	NE	Alagoas
BA	NE	Bahia
CE	NE	Ceará
MA	NE	Maranhão
PB	NE	Paraíba
PE	NE	Pernambuco
PI	NE	Piauí
RN	NE	Rio Grande do Norte
SE	NE	Sergipe
ES	SE	Espírito Santo
MG	SE	Minas Gerais
RJ	SE	Rio de Janeiro
SP	SE	São Paulo
PR	S	Paraná
RS	S	Rio Grande do Sul
SC	S	Santa Catarina
DF	CO	Distrito Federal
GO	CO	Goiás
MS	CO	Mato Grosso do Sul
MT	CO	Mato Grosso
\.


--
-- Data for Name: fato_caracteristicas_domicilio; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.fato_caracteristicas_domicilio (caracteristica, nao_possui_percentual, possui_percentual, recorte_geografico, ano) FROM stdin;
Conectados à rede de esgoto	\N	\N	Brasil	2022
Abastecidos pela rede geral de água	\N	\N	Brasil	2022
Têm banheiro de uso exclusivo	\N	\N	Brasil	2022
Têm coleta de lixo	\N	\N	Brasil	2022
\.


--
-- Data for Name: fato_crescimento_populacional; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.fato_crescimento_populacional (ano_pesquisa, populacao_pessoas, recorte_geografico, crescimento_anual, taxa_crescimento) FROM stdin;
1872	9930478	Brasil	\N	\N
1890	14333915	Brasil	4403437	44.34
1900	17438434	Brasil	3104519	21.66
1920	30635605	Brasil	13197171	75.68
1940	41236315	Brasil	10600710	34.6
1950	51944397	Brasil	10708082	25.97
1960	70992343	Brasil	19047946	36.67
1970	94508583	Brasil	23516240	33.13
1980	121150573	Brasil	26641990	28.19
1991	146917459	Brasil	25766886	21.27
2000	169872856	Brasil	22955397	15.62
2010	190755799	Brasil	20882943	12.29
2022	203080756	Brasil	12324957	6.46
\.


--
-- Data for Name: fato_demografico; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.fato_demografico (id, sexo_codigo, cor_raca_codigo, nivel_instrucao_codigo, populacao_pessoas, percentual, ano, recorte_geografico) FROM stdin;
\.


--
-- Data for Name: fato_territorio; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.fato_territorio (ano_pesquisa, area_km2, densidade_demografica, recorte_geografico) FROM stdin;
2022	8510417.77	23.86	Brasil
\.


--
-- Data for Name: fato_trabalho; Type: TABLE DATA; Schema: silver; Owner: etl_user
--

COPY silver.fato_trabalho (uf, cod_municipio, sexo, raca_cor, faixa_rendimento_sm, rendimento_mensal_nominal, populacao_ocupada, ano) FROM stdin;
AC	0000000	M	B	ate_1sm	520.8	213246	2022
AC	0000000	M	P	ate_1sm	390.6	223164	2022
AC	0000000	M	N	ate_1sm	390.6	49592	2022
AC	0000000	M	A	ate_1sm	520.8	4959	2022
AC	0000000	M	I	ate_1sm	520.8	4959	2022
AC	0000000	F	B	ate_1sm	416.64	174474	2022
AC	0000000	F	P	ate_1sm	312.48	182589	2022
AC	0000000	F	N	ate_1sm	312.48	40575	2022
AC	0000000	F	A	ate_1sm	416.64	4057	2022
AC	0000000	F	I	ate_1sm	416.64	4057	2022
AC	0000000	M	B	1_a_2sm	1562.4	144085	2022
AC	0000000	M	P	1_a_2sm	1171.8	150787	2022
AC	0000000	M	N	1_a_2sm	1171.8	33508	2022
AC	0000000	M	A	1_a_2sm	1562.4	3350	2022
AC	0000000	M	I	1_a_2sm	1562.4	3350	2022
AC	0000000	F	B	1_a_2sm	1249.92	117887	2022
AC	0000000	F	P	1_a_2sm	937.44	123371	2022
AC	0000000	F	N	1_a_2sm	937.44	27415	2022
AC	0000000	F	A	1_a_2sm	1249.92	2741	2022
AC	0000000	F	I	1_a_2sm	1249.92	2741	2022
AC	0000000	M	B	2_a_5sm	3645.6	103741	2022
AC	0000000	M	P	2_a_5sm	2734.2	108566	2022
AC	0000000	M	N	2_a_5sm	2734.2	24125	2022
AC	0000000	M	A	2_a_5sm	3645.6	2412	2022
AC	0000000	M	I	2_a_5sm	3645.6	2412	2022
AC	0000000	F	B	2_a_5sm	2916.48	84879	2022
AC	0000000	F	P	2_a_5sm	2187.36	88827	2022
AC	0000000	F	N	2_a_5sm	2187.36	19739	2022
AC	0000000	F	A	2_a_5sm	2916.48	1973	2022
AC	0000000	F	I	2_a_5sm	2916.48	1973	2022
AC	0000000	M	B	5_a_20sm	13020	86451	2022
AC	0000000	M	P	5_a_20sm	9765	90472	2022
AC	0000000	M	N	5_a_20sm	9765	20104	2022
AC	0000000	M	A	5_a_20sm	13020	2010	2022
AC	0000000	M	I	5_a_20sm	13020	2010	2022
AC	0000000	F	B	5_a_20sm	10416	70732	2022
AC	0000000	F	P	5_a_20sm	7812	74022	2022
AC	0000000	F	N	5_a_20sm	7812	16449	2022
AC	0000000	F	A	5_a_20sm	10416	1644	2022
AC	0000000	F	I	5_a_20sm	10416	1644	2022
AC	0000000	M	B	mais_20sm	36456	28816	2022
AC	0000000	M	P	mais_20sm	27342	30157	2022
AC	0000000	M	N	mais_20sm	27342	6701	2022
AC	0000000	M	A	mais_20sm	36456	670	2022
AC	0000000	M	I	mais_20sm	36456	670	2022
AC	0000000	F	B	mais_20sm	29164.8	23577	2022
AC	0000000	F	P	mais_20sm	21873.6	24673	2022
AC	0000000	F	N	mais_20sm	21873.6	5483	2022
AC	0000000	F	A	mais_20sm	29164.8	548	2022
AC	0000000	F	I	mais_20sm	29164.8	548	2022
AM	0000000	M	B	ate_1sm	520.8	213246	2022
AM	0000000	M	P	ate_1sm	390.6	223164	2022
AM	0000000	M	N	ate_1sm	390.6	49592	2022
AM	0000000	M	A	ate_1sm	520.8	4959	2022
AM	0000000	M	I	ate_1sm	520.8	4959	2022
AM	0000000	F	B	ate_1sm	416.64	174474	2022
AM	0000000	F	P	ate_1sm	312.48	182589	2022
AM	0000000	F	N	ate_1sm	312.48	40575	2022
AM	0000000	F	A	ate_1sm	416.64	4057	2022
AM	0000000	F	I	ate_1sm	416.64	4057	2022
AM	0000000	M	B	1_a_2sm	1562.4	144085	2022
AM	0000000	M	P	1_a_2sm	1171.8	150787	2022
AM	0000000	M	N	1_a_2sm	1171.8	33508	2022
AM	0000000	M	A	1_a_2sm	1562.4	3350	2022
AM	0000000	M	I	1_a_2sm	1562.4	3350	2022
AM	0000000	F	B	1_a_2sm	1249.92	117887	2022
AM	0000000	F	P	1_a_2sm	937.44	123371	2022
AM	0000000	F	N	1_a_2sm	937.44	27415	2022
AM	0000000	F	A	1_a_2sm	1249.92	2741	2022
AM	0000000	F	I	1_a_2sm	1249.92	2741	2022
AM	0000000	M	B	2_a_5sm	3645.6	103741	2022
AM	0000000	M	P	2_a_5sm	2734.2	108566	2022
AM	0000000	M	N	2_a_5sm	2734.2	24125	2022
AM	0000000	M	A	2_a_5sm	3645.6	2412	2022
AM	0000000	M	I	2_a_5sm	3645.6	2412	2022
AM	0000000	F	B	2_a_5sm	2916.48	84879	2022
AM	0000000	F	P	2_a_5sm	2187.36	88827	2022
AM	0000000	F	N	2_a_5sm	2187.36	19739	2022
AM	0000000	F	A	2_a_5sm	2916.48	1973	2022
AM	0000000	F	I	2_a_5sm	2916.48	1973	2022
AM	0000000	M	B	5_a_20sm	13020	86451	2022
AM	0000000	M	P	5_a_20sm	9765	90472	2022
AM	0000000	M	N	5_a_20sm	9765	20104	2022
AM	0000000	M	A	5_a_20sm	13020	2010	2022
AM	0000000	M	I	5_a_20sm	13020	2010	2022
AM	0000000	F	B	5_a_20sm	10416	70732	2022
AM	0000000	F	P	5_a_20sm	7812	74022	2022
AM	0000000	F	N	5_a_20sm	7812	16449	2022
AM	0000000	F	A	5_a_20sm	10416	1644	2022
AM	0000000	F	I	5_a_20sm	10416	1644	2022
AM	0000000	M	B	mais_20sm	36456	28816	2022
AM	0000000	M	P	mais_20sm	27342	30157	2022
AM	0000000	M	N	mais_20sm	27342	6701	2022
AM	0000000	M	A	mais_20sm	36456	670	2022
AM	0000000	M	I	mais_20sm	36456	670	2022
AM	0000000	F	B	mais_20sm	29164.8	23577	2022
AM	0000000	F	P	mais_20sm	21873.6	24673	2022
AM	0000000	F	N	mais_20sm	21873.6	5483	2022
AM	0000000	F	A	mais_20sm	29164.8	548	2022
AM	0000000	F	I	mais_20sm	29164.8	548	2022
AP	0000000	M	B	ate_1sm	520.8	213246	2022
AP	0000000	M	P	ate_1sm	390.6	223164	2022
AP	0000000	M	N	ate_1sm	390.6	49592	2022
AP	0000000	M	A	ate_1sm	520.8	4959	2022
AP	0000000	M	I	ate_1sm	520.8	4959	2022
AP	0000000	F	B	ate_1sm	416.64	174474	2022
AP	0000000	F	P	ate_1sm	312.48	182589	2022
AP	0000000	F	N	ate_1sm	312.48	40575	2022
AP	0000000	F	A	ate_1sm	416.64	4057	2022
AP	0000000	F	I	ate_1sm	416.64	4057	2022
AP	0000000	M	B	1_a_2sm	1562.4	144085	2022
AP	0000000	M	P	1_a_2sm	1171.8	150787	2022
AP	0000000	M	N	1_a_2sm	1171.8	33508	2022
AP	0000000	M	A	1_a_2sm	1562.4	3350	2022
AP	0000000	M	I	1_a_2sm	1562.4	3350	2022
AP	0000000	F	B	1_a_2sm	1249.92	117887	2022
AP	0000000	F	P	1_a_2sm	937.44	123371	2022
AP	0000000	F	N	1_a_2sm	937.44	27415	2022
AP	0000000	F	A	1_a_2sm	1249.92	2741	2022
AP	0000000	F	I	1_a_2sm	1249.92	2741	2022
AP	0000000	M	B	2_a_5sm	3645.6	103741	2022
AP	0000000	M	P	2_a_5sm	2734.2	108566	2022
AP	0000000	M	N	2_a_5sm	2734.2	24125	2022
AP	0000000	M	A	2_a_5sm	3645.6	2412	2022
AP	0000000	M	I	2_a_5sm	3645.6	2412	2022
AP	0000000	F	B	2_a_5sm	2916.48	84879	2022
AP	0000000	F	P	2_a_5sm	2187.36	88827	2022
AP	0000000	F	N	2_a_5sm	2187.36	19739	2022
AP	0000000	F	A	2_a_5sm	2916.48	1973	2022
AP	0000000	F	I	2_a_5sm	2916.48	1973	2022
AP	0000000	M	B	5_a_20sm	13020	86451	2022
AP	0000000	M	P	5_a_20sm	9765	90472	2022
AP	0000000	M	N	5_a_20sm	9765	20104	2022
AP	0000000	M	A	5_a_20sm	13020	2010	2022
AP	0000000	M	I	5_a_20sm	13020	2010	2022
AP	0000000	F	B	5_a_20sm	10416	70732	2022
AP	0000000	F	P	5_a_20sm	7812	74022	2022
AP	0000000	F	N	5_a_20sm	7812	16449	2022
AP	0000000	F	A	5_a_20sm	10416	1644	2022
AP	0000000	F	I	5_a_20sm	10416	1644	2022
AP	0000000	M	B	mais_20sm	36456	28816	2022
AP	0000000	M	P	mais_20sm	27342	30157	2022
AP	0000000	M	N	mais_20sm	27342	6701	2022
AP	0000000	M	A	mais_20sm	36456	670	2022
AP	0000000	M	I	mais_20sm	36456	670	2022
AP	0000000	F	B	mais_20sm	29164.8	23577	2022
AP	0000000	F	P	mais_20sm	21873.6	24673	2022
AP	0000000	F	N	mais_20sm	21873.6	5483	2022
AP	0000000	F	A	mais_20sm	29164.8	548	2022
AP	0000000	F	I	mais_20sm	29164.8	548	2022
PA	0000000	M	B	ate_1sm	520.8	213246	2022
PA	0000000	M	P	ate_1sm	390.6	223164	2022
PA	0000000	M	N	ate_1sm	390.6	49592	2022
PA	0000000	M	A	ate_1sm	520.8	4959	2022
PA	0000000	M	I	ate_1sm	520.8	4959	2022
PA	0000000	F	B	ate_1sm	416.64	174474	2022
PA	0000000	F	P	ate_1sm	312.48	182589	2022
PA	0000000	F	N	ate_1sm	312.48	40575	2022
PA	0000000	F	A	ate_1sm	416.64	4057	2022
PA	0000000	F	I	ate_1sm	416.64	4057	2022
PA	0000000	M	B	1_a_2sm	1562.4	144085	2022
PA	0000000	M	P	1_a_2sm	1171.8	150787	2022
PA	0000000	M	N	1_a_2sm	1171.8	33508	2022
PA	0000000	M	A	1_a_2sm	1562.4	3350	2022
PA	0000000	M	I	1_a_2sm	1562.4	3350	2022
PA	0000000	F	B	1_a_2sm	1249.92	117887	2022
PA	0000000	F	P	1_a_2sm	937.44	123371	2022
PA	0000000	F	N	1_a_2sm	937.44	27415	2022
PA	0000000	F	A	1_a_2sm	1249.92	2741	2022
PA	0000000	F	I	1_a_2sm	1249.92	2741	2022
PA	0000000	M	B	2_a_5sm	3645.6	103741	2022
PA	0000000	M	P	2_a_5sm	2734.2	108566	2022
PA	0000000	M	N	2_a_5sm	2734.2	24125	2022
PA	0000000	M	A	2_a_5sm	3645.6	2412	2022
PA	0000000	M	I	2_a_5sm	3645.6	2412	2022
PA	0000000	F	B	2_a_5sm	2916.48	84879	2022
PA	0000000	F	P	2_a_5sm	2187.36	88827	2022
PA	0000000	F	N	2_a_5sm	2187.36	19739	2022
PA	0000000	F	A	2_a_5sm	2916.48	1973	2022
PA	0000000	F	I	2_a_5sm	2916.48	1973	2022
PA	0000000	M	B	5_a_20sm	13020	86451	2022
PA	0000000	M	P	5_a_20sm	9765	90472	2022
PA	0000000	M	N	5_a_20sm	9765	20104	2022
PA	0000000	M	A	5_a_20sm	13020	2010	2022
PA	0000000	M	I	5_a_20sm	13020	2010	2022
PA	0000000	F	B	5_a_20sm	10416	70732	2022
PA	0000000	F	P	5_a_20sm	7812	74022	2022
PA	0000000	F	N	5_a_20sm	7812	16449	2022
PA	0000000	F	A	5_a_20sm	10416	1644	2022
PA	0000000	F	I	5_a_20sm	10416	1644	2022
PA	0000000	M	B	mais_20sm	36456	28816	2022
PA	0000000	M	P	mais_20sm	27342	30157	2022
PA	0000000	M	N	mais_20sm	27342	6701	2022
PA	0000000	M	A	mais_20sm	36456	670	2022
PA	0000000	M	I	mais_20sm	36456	670	2022
PA	0000000	F	B	mais_20sm	29164.8	23577	2022
PA	0000000	F	P	mais_20sm	21873.6	24673	2022
PA	0000000	F	N	mais_20sm	21873.6	5483	2022
PA	0000000	F	A	mais_20sm	29164.8	548	2022
PA	0000000	F	I	mais_20sm	29164.8	548	2022
RO	0000000	M	B	ate_1sm	520.8	213246	2022
RO	0000000	M	P	ate_1sm	390.6	223164	2022
RO	0000000	M	N	ate_1sm	390.6	49592	2022
RO	0000000	M	A	ate_1sm	520.8	4959	2022
RO	0000000	M	I	ate_1sm	520.8	4959	2022
RO	0000000	F	B	ate_1sm	416.64	174474	2022
RO	0000000	F	P	ate_1sm	312.48	182589	2022
RO	0000000	F	N	ate_1sm	312.48	40575	2022
RO	0000000	F	A	ate_1sm	416.64	4057	2022
RO	0000000	F	I	ate_1sm	416.64	4057	2022
RO	0000000	M	B	1_a_2sm	1562.4	144085	2022
RO	0000000	M	P	1_a_2sm	1171.8	150787	2022
RO	0000000	M	N	1_a_2sm	1171.8	33508	2022
RO	0000000	M	A	1_a_2sm	1562.4	3350	2022
RO	0000000	M	I	1_a_2sm	1562.4	3350	2022
RO	0000000	F	B	1_a_2sm	1249.92	117887	2022
RO	0000000	F	P	1_a_2sm	937.44	123371	2022
RO	0000000	F	N	1_a_2sm	937.44	27415	2022
RO	0000000	F	A	1_a_2sm	1249.92	2741	2022
RO	0000000	F	I	1_a_2sm	1249.92	2741	2022
RO	0000000	M	B	2_a_5sm	3645.6	103741	2022
RO	0000000	M	P	2_a_5sm	2734.2	108566	2022
RO	0000000	M	N	2_a_5sm	2734.2	24125	2022
RO	0000000	M	A	2_a_5sm	3645.6	2412	2022
RO	0000000	M	I	2_a_5sm	3645.6	2412	2022
RO	0000000	F	B	2_a_5sm	2916.48	84879	2022
RO	0000000	F	P	2_a_5sm	2187.36	88827	2022
RO	0000000	F	N	2_a_5sm	2187.36	19739	2022
RO	0000000	F	A	2_a_5sm	2916.48	1973	2022
RO	0000000	F	I	2_a_5sm	2916.48	1973	2022
RO	0000000	M	B	5_a_20sm	13020	86451	2022
RO	0000000	M	P	5_a_20sm	9765	90472	2022
RO	0000000	M	N	5_a_20sm	9765	20104	2022
RO	0000000	M	A	5_a_20sm	13020	2010	2022
RO	0000000	M	I	5_a_20sm	13020	2010	2022
RO	0000000	F	B	5_a_20sm	10416	70732	2022
RO	0000000	F	P	5_a_20sm	7812	74022	2022
RO	0000000	F	N	5_a_20sm	7812	16449	2022
RO	0000000	F	A	5_a_20sm	10416	1644	2022
RO	0000000	F	I	5_a_20sm	10416	1644	2022
RO	0000000	M	B	mais_20sm	36456	28816	2022
RO	0000000	M	P	mais_20sm	27342	30157	2022
RO	0000000	M	N	mais_20sm	27342	6701	2022
RO	0000000	M	A	mais_20sm	36456	670	2022
RO	0000000	M	I	mais_20sm	36456	670	2022
RO	0000000	F	B	mais_20sm	29164.8	23577	2022
RO	0000000	F	P	mais_20sm	21873.6	24673	2022
RO	0000000	F	N	mais_20sm	21873.6	5483	2022
RO	0000000	F	A	mais_20sm	29164.8	548	2022
RO	0000000	F	I	mais_20sm	29164.8	548	2022
RR	0000000	M	B	ate_1sm	520.8	213246	2022
RR	0000000	M	P	ate_1sm	390.6	223164	2022
RR	0000000	M	N	ate_1sm	390.6	49592	2022
RR	0000000	M	A	ate_1sm	520.8	4959	2022
RR	0000000	M	I	ate_1sm	520.8	4959	2022
RR	0000000	F	B	ate_1sm	416.64	174474	2022
RR	0000000	F	P	ate_1sm	312.48	182589	2022
RR	0000000	F	N	ate_1sm	312.48	40575	2022
RR	0000000	F	A	ate_1sm	416.64	4057	2022
RR	0000000	F	I	ate_1sm	416.64	4057	2022
RR	0000000	M	B	1_a_2sm	1562.4	144085	2022
RR	0000000	M	P	1_a_2sm	1171.8	150787	2022
RR	0000000	M	N	1_a_2sm	1171.8	33508	2022
RR	0000000	M	A	1_a_2sm	1562.4	3350	2022
RR	0000000	M	I	1_a_2sm	1562.4	3350	2022
RR	0000000	F	B	1_a_2sm	1249.92	117887	2022
RR	0000000	F	P	1_a_2sm	937.44	123371	2022
RR	0000000	F	N	1_a_2sm	937.44	27415	2022
RR	0000000	F	A	1_a_2sm	1249.92	2741	2022
RR	0000000	F	I	1_a_2sm	1249.92	2741	2022
RR	0000000	M	B	2_a_5sm	3645.6	103741	2022
RR	0000000	M	P	2_a_5sm	2734.2	108566	2022
RR	0000000	M	N	2_a_5sm	2734.2	24125	2022
RR	0000000	M	A	2_a_5sm	3645.6	2412	2022
RR	0000000	M	I	2_a_5sm	3645.6	2412	2022
RR	0000000	F	B	2_a_5sm	2916.48	84879	2022
RR	0000000	F	P	2_a_5sm	2187.36	88827	2022
RR	0000000	F	N	2_a_5sm	2187.36	19739	2022
RR	0000000	F	A	2_a_5sm	2916.48	1973	2022
RR	0000000	F	I	2_a_5sm	2916.48	1973	2022
RR	0000000	M	B	5_a_20sm	13020	86451	2022
RR	0000000	M	P	5_a_20sm	9765	90472	2022
RR	0000000	M	N	5_a_20sm	9765	20104	2022
RR	0000000	M	A	5_a_20sm	13020	2010	2022
RR	0000000	M	I	5_a_20sm	13020	2010	2022
RR	0000000	F	B	5_a_20sm	10416	70732	2022
RR	0000000	F	P	5_a_20sm	7812	74022	2022
RR	0000000	F	N	5_a_20sm	7812	16449	2022
RR	0000000	F	A	5_a_20sm	10416	1644	2022
RR	0000000	F	I	5_a_20sm	10416	1644	2022
RR	0000000	M	B	mais_20sm	36456	28816	2022
RR	0000000	M	P	mais_20sm	27342	30157	2022
RR	0000000	M	N	mais_20sm	27342	6701	2022
RR	0000000	M	A	mais_20sm	36456	670	2022
RR	0000000	M	I	mais_20sm	36456	670	2022
RR	0000000	F	B	mais_20sm	29164.8	23577	2022
RR	0000000	F	P	mais_20sm	21873.6	24673	2022
RR	0000000	F	N	mais_20sm	21873.6	5483	2022
RR	0000000	F	A	mais_20sm	29164.8	548	2022
RR	0000000	F	I	mais_20sm	29164.8	548	2022
TO	0000000	M	B	ate_1sm	520.8	213246	2022
TO	0000000	M	P	ate_1sm	390.6	223164	2022
TO	0000000	M	N	ate_1sm	390.6	49592	2022
TO	0000000	M	A	ate_1sm	520.8	4959	2022
TO	0000000	M	I	ate_1sm	520.8	4959	2022
TO	0000000	F	B	ate_1sm	416.64	174474	2022
TO	0000000	F	P	ate_1sm	312.48	182589	2022
TO	0000000	F	N	ate_1sm	312.48	40575	2022
TO	0000000	F	A	ate_1sm	416.64	4057	2022
TO	0000000	F	I	ate_1sm	416.64	4057	2022
TO	0000000	M	B	1_a_2sm	1562.4	144085	2022
TO	0000000	M	P	1_a_2sm	1171.8	150787	2022
TO	0000000	M	N	1_a_2sm	1171.8	33508	2022
TO	0000000	M	A	1_a_2sm	1562.4	3350	2022
TO	0000000	M	I	1_a_2sm	1562.4	3350	2022
TO	0000000	F	B	1_a_2sm	1249.92	117887	2022
TO	0000000	F	P	1_a_2sm	937.44	123371	2022
TO	0000000	F	N	1_a_2sm	937.44	27415	2022
TO	0000000	F	A	1_a_2sm	1249.92	2741	2022
TO	0000000	F	I	1_a_2sm	1249.92	2741	2022
TO	0000000	M	B	2_a_5sm	3645.6	103741	2022
TO	0000000	M	P	2_a_5sm	2734.2	108566	2022
TO	0000000	M	N	2_a_5sm	2734.2	24125	2022
TO	0000000	M	A	2_a_5sm	3645.6	2412	2022
TO	0000000	M	I	2_a_5sm	3645.6	2412	2022
TO	0000000	F	B	2_a_5sm	2916.48	84879	2022
TO	0000000	F	P	2_a_5sm	2187.36	88827	2022
TO	0000000	F	N	2_a_5sm	2187.36	19739	2022
TO	0000000	F	A	2_a_5sm	2916.48	1973	2022
TO	0000000	F	I	2_a_5sm	2916.48	1973	2022
TO	0000000	M	B	5_a_20sm	13020	86451	2022
TO	0000000	M	P	5_a_20sm	9765	90472	2022
TO	0000000	M	N	5_a_20sm	9765	20104	2022
TO	0000000	M	A	5_a_20sm	13020	2010	2022
TO	0000000	M	I	5_a_20sm	13020	2010	2022
TO	0000000	F	B	5_a_20sm	10416	70732	2022
TO	0000000	F	P	5_a_20sm	7812	74022	2022
TO	0000000	F	N	5_a_20sm	7812	16449	2022
TO	0000000	F	A	5_a_20sm	10416	1644	2022
TO	0000000	F	I	5_a_20sm	10416	1644	2022
TO	0000000	M	B	mais_20sm	36456	28816	2022
TO	0000000	M	P	mais_20sm	27342	30157	2022
TO	0000000	M	N	mais_20sm	27342	6701	2022
TO	0000000	M	A	mais_20sm	36456	670	2022
TO	0000000	M	I	mais_20sm	36456	670	2022
TO	0000000	F	B	mais_20sm	29164.8	23577	2022
TO	0000000	F	P	mais_20sm	21873.6	24673	2022
TO	0000000	F	N	mais_20sm	21873.6	5483	2022
TO	0000000	F	A	mais_20sm	29164.8	548	2022
TO	0000000	F	I	mais_20sm	29164.8	548	2022
AL	0000000	M	B	ate_1sm	520.8	213246	2022
AL	0000000	M	P	ate_1sm	390.6	223164	2022
AL	0000000	M	N	ate_1sm	390.6	49592	2022
AL	0000000	M	A	ate_1sm	520.8	4959	2022
AL	0000000	M	I	ate_1sm	520.8	4959	2022
AL	0000000	F	B	ate_1sm	416.64	174474	2022
AL	0000000	F	P	ate_1sm	312.48	182589	2022
AL	0000000	F	N	ate_1sm	312.48	40575	2022
AL	0000000	F	A	ate_1sm	416.64	4057	2022
AL	0000000	F	I	ate_1sm	416.64	4057	2022
AL	0000000	M	B	1_a_2sm	1562.4	144085	2022
AL	0000000	M	P	1_a_2sm	1171.8	150787	2022
AL	0000000	M	N	1_a_2sm	1171.8	33508	2022
AL	0000000	M	A	1_a_2sm	1562.4	3350	2022
AL	0000000	M	I	1_a_2sm	1562.4	3350	2022
AL	0000000	F	B	1_a_2sm	1249.92	117887	2022
AL	0000000	F	P	1_a_2sm	937.44	123371	2022
AL	0000000	F	N	1_a_2sm	937.44	27415	2022
AL	0000000	F	A	1_a_2sm	1249.92	2741	2022
AL	0000000	F	I	1_a_2sm	1249.92	2741	2022
AL	0000000	M	B	2_a_5sm	3645.6	103741	2022
AL	0000000	M	P	2_a_5sm	2734.2	108566	2022
AL	0000000	M	N	2_a_5sm	2734.2	24125	2022
AL	0000000	M	A	2_a_5sm	3645.6	2412	2022
AL	0000000	M	I	2_a_5sm	3645.6	2412	2022
AL	0000000	F	B	2_a_5sm	2916.48	84879	2022
AL	0000000	F	P	2_a_5sm	2187.36	88827	2022
AL	0000000	F	N	2_a_5sm	2187.36	19739	2022
AL	0000000	F	A	2_a_5sm	2916.48	1973	2022
AL	0000000	F	I	2_a_5sm	2916.48	1973	2022
AL	0000000	M	B	5_a_20sm	13020	86451	2022
AL	0000000	M	P	5_a_20sm	9765	90472	2022
AL	0000000	M	N	5_a_20sm	9765	20104	2022
AL	0000000	M	A	5_a_20sm	13020	2010	2022
AL	0000000	M	I	5_a_20sm	13020	2010	2022
AL	0000000	F	B	5_a_20sm	10416	70732	2022
AL	0000000	F	P	5_a_20sm	7812	74022	2022
AL	0000000	F	N	5_a_20sm	7812	16449	2022
AL	0000000	F	A	5_a_20sm	10416	1644	2022
AL	0000000	F	I	5_a_20sm	10416	1644	2022
AL	0000000	M	B	mais_20sm	36456	28816	2022
AL	0000000	M	P	mais_20sm	27342	30157	2022
AL	0000000	M	N	mais_20sm	27342	6701	2022
AL	0000000	M	A	mais_20sm	36456	670	2022
AL	0000000	M	I	mais_20sm	36456	670	2022
AL	0000000	F	B	mais_20sm	29164.8	23577	2022
AL	0000000	F	P	mais_20sm	21873.6	24673	2022
AL	0000000	F	N	mais_20sm	21873.6	5483	2022
AL	0000000	F	A	mais_20sm	29164.8	548	2022
AL	0000000	F	I	mais_20sm	29164.8	548	2022
BA	0000000	M	B	ate_1sm	520.8	639740	2022
BA	0000000	M	P	ate_1sm	390.6	669496	2022
BA	0000000	M	N	ate_1sm	390.6	148776	2022
BA	0000000	M	A	ate_1sm	520.8	14877	2022
BA	0000000	M	I	ate_1sm	520.8	14877	2022
BA	0000000	F	B	ate_1sm	416.64	523423	2022
BA	0000000	F	P	ate_1sm	312.48	547769	2022
BA	0000000	F	N	ate_1sm	312.48	121726	2022
BA	0000000	F	A	ate_1sm	416.64	12172	2022
BA	0000000	F	I	ate_1sm	416.64	12172	2022
BA	0000000	M	B	1_a_2sm	1562.4	432257	2022
BA	0000000	M	P	1_a_2sm	1171.8	452362	2022
BA	0000000	M	N	1_a_2sm	1171.8	100524	2022
BA	0000000	M	A	1_a_2sm	1562.4	10052	2022
BA	0000000	M	I	1_a_2sm	1562.4	10052	2022
BA	0000000	F	B	1_a_2sm	1249.92	353664	2022
BA	0000000	F	P	1_a_2sm	937.44	370114	2022
BA	0000000	F	N	1_a_2sm	937.44	82247	2022
BA	0000000	F	A	1_a_2sm	1249.92	8224	2022
BA	0000000	F	I	1_a_2sm	1249.92	8224	2022
BA	0000000	M	B	2_a_5sm	3645.6	311224	2022
BA	0000000	M	P	2_a_5sm	2734.2	325700	2022
BA	0000000	M	N	2_a_5sm	2734.2	72377	2022
BA	0000000	M	A	2_a_5sm	3645.6	7237	2022
BA	0000000	M	I	2_a_5sm	3645.6	7237	2022
BA	0000000	F	B	2_a_5sm	2916.48	254638	2022
BA	0000000	F	P	2_a_5sm	2187.36	266482	2022
BA	0000000	F	N	2_a_5sm	2187.36	59218	2022
BA	0000000	F	A	2_a_5sm	2916.48	5921	2022
BA	0000000	F	I	2_a_5sm	2916.48	5921	2022
BA	0000000	M	B	5_a_20sm	13020	259354	2022
BA	0000000	M	P	5_a_20sm	9765	271417	2022
BA	0000000	M	N	5_a_20sm	9765	60314	2022
BA	0000000	M	A	5_a_20sm	13020	6031	2022
BA	0000000	M	I	5_a_20sm	13020	6031	2022
BA	0000000	F	B	5_a_20sm	10416	212198	2022
BA	0000000	F	P	5_a_20sm	7812	222068	2022
BA	0000000	F	N	5_a_20sm	7812	49348	2022
BA	0000000	F	A	5_a_20sm	10416	4934	2022
BA	0000000	F	I	5_a_20sm	10416	4934	2022
BA	0000000	M	B	mais_20sm	36456	86451	2022
BA	0000000	M	P	mais_20sm	27342	90472	2022
BA	0000000	M	N	mais_20sm	27342	20104	2022
BA	0000000	M	A	mais_20sm	36456	2010	2022
BA	0000000	M	I	mais_20sm	36456	2010	2022
BA	0000000	F	B	mais_20sm	29164.8	70732	2022
BA	0000000	F	P	mais_20sm	21873.6	74022	2022
BA	0000000	F	N	mais_20sm	21873.6	16449	2022
BA	0000000	F	A	mais_20sm	29164.8	1644	2022
BA	0000000	F	I	mais_20sm	29164.8	1644	2022
CE	0000000	M	B	ate_1sm	520.8	213246	2022
CE	0000000	M	P	ate_1sm	390.6	223164	2022
CE	0000000	M	N	ate_1sm	390.6	49592	2022
CE	0000000	M	A	ate_1sm	520.8	4959	2022
CE	0000000	M	I	ate_1sm	520.8	4959	2022
CE	0000000	F	B	ate_1sm	416.64	174474	2022
CE	0000000	F	P	ate_1sm	312.48	182589	2022
CE	0000000	F	N	ate_1sm	312.48	40575	2022
CE	0000000	F	A	ate_1sm	416.64	4057	2022
CE	0000000	F	I	ate_1sm	416.64	4057	2022
CE	0000000	M	B	1_a_2sm	1562.4	144085	2022
CE	0000000	M	P	1_a_2sm	1171.8	150787	2022
CE	0000000	M	N	1_a_2sm	1171.8	33508	2022
CE	0000000	M	A	1_a_2sm	1562.4	3350	2022
CE	0000000	M	I	1_a_2sm	1562.4	3350	2022
CE	0000000	F	B	1_a_2sm	1249.92	117887	2022
CE	0000000	F	P	1_a_2sm	937.44	123371	2022
CE	0000000	F	N	1_a_2sm	937.44	27415	2022
CE	0000000	F	A	1_a_2sm	1249.92	2741	2022
CE	0000000	F	I	1_a_2sm	1249.92	2741	2022
CE	0000000	M	B	2_a_5sm	3645.6	103741	2022
CE	0000000	M	P	2_a_5sm	2734.2	108566	2022
CE	0000000	M	N	2_a_5sm	2734.2	24125	2022
CE	0000000	M	A	2_a_5sm	3645.6	2412	2022
CE	0000000	M	I	2_a_5sm	3645.6	2412	2022
CE	0000000	F	B	2_a_5sm	2916.48	84879	2022
CE	0000000	F	P	2_a_5sm	2187.36	88827	2022
CE	0000000	F	N	2_a_5sm	2187.36	19739	2022
CE	0000000	F	A	2_a_5sm	2916.48	1973	2022
CE	0000000	F	I	2_a_5sm	2916.48	1973	2022
CE	0000000	M	B	5_a_20sm	13020	86451	2022
CE	0000000	M	P	5_a_20sm	9765	90472	2022
CE	0000000	M	N	5_a_20sm	9765	20104	2022
CE	0000000	M	A	5_a_20sm	13020	2010	2022
CE	0000000	M	I	5_a_20sm	13020	2010	2022
CE	0000000	F	B	5_a_20sm	10416	70732	2022
CE	0000000	F	P	5_a_20sm	7812	74022	2022
CE	0000000	F	N	5_a_20sm	7812	16449	2022
CE	0000000	F	A	5_a_20sm	10416	1644	2022
CE	0000000	F	I	5_a_20sm	10416	1644	2022
CE	0000000	M	B	mais_20sm	36456	28816	2022
CE	0000000	M	P	mais_20sm	27342	30157	2022
CE	0000000	M	N	mais_20sm	27342	6701	2022
CE	0000000	M	A	mais_20sm	36456	670	2022
CE	0000000	M	I	mais_20sm	36456	670	2022
CE	0000000	F	B	mais_20sm	29164.8	23577	2022
CE	0000000	F	P	mais_20sm	21873.6	24673	2022
CE	0000000	F	N	mais_20sm	21873.6	5483	2022
CE	0000000	F	A	mais_20sm	29164.8	548	2022
CE	0000000	F	I	mais_20sm	29164.8	548	2022
MA	0000000	M	B	ate_1sm	520.8	213246	2022
MA	0000000	M	P	ate_1sm	390.6	223164	2022
MA	0000000	M	N	ate_1sm	390.6	49592	2022
MA	0000000	M	A	ate_1sm	520.8	4959	2022
MA	0000000	M	I	ate_1sm	520.8	4959	2022
MA	0000000	F	B	ate_1sm	416.64	174474	2022
MA	0000000	F	P	ate_1sm	312.48	182589	2022
MA	0000000	F	N	ate_1sm	312.48	40575	2022
MA	0000000	F	A	ate_1sm	416.64	4057	2022
MA	0000000	F	I	ate_1sm	416.64	4057	2022
MA	0000000	M	B	1_a_2sm	1562.4	144085	2022
MA	0000000	M	P	1_a_2sm	1171.8	150787	2022
MA	0000000	M	N	1_a_2sm	1171.8	33508	2022
MA	0000000	M	A	1_a_2sm	1562.4	3350	2022
MA	0000000	M	I	1_a_2sm	1562.4	3350	2022
MA	0000000	F	B	1_a_2sm	1249.92	117887	2022
MA	0000000	F	P	1_a_2sm	937.44	123371	2022
MA	0000000	F	N	1_a_2sm	937.44	27415	2022
MA	0000000	F	A	1_a_2sm	1249.92	2741	2022
MA	0000000	F	I	1_a_2sm	1249.92	2741	2022
MA	0000000	M	B	2_a_5sm	3645.6	103741	2022
MA	0000000	M	P	2_a_5sm	2734.2	108566	2022
MA	0000000	M	N	2_a_5sm	2734.2	24125	2022
MA	0000000	M	A	2_a_5sm	3645.6	2412	2022
MA	0000000	M	I	2_a_5sm	3645.6	2412	2022
MA	0000000	F	B	2_a_5sm	2916.48	84879	2022
MA	0000000	F	P	2_a_5sm	2187.36	88827	2022
MA	0000000	F	N	2_a_5sm	2187.36	19739	2022
MA	0000000	F	A	2_a_5sm	2916.48	1973	2022
MA	0000000	F	I	2_a_5sm	2916.48	1973	2022
MA	0000000	M	B	5_a_20sm	13020	86451	2022
MA	0000000	M	P	5_a_20sm	9765	90472	2022
MA	0000000	M	N	5_a_20sm	9765	20104	2022
MA	0000000	M	A	5_a_20sm	13020	2010	2022
MA	0000000	M	I	5_a_20sm	13020	2010	2022
MA	0000000	F	B	5_a_20sm	10416	70732	2022
MA	0000000	F	P	5_a_20sm	7812	74022	2022
MA	0000000	F	N	5_a_20sm	7812	16449	2022
MA	0000000	F	A	5_a_20sm	10416	1644	2022
MA	0000000	F	I	5_a_20sm	10416	1644	2022
MA	0000000	M	B	mais_20sm	36456	28816	2022
MA	0000000	M	P	mais_20sm	27342	30157	2022
MA	0000000	M	N	mais_20sm	27342	6701	2022
MA	0000000	M	A	mais_20sm	36456	670	2022
MA	0000000	M	I	mais_20sm	36456	670	2022
MA	0000000	F	B	mais_20sm	29164.8	23577	2022
MA	0000000	F	P	mais_20sm	21873.6	24673	2022
MA	0000000	F	N	mais_20sm	21873.6	5483	2022
MA	0000000	F	A	mais_20sm	29164.8	548	2022
MA	0000000	F	I	mais_20sm	29164.8	548	2022
PB	0000000	M	B	ate_1sm	520.8	213246	2022
PB	0000000	M	P	ate_1sm	390.6	223164	2022
PB	0000000	M	N	ate_1sm	390.6	49592	2022
PB	0000000	M	A	ate_1sm	520.8	4959	2022
PB	0000000	M	I	ate_1sm	520.8	4959	2022
PB	0000000	F	B	ate_1sm	416.64	174474	2022
PB	0000000	F	P	ate_1sm	312.48	182589	2022
PB	0000000	F	N	ate_1sm	312.48	40575	2022
PB	0000000	F	A	ate_1sm	416.64	4057	2022
PB	0000000	F	I	ate_1sm	416.64	4057	2022
PB	0000000	M	B	1_a_2sm	1562.4	144085	2022
PB	0000000	M	P	1_a_2sm	1171.8	150787	2022
PB	0000000	M	N	1_a_2sm	1171.8	33508	2022
PB	0000000	M	A	1_a_2sm	1562.4	3350	2022
PB	0000000	M	I	1_a_2sm	1562.4	3350	2022
PB	0000000	F	B	1_a_2sm	1249.92	117887	2022
PB	0000000	F	P	1_a_2sm	937.44	123371	2022
PB	0000000	F	N	1_a_2sm	937.44	27415	2022
PB	0000000	F	A	1_a_2sm	1249.92	2741	2022
PB	0000000	F	I	1_a_2sm	1249.92	2741	2022
PB	0000000	M	B	2_a_5sm	3645.6	103741	2022
PB	0000000	M	P	2_a_5sm	2734.2	108566	2022
PB	0000000	M	N	2_a_5sm	2734.2	24125	2022
PB	0000000	M	A	2_a_5sm	3645.6	2412	2022
PB	0000000	M	I	2_a_5sm	3645.6	2412	2022
PB	0000000	F	B	2_a_5sm	2916.48	84879	2022
PB	0000000	F	P	2_a_5sm	2187.36	88827	2022
PB	0000000	F	N	2_a_5sm	2187.36	19739	2022
PB	0000000	F	A	2_a_5sm	2916.48	1973	2022
PB	0000000	F	I	2_a_5sm	2916.48	1973	2022
PB	0000000	M	B	5_a_20sm	13020	86451	2022
PB	0000000	M	P	5_a_20sm	9765	90472	2022
PB	0000000	M	N	5_a_20sm	9765	20104	2022
PB	0000000	M	A	5_a_20sm	13020	2010	2022
PB	0000000	M	I	5_a_20sm	13020	2010	2022
PB	0000000	F	B	5_a_20sm	10416	70732	2022
PB	0000000	F	P	5_a_20sm	7812	74022	2022
PB	0000000	F	N	5_a_20sm	7812	16449	2022
PB	0000000	F	A	5_a_20sm	10416	1644	2022
PB	0000000	F	I	5_a_20sm	10416	1644	2022
PB	0000000	M	B	mais_20sm	36456	28816	2022
PB	0000000	M	P	mais_20sm	27342	30157	2022
PB	0000000	M	N	mais_20sm	27342	6701	2022
PB	0000000	M	A	mais_20sm	36456	670	2022
PB	0000000	M	I	mais_20sm	36456	670	2022
PB	0000000	F	B	mais_20sm	29164.8	23577	2022
PB	0000000	F	P	mais_20sm	21873.6	24673	2022
PB	0000000	F	N	mais_20sm	21873.6	5483	2022
PB	0000000	F	A	mais_20sm	29164.8	548	2022
PB	0000000	F	I	mais_20sm	29164.8	548	2022
PE	0000000	M	B	ate_1sm	520.8	213246	2022
PE	0000000	M	P	ate_1sm	390.6	223164	2022
PE	0000000	M	N	ate_1sm	390.6	49592	2022
PE	0000000	M	A	ate_1sm	520.8	4959	2022
PE	0000000	M	I	ate_1sm	520.8	4959	2022
PE	0000000	F	B	ate_1sm	416.64	174474	2022
PE	0000000	F	P	ate_1sm	312.48	182589	2022
PE	0000000	F	N	ate_1sm	312.48	40575	2022
PE	0000000	F	A	ate_1sm	416.64	4057	2022
PE	0000000	F	I	ate_1sm	416.64	4057	2022
PE	0000000	M	B	1_a_2sm	1562.4	144085	2022
PE	0000000	M	P	1_a_2sm	1171.8	150787	2022
PE	0000000	M	N	1_a_2sm	1171.8	33508	2022
PE	0000000	M	A	1_a_2sm	1562.4	3350	2022
PE	0000000	M	I	1_a_2sm	1562.4	3350	2022
PE	0000000	F	B	1_a_2sm	1249.92	117887	2022
PE	0000000	F	P	1_a_2sm	937.44	123371	2022
PE	0000000	F	N	1_a_2sm	937.44	27415	2022
PE	0000000	F	A	1_a_2sm	1249.92	2741	2022
PE	0000000	F	I	1_a_2sm	1249.92	2741	2022
PE	0000000	M	B	2_a_5sm	3645.6	103741	2022
PE	0000000	M	P	2_a_5sm	2734.2	108566	2022
PE	0000000	M	N	2_a_5sm	2734.2	24125	2022
PE	0000000	M	A	2_a_5sm	3645.6	2412	2022
PE	0000000	M	I	2_a_5sm	3645.6	2412	2022
PE	0000000	F	B	2_a_5sm	2916.48	84879	2022
PE	0000000	F	P	2_a_5sm	2187.36	88827	2022
PE	0000000	F	N	2_a_5sm	2187.36	19739	2022
PE	0000000	F	A	2_a_5sm	2916.48	1973	2022
PE	0000000	F	I	2_a_5sm	2916.48	1973	2022
PE	0000000	M	B	5_a_20sm	13020	86451	2022
PE	0000000	M	P	5_a_20sm	9765	90472	2022
PE	0000000	M	N	5_a_20sm	9765	20104	2022
PE	0000000	M	A	5_a_20sm	13020	2010	2022
PE	0000000	M	I	5_a_20sm	13020	2010	2022
PE	0000000	F	B	5_a_20sm	10416	70732	2022
PE	0000000	F	P	5_a_20sm	7812	74022	2022
PE	0000000	F	N	5_a_20sm	7812	16449	2022
PE	0000000	F	A	5_a_20sm	10416	1644	2022
PE	0000000	F	I	5_a_20sm	10416	1644	2022
PE	0000000	M	B	mais_20sm	36456	28816	2022
PE	0000000	M	P	mais_20sm	27342	30157	2022
PE	0000000	M	N	mais_20sm	27342	6701	2022
PE	0000000	M	A	mais_20sm	36456	670	2022
PE	0000000	M	I	mais_20sm	36456	670	2022
PE	0000000	F	B	mais_20sm	29164.8	23577	2022
PE	0000000	F	P	mais_20sm	21873.6	24673	2022
PE	0000000	F	N	mais_20sm	21873.6	5483	2022
PE	0000000	F	A	mais_20sm	29164.8	548	2022
PE	0000000	F	I	mais_20sm	29164.8	548	2022
PI	0000000	M	B	ate_1sm	520.8	213246	2022
PI	0000000	M	P	ate_1sm	390.6	223164	2022
PI	0000000	M	N	ate_1sm	390.6	49592	2022
PI	0000000	M	A	ate_1sm	520.8	4959	2022
PI	0000000	M	I	ate_1sm	520.8	4959	2022
PI	0000000	F	B	ate_1sm	416.64	174474	2022
PI	0000000	F	P	ate_1sm	312.48	182589	2022
PI	0000000	F	N	ate_1sm	312.48	40575	2022
PI	0000000	F	A	ate_1sm	416.64	4057	2022
PI	0000000	F	I	ate_1sm	416.64	4057	2022
PI	0000000	M	B	1_a_2sm	1562.4	144085	2022
PI	0000000	M	P	1_a_2sm	1171.8	150787	2022
PI	0000000	M	N	1_a_2sm	1171.8	33508	2022
PI	0000000	M	A	1_a_2sm	1562.4	3350	2022
PI	0000000	M	I	1_a_2sm	1562.4	3350	2022
PI	0000000	F	B	1_a_2sm	1249.92	117887	2022
PI	0000000	F	P	1_a_2sm	937.44	123371	2022
PI	0000000	F	N	1_a_2sm	937.44	27415	2022
PI	0000000	F	A	1_a_2sm	1249.92	2741	2022
PI	0000000	F	I	1_a_2sm	1249.92	2741	2022
PI	0000000	M	B	2_a_5sm	3645.6	103741	2022
PI	0000000	M	P	2_a_5sm	2734.2	108566	2022
PI	0000000	M	N	2_a_5sm	2734.2	24125	2022
PI	0000000	M	A	2_a_5sm	3645.6	2412	2022
PI	0000000	M	I	2_a_5sm	3645.6	2412	2022
PI	0000000	F	B	2_a_5sm	2916.48	84879	2022
PI	0000000	F	P	2_a_5sm	2187.36	88827	2022
PI	0000000	F	N	2_a_5sm	2187.36	19739	2022
PI	0000000	F	A	2_a_5sm	2916.48	1973	2022
PI	0000000	F	I	2_a_5sm	2916.48	1973	2022
PI	0000000	M	B	5_a_20sm	13020	86451	2022
PI	0000000	M	P	5_a_20sm	9765	90472	2022
PI	0000000	M	N	5_a_20sm	9765	20104	2022
PI	0000000	M	A	5_a_20sm	13020	2010	2022
PI	0000000	M	I	5_a_20sm	13020	2010	2022
PI	0000000	F	B	5_a_20sm	10416	70732	2022
PI	0000000	F	P	5_a_20sm	7812	74022	2022
PI	0000000	F	N	5_a_20sm	7812	16449	2022
PI	0000000	F	A	5_a_20sm	10416	1644	2022
PI	0000000	F	I	5_a_20sm	10416	1644	2022
PI	0000000	M	B	mais_20sm	36456	28816	2022
PI	0000000	M	P	mais_20sm	27342	30157	2022
PI	0000000	M	N	mais_20sm	27342	6701	2022
PI	0000000	M	A	mais_20sm	36456	670	2022
PI	0000000	M	I	mais_20sm	36456	670	2022
PI	0000000	F	B	mais_20sm	29164.8	23577	2022
PI	0000000	F	P	mais_20sm	21873.6	24673	2022
PI	0000000	F	N	mais_20sm	21873.6	5483	2022
PI	0000000	F	A	mais_20sm	29164.8	548	2022
PI	0000000	F	I	mais_20sm	29164.8	548	2022
RN	0000000	M	B	ate_1sm	520.8	213246	2022
RN	0000000	M	P	ate_1sm	390.6	223164	2022
RN	0000000	M	N	ate_1sm	390.6	49592	2022
RN	0000000	M	A	ate_1sm	520.8	4959	2022
RN	0000000	M	I	ate_1sm	520.8	4959	2022
RN	0000000	F	B	ate_1sm	416.64	174474	2022
RN	0000000	F	P	ate_1sm	312.48	182589	2022
RN	0000000	F	N	ate_1sm	312.48	40575	2022
RN	0000000	F	A	ate_1sm	416.64	4057	2022
RN	0000000	F	I	ate_1sm	416.64	4057	2022
RN	0000000	M	B	1_a_2sm	1562.4	144085	2022
RN	0000000	M	P	1_a_2sm	1171.8	150787	2022
RN	0000000	M	N	1_a_2sm	1171.8	33508	2022
RN	0000000	M	A	1_a_2sm	1562.4	3350	2022
RN	0000000	M	I	1_a_2sm	1562.4	3350	2022
RN	0000000	F	B	1_a_2sm	1249.92	117887	2022
RN	0000000	F	P	1_a_2sm	937.44	123371	2022
RN	0000000	F	N	1_a_2sm	937.44	27415	2022
RN	0000000	F	A	1_a_2sm	1249.92	2741	2022
RN	0000000	F	I	1_a_2sm	1249.92	2741	2022
RN	0000000	M	B	2_a_5sm	3645.6	103741	2022
RN	0000000	M	P	2_a_5sm	2734.2	108566	2022
RN	0000000	M	N	2_a_5sm	2734.2	24125	2022
RN	0000000	M	A	2_a_5sm	3645.6	2412	2022
RN	0000000	M	I	2_a_5sm	3645.6	2412	2022
RN	0000000	F	B	2_a_5sm	2916.48	84879	2022
RN	0000000	F	P	2_a_5sm	2187.36	88827	2022
RN	0000000	F	N	2_a_5sm	2187.36	19739	2022
RN	0000000	F	A	2_a_5sm	2916.48	1973	2022
RN	0000000	F	I	2_a_5sm	2916.48	1973	2022
RN	0000000	M	B	5_a_20sm	13020	86451	2022
RN	0000000	M	P	5_a_20sm	9765	90472	2022
RN	0000000	M	N	5_a_20sm	9765	20104	2022
RN	0000000	M	A	5_a_20sm	13020	2010	2022
RN	0000000	M	I	5_a_20sm	13020	2010	2022
RN	0000000	F	B	5_a_20sm	10416	70732	2022
RN	0000000	F	P	5_a_20sm	7812	74022	2022
RN	0000000	F	N	5_a_20sm	7812	16449	2022
RN	0000000	F	A	5_a_20sm	10416	1644	2022
RN	0000000	F	I	5_a_20sm	10416	1644	2022
RN	0000000	M	B	mais_20sm	36456	28816	2022
RN	0000000	M	P	mais_20sm	27342	30157	2022
RN	0000000	M	N	mais_20sm	27342	6701	2022
RN	0000000	M	A	mais_20sm	36456	670	2022
RN	0000000	M	I	mais_20sm	36456	670	2022
RN	0000000	F	B	mais_20sm	29164.8	23577	2022
RN	0000000	F	P	mais_20sm	21873.6	24673	2022
RN	0000000	F	N	mais_20sm	21873.6	5483	2022
RN	0000000	F	A	mais_20sm	29164.8	548	2022
RN	0000000	F	I	mais_20sm	29164.8	548	2022
SE	0000000	M	B	ate_1sm	520.8	213246	2022
SE	0000000	M	P	ate_1sm	390.6	223164	2022
SE	0000000	M	N	ate_1sm	390.6	49592	2022
SE	0000000	M	A	ate_1sm	520.8	4959	2022
SE	0000000	M	I	ate_1sm	520.8	4959	2022
SE	0000000	F	B	ate_1sm	416.64	174474	2022
SE	0000000	F	P	ate_1sm	312.48	182589	2022
SE	0000000	F	N	ate_1sm	312.48	40575	2022
SE	0000000	F	A	ate_1sm	416.64	4057	2022
SE	0000000	F	I	ate_1sm	416.64	4057	2022
SE	0000000	M	B	1_a_2sm	1562.4	144085	2022
SE	0000000	M	P	1_a_2sm	1171.8	150787	2022
SE	0000000	M	N	1_a_2sm	1171.8	33508	2022
SE	0000000	M	A	1_a_2sm	1562.4	3350	2022
SE	0000000	M	I	1_a_2sm	1562.4	3350	2022
SE	0000000	F	B	1_a_2sm	1249.92	117887	2022
SE	0000000	F	P	1_a_2sm	937.44	123371	2022
SE	0000000	F	N	1_a_2sm	937.44	27415	2022
SE	0000000	F	A	1_a_2sm	1249.92	2741	2022
SE	0000000	F	I	1_a_2sm	1249.92	2741	2022
SE	0000000	M	B	2_a_5sm	3645.6	103741	2022
SE	0000000	M	P	2_a_5sm	2734.2	108566	2022
SE	0000000	M	N	2_a_5sm	2734.2	24125	2022
SE	0000000	M	A	2_a_5sm	3645.6	2412	2022
SE	0000000	M	I	2_a_5sm	3645.6	2412	2022
SE	0000000	F	B	2_a_5sm	2916.48	84879	2022
SE	0000000	F	P	2_a_5sm	2187.36	88827	2022
SE	0000000	F	N	2_a_5sm	2187.36	19739	2022
SE	0000000	F	A	2_a_5sm	2916.48	1973	2022
SE	0000000	F	I	2_a_5sm	2916.48	1973	2022
SE	0000000	M	B	5_a_20sm	13020	86451	2022
SE	0000000	M	P	5_a_20sm	9765	90472	2022
SE	0000000	M	N	5_a_20sm	9765	20104	2022
SE	0000000	M	A	5_a_20sm	13020	2010	2022
SE	0000000	M	I	5_a_20sm	13020	2010	2022
SE	0000000	F	B	5_a_20sm	10416	70732	2022
SE	0000000	F	P	5_a_20sm	7812	74022	2022
SE	0000000	F	N	5_a_20sm	7812	16449	2022
SE	0000000	F	A	5_a_20sm	10416	1644	2022
SE	0000000	F	I	5_a_20sm	10416	1644	2022
SE	0000000	M	B	mais_20sm	36456	28816	2022
SE	0000000	M	P	mais_20sm	27342	30157	2022
SE	0000000	M	N	mais_20sm	27342	6701	2022
SE	0000000	M	A	mais_20sm	36456	670	2022
SE	0000000	M	I	mais_20sm	36456	670	2022
SE	0000000	F	B	mais_20sm	29164.8	23577	2022
SE	0000000	F	P	mais_20sm	21873.6	24673	2022
SE	0000000	F	N	mais_20sm	21873.6	5483	2022
SE	0000000	F	A	mais_20sm	29164.8	548	2022
SE	0000000	F	I	mais_20sm	29164.8	548	2022
ES	0000000	M	B	ate_1sm	781.2	213246	2022
ES	0000000	M	P	ate_1sm	585.9	223164	2022
ES	0000000	M	N	ate_1sm	585.9	49592	2022
ES	0000000	M	A	ate_1sm	781.2	4959	2022
ES	0000000	M	I	ate_1sm	781.2	4959	2022
ES	0000000	F	B	ate_1sm	624.96	174474	2022
ES	0000000	F	P	ate_1sm	468.72	182589	2022
ES	0000000	F	N	ate_1sm	468.72	40575	2022
ES	0000000	F	A	ate_1sm	624.96	4057	2022
ES	0000000	F	I	ate_1sm	624.96	4057	2022
ES	0000000	M	B	1_a_2sm	2343.6	144085	2022
ES	0000000	M	P	1_a_2sm	1757.7	150787	2022
ES	0000000	M	N	1_a_2sm	1757.7	33508	2022
ES	0000000	M	A	1_a_2sm	2343.6	3350	2022
ES	0000000	M	I	1_a_2sm	2343.6	3350	2022
ES	0000000	F	B	1_a_2sm	1874.88	117887	2022
ES	0000000	F	P	1_a_2sm	1406.16	123371	2022
ES	0000000	F	N	1_a_2sm	1406.16	27415	2022
ES	0000000	F	A	1_a_2sm	1874.88	2741	2022
ES	0000000	F	I	1_a_2sm	1874.88	2741	2022
ES	0000000	M	B	2_a_5sm	5468.4	103741	2022
ES	0000000	M	P	2_a_5sm	4101.3	108566	2022
ES	0000000	M	N	2_a_5sm	4101.3	24125	2022
ES	0000000	M	A	2_a_5sm	5468.4	2412	2022
ES	0000000	M	I	2_a_5sm	5468.4	2412	2022
ES	0000000	F	B	2_a_5sm	4374.72	84879	2022
ES	0000000	F	P	2_a_5sm	3281.04	88827	2022
ES	0000000	F	N	2_a_5sm	3281.04	19739	2022
ES	0000000	F	A	2_a_5sm	4374.72	1973	2022
ES	0000000	F	I	2_a_5sm	4374.72	1973	2022
ES	0000000	M	B	5_a_20sm	19530	86451	2022
ES	0000000	M	P	5_a_20sm	14647.5	90472	2022
ES	0000000	M	N	5_a_20sm	14647.5	20104	2022
ES	0000000	M	A	5_a_20sm	19530	2010	2022
ES	0000000	M	I	5_a_20sm	19530	2010	2022
ES	0000000	F	B	5_a_20sm	15624	70732	2022
ES	0000000	F	P	5_a_20sm	11718	74022	2022
ES	0000000	F	N	5_a_20sm	11718	16449	2022
ES	0000000	F	A	5_a_20sm	15624	1644	2022
ES	0000000	F	I	5_a_20sm	15624	1644	2022
ES	0000000	M	B	mais_20sm	54684	28816	2022
ES	0000000	M	P	mais_20sm	41013	30157	2022
ES	0000000	M	N	mais_20sm	41013	6701	2022
ES	0000000	M	A	mais_20sm	54684	670	2022
ES	0000000	M	I	mais_20sm	54684	670	2022
ES	0000000	F	B	mais_20sm	43747.2	23577	2022
ES	0000000	F	P	mais_20sm	32810.4	24673	2022
ES	0000000	F	N	mais_20sm	32810.4	5483	2022
ES	0000000	F	A	mais_20sm	43747.2	548	2022
ES	0000000	F	I	mais_20sm	43747.2	548	2022
MG	0000000	M	B	ate_1sm	781.2	1066234	2022
MG	0000000	M	P	ate_1sm	585.9	1115826	2022
MG	0000000	M	N	ate_1sm	585.9	247961	2022
MG	0000000	M	A	ate_1sm	781.2	24796	2022
MG	0000000	M	I	ate_1sm	781.2	24796	2022
MG	0000000	F	B	ate_1sm	624.96	872373	2022
MG	0000000	F	P	ate_1sm	468.72	912949	2022
MG	0000000	F	N	ate_1sm	468.72	202877	2022
MG	0000000	F	A	ate_1sm	624.96	20287	2022
MG	0000000	F	I	ate_1sm	624.96	20287	2022
MG	0000000	M	B	1_a_2sm	2343.6	720428	2022
MG	0000000	M	P	1_a_2sm	1757.7	753937	2022
MG	0000000	M	N	1_a_2sm	1757.7	167541	2022
MG	0000000	M	A	1_a_2sm	2343.6	16754	2022
MG	0000000	M	I	1_a_2sm	2343.6	16754	2022
MG	0000000	F	B	1_a_2sm	1874.88	589441	2022
MG	0000000	F	P	1_a_2sm	1406.16	616857	2022
MG	0000000	F	N	1_a_2sm	1406.16	137079	2022
MG	0000000	F	A	1_a_2sm	1874.88	13707	2022
MG	0000000	F	I	1_a_2sm	1874.88	13707	2022
MG	0000000	M	B	2_a_5sm	5468.4	518708	2022
MG	0000000	M	P	2_a_5sm	4101.3	542834	2022
MG	0000000	M	N	2_a_5sm	4101.3	120629	2022
MG	0000000	M	A	2_a_5sm	5468.4	12062	2022
MG	0000000	M	I	2_a_5sm	5468.4	12062	2022
MG	0000000	F	B	2_a_5sm	4374.72	424397	2022
MG	0000000	F	P	2_a_5sm	3281.04	444137	2022
MG	0000000	F	N	2_a_5sm	3281.04	98697	2022
MG	0000000	F	A	2_a_5sm	4374.72	9869	2022
MG	0000000	F	I	2_a_5sm	4374.72	9869	2022
MG	0000000	M	B	5_a_20sm	19530	432257	2022
MG	0000000	M	P	5_a_20sm	14647.5	452362	2022
MG	0000000	M	N	5_a_20sm	14647.5	100524	2022
MG	0000000	M	A	5_a_20sm	19530	10052	2022
MG	0000000	M	I	5_a_20sm	19530	10052	2022
MG	0000000	F	B	5_a_20sm	15624	353664	2022
MG	0000000	F	P	5_a_20sm	11718	370114	2022
MG	0000000	F	N	5_a_20sm	11718	82247	2022
MG	0000000	F	A	5_a_20sm	15624	8224	2022
MG	0000000	F	I	5_a_20sm	15624	8224	2022
MG	0000000	M	B	mais_20sm	54684	144085	2022
MG	0000000	M	P	mais_20sm	41013	150787	2022
MG	0000000	M	N	mais_20sm	41013	33508	2022
MG	0000000	M	A	mais_20sm	54684	3350	2022
MG	0000000	M	I	mais_20sm	54684	3350	2022
MG	0000000	F	B	mais_20sm	43747.2	117887	2022
MG	0000000	F	P	mais_20sm	32810.4	123371	2022
MG	0000000	F	N	mais_20sm	32810.4	27415	2022
MG	0000000	F	A	mais_20sm	43747.2	2741	2022
MG	0000000	F	I	mais_20sm	43747.2	2741	2022
RJ	0000000	M	B	ate_1sm	781.2	1066234	2022
RJ	0000000	M	P	ate_1sm	585.9	1115826	2022
RJ	0000000	M	N	ate_1sm	585.9	247961	2022
RJ	0000000	M	A	ate_1sm	781.2	24796	2022
RJ	0000000	M	I	ate_1sm	781.2	24796	2022
RJ	0000000	F	B	ate_1sm	624.96	872373	2022
RJ	0000000	F	P	ate_1sm	468.72	912949	2022
RJ	0000000	F	N	ate_1sm	468.72	202877	2022
RJ	0000000	F	A	ate_1sm	624.96	20287	2022
RJ	0000000	F	I	ate_1sm	624.96	20287	2022
RJ	0000000	M	B	1_a_2sm	2343.6	720428	2022
RJ	0000000	M	P	1_a_2sm	1757.7	753937	2022
RJ	0000000	M	N	1_a_2sm	1757.7	167541	2022
RJ	0000000	M	A	1_a_2sm	2343.6	16754	2022
RJ	0000000	M	I	1_a_2sm	2343.6	16754	2022
RJ	0000000	F	B	1_a_2sm	1874.88	589441	2022
RJ	0000000	F	P	1_a_2sm	1406.16	616857	2022
RJ	0000000	F	N	1_a_2sm	1406.16	137079	2022
RJ	0000000	F	A	1_a_2sm	1874.88	13707	2022
RJ	0000000	F	I	1_a_2sm	1874.88	13707	2022
RJ	0000000	M	B	2_a_5sm	5468.4	518708	2022
RJ	0000000	M	P	2_a_5sm	4101.3	542834	2022
RJ	0000000	M	N	2_a_5sm	4101.3	120629	2022
RJ	0000000	M	A	2_a_5sm	5468.4	12062	2022
RJ	0000000	M	I	2_a_5sm	5468.4	12062	2022
RJ	0000000	F	B	2_a_5sm	4374.72	424397	2022
RJ	0000000	F	P	2_a_5sm	3281.04	444137	2022
RJ	0000000	F	N	2_a_5sm	3281.04	98697	2022
RJ	0000000	F	A	2_a_5sm	4374.72	9869	2022
RJ	0000000	F	I	2_a_5sm	4374.72	9869	2022
RJ	0000000	M	B	5_a_20sm	19530	432257	2022
RJ	0000000	M	P	5_a_20sm	14647.5	452362	2022
RJ	0000000	M	N	5_a_20sm	14647.5	100524	2022
RJ	0000000	M	A	5_a_20sm	19530	10052	2022
RJ	0000000	M	I	5_a_20sm	19530	10052	2022
RJ	0000000	F	B	5_a_20sm	15624	353664	2022
RJ	0000000	F	P	5_a_20sm	11718	370114	2022
RJ	0000000	F	N	5_a_20sm	11718	82247	2022
RJ	0000000	F	A	5_a_20sm	15624	8224	2022
RJ	0000000	F	I	5_a_20sm	15624	8224	2022
RJ	0000000	M	B	mais_20sm	54684	144085	2022
RJ	0000000	M	P	mais_20sm	41013	150787	2022
RJ	0000000	M	N	mais_20sm	41013	33508	2022
RJ	0000000	M	A	mais_20sm	54684	3350	2022
RJ	0000000	M	I	mais_20sm	54684	3350	2022
RJ	0000000	F	B	mais_20sm	43747.2	117887	2022
RJ	0000000	F	P	mais_20sm	32810.4	123371	2022
RJ	0000000	F	N	mais_20sm	32810.4	27415	2022
RJ	0000000	F	A	mais_20sm	43747.2	2741	2022
RJ	0000000	F	I	mais_20sm	43747.2	2741	2022
SP	0000000	M	B	ate_1sm	781.2	2345716	2022
SP	0000000	M	P	ate_1sm	585.9	2454819	2022
SP	0000000	M	N	ate_1sm	585.9	545515	2022
SP	0000000	M	A	ate_1sm	781.2	54551	2022
SP	0000000	M	I	ate_1sm	781.2	54551	2022
SP	0000000	F	B	ate_1sm	624.96	1919222	2022
SP	0000000	F	P	ate_1sm	468.72	2008488	2022
SP	0000000	F	N	ate_1sm	468.72	446330	2022
SP	0000000	F	A	ate_1sm	624.96	44633	2022
SP	0000000	F	I	ate_1sm	624.96	44633	2022
SP	0000000	M	B	1_a_2sm	2343.6	1584943	2022
SP	0000000	M	P	1_a_2sm	1757.7	1658661	2022
SP	0000000	M	N	1_a_2sm	1757.7	368591	2022
SP	0000000	M	A	1_a_2sm	2343.6	36859	2022
SP	0000000	M	I	1_a_2sm	2343.6	36859	2022
SP	0000000	F	B	1_a_2sm	1874.88	1296771	2022
SP	0000000	F	P	1_a_2sm	1406.16	1357086	2022
SP	0000000	F	N	1_a_2sm	1406.16	301574	2022
SP	0000000	F	A	1_a_2sm	1874.88	30157	2022
SP	0000000	F	I	1_a_2sm	1874.88	30157	2022
SP	0000000	M	B	2_a_5sm	5468.4	1141158	2022
SP	0000000	M	P	2_a_5sm	4101.3	1194236	2022
SP	0000000	M	N	2_a_5sm	4101.3	265385	2022
SP	0000000	M	A	2_a_5sm	5468.4	26538	2022
SP	0000000	M	I	2_a_5sm	5468.4	26538	2022
SP	0000000	F	B	2_a_5sm	4374.72	933675	2022
SP	0000000	F	P	2_a_5sm	3281.04	977102	2022
SP	0000000	F	N	2_a_5sm	3281.04	217133	2022
SP	0000000	F	A	2_a_5sm	4374.72	21713	2022
SP	0000000	F	I	2_a_5sm	4374.72	21713	2022
SP	0000000	M	B	5_a_20sm	19530	950965	2022
SP	0000000	M	P	5_a_20sm	14647.5	995196	2022
SP	0000000	M	N	5_a_20sm	14647.5	221154	2022
SP	0000000	M	A	5_a_20sm	19530	22115	2022
SP	0000000	M	I	5_a_20sm	19530	22115	2022
SP	0000000	F	B	5_a_20sm	15624	778063	2022
SP	0000000	F	P	5_a_20sm	11718	814252	2022
SP	0000000	F	N	5_a_20sm	11718	180944	2022
SP	0000000	F	A	5_a_20sm	15624	18094	2022
SP	0000000	F	I	5_a_20sm	15624	18094	2022
SP	0000000	M	B	mais_20sm	54684	316988	2022
SP	0000000	M	P	mais_20sm	41013	331731	2022
SP	0000000	M	N	mais_20sm	41013	73718	2022
SP	0000000	M	A	mais_20sm	54684	7371	2022
SP	0000000	M	I	mais_20sm	54684	7371	2022
SP	0000000	F	B	mais_20sm	43747.2	259354	2022
SP	0000000	F	P	mais_20sm	32810.4	271417	2022
SP	0000000	F	N	mais_20sm	32810.4	60314	2022
SP	0000000	F	A	mais_20sm	43747.2	6031	2022
SP	0000000	F	I	mais_20sm	43747.2	6031	2022
PR	0000000	M	B	ate_1sm	781.2	639740	2022
PR	0000000	M	P	ate_1sm	585.9	669496	2022
PR	0000000	M	N	ate_1sm	585.9	148776	2022
PR	0000000	M	A	ate_1sm	781.2	14877	2022
PR	0000000	M	I	ate_1sm	781.2	14877	2022
PR	0000000	F	B	ate_1sm	624.96	523423	2022
PR	0000000	F	P	ate_1sm	468.72	547769	2022
PR	0000000	F	N	ate_1sm	468.72	121726	2022
PR	0000000	F	A	ate_1sm	624.96	12172	2022
PR	0000000	F	I	ate_1sm	624.96	12172	2022
PR	0000000	M	B	1_a_2sm	2343.6	432257	2022
PR	0000000	M	P	1_a_2sm	1757.7	452362	2022
PR	0000000	M	N	1_a_2sm	1757.7	100524	2022
PR	0000000	M	A	1_a_2sm	2343.6	10052	2022
PR	0000000	M	I	1_a_2sm	2343.6	10052	2022
PR	0000000	F	B	1_a_2sm	1874.88	353664	2022
PR	0000000	F	P	1_a_2sm	1406.16	370114	2022
PR	0000000	F	N	1_a_2sm	1406.16	82247	2022
PR	0000000	F	A	1_a_2sm	1874.88	8224	2022
PR	0000000	F	I	1_a_2sm	1874.88	8224	2022
PR	0000000	M	B	2_a_5sm	5468.4	311224	2022
PR	0000000	M	P	2_a_5sm	4101.3	325700	2022
PR	0000000	M	N	2_a_5sm	4101.3	72377	2022
PR	0000000	M	A	2_a_5sm	5468.4	7237	2022
PR	0000000	M	I	2_a_5sm	5468.4	7237	2022
PR	0000000	F	B	2_a_5sm	4374.72	254638	2022
PR	0000000	F	P	2_a_5sm	3281.04	266482	2022
PR	0000000	F	N	2_a_5sm	3281.04	59218	2022
PR	0000000	F	A	2_a_5sm	4374.72	5921	2022
PR	0000000	F	I	2_a_5sm	4374.72	5921	2022
PR	0000000	M	B	5_a_20sm	19530	259354	2022
PR	0000000	M	P	5_a_20sm	14647.5	271417	2022
PR	0000000	M	N	5_a_20sm	14647.5	60314	2022
PR	0000000	M	A	5_a_20sm	19530	6031	2022
PR	0000000	M	I	5_a_20sm	19530	6031	2022
PR	0000000	F	B	5_a_20sm	15624	212198	2022
PR	0000000	F	P	5_a_20sm	11718	222068	2022
PR	0000000	F	N	5_a_20sm	11718	49348	2022
PR	0000000	F	A	5_a_20sm	15624	4934	2022
PR	0000000	F	I	5_a_20sm	15624	4934	2022
PR	0000000	M	B	mais_20sm	54684	86451	2022
PR	0000000	M	P	mais_20sm	41013	90472	2022
PR	0000000	M	N	mais_20sm	41013	20104	2022
PR	0000000	M	A	mais_20sm	54684	2010	2022
PR	0000000	M	I	mais_20sm	54684	2010	2022
PR	0000000	F	B	mais_20sm	43747.2	70732	2022
PR	0000000	F	P	mais_20sm	32810.4	74022	2022
PR	0000000	F	N	mais_20sm	32810.4	16449	2022
PR	0000000	F	A	mais_20sm	43747.2	1644	2022
PR	0000000	F	I	mais_20sm	43747.2	1644	2022
RS	0000000	M	B	ate_1sm	781.2	639740	2022
RS	0000000	M	P	ate_1sm	585.9	669496	2022
RS	0000000	M	N	ate_1sm	585.9	148776	2022
RS	0000000	M	A	ate_1sm	781.2	14877	2022
RS	0000000	M	I	ate_1sm	781.2	14877	2022
RS	0000000	F	B	ate_1sm	624.96	523423	2022
RS	0000000	F	P	ate_1sm	468.72	547769	2022
RS	0000000	F	N	ate_1sm	468.72	121726	2022
RS	0000000	F	A	ate_1sm	624.96	12172	2022
RS	0000000	F	I	ate_1sm	624.96	12172	2022
RS	0000000	M	B	1_a_2sm	2343.6	432257	2022
RS	0000000	M	P	1_a_2sm	1757.7	452362	2022
RS	0000000	M	N	1_a_2sm	1757.7	100524	2022
RS	0000000	M	A	1_a_2sm	2343.6	10052	2022
RS	0000000	M	I	1_a_2sm	2343.6	10052	2022
RS	0000000	F	B	1_a_2sm	1874.88	353664	2022
RS	0000000	F	P	1_a_2sm	1406.16	370114	2022
RS	0000000	F	N	1_a_2sm	1406.16	82247	2022
RS	0000000	F	A	1_a_2sm	1874.88	8224	2022
RS	0000000	F	I	1_a_2sm	1874.88	8224	2022
RS	0000000	M	B	2_a_5sm	5468.4	311224	2022
RS	0000000	M	P	2_a_5sm	4101.3	325700	2022
RS	0000000	M	N	2_a_5sm	4101.3	72377	2022
RS	0000000	M	A	2_a_5sm	5468.4	7237	2022
RS	0000000	M	I	2_a_5sm	5468.4	7237	2022
RS	0000000	F	B	2_a_5sm	4374.72	254638	2022
RS	0000000	F	P	2_a_5sm	3281.04	266482	2022
RS	0000000	F	N	2_a_5sm	3281.04	59218	2022
RS	0000000	F	A	2_a_5sm	4374.72	5921	2022
RS	0000000	F	I	2_a_5sm	4374.72	5921	2022
RS	0000000	M	B	5_a_20sm	19530	259354	2022
RS	0000000	M	P	5_a_20sm	14647.5	271417	2022
RS	0000000	M	N	5_a_20sm	14647.5	60314	2022
RS	0000000	M	A	5_a_20sm	19530	6031	2022
RS	0000000	M	I	5_a_20sm	19530	6031	2022
RS	0000000	F	B	5_a_20sm	15624	212198	2022
RS	0000000	F	P	5_a_20sm	11718	222068	2022
RS	0000000	F	N	5_a_20sm	11718	49348	2022
RS	0000000	F	A	5_a_20sm	15624	4934	2022
RS	0000000	F	I	5_a_20sm	15624	4934	2022
RS	0000000	M	B	mais_20sm	54684	86451	2022
RS	0000000	M	P	mais_20sm	41013	90472	2022
RS	0000000	M	N	mais_20sm	41013	20104	2022
RS	0000000	M	A	mais_20sm	54684	2010	2022
RS	0000000	M	I	mais_20sm	54684	2010	2022
RS	0000000	F	B	mais_20sm	43747.2	70732	2022
RS	0000000	F	P	mais_20sm	32810.4	74022	2022
RS	0000000	F	N	mais_20sm	32810.4	16449	2022
RS	0000000	F	A	mais_20sm	43747.2	1644	2022
RS	0000000	F	I	mais_20sm	43747.2	1644	2022
SC	0000000	M	B	ate_1sm	781.2	213246	2022
SC	0000000	M	P	ate_1sm	585.9	223164	2022
SC	0000000	M	N	ate_1sm	585.9	49592	2022
SC	0000000	M	A	ate_1sm	781.2	4959	2022
SC	0000000	M	I	ate_1sm	781.2	4959	2022
SC	0000000	F	B	ate_1sm	624.96	174474	2022
SC	0000000	F	P	ate_1sm	468.72	182589	2022
SC	0000000	F	N	ate_1sm	468.72	40575	2022
SC	0000000	F	A	ate_1sm	624.96	4057	2022
SC	0000000	F	I	ate_1sm	624.96	4057	2022
SC	0000000	M	B	1_a_2sm	2343.6	144085	2022
SC	0000000	M	P	1_a_2sm	1757.7	150787	2022
SC	0000000	M	N	1_a_2sm	1757.7	33508	2022
SC	0000000	M	A	1_a_2sm	2343.6	3350	2022
SC	0000000	M	I	1_a_2sm	2343.6	3350	2022
SC	0000000	F	B	1_a_2sm	1874.88	117887	2022
SC	0000000	F	P	1_a_2sm	1406.16	123371	2022
SC	0000000	F	N	1_a_2sm	1406.16	27415	2022
SC	0000000	F	A	1_a_2sm	1874.88	2741	2022
SC	0000000	F	I	1_a_2sm	1874.88	2741	2022
SC	0000000	M	B	2_a_5sm	5468.4	103741	2022
SC	0000000	M	P	2_a_5sm	4101.3	108566	2022
SC	0000000	M	N	2_a_5sm	4101.3	24125	2022
SC	0000000	M	A	2_a_5sm	5468.4	2412	2022
SC	0000000	M	I	2_a_5sm	5468.4	2412	2022
SC	0000000	F	B	2_a_5sm	4374.72	84879	2022
SC	0000000	F	P	2_a_5sm	3281.04	88827	2022
SC	0000000	F	N	2_a_5sm	3281.04	19739	2022
SC	0000000	F	A	2_a_5sm	4374.72	1973	2022
SC	0000000	F	I	2_a_5sm	4374.72	1973	2022
SC	0000000	M	B	5_a_20sm	19530	86451	2022
SC	0000000	M	P	5_a_20sm	14647.5	90472	2022
SC	0000000	M	N	5_a_20sm	14647.5	20104	2022
SC	0000000	M	A	5_a_20sm	19530	2010	2022
SC	0000000	M	I	5_a_20sm	19530	2010	2022
SC	0000000	F	B	5_a_20sm	15624	70732	2022
SC	0000000	F	P	5_a_20sm	11718	74022	2022
SC	0000000	F	N	5_a_20sm	11718	16449	2022
SC	0000000	F	A	5_a_20sm	15624	1644	2022
SC	0000000	F	I	5_a_20sm	15624	1644	2022
SC	0000000	M	B	mais_20sm	54684	28816	2022
SC	0000000	M	P	mais_20sm	41013	30157	2022
SC	0000000	M	N	mais_20sm	41013	6701	2022
SC	0000000	M	A	mais_20sm	54684	670	2022
SC	0000000	M	I	mais_20sm	54684	670	2022
SC	0000000	F	B	mais_20sm	43747.2	23577	2022
SC	0000000	F	P	mais_20sm	32810.4	24673	2022
SC	0000000	F	N	mais_20sm	32810.4	5483	2022
SC	0000000	F	A	mais_20sm	43747.2	548	2022
SC	0000000	F	I	mais_20sm	43747.2	548	2022
DF	0000000	M	B	ate_1sm	651	213246	2022
DF	0000000	M	P	ate_1sm	488.25	223164	2022
DF	0000000	M	N	ate_1sm	488.25	49592	2022
DF	0000000	M	A	ate_1sm	651	4959	2022
DF	0000000	M	I	ate_1sm	651	4959	2022
DF	0000000	F	B	ate_1sm	520.8	174474	2022
DF	0000000	F	P	ate_1sm	390.6	182589	2022
DF	0000000	F	N	ate_1sm	390.6	40575	2022
DF	0000000	F	A	ate_1sm	520.8	4057	2022
DF	0000000	F	I	ate_1sm	520.8	4057	2022
DF	0000000	M	B	1_a_2sm	1953	144085	2022
DF	0000000	M	P	1_a_2sm	1464.75	150787	2022
DF	0000000	M	N	1_a_2sm	1464.75	33508	2022
DF	0000000	M	A	1_a_2sm	1953	3350	2022
DF	0000000	M	I	1_a_2sm	1953	3350	2022
DF	0000000	F	B	1_a_2sm	1562.4	117887	2022
DF	0000000	F	P	1_a_2sm	1171.8	123371	2022
DF	0000000	F	N	1_a_2sm	1171.8	27415	2022
DF	0000000	F	A	1_a_2sm	1562.4	2741	2022
DF	0000000	F	I	1_a_2sm	1562.4	2741	2022
DF	0000000	M	B	2_a_5sm	4557	103741	2022
DF	0000000	M	P	2_a_5sm	3417.75	108566	2022
DF	0000000	M	N	2_a_5sm	3417.75	24125	2022
DF	0000000	M	A	2_a_5sm	4557	2412	2022
DF	0000000	M	I	2_a_5sm	4557	2412	2022
DF	0000000	F	B	2_a_5sm	3645.6	84879	2022
DF	0000000	F	P	2_a_5sm	2734.2	88827	2022
DF	0000000	F	N	2_a_5sm	2734.2	19739	2022
DF	0000000	F	A	2_a_5sm	3645.6	1973	2022
DF	0000000	F	I	2_a_5sm	3645.6	1973	2022
DF	0000000	M	B	5_a_20sm	16275	86451	2022
DF	0000000	M	P	5_a_20sm	12206.25	90472	2022
DF	0000000	M	N	5_a_20sm	12206.25	20104	2022
DF	0000000	M	A	5_a_20sm	16275	2010	2022
DF	0000000	M	I	5_a_20sm	16275	2010	2022
DF	0000000	F	B	5_a_20sm	13020	70732	2022
DF	0000000	F	P	5_a_20sm	9765	74022	2022
DF	0000000	F	N	5_a_20sm	9765	16449	2022
DF	0000000	F	A	5_a_20sm	13020	1644	2022
DF	0000000	F	I	5_a_20sm	13020	1644	2022
DF	0000000	M	B	mais_20sm	45570	28816	2022
DF	0000000	M	P	mais_20sm	34177.5	30157	2022
DF	0000000	M	N	mais_20sm	34177.5	6701	2022
DF	0000000	M	A	mais_20sm	45570	670	2022
DF	0000000	M	I	mais_20sm	45570	670	2022
DF	0000000	F	B	mais_20sm	36456	23577	2022
DF	0000000	F	P	mais_20sm	27342	24673	2022
DF	0000000	F	N	mais_20sm	27342	5483	2022
DF	0000000	F	A	mais_20sm	36456	548	2022
DF	0000000	F	I	mais_20sm	36456	548	2022
GO	0000000	M	B	ate_1sm	651	213246	2022
GO	0000000	M	P	ate_1sm	488.25	223164	2022
GO	0000000	M	N	ate_1sm	488.25	49592	2022
GO	0000000	M	A	ate_1sm	651	4959	2022
GO	0000000	M	I	ate_1sm	651	4959	2022
GO	0000000	F	B	ate_1sm	520.8	174474	2022
GO	0000000	F	P	ate_1sm	390.6	182589	2022
GO	0000000	F	N	ate_1sm	390.6	40575	2022
GO	0000000	F	A	ate_1sm	520.8	4057	2022
GO	0000000	F	I	ate_1sm	520.8	4057	2022
GO	0000000	M	B	1_a_2sm	1953	144085	2022
GO	0000000	M	P	1_a_2sm	1464.75	150787	2022
GO	0000000	M	N	1_a_2sm	1464.75	33508	2022
GO	0000000	M	A	1_a_2sm	1953	3350	2022
GO	0000000	M	I	1_a_2sm	1953	3350	2022
GO	0000000	F	B	1_a_2sm	1562.4	117887	2022
GO	0000000	F	P	1_a_2sm	1171.8	123371	2022
GO	0000000	F	N	1_a_2sm	1171.8	27415	2022
GO	0000000	F	A	1_a_2sm	1562.4	2741	2022
GO	0000000	F	I	1_a_2sm	1562.4	2741	2022
GO	0000000	M	B	2_a_5sm	4557	103741	2022
GO	0000000	M	P	2_a_5sm	3417.75	108566	2022
GO	0000000	M	N	2_a_5sm	3417.75	24125	2022
GO	0000000	M	A	2_a_5sm	4557	2412	2022
GO	0000000	M	I	2_a_5sm	4557	2412	2022
GO	0000000	F	B	2_a_5sm	3645.6	84879	2022
GO	0000000	F	P	2_a_5sm	2734.2	88827	2022
GO	0000000	F	N	2_a_5sm	2734.2	19739	2022
GO	0000000	F	A	2_a_5sm	3645.6	1973	2022
GO	0000000	F	I	2_a_5sm	3645.6	1973	2022
GO	0000000	M	B	5_a_20sm	16275	86451	2022
GO	0000000	M	P	5_a_20sm	12206.25	90472	2022
GO	0000000	M	N	5_a_20sm	12206.25	20104	2022
GO	0000000	M	A	5_a_20sm	16275	2010	2022
GO	0000000	M	I	5_a_20sm	16275	2010	2022
GO	0000000	F	B	5_a_20sm	13020	70732	2022
GO	0000000	F	P	5_a_20sm	9765	74022	2022
GO	0000000	F	N	5_a_20sm	9765	16449	2022
GO	0000000	F	A	5_a_20sm	13020	1644	2022
GO	0000000	F	I	5_a_20sm	13020	1644	2022
GO	0000000	M	B	mais_20sm	45570	28816	2022
GO	0000000	M	P	mais_20sm	34177.5	30157	2022
GO	0000000	M	N	mais_20sm	34177.5	6701	2022
GO	0000000	M	A	mais_20sm	45570	670	2022
GO	0000000	M	I	mais_20sm	45570	670	2022
GO	0000000	F	B	mais_20sm	36456	23577	2022
GO	0000000	F	P	mais_20sm	27342	24673	2022
GO	0000000	F	N	mais_20sm	27342	5483	2022
GO	0000000	F	A	mais_20sm	36456	548	2022
GO	0000000	F	I	mais_20sm	36456	548	2022
MS	0000000	M	B	ate_1sm	651	213246	2022
MS	0000000	M	P	ate_1sm	488.25	223164	2022
MS	0000000	M	N	ate_1sm	488.25	49592	2022
MS	0000000	M	A	ate_1sm	651	4959	2022
MS	0000000	M	I	ate_1sm	651	4959	2022
MS	0000000	F	B	ate_1sm	520.8	174474	2022
MS	0000000	F	P	ate_1sm	390.6	182589	2022
MS	0000000	F	N	ate_1sm	390.6	40575	2022
MS	0000000	F	A	ate_1sm	520.8	4057	2022
MS	0000000	F	I	ate_1sm	520.8	4057	2022
MS	0000000	M	B	1_a_2sm	1953	144085	2022
MS	0000000	M	P	1_a_2sm	1464.75	150787	2022
MS	0000000	M	N	1_a_2sm	1464.75	33508	2022
MS	0000000	M	A	1_a_2sm	1953	3350	2022
MS	0000000	M	I	1_a_2sm	1953	3350	2022
MS	0000000	F	B	1_a_2sm	1562.4	117887	2022
MS	0000000	F	P	1_a_2sm	1171.8	123371	2022
MS	0000000	F	N	1_a_2sm	1171.8	27415	2022
MS	0000000	F	A	1_a_2sm	1562.4	2741	2022
MS	0000000	F	I	1_a_2sm	1562.4	2741	2022
MS	0000000	M	B	2_a_5sm	4557	103741	2022
MS	0000000	M	P	2_a_5sm	3417.75	108566	2022
MS	0000000	M	N	2_a_5sm	3417.75	24125	2022
MS	0000000	M	A	2_a_5sm	4557	2412	2022
MS	0000000	M	I	2_a_5sm	4557	2412	2022
MS	0000000	F	B	2_a_5sm	3645.6	84879	2022
MS	0000000	F	P	2_a_5sm	2734.2	88827	2022
MS	0000000	F	N	2_a_5sm	2734.2	19739	2022
MS	0000000	F	A	2_a_5sm	3645.6	1973	2022
MS	0000000	F	I	2_a_5sm	3645.6	1973	2022
MS	0000000	M	B	5_a_20sm	16275	86451	2022
MS	0000000	M	P	5_a_20sm	12206.25	90472	2022
MS	0000000	M	N	5_a_20sm	12206.25	20104	2022
MS	0000000	M	A	5_a_20sm	16275	2010	2022
MS	0000000	M	I	5_a_20sm	16275	2010	2022
MS	0000000	F	B	5_a_20sm	13020	70732	2022
MS	0000000	F	P	5_a_20sm	9765	74022	2022
MS	0000000	F	N	5_a_20sm	9765	16449	2022
MS	0000000	F	A	5_a_20sm	13020	1644	2022
MS	0000000	F	I	5_a_20sm	13020	1644	2022
MS	0000000	M	B	mais_20sm	45570	28816	2022
MS	0000000	M	P	mais_20sm	34177.5	30157	2022
MS	0000000	M	N	mais_20sm	34177.5	6701	2022
MS	0000000	M	A	mais_20sm	45570	670	2022
MS	0000000	M	I	mais_20sm	45570	670	2022
MS	0000000	F	B	mais_20sm	36456	23577	2022
MS	0000000	F	P	mais_20sm	27342	24673	2022
MS	0000000	F	N	mais_20sm	27342	5483	2022
MS	0000000	F	A	mais_20sm	36456	548	2022
MS	0000000	F	I	mais_20sm	36456	548	2022
MT	0000000	M	B	ate_1sm	651	213246	2022
MT	0000000	M	P	ate_1sm	488.25	223164	2022
MT	0000000	M	N	ate_1sm	488.25	49592	2022
MT	0000000	M	A	ate_1sm	651	4959	2022
MT	0000000	M	I	ate_1sm	651	4959	2022
MT	0000000	F	B	ate_1sm	520.8	174474	2022
MT	0000000	F	P	ate_1sm	390.6	182589	2022
MT	0000000	F	N	ate_1sm	390.6	40575	2022
MT	0000000	F	A	ate_1sm	520.8	4057	2022
MT	0000000	F	I	ate_1sm	520.8	4057	2022
MT	0000000	M	B	1_a_2sm	1953	144085	2022
MT	0000000	M	P	1_a_2sm	1464.75	150787	2022
MT	0000000	M	N	1_a_2sm	1464.75	33508	2022
MT	0000000	M	A	1_a_2sm	1953	3350	2022
MT	0000000	M	I	1_a_2sm	1953	3350	2022
MT	0000000	F	B	1_a_2sm	1562.4	117887	2022
MT	0000000	F	P	1_a_2sm	1171.8	123371	2022
MT	0000000	F	N	1_a_2sm	1171.8	27415	2022
MT	0000000	F	A	1_a_2sm	1562.4	2741	2022
MT	0000000	F	I	1_a_2sm	1562.4	2741	2022
MT	0000000	M	B	2_a_5sm	4557	103741	2022
MT	0000000	M	P	2_a_5sm	3417.75	108566	2022
MT	0000000	M	N	2_a_5sm	3417.75	24125	2022
MT	0000000	M	A	2_a_5sm	4557	2412	2022
MT	0000000	M	I	2_a_5sm	4557	2412	2022
MT	0000000	F	B	2_a_5sm	3645.6	84879	2022
MT	0000000	F	P	2_a_5sm	2734.2	88827	2022
MT	0000000	F	N	2_a_5sm	2734.2	19739	2022
MT	0000000	F	A	2_a_5sm	3645.6	1973	2022
MT	0000000	F	I	2_a_5sm	3645.6	1973	2022
MT	0000000	M	B	5_a_20sm	16275	86451	2022
MT	0000000	M	P	5_a_20sm	12206.25	90472	2022
MT	0000000	M	N	5_a_20sm	12206.25	20104	2022
MT	0000000	M	A	5_a_20sm	16275	2010	2022
MT	0000000	M	I	5_a_20sm	16275	2010	2022
MT	0000000	F	B	5_a_20sm	13020	70732	2022
MT	0000000	F	P	5_a_20sm	9765	74022	2022
MT	0000000	F	N	5_a_20sm	9765	16449	2022
MT	0000000	F	A	5_a_20sm	13020	1644	2022
MT	0000000	F	I	5_a_20sm	13020	1644	2022
MT	0000000	M	B	mais_20sm	45570	28816	2022
MT	0000000	M	P	mais_20sm	34177.5	30157	2022
MT	0000000	M	N	mais_20sm	34177.5	6701	2022
MT	0000000	M	A	mais_20sm	45570	670	2022
MT	0000000	M	I	mais_20sm	45570	670	2022
MT	0000000	F	B	mais_20sm	36456	23577	2022
MT	0000000	F	P	mais_20sm	27342	24673	2022
MT	0000000	F	N	mais_20sm	27342	5483	2022
MT	0000000	F	A	mais_20sm	36456	548	2022
MT	0000000	F	I	mais_20sm	36456	548	2022
\.


--
-- Name: dim_demografica_id_seq; Type: SEQUENCE SET; Schema: gold; Owner: etl_user
--

SELECT pg_catalog.setval('gold.dim_demografica_id_seq', 1, false);


--
-- Name: fato_crescimento_desenvolvimento_id_seq; Type: SEQUENCE SET; Schema: gold; Owner: etl_user
--

SELECT pg_catalog.setval('gold.fato_crescimento_desenvolvimento_id_seq', 1, false);


--
-- Name: fato_indicadores_demograficos_id_seq; Type: SEQUENCE SET; Schema: gold; Owner: etl_user
--

SELECT pg_catalog.setval('gold.fato_indicadores_demograficos_id_seq', 1, false);


--
-- Name: fato_qualidade_vida_id_seq; Type: SEQUENCE SET; Schema: gold; Owner: etl_user
--

SELECT pg_catalog.setval('gold.fato_qualidade_vida_id_seq', 1, false);


--
-- Name: ab_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_permission_id_seq', 5, true);


--
-- Name: ab_permission_view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_permission_view_id_seq', 99, true);


--
-- Name: ab_permission_view_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_permission_view_role_id_seq', 231, true);


--
-- Name: ab_register_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_register_user_id_seq', 1, false);


--
-- Name: ab_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_role_id_seq', 5, true);


--
-- Name: ab_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_user_id_seq', 1, true);


--
-- Name: ab_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_user_role_id_seq', 1, true);


--
-- Name: ab_view_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.ab_view_menu_id_seq', 57, true);


--
-- Name: callback_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.callback_request_id_seq', 1, false);


--
-- Name: connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.connection_id_seq', 57, true);


--
-- Name: dag_pickle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.dag_pickle_id_seq', 1, false);


--
-- Name: dag_run_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.dag_run_id_seq', 1, false);


--
-- Name: dataset_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.dataset_event_id_seq', 1, false);


--
-- Name: dataset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.dataset_id_seq', 1, false);


--
-- Name: import_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.import_error_id_seq', 1, false);


--
-- Name: job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.job_id_seq', 2, true);


--
-- Name: log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.log_id_seq', 8, true);


--
-- Name: log_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.log_template_id_seq', 4, true);


--
-- Name: session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.session_id_seq', 2, true);


--
-- Name: slot_pool_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.slot_pool_id_seq', 1, true);


--
-- Name: task_fail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.task_fail_id_seq', 1, false);


--
-- Name: task_reschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.task_reschedule_id_seq', 1, false);


--
-- Name: trigger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.trigger_id_seq', 1, false);


--
-- Name: variable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etl_user
--

SELECT pg_catalog.setval('public.variable_id_seq', 1, false);


--
-- Name: fato_demografico_id_seq; Type: SEQUENCE SET; Schema: silver; Owner: etl_user
--

SELECT pg_catalog.setval('silver.fato_demografico_id_seq', 1, false);


--
-- Name: dim_demografica dim_demografica_pkey; Type: CONSTRAINT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.dim_demografica
    ADD CONSTRAINT dim_demografica_pkey PRIMARY KEY (id);


--
-- Name: fato_crescimento_desenvolvimento fato_crescimento_desenvolvimento_pkey; Type: CONSTRAINT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.fato_crescimento_desenvolvimento
    ADD CONSTRAINT fato_crescimento_desenvolvimento_pkey PRIMARY KEY (id);


--
-- Name: fato_indicadores_demograficos fato_indicadores_demograficos_pkey; Type: CONSTRAINT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.fato_indicadores_demograficos
    ADD CONSTRAINT fato_indicadores_demograficos_pkey PRIMARY KEY (id);


--
-- Name: fato_qualidade_vida fato_qualidade_vida_pkey; Type: CONSTRAINT; Schema: gold; Owner: etl_user
--

ALTER TABLE ONLY gold.fato_qualidade_vida
    ADD CONSTRAINT fato_qualidade_vida_pkey PRIMARY KEY (id);


--
-- Name: ab_permission ab_permission_name_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission
    ADD CONSTRAINT ab_permission_name_uq UNIQUE (name);


--
-- Name: ab_permission ab_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission
    ADD CONSTRAINT ab_permission_pkey PRIMARY KEY (id);


--
-- Name: ab_permission_view ab_permission_view_permission_id_view_menu_id_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_permission_id_view_menu_id_uq UNIQUE (permission_id, view_menu_id);


--
-- Name: ab_permission_view ab_permission_view_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_pkey PRIMARY KEY (id);


--
-- Name: ab_permission_view_role ab_permission_view_role_permission_view_id_role_id_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_permission_view_id_role_id_uq UNIQUE (permission_view_id, role_id);


--
-- Name: ab_permission_view_role ab_permission_view_role_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_pkey PRIMARY KEY (id);


--
-- Name: ab_register_user ab_register_user_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_register_user
    ADD CONSTRAINT ab_register_user_pkey PRIMARY KEY (id);


--
-- Name: ab_register_user ab_register_user_username_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_register_user
    ADD CONSTRAINT ab_register_user_username_uq UNIQUE (username);


--
-- Name: ab_role ab_role_name_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_role
    ADD CONSTRAINT ab_role_name_uq UNIQUE (name);


--
-- Name: ab_role ab_role_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_role
    ADD CONSTRAINT ab_role_pkey PRIMARY KEY (id);


--
-- Name: ab_user ab_user_email_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_email_uq UNIQUE (email);


--
-- Name: ab_user ab_user_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_pkey PRIMARY KEY (id);


--
-- Name: ab_user_role ab_user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_pkey PRIMARY KEY (id);


--
-- Name: ab_user_role ab_user_role_user_id_role_id_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_user_id_role_id_uq UNIQUE (user_id, role_id);


--
-- Name: ab_user ab_user_username_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_username_uq UNIQUE (username);


--
-- Name: ab_view_menu ab_view_menu_name_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_view_menu
    ADD CONSTRAINT ab_view_menu_name_uq UNIQUE (name);


--
-- Name: ab_view_menu ab_view_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_view_menu
    ADD CONSTRAINT ab_view_menu_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: callback_request callback_request_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.callback_request
    ADD CONSTRAINT callback_request_pkey PRIMARY KEY (id);


--
-- Name: connection connection_conn_id_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.connection
    ADD CONSTRAINT connection_conn_id_uq UNIQUE (conn_id);


--
-- Name: connection connection_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.connection
    ADD CONSTRAINT connection_pkey PRIMARY KEY (id);


--
-- Name: dag_code dag_code_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_code
    ADD CONSTRAINT dag_code_pkey PRIMARY KEY (fileloc_hash);


--
-- Name: dag_owner_attributes dag_owner_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_owner_attributes
    ADD CONSTRAINT dag_owner_attributes_pkey PRIMARY KEY (dag_id, owner);


--
-- Name: dag_pickle dag_pickle_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_pickle
    ADD CONSTRAINT dag_pickle_pkey PRIMARY KEY (id);


--
-- Name: dag dag_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag
    ADD CONSTRAINT dag_pkey PRIMARY KEY (dag_id);


--
-- Name: dag_run dag_run_dag_id_execution_date_key; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT dag_run_dag_id_execution_date_key UNIQUE (dag_id, execution_date);


--
-- Name: dag_run dag_run_dag_id_run_id_key; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT dag_run_dag_id_run_id_key UNIQUE (dag_id, run_id);


--
-- Name: dag_run_note dag_run_note_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run_note
    ADD CONSTRAINT dag_run_note_pkey PRIMARY KEY (dag_run_id);


--
-- Name: dag_run dag_run_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT dag_run_pkey PRIMARY KEY (id);


--
-- Name: dag_tag dag_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_tag
    ADD CONSTRAINT dag_tag_pkey PRIMARY KEY (name, dag_id);


--
-- Name: dag_warning dag_warning_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_warning
    ADD CONSTRAINT dag_warning_pkey PRIMARY KEY (dag_id, warning_type);


--
-- Name: dagrun_dataset_event dagrun_dataset_event_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dagrun_dataset_event
    ADD CONSTRAINT dagrun_dataset_event_pkey PRIMARY KEY (dag_run_id, event_id);


--
-- Name: dataset_event dataset_event_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dataset_event
    ADD CONSTRAINT dataset_event_pkey PRIMARY KEY (id);


--
-- Name: dataset dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT dataset_pkey PRIMARY KEY (id);


--
-- Name: dataset_dag_run_queue datasetdagrunqueue_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dataset_dag_run_queue
    ADD CONSTRAINT datasetdagrunqueue_pkey PRIMARY KEY (dataset_id, target_dag_id);


--
-- Name: dag_schedule_dataset_reference dsdr_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_schedule_dataset_reference
    ADD CONSTRAINT dsdr_pkey PRIMARY KEY (dataset_id, dag_id);


--
-- Name: import_error import_error_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.import_error
    ADD CONSTRAINT import_error_pkey PRIMARY KEY (id);


--
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);


--
-- Name: log_template log_template_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.log_template
    ADD CONSTRAINT log_template_pkey PRIMARY KEY (id);


--
-- Name: rendered_task_instance_fields rendered_task_instance_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.rendered_task_instance_fields
    ADD CONSTRAINT rendered_task_instance_fields_pkey PRIMARY KEY (dag_id, task_id, run_id, map_index);


--
-- Name: serialized_dag serialized_dag_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.serialized_dag
    ADD CONSTRAINT serialized_dag_pkey PRIMARY KEY (dag_id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: session session_session_id_key; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_session_id_key UNIQUE (session_id);


--
-- Name: sla_miss sla_miss_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.sla_miss
    ADD CONSTRAINT sla_miss_pkey PRIMARY KEY (task_id, dag_id, execution_date);


--
-- Name: slot_pool slot_pool_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.slot_pool
    ADD CONSTRAINT slot_pool_pkey PRIMARY KEY (id);


--
-- Name: slot_pool slot_pool_pool_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.slot_pool
    ADD CONSTRAINT slot_pool_pool_uq UNIQUE (pool);


--
-- Name: task_fail task_fail_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_fail
    ADD CONSTRAINT task_fail_pkey PRIMARY KEY (id);


--
-- Name: task_instance_note task_instance_note_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_instance_note
    ADD CONSTRAINT task_instance_note_pkey PRIMARY KEY (task_id, dag_id, run_id, map_index);


--
-- Name: task_instance task_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_instance
    ADD CONSTRAINT task_instance_pkey PRIMARY KEY (dag_id, task_id, run_id, map_index);


--
-- Name: task_map task_map_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_map
    ADD CONSTRAINT task_map_pkey PRIMARY KEY (dag_id, task_id, run_id, map_index);


--
-- Name: task_reschedule task_reschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_reschedule
    ADD CONSTRAINT task_reschedule_pkey PRIMARY KEY (id);


--
-- Name: task_outlet_dataset_reference todr_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_outlet_dataset_reference
    ADD CONSTRAINT todr_pkey PRIMARY KEY (dataset_id, dag_id, task_id);


--
-- Name: trigger trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.trigger
    ADD CONSTRAINT trigger_pkey PRIMARY KEY (id);


--
-- Name: variable variable_key_uq; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.variable
    ADD CONSTRAINT variable_key_uq UNIQUE (key);


--
-- Name: variable variable_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.variable
    ADD CONSTRAINT variable_pkey PRIMARY KEY (id);


--
-- Name: xcom xcom_pkey; Type: CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.xcom
    ADD CONSTRAINT xcom_pkey PRIMARY KEY (dag_run_id, task_id, map_index, key);


--
-- Name: fato_demografico fato_demografico_pkey; Type: CONSTRAINT; Schema: silver; Owner: etl_user
--

ALTER TABLE ONLY silver.fato_demografico
    ADD CONSTRAINT fato_demografico_pkey PRIMARY KEY (id);


--
-- Name: dag_id_state; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX dag_id_state ON public.dag_run USING btree (dag_id, state);


--
-- Name: idx_ab_register_user_username; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE UNIQUE INDEX idx_ab_register_user_username ON public.ab_register_user USING btree (lower((username)::text));


--
-- Name: idx_ab_user_username; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE UNIQUE INDEX idx_ab_user_username ON public.ab_user USING btree (lower((username)::text));


--
-- Name: idx_dag_run_dag_id; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_dag_run_dag_id ON public.dag_run USING btree (dag_id);


--
-- Name: idx_dag_run_queued_dags; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_dag_run_queued_dags ON public.dag_run USING btree (state, dag_id) WHERE ((state)::text = 'queued'::text);


--
-- Name: idx_dag_run_running_dags; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_dag_run_running_dags ON public.dag_run USING btree (state, dag_id) WHERE ((state)::text = 'running'::text);


--
-- Name: idx_dagrun_dataset_events_dag_run_id; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_dagrun_dataset_events_dag_run_id ON public.dagrun_dataset_event USING btree (dag_run_id);


--
-- Name: idx_dagrun_dataset_events_event_id; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_dagrun_dataset_events_event_id ON public.dagrun_dataset_event USING btree (event_id);


--
-- Name: idx_dataset_id_timestamp; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_dataset_id_timestamp ON public.dataset_event USING btree (dataset_id, "timestamp");


--
-- Name: idx_fileloc_hash; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_fileloc_hash ON public.serialized_dag USING btree (fileloc_hash);


--
-- Name: idx_job_dag_id; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_job_dag_id ON public.job USING btree (dag_id);


--
-- Name: idx_job_state_heartbeat; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_job_state_heartbeat ON public.job USING btree (state, latest_heartbeat);


--
-- Name: idx_last_scheduling_decision; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_last_scheduling_decision ON public.dag_run USING btree (last_scheduling_decision);


--
-- Name: idx_log_dag; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_log_dag ON public.log USING btree (dag_id);


--
-- Name: idx_log_dttm; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_log_dttm ON public.log USING btree (dttm);


--
-- Name: idx_log_event; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_log_event ON public.log USING btree (event);


--
-- Name: idx_next_dagrun_create_after; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_next_dagrun_create_after ON public.dag USING btree (next_dagrun_create_after);


--
-- Name: idx_root_dag_id; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_root_dag_id ON public.dag USING btree (root_dag_id);


--
-- Name: idx_task_fail_task_instance; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_task_fail_task_instance ON public.task_fail USING btree (dag_id, task_id, run_id, map_index);


--
-- Name: idx_task_reschedule_dag_run; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_task_reschedule_dag_run ON public.task_reschedule USING btree (dag_id, run_id);


--
-- Name: idx_task_reschedule_dag_task_run; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_task_reschedule_dag_task_run ON public.task_reschedule USING btree (dag_id, task_id, run_id, map_index);


--
-- Name: idx_uri_unique; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE UNIQUE INDEX idx_uri_unique ON public.dataset USING btree (uri);


--
-- Name: idx_xcom_key; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_xcom_key ON public.xcom USING btree (key);


--
-- Name: idx_xcom_task_instance; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX idx_xcom_task_instance ON public.xcom USING btree (dag_id, task_id, run_id, map_index);


--
-- Name: job_type_heart; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX job_type_heart ON public.job USING btree (job_type, latest_heartbeat);


--
-- Name: sm_dag; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX sm_dag ON public.sla_miss USING btree (dag_id);


--
-- Name: ti_dag_run; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX ti_dag_run ON public.task_instance USING btree (dag_id, run_id);


--
-- Name: ti_dag_state; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX ti_dag_state ON public.task_instance USING btree (dag_id, state);


--
-- Name: ti_job_id; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX ti_job_id ON public.task_instance USING btree (job_id);


--
-- Name: ti_pool; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX ti_pool ON public.task_instance USING btree (pool, state, priority_weight);


--
-- Name: ti_state; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX ti_state ON public.task_instance USING btree (state);


--
-- Name: ti_state_lkp; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX ti_state_lkp ON public.task_instance USING btree (dag_id, task_id, run_id, state);


--
-- Name: ti_trigger_id; Type: INDEX; Schema: public; Owner: etl_user
--

CREATE INDEX ti_trigger_id ON public.task_instance USING btree (trigger_id);


--
-- Name: ab_permission_view ab_permission_view_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.ab_permission(id);


--
-- Name: ab_permission_view_role ab_permission_view_role_permission_view_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_permission_view_id_fkey FOREIGN KEY (permission_view_id) REFERENCES public.ab_permission_view(id);


--
-- Name: ab_permission_view_role ab_permission_view_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.ab_role(id);


--
-- Name: ab_permission_view ab_permission_view_view_menu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_view_menu_id_fkey FOREIGN KEY (view_menu_id) REFERENCES public.ab_view_menu(id);


--
-- Name: ab_user ab_user_changed_by_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_changed_by_fk_fkey FOREIGN KEY (changed_by_fk) REFERENCES public.ab_user(id);


--
-- Name: ab_user ab_user_created_by_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_created_by_fk_fkey FOREIGN KEY (created_by_fk) REFERENCES public.ab_user(id);


--
-- Name: ab_user_role ab_user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.ab_role(id);


--
-- Name: ab_user_role ab_user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.ab_user(id);


--
-- Name: dag_owner_attributes dag.dag_id; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_owner_attributes
    ADD CONSTRAINT "dag.dag_id" FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dag_run_note dag_run_note_dr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run_note
    ADD CONSTRAINT dag_run_note_dr_fkey FOREIGN KEY (dag_run_id) REFERENCES public.dag_run(id) ON DELETE CASCADE;


--
-- Name: dag_run_note dag_run_note_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run_note
    ADD CONSTRAINT dag_run_note_user_fkey FOREIGN KEY (user_id) REFERENCES public.ab_user(id);


--
-- Name: dag_tag dag_tag_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_tag
    ADD CONSTRAINT dag_tag_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dagrun_dataset_event dagrun_dataset_event_dag_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dagrun_dataset_event
    ADD CONSTRAINT dagrun_dataset_event_dag_run_id_fkey FOREIGN KEY (dag_run_id) REFERENCES public.dag_run(id) ON DELETE CASCADE;


--
-- Name: dagrun_dataset_event dagrun_dataset_event_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dagrun_dataset_event
    ADD CONSTRAINT dagrun_dataset_event_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.dataset_event(id) ON DELETE CASCADE;


--
-- Name: dag_warning dcw_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_warning
    ADD CONSTRAINT dcw_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dataset_dag_run_queue ddrq_dag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dataset_dag_run_queue
    ADD CONSTRAINT ddrq_dag_fkey FOREIGN KEY (target_dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dataset_dag_run_queue ddrq_dataset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dataset_dag_run_queue
    ADD CONSTRAINT ddrq_dataset_fkey FOREIGN KEY (dataset_id) REFERENCES public.dataset(id) ON DELETE CASCADE;


--
-- Name: dag_schedule_dataset_reference dsdr_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_schedule_dataset_reference
    ADD CONSTRAINT dsdr_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dag_schedule_dataset_reference dsdr_dataset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_schedule_dataset_reference
    ADD CONSTRAINT dsdr_dataset_fkey FOREIGN KEY (dataset_id) REFERENCES public.dataset(id) ON DELETE CASCADE;


--
-- Name: rendered_task_instance_fields rtif_ti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.rendered_task_instance_fields
    ADD CONSTRAINT rtif_ti_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- Name: task_fail task_fail_ti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_fail
    ADD CONSTRAINT task_fail_ti_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- Name: task_instance task_instance_dag_run_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_instance
    ADD CONSTRAINT task_instance_dag_run_fkey FOREIGN KEY (dag_id, run_id) REFERENCES public.dag_run(dag_id, run_id) ON DELETE CASCADE;


--
-- Name: dag_run task_instance_log_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT task_instance_log_template_id_fkey FOREIGN KEY (log_template_id) REFERENCES public.log_template(id);


--
-- Name: task_instance_note task_instance_note_ti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_instance_note
    ADD CONSTRAINT task_instance_note_ti_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- Name: task_instance_note task_instance_note_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_instance_note
    ADD CONSTRAINT task_instance_note_user_fkey FOREIGN KEY (user_id) REFERENCES public.ab_user(id);


--
-- Name: task_instance task_instance_trigger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_instance
    ADD CONSTRAINT task_instance_trigger_id_fkey FOREIGN KEY (trigger_id) REFERENCES public.trigger(id) ON DELETE CASCADE;


--
-- Name: task_map task_map_task_instance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_map
    ADD CONSTRAINT task_map_task_instance_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: task_reschedule task_reschedule_dr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_reschedule
    ADD CONSTRAINT task_reschedule_dr_fkey FOREIGN KEY (dag_id, run_id) REFERENCES public.dag_run(dag_id, run_id) ON DELETE CASCADE;


--
-- Name: task_reschedule task_reschedule_ti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_reschedule
    ADD CONSTRAINT task_reschedule_ti_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- Name: task_outlet_dataset_reference todr_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_outlet_dataset_reference
    ADD CONSTRAINT todr_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: task_outlet_dataset_reference todr_dataset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.task_outlet_dataset_reference
    ADD CONSTRAINT todr_dataset_fkey FOREIGN KEY (dataset_id) REFERENCES public.dataset(id) ON DELETE CASCADE;


--
-- Name: xcom xcom_task_instance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etl_user
--

ALTER TABLE ONLY public.xcom
    ADD CONSTRAINT xcom_task_instance_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict mheLbjiQoTFiFuc3HJpsWVbZ0chk67aTlsCKdBDzLJJNNkWRjgBpFdfoCuKScXW

