<?php header("Content-Type: text/html; charset=utf-8", true); ?>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Saber Livre — Acervo</title>
  <link rel="stylesheet" href="style_estante.css">
</head>

<body>

  <p class="biblioteca-titulo">Acervo · Biblioteca Saber Livre</p>

  <div class="estante-container">
    <?php
    include("./config.php");
    $con = mysqli_connect($host, $login, $senha, $bd);

    // Consulta atualizada com LEFT JOIN e GROUP_CONCAT para agrupar autores e gêneros
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
      echo "<div class='estante-vazia'>Nenhum livro na estante ainda.</div>";
    } else {
      $livros = [];
      while ($livro = mysqli_fetch_assoc($resultado)) {
        $livros[] = $livro;
      }

      $cores        = ['c0', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7'];
      $alturas      = [118, 105, 130, 112, 122, 100, 125, 108];
      $larguras     = [36, 38, 34, 40, 32, 42, 36, 38];
      $por_prateleira = 16;
      $total          = count($livros);
      $prateleiras    = ceil($total / $por_prateleira);

      for ($p = 0; $p < $prateleiras; $p++) {
        $inicio = $p * $por_prateleira;
        $fatia  = array_slice($livros, $inicio, $por_prateleira);

        echo "<div class='prateleira-wrap'>";
        echo "<div class='prateleira-livros'>";

        foreach ($fatia as $i => $livro) {
          $idx     = $inicio + $i;
          $cor     = $cores[$idx % count($cores)];
          $alt     = $alturas[$idx % count($alturas)];
          $larg    = $larguras[$idx % count($larguras)];

          // Preparando todas as variáveis
          $isbn    = addslashes(htmlspecialchars($livro['isbn'],          ENT_QUOTES));
          $titulo  = addslashes(htmlspecialchars($livro['titulo'],        ENT_QUOTES));
          $ano     = addslashes(htmlspecialchars($livro['anoPublicacao'], ENT_QUOTES));
          $nomeeditora = addslashes(htmlspecialchars($livro['nomeFantasia'],  ENT_QUOTES));
          $cnpjeditora = addslashes(htmlspecialchars($livro['Editora_cnpj'],  ENT_QUOTES));
          $sobre = addslashes(htmlspecialchars($livro['sobre'],  ENT_QUOTES));
          $autores = addslashes(htmlspecialchars($livro['autores'] ? $livro['autores'] : 'Não informado', ENT_QUOTES));
          $generos = addslashes(htmlspecialchars($livro['generos'] ? $livro['generos'] : 'Não informado', ENT_QUOTES));

          // Passando as variáveis para a função abrirModal
          echo "<div class='livro' style='width:{$larg}px'
                     onclick=\"abrirModal('{$isbn}','{$titulo}','{$ano}','{$nomeeditora}','{$cnpjeditora}','{$cor}','{$autores}','{$generos}','{$sobre}')\">";
          echo "  <div class='livro-corpo {$cor}' style='height:{$alt}px;width:{$larg}px'>";
          echo "    <div class='livro-lombada'></div>";
          echo     htmlspecialchars($livro['titulo']);
          echo "  </div>";
          echo "  <div class='livro-sombra'></div>";
          echo "</div>";
        }

        echo "</div>"; // .prateleira-livros
        echo "<div class='tabua'></div>";
        echo "</div>"; // .prateleira-wrap
      }
    }

    mysqli_close($con);
    ?>
  </div>

  <div class="modal-overlay" id="modal-overlay">
    <div class="livro-aberto" id="livro-aberto" role="dialog" aria-modal="true" aria-labelledby="info-titulo">

      <button class="modal-fechar" id="btn-fechar" aria-label="Fechar">×</button>

      <div class="modal-capa" id="modal-capa">
        <div class="capa-borda"></div>
        <div class="modal-capa-titulo" id="modal-capa-titulo"></div>
        <div class="modal-capa-rodape">Saber Livre</div>
      </div>

      <div class="pagina-esq">
        <div>
          <p class="pagina-ficha">Ficha catalográfica</p>
          <p id="info-titulo">Título do Livro</p>

          <div class="pagina-campo">
            <span class="pagina-label">Autor(es)</span>
            <span class="pagina-valor" id="info-autores">—</span>
          </div>
          <div class="pagina-campo">
            <span class="pagina-label">Sobre o(s) autor(es)</span>
            <span class="pagina-valor" id="info-sobre">—</span>
          </div>
          <div class="pagina-campo">
            <span class="pagina-label">Gênero(s)</span>
            <span class="pagina-valor" id="info-generos">—</span>
          </div>
          <div class="pagina-campo">
            <span class="pagina-label">Editora (Nome)</span>
            <span class="pagina-valor" id="info-nome-editora">—</span>
          </div>
          <div class="pagina-campo">
            <span class="pagina-label">Editora (CNPJ)</span>
            <span class="pagina-valor" id="info-cnpj-editora">—</span>
          </div>
        </div>
        <div class="pagina-esq-num">i</div>
      </div>

      <div class="pagina-dir">
        <div>
          <div class="pagina-campo">
            <span class="pagina-label">ISBN</span>
            <span class="pagina-valor" id="info-isbn">—</span>
          </div>
          <div class="pagina-campo">
            <span class="pagina-label">Ano de publicação</span>
            <span class="pagina-valor" id="info-ano">—</span>
          </div>
        </div>
        <div class="pagina-linhas">
          <div class="linha-texto longa"></div>
          <div class="linha-texto media"></div>
          <div class="linha-texto longa"></div>
          <div class="linha-texto curta"></div>
          <div class="linha-texto longa"></div>
          <div class="linha-texto media"></div>
          <div class="linha-texto tiny"></div>
          <div class="linha-texto longa"></div>
          <div class="linha-texto curta"></div>
          <div class="linha-texto media"></div>
          <div class="linha-texto longa"></div>
          <div class="linha-texto tiny"></div>
          <div class="linha-texto longa"></div>
        </div>

        <div class="modal-acoes">
          <a id="btn-editar" class="btn btn-editar" href="#">Editar livro</a>
          <a id="btn-excluir" class="btn btn-danger" href="#"
            onclick="return confirm('Tem certeza que deseja excluir este livro?');">Excluir livro</a>
        </div>
      </div>

    </div>
  </div>

  <div class="rodape-acoes">
    <a href="form_livro.php" class="btn btn-cadastrar">+ Cadastrar novo livro</a>
  </div>

  <script>
    // Atualizado para receber os parâmetros de autores e generos
    function abrirModal(isbn, titulo, ano, nomeditora, cnpjeditora, cor, autores, generos, sobreAutores) {
      document.getElementById('info-titulo').textContent = titulo;
      document.getElementById('info-autores').textContent = autores || '—';
      document.getElementById('info-sobre').textContent = sobreAutores || '—';
      document.getElementById('info-generos').textContent = generos || '—';
      document.getElementById('info-nome-editora').textContent = nomeditora || '—';
      document.getElementById('info-cnpj-editora').textContent = cnpjeditora || '—';

      // Inserindo os novos campos
      document.getElementById('info-isbn').textContent = isbn || '—';
      document.getElementById('info-ano').textContent = ano || '—';

      document.getElementById('modal-capa-titulo').textContent = titulo;

      const capa = document.getElementById('modal-capa');
      capa.className = 'modal-capa ' + cor;

      document.getElementById('btn-editar').href = 'form_livro.php?isbn=' + encodeURIComponent(isbn);
      document.getElementById('btn-excluir').href = 'excluir_livro.php?isbn=' + encodeURIComponent(isbn);

      const el = document.getElementById('livro-aberto');
      el.classList.remove('animando');
      void el.offsetWidth;
      el.classList.add('animando');

      document.getElementById('modal-overlay').classList.add('ativo');
    }

    function fecharModal(e) {
      if (e && e.target !== document.getElementById('modal-overlay')) return;
      document.getElementById('modal-overlay').classList.remove('ativo');
    }

    document.getElementById('btn-fechar').addEventListener('click', () =>
      document.getElementById('modal-overlay').classList.remove('ativo')
    );

    document.getElementById('modal-overlay').addEventListener('click', fecharModal);

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape')
        document.getElementById('modal-overlay').classList.remove('ativo');
    });
  </script>

</body>

</html>