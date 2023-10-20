create schema viajes;

create table Destino(
IdDestino int primary key auto_increment not null,
Nombre varchar(50)
);

create table Avion(
IdAvion int primary key auto_increment not null,
cantAsientos int
);

create table Cliente(
IdCliente int primary key auto_increment not null,
Nombre varchar(50),
Apellido varchar(50),
Mail varchar(50)
);


create table Piloto(
dniPiloto int primary key not null,
Nombre varchar(50),
Apellido varchar(50)
);

create table Vuelo(
IdVuelo int primary key auto_increment,
IdDestino int,
IdAvion int,
fechahorario datetime,
piloto int,
foreign key (IdDestino) references Destino(IdDestino),
foreign key (IdAvion) references Avion(IdAvion),
foreign key (piloto) references Piloto(dniPiloto)
);

create table Pasaje(
IdPasaje int primary key auto_increment not null,
IdCliente int,
IdVuelo int,
foreign key (IdCliente) References Cliente(IdCliente),
foreign key (IdVuelo) References Vuelo(IdVuelo)
);

create table baja_cliente(

idcliente int primary key,
fecha datetime,
mail int,
nombre int,
apellido int
);

create table log_vuelos(

id_vuelo int primary key,
fecha datetime,
destino int
);

/*PROCEDIMIENTOS ALMACENADOS*/
DELIMITER $$
CREATE PROCEDURE `sp_ordenar_vuelos` (in campo varchar(60), in orden varchar(20))
BEGIN
	if campo <> '' and orden <>'' then
		set @ordenvuelo = concat(' ORDER BY ',campo,' ',orden);
    elseif campo <> '' and orden ='' then
		set @ordenvuelo = concat(' ORDER BY ',campo);
    else
		set @ordenvuelo='';
    end if;
    set @clausula = concat('SELECT * FROM VUELO', @ordenvuelo);
    PREPARE runSQL from @clausula;
    execute runSQL;
    deallocate prepare runSQL;
END
$$



CREATE PROCEDURE `sp_eliminar_vuelo` (in vuelo int)
BEGIN
	if vuelo = '' then
		select 'no cumple las condiciones';
        else
        delete from vuelo where IdVuelo = vuelo;
        
        select * from vuelo;
        end if;
END;

/* TRIGGERS*/
create trigger `vuelo_cancelado`
BEFORE DELETE on vuelo
for each row
	insert into log_vuelos(id_vuelo, fecha, destino)
    values(old.IdVuelo, current_timestamp(),old.IdDestino);



create trigger `baja_usuario`
BEFORE DELETE on cliente
for each row
	insert into baja_cliente(idcliente, fecha,mail,nombre,apellido)
    values(old.IdCliente, current_timestamp(),old.mail,old.Nombre,old.Apellido);
    


/*VISTAS */
#Todos los vuelos
SELECT * FROM viajes.vuelo;

#VUELOS QUE TODAVIA NO SALIERON
select * from viajes.vuelo where fechahorario > CURRENT_TIMESTAMP;

#VUELOS REALIZADOS POR PILOTOS
SELECT * FROM piloto
inner join vuelo on piloto.dniPiloto = vuelo.piloto;

#VUELOS A ARGENTINA
select destino.Nombre, vuelo.fechahorario as Salida,
concat( piloto.Apellido," ", piloto.nombre) as Piloto from vuelo
inner join destino
on vuelo.IdDestino = destino.IdDestino
inner join piloto on vuelo.piloto = piloto.dniPiloto
 where destino.IdDestino = 31;
 
 #Cantidad de pasajes por clientes
 SELECT count(IdPasaje) as "Cantidad de pasajes", pasaje.IdCliente,concat( cliente.Nombre," ", cliente.apellido) as Cliente
FROM pasaje
inner join cliente
on pasaje.IdCliente = cliente.IdCliente 
group by cliente.IdCliente;

/*FUNCIONES*/

CREATE FUNCTION `Actualizar_mail` (mail varchar(100), idCliente int)
RETURNS VARCHAR(60)
BEGIN
	DECLARE Resolucion VARCHAR(60);
    SET	Resolucion = 'Se ha actualizado correctamente';
    update viajes.cliente
    set cliente.Mail = mail
    where cliente.IdCliente = idcliente;
    

RETURN Resolucion;
END

CREATE FUNCTION `Destino_de_Vuelo` (idvuelo int)
RETURNS VARCHAR(60)
BEGIN
	DECLARE Resolucion VARCHAR(60);
    select Nombre into Resolucion
    from vuelo
    inner join destino
    on vuelo.IdDestino = vuelo.IdDestino
    where vuelo.idvuelo = idvuelo
    

