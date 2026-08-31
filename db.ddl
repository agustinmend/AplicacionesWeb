CREATE SCHEMA IF NOT EXISTS content;

CREATE TABLE content.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE content.tables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_number INT NOT NULL UNIQUE,
    capacity INT NOT NULL CHECK (capacity > 0),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE content.reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    table_id UUID NOT NULL,
    reservation_time TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')),
    created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reservation_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES content.customers(id) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_reservation_table 
        FOREIGN KEY (table_id) 
        REFERENCES content.tables(id) 
        ON DELETE RESTRICT
);

CREATE TABLE content.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    current_price DECIMAL(10, 2) NOT NULL CHECK (current_price >= 0),
    is_available BOOLEAN NOT NULL DEFAULT true,
    created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE content.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_id UUID NOT NULL,
    customer_id UUID,
    status VARCHAR(30) NOT NULL DEFAULT 'IN_PROGRESS' CHECK (status IN ('IN_PROGRESS', 'SERVED', 'BILLED', 'CANCELLED')),
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (total_amount >= 0),
    created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_table 
        FOREIGN KEY (table_id) 
        REFERENCES content.tables(id) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES content.customers(id) 
        ON DELETE RESTRICT
);

CREATE TABLE content.order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_item_order 
        FOREIGN KEY (order_id) 
        REFERENCES content.orders(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_item_product 
        FOREIGN KEY (product_id) 
        REFERENCES content.products(id) 
        ON DELETE RESTRICT,
    CONSTRAINT uq_order_product 
        UNIQUE (order_id, product_id)
);

CREATE TABLE content.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('CASH', 'CREDIT_CARD', 'QR', 'OTHER')),
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED')),
    created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_order 
        FOREIGN KEY (order_id) 
        REFERENCES content.orders(id) 
        ON DELETE RESTRICT
);

CREATE INDEX customer_created_idx ON content.customers(created);
CREATE INDEX reservations_reservation_time_idx ON content.reservations(reservation_time);
CREATE INDEX orders_created_idx ON content.orders(created);