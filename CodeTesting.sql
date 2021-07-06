/*tercera pregunta*/
/*Crear un trigger que genere el codigo para cada direccion registrada por los
clientes. Este codigo debe ser unico.*/
CREATE OR REPLACE TRIGGER direccion_registrada
    BEFORE INSERT ON DIRECCIONES_DESPACHO
    FOR EACH ROW 
DECLARE
    CODIGO_DIR_DESPACHO INTEGER         :=:NEW.CODIGO_DIR_DESPACHO;
    CODIGO_CIUDAD       INTEGER         :=:NEW.CODIGO_CIUDAD;
    NOMBRE              VARCHAR2(20)    :=:NEW.NOMBRE;
    CALLE               VARCHAR2(100)   :=:NEW.CALLE;
    NUMERO              INTEGER         :=:NEW.NUMERO;
    CODIGO_DIR_DESPACHO INTEGER;
BEGIN
    CODIGO_DIR_DESPACHO = CODIGO_DIR_DESPACHO + SELECT count(*) FROM DIRECCIONES_DESPACHO;
END;