RETURN Resolucion;
END

insert into destino (IdDestino, Nombre) values (1, 'Netherlands');
insert into destino (IdDestino, Nombre) values (2, 'China');
insert into destino (IdDestino, Nombre) values (3, 'China');
insert into destino (IdDestino, Nombre) values (4, 'Brazil');
insert into destino (IdDestino, Nombre) values (5, 'Portugal');
insert into destino (IdDestino, Nombre) values (6, 'Sierra Leone');
insert into destino (IdDestino, Nombre) values (7, 'China');
insert into destino (IdDestino, Nombre) values (8, 'Portugal');
insert into destino (IdDestino, Nombre) values (9, 'Uzbekistan');
insert into destino (IdDestino, Nombre) values (10, 'China');
insert into destino (IdDestino, Nombre) values (11, 'China');
insert into destino (IdDestino, Nombre) values (12, 'Finland');
insert into destino (IdDestino, Nombre) values (13, 'Poland');
insert into destino (IdDestino, Nombre) values (14, 'China');
insert into destino (IdDestino, Nombre) values (15, 'Kazakhstan');
insert into destino (IdDestino, Nombre) values (16, 'Greece');
insert into destino (IdDestino, Nombre) values (17, 'Bulgaria');
insert into destino (IdDestino, Nombre) values (18, 'Sweden');
insert into destino (IdDestino, Nombre) values (19, 'Honduras');
insert into destino (IdDestino, Nombre) values (20, 'Indonesia');
insert into destino (IdDestino, Nombre) values (21, 'Canada');
insert into destino (IdDestino, Nombre) values (22, 'China');
insert into destino (IdDestino, Nombre) values (23, 'Albania');
insert into destino (IdDestino, Nombre) values (24, 'China');
insert into destino (IdDestino, Nombre) values (25, 'Russia');
insert into destino (IdDestino, Nombre) values (26, 'Netherlands');
insert into destino (IdDestino, Nombre) values (27, 'Portugal');
insert into destino (IdDestino, Nombre) values (28, 'China');
insert into destino (IdDestino, Nombre) values (29, 'China');
insert into destino (IdDestino, Nombre) values (30, 'China');

insert into piloto (dniPiloto, Nombre, Apellido) values (40177679, 'Ichabod', 'Rospars');
insert into piloto (dniPiloto, Nombre, Apellido) values (30829107, 'Neall', 'Mudie');
insert into piloto (dniPiloto, Nombre, Apellido) values (12718017, 'Walden', 'Ralls');
insert into piloto (dniPiloto, Nombre, Apellido) values (45401328, 'Johnathon', 'Moss');
insert into piloto (dniPiloto, Nombre, Apellido) values (40165908, 'Noble', 'Stait');
insert into piloto (dniPiloto, Nombre, Apellido) values (55114050, 'Cullin', 'Woods');
insert into piloto (dniPiloto, Nombre, Apellido) values (85779554, 'Kendal', 'Clemonts');
insert into piloto (dniPiloto, Nombre, Apellido) values (74957492, 'Haslett', 'Biaggioli');
insert into piloto (dniPiloto, Nombre, Apellido) values (36365609, 'Bogey', 'Itzkin');
insert into piloto (dniPiloto, Nombre, Apellido) values (57333761, 'Sollie', 'Rudall');
insert into piloto (dniPiloto, Nombre, Apellido) values (27609940, 'Emmet', 'Yoslowitz');
insert into piloto (dniPiloto, Nombre, Apellido) values (75508916, 'Aylmer', 'Heeran');
insert into piloto (dniPiloto, Nombre, Apellido) values (27910260, 'Hurleigh', 'Causer');
insert into piloto (dniPiloto, Nombre, Apellido) values (48840305, 'Killian', 'Milmoe');
insert into piloto (dniPiloto, Nombre, Apellido) values (71661894, 'Ker', 'Powis');
insert into piloto (dniPiloto, Nombre, Apellido) values (80740553, 'Boony', 'Symon');
insert into piloto (dniPiloto, Nombre, Apellido) values (12690183, 'Terrance', 'Binestead');
insert into piloto (dniPiloto, Nombre, Apellido) values (68956775, 'Olivier', 'O''Doireidh');
insert into piloto (dniPiloto, Nombre, Apellido) values (91151926, 'Xerxes', 'Mundwell');
insert into piloto (dniPiloto, Nombre, Apellido) values (61442839, 'Osbert', 'Weinberg');
insert into piloto (dniPiloto, Nombre, Apellido) values (36060652, 'Cly', 'Nann');
insert into piloto (dniPiloto, Nombre, Apellido) values (82498029, 'Major', 'Teresa');
insert into piloto (dniPiloto, Nombre, Apellido) values (41018977, 'Cully', 'Lowers');
insert into piloto (dniPiloto, Nombre, Apellido) values (44018730, 'Verne', 'Jezzard');
insert into piloto (dniPiloto, Nombre, Apellido) values (31217780, 'Ulberto', 'Garci');
insert into piloto (dniPiloto, Nombre, Apellido) values (74351684, 'Horten', 'Opdenorth');
insert into piloto (dniPiloto, Nombre, Apellido) values (23881037, 'Tabor', 'Cayford');
insert into piloto (dniPiloto, Nombre, Apellido) values (59310641, 'Sayres', 'Bony');
insert into piloto (dniPiloto, Nombre, Apellido) values (89037208, 'Hendrik', 'Tompkins');
insert into piloto (dniPiloto, Nombre, Apellido) values (12703185, 'Griz', 'Ace');


