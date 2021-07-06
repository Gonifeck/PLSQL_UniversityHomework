/*Primera pregunta*/
/*Genere un programa en PL/SLQ que sea capaz de mostrar el nombre de los
emprendedores que han tenido el mayor numero de ventas durante el mes de septiembre*/

DECLARE
    CURSOR n_emprendedor IS
    SELECT  nombre_dueno, fecha, total_ventas 
    FROM EMPRENDEDORES 
    JOIN PRODUCTO               ON producto.codigo_emprendedor = emprendedores.codigo_emprendedor
    JOIN INFORME_EVALUACION     ON informe_evaluacion.codigo_informe = producto.codigo_informe
    JOIN COMPRA                  ON compra.codigo_producto = producto.codigo_producto 
    WHERE EXTRACT(MONTH FROM COMPRA.fecha) = 09
    GROUP BY nombre_dueno, fecha, total_ventas;
    nombre_dueno    EMPRENDEDORES.nombre_dueno%TYPE;
    fecha           COMPRA.fecha%TYPE;
    total_ventas    INFORME_EVALUACION.total_ventas%TYPE;
BEGIN
    open n_emprendedor;
    fetch n_emprendedor into nombre_dueno, fecha, total_ventas;
    while n_emprendedor%found
        LOOP
            dbms_output.put_line(nombre_dueno||' | '|| fecha ||' | '||total_ventas);
            fetch n_emprendedor into nombre_dueno, fecha, total_ventas;
        END LOOP;
    close n_emprendedor;
END;

/*segunda pregunta*/
/*Genere un programa en PL/SLQ que sea capaz de mostrar los clientes que se
encuentran registrados pero no han realizado compras durante desde julio del 2020.*/
DECLARE
    CURSOR n_cliente IS
    SELECT USUARIO.rut_usuario, USUARIO.nombre, USUARIO.codigo_dir_despacho, COMPRA.fecha
    FROM USUARIO
    JOIN COMPRA ON COMPRA.rut_usuario = USUARIO.rut_usuario 
    WHERE NOT EXISTS(select * from compra where compra.rut_usuario = usuario.rut_usuario and compra.fecha >= TO_DATE('01/07/2020', 'DD/MM/YYYY'))
    GROUP BY USUARIO.rut_usuario, USUARIO.nombre, USUARIO.codigo_dir_despacho, COMPRA.fecha;
    rut_usuario            USUARIO.rut_usuario%TYPE;
    nombre                  USUARIO.nombre%TYPE;
    codigo_dir_despacho     USUARIO.codigo_dir_despacho%TYPE;
    fecha                   COMPRA.fecha%TYPE;
BEGIN
    open n_cliente;
    fetch n_cliente into rut_usuario, nombre, codigo_dir_despacho, fecha;
    while n_cliente%found
        LOOP
            dbms_output.put_line(rut_usuario||' | '|| nombre ||' | '|| codigo_dir_despacho ||' | '|| fecha);
            fetch n_cliente into rut_usuario, nombre, codigo_dir_despacho, fecha;
        END LOOP;
    close n_cliente;
END;

/*tercera pregunta*/
/*Crear un trigger que genere el codigo para cada direccion registrada por los
clientes. Este codigo debe ser unico.*/
CREATE OR REPLACE TRIGGER direccion_registrada
    BEFORE INSERT ON DIRECCIONES_DESPACHO
    FOR EACH ROW 
DECLARE
    CODIGO_DIR_DESPACHO INTEGER :=:NEW.CODIGO_DIR_DESPACHO;
BEGIN
    CODIGO_DIR_DESPACHO = SELECT count(*) FROM DIRECCIONES_DESPACHO;
    dbms_output.put_line(CODIGO_DIR_DESPACHO);
END;

/*cuarta pregunta*/
/*Genere un trigger que al momento de generar el despacho, la compra se debe
encontrar en estado pagada, de lo contrario enviar un error y no permitir el ingreso del
despacho.*/
CREATE OR REPLACE TRIGGER generacion_despacho
    BEFORE INSERT ON DESPACHO
    FOR EACH ROW 
DECLARE
    CODIGO_DESPACHO             INTEGER     :=:NEW.CODIGO_DESPACHO;
    CODIGO_EMPRESA_REPARTO      INTEGER     :=:NEW.CODIGO_EMPRESA_REPARTO;
    CODIGO_COMPRA               INTEGER     :=:NEW.CODIGO_COMPRA;
    FECHA_ENTREGA_PROGRAMADA    DATE        :=:NEW.FECHA_ENTREGA_PROGRAMADA;
    FECHA_ENTREGA_REAL          DATE        :=:NEW.FECHA_ENTREGA_REAL;
    CODIGO_DIR_DESPACHO         INTEGER     :=:NEW.CODIGO_DIR_DESPACHO;
    ESTADO_COMPRA               VALIDACION_COMPRA.ESTADO_COMPRA%TYPE;
BEGIN
    ESTADO_COMPRA = SELECT VALIDACION_COMPRA.ESTADO_COMPRA
    FROM COMPRA, VALIDACION_COMPRA 
    WHERE COMPRA.CODIGO_VALIDACION = VALIDACION_COMPRA.CODIGO_VALIDACION;
    IF ESTADO_COMPRA != 'Confirmada' THEN
        RAISE_APPLICATION_ERROR(-20090, 'El pago de la compra no fue confirmado o fue cancelado');
    END IF;
END;

/*pregunta cinco*/
/*Genere un trigger que actualice el stock disponible de el o los productos, una
vez que la compra haya sido registrada.*/
CREATE OR REPLACE TRIGGER actualizacion_stock
    BEFORE INSERT OR UPDATE ON COMPRA
    FOR EACH ROW
DECLARE
    CODIGO_COMPRA       INTEGER         :=:NEW.CODIGO_PRODUCTO;
    RUT_USUARIO         VARCHAR2(20)    :=:NEW.RUT_USUARIO;
    CODIGO_MEDIO_PAGO   INTEGER         :=:NEW.CODIGO_MEDIO_PAGO;
    CODIGO_PRODUCTO     INTEGER         :=:NEW.CODIGO_PRODUCTO;
    CODIGO_VALIDACION   INTEGER         :=:NEW.CODIGO_VALIDACION;
    CANTIDAD            INTEGER         :=:NEW.CANTIDAD;
    FECHA               DATE            :=:NEW.FECHA;
    STOCK_PRODUCTO               PRODUCTO.STOCK%TYPE;
BEGIN
    SELECT PRODUCTO.STOCK
    INTO STOCK_PRODUCTO
    WHERE PRODUCTO.CODIGO_PRODUCTO = COMPRA.CODIGO_PRODUCTO;

    IF STOCK_PRODUCTO > 0 THEN
        UPDATE PRODUCTO
        SET PRODUCTO.STOCK = (STOCK_PRODUCTO-1)
        WHERE PRODUCTO.CODIGO_PRODUCTO = COMPRA.CODIGO_PRODUCTO;
    ELSE
        RAISE_APPLICATION_ERROR(-20090, 'No hay stock disponible');
    END IF;
END;
