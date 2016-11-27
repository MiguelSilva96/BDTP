USE IberoTrem;

-- Povoamento da tabela "Cliente"
INSERT INTO Cliente
	(CC, Data_de_Nascimento, Nome, Telefone, Email)
	VALUES
		('15325142', '1992-01-05', 'Rolando Escada Abaixo', '924145314', 'rea2010@sapo.pt'),
		('76452899', '1967-11-12', 'João Bragança', '914934870', 'joao_67_bra@iol.pt'),
		('83509478', '1974-09-23', 'Fernanda Castro', '929896439', 'nanda123@gmail.com'),
		('54365476', '1955-08-12', 'Miguel Castro', '93780900', 'miguel_c@hotmail.pt'),
		('86104398', '1996-12-25', 'Alexandre Mendes', '918626154', 'alex_fcf_96@hotmail.pt'),
		('55787890A', '1960-11-13', 'Diego Murillo', '917483436', 'diego_murillo@gmail.pt');

-- Povoamento da tabela "Comboio"
INSERT INTO Comboio
	(Id_comboio, Nr_lugares)
	VALUES 
		(1, 10),
		(2, 10);

-- Povoamente da tabela "Lugares"
INSERT INTO Lugares
	(Lugar, Comboio)
    VALUES
		(1, 1),
        (2, 1),
        (3, 1),
        (4, 1),
        (5, 1),
        (6, 1),
        (7, 1),
        (8, 1),
        (9, 1),
        (10, 1),
        (1, 2),
        (2, 2),
        (3, 2),
        (4, 2),
        (5, 2),
        (6, 2),
        (7, 2),
        (8, 2),
        (9, 2),
        (10, 2);


-- Povoamento da tabela "Estação"
INSERT INTO Estação
	(Id_estação, Nome, Cidade)
	VALUES 
		(1, 'Campanhã', 'Porto'),
		(2, 'Santiago de Compostela ', 'Santiago de Compostela'),
		(3, 'Vigo Guixar', 'Vigo'),
		(4, 'Chaves', 'Chaves'),
        (5, 'Braga', 'Braga'),
        (6, 'Vila Real', 'Vila Real'),
        (7, 'Guimarães', 'Guimarães'),
        (8, 'Viana do Castelo', 'Viana do Castelo'),
        (9, 'A Coruña', 'Corunha'),
        (10, 'Mirandela', 'Mirandela'),
        (11, 'Ourense', 'Ourense'),
        (12, 'Duas Igrejas', 'Miranda Douro');


-- Hora de partida é sempre superior à hora de chegada

DELIMITER $$ 

CREATE TRIGGER check_horario
     BEFORE INSERT ON Viagem FOR EACH ROW
     BEGIN
	IF (NEW.Hora_chegada < NEW.Hora_partida)
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Hora de chegada inválida';
          END IF;
     END;
$$

-- Estação origem != Estação destino

DELIMITER $$
CREATE TRIGGER check_estacao
	BEFORE INSERT ON Viagem
    FOR EACH ROW
    BEGIN
		IF (NEW.Id_estação_origem = NEW.Id_estação_destino)
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Estação de destino não pode ser igual à estação de partida';
		END IF;
	END;
$$


DROP PROCEDURE LugaresLivres;
DELIMITER $$
CREATE PROCEDURE LugaresLivres (IN viagem INT, IN data Date)
BEGIN
	SELECT DISTINCT Lugares.Lugar FROM Lugares
	LEFT JOIN (SELECT Reserva.Lugar from Reserva
			   inner join Viagem on Viagem.Id_viagem = Reserva.Id_viagem
				where Viagem.Id_viagem = viagem and Reserva.Data = data) AS T on Lugares.Lugar = T.Lugar where T.Lugar is NULL
	ORDER BY Lugares.Lugar asc;
END
$$

DROP FUNCTION calculaPreço;
DELIMITER $$
CREATE FUNCTION calculaPreço(viagem INT, cliente VARCHAR(64)) RETURNS FLOAT
BEGIN

	DECLARE Price FLOAT DEFAULT 0;
    DECLARE idade INT DEFAULT 0;
	DECLARE RES FLOAT DEFAULT 0;

		SELECT Preço INTO Price FROM Viagem where id_viagem = viagem;
		SELECT TIMESTAMPDIFF(YEAR, Data_de_Nascimento, CURDATE()) INTO idade FROM Cliente where cc = cliente;
	if (idade < 25) then SET RES = 0.75 * Price;
    else SET RES = Price;
	end if;
	RETURN RES;
END;
$$


-- Povoamento da tabela "Viagem"
INSERT INTO Viagem
	(Id_viagem, Hora_partida, Hora_chegada, Preço, Id_estação_origem, Id_comboio, Id_estação_destino)
	VALUES 
		(1, '07:04:00', '23:12:00', 60.0, 1, 1, 3),
		(2, '07:34:00', '23:02:00', 83.5, 4, 2, 2),
		(3, '06:04:00', '22:12:00', 60.0, 3, 1, 1),
		(4, '06:47:00', '22:17:00', 83.5, 2, 2, 4);

-- Povoamento da tabela "Reserva" com reservas antigas
INSERT INTO Reserva
	(Id_reserva, Lugar, Data, CC, Id_viagem)
	VALUES 
		(1, 1, '2016-11-01','76452899', 1),
		(2, 2, '2016-11-01', '86104398', 1),
		(3, 1, '2016-11-05', '83509478', 2),
		(4, 3,'2016-11-07', '54365476', 3),
		(5, 7, '2016-11-10', '55787890A', 4);
        
        
DROP PROCEDURE addReserva;
DELIMITER $$
CREATE PROCEDURE addReserva(IN nome VARCHAR(32), IN cc VARCHAR(9), IN dob DATE, IN tel VARCHAR(9), IN ee VARCHAR(32), IN viagem INT, IN dia DATE, IN lugar INT)
BEGIN
	IF NOT EXISTS
		(SELECT CC FROM Cliente where cc = CC.Cliente)
	BEGIN
    START TRANSACTION;
	INSERT INTO Cliente
		(CC, Data_de_Nascimento, Nome, Telefone, Email)
		VALUES
			(cc, dob, nome, tel, ee);
    END
    -- Declaraçãoo de um handler para tratamento de erros.
    DECLARE ErroTransacao BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET ErroTransacao = 1;
	-- Início da transação
	START TRANSACTION;
    INSERT INTO Reserva
		(Id_reserva, Lugar, Data, CC, Id_viagem)
		VALUES
			(SELECT COUNT(*) FROM Reserva + 1, lugar, dia, cc, viagem);
		-- Verificação da ocorrência de um erro.
    IF ErroTransacao THEN
		-- Desfazer as operações realizadas.
        ROLLBACK;
    ELSE
		-- Confirmar as operações realizadas.
        COMMIT;
    END IF;
END
$$

CREATE VIEW ReservaPreço
AS SELECT *, ROUND(calculaPreço(id_viagem, cc), 2) as Price FROM Reserva;
        
-- gatilho que garante que nao sao efetuadas reservas para o dia atual ou anteriores
DELIMITER $$
create trigger check_reserva
	before insert on Reserva
    for each row
    begin
		if (datediff(new.data,curdate()) < 1)
        then
			signal sqlstate '45000'
				set message_text = 'Reserva não pode ser efetuada';
		end if;
	end;
$$

-- teste ao gatilho
insert into Reserva
	(Id_reserva, Lugar, Data, CC, Id_viagem)
	values (6, 1, curdate(),'76452899', 1);

