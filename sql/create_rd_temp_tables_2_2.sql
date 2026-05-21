-- Скрипт создания пустых временных таблиц клонов для выгрузки CSV

DROP TABLE IF EXISTS rd.deal_info_temp;
CREATE TABLE rd.deal_info_temp (
    deal_rk bigint NOT NULL,
    deal_num text,
    deal_name text,
    deal_sum numeric,
    client_rk bigint NOT NULL,
    account_rk bigint NOT NULL,
    agreement_rk bigint NOT NULL,
    deal_start_date date,
    department_rk bigint,
    product_rk bigint,
    deal_type_cd text,
    effective_from_date date NOT NULL,
    effective_to_date date NOT NULL
);

DROP TABLE IF EXISTS rd.product_info_temp;
CREATE TABLE rd.product_info_temp (
    product_rk bigint NOT NULL,
    product_name text,
    effective_from_date date NOT NULL,
    effective_to_date date NOT NULL
);
