USE IberoTrem;

-- Povoamento da tabela "Cliente"
INSERT INTO Cliente
	(CC, Data_de_Nascimento, Nome, Telefone, Email)
	VALUES 
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
		(2, 'Estación de Francia', 'Barcelona'),
		(3, 'Madrid Atocha', 'Madrid'),
		(4, 'Oriente', 'Lisboa');



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

-- Povoamento da tabela "Viagem"
INSERT INTO Viagem
	(Id_viagem, Hora_partida, Hora_chegada, Preço, Id_estação_origem, Id_comboio, Id_estação_destino)
	VALUES 
		(1, '07:04:00', '23:12:00', 60.0, 1, 1, 3),
		(2, '07:34:00', '23:02:00', 83.5, 4, 2, 2),
		(3, '06:04:00', '22:12:00', 60.0, 3, 1, 1),
		(4, '06:47:00', '22:17:00', 83.5, 2, 2, 4);


DROP TRIGGER check_estacao;
DROP TRIGGER check_horario;

-- Povoamento da tabela "Reserva"
INSERT INTO Reserva
	(Id_reserva, Lugar, Data, CC, Id_viagem)
	VALUES 
		(1, 1, '2016-11-01','76452899', 1),
		(2, 2, '2016-11-01', '86104398', 1),
		(3, 1, '2016-11-05', '83509478', 2),
		(4, 3,'2016-11-07', '54365476', 3),
		(5, 7, '2016-11-10', '55787890A', 4);




