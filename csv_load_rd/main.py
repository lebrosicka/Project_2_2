from __future__ import annotations

import argparse
import logging
import os
from pathlib import Path
from dotenv import load_dotenv

from sqlalchemy import create_engine, text

from csv_loader import read_deal_csv, read_product_csv

_SCRIPT_DIR = Path(__file__).resolve().parent
load_dotenv(_SCRIPT_DIR / ".env")

LOG = logging.getLogger(__name__)


# Функция возвращает путь к папке где лежат оба CSV
def default_csv_dir() -> Path:
    return (
        Path(__file__).resolve().parents[1]
        / "input"
        / "data"
        / "data"
        / "loan_holiday_info"
    )


# Функция читает переменную окружения DATABASE_URL для подключения
def build_engine():
    database_url = os.getenv("DATABASE_URL")
    if not database_url:
        # Ошибка если DataBaseUrl не будет найдена
        raise SystemExit("Ошибка: Не найдена переменная окружения DATABASE_URL.")
    return create_engine(database_url)


# Функция формирует полные пути к CSV файлам в папке, которую вернула фунция default_csv_dir и устанавливает кодировку для чтения
def run_dry() -> int:
    deal_path = default_csv_dir() / "deal_info.csv"
    product_path = default_csv_dir() / "product_info.csv"
    encoding = "cp1251"
    # Вызов функций чтения CSV файлов из csv_loader
    deal_df = read_deal_csv(deal_path, encoding)
    prod_df = read_product_csv(product_path, encoding)
    # Здесь для наглядности выводится колличество строк и колонок в каждом прочтённом CSV, возвращает 0 при успешном чтении
    print(f"deal_info.csv: {len(deal_df)} строк, колонок {len(deal_df.columns)}")
    print(f"product_info.csv: {len(prod_df)} строк, колонок {len(prod_df.columns)}")
    print("Dry-run: файлы прочитаны, в БД ничего не записано.")
    return 0


# В этой функции мы собираем уже известные нам переменные, пути к папке где CSV, кодировку, подключение и чтение
def run_apply() -> int:
    deal_path = default_csv_dir() / "deal_info.csv"
    product_path = default_csv_dir() / "product_info.csv"
    encoding = "cp1251"

    engine = build_engine()
    deal_df = read_deal_csv(deal_path, encoding)
    prod_df = read_product_csv(product_path, encoding)
    # Открываем транзацкцию, для того чтобы при выходе из неё при наличии ошибок произошёл откат
    with engine.begin() as conn:
        # В данный момент очистка отключена, если понадобиться то просто раскоментировать
        # conn.execute(text("TRUNCATE TABLE rd.deal_info_temp"))
        # conn.execute(text("TRUNCATE TABLE rd.product_info_temp"))
        LOG.info("Загрузка без TRUNCATE (таблицы не очищаются)")
        # Тут используем метод из модуля Pandas to_sql и загружаем DataFrame во временную таблицу deal_info_temp
        deal_df.to_sql(
            "deal_info_temp",
            con=conn,
            schema="rd",
            if_exists="append",
            index=False,
            chunksize=500,
            method="multi",
        )
        # Аналогично для product_info_temp
        prod_df.to_sql(
            "product_info_temp",
            con=conn,
            schema="rd",
            if_exists="append",
            index=False,
            chunksize=500,
            method="multi",
        )
    # Выводим статистику по загруженным строкам и возвращаем 0 при успехе
    print(
        f"Загружено: deal_info_temp {len(deal_df)} строк, "
        f"product_info_temp {len(prod_df)} строк."
    )
    return 0


# Главная функция, сначала настройка логирования затем добавление парсера аргументов для исключительного чтения "--dry", в противном случае полная загрузка


def main(argv: list[str] | None = None) -> int:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")

    parser = argparse.ArgumentParser(
        description="CSV → rd.deal_info_temp / rd.product_info_temp (без очистки)"
    )
    parser.add_argument(
        "--dry",
        action="store_true",
        help="Только прочитать CSV, без записи в БД",
    )

    args = parser.parse_args(argv)

    if args.dry:
        return run_dry()
    else:
        return run_apply()


if __name__ == "__main__":
    raise SystemExit(main())
