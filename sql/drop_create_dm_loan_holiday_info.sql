-- Скрипт удаления витрины для полного пересоздания в соответствии с прототипом
DROP TABLE IF EXISTS dm.loan_holiday_info;

-- Скрипт создания таблицы строго по колонкам из прототипа
CREATE TABLE dm.loan_holiday_info (
    deal_rk                       BIGINT,
    effective_from_date           DATE,
    effective_to_date             DATE,
    agreement_rk                  BIGINT,
    client_rk                     BIGINT,
    department_rk                 BIGINT,
    product_rk                    BIGINT,
    product_name                  TEXT,
    deal_type_cd                  TEXT,
    deal_start_date               DATE,
    deal_name                     TEXT,
    deal_number                   TEXT,
    deal_sum                      NUMERIC,
    loan_holiday_type_cd          TEXT,
    loan_holiday_start_date       DATE,
    loan_holiday_finish_date      DATE,
    loan_holiday_fact_finish_date DATE,
    loan_holiday_finish_flg       TEXT,
    loan_holiday_last_possible_date DATE
);