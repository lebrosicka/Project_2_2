-- Скрипт проверки таблиц на дубликаты, имеющихся в БД и + выгруженных во временные таблицы
-- Проверка таблицы deal_info на дубли по всем столбцам, т.к составных ключей нету, в результате - 0
SELECT
	deal_rk,
	deal_num,
	deal_name,
	deal_sum,
	client_rk,
	account_rk,
	agreement_rk,
	deal_start_date,
	department_rk,
	product_rk,
	deal_type_cd,
	effective_from_date,
	effective_to_date,
	COUNT(*) AS duplicates_deal
FROM deal_info di
GROUP BY 
	deal_rk,
	deal_num,
	deal_name,
	deal_sum,
	client_rk,
	account_rk,
	agreement_rk,
	deal_start_date,
	department_rk,
	product_rk,
	deal_type_cd,
	effective_from_date,
	effective_to_date
HAVING COUNT(*) > 1;

-- Проверка таблицы loan_holiday на дубли по всем столбцам, т.к составных ключей нету, в результате - 0

SELECT 
	deal_rk,
	loan_holiday_type_cd,
	loan_holiday_start_date,
	loan_holiday_finish_date,
	loan_holiday_fact_finish_date,
	loan_holiday_finish_flg, 
	loan_holiday_last_possible_date,
	effective_from_date, 
	effective_to_date,
COUNT(*) AS duplicates_loan_holiday
FROM loan_holiday lh 
GROUP BY
	deal_rk,
	loan_holiday_type_cd,
	loan_holiday_start_date,
	loan_holiday_finish_date,
	loan_holiday_fact_finish_date,
	loan_holiday_finish_flg, 
	loan_holiday_last_possible_date,
	effective_from_date, 
	effective_to_date
HAVING COUNT(*) > 1;

-- Проверка таблицы product на дубли по всем столбцам, т.к составных ключей нету, в результате - 2 строки

SELECT
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date,
	COUNT(*) AS duplicates_product
FROM product p 
GROUP BY 
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date
HAVING COUNT(*) > 1;

-- Удаление строк дубликатов из таблицы product с помощью отдельного CTE и использования ctid, также открыл транзацкцию на всякий случай, чтобы сначала проверить результат а потом применить изменения
BEGIN;
WITH ranked AS (
SELECT 
	ctid,
	ROW_NUMBER() OVER (
	PARTITION BY product_rk, product_name, effective_from_date, effective_to_date
	ORDER BY ctid
	) AS rn
FROM product
)
DELETE FROM product
WHERE ctid IN (SELECT ctid FROM ranked WHERE rn > 1);

-- Проверка перед commit, чтобы убедиться, 2 строчки были успешно удалены из product

SELECT * FROM product;

--COMMIT; 
--ROLLBACK;

-- Снова проверю таблицу на дубли, чтобы окончательно убедиться, что всё успешно
SELECT
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date,
	COUNT(*) AS duplicates_product
FROM product p 
GROUP BY 
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date
HAVING COUNT(*) > 1;

-- Проверка дубликатов во временных таблицах --------------------------------------------------------------------------
-- deal_info_temp

SELECT
	deal_rk,
	deal_num,
	deal_name,
	deal_sum,
	client_rk,
	account_rk,
	agreement_rk,
	deal_start_date,
	department_rk,
	product_rk,
	deal_type_cd,
	effective_from_date,
	effective_to_date,
	COUNT(*) AS duplicates_deal
FROM deal_info_temp dit
GROUP BY 
	deal_rk,
	deal_num,
	deal_name,
	deal_sum,
	client_rk,
	account_rk,
	agreement_rk,
	deal_start_date,
	department_rk,
	product_rk,
	deal_type_cd,
	effective_from_date,
	effective_to_date
HAVING COUNT(*) > 1;

----- product_info_temp, нашлись дубликаты
SELECT
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date,
	COUNT(*) AS duplicates_product
FROM product_info_temp pip 
GROUP BY 
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date
HAVING COUNT(*) > 1;

-- Удаление дубликатов по примеру product, 
BEGIN;

WITH ranked AS (
SELECT 
	ctid,
	ROW_NUMBER() OVER (
	PARTITION BY product_rk, product_name, effective_from_date, effective_to_date
	ORDER BY ctid
	) AS rn
FROM product_info_temp
)
DELETE FROM product_info_temp mp
WHERE ctid IN (SELECT ctid FROM ranked WHERE rn > 1);
-- Проверка перед commit на дубликаты
SELECT
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date,
	COUNT(*) AS duplicates_product
FROM product_info_temp pip 
GROUP BY 
	product_rk, 
	product_name,
	effective_from_date, 
	effective_to_date
HAVING COUNT(*) > 1;

--COMMIT;
--ROLLBACK;



	