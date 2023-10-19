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
