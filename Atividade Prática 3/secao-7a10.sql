-- Parte 1 – Junções e Produto Cartesiano (Seção 7)

-- 1. Usando a sintaxe proprietária da Oracle, exiba o nome de cada cliente junto com o número de sua conta.
SELECT c.nome, a.numero_conta FROM clientes c, contas a WHERE c.id = a.id_cliente;

-- 2. Mostre todas as combinações possíveis de clientes e agências (produto cartesiano).
SELECT c.nome, a.nome_agencia FROM clientes c, agencias a;    

-- 3. Usando aliases de tabela, exiba o nome dos clientes e a cidade da agência onde mantêm conta.
SELECT c.nome, a.cidade FROM clientes c, agencias a WHERE c.id_agencia = a.id;

-- Parte 2 – Funções de Grupo, COUNT, DISTINCT e NVL (Seção 8)

-- 4. Exiba o saldo total de todas as contas cadastradas.
SELECT SUM(a.saldo) AS saldo_total FROM contas a;

-- 5. Mostre o maior saldo e a média de saldo entre todas as contas.
SELECT MAX(a.saldo) AS maior_saldo, AVG(a.saldo) AS media_saldo FROM contas a;

-- 6. Apresente a quantidade total de contas cadastradas.
SELECT COUNT(a.id) AS total_contas FROM contas a;

-- 7. Liste o número de cidades distintas onde os clientes residem.
SELECT COUNT(DISTINCT c.cidade) AS cidades_distintas FROM clientes c;

-- 8. Exiba o número da conta e o saldo, substituindo valores nulos por zero.
SELECT a.numero_conta, NVL(a.saldo, 0) AS saldo FROM contas a;

-- Parte 3 – GROUP BY, HAVING, ROLLUP e Operadores de Conjunto (Seção 9)

-- 9. Exiba a média de saldo por cidade dos clientes.
SELECT a.cidade, AVG(b.saldo) AS media_saldo FROM agencias a JOIN contas b ON a.id = b.id_agencia GROUP BY a.cidade;

-- 10. Liste apenas as cidades com mais de 3 contas associadas a seus moradores.
SELECT a.cidade, COUNT(b.id) AS total_contas FROM agencias a JOIN contas b ON a.id = b.id_agencia GROUP BY a.cidade HAVING COUNT(b.id) > 3;

-- 11.Utilize a cláusula ROLLUP para exibir o total de saldos por cidade da agência e o total geral.
SELECT a.cidade, SUM(b.saldo) AS total_saldo FROM agencias a JOIN contas b ON a.id = b.id_agencia GROUP BY ROLLUP(a.cidade);

-- 12. Faça uma consulta com UNION que combine os nomes de cidades dos clientes e das agências, sem repetições.
SELECT c.cidade FROM clientes c UNION SELECT a.cidade FROM agencias a;

-- Parte 1 – Subconsultas de Linha Única

-- 1. Liste os nomes dos clientes cujas contas possuem saldo acima da média geral de todas as contas registradas.
SELECT c.nome FROM clientes c JOIN contas a ON c.id = a.id_cliente WHERE a.saldo > (SELECT AVG(saldo) FROM contas);

-- 2. Exiba os nomes dos clientes cujos saldos são iguais ao maior saldo encontrado no banco.
SELECT c.nome FROM clientes c JOIN contas a ON c.id = a.id_cliente WHERE a.saldo = (SELECT MAX(saldo) FROM contas);

-- 3. Liste as cidades onde a quantidade de clientes é maior que a quantidade média de clientes por cidade.
SELECT c.cidade FROM clientes c GROUP BY c.cidade HAVING COUNT(c.id) > (SELECT AVG(total) FROM (SELECT COUNT(id) AS total FROM clientes GROUP BY cidade));

-- Parte 2 – Subconsultas Multilinha

-- 4. Liste os nomes dos clientes com saldo igual a qualquer um dos dez maiores saldos registrados.
SELECT c.nome FROM clientes c JOIN contas a ON c.id = a.id_cliente WHERE a.saldo IN (SELECT saldo FROM contas ORDER BY saldo DESC FETCH FIRST 10 ROWS ONLY);

-- 5. Liste os clientes que possuem saldo menor que todos os saldos dos clientes da cidade de Niterói.
SELECT c.nome FROM clientes c JOIN contas a ON c.id = a.id_cliente WHERE a.saldo < ALL (SELECT saldo FROM contas WHERE id_cliente IN (SELECT id FROM clientes WHERE cidade = 'Niterói'));

-- 6. Liste os clientes cujos saldos estão entre os saldos de clientes de Volta Redonda.
SELECT c.nome
FROM clientes c
JOIN contas a ON c.id = a.id_cliente
WHERE a.saldo BETWEEN (SELECT MIN(saldo) FROM contas WHERE id_cliente IN (SELECT id FROM clientes WHERE cidade = 'Volta Redonda'))
AND (SELECT MAX(saldo) FROM contas WHERE id_cliente IN (SELECT id FROM clientes WHERE cidade = 'Volta Redonda'));

-- Parte 3 – Subconsultas Correlacionadas

-- 7. Exiba os nomes dos clientes cujos saldos são maiores que a média de saldo das contas da mesma agência.
SELECT c.nome FROM clientes c JOIN contas a ON c.id = a.id_cliente WHERE a.saldo > (SELECT AVG(saldo) FROM contas WHERE id_agencia = a.id_agencia);

-- 8. Liste os nomes e cidades dos clientes que têm saldo inferior à média de sua própria cidade.
SELECT c.nome, c.cidade FROM clientes c JOIN contas a ON c.id = a.id_cliente WHERE a.saldo < (SELECT AVG(saldo) FROM contas WHERE id_cliente IN (SELECT id FROM clientes WHERE cidade = c.cidade));


-- Parte 4 – Subconsultas com EXISTS e NOT EXISTS

-- 9. Liste os nomes dos clientes que possuem pelo menos uma conta registrada no banco.
SELECT c.nome FROM clientes c WHERE EXISTS (SELECT 1 FROM contas a WHERE a.id_cliente = c.id);

-- 10. Liste os nomes dos clientes que ainda não possuem conta registrada no banco.
SELECT c.nome FROM clientes c WHERE NOT EXISTS (SELECT 1 FROM contas a WHERE a.id_cliente = c.id);

-- Parte 5 – Subconsulta Nomeada com WITH

-- 11.Usando a cláusula WITH, calcule a média de saldo por cidade e exiba os clientes que possuem saldo acima da média de sua cidade.
WITH media_saldo AS (
    SELECT c.cidade, AVG(a.saldo) AS media
    FROM clientes c
    JOIN contas a ON c.id = a.id_cliente
    GROUP BY c.cidade
)
SELECT c.nome
FROM clientes c
JOIN contas a ON c.id = a.id_cliente
JOIN media_saldo m ON c.cidade = m.cidade
WHERE a.saldo > m.media;