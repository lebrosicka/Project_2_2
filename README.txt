Задание 2.2 выполнено в соответствии с условиями, выгрузка данных из CSV в БД реализована на языке python с использованием встроенного модуля Pandas.
Все остальные манипуляции с БД реализованы в виде SQL скриптов. В каждом SQL скрипте присутствуют явные комментарии с указанием их функции. 

Очередность запуска и выполнения файлов:

1. Создать .env и внести туда данные о БД
2. Выполнить drop_duplicates для исходных таблиц deal_info, product, loan_info
3. Выполнить create_rd_temp_tables создав временные таблицы для выгрузки данных из CSV
4. Выполнить main.py
5. Выполнить drop_duplicates для временных таблицы deal_info_temp, product_info_temp
6. Выполнить insert_missing_deal_info_product добавив недостающие данные из временных таблиц в основные
7. Выполнить drop_create_dm_loan_holiday_info создав новую витрину по прототипу
8. Выполнить refresh_loan_holiday_info_procedure создав процедуру наполнения
9. Вызвать процедуру call_dm_refresh_loan_holiday

Схема файлов:

Project_2_2/                         python скрипты для выгрузки данных
├── csv_load_rd/
│   ├── main.py                     
│   ├── csv_loader.py
│   └── .env
│
├── sql/                            # SQL-скрипты
   ├── create_rd_temp_tables_2_2.sql
   ├── drop_duplicates.sql
   ├── migration_deal_product.sql
   ├── insert_missing_deal_info_product.sql
   ├── refresh_loan_holiday_info_procedure.sql
   ├── call_dm_refresh_loan_holiday.sql
   └── drop_create_dm_loan_holiday_info.sql

