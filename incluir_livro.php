<?php
include("./config.php");
$con = mysqli_connect($host, $login, $senha, $bd);

$isbn_novo = $_POST["isbn"];
$titulo = $_POST["titulo"];
$ano = $_POST["ano"];
$editora = $_POST["editora_cnpj"];

// Verifica se veio de uma edição (tem o isbn_antigo escondido no form)
if (isset($_POST["isbn_antigo"]) && !empty($_POST["isbn_antigo"])) {
    $isbn_antigo = $_POST["isbn_antigo"];
    $sql = "UPDATE livro SET isbn='$isbn_novo', titulo='$titulo', anoPublicacao=$ano, Editora_cnpj='$editora' WHERE isbn='$isbn_antigo'";
} else {
    // Se não tem isbn_antigo, é um cadastro novo
    $sql = "INSERT INTO livro (isbn, titulo, anoPublicacao, Editora_cnpj) VALUES ('$isbn_novo', '$titulo', $ano, '$editora')";
}

mysqli_query($con, $sql);
mysqli_close($con);

// Redireciona de volta para a estante
header("location: ./index.php");
