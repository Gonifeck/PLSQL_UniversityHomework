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
