
# 📚 Biblioteca Saber Livre

![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)

Este projeto é a implementação prática (Etapa 3) do sistema de banco de dados para a **Biblioteca Saber Livre**, desenvolvido como requisito avaliativo para a disciplina de Introdução a Sistemas de Banco de Dados. 

O projeto contempla a criação e manipulação avançada de um banco de dados relacional (esquema físico) e uma interface Web interativa para a gestão do acervo de livros.

## 🏛️ Contexto Acadêmico
* **Instituição:** Universidade Federal de Lavras (UFLA)
* **Departamento:** Departamento de Ciência da Computação (DCC)
* **Disciplina:** GCC214 - Introdução a Sistemas de Banco de Dados
* **Professor:** Denilson Alves Pereira
* **Período:** 2026/1

---

## 🚀 Funcionalidades Implementadas

O projeto foi construído para atender a todos os requisitos arquiteturais e de manipulação de dados exigidos na especificação técnica:

### 💾 1. Banco de Dados (SQL)
- **Modelagem Física (DDL):** Criação de 11 tabelas normalizadas com todas as restrições de chave primária (`PRIMARY KEY`), chave estrangeira (`FOREIGN KEY` com `CASCADE`), `UNIQUE` e `DEFAULT`.
- **Manipulação de Dados (DML):** Inserções em massa, deleções e atualizações complexas (aninhadas com subconsultas).
- **Consultas Avançadas (DQL):** Mais de 12 relatórios complexos explorando `INNER/OUTER JOIN`, `UNION`, agrupamentos (`GROUP BY`/`HAVING`), além de operadores lógicos e subconsultas (`EXISTS`, `ANY/SOME`, `ALL`, `IN`).
- **Lógica de Negócio no SGBD:**
  - **3 Visões (`VIEWs`):** Para simplificar relatórios de empréstimos pendentes, catálogo público e disponibilidade de exemplares.
  - **3 Procedimentos/Funções (`PROCEDURES/FUNCTIONS`):** Utilizando estruturas de repetição (`WHILE`) e condicionais (`IF`, `CASE WHEN`) para classificação de obras, registro de devoluções e geração automática de cópias físicas (exemplares) no acervo.
  - **3 Gatilhos (`TRIGGERs`):** Para auditoria e garantia de integridade em eventos de `INSERT`, `UPDATE` e `DELETE` (ex: bloqueio de exclusão de livros com exemplares ativos).
- **Controle de Acesso (DCL):** Criação de múltiplos níveis de usuários (Bibliotecário e Estagiário) com concessão (`GRANT`) e revogação (`REVOKE`) de privilégios específicos.

### 🌐 2. Interface Web (PHP)
Um CRUD completo focado na entidade **Livro**, construído para ser visualmente intuitivo e seguro:
- **Estante Digital (CSS):** Exibição interativa do acervo simulando uma estante de madeira real com lombadas de livros geradas dinamicamente.
- **Formulário Imersivo:** Telas de inclusão e edição desenhadas como páginas de um livro aberto.
- **Segurança & UX:** Prevenção contra *SQL Injection*, tratamento amigável de erros de Foreign Key/Unique Key via bloco `try...catch` com alertas dinâmicos (JavaScript) no front-end, e carregamento automático de entidades relacionadas (Editoras) via banco de dados (`<select>` dinâmico).

---

## 🛠️ Como Executar o Projeto

### Pré-requisitos
- Um servidor Web local com suporte a PHP e MySQL/MariaDB (ex: **XAMPP**, **WAMP**, **Laragon**).

### Passos para Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/gustakakkoii/GCC263-sistema-biblioteca
```

2. **Configuração do Banco de Dados:**
* Abra o seu gerenciador de banco de dados (ex: MySQL Workbench, phpMyAdmin, HeidiSQL).
* Execute o arquivo `script_biblioteca.sql` (encontrado na raiz do projeto). Ele se encarregará de criar o banco `bibliotecasaberlivre`, estruturar todas as tabelas, inserir os dados e criar os usuários e lógicas internas.


3. **Configuração da Conexão Web:**
* Mova os arquivos `.php` e `.css` para a pasta pública do seu servidor local (ex: pasta `htdocs` no XAMPP ou `www` no Laragon).
* Abra o arquivo `config.php` e altere os dados de conexão de acordo com o seu ambiente local:
```php
$host = "127.0.0.1";
$login = "root";       // Seu usuário do banco
$senha = "";           // Sua senha do banco
$bd = "bibliotecasaberlivre";

```




4. **Acesso:**
* Abra o navegador e acesse: `http://localhost/sua-pasta-do-projeto/index.php`.



---

## 📁 Estrutura de Arquivos

```text
📦 raiz-do-projeto
 ┣ 📜 script_biblioteca.sql  # Script completo de DDL, DML e lógicas avançadas do banco.
 ┣ 📜 config.php             # Arquivo de conexão entre o PHP e o banco de dados.
 ┣ 📜 index.php              # Interface principal (Estante visual e lista de livros).
 ┣ 📜 form_livro.php         # Formulário (UI estilo livro) para inserção/edição.
 ┣ 📜 incluir_livro.php      # Lógica de processamento (INSERT/UPDATE) com tratamento de exceções.
 ┣ 📜 excluir_livro.php      # Lógica de exclusão com tratamento de falha por Trigger.
 ┗ 📜 style_estante.css      # Folha de estilos contendo o design da biblioteca e animações 3D.

```

---

## 👥 Equipe Desenvolvedora

* **Arthur Valadares Campideli** - [GitHub](https://github.com/link)
* **Gabriel Pirassoli Mendonca Pereira Vale** - [GitHub](https://github.com/link)
* **Gustavo Costa Almeida** - [GitHub](https://github.com/gustakakkoii)
* **Luiz Felipe Sanches Guimarães** - [GitHub](https://github.com/link)
* **Raphaela Lima Conti** - [GitHub](https://github.com/link)
