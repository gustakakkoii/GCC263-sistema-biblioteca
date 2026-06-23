-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET FOREIGN_KEY_CHECKS = 1;

CREATE SCHEMA IF NOT EXISTS `bibliotecasaberlivre` DEFAULT CHARACTER SET utf8mb4 ;
USE `bibliotecasaberlivre` ;

-- ==============================================================================
-- (a) Criação de todas as tabelas e restrições de integridade.
-- ==============================================================================

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`autor` (
  `cpfAutor` CHAR(11) NOT NULL,
  `nome` VARCHAR(80) NOT NULL,
  `sobre` VARCHAR(150) DEFAULT 'Biografia não informada', 
  PRIMARY KEY (`cpfAutor`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`editora` (
  `cnpj` CHAR(14) NOT NULL,
  `nomeFantasia` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`cnpj`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`usuario` (
  `cpf` CHAR(11) NOT NULL,
  `nome` VARCHAR(80) NOT NULL,
  `email` VARCHAR(80) NOT NULL UNIQUE, 
  PRIMARY KEY (`cpf`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`emprestimo` (
  `protocolo` INT(11) NOT NULL,
  `dataRetirada` DATE NOT NULL,
  `dataLimite` DATE NOT NULL,
  `dataEntrega` DATE NULL DEFAULT NULL,
  `Usuario_cpf` CHAR(11) NOT NULL,
  PRIMARY KEY (`protocolo`),
  INDEX `fk_emprestimo_usuario` (`Usuario_cpf` ASC),
  CONSTRAINT `fk_emprestimo_usuario`
    FOREIGN KEY (`Usuario_cpf`) REFERENCES `bibliotecasaberlivre`.`usuario` (`cpf`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`livro` (
  `isbn` CHAR(13) NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `anoPublicacao` INT(11) NOT NULL,
  `Editora_cnpj` CHAR(14) NOT NULL,
  PRIMARY KEY (`isbn`),
  INDEX `fk_livro_editora` (`Editora_cnpj` ASC),
  CONSTRAINT `fk_livro_editora`
    FOREIGN KEY (`Editora_cnpj`) REFERENCES `bibliotecasaberlivre`.`editora` (`cnpj`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`exemplar` (
  `codigo` INT(11) NOT NULL,
  `localizacao` VARCHAR(50) NOT NULL,
  `status` CHAR(1) NOT NULL,
  `Livro_isbn` CHAR(13) NOT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_exemplar_livro` (`Livro_isbn` ASC),
  CONSTRAINT `fk_exemplar_livro`
    FOREIGN KEY (`Livro_isbn`) REFERENCES `bibliotecasaberlivre`.`livro` (`isbn`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`genero` (
  `nome` VARCHAR(50) NOT NULL,
  `descricao` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`nome`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`item_emprestimo` (
  `Emprestimo_prot` INT(11) NOT NULL,
  `Exemplar_codigo` INT(11) NOT NULL,
  PRIMARY KEY (`Emprestimo_prot`, `Exemplar_codigo`),
  INDEX `fk_ie_exemplar` (`Exemplar_codigo` ASC),
  CONSTRAINT `fk_ie_emprestimo`
    FOREIGN KEY (`Emprestimo_prot`) REFERENCES `bibliotecasaberlivre`.`emprestimo` (`protocolo`) ON DELETE CASCADE,
  CONSTRAINT `fk_ie_exemplar`
    FOREIGN KEY (`Exemplar_codigo`) REFERENCES `bibliotecasaberlivre`.`exemplar` (`codigo`))
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`livro_autor` (
  `Livro_isbn` CHAR(13) NOT NULL,
  `Autor_cpf` CHAR(11) NOT NULL,
  PRIMARY KEY (`Livro_isbn`, `Autor_cpf`),
  INDEX `fk_la_autor` (`Autor_cpf` ASC),
  CONSTRAINT `fk_la_autor`
    FOREIGN KEY (`Autor_cpf`) REFERENCES `bibliotecasaberlivre`.`autor` (`cpfAutor`) ON DELETE CASCADE,
  CONSTRAINT `fk_la_livro`
    FOREIGN KEY (`Livro_isbn`) REFERENCES `bibliotecasaberlivre`.`livro` (`isbn`) ON DELETE CASCADE)
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`livro_genero` (
  `Livro_isbn` CHAR(13) NOT NULL,
  `Genero_nome` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Livro_isbn`, `Genero_nome`),
  INDEX `fk_lg_genero` (`Genero_nome` ASC),
  CONSTRAINT `fk_lg_genero`
    FOREIGN KEY (`Genero_nome`) REFERENCES `bibliotecasaberlivre`.`genero` (`nome`) ON DELETE CASCADE,
  CONSTRAINT `fk_lg_livro`
    FOREIGN KEY (`Livro_isbn`) REFERENCES `bibliotecasaberlivre`.`livro` (`isbn`) ON DELETE CASCADE)
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `bibliotecasaberlivre`.`telefone_usuario` (
  `Usuario_cpf` CHAR(11) NOT NULL,
  `telefone` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Usuario_cpf`, `telefone`),
  CONSTRAINT `fk_tel_usuario`
    FOREIGN KEY (`Usuario_cpf`) REFERENCES `bibliotecasaberlivre`.`usuario` (`cpf`) ON DELETE CASCADE)
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- ==============================================================================
-- (b) Exemplos de ALTER TABLE (3 exemplos) e DROP TABLE
-- Descrição: Altera colunas de tabelas existentes, cria uma tabela lixo e a apaga.
-- ==============================================================================
ALTER TABLE `usuario` ADD COLUMN `dataNascimento` DATE NULL;
ALTER TABLE `editora` ADD COLUMN `website` VARCHAR(100) NULL;
ALTER TABLE `livro` CHANGE COLUMN `titulo` `titulo` VARCHAR(120) NOT NULL;

CREATE TABLE IF NOT EXISTS `tabela_temporaria` (
  `id` INT PRIMARY KEY,
  `dado` VARCHAR(50)
);

DROP TABLE `tabela_temporaria`;


-- ==============================================================================
-- (c) Inserções de dados (pelo menos 5 em cada tabela)
-- ==============================================================================
INSERT INTO autor (cpfAutor, nome, sobre) VALUES 
('11111111111', 'Machado de Assis', 'Escritor brasileiro'),
('22222222222', 'J.R.R. Tolkien', 'Autor de fantasia'),
('33333333333', 'Clarice Lispector', 'Escritora ucraniana-brasileira'),
('44444444444', 'George Orwell', 'Escritor inglês'),
('55555555555', 'Isaac Asimov', 'Autor de ficção científica');

INSERT INTO editora (cnpj, nomeFantasia) VALUES 
('11111111000101', 'Companhia das Letras'),
('22222222000102', 'HarperCollins'),
('33333333000103', 'Rocco'),
('44444444000104', 'Aleph'),
('55555555000105', 'Intrínseca');

INSERT INTO usuario (cpf, nome, email, dataNascimento) VALUES 
('12345678901', 'Ana Silva', 'ana@ufla.br', '2000-05-10'),
('10987654321', 'Bruno Costa', 'bruno@ufla.br', '1999-08-22'),
('11122233344', 'Carlos Mendes', 'carlos@ufla.br', '2001-11-30'),
('55566677788', 'Diana Souza', 'diana@ufla.br', '1998-02-15'),
('99988877766', 'Elena Rios', 'elena@ufla.br', '2002-07-08');

INSERT INTO genero (nome, descricao) VALUES 
('Ficção Científica', 'Obras baseadas em conceitos científicos imaginários'),
('Fantasia', 'Obras que usam magia e outras formas sobrenaturais'),
('Romance', 'Narrativas longas de ficção'),
('Distopia', 'Sociedades imaginárias indesejáveis'),
('Biografia', 'História da vida de uma pessoa');

INSERT INTO livro (isbn, titulo, anoPublicacao, Editora_cnpj) VALUES 
('9788595084742', 'Vidas Secas', 1938, '11111111000101'),
('9788520923456', 'Grande Sertão: Veredas', 1956, '22222222000102'),
('9788535904567', 'O Cortiço', 1890, '33333333000103'),
('9788535915678', 'Capitães da Areia', 1937, '44444444000104'),
('9788571646789', 'Macunaíma', 1928, '11111111000101'),
('9788573267890', 'A Metamorfose', 1915, '22222222000102'),
('9788535928901', 'O Processo', 1925, '33333333000103'),
('9788535909012', 'Ensaio sobre a Cegueira', 1995, '44444444000104'),
('9788571100123', 'Orgulho e Preconceito', 1813, '11111111000101'),
('9788520911234', 'O Morro dos Ventos Uivantes', 1847, '22222222000102'),
('9788537802345', 'Jane Eyre', 1847, '33333333000103'),
('9788573263456', 'Frankenstein', 1818, '44444444000104'),
('9788537804567', 'Drácula', 1897, '11111111000101'),
('9788520915678', 'O Retrato de Dorian Gray', 1890, '22222222000102'),
('9788573266789', 'Crime e Castigo', 1866, '33333333000103'),
('9788573267891', 'Os Irmãos Karamázov', 1880, '44444444000104'),
('9788573268902', 'Anna Karenina', 1877, '11111111000101'),
('9788573269013', 'Guerra e Paz', 1869, '22222222000102'),
('9788573260124', 'Moby Dick', 1851, '33333333000103'),
('9788573261235', 'As Aventuras de Huckleberry Finn', 1884, '44444444000104'),
('9788535922345', 'O Grande Gatsby', 1925, '11111111000101'),
('9788532523456', 'O Apanhador no Campo de Centeio', 1951, '22222222000102'),
('9788520924567', 'O Sol é para Todos', 1960, '33333333000103'),
('9788532525678', 'O Conto da Aia', 1985, '44444444000104'),
('9788576571234', 'Duna', 1965, '11111111000101'),
('9788576572345', 'Neuromancer', 1984, '22222222000102'),
('9788576573456', 'Eu, Robô', 1950, '33333333000103'),
('9788599296493', 'O Guia do Mochileiro das Galáxias', 1979, '44444444000104'),
('9788539004567', 'A Bússola de Ouro', 1995, '11111111000101'),
('9788578270698', 'As Crônicas de Nárnia', 1950, '22222222000102'),
('9788598078175', 'Percy Jackson e o Ladrão de Raios', 2005, '33333333000103'),
('9788579800245', 'Jogos Vorazes', 2008, '44444444000104'),
('9788579801234', 'Divergente', 2011, '11111111000101'),
('9788580572261', 'A Culpa é das Estrelas', 2012, '22222222000102'),
('9788520917890', 'O Caçador de Pipas', 2003, '33333333000103'),
('9788598078168', 'A Menina que Roubava Livros', 2005, '44444444000104'),
('9788525432186', 'Sapiens: Uma Breve História da Humanidade', 2011, '11111111000101'),
('9788539004119', 'O Poder do Hábito', 2012, '22222222000102'),
('9788539003839', 'Rápido e Devagar', 2011, '33333333000103'),
('9788535217215', 'Pai Rico, Pai Pobre', 1997, '44444444000104');

INSERT INTO exemplar (codigo, localizacao, status, Livro_isbn) VALUES 
(1, 'Estante A1', 'D', '9788595084742'),
(2, 'Estante A1', 'E', '9788595084742'),
(3, 'Estante B2', 'D', '9788520923456'),
(4, 'Estante C3', 'E', '9788535915678'),
(5, 'Estante D4', 'D', '9788571646789'),
(6, 'Estante E5', 'D', '9788571100123');

INSERT INTO emprestimo (protocolo, dataRetirada, dataLimite, dataEntrega, Usuario_cpf) VALUES 
(101, '2026-06-01', '2026-06-15', '2026-06-10', '12345678901'),
(102, '2026-06-05', '2026-06-20', NULL, '10987654321'),
(103, '2026-06-10', '2026-06-25', NULL, '11122233344'),
(104, '2026-05-20', '2026-06-04', '2026-06-04', '55566677788'),
(105, '2026-06-15', '2026-06-30', NULL, '99988877766');

INSERT INTO item_emprestimo (Emprestimo_prot, Exemplar_codigo) VALUES 
(101, 1),
(102, 2),
(103, 4),
(104, 3),
(105, 5);

INSERT INTO livro_autor (Livro_isbn, Autor_cpf) VALUES 
('9788595084742', '11111111111'),
('9788520923456', '22222222222'),
('9788535915678', '33333333333'),
('9788571646789', '44444444444'),
('9788571100123', '55555555555');

INSERT INTO livro_genero (Livro_isbn, Genero_nome) VALUES 
('9788595084742', 'Romance'),
('9788520923456', 'Fantasia'),
('9788535915678', 'Distopia'),
('9788571646789', 'Ficção Científica'),
('9788571100123', 'Romance');

INSERT INTO telefone_usuario (Usuario_cpf, telefone) VALUES 
('12345678901', '35999991111'),
('10987654321', '35999992222'),
('11122233344', '35999993333'),
('55566677788', '35999994444'),
('99988877766', '35999995555');


-- ==============================================================================
-- (d) Modificação de dados em 5 tabelas (Pelo menos 1 UPDATE aninhado)
-- ==============================================================================
-- Descrição 1: Atualiza status do exemplar 1 para Indisponível (I).
UPDATE exemplar SET status = 'I' WHERE codigo = 1;

-- Descrição 2: Atualiza o website da editora 1.
UPDATE editora SET website = 'www.ciadasletras.com.br' WHERE cnpj = '11111111000101';

-- Descrição 3: Atualiza o email de um usuário específico.
UPDATE usuario SET email = 'ana.silva@estudante.ufla.br' WHERE cpf = '12345678901';

-- Descrição 4: Aumenta o limite de entrega em 5 dias para o empréstimo 102.
UPDATE emprestimo SET dataLimite = DATE_ADD(dataLimite, INTERVAL 5 DAY) WHERE protocolo = 102;

-- Descrição 5 (UPDATE ANINHADO): Atualiza a descrição de gênero 'Fantasia' para os livros que pertencem a editora 'HarperCollins'
UPDATE genero SET descricao = 'Fantasia (Alta Fantasia)' 
WHERE nome IN (
    SELECT Genero_nome FROM livro_genero lg 
    JOIN livro l ON lg.Livro_isbn = l.isbn 
    WHERE l.Editora_cnpj = '22222222000102'
);


-- ==============================================================================
-- (e) Exclusão de dados em 5 tabelas (Pelo menos 1 DELETE aninhado)
-- ==============================================================================
-- Descrição 1: Exclui um telefone do usuário.
DELETE FROM telefone_usuario WHERE telefone = '35999995555';

-- Descrição 2: Exclui o autor J.R.R. Tolkien (o CASCADE apagará em livro_autor).
-- (Criamos um autor fictício apenas para ser apagado e não quebrar as outras consultas)
INSERT INTO autor (cpfAutor, nome, sobre) VALUES ('00000000000', 'Autor Teste', 'Apagar');
DELETE FROM autor WHERE cpfAutor = '00000000000';

-- Descrição 3: Exclui um item de empréstimo devolvido.
DELETE FROM item_emprestimo WHERE Emprestimo_prot = 104;

-- Descrição 4: Exclui o empréstimo 104.
DELETE FROM emprestimo WHERE protocolo = 104;

-- Descrição 5 (DELETE ANINHADO): Exclui exemplares cujo livro foi publicado antes de 1830.
-- Isso apagará o exemplar 6 (Orgulho e Preconceito, de 1813), que não possui empréstimos pendentes.
DELETE FROM exemplar WHERE Livro_isbn IN (SELECT isbn FROM livro WHERE anoPublicacao < 1830);


-- ==============================================================================
-- (f) Consultas (F1 a F12 e operadores extras)
-- ==============================================================================
-- F1 (INNER JOIN): Recupera o título dos livros e o nome fantasia de suas editoras.
SELECT l.titulo, e.nomeFantasia 
FROM livro l 
INNER JOIN editora e ON l.Editora_cnpj = e.cnpj;

-- F2 (OUTER JOIN): Recupera o nome de todos os usuários, acompanhado dos protocolos de empréstimo (se houver).
SELECT u.nome, e.protocolo 
FROM usuario u 
LEFT OUTER JOIN emprestimo e ON u.cpf = e.Usuario_cpf;

-- F3 (ORDER BY): Recupera os livros ordenados por ano de publicação, do mais recente pro mais antigo.
SELECT titulo, anoPublicacao 
FROM livro 
ORDER BY anoPublicacao DESC;

-- F4 (GROUP BY): Conta quantos livros existem por editora.
SELECT Editora_cnpj, COUNT(isbn) AS total_livros 
FROM livro 
GROUP BY Editora_cnpj;

-- F5 (HAVING): Recupera os protocolos de empréstimo que possuem mais de 1 exemplar alugado.
SELECT Emprestimo_prot, COUNT(Exemplar_codigo) AS qtd_itens 
FROM item_emprestimo 
GROUP BY Emprestimo_prot 
HAVING COUNT(Exemplar_codigo) > 1;

-- F6 (UNION): Lista consolidada de nomes de Autores e nomes de Usuários para mala direta.
SELECT nome, 'Autor' AS tipo FROM autor 
UNION 
SELECT nome, 'Usuario' AS tipo FROM usuario;

-- F7 (IN): Recupera livros cujos anos de publicação são 1938 ou 1956.
SELECT titulo, anoPublicacao 
FROM livro 
WHERE anoPublicacao IN (1938, 1956);

-- F8 (LIKE): Recupera usuários que usam o email da UFLA.
SELECT nome, email 
FROM usuario 
WHERE email LIKE '%@ufla.br%';

-- F9 (IS NULL): Recupera os protocolos de empréstimos pendentes (não devolvidos).
SELECT protocolo, Usuario_cpf 
FROM emprestimo 
WHERE dataEntrega IS NULL;

-- F10 (ANY/SOME): Recupera livros mais novos que QUALQUER livro da editora Companhia das Letras (11111111000101).
SELECT titulo, anoPublicacao 
FROM livro 
WHERE anoPublicacao > ANY (SELECT anoPublicacao FROM livro WHERE Editora_cnpj = '11111111000101');

-- F11 (ALL): Recupera o livro mais antigo de todo o banco de dados.
SELECT titulo, anoPublicacao 
FROM livro 
WHERE anoPublicacao <= ALL (SELECT anoPublicacao FROM livro);

-- F12 (EXISTS): Recupera os usuários que já fizeram pelo menos um empréstimo.
SELECT nome 
FROM usuario u 
WHERE EXISTS (SELECT 1 FROM emprestimo e WHERE e.Usuario_cpf = u.cpf);

-- EXTRA (AND, OR, NOT, BETWEEN): Recupera livros publicados entre 1950 e 1980 que NÃO sejam da editora Intrínseca (55555555000105) OU que tenham o nome "Duna".
SELECT titulo 
FROM livro 
WHERE (anoPublicacao BETWEEN 1950 AND 1980 AND NOT Editora_cnpj = '55555555000105') 
   OR titulo = 'Duna';


-- ==============================================================================
-- (g) Criação e Uso de 3 Visões (Views)
-- ==============================================================================
-- Descrição 1: Visão para consultar livros pendentes de devolução e seus usuários.
CREATE VIEW v_emprestimos_pendentes AS
SELECT u.nome, u.email, e.protocolo, e.dataLimite 
FROM emprestimo e 
JOIN usuario u ON e.Usuario_cpf = u.cpf 
WHERE e.dataEntrega IS NULL;
-- Uso:
SELECT * FROM v_emprestimos_pendentes WHERE dataLimite < CURDATE();

-- Descrição 2: Visão do catálogo público de livros com autores e gêneros.
CREATE VIEW v_catalogo_publico AS
SELECT l.titulo, a.nome AS autor, g.nome AS genero
FROM livro l
JOIN livro_autor la ON l.isbn = la.Livro_isbn
JOIN autor a ON la.Autor_cpf = a.cpfAutor
JOIN livro_genero lg ON l.isbn = lg.Livro_isbn
JOIN genero g ON lg.Genero_nome = g.nome;
-- Uso:
SELECT titulo FROM v_catalogo_publico WHERE genero = 'Ficção Científica';

-- Descrição 3: Visão de disponibilidade de exemplares por livro.
CREATE VIEW v_disponibilidade_exemplares AS
SELECT l.titulo, COUNT(e.codigo) AS qtd_disponivel
FROM livro l
JOIN exemplar e ON l.isbn = e.Livro_isbn
WHERE e.status = 'D'
GROUP BY l.titulo;
-- Uso:
SELECT * FROM v_disponibilidade_exemplares ORDER BY qtd_disponivel DESC;


-- ==============================================================================
-- (h) Usuários, GRANT e REVOKE
-- ==============================================================================
-- Descrição: Cria o usuário bibliotecário (com direitos DML) e estagiário (apenas leitura das views).

-- Apaga os usuários caso eles já existam de execuções anteriores do script
DROP USER IF EXISTS 'bibliotecario'@'localhost';
DROP USER IF EXISTS 'estagiario'@'localhost';

-- Cria os usuários novamente do zero
CREATE USER 'bibliotecario'@'localhost' IDENTIFIED BY 'senha_forte123';
CREATE USER 'estagiario'@'localhost' IDENTIFIED BY 'estagio_2026';

-- Concede as permissões no nível do banco de dados (todas as tabelas)
GRANT SELECT, INSERT, UPDATE, DELETE ON bibliotecasaberlivre.* TO 'bibliotecario'@'localhost';
GRANT SELECT ON bibliotecasaberlivre.v_catalogo_publico TO 'estagiario'@'localhost';

-- Revoga a permissão de deletar dados de qualquer tabela para o bibliotecário
REVOKE DELETE ON bibliotecasaberlivre.* FROM 'bibliotecario'@'localhost';


-- ==============================================================================
-- (i) 3 Procedimentos/Funções (com IN/OUT, IF, CASE WHEN, WHILE)
-- ==============================================================================
DELIMITER $$

-- 1. Função com CASE WHEN: Classifica a obra como Clássica ou Contemporânea
CREATE FUNCTION fn_classifica_livro(ano INT) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE classificacao VARCHAR(20);
    CASE 
        WHEN ano < 1950 THEN SET classificacao = 'Clássico Histórico';
        WHEN ano BETWEEN 1950 AND 1999 THEN SET classificacao = 'Clássico Moderno';
        ELSE SET classificacao = 'Contemporâneo';
    END CASE;
    RETURN classificacao;
END$$

-- Teste 1:
SELECT titulo, fn_classifica_livro(anoPublicacao) AS tipo FROM livro;

-- 2. Procedimento com IF: Realiza baixa de devolução e atualiza status do exemplar
CREATE PROCEDURE pr_realizar_devolucao(IN p_protocolo INT, OUT p_msg VARCHAR(100))
BEGIN
    DECLARE v_status_entrega DATE;
    SELECT dataEntrega INTO v_status_entrega FROM emprestimo WHERE protocolo = p_protocolo;
    
    IF v_status_entrega IS NULL THEN
        UPDATE emprestimo SET dataEntrega = CURDATE() WHERE protocolo = p_protocolo;
        UPDATE exemplar SET status = 'D' 
        WHERE codigo IN (SELECT Exemplar_codigo FROM item_emprestimo WHERE Emprestimo_prot = p_protocolo);
        SET p_msg = 'Devolução registrada com sucesso.';
    ELSE
        SET p_msg = 'Erro: Este empréstimo já foi devolvido anteriormente.';
    END IF;
END$$

-- Teste 2:
CALL pr_realizar_devolucao(102, @mensagem); SELECT @mensagem;

-- 3. Procedimento com WHILE: Gera n cópias virtuais (exemplares) de um livro
CREATE PROCEDURE pr_gerar_exemplares(IN p_isbn CHAR(13), IN p_quantidade INT, IN p_localizacao VARCHAR(50))
BEGIN
    DECLARE contador INT DEFAULT 0;
    DECLARE novo_codigo INT;
    
    -- Pega o maior código atual
    SELECT IFNULL(MAX(codigo), 0) INTO novo_codigo FROM exemplar;
    
    WHILE contador < p_quantidade DO
        SET novo_codigo = novo_codigo + 1;
        INSERT INTO exemplar (codigo, localizacao, status, Livro_isbn) 
        VALUES (novo_codigo, p_localizacao, 'D', p_isbn);
        SET contador = contador + 1;
    END WHILE;
END$$

-- Teste 3: Utilizando o livro Duna (9788576571234)
CALL pr_gerar_exemplares('9788576571234', 3, 'Acervo Novo');

DELIMITER ;


-- ==============================================================================
-- (j) 3 Triggers (INSERT, UPDATE, DELETE)
-- ==============================================================================
DELIMITER $$

-- 1. TRIGGER (AFTER INSERT): Automatiza a mudança de status do Exemplar para Emprestado ('E') assim que ele sai da biblioteca.
CREATE TRIGGER tr_atualiza_status_exemplar AFTER INSERT ON item_emprestimo
FOR EACH ROW
BEGIN
    UPDATE exemplar SET status = 'E' WHERE codigo = NEW.Exemplar_codigo;
END$$

-- 2. TRIGGER (BEFORE UPDATE): Protege o sistema impedindo a alteração cadastral de CPF de um Usuário que possua dívidas/empréstimos ativos.
CREATE TRIGGER tr_valida_update_usuario BEFORE UPDATE ON usuario
FOR EACH ROW
BEGIN
    DECLARE pendencias INT;
    IF OLD.cpf != NEW.cpf THEN
        SELECT COUNT(*) INTO pendencias FROM emprestimo WHERE Usuario_cpf = OLD.cpf AND dataEntrega IS NULL;
        IF pendencias > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido alterar CPF de usuário com empréstimos pendentes!';
        END IF;
    END IF;
END$$

-- 3. TRIGGER (BEFORE DELETE): Restrição vital. Bloqueia a exclusão de uma obra do catálogo caso existam itens de prateleira (exemplares) vinculados a ela.
CREATE TRIGGER tr_valida_delete_livro BEFORE DELETE ON livro
FOR EACH ROW
BEGIN
    DECLARE qtd_exemplares INT;
    SELECT COUNT(*) INTO qtd_exemplares FROM exemplar WHERE Livro_isbn = OLD.isbn;
    IF qtd_exemplares > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir livro que possui exemplares no acervo!';
    END IF;
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- TESTES DOCUMENTADOS DOS TRIGGERS (Disparos e Não Disparos)
-- ----------------------------------------------------------------------------

-- ---------------------------------------------------------
-- TESTES TRIGGER 1 (AFTER INSERT em item_emprestimo)
-- ---------------------------------------------------------
-- CASO DISPARADO (Condição de sucesso na inserção ativando o gatilho):
-- Inserimos um novo item no empréstimo 101 usando o exemplar 5 (que estava status 'D').
INSERT INTO item_emprestimo (Emprestimo_prot, Exemplar_codigo) VALUES (101, 5);
-- Resultado: O trigger é disparado e altera automaticamente o status do exemplar 5 para 'E'.

-- CASO NÃO DISPARADO (Falha anterior ao evento AFTER):
-- Tentamos inserir um item com um código de exemplar que não existe (Ex: 999).
INSERT INTO item_emprestimo (Emprestimo_prot, Exemplar_codigo) VALUES (101, 999);
-- Resultado: O SGBD barra a operação por violação de Chave Estrangeira (FK). Como a inserção falha, o trigger AFTER INSERT não chega a ser disparado.


-- ---------------------------------------------------------
-- TESTES TRIGGER 2 (BEFORE UPDATE em usuario)
-- ---------------------------------------------------------
-- CASO DISPARADO (IF ativado - Bloqueio por pendência):
-- Tentamos alterar o CPF do Carlos Mendes (11122233344), que possui o empréstimo 103 pendente (dataEntrega = NULL).
UPDATE usuario SET cpf = '00000000000' WHERE cpf = '11122233344'; 
-- Resultado: O trigger é disparado, entra na condição IF (pendencias > 0) e lança o Erro 45000, bloqueando o UPDATE.

-- CASO NÃO DISPARADO (IF ignorado - Permite alteração):
-- Tentamos alterar o CPF da Ana Silva (12345678901), cujo empréstimo 101 já possui a data de entrega preenchida.
UPDATE usuario SET cpf = '12345678900' WHERE cpf = '12345678901';
-- Resultado: O trigger roda, mas como a contagem de pendências é 0, a condição de bloqueio não é disparada e o CPF é alterado perfeitamente.


-- ---------------------------------------------------------
-- TESTES TRIGGER 3 (BEFORE DELETE em livro)
-- ---------------------------------------------------------
-- CASO DISPARADO (IF ativado - Bloqueio estrutural):
-- Tentamos excluir o livro "Vidas Secas" (ISBN 9788595084742), que possui exemplares (1 e 2) registrados no acervo.
DELETE FROM livro WHERE isbn = '9788595084742';
-- Resultado: O trigger é disparado, identifica a contagem de exemplares > 0 e lança o Erro 45000, barrando o DELETE.

-- CASO NÃO DISPARADO (IF ignorado - Permite exclusão):
-- Inserimos um livro fictício sem exemplares na estante e em seguida tentamos excluí-lo.
INSERT INTO livro (isbn, titulo, anoPublicacao, Editora_cnpj) VALUES ('9788500000000', 'Livro Teste Sem Exemplar', 2026, '11111111000101');
DELETE FROM livro WHERE isbn = '9788500000000';
-- Resultado: Como a contagem de exemplares é 0, a condição IF de bloqueio não é disparada e o livro é apagado com sucesso.

