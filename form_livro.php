<?php
header("Content-Type: text/html; charset=utf-8", true);
include("./config.php");

$con = mysqli_connect($host, $login, $senha, $bd);

// Verifica se está editando ou criando um novo
$isEditando = isset($_GET["isbn"]);
$vetor = [];
$autor_selecionado = "";
$genero_selecionado = "";

// Se for edição, busca os dados do livro usando uma ÚNICA consulta com JOIN
if ($isEditando) {
    $isbn_busca = mysqli_real_escape_string($con, $_GET['isbn']);

    // Consulta otimizada trazendo o livro, o autor e o gênero de uma vez só
    $sql = "
        SELECT 
            l.*, 
            la.Autor_cpf, 
            lg.Genero_nome 
        FROM livro l
        LEFT JOIN livro_autor la ON l.isbn = la.Livro_isbn
        LEFT JOIN livro_genero lg ON l.isbn = lg.Livro_isbn
        WHERE l.isbn = '$isbn_busca'
        LIMIT 1
    ";

    $result = mysqli_query($con, $sql);

    if ($result && mysqli_num_rows($result) > 0) {
        $vetor = mysqli_fetch_array($result, MYSQLI_ASSOC);
        // Separa as chaves para facilitar a marcação no HTML
        $autor_selecionado = $vetor['Autor_cpf'];
        $genero_selecionado = $vetor['Genero_nome'];
    }
}
?>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <title><?php echo $isEditando ? "Editar Livro" : "Cadastrar Livro"; ?></title>
    <link rel="stylesheet" href="style.css">
</head>

<body id="body">

    <div class="form-container">
        <h2><?php echo $isEditando ? "Editar Livro" : "Novo Livro"; ?></h2>

        <form name="form1" method="POST" action="incluir_livro.php">

            <?php if ($isEditando && !empty($vetor['isbn'])): ?>
                <input type="hidden" name="isbn_antigo" value="<?php echo htmlspecialchars($vetor['isbn'], ENT_QUOTES); ?>">
            <?php endif; ?>

            <label for="titulo">Título do Livro:</label>
            <input type="text" name="titulo" id="titulo" value="<?php echo htmlspecialchars(@$vetor['titulo'], ENT_QUOTES); ?>" maxlength="100" required>

            <label for="ano">Ano de Publicação:</label>
            <input type="number" name="ano" id="ano" value="<?php echo htmlspecialchars(@$vetor['anoPublicacao'], ENT_QUOTES); ?>" required>

            <label for="isbn">ISBN:</label>
            <input type="text" name="isbn" id="isbn" value="<?php echo htmlspecialchars(@$vetor['isbn'], ENT_QUOTES); ?>" maxlength="13" required>

            <label for="editora_cnpj">Editora:</label>
            <select name="editora_cnpj" id="editora_cnpj" required>
                <option value="">Selecione uma editora...</option>
                <?php
                $sql_editoras = "SELECT cnpj, nomeFantasia FROM editora ORDER BY nomeFantasia";
                $result_editoras = mysqli_query($con, $sql_editoras);
                while ($ed = mysqli_fetch_assoc($result_editoras)) {
                    $selected = (@$vetor['Editora_cnpj'] == $ed['cnpj']) ? "selected" : "";
                    echo "<option value='{$ed['cnpj']}' {$selected}>{$ed['nomeFantasia']} ({$ed['cnpj']})</option>";
                }
                ?>
            </select>

            <label for="autor_cpf">Autor:</label>
            <select name="autor_cpf" id="autor_cpf">
                <option value="">Selecione um autor...</option>
                <?php
                $sql_autores = "SELECT cpfAutor, nome FROM autor ORDER BY nome";
                $result_autores = mysqli_query($con, $sql_autores);
                while ($aut = mysqli_fetch_assoc($result_autores)) {
                    $selected = ($autor_selecionado == $aut['cpfAutor']) ? "selected" : "";
                    echo "<option value='{$aut['cpfAutor']}' {$selected}>{$aut['nome']}</option>";
                }
                ?>
            </select>

            <label for="genero_nome">Gênero:</label>
            <select name="genero_nome" id="genero_nome">
                <option value="">Selecione um gênero...</option>
                <?php
                $sql_generos = "SELECT nome FROM genero ORDER BY nome";
                $result_generos = mysqli_query($con, $sql_generos);
                while ($gen = mysqli_fetch_assoc($result_generos)) {
                    $selected = ($genero_selecionado == $gen['nome']) ? "selected" : "";
                    echo "<option value='{$gen['nome']}' {$selected}>{$gen['nome']}</option>";
                }
                ?>
            </select>

            <div class="botoes">
                <button type="button" class="btn-cancelar" onclick="location.href='index.php'">Cancelar</button>
                <button type="submit" class="btn-gravar">Gravar Livro</button>
            </div>

        </form>
    </div>

</body>

</html>
<?php mysqli_close($con); ?>