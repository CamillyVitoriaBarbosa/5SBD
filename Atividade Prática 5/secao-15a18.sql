-- Parte 1 – Sequências

-- 1. Crie uma sequência chamada seq_movimento que inicie em 100 e incremente de 10 em 10.
CREATE SEQUENCE seq_movimento START WITH 100 INCREMENT BY 10;

-- 2. Crie uma tabela chamada movimento_conta com as colunas: movimento_id, conta_numero, tipo (C ou D), valor, data_movimento.
CREATE TABLE movimento_conta (
  movimento_id    INTEGER PRIMARY KEY,
  conta_numero    INTEGER NOT NULL,
  tipo            CHAR(1) NOT NULL,
  valor           NUMBER(10, 2) NOT NULL,
  data_movimento  DATE DEFAULT SYSDATE,
  
  CONSTRAINT fk_mov_conta FOREIGN KEY (conta_numero) REFERENCES conta(conta_numero),
  CONSTRAINT chk_mov_tipo CHECK (tipo IN ('C', 'D'))
);

-- 3. Insira pelo menos três movimentações diferentes utilizando a sequência seq_movimento.
INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor, data_movimento)
VALUES (seq_movimento.NEXTVAL, 1, 'C', 1000.00, SYSDATE);
INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor, data_movimento)
VALUES (seq_movimento.NEXTVAL, 2, 'D', 150.50, SYSDATE);
INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor, data_movimento)
VALUES (seq_movimento.NEXTVAL, 1, 'D', 25.00, SYSDATE);


-- Parte 2 – Views

-- 4. Crie uma view chamada vw_contas_clientes que exiba o nome do cliente, o número da conta, saldo e código da agência.
CREATE OR REPLACE VIEW vw_contas_clientes AS
SELECT
  c.cliente_nome,
  ct.conta_numero,
  ct.saldo,
  ct.agencia_agencia_cod
FROM
  cliente c
  JOIN conta ct ON c.cliente_cod = ct.cliente_cliente_cod;

-- 5. Crie uma view chamada vw_emprestimos_grandes que exiba número do empréstimo, nome do cliente e valor dos empréstimos acima de R$ 20.000.
CREATE OR REPLACE VIEW vw_emprestimos_grandes AS
SELECT
  e.emprestimo_numero,
  c.cliente_nome,
  e.quantia
FROM
  cliente c
  JOIN emprestimo e ON c.cliente_cod = e.cliente_cliente_cod
WHERE
  e.quantia > 20000;

-- 6. Tente fazer um update diretamente na view vw_emprestimos_grandes e observe o que acontece. Explique o motivo.
UPDATE vw_emprestimos_grandes SET quantia = 1500 WHERE emprestimo_numero = 3;
-- Deu o erro 'ORA-01779: cannot modify a column which maps to a non key-preserved table' 
-- Porque a view foi feita com um join e para conseguir atualizar esse tipo de view a tabela é para modificar deve ter a chave primária incluída na view.


-- Parte 3 – Privilégios e Roles

-- 7. Crie uma role chamada atendente_agencia com privilégios de SELECT em cliente e conta, e UPDATE no endereço do cliente.
CREATE ROLE atendente_agencia;

GRANT SELECT ON cliente TO atendente_agencia;
GRANT SELECT ON conta TO atendente_agencia;
GRANT UPDATE (rua, cidade) ON cliente TO atendente_agencia;

-- 8. Conceda essa role ao usuário carla.
GRANT atendente_agencia TO carla;

-- 9. Revogue da role o privilégio de UPDATE no endereço.
REVOKE UPDATE (rua, cidade) ON cliente FROM atendente_agencia;

-- 10. Crie um usuário chamado auditor com privilégios para consultar qualquer view do banco.
CREATE USER auditor IDENTIFIED BY SenhaForte;

GRANT SELECT ANY VIEW TO auditor;


-- Parte 3 – Expressões Regulares

-- Adicionando cpf e email na tabela e populando as adições
ALTER TABLE cliente ADD (
  cpf   VARCHAR2(14),
  email VARCHAR2(100)
);

