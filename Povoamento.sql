USE IberoTrem;

-- Povoamento da tabela "Cliente"
INSERT INTO Cliente
	(CC, Data_de_Nascimento, Nome, Telefone, Email)
	VALUES 
		('76452899', 1967-11-12, 'João Bragança', '914934870', 'joao_67_bra@iol.pt'),
		('83509478', 1974-09-23, 'Fernanda Castro', '929896439', 'nanda123@gmail.com'),
		('54365476', 1955-08-12, 'Miguel Castro', '93780900', 'miguel_c@hotmail.pt'),
		('86104398', 1996-12-25, 'Alexandre Mendes', '918626154', 'alex_fcf_96@hotmail.pt'),
		('55787890A', 1960-11-13, 'Diego Murillo', '917483436', 'diego_murillo@gmail.pt');

-- Povoamento da tabela "Reserva"
INSERT INTO Reserva
	(Id_reserva, Preço, Lugar, Data, CC, Id_viagem)
	VALUES 
		(34, 60.0, 1, 2016-11-01,'76452899', 1),
		(35, 45.0, 2, 2016-11-01, '86104398', 1),
		(40, 83.5, 1, 2016-11-05, '83509478', 2),
		(58, 60.0, 3, 2016-11-07, '54365476', 3),
		(67, 83.5, 7, 2016-11-10, '55787890A', 4);


-- Povoamento da tabela "Comboio"
INSERT INTO Comboio
	(Id_comboio, Nr_lugares)
	VALUES 
		(1, 10),
		(2, 10);


-- Povoamento da tabela "Estação"
INSERT INTO Estação
	(Id_estação, Nome, Cidade)
	VALUES 
		(1, 'Campanhã', 'Porto'),
		(2, 'Estación de Francia', 'Barcelona'),
		(3, 'Madrid Atocha', 'Madrid'),
		(4, 'Oriente', 'Lisboa');


-- Povoamento da tabela "Viagem"
INSERT INTO Viagem
	(Id_viagem, Hora_partida, Hora_chegada, Preço, Id_estação_origem, Id_comboio, Id_estação_destino)
	VALUES 
		(1, '07:04', '23:12', 60.0, 1, 1, 3),
		(2, '08:34', '00:02', 83.5, 4, 2, 2),
		(3, '08:04', '00:12', 60.0, 3, 1, 1),
		(4, '06:47', '23:17', 83.5, 2, 2, 4);


