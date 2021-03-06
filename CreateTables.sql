CREATE TABLE REGION(
    CODIGO_REGION       INTEGER,
    NOMBRE              VARCHAR2(20),
    PRIMARY KEY (CODIGO_REGION)
);
CREATE TABLE CIUDAD (
    CODIGO_CIUDAD       INTEGER,
    CODIGO_REGION       INTEGER,
    NOMBRE              VARCHAR2(20),
    PRIMARY KEY(CODIGO_CIUDAD),
    FOREIGN KEY(CODIGO_REGION) REFERENCES REGION (CODIGO_REGION)
);
CREATE TABLE EMPRESA_REPARTO(
    CODIGO_EMPRESA_REPARTO   INTEGER,
    CODIGO_REGION       INTEGER,
    NOMBRE              VARCHAR2(20),
    PRIMARY KEY(CODIGO_EMPRESA_REPARTO),
    FOREIGN KEY(CODIGO_REGION) REFERENCES REGION(CODIGO_REGION)
);
CREATE TABLE DIRECCIONES_DESPACHO (
    CODIGO_DIR_DESPACHO INTEGER,
    CODIGO_CIUDAD       INTEGER,
    NOMBRE              VARCHAR2(20),
    CALLE               VARCHAR2(100),
    NUMERO              INTEGER,
    PRIMARY KEY(CODIGO_DIR_DESPACHO),
    FOREIGN KEY(CODIGO_CIUDAD) REFERENCES CIUDAD(CODIGO_CIUDAD)
);
CREATE TABLE USUARIO (
    RUT_USUARIO         VARCHAR2(20),
    CODIGO_DIR_DESPACHO INTEGER,
    NOMBRE              VARCHAR(20),
    PRIMARY KEY(RUT_USUARIO),
    FOREIGN KEY(CODIGO_DIR_DESPACHO) REFERENCES DIRECCIONES_DESPACHO(CODIGO_DIR_DESPACHO)
);
CREATE TABLE EMPRENDEDORES (
    CODIGO_EMPRENDEDOR  INTEGER,
    CODIGO_CIUDAD       INTEGER,
    NOMBRE_DUENO        VARCHAR2(20),
    NOMBRE_COMERCIAL    VARCHAR2(30),
    CORREO_ELECTRONICO  VARCHAR2(50),
    INSTAGRAM           VARCHAR2(30),
    FACEBOOK            VARCHAR2(30),
    PRIMARY KEY(CODIGO_EMPRENDEDOR),
    FOREIGN KEY(CODIGO_CIUDAD) REFERENCES CIUDAD(CODIGO_CIUDAD)
);
CREATE TABLE MEDIO_PAGO (
    CODIGO_MEDIO_PAGO   INTEGER,
    MEDIO_PAGO          VARCHAR2(20),
    PRIMARY KEY (CODIGO_MEDIO_PAGO)
);
CREATE TABLE INFORME_EVALUACION (
    CODIGO_INFORME          INTEGER,
    TOTAL_VENTAS            INTEGER,
    EVALUACIONES            INTEGER,
    PRIMARY KEY(CODIGO_INFORME)
);

CREATE TABLE PRODUCTO (
    CODIGO_PRODUCTO     INTEGER,
    CODIGO_EMPRENDEDOR  INTEGER,
    CODIGO_INFORME      INTEGER,
    NOMBRE              VARCHAR2(100),
    UNIDAD_DE_MEDIDA    VARCHAR2(20),
    VALOR_UNIDAD        INTEGER,
    STOCK               INTEGER,
    PRIMARY KEY(CODIGO_PRODUCTO),
    FOREIGN KEY(CODIGO_EMPRENDEDOR) REFERENCES EMPRENDEDORES(CODIGO_EMPRENDEDOR),
    FOREIGN KEY(CODIGO_INFORME)  REFERENCES INFORME_EVALUACION(CODIGO_INFORME)
);
CREATE TABLE VALIDACION_COMPRA(
    CODIGO_VALIDACION   INTEGER,
    ESTADO_COMPRA       VARCHAR2(20),
    PRIMARY KEY(CODIGO_VALIDACION)
);
CREATE TABLE COMPRA (
    CODIGO_COMPRA       INTEGER,
    RUT_USUARIO         VARCHAR2(20),
    CODIGO_MEDIO_PAGO   INTEGER,    
    CODIGO_PRODUCTO     INTEGER,
    CODIGO_VALIDACION   INTEGER,
    CANTIDAD            INTEGER,
    FECHA               DATE,
    PRIMARY KEY(CODIGO_COMPRA),
    FOREIGN KEY(RUT_USUARIO) REFERENCES USUARIO(RUT_USUARIO),
    FOREIGN KEY(CODIGO_MEDIO_PAGO) REFERENCES MEDIO_PAGO(CODIGO_MEDIO_PAGO),
    FOREIGN KEY(CODIGO_PRODUCTO) REFERENCES PRODUCTO(CODIGO_PRODUCTO),
    FOREIGN KEY(CODIGO_VALIDACION) REFERENCES VALIDACION_COMPRA(CODIGO_VALIDACION)
);


CREATE TABLE EVALUACION(
    CODIGO_EVALUACION   INTEGER,
    CODIGO_COMPRA       INTEGER,
    NOTA                INTEGER,
    COMENTARIO          VARCHAR(300),
    PRIMARY KEY(CODIGO_EVALUACION),
    FOREIGN KEY(CODIGO_COMPRA) REFERENCES COMPRA(CODIGO_COMPRA)
);

CREATE TABLE DESPACHO (
    CODIGO_DESPACHO             INTEGER,
    CODIGO_EMPRESA_REPARTO      INTEGER,
    CODIGO_COMPRA               INTEGER,
    FECHA_ENTREGA_PROGRAMADA    DATE,
    FECHA_ENTREGA_REAL          DATE,
    CODIGO_DIR_DESPACHO         INTEGER,
    PRIMARY KEY(CODIGO_DESPACHO),
    FOREIGN KEY(CODIGO_EMPRESA_REPARTO) REFERENCES EMPRESA_REPARTO(CODIGO_EMPRESA_REPARTO),
    FOREIGN KEY(CODIGO_COMPRA) REFERENCES COMPRA(CODIGO_COMPRA),
    FOREIGN KEY(CODIGO_DIR_DESPACHO) REFERENCES DIRECCIONES_DESPACHO(CODIGO_DIR_DESPACHO)
);
