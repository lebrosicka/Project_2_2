-- Скрипт проверка выборки добавляемых строк 
-- Выборка deal для наглядности строк которые будем добавлять из temp в основную таблицу
SELECT 
    t.deal_rk,
    t.deal_num,
    t.deal_name,
    t.deal_sum,
    t.client_rk,
    t.account_rk,
    t.agreement_rk,
    t.deal_start_date,
    t.department_rk,
    t.product_rk,
    t.deal_type_cd,
    t.effective_from_date,
    t.effective_to_date
FROM rd.deal_info_temp t
WHERE NOT EXISTS (
    SELECT 1 
    FROM rd.deal_info d 
    WHERE d.deal_rk = t.deal_rk
);
-- Просто колличество строк
SELECT COUNT(*)
FROM rd.deal_info_temp t
WHERE NOT EXISTS (SELECT 1 FROM rd.deal_info d WHERE d.deal_rk = t.deal_rk);

-- Проверка какие строки уже есть в deal_info из deal_info_temp, их 2

SELECT t.*
FROM rd.deal_info_temp t
WHERE EXISTS (
    SELECT 1 FROM rd.deal_info d WHERE d.deal_rk = t.deal_rk
);

-- Выборка product для наглядности строк которые будем добавлять из temp в основную таблицу
SELECT 
    t.product_rk,
    t.product_name,
    t.effective_from_date,
    t.effective_to_date
FROM rd.product_info_temp t
WHERE NOT EXISTS (
    SELECT 1 
    FROM rd.product p 
    WHERE p.product_rk = t.product_rk
);
-- Аналогично просто колличество строк

SELECT COUNT(*)
FROM rd.product_info_temp t
WHERE NOT EXISTS (SELECT 1 FROM rd.product p WHERE p.product_rk = t.product_rk);

-- Аналогично проверка какие строки уже есть в product из product_info_temp, 3517 
SELECT t.*
FROM rd.product_info_temp t
WHERE EXISTS (
    SELECT 1 
    FROM rd.product p 
    WHERE p.product_rk = t.product_rk
);

