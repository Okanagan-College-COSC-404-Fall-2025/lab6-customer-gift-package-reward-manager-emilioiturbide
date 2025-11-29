-- Emilio Iturbide
-- Lab 6 - Part D

SET SERVEROUTPUT ON;

-- Test the package by calling the ASSIGN_GIFTS_TO_ALL procedure.
BEGIN
    CUSTOMER_MANAGER.ASSIGN_GIFTS_TO_ALL;
END;
/

-- Implement a procedure that joins the CUSTOMER_REWARDS and 
-- GIFT_CATALOG tables and displays the results for the first 
-- five customers.
DECLARE
    CURSOR rewards_cursor IS
        SELECT CR.CUSTOMER_EMAIL, GC.GIFTS
        FROM CUSTOMER_REWARDS CR
        JOIN GIFT_CATALOG GC ON CR.GIFT_ID = GC.GIFT_ID
        FETCH FIRST 5 ROWS ONLY;
        
    v_gifts gift_item_table;
BEGIN
    FOR reward_record IN rewards_cursor LOOP
        v_gifts := reward_record.GIFTS;
        DBMS_OUTPUT.PUT_LINE('Customer Email: ' || reward_record.CUSTOMER_EMAIL);
        DBMS_OUTPUT.PUT('Gifts: ');
        
        FOR i IN 1 .. v_gifts.COUNT LOOP
            DBMS_OUTPUT.PUT(v_gifts(i));
            IF i < v_gifts.COUNT THEN
                DBMS_OUTPUT.PUT(', ');
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;
/