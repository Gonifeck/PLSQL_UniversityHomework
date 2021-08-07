/*Primera pregunta*/
/*Crear un procedimiento almacenado que permita mostrar el cuadro de honor
de los emprendedores que han recibido las mejores evaluaciones de sus productos, considerando
en el nivel Oro, quienes han recibido en promedio nota 6.5 o mas. Para el
nivel Plata con nota promedio entre 6.4 y 6 inclusive. Para nivel Bronce 5.9 y 5.,5 ambos
inlusive. Se debe recibir por parametro el mes a evaluar. */

CREATE OR REPLACE PROCEDURE cuadro_de_honor 
    (MES_HONOR IN COMPRA.FECHA%TYPE) 
IS
    CURSOR c_emprendedor IS
    SELECT EMPRENDEDORES.NOMBRE_DUENO, INFORME_EVALUACION.EVALUACIONES
    FROM EMPRENDEDORES, PRODUCTO, COMPRA, VALIDACION_COMPRA, INFORME_EVALUACION
    WHERE EMPRENDEDORES.CODIGO_EMPRENDEDOR = PRODUCTO.CODIGO_EMPRENDEDOR 
        AND PRODUCTO.CODIGO_PRODUCTO = COMPRA.CODIGO_PRODUCTO
        AND COMPRA.CODIGO_VALIDACION = VALIDACION_COMPRA.CODIGO_VALIDACION
        AND PRODUCTO.CODIGO_INFORME = INFORME_EVALUACION.CODIGO_INFORME
        AND VALIDACION_COMPRA.ESTADO_COMPRA = 'Confirmada'
        AND EXTRACT(MONTH FROM COMPRA.FECHA) = EXTRACT(MONTH FROM MES_HONOR)
    GROUP BY EMPRENDEDORES.NOMBRE_DUENO, INFORME_EVALUACION.EVALUACIONES
    ORDER BY INFORME_EVALUACION.EVALUACIONES DESC;

    nombre_t            EMPRENDEDORES.NOMBRE_DUENO%TYPE;
    evaluacion_t        FLOAT;
    nivel               INTEGER := 0;

BEGIN
    open c_emprendedor;
    fetch c_emprendedor into nombre_t, evaluacion_t;
    while c_emprendedor%found
        LOOP
            CASE 
                WHEN evaluacion_t >= 6.5 THEN
                    dbms_output.put_line('Emprededor de oro: ' || nombre_t || ' con un promedio de evaluacion de ' || evaluacion_t);
                WHEN evaluacion_t <  6.5 and evaluacion_t >= 6.0 THEN
                    dbms_output.put_line('Emprededor de plata: ' || nombre_t || ' con un promedio de evaluacion de ' || evaluacion_t);
                WHEN evaluacion_t <  6.0 and evaluacion_t >= 5.5 THEN
                    dbms_output.put_line('emprendedor de bronce: ' || nombre_t || ' con un promedio de evaluacion de ' || evaluacion_t);
            END CASE;
            fetch c_emprendedor into nombre_t, evaluacion_t;
        END LOOP;
    close c_emprendedor;
END;

EXECUTE cuadro_de_honor(TO_DATE('17/12/2020','DD/MM/YYYY'));

/*Segunda pregunta*/
/*Crear un procedimiento almacenado que permita cambiar el estado de todas
las compras que llevan mas de 30 dias en estado registrada por eliminada.*/

CREATE OR REPLACE PROCEDURE compra_eliminar 
IS
    CURSOR c_compra IS
    SELECT COMPRA.FECHA, VALIDACION_COMPRA.ESTADO_COMPRA, VALIDACION_COMPRA.CODIGO_VALIDACION
    FROM COMPRA, VALIDACION_COMPRA
    WHERE COMPRA.CODIGO_VALIDACION = VALIDACION_COMPRA.CODIGO_VALIDACION
        AND VALIDACION_COMPRA.ESTADO_COMPRA = 'Pendiente'
    GROUP BY COMPRA.FECHA, VALIDACION_COMPRA.ESTADO_COMPRA, VALIDACION_COMPRA.CODIGO_VALIDACION;

    fecha_t                 COMPRA.FECHA%TYPE;
    validacion_t            VALIDACION_COMPRA.ESTADO_COMPRA%TYPE;
    codigo_validacion_t     VALIDACION_COMPRA.CODIGO_VALIDACION%TYPE;

BEGIN
    open c_compra;
    fetch c_compra into fecha_t, validacion_t, codigo_validacion_t;
    while c_compra%found
        LOOP
            IF (TO_DATE(CURRENT_DATE(), 'dd/mm/yyyy') - TO_DATE(fecha_t, 'dd/mm/yyyy')) > 30 THEN
                UPDATE VALIDACION_COMPRA
                SET ESTADO_COMPRA = 'Cancelado'
                WHERE CODIGO_VALIDACION = codigo_validacion_t;
            END IF;
            fetch c_compra into fecha_t, validacion_t, codigo_validacion_t;
        END LOOP;
    close c_compra;
END;

EXECUTE compra_eliminar;

/*tercera pregunta*/
/*El sistema debe contar con tres usuarios, identifiquelos segun el enunciado y
defina los permisos necesarios para cada uno de ellos.*/


-- ROLE EMPRENDEDOR
CREATE ROLE emprendedor
GRANT ALTER ON PRODUCTO TO emprendedor
GRANT ALTER ON EMPRENDEDORES TO emprendedor
GRANT CREATE SESSION TO emprendedor

-- DROP
DROP ROLE emprendedor

-- ROLE USUARIO
CREATE ROLE usuario
GRANT ALTER ON DIRECCIONES_DESPACHO TO usuario
GRANT ALTER ON USUARIO TO usuario
GRANT CREATE SESSION TO usuario

-- DROP
DROP ROLE usuario

-- ROLE EMPRESA REPARTO
CREATE ROLE empresa_reparto
GRANT ALTER ON DESPACHO TO empresa_reparto
GRANT ALTER ON EMPRESA_REPARTO TO empresa_reparto
GRANT CREATE SESSION TO empresa_reparto

-- DROP
DROP ROLE empresa_reparto

-- CREATE USER

-- CREATE EMPRENDEDOR
CREATE USER emprendedor_juan IDENTIFIED BY patata
GRANT emprendedor TO emprendedor_juan

-- CREATE USUARIO
CREATE USER usuario_pancho IDENTIFIED BY patata1
GRANT usuario TO usuario_pancho

-- CREATE EMPRESA REPARTO
CREATE USER empresa_ricardo IDENTIFIED BY patata2
GRANT empresa_reparto TO empresa_ricardo


/*cuarta pregunta*/
/*De acuerdo a todo lo planteado en este enunciado (parte I y II), defina dos
indices que permita mejorar el rendimiento de esta Base de Datos.*/

/*dado el frecuente uso de la clase productos y compra, podemos crear 
indices que agilicen su funcionamiento, de esta forma acelerar el proceso de 
llamada y respuesta de nuestra base de datos.*/