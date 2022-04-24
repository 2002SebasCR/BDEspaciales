CREATE TABLE productos (
  IdProducto int identity,
  nombre varchar(32),
  PRIMARY KEY (IdProducto)
);

CREATE TABLE calle (
  IdCalle int identity,
  Numero varchar(32),
  ubicacion geometry,
  PRIMARY KEY (IdCalle)
);

CREATE TABLE tipoComercio (
  IdTipoComercio int identity,
  nombre varchar(32),
  horario_apertura Time,
  horario_cierre Time,
  PRIMARY KEY (IdTipoComercio)
);

CREATE TABLE comercios (
  IdComercio int identity,
  IdTipo int,
  nombre varchar(32),
  numero varchar(32),
  ubicacion geometry,
  PRIMARY KEY (IdComercio),

  CONSTRAINT FK_ComerciosIdTipo
  FOREIGN KEY (IdTipo)
  REFERENCES tipoComercio(IdTipoComercio)
);

CREATE TABLE casas (
  IdCasa int identity,
  numero varchar(32),
  ubicacion geometry,
  PRIMARY KEY (IdCasa)
);

CREATE TABLE inventario (
  IdComercio int,
  IdProducto int,
  cantidad int,
  precio money,
  CONSTRAINT FK_InventarioIdComercio
  FOREIGN KEY (IdComercio)
  REFERENCES comercios(IdComercio),

  CONSTRAINT FK_InventarioIdProducto
  FOREIGN KEY (IdProducto)
  REFERENCES productos(IdProducto)
);