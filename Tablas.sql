--

CREATE TABLE Productos (
  IdProducto int,
  nombre varchar(32),
  PRIMARY KEY (IdProducto)
);

CREATE TABLE Calle (
  IdCalle int,
  Numero varchar(32),
  ubicacion geometry,
  PRIMARY KEY (IdCalle)
);

CREATE TABLE TipoComercio (
  IdTipoComercio int,
  nombre varchar(32),
  horario apertura Time,
  horario cierre Time,
  PRIMARY KEY (IdTipoComercio)
);

CREATE TABLE Comercios (
  IdComercio int,
  IdTipo int,
  nombre varchar(32),
  numero varchar(32),
  ubicacion geometry,
  PRIMARY KEY (IdComercio),
  CONSTRAINT FK_Comercios.IdTipo
    FOREIGN KEY (IdTipo)
      REFERENCES TipoComercio(IdTipoComercio)
);

CREATE TABLE Casas (
  IdCasa int,
  numero varchar(32),
  ubicacion geometry,
  PRIMARY KEY (IdCasa)
);

CREATE TABLE Inventario (
  IdComercio int,
  IdProducto int,
  cantidad int,
  precio money,
  CONSTRAINT FK_InventarioIdComercio
  FOREIGN KEY (IdComercio)
  REFERENCES Comercios(IdComercio),

  CONSTRAINT FK_InventarioIdProducto
  FOREIGN KEY (IdProducto)
  REFERENCES Productos(IdProducto)
);

