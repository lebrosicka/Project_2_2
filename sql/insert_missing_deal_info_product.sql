-- Скрипт добавления недостающих строк из таблиц temp

-- deal_info
BEGIN;
INSERT INTO rd.deal_info (
    deal_rk, deal_num, deal_name, deal_sum, client_rk,
    account_rk, agreement_rk, deal_start_date, department_rk,
    product_rk, deal_type_cd, effective_from_date, effective_to_date
)
SELECT
    t.deal_rk, t.deal_num, t.deal_name, t.deal_sum, t.client_rk,
    t.account_rk, t.agreement_rk, t.deal_start_date, t.department_rk,
    t.product_rk, t.deal_type_cd, t.effective_from_date, t.effective_to_date
FROM rd.deal_info_temp t
WHERE NOT EXISTS (
    SELECT 1 FROM rd.deal_info d WHERE d.deal_rk = t.deal_rk
);

-- Проверка

SELECT COUNT(*) FROM rd.deal_info;

--COMMIT;
--ROLLBACK;

-- product_info

BEGIN;
INSERT INTO rd.product (
    product_rk, product_name, effective_from_date, effective_to_date
)
SELECT
    t.product_rk, t.product_name, t.effective_from_date, t.effective_to_date
FROM rd.product_info_temp t
WHERE NOT EXISTS (
    SELECT 1 FROM rd.product p WHERE p.product_rk = t.product_rk
);

-- Проверка

SELECT COUNT(*) FROM rd.product;

--COMMIT;
--ROLLBACK; 


