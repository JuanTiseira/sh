docker run --name my-postgres-l \
    -e POSTGRES_USER=myuser \
    -e POSTGRES_PASSWORD=sistemas*2023 \
    -e POSTGRES_DB=ctd-dev \
    -p 5432:5432 \
    -v /home/juani/Documentos/dev/postgres:/var/lib/postgresql/data \
    -d postgres
