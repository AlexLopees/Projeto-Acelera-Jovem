-- INICIO DAS CONSULTAS COMPLEXAS --

--CONTA O NUMERO DE PESSOAS QUE INICIA O NOME COM LETRA 'A'

SELECT COUNT(NOME) AS [INICIADOS COM LETRA A]
FROM TB_PESSOA
WHERE NOME LIKE 'A%'
	



-- CONTA O NUMERO DE PEDIDOS FEITO

SELECT COUNT(*) AS [QUANTIDADE DE PEDIDO]
FROM TB_PEDIDO



--MOSTRA O VALOR DOS PRODUTOS, A QTDE EM ESTOQUE E O VALOR TOTAL DO ESTOQUE 

SELECT
	NOME_PRODUTO AS 'PRODUTO',
	VALOR,
	QTDE_ESTOQUE,
	SUM(VALOR)*(QTDE_ESTOQUE) AS 'VALOR TOTAL EM ESTOQUE'
FROM TB_PRODUTO
GROUP BY NOME_PRODUTO,VALOR,QTDE_ESTOQUE


--PARA UTILIZAR FILTROS EM AGREGA��O SE UTILAZA 'HAVING' E N�O 'WHERE'

SELECT SUM(VALOR) AS [VALOR PRODUTO], QTDE_ESTOQUE
FROM TB_PRODUTO
GROUP BY QTDE_ESTOQUE
HAVING SUM(VALOR) > 100 


--CONSULTAR FUNSION�RIOS QUE TEM OU N�O PEDIDOS FEITOS  

SELECT 
	F.MATRICULA			AS 'MATATRICULA',
	PES.NOME			AS 'VENDEDOR',
	COUNT(P.COD_PEDIDO)	AS 'QTDE PEDIDO FEITO'		
FROM TB_FUNCIONARIO AS F
	LEFT JOIN TB_PEDIDO AS P
		ON F.MATRICULA = P.FK_MATRICULA

	LEFT JOIN TB_PESSOA AS PES
		ON PES.ID_PESSOA = F.FK_ID_PESSOA
WHERE F.MATRICULA IN (7,5,1,11)
GROUP BY F.MATRICULA,PES.NOME
HAVING COUNT(P.COD_PEDIDO) >=0 

--CONSULTAR QUANTIDADE DE PEDIDO QUE CADA CLIENTE REALIZOU 

SELECT  
	P.FK_ID_CLIENTE   AS 'CODIGO',
	PES.NOME		  AS 'CLIENTE',
	COUNT(*)	      AS 'QTDE PEDIDO FEITO'
FROM TB_PEDIDO AS P
	INNER JOIN TB_PESSOA AS PES
		ON PES.ID_PESSOA = P.FK_ID_CLIENTE
GROUP BY FK_ID_CLIENTE,PES.NOME


/*CONSULTAR O VALOR MEDIO DE PRODUTO, BEM COMO O MAIOR VALOR, O MENOR VALOR E
QTDE DE PRODUTOS CADASTRADOS*/

SELECT	
		AVG(VALOR) AS	[MEDIA],
		MAX(VALOR) AS	[MAIOR VALOR],
		MIN(VALOR) AS	[MENOR VALOR],
		COUNT(*)   AS	[QUANTIDADE DE ITENS CADASTRADOS]

FROM TB_PRODUTO

/*----------------------------------------------------//----------------------------------------*/

	-- INICIO DE CRIA��O DOS JOINS	--

--EXIBE A MATRICULA, NOME, FUN��O E ESTATUS DOS FUNCIONARIOS

SELECT
	F.MATRICULA,
	P.NOME,
	FUNC.ID_FUNC AS 'CODIGO',
	FUNC.DESCRICAO AS 'FUNCAO',
	F.SALARIO,

CASE 

		WHEN  F.STATUS_FUNC = 'A' THEN 'ATIVO'
		ELSE 'FERIAS'

