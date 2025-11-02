-- Parte 1 – Conversões Implícitas e Explícitas

-- 1. Exiba o número da conta e o saldo formatado com separador de milhar e vírgula como separador decimal.
SELECT conta_numero, TO_CHAR(saldo, 'FM9G999D00', 'NLS_NUMERIC_CHARACTERS = '',.''') AS saldo_formatado FROM conta;

-- 2. Mostre a data atual no formato 'DD/MM/YYYY'.
SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS data_atual FROM dual;

-- 3. Exiba o nome do cliente concatenado com a cidade onde ele reside.
SELECT cliente_nome || ' - ' || cidade AS cliente_cidade FROM cliente;

-- 4. Liste os empréstimos com valor maior que R$ 5.000, formatando o valor com símbolo monetário.
SELECT emprestimo_numero, 'R$ ' || TO_CHAR(quantia, 'FM999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') AS valor_formatado FROM emprestimo WHERE quantia > 5000;

-- Parte 2 - Tipos de Dados Avançados

-- 5. Adicione uma coluna do tipo TIMESTAMP na tabela cliente chamada data_cadastro.
ALTER TABLE cliente ADD data_cadastro TIMESTAMP;

-- 6. Mostre quantos dias se passaram desde o cadastro de cada cliente.
SELECT cliente_nome, TRUNC(SYSDATE - CAST(data_cadastro AS DATE)) AS dias_passados FROM cliente;

-- 7. Adicione uma coluna do tipo INTERVAL YEAR TO MONTH na tabela cliente chamada tempo_fidelidade.
ALTER TABLE cliente ADD tempo_fidelidade INTERVAL YEAR(2) TO MONTH;

-- 8. Exiba para cada cliente a data de cadastro e uma previsão de renovação de cadastro adicionando 3 meses.
SELECT
  cliente_nome,
  data_cadastro,
  ADD_MONTHS(data_cadastro, 3) AS data_renovacao
FROM
  cliente;

-- Parte 3 – Constraints

-- 9. Crie uma tabela chamada cartao_credito com as seguintes restrições:
-- - cartao_numero (PK)
-- - cliente_cod (FK)
-- - limite_credito (NOT NULL)
-- - status (CHECK: 'ATIVO', 'BLOQUEADO', 'CANCELADO')
CREATE TABLE cartao_credito (
  cartao_numero   INTEGER PRIMARY KEY,
  cliente_cod     INTEGER NOT NULL,
  limite_credito  NUMBER(10, 2) NOT NULL,
  status          VARCHAR2(10 CHAR),
  
  CONSTRAINT cartao_cliente_fk FOREIGN KEY (cliente_cod) REFERENCES cliente(cliente_cod),
  CONSTRAINT chk_cartao_status CHECK (status IN ('ATIVO', 'BLOQUEADO', 'CANCELADO'))
);

-- 10. Tente inserir um cartão de crédito com campo limite_credito nulo (explique o erro).
INSERT INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status)
VALUES (1001, 1, NULL, 'ATIVO');
-- O erro ocorre porque a coluna limite_credito foi definida como NOT NULL, ou seja, não pode aceitar valores nulos.
 
-- 11. Insira ao menos três registros válidos na tabela cartao_credito.
INSERT ALL
  INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status) VALUES (1001, 1, 5000.00, 'ATIVO')
  INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status) VALUES (1002, 2, 2500.00, 'ATIVO')
  INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status) VALUES (1003, 3, 1000.00, 'BLOQUEADO')
SELECT * FROM dual;

-- 12. Crie uma tabela transacao com restrição CHECK para valores positivos.
CREATE TABLE transacao (
  transacao_id    INTEGER PRIMARY KEY,
  conta_numero    INTEGER,
  valor           NUMBER(10, 2),
  data_transacao  DATE DEFAULT SYSDATE,
  
  CONSTRAINT fk_trans_conta FOREIGN KEY (conta_numero) REFERENCES conta(conta_numero),
  CONSTRAINT chk_valor_positivo CHECK (valor > 0)
);

-- 13. Tente inserir uma transação com valor negativo (explique o erro).
INSERT INTO transacao (transacao_id, conta_numero, valor)
VALUES (1, 1, -100.00);
-- O erro ocorre porque a coluna valor foi definida com uma restrição CHECK que não permite valores negativos.

-- 14. Crie uma consulta que relacione clientes ativos com seus respectivos limites de crédito acima de 3000.
SELECT
  c.cliente_nome,
  cc.limite_credito,
  cc.status
FROM
  cliente c
  JOIN cartao_credito cc ON c.cliente_cod = cc.cliente_cod
WHERE
  cc.status = 'ATIVO'
  AND cc.limite_credito > 3000;

-- 15. Crie uma VIEW chamada vw_clientes_com_cartao que exiba nome, cidade e status do cartão.
CREATE OR REPLACE VIEW vw_clientes_com_cartao AS
SELECT
  c.cliente_nome,
  c.cidade,
  cc.status
FROM
  cliente c
  JOIN cartao_credito cc ON c.cliente_cod = cc.cliente_cod;