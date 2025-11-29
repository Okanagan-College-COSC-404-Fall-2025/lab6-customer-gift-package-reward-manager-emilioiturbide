-- Emilio Iturbide
-- Lab 6 - Part A

-- Drop existing objects if they exist
DROP PACKAGE IF EXISTS CUSTOMER_MANAGER;
DROP TABLE IF EXISTS CUSTOMER_REWARDS PURGE;
DROP TABLE IF EXISTS GIFT_CATALOG PURGE;
DROP TYPE IF EXISTS gift_item_table;
/

-- Create the GIFT_CATALOG table and the nested table type for gifts
CREATE OR REPLACE TYPE gift_item_table
AS
TABLE OF VARCHAR2(100);
/

CREATE TABLE GIFT_CATALOG (
    GIFT_ID NUMBER PRIMARY KEY,
    MIN_PURCHASE NUMBER,
    GIFTS gift_item_table
) NESTED TABLE GIFTS STORE AS GIFT_ITEMS_NT;

INSERT INTO GIFT_CATALOG (GIFT_ID, MIN_PURCHASE, GIFTS) VALUES (
    1, 100, gift_item_table('Stickers', 'Pen Set')
);
INSERT INTO GIFT_CATALOG (GIFT_ID, MIN_PURCHASE, GIFTS) VALUES (
    2, 1000, gift_item_table('Teddy Bear', 'Perfume')
);
INSERT INTO GIFT_CATALOG (GIFT_ID, MIN_PURCHASE, GIFTS) VALUES (
    3, 10000, gift_item_table('Backpack', 'Thermos Bottle', 'Chocolate Collection')
);
COMMIT;
