sudo -u postgres psql -f $INSTALLATION_FILES/initdb.sql

sudo cp ${PG_CONF_DIR}/pg_hba.conf ${PG_CONF_DIR}/pg_hba.conf.orig 
sudo cp ${INSTALLATION_FILES}/pg_hba.conf-9.3 ${PG_CONF_DIR}/pg_hba.conf

sudo cp ${PG_CONF_DIR}/postgresql.conf ${PG_CONF_DIR}/postgresql.conf.orig
sudo cp ${INSTALLATION_FILES}/postgresql.conf-9.3 ${PG_CONF_DIR}/postgresql.conf

sudo service postgresql restart