END AS 'STATUS_FUNCIONARIO'

FROM TB_FUNCIONARIO AS F
	INNER JOIN TB_PESSOA AS P
		ON P.ID_PESSOA = F.FK_ID_PESSOA

	INNER JOIN TB_FUNCAO AS FUNC
		ON FUNC.ID_FUNC = F.FK_FUNCAO

WHERE F.STATUS_FUNC = 'A' OR F.STATUS_FUNC = 'F'


--RETORNA O CODIGO DO PEDIDO, O PRODUTO, QUANTIDADE VENDIDA E A DATA DE CADA PEDIDO

SELECT
	P.COD_PEDIDO,
	PROD.NOME_PRODUTO,
	C.DESCRICAO AS 'CATEGORIA',
	PROD.VALOR,
	PP.QTDE_ITENS_COMPRADOS AS 'QTDE ITENS VENDIDOS' ,
	P.DTPEDIDO
FROM TB_PEDIDO AS P
	INNER JOIN TB_PEDIDO_PRODUTO AS PP
		ON P.COD_PEDIDO = PP.FK_COD_PEDIDO
	
	INNER JOIN TB_PRODUTO AS PROD
		ON PROD.COD_PRODUTO = PP.FK_COD_PRODUTO

	INNER JOIN TB_CATEGORIA AS C
		ON C.ID_CATEGORIA = PROD.FK_ID_CATEGORIA


/* 
RETORNA CODIGO DO CLIENTE, NOME DO CLIENTE, MATRICULA DO VENDEDOR, NOME DO VENDEDOR, 
CODIGO DO PAGAMENTO, DESCRI�A� DO PAGAMENTO,CODIGO DO PAGAMENTO, NOTA FISCAL E A DATA DO PEDIDO 
*/

SELECT
	FK_ID_CLIENTE AS 'CODCLI',
	PESC.NOME AS 'NOMECLIENTE',
	FK_MATRICULA AS 'MATRICULA',
	PESF.NOME AS 'NOMEVENDEDOR',
	FP.ID_PGTO AS 'NUMPAGAMENTO',
	FP.DESCRICAO,
	PFP.COD_PGTO AS 'CODPAGAMENTO',
	PFP.NUM_NOTA_FISCAL AS 'NFISCAL PEDIDO',
	P.DTPEDIDO
FROM TB_FORMA_PGTO AS FP
	INNER JOIN TB_PEDIDO_FPGTO AS PFP
		ON FP.ID_PGTO = PFP.FK_COD_PGTO
	
	INNER JOIN TB_PEDIDO AS P
		ON P.COD_PEDIDO = PFP.FK_COD_PEDIDO

	INNER JOIN TB_CLIENTE AS CLI
		ON CLI.ID_CLIENTE = P.FK_ID_CLIENTE

	INNER JOIN TB_PESSOA AS PESC
		ON PESC.ID_PESSOA = FK_ID_PESSOA

	INNER JOIN TB_FUNCIONARIO AS FUNC
		ON FUNC.MATRICULA = P.FK_MATRICULA

	INNER JOIN TB_PESSOA AS PESF
		ON PESF.ID_PESSOA = FUNC.FK_ID_PESSOA


/*
RETORNA A MATRICULA DO VENDEDOR, NOME, CODIGO DO PEDIDO,CATEGORIA, 
QUANTIDADE VENDIDA, VALOR DO PRODUTO, NOTA FISCAL, DATA DO PEDIDO E VALOR TOTAL DO PEDIDO
*/

SELECT
	F.MATRICULA,
	PES.NOME AS 'NOMEVENDEDOR',
	P.COD_PEDIDO AS 'CODPEDIDO',
	PRD.NOME_PRODUTO AS 'ITEM',
	C.DESCRICAO AS 'CATEGORIA',
	PP.QTDE_ITENS_COMPRADOS AS 'QTDE VENDIDA',
	PRD.VALOR AS 'VALOR UN',
	P.NOTA_FISCAL AS 'NFISCAL PEDIDO',
	P.DTPEDIDO,
	SUM(PP.QTDE_ITENS_COMPRADOS * PRD.VALOR) 'TOTALPEDIDO'
