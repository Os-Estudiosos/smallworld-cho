import psycopg2

class Connection:
    def __init__(self, db_name, path, user, host, password):
        self.db_name = db_name
        self.path = path
        self.user = user
        self.host = host
        self.password = password
        self.conn = None
    
    def initialize(self):
        try:
            self.conn = psycopg2.connect(
                dbname=self.db_name,
                user=self.user,
                password=self.password,
                host=self.host,
                port=5432
            )
            with self.conn.cursor() as cur:
                cur.execute(f'SET search_path TO {self.path};')
            self.conn.commit()
            return self.conn

        except Exception as e:
            print("Erro ao conectar ao banco de dados:", e)
            self.conn = None
            return None
    
    def cursor(self):
        if not self.conn:
            raise Exception("Conexão não inicializada")
        return self.conn.cursor()

    def commit(self):
        if self.conn:
            self.conn.commit()

    def rollback(self):
        if self.conn:
            self.conn.rollback()

    def close(self):
        if self.conn:
            self.conn.close()