insert into avion(IdAvion, cantAsientos) values(1,50);
insert into avion(IdAvion, cantAsientos) values(2,50);
insert into avion(IdAvion, cantAsientos) values(3,50);
insert into avion(IdAvion, cantAsientos) values(4,50);
insert into avion(IdAvion, cantAsientos) values(5,50);
insert into avion(IdAvion, cantAsientos) values(6,50);
insert into avion(IdAvion, cantAsientos) values(7,50);
insert into avion(IdAvion, cantAsientos) values(8,50);
insert into avion(IdAvion, cantAsientos) values(9,50);
insert into avion(IdAvion, cantAsientos) values(10,50);



insert into cliente (IdCliente, Nombre, Apellido, Mail) values (1, 'Fransisco', 'Harlett', 'fharlett0@photobucket.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (2, 'Jermaine', 'Warstall', 'jwarstall1@scribd.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (3, 'Newton', 'Pouton', 'npouton2@ifeng.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (4, 'Jard', 'McFarlane', 'jmcfarlane3@tripod.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (5, 'Jarad', 'Davidavidovics', 'jdavidavidovics4@cnn.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (6, 'Elvyn', 'Crow', 'ecrow5@imdb.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (7, 'Bryant', 'Bland', 'bbland6@buzzfeed.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (8, 'Baudoin', 'Jennins', 'bjennins7@mapy.cz');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (9, 'Salomone', 'Curwood', 'scurwood8@pinterest.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (10, 'Brion', 'Joynes', 'bjoynes9@marketwatch.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (11, 'Abdel', 'Pawle', 'apawlea@cdbaby.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (12, 'Putnem', 'Stovin', 'pstovinb@ow.ly');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (13, 'Bentlee', 'Aynscombe', 'baynscombec@eventbrite.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (14, 'Aldus', 'Chevers', 'acheversd@epa.gov');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (15, 'Delmer', 'Ciraldo', 'dciraldoe@surveymonkey.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (16, 'Early', 'Giraudot', 'egiraudotf@qq.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (17, 'Leeland', 'Bowers', 'lbowersg@tripod.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (18, 'Erin', 'Rodrig', 'erodrigh@mac.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (19, 'Kristian', 'Ambrosch', 'kambroschi@qq.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (20, 'Even', 'Kiefer', 'ekieferj@tuttocitta.it');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (21, 'Wait', 'Houdhury', 'whoudhuryk@is.gd');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (22, 'Mort', 'Skews', 'mskewsl@gmpg.org');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (23, 'Rossy', 'Goodyear', 'rgoodyearm@biglobe.ne.jp');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (24, 'Vassily', 'Fairall', 'vfairalln@indiegogo.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (25, 'Ty', 'Voce', 'tvoceo@wikia.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (26, 'Gerrard', 'Backes', 'gbackesp@gnu.org');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (27, 'Karlis', 'Corssen', 'kcorssenq@hexun.com');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (28, 'Mikey', 'Winspire', 'mwinspirer@ameblo.jp');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (29, 'Petey', 'Ducker', 'pduckers@unc.edu');
insert into cliente (IdCliente, Nombre, Apellido, Mail) values (30, 'Devlen', 'Bartlomiej', 'dbartlomiejt@admin.ch');


