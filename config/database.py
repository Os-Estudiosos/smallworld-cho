import os
from dotenv import load_dotenv

load_dotenv()

DB_NAME="cho"
DB_PATH="cho"
DB_USER = os.getenv("DB_USER")
DB_HOST= os.getenv("DB_HOST")
DB_PASSWORD= os.getenv("DB_PASSWORD")
DB_PORT="5432"  # Default

N_PAISES = 10
N_ITENS = 40
N_CLIENTES = 50
MAX_NUM_TELEFONE = 3
PROB_ENFERMIDADE = 0.3
N_INGREDIENTES = 25
N_FILIAIS = 5
N_FORNECEDORES = 10
N_FUNCIONARIOS = 30
MAX_INGREDIENTES = 20
N_RESERVAS = 60
MAX_MESAS = 20
N_PEDIDOS = 120
MAX_QTD = 5
MAX_ITENS = 4

FAKER_LOCALES = {
    "pt_BR": "Brazil",
    "pt_PT": "Portugal",

    "en_US": "United States",
    "en_GB": "United Kingdom",
    "en_CA": "Canada",
    "en_AU": "Australia",
    "en_NZ": "New Zealand",

    "fr_FR": "France",
    "fr_CA": "Canada",
    "fr_BE": "Belgium",
    "fr_CH": "Switzerland",

    "es_ES": "Spain",
    "es_MX": "Mexico",
    "es_AR": "Argentina",
    "es_CO": "Colombia",
    "es_CL": "Chile",
    "es_VE": "Venezuela",

    "de_DE": "Germany",
    "de_AT": "Austria",
    "de_CH": "Switzerland",

    "it_IT": "Italy",

    "nl_NL": "Netherlands",
    "nl_BE": "Belgium",

    "sv_SE": "Sweden",
    "nb_NO": "Norway",
    "da_DK": "Denmark",
    "fi_FI": "Finland",

    "ru_RU": "Russia",
    "uk_UA": "Ukraine",

    "pl_PL": "Poland",
    "cs_CZ": "Czech Republic",
    "sk_SK": "Slovakia",
    "sl_SI": "Slovenia",

    "ja_JP": "Japan",
    "ko_KR": "South Korea",
    "zh_CN": "China",
    "zh_TW": "Taiwan",

    "ar_EG": "Egypt",
    "ar_SA": "Saudi Arabia",
    "ar_JO": "Jordan",

    "tr_TR": "Turkey",

    "hi_IN": "India",
    "bn_BD": "Bangladesh",

    "el_GR": "Greece",

    "ro_RO": "Romania",
    "hu_HU": "Hungary",
    "bg_BG": "Bulgaria",
}
