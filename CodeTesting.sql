/*segunda pregunta*/
/*Genere un programa en PL/SLQ que sea capaz de mostrar los clientes que se
encuentran registrados pero no han realizado compras durante desde julio del 2020.*/
SELECT USUARIO.rut_usuario          AS Rut,
       USUARIO.nombre               AS Nombre,
       USUARIO.codigo_dir_despacho  AS Direccion,
       COMPRA.fecha                 AS Fecha,
       COUNT(*)                     AS Registrado_sin_compra
       
FROM USUARIO
JOIN COMPRA ON compra.rut_usuario = usuario.rut_usuario
JOIN validacion_compra  on compra.codigo_validacion = validacion_compra.codigo_validacion
WHERE NOT EXISTS(select * from compra where compra.rut_usuario = usuario.rut_usuario and compra.fecha >= TO_DATE('01/07/2020', 'DD/MM/YYYY'))
GROUP BY USUARIO.rut_usuario, USUARIO.nombre, USUARIO.codigo_dir_despacho, COMPRA.fecha
ORDER BY compra.fecha

DECLARE
    CURSOR n_cliente IS
    SELECT rut_usuario,nombre,codigo_dir_despacho,fecha FROM
    FROM USUARIO
    JOIN COMPRA ON compra.rut_usuario = usuario.rut_usuario
    JOIN validacion_compra  on compra.codigo_validacion = validacion_compra.codigo_validacion
    WHERE NOT EXISTS(select * from compra where compra.rut_usuario = usuario.rut_usuario and compra.fecha >= TO_DATE('01/07/2020', 'DD/MM/YYYY'))
    GROUP BY rut_usuario, nombre, codigo_dir_despacho, fecha;
    rut_usuario             USUARIO.rut_usuario%TYPE;
    nombre                  USUARIO.nombre%TYPE;
    codigo_dir_despacho     USUARIO.codigo_dir_despacho%TYPE;
    fecha                   USUARIO.fecha%TYPE;
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

DECLARE
    CURSOR n_emprendedor IS
    SELECT  nombre_dueno, fecha, total_ventas 
    FROM EMPRENDEDORES E, COMPRA C, INFORME_EVALUACION IE, PRODUCTO P WHERE
    p.codigo_emprendedor = e.codigo_emprendedor
    AND ie.codigo_informe = p.codigo_informe
    AND c.codigo_producto = p.codigo_producto
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