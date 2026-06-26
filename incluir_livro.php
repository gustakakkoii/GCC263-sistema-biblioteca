<?php
include("./config.php");

// Habilita o lançamento de exceções para tratar erros no catch
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $con = mysqli_connect($host, $login, $senha, $bd);

    // 1. Recebe todos os dados do formulário e protege contra SQL Injection
    $isbn_novo = mysqli_real_escape_string($con, $_POST["isbn"]);
    $titulo    = mysqli_real_escape_string($con, $_POST["titulo"]);
    $ano       = (int)$_POST["ano"];
    $editora   = mysqli_real_escape_string($con, $_POST["editora_cnpj"]);
    $autor     = mysqli_real_escape_string($con, $_POST["autor_cpf"]);
    $genero    = mysqli_real_escape_string($con, $_POST["genero_nome"]);

    // 2. Verifica se é uma EDIÇÃO ou um CADASTRO NOVO
    if (isset($_POST["isbn_antigo"]) && !empty($_POST["isbn_antigo"])) {
        $isbn_antigo = mysqli_real_escape_string($con, $_POST["isbn_antigo"]);

        // Atualiza a tabela principal do livro
        $sql_livro = "UPDATE livro SET isbn='$isbn_novo', titulo='$titulo', anoPublicacao=$ano, Editora_cnpj='$editora' WHERE isbn='$isbn_antigo'";
        mysqli_query($con, $sql_livro);

        // Atualiza a tabela associativa de autor
        // (Buscamos pelo isbn_novo assumindo que, se o ISBN mudou, o banco atualizou as tabelas filhas automaticamente via CASCADE)
        $sql_autor = "UPDATE livro_autor SET Autor_cpf='$autor' WHERE Livro_isbn='$isbn_novo'";
        mysqli_query($con, $sql_autor);

        // Atualiza a tabela associativa de gênero
        $sql_genero = "UPDATE livro_genero SET Genero_nome='$genero' WHERE Livro_isbn='$isbn_novo'";
        mysqli_query($con, $sql_genero);
    } else {
        // Insere na tabela principal do livro
        $sql_livro = "INSERT INTO livro (isbn, titulo, anoPublicacao, Editora_cnpj) VALUES ('$isbn_novo', '$titulo', $ano, '$editora')";
        mysqli_query($con, $sql_livro);

        // Insere na tabela associativa de autor
        $sql_autor = "INSERT INTO livro_autor (Livro_isbn, Autor_cpf) VALUES ('$isbn_novo', '$autor')";
        mysqli_query($con, $sql_autor);

        // Insere na tabela associativa de gênero
        $sql_genero = "INSERT INTO livro_genero (Livro_isbn, Genero_nome) VALUES ('$isbn_novo', '$genero')";
        mysqli_query($con, $sql_genero);
    }

    mysqli_close($con);

    // Se tudo deu certo, volta para a tela inicial
    header("location: ./index.php");
} catch (mysqli_sql_exception $e) {
    // Captura qualquer erro do banco (ex: ISBN duplicado) e mostra na tela
    $msgErro = str_replace(array("'", "\""), "", $e->getMessage());

    echo "<script>
            alert('Atenção: $msgErro');
            window.history.back();
          </script>";
}
