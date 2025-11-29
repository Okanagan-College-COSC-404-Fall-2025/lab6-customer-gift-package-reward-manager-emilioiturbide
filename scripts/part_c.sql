-- Emilio Iturbide
-- Lab 6 - Part C

-- Create the CUSTOMER_MANAGER package
CREATE OR REPLACE PACKAGE CUSTOMER_MANAGER AS
    FUNCTION GET_TOTAL_PURCHASE(customer_id NUMBER) RETURN NUMBER;
    
    PROCEDURE ASSIGN_GIFTS_TO_ALL;
END CUSTOMER_MANAGER;
/

CREATE OR REPLACE PACKAGE BODY CUSTOMER_MANAGER AS

    FUNCTION GET_TOTAL_PURCHASE(customer_id NUMBER) RETURN NUMBER IS
        v_total_purchase NUMBER;
    BEGIN
        SELECT SUM(OD.UNIT_PRICE * OD.QUANTITY)
        INTO v_total_purchase
        FROM ORDERS O
        LEFT JOIN ORDER_ITEMS OD ON O.ORDER_ID = OD.ORDER_ID
        WHERE O.CUSTOMER_ID = customer_id
          AND O.ORDER_STATUS = 'COMPLETE';
                
        RETURN v_total_purchase;
    END GET_TOTAL_PURCHASE;

    FUNCTION CHOOSE_GIFT_PACKAGE(p_total_purchase NUMBER) RETURN NUMBER IS
        v_gift_id NUMBER;
    BEGIN
        SELECT GIFT_ID
        INTO v_gift_id
        FROM (
            SELECT GIFT_ID, MIN_PURCHASE,
            CASE WHEN MIN_PURCHASE <= p_total_purchase THEN 1 ELSE 0 END AS ELIGIBLE
            FROM GIFT_CATALOG
        )
        WHERE ELIGIBLE = 1
        ORDER BY MIN_PURCHASE DESC
        FETCH FIRST 1 ROW ONLY;
        
        RETURN v_gift_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END CHOOSE_GIFT_PACKAGE;

    PROCEDURE ASSIGN_GIFTS_TO_ALL IS
        CURSOR customers_cursor IS
            SELECT CUSTOMER_ID, EMAIL_ADDRESS
            FROM CUSTOMERS;

        v_total_purchase NUMBER;
        v_gift_id NUMBER;
    BEGIN
        FOR customer IN customers_cursor LOOP
            v_total_purchase := GET_TOTAL_PURCHASE(customer.CUSTOMER_ID);
            v_gift_id := CHOOSE_GIFT_PACKAGE(v_total_purchase);

            IF v_gift_id IS NOT NULL THEN
                INSERT INTO CUSTOMER_REWARDS (CUSTOMER_EMAIL, GIFT_ID, REWARD_DATE)
                VALUES (customer.EMAIL_ADDRESS, v_gift_id, SYSDATE);
            END IF;
        END LOOP;

        COMMIT;
    END ASSIGN_GIFTS_TO_ALL;
END CUSTOMER_MANAGER;
/