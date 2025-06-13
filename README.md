# Docker Databases Setup

This project provides a complete setup for running MySQL and PostgreSQL databases in Docker containers with persistent storage, configuration management, and CloudBeaver (web-based DBeaver) for unified database administration.

## 🗂️ Project Structure

```
docker-databases/
├── docker-compose.yml          # Main compose file (runs both databases)
├── mysql/
│   ├── config/
│   ├── data/                  # MySQL persistent data (host binding - optional)
│   └── logs/                  # MySQL logs
├── postgres/
│   ├── config/
│   │   └── postgresql.conf    # PostgreSQL configuration
│   ├── data/                  # PostgreSQL persistent data
│   ├── logs/                  # PostgreSQL logs
│   └── initdb/                # SQL scripts to run on first startup
├── cloudbeaver/
│   ├── workspace/             # CloudBeaver workspace data
│   └── logs/                  # CloudBeaver logs
└── README.md                  # This file
```

## 🚀 Quick Start

### Start Both Databases
```bash
# Start both MySQL and PostgreSQL with CloudBeaver
docker compose up -d

# View logs
docker compose logs -f

# Stop all services
docker compose down
```

### Start Individual Databases

#### MySQL Only
```bash
cd mysql
docker compose up -d
```

#### PostgreSQL Only
```bash
cd postgres
docker compose up -d
```

## 🔧 Configuration

### MySQL Configuration
- **Config file**: `mysql/config/my.cnf`
- **Key settings**:
  - MySQL 8.0 optimized
  - InnoDB storage engine
  - UTF8MB4 character set
  - Performance tuned for development
  - Logging enabled

### PostgreSQL Configuration
- **Config file**: `postgres/config/postgresql.conf`
- **Key settings**:
  - PostgreSQL 16 optimized
  - Memory settings tuned for development
  - WAL configuration for reliability
  - Comprehensive logging
  - Performance monitoring enabled

## 🔑 Default Credentials

### MySQL
- **Root Password**: `root123`
- **Database**: `myapp`
- **User**: `appuser`
- **Password**: `appuser123`
- **Port**: `3306`

### PostgreSQL
- **Database**: `myapp`
- **User**: `appuser`
- **Password**: `appuser123`
- **Port**: `5432`

## 🌐 Web Administration

### CloudBeaver (Universal Database Tool)
- **URL**: http://localhost:8081
- **Initial Setup**: First time access will require setup
- **Features**: 
  - Single interface for both MySQL and PostgreSQL
  - Web-based DBeaver with full SQL capabilities
  - Visual query builder and data editor
  - Schema browser and ERD diagrams
  - Connection management and user authentication

#### CloudBeaver First-Time Setup:
1. Open http://localhost:8081
2. Create an admin user account
3. Add database connections:
   - **MySQL**: Host: `mysql`, Port: `3306`, User: `appuser`, Password: `appuser123`
   - **PostgreSQL**: Host: `postgres`, Port: `5432`, User: `appuser`, Password: `appuser123`

## 📊 Database Connections

### From Host Machine
```bash
# MySQL
mysql -h localhost -P 3306 -u appuser -p

# PostgreSQL
psql -h localhost -p 5432 -U appuser -d myapp
```

### From Application (Docker Network)
```bash
# MySQL connection string
mysql://appuser:appuser123@mysql:3306/myapp

# PostgreSQL connection string
postgresql://appuser:appuser123@postgres:5432/myapp
```

## 🔧 Management Commands

### View Running Containers
```bash
docker compose ps
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f mysql
docker compose logs -f postgres
```

### Execute Commands in Containers
```bash
# MySQL
docker compose exec mysql mysql -u root -p
docker compose exec mysql bash

# PostgreSQL
docker compose exec postgres psql -U appuser -d myapp
docker compose exec postgres bash
```

### Backup Databases
```bash
# MySQL backup
docker compose exec mysql mysqldump -u root -p myapp > backup_mysql.sql

# PostgreSQL backup
docker compose exec postgres pg_dump -U appuser myapp > backup_postgres.sql
```

### Restore Databases
```bash
# MySQL restore
docker compose exec -T mysql mysql -u root -p myapp < backup_mysql.sql

# PostgreSQL restore
docker compose exec -T postgres psql -U appuser -d myapp < backup_postgres.sql
```

## 🔄 Data Persistence

Both databases use Docker volumes for persistent storage:
- **MySQL data**: `./mysql/data/`
- **PostgreSQL data**: `./postgres/data/`
- **Logs**: `./mysql/logs/` and `./postgres/logs/`

Data persists even when containers are stopped or removed.

## 🛠️ Customization

### Adding Initialization Scripts
Place SQL files in `postgres/initdb/` to run them automatically when PostgreSQL starts for the first time.

### Modifying Configuration
1. Edit the configuration files (`my.cnf` or `postgresql.conf`)
2. Restart the containers: `docker compose restart mysql` or `docker compose restart postgres`

### Changing Passwords
1. Update the environment variables in `docker-compose.yml`
2. Remove the data volumes if databases already exist
3. Restart: `docker compose down && docker compose up -d`

## 🩺 Health Checks

Both databases include health checks:
- **MySQL**: Uses `mysqladmin ping`
- **PostgreSQL**: Uses `pg_isready`

Check health status:
```bash
docker compose ps
```

## 🔒 Security Notes

⚠️ **Important**: This setup is designed for development environments. For production:
1. Change all default passwords
2. Use environment files for secrets
3. Configure proper networking
4. Enable SSL/TLS
5. Review and harden configurations
6. Implement proper backup strategies

## 🐛 Troubleshooting

### Container Won't Start
```bash
# Check logs
docker compose logs [service-name]

# Check if ports are available
netstat -tlnp | grep 3306  # MySQL
netstat -tlnp | grep 5432  # PostgreSQL
```

### Permission Issues
```bash
# Fix ownership of data directories 
sudo chown -R 999:999 mysql/data
sudo chown -R 999:999 postgres/data
```

### Reset Everything
```bash
# Stop and remove everything including volumes
docker compose down -v
sudo rm -rf mysql/data/* postgres/data/*
docker compose up -d
```