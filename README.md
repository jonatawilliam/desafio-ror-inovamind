# Desafio RoR Inovamind

Jonata William


### Introdução

*Tecnologias/Padrões*
Devem ser utilizadas as seguintes tecnologias:

* Ruby on Rails
* MongoDB
* API (protegida por token de acesso)

*Desafio*

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

*Observações*

* Não é necessário crawlear todas as páginas de retorno da busca no site, apenas a primeira página de resposta.
* Dica: Utilize a gem Mongoid para trabalhar com o Mongo.
* Dica: Utilize serialização de objetos para retornar o json.

*Requisitos:*

* A consulta ao endpoint deve apenas ser executada para requisições que possuam o token de acesso. As informações devem ser salvas no MongoDB.
* Crie um repositório para a solução desenvolvida no Github.

### Solução

À ser desenvolvida





