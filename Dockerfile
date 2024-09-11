# Especificando a versão do Ruby como argumento
ARG RUBY_VERSION=3.1
FROM ruby:${RUBY_VERSION}

# Instalar dependências do sistema
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  redis-tools \
  && rm -rf /var/lib/apt/lists/*

# Atualizar o sistema de gems
RUN gem update --system

# Definir o diretório de trabalho da aplicação
WORKDIR /my_app

# Copiar o Gemfile e Gemfile.lock antes de instalar as gems (para cache de dependências)
COPY Gemfile Gemfile.lock ./

# Instalar gems do bundle, incluindo Devise e Rubocop
RUN bundle config set deployment 'true' \
  && bundle install --jobs 4 --retry 3

# Copiar o restante da aplicação
COPY . .

# Copiar o entrypoint e torná-lo executável
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Definir o entrypoint padrão
ENTRYPOINT ["entrypoint.sh"]

# Expor a porta 3000 para o Rails
EXPOSE 3000

# Comando padrão ao iniciar o container
CMD ["rails", "server", "-b", "0.0.0.0"]
