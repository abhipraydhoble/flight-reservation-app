# 📘 Flight Reservation System – Database Setup (AWS RDS)

---

## 🔹 1. Install MySQL Client 

Update package index and install MySQL:

```bash
sudo apt update -y
sudo apt install mysql-server -y
```

Start and enable MySQL service:

```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```

Verify installation:

```bash
mysql --version
```

---

## 🔹 2. Connect to AWS RDS MySQL Instance

Use the RDS endpoint, username, and password provided while creating the RDS instance.

### 🔸 Syntax

```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

### 🔸 Example

```bash
mysql -h flightdb.xxxxx.ap-south-1.rds.amazonaws.com -u admin -p
```

---

## 🔹 3. Create Database

Once connected to RDS, create the database:

```sql
CREATE DATABASE flightdb;
```

Exit MySQL:

```sql
EXIT;
```

---

## 🔹 4. Import Database Schema & Data

Ensure the file `flightdb.sql` is present in the current directory.

### 🔸 Import SQL file

```bash
mysql -h <RDS-ENDPOINT> -u admin -p flightdb < flightdb.sql
```

---

## 🔹 5. Verify Database & Tables

Login again to MySQL:

```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

Select database and verify tables:

```sql
USE flightdb;
SHOW TABLES;
```

Verify sample data:

```sql
SELECT COUNT(*) FROM flight;
```

---

## 🔹 6. Expected Tables

After successful import, the following tables should be available:

```
users
user_roles
flight
booking
check_in
```

---

✅ **Database setup completed successfully!**
You can now connect this RDS database to your backend application.


Just say the word 🚀
