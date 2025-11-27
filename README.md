# Flutter CRUD de Usuários com SQLite

Este é um aplicativo Flutter para gerenciamento de usuários com autenticação e controle de permissões (Admin/Normal), utilizando SQLite como banco de dados.

## Funcionalidades

- **Autenticação**: Login com email e senha.
- **Permissões**:
  - **Admin**: Pode listar todos os usuários, ver detalhes e editar qualquer perfil.
  - **Normal**: Pode ver e editar apenas seu próprio perfil.
- **CRUD Completo**: Criação, Leitura, Atualização e Exclusão (via edição de status/papel) de usuários.
- **Persistência**: Dados salvos localmente usando SQLite.

## Pré-requisitos

- Flutter SDK instalado
- Google Chrome (para rodar na web)

## Como Rodar

### Web

Para rodar na web com suporte ao SQLite (via `sqflite_common_ffi_web`), é necessário ter os arquivos `sqflite_sw.js` e `sqlite3.wasm` na pasta `web/`. Estes arquivos já foram baixados durante a configuração.

Execute o seguinte comando no terminal:

```bash
flutter run -d chrome --web-port=8080
```

### Mobile (Android/iOS)

Para rodar em dispositivos móveis, basta executar:

```bash
flutter run
```

## Credenciais de Teste

O sistema já vem com um usuário administrador pré-cadastrado:

- **Email**: `admin@email.com`
- **Senha**: `admin123`

## Estrutura do Projeto

- `lib/models`: Modelos de dados (User).
- `lib/database`: Configuração e operações do banco de dados SQLite.
- `lib/services`: Serviços de autenticação e lógica de negócios.
- `lib/screens`: Telas do aplicativo (Login, Lista, Perfil, Cadastro, Edição).
- `lib/widgets`: Componentes reutilizáveis (se houver).

## Dependências Principais

- `sqflite`: Banco de dados SQLite.
- `sqflite_common_ffi_web`: Suporte SQLite para Web.
- `provider`: Gerenciamento de estado.
- `url_launcher`: Abertura de links externos.
- `intl`: Formatação de datas.
