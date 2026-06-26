<?php
header("Content-Type: text/html; charset=utf-8", true);
include("./config.php");
$con = mysqli_connect($host, $login, $senha, $bd);
?>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Saber Livre — Acervo</title>
  <link rel="stylesheet" href="style.css">
</head>

<body>

  <h2>Acervo · Biblioteca Saber Livre</h2>

  <a href="form_livro.php" class="btn-novo">+ Cadastrar novo livro</a>

  <?php
  // Consulta SQL
  $sql = "
        SELECT 
            l.isbn, 
            l.titulo, 
            l.anoPublicacao, 
            l.Editora_cnpj,
            ed.nomeFantasia,
            GROUP_CONCAT(DISTINCT a.nome SEPARATOR ', ') AS autores,
            GROUP_CONCAT(DISTINCT a.sobre SEPARATOR ' | ') AS sobre,
            GROUP_CONCAT(DISTINCT lg.Genero_nome SEPARATOR ', ') AS generos
        FROM livro l
        LEFT JOIN livro_autor la ON l.isbn = la.Livro_isbn
        LEFT JOIN autor a ON la.Autor_cpf = a.cpfAutor
        LEFT JOIN livro_genero lg ON l.isbn = lg.Livro_isbn
        LEFT JOIN editora ed ON l.Editora_cnpj = ed.cnpj
        GROUP BY 
            l.isbn, 
            l.titulo, 
            l.anoPublicacao, 
            l.Editora_cnpj, 
            ed.nomeFantasia
        ORDER BY l.titulo
    ";

  $resultado = mysqli_query($con, $sql);

  if (mysqli_num_rows($resultado) == 0) {
    echo "<p>Nenhum livro na estante ainda.</p>";
  } else {
    // Cria o cabeçalho da tabela HTML
    echo "<table>";
    echo "<thead>
                <tr>
                    <th>ISBN</th>
                    <th>Título</th>
                    <th>Ano</th>
                    <th>Editora</th>
                    <th>Autor(es)</th>
                    <th>Gênero(s)</th>
                    <th>Ações</th>
                </tr>
              </thead>";
    echo "<tbody>";

    // Laço de repetição percorrendo os dados do banco
    while ($livro = mysqli_fetch_assoc($resultado)) {

      // Tratamento básico para evitar campos vazios na tela
      $autores = $livro['autores'] ? $livro['autores'] : 'Não informado';
      $generos = $livro['generos'] ? $livro['generos'] : 'Não informado';
      $editora = $livro['nomeFantasia'] ? $livro['nomeFantasia'] : 'Não informada';

      // Monta a linha da tabela (<tr>) com as colunas (<td>)
      echo "<tr>";
      echo "<td>" . htmlspecialchars($livro['isbn']) . "</td>";
      echo "<td>" . htmlspecialchars($livro['titulo']) . "</td>";
      echo "<td>" . htmlspecialchars($livro['anoPublicacao']) . "</td>";
      echo "<td>" . htmlspecialchars($editora) . "</td>";
      echo "<td>" . htmlspecialchars($autores) . "</td>";
      echo "<td>" . htmlspecialchars($generos) . "</td>";

      // Coluna de Ações (Editar e Excluir) passando o ISBN via URL (GET)
      echo "<td>
                    <a href='form_livro.php?isbn={$livro['isbn']}' class='acao-editar'>Editar</a>
                    <a href='excluir_livro.php?isbn={$livro['isbn']}' class='acao-excluir' onclick=\"return confirm('Tem certeza que deseja excluir o livro: {$livro['titulo']}?');\">Excluir</a>
                  </td>";
      echo "</tr>";
    }

    echo "</tbody>";
    echo "</table>";
  }

  mysqli_close($con);
  ?>

</body>

</html>