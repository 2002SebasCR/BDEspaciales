CREATE TABLE ciudad (
    idCiudad int identity,
    nombre varchar(32)
    PRIMARY KEY (idCiudad)
);

CREATE TABLE producto (
    idProducto int identity,
    nombre varchar(32),
    PRIMARY KEY (idProducto)
);

CREATE TABLE calle (
    idCalle int identity,
    idCiudad int,
    Numero varchar(32),
    ubicacion geometry,
    PRIMARY KEY (idCalle),
    CONSTRAINT FK_CalleIdCiudad
    FOREIGN KEY (idCiudad)
    REFERENCES ciudad(idCiudad),
);

CREATE TABLE tipoComercio (
    idTipoComercio int identity,
    nombre varchar(32),
    horario_apertura Time,
    horario_cierre Time,
    PRIMARY KEY (idTipoComercio)
);

CREATE TABLE comercio (
    idComercio int identity,
    idTipo int,
    idCiudad int,
    nombre varchar(32),
    numero varchar(32),
    ubicacion geometry,
    PRIMARY KEY (idComercio),
    CONSTRAINT FK_ComercioIdCiudad
    FOREIGN KEY (idCiudad)
    REFERENCES ciudad(idCiudad),

    CONSTRAINT FK_ComerciosIdTipo
    FOREIGN KEY (idTipo)
    REFERENCES tipoComercio(idTipoComercio)
);

CREATE TABLE casa (
    idCasa int identity,
    idCiudad int,
    numero varchar(32),
    ubicacion geometry,
    PRIMARY KEY (idCasa),
    CONSTRAINT FK_CasaIdCiudad
    FOREIGN KEY (idCiudad)
    REFERENCES ciudad(idCiudad),
);

CREATE TABLE inventario (
    idComercio int,
    idProducto int,
    cantidad int,
    precio money,
    CONSTRAINT FK_InventarioIdComercio
    FOREIGN KEY (idComercio)
    REFERENCES comercio(idComercio),

    CONSTRAINT FK_InventarioIdProducto
    FOREIGN KEY (idProducto)
    REFERENCES producto(idProducto)
);