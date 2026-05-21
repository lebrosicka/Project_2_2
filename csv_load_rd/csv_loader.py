import pandas as pd
from pathlib import Path

# Задаём список значений колонок, которые мы будем брать из CSV файла deal
DEAL_COLS = [
    "deal_rk",
    "deal_num",
    "deal_name",
    "deal_sum",
    "client_rk",
    "account_rk",
    "agreement_rk",
    "deal_start_date",
    "department_rk",
    "product_rk",
    "deal_type_cd",
    "effective_from_date",
    "effective_to_date",
]

# Задаём список значений колонок, которые мы будем брать из CSV файла product
PRODUCT_COLS = [
    "product_rk",
    "product_name",
    "effective_from_date",
    "effective_to_date",
]


# Функция принимает 2 параметра, путь к файлу и кодировку текста и возвращает DataFrame таблицу с помощью модуля Pandas
def read_deal_csv(path: Path, encoding: str = "cp1251") -> pd.DataFrame:
    # Команда открывает CSV, затем читает его и создаёт DataFrame со всеми колонками из DEAL_COLS и возвращает результат который будет использован в main
    return pd.read_csv(path, encoding=encoding)[DEAL_COLS]


# Аналогичная функция но для product
def read_product_csv(path: Path, encoding: str = "cp1251") -> pd.DataFrame:
    return pd.read_csv(path, encoding=encoding)[PRODUCT_COLS]
