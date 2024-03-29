create table HISTORIAL(
idhistorial int auto_increment primary key,
descripcion varchar (100) not null,
fecha date not null
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ROL` (
  `id_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `USUARIOS` (
  `idusuarios` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` int(11) NOT NULL,
  `contrasena` varchar(50) NOT NULL,
  `id_rol` int,
  PRIMARY KEY (`idusuarios`,`id_rol`),
  foreign key (id_rol) references ROL (id_rol),
  UNIQUE KEY `idusuarios` (`idusuarios`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into USUARIOS (usuario,contrasena,id_rol)values(1730042,"Rebeca",1);
insert into USUARIOS (usuario,contrasena,id_rol)values(1730123,"Jose",2);

CREATE TABLE `ITEMS` (
  `iditems` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `precio` int(100) NOT NULL,
  `fecha` date DEFAULT NULL,
  `thumb` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`iditems`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

  CREATE TABLE `JUGADORES` (
    `idjugadores` int(11) NOT NULL AUTO_INCREMENT,
    `matricula` varchar(45) NOT NULL,
    `nombre` varchar(45) NOT NULL,
    `apellidos` varchar(200) NOT NULL,
    `equipo` varchar(45) NOT NULL,
    `genero` varchar(45) NOT NULL,
    `vida` int(100) NOT NULL,
    `fantasma` tinyint(1) DEFAULT NULL,
    `idusuarios` int(11) DEFAULT NULL,
    PRIMARY KEY (`idjugadores`),
    UNIQUE KEY `idusuarios` (`idusuarios`),
    CONSTRAINT `JUGADORES_ibfk_1` FOREIGN KEY (`idusuarios`) REFERENCES `USUARIOS` (`idusuarios`)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `INVENTARIO_ITEMS` (
  idinventario int(11) NOT NULL auto_increment,
  idjugadores int,
  iditems int,
  foreign key (iditems) references ITEMS (iditems),
  foreign key (idjugadores) references JUGADORES (idjugadores),
  PRIMARY KEY (idinventario,idjugadores,iditems)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `MISIONES` (
  `id` int(11) auto_increment,
  `nombre` varchar(25) NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  `recompensa` int NOT NULL,
  `fecha` date NOT NULL,
  `idjugadores` int (11),
  PRIMARY KEY (`id`,`idjugadores`),
  foreign key (idjugadores) references JUGADORES (idjugadores)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


create table ASISTENCIA(
idasistencia int auto_increment,
idjugadores int,
total int,
primary key(idasistencia,idjugadores),
foreign key (idjugadores) references JUGADORES (idjugadores)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- stored procedure
 DELIMITER //
 CREATE PROCEDURE Clon_de_sombras(_ID INT(25))
   BEGIN
   UPDATE ASISTENCIA SET total=total+1 WHERE idasistencia=_ID;

   END //
 DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciar_sesion`(_username varchar(32), _pasword varchar(32))
BEGIN

select u.id_rol,u.idusuarios from USUARIOS u where u.usuario = _username and u.contrasena=_pasword;

END$$
DELIMITER ;


DELIMITER //
CREATE PROCEDURE MuertePrematura(_MATRICULA int(20))
 BEGIN

 UPDATE JUGADORES SET vida=vida+1 WHERE fantasma=1 and matricula=_MATRICULA;
 END //
DELIMITER ;

 DELIMITER $$
CREATE PROCEDURE Lagrimas_de_amigos(_NUMERO_DE_EQUIPO INT(25))
BEGIN

   UPDATE JUGADORES SET vida=vida+5 WHERE fantasma=1 and equipo=_NUMERO_DE_EQUIPO;
   END$$
DELIMITER ;

 DELIMITER $$
CREATE PROCEDURE Reloj_de_arena(_ID INT(25))
BEGIN
   UPDATE MISIONES SET fecha=fecha+1  WHERE idjugadores=_ID;

   END$$
DELIMITER ;
 DELIMITER $$
CREATE PROCEDURE teletransportacion_mayor(_ID INT(25),_NUMERO_DE_EQUIPO INT(20))
BEGIN
	 UPDATE JUGADORES SET idjugadores=_ID WHERE equipo=_NUMERO_DE_EQUIPO;

   END$$
DELIMITER ;
 DELIMITER $$
CREATE PROCEDURE teletransportacion_menor(_ID INT(25),_ID1 INT(25))
BEGIN
    UPDATE MISIONES SET idjugadores=_ID1 WHERE idjugadores=_ID;

   END$$
DELIMITER ;

 DELIMITER $$
CREATE PROCEDURE tortura_simple(_ID INT(25),_NUM INT(25))
BEGIN
 UPDATE MISIONES set idjugadores = CAST(RAND() * _NUM AS UNSIGNED) where idjugadores=_ID;
 END$$
DELIMITER ;
--
DELIMITER $$
CREATE PROCEDURE veneno_menor(_ID INT(25),fechactual date)
BEGIN
UPDATE JUGADORES J
INNER JOIN INVENTARIO_ITEMS INV
ON J.idjugadores = INV.idjugadores
INNER JOIN ITEMS I ON I.iditems = INV.iditems SET J.vida=J.vida-1
WHERE J.idjugadores !=_ID AND I.fecha !=fechactual;
  END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE veneno_medio(_NUMERO_DE_EQUIPO INT(20),fechactual date)
BEGIN
UPDATE JUGADORES J
INNER JOIN INVENTARIO_ITEMS INV
ON J.idjugadores = INV.idjugadores
INNER JOIN ITEMS I ON I.iditems = INV.iditems SET J.vida=J.vida-1
WHERE J.equipo !=_NUMERO_DE_EQUIPO AND I.fecha !=fechactual;
  END$$
DELIMITER ;

DELIMITER //
CREATE PROCEDURE historial_ins(_descripcion varchar(100),fechactual date)
  BEGIN
  insert into HISTORIAL (descripcion,fecha) values(_descripcion,fechactual);
  END //
DELIMITER ;
