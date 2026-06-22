<?php
include("./config.php");

try {
    $con = mysqli_connect($host, $login, $senha, $bd);

    // Pega o ISBN passado pela URL e protege contra SQL Injection
    $isbn = mysqli_real_escape_string($con, $_GET["isbn"]);

    $sql = "DELETE FROM livro WHERE isbn='$isbn'";

    // Tenta executar a exclusão
    mysqli_query($con, $sql);
    mysqli_close($con);

    // Se der tudo certo, volta para a página principal
    header("location: ./index.php");
} catch (mysqli_sql_exception $e) {
    // Se o banco barrar (ex: pelo nosso Trigger), ele cai aqui no catch

    // Pega a mensagem gerada pelo banco/trigger e limpa as aspas para não quebrar o JS
    $msgErro = str_replace(array("'", "\""), "", $e->getMessage());

    // Mostra o alerta na tela e redireciona de volta para o index
    echo "<script>
            alert('Atenção: $msgErro');
            window.location.href = 'index.php';
          </script>";
}
