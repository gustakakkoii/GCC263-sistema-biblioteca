<?php
header("Content-Type: text/html; charset=utf-8", true);
include("./config.php");
$con = mysqli_connect($host, $login, $senha, $bd);
?>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <title>Incluir/Editar Livro</title>
    <link rel="stylesheet" href="style_estante.css">
</head>

<body>
    <?php
    $isEditando = isset($_GET["isbn"]);
    $vetor = [];

    if ($isEditando) {
        $isbn_busca = mysqli_real_escape_string($con, $_GET['isbn']);
        $sql = "SELECT * FROM livro WHERE isbn = '$isbn_busca'";
        $result = mysqli_query($con, $sql);

        if ($result && mysqli_num_rows($result) > 0) {
            $vetor = mysqli_fetch_array($result, MYSQLI_ASSOC);
        }
    }
    ?>

    <form name="form1" method="POST" action="incluir_livro.php">

        <?php if ($isEditando && !empty($vetor['isbn'])): ?>
            <input type="hidden" name="isbn_antigo" value="<?php echo htmlspecialchars($vetor['isbn'], ENT_QUOTES); ?>">
        <?php endif; ?>

        <div class="livro-aberto estatico">

            <div class="modal-capa c4">
                <div class="capa-borda"></div>
                <div class="modal-capa-titulo">
                    <?php echo $isEditando ? "Editando<br>Obra" : "Nova<br>Obra"; ?>
                </div>
                <div class="modal-capa-rodape">Saber Livre</div>
            </div>

            <div class="pagina-esq">
                <div>
                    <p class="pagina-ficha">Ficha de Cadastro</p>
                    <div class="titulo-form">
                        <?php echo $isEditando ? "Editar Livro Existente" : "Cadastrar Novo Livro"; ?>
                    </div>

                    <div class="pagina-campo">
                        <span class="pagina-label">Título do Livro:</span>
                        <input type="text" name="titulo" class="input-estilo" value="<?php echo htmlspecialchars(@$vetor['titulo'], ENT_QUOTES); ?>" maxlength="100" required placeholder="Ex: Memórias Póstumas...">
                    </div>

                    <div class="pagina-campo">
                        <span class="pagina-label">Ano de Publicação:</span>
                        <input type="number" name="ano" class="input-estilo" value="<?php echo htmlspecialchars(@$vetor['anoPublicacao'], ENT_QUOTES); ?>" required placeholder="Ex: 1881">
                    </div>
                </div>
                <div class="pagina-esq-num">1</div>
            </div>

            <div class="pagina-dir">
                <div>
                    <div class="pagina-campo">
                        <span class="pagina-label">ISBN:</span>
                        <input type="text" name="isbn" class="input-estilo" value="<?php echo htmlspecialchars(@$vetor['isbn'], ENT_QUOTES); ?>" maxlength="13" required placeholder="Ex: 9788535914849">
                    </div>

                    <div class="pagina-campo">
                        <span class="pagina-label">Editora:</span>
                        <select name="editora_cnpj" class="input-estilo" required>
                            <option value="">Selecione uma editora...</option>
                            <?php
                            $sql_editoras = "SELECT cnpj, nomeFantasia FROM editora ORDER BY nomeFantasia";
                            $result_editoras = mysqli_query($con, $sql_editoras);

                            while ($ed = mysqli_fetch_assoc($result_editoras)) {
                                // Seleciona automaticamente se estiver editando
                                $selected = (@$vetor['Editora_cnpj'] == $ed['cnpj']) ? "selected" : "";
                                echo "<option value='{$ed['cnpj']}' {$selected}>{$ed['nomeFantasia']} ({$ed['cnpj']})</option>";
                            }
                            ?>
                        </select>
                    </div>
                </div>

                <div class="pagina-linhas" style="margin-top: 40px; opacity: 0.4;">
                    <div class="linha-texto longa"></div>
                    <div class="linha-texto media"></div>
                    <div class="linha-texto curta"></div>
                    <div class="linha-texto longa"></div>
                </div>

                <div class="modal-acoes">
                    <button type="button" class="btn btn-danger" onclick="location.href='index.php'">Cancelar</button>
                    <button type="submit" class="btn-gravar">✔ Gravar Livro</button>
                </div>
            </div>

        </div>
    </form>
</body>

</html>
<?php mysqli_close($con); ?>