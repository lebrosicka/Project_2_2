-- Скрипт создания процедуры формирования витрины заново, исходя из прототипа 

CREATE OR REPLACE PROCEDURE dm.refresh_loan_holiday_info()
LANGUAGE plpgsql
AS $$
BEGIN
-- Перед повторным заполнением витрины очищаем её
    TRUNCATE TABLE dm.loan_holiday_info;

-- Скрипт заполнения свежими данными из исходных таблиц
    INSERT INTO dm.loan_holiday_info (
        deal_rk,
        effective_from_date,
        effective_to_date,
        agreement_rk,
        client_rk,
        department_rk,
        product_rk,
        product_name,
        deal_type_cd,
        deal_start_date,
        deal_name,
        deal_number,
        deal_sum,
        loan_holiday_type_cd,
        loan_holiday_start_date,
        loan_holiday_finish_date,
        loan_holiday_fact_finish_date,
        loan_holiday_finish_flg,
        loan_holiday_last_possible_date
    )
    SELECT
        d.deal_rk,
        lh.effective_from_date,
        lh.effective_to_date,
        d.agreement_rk,
        d.client_rk,
        d.department_rk,
        d.product_rk,
        p.product_name,
        d.deal_type_cd,
        d.deal_start_date,
        d.deal_name,
        d.deal_num AS deal_number,
        d.deal_sum,
        lh.loan_holiday_type_cd,
        lh.loan_holiday_start_date,
        lh.loan_holiday_finish_date,
        lh.loan_holiday_fact_finish_date,
        lh.loan_holiday_finish_flg,
        lh.loan_holiday_last_possible_date
    FROM rd.deal_info d
    LEFT JOIN rd.loan_holiday lh 
        ON d.deal_rk = lh.deal_rk 
        AND d.effective_from_date = lh.effective_from_date
    LEFT JOIN rd.product p 
        ON p.product_rk = d.product_rk
        AND p.effective_from_date = d.effective_from_date;

-- Добавил обработку ошибок если что-то пошло не так, транзакция откатится автоматически
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ошибка: %', SQLERRM;
            RAISE;
END;
$$;
