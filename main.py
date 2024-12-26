# postgresql://root@129.154.47.3:26257/defaultdb?sslcert=%2Fcockroach%2Fcerts%2Fclient.root.crt&sslkey=%2Fcockroach%2Fcerts%2Fclient.root.key&sslmode=verify-full&sslrootcert=%2Fcockroach%2Fcerts%2Fca.crt

# access the cockroachdb above and create a table named 'users' 


import psycopg2
import os

# connect to the cockroachdb using above link
conn = psycopg2.connect(
    database='defaultdb',
    user='root',
    password='suraj@1234',
    sslmode='require',
    sslrootcert='certs/ca.crt',
    sslkey='certs/client.root.key',
    sslcert='certs/client.root.crt',
    port=26257,
    host='129.154.47.3'
)

# create a cursor object using the connection
cur = conn.cursor()

# create a table named 'users' with columns 'id', 'name', 'age'
cur.execute("CREATE TABLE users (id INT PRIMARY KEY, name STRING, age INT)")

# insert some data into the table
cur.execute("INSERT INTO users (id, name, age) VALUES (1, 'John', 25)")
cur.execute("INSERT INTO users (id, name, age) VALUES (2, 'Jane', 30)")
cur.execute("INSERT INTO users (id, name, age) VALUES (3, 'Alice', 35)")

# commit the changes
conn.commit()

# close the cursor and connection
cur.close()
conn.close()
