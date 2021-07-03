/*cuarta pregunta*/
/*Genere un trigger que al momento de generar el despacho, la compra se debe
encontrar en estado pagada, de lo contrario enviar un error y no permitir el ingreso del
despacho.*/
CREATE OR REPLACE TRIGGER generacion_despacho
    BEFORE INSERT ON DESPACHO
    FOR EACH ROW 
DECLARE
    CODIGO_DESPACHO             INTEGER     :=:NEW.monto_carga_GCL;
    CODIGO_EMPRESA_REPARTO      INTEGER     :=:NEW.monto_carga_GCL;
    CODIGO_COMPRA               INTEGER     :=:NEW.monto_carga_GCL;
    FECHA_ENTREGA_PROGRAMADA    DATE        :=:NEW.monto_carga_GCL;
    FECHA_ENTREGA_REAL          DATE        :=:NEW.monto_carga_GCL;
    CODIGO_DIR_DESPACHO         INTEGER     :=:NEW.monto_carga_GCL;
    ESTADO_COMPRA               VALIDACION_COMPRA.ESTADO_COMPRA%TYPE;
BEGIN
    ESTADO_COMPRA = SELECT VALIDACION_COMPRA.ESTADO_COMPRA
    FROM COMPRA, VALIDACION_COMPRA 
    WHERE COMPRA.CODIGO_VALIDACION = VALIDACION_COMPRA.CODIGO_VALIDACION;
    IF ESTADO_COMPRA != 'Confirmada' THEN
        RAISE_APPLICATION_ERROR(-20090, 'El pago de la compra no fue confirmado o fue cancelado');
    END IF;
END;