FROM TB_FUNCIONARIO AS F
	INNER JOIN TB_PEDIDO AS P
		ON F.MATRICULA = P.FK_MATRICULA
	
	INNER JOIN TB_PESSOA AS PES
		ON PES.ID_PESSOA = F.FK_ID_PESSOA
	
	INNER JOIN TB_PEDIDO_PRODUTO AS PP
		ON P.COD_PEDIDO = PP.FK_COD_PEDIDO

	INNER JOIN TB_PRODUTO AS PRD
		ON PRD.COD_PRODUTO = PP.FK_COD_PRODUTO

	INNER JOIN TB_CATEGORIA AS C
		ON C.ID_CATEGORIA = PRD.FK_ID_CATEGORIA
GROUP BY F.MATRICULA, PES.NOME, P.COD_PEDIDO ,PRD.NOME_PRODUTO ,
		 PP.QTDE_ITENS_COMPRADOS , PRD.VALOR, P.NOTA_FISCAL,P.DTPEDIDO,C.DESCRICAO


--RETORNA APENAS FUNCIONARIOS CUJO ESTATUS ESTAJA INATIVO

SELECT
	F.MATRICULA,
	P.NOME,
	FUNC.ID_FUNC AS 'CODIGO',
	FUNC.DESCRICAO AS 'FUNCAO',
	F.SALARIO,
	F.DTDMISSAO,

	CASE

		WHEN  F.STATUS_FUNC = 'A' THEN 'ATIVO'
		WHEN F.STATUS_FUNC = 'I' THEN 'INATIVO'
		ELSE 'FERIAS'

END AS 'STATUS_FUNCIONARIO'

FROM TB_FUNCIONARIO AS F
	INNER JOIN TB_PESSOA AS P
		ON P.ID_PESSOA = F.FK_ID_PESSOA

	INNER JOIN TB_FUNCAO AS FUNC
		ON FUNC.ID_FUNC = F.FK_FUNCAO

WHERE F.DTDMISSAO IS NOT NULL

/* TRAZ TODOS OS CLIENTES QUE TEM RELA��O COM AS TABELAS, OU SEJA,
CLIENTES QUE FIZER�O PEDIDOS E PEDIDOS QUE EST�O VINCULADOS A CLIENTES */

SELECT 
	CLI.ID_CLIENTE AS 'CODCLIENTE',
	PES.NOME AS 'NOMECLIENTE',
	P.COD_PEDIDO AS 'CODPEDIDO',
	P.NOTA_FISCAL,
	P.DTPEDIDO
FROM TB_CLIENTE AS CLI
	INNER JOIN TB_PEDIDO AS P
		ON CLI.ID_CLIENTE = P.FK_ID_CLIENTE

	INNER JOIN TB_PESSOA AS PES
		ON PES.ID_PESSOA = CLI.FK_ID_PESSOA
ORDER BY CODCLIENTE


--TOTAL DE PEDIDO POR CLIENTE

SELECT
	C.ID_CLIENTE,
	PES.NOME,
	COUNT(COD_PEDIDO) AS 'TOTAL DE PEDIDO'
	
FROM TB_CLIENTE AS C
	INNER JOIN TB_PEDIDO AS P
		ON C.ID_CLIENTE = P.FK_ID_CLIENTE

	INNER JOIN TB_PESSOA AS PES
		ON PES.ID_PESSOA = C.FK_ID_PESSOA

GROUP BY ID_CLIENTE,NOME

-- FIM CRIA��O DE JOINS --

/*-----------------------------------------------------------///-----------------------------------------------------------------*/