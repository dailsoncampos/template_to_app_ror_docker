#!/bin/bash
set -e

# Remove o arquivo de PID do servidor Rails, caso exista.
if [ -f /my_app/tmp/pids/server.pid ]; then
  rm /my_app/tmp/pids/server.pid
fi

# Verifica se as gems estão instaladas, caso contrário, instala as dependências.
bundle check || bundle install

# Espera o banco de dados estar disponível antes de continuar.
echo "Aguardando banco de dados..."
until nc -z $DB_HOST 5432; do
  sleep 1
  echo "Ainda aguardando o banco de dados..."
done

echo "Banco de dados está disponível! Continuando..."

# Executa as migrações do banco de dados
bundle exec rails db:migrate

# Se você precisar garantir que as seeds sejam rodadas:
# bundle exec rails db:seed

# Executa o comando que foi fornecido para o container (default é iniciar o servidor Rails).
exec "$@"
