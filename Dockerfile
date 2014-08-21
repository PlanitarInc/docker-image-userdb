FROM planitar/postgresql

ADD  config.sql /src/config.sql

USER root

RUN sed -e "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" \
        -i /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host userdb user_api 0.0.0.0/0 trust" \
    >>/etc/postgresql/9.3/main/pg_hba.conf

# Start the server and run the config commands
RUN service postgresql start && \
    su postgres -c "psql -f /src/config.sql" && \
    service postgresql stop

USER postgres
