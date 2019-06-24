# Desafio RoR Inovamind

Jonata William


## Sumário

* [Introdução](#Introdução)
  - [Tecnologias/Padrões](#Tecnologias/Padrões)
  - [Desafio](#Desafio)
  - [Observações](#Observações)
  - [Requisitos](#Requisitos)
* [Estrutura](#Estrutura)
  - [Models](#Models)
  - [Controllers](#Controllers)
  - [Lib](#Lib)
  - [Services](#Services)
* [Testar](#Testar)
  - [Heroku](#Heroku)
  - [Docker](#Docker)
  - [Local](#Local)
* [End_Point](#End_Point)

### Introdução

**Tecnologias/Padrões**
Devem ser utilizadas as seguintes tecnologias:

* Ruby on Rails
* MongoDB
* API (protegida por token de acesso)

**Desafio**

Crie um web crawler para efetuar uma busca de frases no site http://quotes.toscrape.com/.
As infomações vindas do crawler devem ser disponibilizadas por uma API. Esta API deve receber como parâmetro uma tag e buscar por frases que estejam classificadas de acordo com esta tag.
As informações extraidas do site devem ser salvas no MongoDB que simulará um cache, onde caso a tag já tenha sido pesquisada, deverá retornar os dados persistidos previamente no banco de dados.
A api deve possuir o endpoint /quotes/{SEARCH_TAG}. Uma consulta ao mesmo deve retornar um objeto json com a seguinte estrutura:

```json
{
"quotes": [
    {
      "quote": "frase",
      "author": "nome do autor",
      "author_about": "link para o perfil do autor",
      "tags": ["tag1", "tag2"]
    } 
  ]
}
```

**Observações**

* Não é necessário crawlear todas as páginas de retorno da busca no site, apenas a primeira página de resposta.
* Dica: Utilize a gem Mongoid para trabalhar com o Mongo.
* Dica: Utilize serialização de objetos para retornar o json.

**Requisitos:**

* A consulta ao endpoint deve apenas ser executada para requisições que possuam o token de acesso. As informações devem ser salvas no MongoDB.
* Crie um repositório para a solução desenvolvida no Github.

### Estrutura
```
desafio-ror-inovamind/
├── app/
│   ├── channels/
│   ├── controller/
│   │   ├── concerns/
│   │   ├── application_controller.rb
│   │   ├── authentication_controller.rb
│   │   ├── quotes_controller.rb
│   ├── jobs/
│   │   ├── ...
│   ├── lib/
│   │   ├── json_web_token.rb
│   ├── mailers/
│   │   ├── ...
│   ├── models/
│   │   ├── concerns/
│   │   ├── author.rb
│   │   ├── quote.rb
│   │   ├── tag.rb
│   │   ├── user.rb
│   ├── serializers/
│   │   ├── author_serializer.rb
│   │   ├── quote_serializer.rb
│   │   ├── tag_serializer.rb
│   ├── services/
│   │   ├── quote_service.rb
│   │   ├── web_crawler_service.rb
│   ├── views/
│   │   ├── layout/
│   │   │   ├── ...
├── bin/
│   ├── ...
├── config/
│   ├── environments/
│   │   ├── development.rb
│   │   ├── production.rb
│   │   ├── test.rb
│   ├── initializers/
│   │   ├── application_controller_renderer.rb
│   │   ├── backtrace_silencers.rb
│   │   ├── cors.rb
│   │   ├── filter_parameter_logging.rb
│   │   ├── inflections.rb
│   │   ├── mine_types.rb
│   │   ├── rack_attack.rb
│   │   ├── wrap_parameters.rb
│   ├── locales/
│   │   ├── en.yml
│   ├── application.rb
│   ├── boot.rb
│   ├── cable.yml
│   ├── credentials.yml.enc
│   ├── environment.rb
│   ├── mongoid.yml
│   ├── puma.rb
│   ├── routes.rb
│   ├── spring.rb
├── db/
│   ├── seeds/
│   │   ├── user.rb
├── lib/
│   ├── taks
│   ├── desafio.task
├── log/
│   ├── ...
├── public/
│   ├── ...
├── test/
│   ├── ...
├── .gitignore
├── .ruby-version
├── config.ru
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── Procfile
├── Rakefile
├── README.md
├── start.sh
└── ...
```
##### Models

- **User** 
Tabela voltado para os usuários da aplicação. Fields: name, email, password
- **Author** 
Tabela voltado para os autores das citações. Relacionamento com tabela Quote. Fields: name, author_url.
- **Tag** 
Tabela voltado para as tags das citações. Relacionamento com tabela Quote. Fields: title.
- **Quote** 
Tabela voltado para as citações. Relacionamento com tabela Author e Tags. Fields: quote.

##### Controllers

- **Authentication**
Metódos: 
* [POST] login -> este corresponde ao end point */auth/login* no qual recebe como parâmetro uma *email* e *password*, procurar um usuário que corresponda aos parâmetros informado e caso de positivo chama a Lib JsonWebToken que irá fornecer um Token, este com válidade de 30 minutos.
- **Application**
Metódos: 
* authorize_request -> este corresponde por válidar o token informado no *header* das chamadas pelo end point */quote/{search_tag}*.
- **Quote**
Metódos: 
* [GET] search_tag -> este corresponde ao end point */quote/{search_tag}* no qual recebe como parâmetro uma *tag*, assim chamar o Service Quote para pesquisar as citações que correspondam a *tag* informado no parâmetro. 

##### Lib

- **JsonWebToken** 
Metódos: 
* encode -> gerar um token que tem válidade de 30 minutos. 
* decode -> utilizado para ler o token e válidar o mesmo.

##### Services

- **WebCrawler**
Metódos privados: 
* tag_strip -> verifica se a palavra referente *tag* informada contém *espaços*, caso tenha, o metódo remove os mesmos.
* web_carwler -> recebe a *tag* e com a utilização do Nokogiri realiza um web crawler na página "http://quotes.toscrape.com" retornando o conteúdo numa variável *quotes_crawled*.
Metódos publicos: 
* execute -> chama o metódo tag_strip passando a *tag* por parâmetro e posteriormente chama o metódo web_crawler.

- **Quote**
Metódos privados: 
* database_save -> recebe por parâmetro uma variável *quotes_crawled* que contém a página que foi feito o crawler e salva no banco de dados.
* search_quotes -> recebe a *tag* e realiza a pesquisa, em caso de positivo retorna a variável com todas as citações refernte a esta *tag*, caso de negativa, chama o Service WebCrawler que irá buscar as citações que ainda não estão no banco de dados.
Metódos publicos: 
* execute -> chama o metódo search_quotes passando a *tag* por parâmetro.

### Testar

#### Heroku

Foi feito deploy para produção utilizando o serviço Heroku e MongoDB Atlas, assim é possível testar o mesmo sem precisar configurar nada.
Endereço para teste:

[https://desafio-ror-inovamind.herokuapp.com](https://desafio-ror-inovamind.herokuapp.com)

Com o endereço, vejas os [End Point](#EndPoint) da aplicação.



#### Docker

Se você não tiver o Docker no computador, siga as instruções de instalação no Docker, Github([mais informações aqui](https://github.com/docker/docker-install)).

Clone o projeto no diretório de sua escolha.
```bash
git clone https://github.com/jonatawilliam/desafio-ror-inovamind
cd your-project-name
```

Execute o comando do Docker para compilação.
```bash
docker-compose build
```

Agora faça o upload do serviço criado no Docker
```bash
docker up
```

Execute o comando  em outra janela do terminal para popular o adicionar usuário para login e obter token.
```bash
docker-compose run --rm app bundle exec rake db:seed:user
```


#### Obs: para executar usando o Docker, alterar o arquivo 'mongoid.yml' conforme abaixo

Atual
```yaml
production:
  clients:
    default:
      uri: <%= ENV['MONGODB_URI'] %>
development:
  clients:
    default:
      database: desafio_ror_inovamind_development
      hosts:
        - localhost
test:
  clients:
    default:
      database: desafio_ror_inovamind_test
      hosts:
        - localhost:27017
      options:
        read:
          mode: :primary
        max_pool_size: 1
```

Modificado
```yaml
production:
  clients:
    default:
      uri: <%= ENV['MONGODB_URI'] %>
development:
  clients:
    default:
      database: desafio_ror_inovamind_development
      hosts:
        - mongodb
test:
  clients:
    default:
      database: desafio_ror_inovamind_test
      hosts:
        - localhost:27017
      options:
        read:
          mode: :primary
        max_pool_size: 1
```


#### Local

- Instale a versão 2.6.3 do ruby e configure-a com o seu gerenciador de ambiente ruby ([mais informações aqui](https://www.ruby-lang.org/en/documentation/installation/)).
- Instale o MongoDB e inicie o servidor MongoDB em primeiro plano ([mais informações aqui](https://docs.mongodb.com/manual/installation/#mongodb-community-edition-installation-tutorials)).
- Clone o repositório e acesse o diretório clonado:

```bash
git clone https://github.com/jonatawilliam/api-maskEs-soccer.git
cd nome-do-seu-projeto
```

- Em outro janela do terminal, iniciar MongoDB: 
```bash
mongod
```

- Executar os comando no diretório do projeto:

Baixar e atualizar as gems: 
```bash
bundle install
```

Criar usuário teste: 
```bash
rake db:seed:user
```

Inicializar servidor Puma: 
```bash
rails s
```



### End_Point

End point para solicitar um Token:
POST
[http://localhost:3000/auth/login](http://localhost:3000/auth/login)

Dados do usuário teste para autenticação e obteção do Token:
* email: desafio@inovamind.com.br
* password: 123456 

Retorno:
```json
{
  "token": "hash token",
  "expirate": "06-23-2019 20:21"
}
```


End point para efetuar buscas de citações atráves de uma Tag:
GET
[http://localhost:3000/quotes/{search_tag}](http://localhost:3000/quotes/{search_tag})

Exemplo:
http://localhost:3000/quotes/value

Retorno:
```json
[
  {
    "quote": "“Try not to become a man of success. Rather become a man of value.”",
    "author": "Albert Einstein",
    "author_about": "http://quotes.toscrape.com/author/Albert-Einstein",
    "tags": [
      "value"
    ]
  }
]
```