UPDATE cliente SET email = 'carlos.silva@coxinha-rj.br', cpf = '000.000.001-01' WHERE cliente_cod = 1;
UPDATE cliente SET email = 'ana.santos@snoopy-nha.br', cpf = '000.000.002-02' WHERE cliente_cod = 2;
UPDATE cliente SET email = 'pedro.oliveira@naosou-bot.us', cpf = '000.000.003-03' WHERE cliente_cod = 3;
UPDATE cliente SET email = 'maria.souza@sobrevivente.br', cpf = '000.000.004-04' WHERE cliente_cod = 4;
UPDATE cliente SET email = 'jose.rodrigues@coxinha-rj.br', cpf = '000.000.005-05' WHERE cliente_cod = 5;
UPDATE cliente SET email = 'paula.ferreira@snoopy-nha.br', cpf = '000.000.006-06' WHERE cliente_cod = 6;
UPDATE cliente SET email = 'lucas.almeida@naosou-bot.us', cpf = '000.000.007-07' WHERE cliente_cod = 7;
UPDATE cliente SET email = 'fernanda.costa@sobrevivente.br', cpf = '000.000.008-08' WHERE cliente_cod = 8;
UPDATE cliente SET email = 'rafael.gomes@coxinha-rj.br', cpf = '000.000.009-09' WHERE cliente_cod = 9;
UPDATE cliente SET email = 'juliana.martins@snoopy-nha.br', cpf = '000.000.010-10' WHERE cliente_cod = 10;
UPDATE cliente SET email = 'gabriel.ribeiro@naosou-bot.us', cpf = '000.000.011-11' WHERE cliente_cod = 11;
UPDATE cliente SET email = 'mariana.carvalho@sobrevivente.br', cpf = '000.000.012-12' WHERE cliente_cod = 12;
UPDATE cliente SET email = 'bruno.lima@coxinha-rj.br', cpf = '000.000.013-13' WHERE cliente_cod = 13;
UPDATE cliente SET email = 'laura.araujo@snoopy-nha.br', cpf = '000.000.014-14' WHERE cliente_cod = 14;
UPDATE cliente SET email = 'thiago.pereira@naosou-bot.us', cpf = '000.000.015-15' WHERE cliente_cod = 15;
UPDATE cliente SET email = 'patricia.mendes@sobrevivente.br', cpf = '000.000.016-16' WHERE cliente_cod = 16;
UPDATE cliente SET email = 'felipe.barbosa@coxinha-rj.br', cpf = '000.000.017-17' WHERE cliente_cod = 17;
UPDATE cliente SET email = 'aline.teixeira@snoopy-nha.br', cpf = '000.000.018-18' WHERE cliente_cod = 18;
UPDATE cliente SET email = 'gustavo.moreira@naosou-bot.us', cpf = '000.000.019-19' WHERE cliente_cod = 19;
UPDATE cliente SET email = 'camila.vieira@sobrevivente.br', cpf = '000.000.020-20' WHERE cliente_cod = 20;
UPDATE cliente SET email = 'mateus.silva@coxinha-rj.br', cpf = '000.000.021-21' WHERE cliente_cod = 21;
UPDATE cliente SET email = 'beatriz.santos@snoopy-nha.br', cpf = '000.000.022-22' WHERE cliente_cod = 22;
UPDATE cliente SET email = 'renato.oliveira@naosou-bot.us', cpf = '000.000.023-23' WHERE cliente_cod = 23;
UPDATE cliente SET email = 'sofia.souza@sobrevivente.br', cpf = '000.000.024-24' WHERE cliente_cod = 24;
UPDATE cliente SET email = 'diego.rodrigues@coxinha-rj.br', cpf = '000.000.025-25' WHERE cliente_cod = 25;
UPDATE cliente SET email = 'mariana.ferreira@snoopy-nha.br', cpf = '000.000.026-26' WHERE cliente_cod = 26;
UPDATE cliente SET email = 'joao.almeida@naosou-bot.us', cpf = '000.000.027-27' WHERE cliente_cod = 27;
UPDATE cliente SET email = 'juliana.costa@sobrevivente.br', cpf = '000.000.028-28' WHERE cliente_cod = 28;
UPDATE cliente SET email = 'rafaela.gomes@snoopy-nha.br', cpf = '000.000.029-29' WHERE cliente_cod = 29;
UPDATE cliente SET email = 'gabriel.martins@coxinha-rj.br', cpf = '000.000.030-30' WHERE cliente_cod = 30;
UPDATE cliente SET email = 'marcelo.ribeiro@naosou-bot.us', cpf = '000.000.031-31' WHERE cliente_cod = 31;
UPDATE cliente SET email = 'ana.carvalho@sobrevivente.br', cpf = '000.000.032-32' WHERE cliente_cod = 32;
UPDATE cliente SET email = 'carlos.lima@coxinha-rj.br', cpf = '000.000.033-33' WHERE cliente_cod = 33;
UPDATE cliente SET email = 'patricia.araujo@snoopy-nha.br', cpf = '000.000.034-34' WHERE cliente_cod = 34;
UPDATE cliente SET email = 'rafael.pereira@naosou-bot.us', cpf = '000.000.035-35' WHERE cliente_cod = 35;
UPDATE cliente SET email = 'fernanda.mendes@sobrevivente.br', cpf = '000.000.036-36' WHERE cliente_cod = 36;
UPDATE cliente SET email = 'thiago.barbosa@coxinha-rj.br', cpf = '000.000.037-37' WHERE cliente_cod = 37;
UPDATE cliente SET email = 'ana.teixeira@snoopy-nha.br', cpf = '000.000.038-38' WHERE cliente_cod = 38;
UPDATE cliente SET email = 'paulo.moreira@naosou-bot.us', cpf = '000.000.039-39' WHERE cliente_cod = 39;
UPDATE cliente SET email = 'juliana.vieira@sobrevivente.br', cpf = '000.000.040-40' WHERE cliente_cod = 40;

-- 11. Liste todos os clientes cujo nome começa com 'M' e termina com 'a' (não sensível a maiúsculas/minúsculas).
SELECT cliente_nome FROM cliente WHERE REGEXP_LIKE(cliente_nome, '^M.*a$', 'i');

-- 12. Mascarar os seis primeiros dígitos do CPF, mantendo os últimos três visíveis, para todos os clientes.
SELECT cpf, REGEXP_REPLACE(cpf, '^([0-9]{3}\\.[0-9]{3}\\.[0-9]{3})', '***.***.***') AS cpf_mascarado FROM cliente WHERE cpf IS NOT NULL;

-- 13. Exibir o domínio dos e-mails dos clientes (parte após o @).
SELECT email, REGEXP_REPLACE(email, '.*@', '') AS dominio FROM cliente WHERE email IS NOT NULL;

-- 14. Listar clientes com dois ou mais nomes.
SELECT cliente_nome FROM cliente WHERE REGEXP_LIKE(cliente_nome, '\s');

-- 15. Filtrar clientes cujo e-mail termina com '.br'.
SELECT cliente_nome, email FROM cliente WHERE REGEXP_LIKE(email, '\.br$');