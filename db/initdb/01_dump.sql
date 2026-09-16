--
-- PostgreSQL database dump
--

\restrict pz94lTKNaveHdJR59uAADB6zbaJw8WfEGvJt8XcJktkBz2LWdpRbYfOKA5zO01I

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: content; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA content;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: customers; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(150),
    phone character varying(20) NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: order_items; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


--
-- Name: orders; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    table_id uuid NOT NULL,
    customer_id uuid,
    status character varying(30) DEFAULT 'IN_PROGRESS'::character varying NOT NULL,
    total_amount numeric(10,2) DEFAULT 0.00 NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['IN_PROGRESS'::character varying, 'SERVED'::character varying, 'BILLED'::character varying, 'CANCELLED'::character varying])::text[]))),
    CONSTRAINT orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


--
-- Name: payments; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_method character varying(50) NOT NULL,
    status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT payments_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT payments_payment_method_check CHECK (((payment_method)::text = ANY ((ARRAY['CASH'::character varying, 'CREDIT_CARD'::character varying, 'QR'::character varying, 'OTHER'::character varying])::text[]))),
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying])::text[])))
);


--
-- Name: products; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    current_price numeric(10,2) NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    category_id uuid NOT NULL,
    CONSTRAINT products_current_price_check CHECK ((current_price >= (0)::numeric))
);


--
-- Name: reservations; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.reservations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    table_id uuid NOT NULL,
    reservation_time timestamp with time zone NOT NULL,
    status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reservations_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'CONFIRMED'::character varying, 'CANCELLED'::character varying, 'COMPLETED'::character varying])::text[])))
);


--
-- Name: tables; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    table_number integer NOT NULL,
    capacity integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tables_capacity_check CHECK ((capacity > 0))
);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.categories (id, name, description, created, modified) FROM stdin;
0f7aebf2-f4d5-4d24-b2a6-ae33a6f1d178	Appetizers	Starters and small dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
710e7f8e-fc0e-4e31-a351-9e1ff6b844c4	Salads	Fresh salads and vegetables	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
96526bf4-fd5c-4c73-bc60-98a12392b05d	Soups	Soups and broths	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
2c23a3bd-bf73-4593-8df0-4deadde507b0	Burgers	Hamburgers and burger meals	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
fd11af55-3b2f-4448-abb0-5bca763c7ec6	Pizzas	Different types of pizzas	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
c4136a9f-8c90-41f9-b78d-3c9b42ad5891	Pasta	Pasta dishes and Italian specialties	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
646a9069-a07b-4a40-8582-5dfd3a9d9e1a	Sandwiches	Sandwiches and baguettes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
6068e937-200e-4440-8645-1000355131fa	Tacos	Tacos and Mexican-style dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
ee6e9380-42cf-4b45-9990-77ed4cee3362	Chicken	Chicken-based dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
7c71932f-6d83-41b0-8675-65c30058cfce	Beef	Beef-based dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
24051b82-ee81-44d3-8431-21c79a6de38b	Pork	Pork-based dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
158099f1-4154-4e3d-a1d5-f172fd58747a	Seafood	Fish and seafood dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
ffada9fd-cce5-4c54-9db8-3fde536d992d	Rice	Rice-based dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
6a82efaa-055a-437f-81ed-64e7f53726f5	Side Dishes	Accompaniments and side dishes	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
ce1af85b-ebd8-4d9c-a517-ec54b26b9670	Desserts	Sweet dishes and desserts	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
c1a3bf6c-4691-4f87-8546-8ffe86b08568	Ice Cream	Ice cream and frozen desserts	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
4aebb4ea-cc29-4b74-af6f-a1a93691c59d	Soft Drinks	Carbonated and non-alcoholic beverages	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
da7befc6-3381-4642-90fd-9ad2e717cfa1	Juices	Natural and fruit juices	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
a89adc9f-53b3-4667-83c7-efe7d307418e	Coffee	Coffee and hot coffee beverages	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
729bf46c-df80-4094-8d9b-5b8ee4f729fc	Tea	Tea and herbal infusions	2026-09-02 00:44:46.751681+00	2026-09-02 00:44:46.751681+00
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.customers (id, first_name, last_name, email, phone, created, modified) FROM stdin;
2831efd0-fb42-4999-aecb-ba96da720989	Richard	Smith	customer1@example.com	+15509519132	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
23d44be1-cefe-4bad-8f5f-39c5ae3658b1	David	Johnson	customer2@example.com	+18212910042	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9097d28d-80c6-4887-8d2d-d753c26de181	Michael	Garcia	customer3@example.com	+17415291538	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
404e85bd-882d-485e-b18b-0b0825a444e0	John	Martinez	customer4@example.com	+14234282689	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
06ef2fdf-eb16-4c0c-ae32-f7b634017521	Patricia	Miller	customer5@example.com	+16005023146	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
bb25281b-0077-4cf4-b2e7-f6b330f124bb	William	Jones	customer6@example.com	+14143187659	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
19dceb56-9eed-4737-be24-46fd35f96db1	Susan	Lopez	customer7@example.com	+11426099896	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6addb38e-b830-4f10-8973-1102896c18d6	Jessica	Jackson	customer8@example.com	+18330929542	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e8aac858-045f-4bba-aa54-f578b4b6abce	Jennifer	Lopez	customer9@example.com	+17925333184	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a58c6487-9492-4b75-9038-d6192cd2eb83	David	Garcia	customer10@example.com	+15895414006	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
358f99bb-40b6-4c71-8db1-a897526337a0	James	Brown	customer11@example.com	+15171028985	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9cc0d06f-3a2b-4e67-9fb6-e880be3bf699	Karen	Lopez	customer12@example.com	+13012017959	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
1a4ed97b-7fc7-4575-b924-b5b6735721a4	Elizabeth	Smith	customer13@example.com	+19911315567	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
d6259d11-53b2-48f0-99f4-8291b1315f30	Mary	Anderson	customer14@example.com	+12649820168	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
43310204-7b5e-4d62-b08d-4501f8cc3738	Barbara	Garcia	customer15@example.com	+14511311371	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5f250384-fff8-4583-90d0-6c8cc1d8b6c4	William	Garcia	customer16@example.com	+16763540727	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
12b7ac88-7b3a-423b-a28a-6c95a93cf860	Jennifer	Wilson	customer17@example.com	+12824163898	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8c4ddd44-4e84-4a85-b42e-ae047e6f14de	Mary	Garcia	customer18@example.com	+13791848995	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
bf7e3fda-a7ff-48db-a558-4c4b8670c50a	John	Lopez	customer19@example.com	+12256971496	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
789c5d5b-4a48-4c9b-b42b-812ec235c3a9	William	Jackson	customer20@example.com	+17810033313	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2c3f5be1-67c6-40c3-b14d-f802e2ac36c6	Linda	Smith	customer21@example.com	+12049745460	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b805fd2e-4fae-4bdc-82fb-71313cf7fc67	Michael	Thomas	customer22@example.com	+13874394283	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b6a1114f-889e-4992-bf81-69a26bc20c0d	Elizabeth	Brown	customer23@example.com	+15664084184	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4cc64573-8586-4e56-aa6f-73082f6cf75c	David	Brown	customer24@example.com	+14849645019	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c5981b0b-5054-4b0e-bc46-0301c17eed87	Richard	Moore	customer25@example.com	+13233486114	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9e8ca6b3-b51c-4d07-8f1a-d339094e3cb6	Robert	Moore	customer26@example.com	+13211217622	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0065ad06-6c63-4e6d-8233-3ea952fd2a28	Linda	Wilson	customer27@example.com	+15488997956	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
bfb9f4a5-d84c-41a1-a28d-624093f62ce4	Joseph	Davis	customer28@example.com	+13507316669	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0a983262-8aa7-4757-8f58-d5d33526b924	Jessica	Miller	customer29@example.com	+16774978243	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	Elizabeth	Garcia	customer30@example.com	+14816922528	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b842262e-c197-41d9-936d-a1003634953f	Karen	Jackson	customer31@example.com	+11974367587	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
91bbc62e-2bf0-47ea-8b9d-4f328df4af4e	Mary	Garcia	customer32@example.com	+15911789698	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5727546f-c899-4c69-84f0-c967e18e9736	James	Johnson	customer33@example.com	+14409383539	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f6d400b9-304d-4e66-889e-3f47feb8f2ca	John	Williams	customer34@example.com	+11912446331	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0e4afe69-af0b-4b9f-a9d8-734f10c7b739	Jessica	Jackson	customer35@example.com	+14451316096	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
49b987d0-74dd-43fa-b6b8-27cf0b736cd8	Mary	Lopez	customer36@example.com	+19221481875	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f39723f9-a757-4a9a-8ea8-c3762651fbb0	John	Martin	customer37@example.com	+19840768316	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ecb1221d-f014-4b3f-894e-c76c5c989fac	Linda	Moore	customer38@example.com	+16563127794	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
402597eb-7e91-4939-a9a5-eb483f048455	Sarah	Lopez	customer39@example.com	+11592872852	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
02fb5e2d-bc6c-462e-acb4-fe04017b141d	Karen	Johnson	customer40@example.com	+12295968276	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ad648e3e-075a-4f64-8325-86863d20ffd7	Susan	Lopez	customer41@example.com	+13982423391	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a8d4577f-b1fe-42e9-9b09-073e6cf9a952	Charles	Martinez	customer42@example.com	+15291183736	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e0149b67-d698-4a00-af00-be495b54b13b	Joseph	Hernandez	customer43@example.com	+14604165013	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
96c3ab7e-253f-4433-aa62-9a37d3a54d53	Karen	Martinez	customer44@example.com	+11309920595	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ce63fdf5-d4f2-4176-bd3a-8160db534116	Karen	Martinez	customer45@example.com	+19699264215	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6d61759a-f277-478d-a64b-20235ef12e92	Richard	Wilson	customer46@example.com	+16849285644	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a423bb3f-38fe-4660-afa6-7e1b8b7003ed	John	Gonzalez	customer47@example.com	+16865337700	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
00aca3de-ac11-4a30-b287-4c8000924f5f	James	Thomas	customer48@example.com	+15123626671	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
206c538f-c980-4013-b55a-127ac3873b45	Linda	Brown	customer49@example.com	+16422726236	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2966ea41-5080-4356-9f41-32acbeb83e79	Barbara	Moore	customer50@example.com	+16563153244	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
27be9ba7-cc5a-4bf9-b01f-223af7410560	Sarah	Moore	customer51@example.com	+13927539914	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8e5f9339-ecdb-44a7-a36c-39baac5436b3	Mary	Moore	customer52@example.com	+14880174323	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e6befeb8-b99f-46b0-82ea-f4821bb3e019	Richard	Martinez	customer53@example.com	+19111231721	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3c85445d-cf97-468b-b2bf-a6b9dd3799ba	Michael	Martin	customer54@example.com	+12306464126	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
792bed63-fc73-4acf-b738-e073f94ec232	Sarah	Smith	customer55@example.com	+11290911159	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
84a3133a-4ff9-4947-a297-7f30f01be533	John	Anderson	customer56@example.com	+18625443555	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f34579e7-9fcc-4bba-9d03-689528b577af	Michael	Gonzalez	customer57@example.com	+15231734954	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9bf949c5-01e3-4a9a-803b-a4095ce9eb15	David	Anderson	customer58@example.com	+12296212858	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
afd78b91-2920-443c-b8b5-4dba3a3c893f	Mary	Jackson	customer59@example.com	+18482632123	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
16d31b0d-00b2-4043-a19d-08ac4775bf37	Barbara	Moore	customer60@example.com	+15769360867	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b7ceb23d-7c76-441d-99a4-25eabd906add	Michael	Gonzalez	customer61@example.com	+18001034897	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
94db9d06-e501-46ad-9d2a-bb2ec40c0ac8	Barbara	Wilson	customer62@example.com	+18729816217	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4ce8a488-9b27-44c1-a87c-793838bb0f97	Michael	Williams	customer63@example.com	+18016719333	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ce95dbe9-f8a7-4ba5-8de8-60f7d763c140	Jennifer	Williams	customer64@example.com	+12571439302	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
36d9063f-20c4-4f00-8c28-554c7706acc9	Patricia	Lopez	customer65@example.com	+12832725023	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
dee94165-fa23-4028-9b9c-38445981105e	Karen	Anderson	customer66@example.com	+13742636714	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b5aca810-f4e2-4e5f-a388-4836a301ff5f	Jessica	Gonzalez	customer67@example.com	+12339150107	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9bf3b68f-9d6d-4c45-bde2-bb5aa42fdf3b	Elizabeth	Jones	customer68@example.com	+16462182799	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3eba3c44-b77c-4177-8a04-8a1702070764	Patricia	Jones	customer69@example.com	+16242371067	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a5881d02-92fe-4ec0-9682-963fd01b3cbc	Patricia	Jackson	customer70@example.com	+13912614638	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
08787311-1c21-4ac2-b055-09a58c482f02	James	Moore	customer71@example.com	+19256314453	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
77b1030f-978b-4c13-adf3-3d049f6c890f	Charles	Rodriguez	customer72@example.com	+19445374552	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0e896b19-4901-481f-837b-7702c232f47d	Richard	Jackson	customer73@example.com	+13907448878	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f98dac88-a1f2-42b0-8f24-e0f2eb484b91	Sarah	Gonzalez	customer74@example.com	+11850988453	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f19e3dc5-88f5-4c72-a74c-489a99aca0c3	James	Miller	customer75@example.com	+17500359160	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2b1c9eda-cd00-47c9-8f81-d7959eb6001b	John	Garcia	customer76@example.com	+13475516603	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
75a46c75-d94d-476d-be34-db5ff143b824	Susan	Hernandez	customer77@example.com	+18548879588	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
450be474-2b7e-4ca2-b336-e455c635dead	John	Johnson	customer78@example.com	+11872561429	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ddb5b2bc-d712-4126-9508-100e8ebdf0f2	David	Rodriguez	customer79@example.com	+18206509561	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4327b317-e5f8-4997-bbfd-3368138da698	Jennifer	Wilson	customer80@example.com	+18435813344	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2b2af435-d6cc-44f4-b2b1-26214b784566	Mary	Davis	customer81@example.com	+15657741077	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
48f4d07d-80f1-485f-8f32-7c08c4b37ed4	William	Taylor	customer82@example.com	+16246975330	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7833a3bc-f269-46fc-a14b-3e3e63ca1138	Barbara	Martin	customer83@example.com	+14010606297	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
50d71377-d586-458f-8dfe-7cb43c5b2b48	Sarah	Martinez	customer84@example.com	+11353553805	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0d70f380-36c9-4e48-9cc2-eb31b1667ed4	Charles	Miller	customer85@example.com	+19962391064	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3af89f0a-3cf7-455c-922c-06fd83351308	Linda	Hernandez	customer86@example.com	+14494331315	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
31016dfc-8da9-4e47-9ca3-0b1801b6d499	Robert	Brown	customer87@example.com	+16239633183	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ac36a0d7-22e3-4d4e-be4b-e6fd4519e1d5	Jessica	Taylor	customer88@example.com	+13433539783	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
45d370b3-fb29-470c-8b76-117ab3becdc4	Susan	Hernandez	customer89@example.com	+11146252940	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
db13bf59-f2c0-416a-ba94-f5fefbb6485b	John	Smith	customer90@example.com	+16752030574	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
cf42e6f1-a82b-429a-820a-051834af0bcd	William	Garcia	customer91@example.com	+14532943407	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0725bf08-acd5-4688-9483-3b04bddd39d0	David	Brown	customer92@example.com	+11261982942	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7f92f58b-e9fc-4b5b-81bb-e3df60f83be3	David	Lopez	customer93@example.com	+12045907585	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
735c3985-aaf7-4256-b84f-a4a59e865219	Mary	Hernandez	customer94@example.com	+11643648826	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4e16c93d-0d77-4bd9-a9df-827040485786	Patricia	Martin	customer95@example.com	+17160098866	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7d9f5030-b82c-4485-a7f9-9b9b5719a30b	Jessica	Miller	customer96@example.com	+18378840815	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
692e78ae-d89a-454e-95b9-821b64d15187	Susan	Wilson	customer97@example.com	+14888437341	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4a376439-19aa-4cdb-aac5-5c8b24b45b35	James	Davis	customer98@example.com	+14983150884	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4aafa299-9282-4935-b49a-591063f0be07	Susan	Lopez	customer99@example.com	+14182086555	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
69346b7a-ce9b-42da-b742-c72adfa1b2a9	John	Hernandez	customer100@example.com	+15877930721	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
d8fc9804-ece7-46c7-a57a-ae0dbaf2a984	Michael	Hernandez	customer101@example.com	+19344224023	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ce5d1a79-8744-4c47-ac38-0ec7e1e5228a	Susan	Jackson	customer102@example.com	+19150911728	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
fc046448-e40a-4500-bd91-b4e52f3956a1	David	Garcia	customer103@example.com	+19291544035	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
31942f7e-b155-4e5c-8da3-45ef83e9f774	Richard	Davis	customer104@example.com	+13652305382	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a47e6a8a-6be5-45fa-8558-a52b46054545	Jessica	Taylor	customer105@example.com	+14974350008	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
38cf4fdb-0d40-4787-ab2e-e0fd30d569fc	Susan	Davis	customer106@example.com	+19143691500	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
55975a95-fe3c-4284-9371-3fbabfafc365	Thomas	Jones	customer107@example.com	+14358605109	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
689ad5d5-5a9a-4c2b-8d86-4a74b0947307	Sarah	Anderson	customer108@example.com	+19032350412	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
423c6d3c-4f10-4f28-b8ef-7e7771c44811	Jessica	Brown	customer109@example.com	+14923377926	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f10aea05-505b-47d0-b420-87c7b39abf4f	Thomas	Gonzalez	customer110@example.com	+18551123514	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7732a2c7-0af4-4131-b5ef-569479baf5a6	Jennifer	Taylor	customer111@example.com	+18640227092	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e768c31d-840c-4ee9-a795-de8362942132	Charles	Thomas	customer112@example.com	+12095605713	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8f1b700a-6462-4ba2-8483-b618dc6b09b9	James	Anderson	customer113@example.com	+13265845957	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7ab0133a-63a7-456a-9e68-76c726da853c	Elizabeth	Martinez	customer114@example.com	+14896015587	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c602187f-e9c4-4300-8a73-1bc490552aaa	Charles	Brown	customer115@example.com	+12000319474	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
454582a6-37e8-43ba-b12b-3d75b64c66be	David	Hernandez	customer116@example.com	+15990522560	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e778a7fb-50d4-4eb0-affd-b9d1aa6b510b	James	Miller	customer117@example.com	+18498677137	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
202d6855-3e74-47ed-858c-020d4292ed6a	David	Martin	customer118@example.com	+14411633545	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0a5755ba-a5e4-4b23-ab5a-bc60e7d2908d	Patricia	Martin	customer119@example.com	+15940437216	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a7342c6f-3452-4e80-88ef-acd23bc36eb2	Jennifer	Martin	customer120@example.com	+19055818459	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
928ba062-0d49-481f-9bc0-281ca6f0fce6	Michael	Davis	customer121@example.com	+12507378413	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
75418ee0-2c89-4833-8b76-7e4c3fcf548e	Linda	Garcia	customer122@example.com	+17327289701	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4509edb5-a128-448e-a068-da1f0f40e71d	Robert	Jackson	customer123@example.com	+18596056657	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
81c43bec-83e5-4e16-b120-df5e5ce22115	Joseph	Jones	customer124@example.com	+16837649216	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f8cef700-bfdf-4d73-bb06-164fd9e320dd	Susan	Moore	customer125@example.com	+17174899181	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
76b43c30-8ce0-466a-8051-c13cbfb53e88	Robert	Rodriguez	customer126@example.com	+15396224941	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6f5f1a86-f824-44e1-8191-a15e837ce8bd	James	Miller	customer127@example.com	+16942532195	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
616af098-5481-4469-a69f-22fa8b557075	David	Taylor	customer128@example.com	+12141975081	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8a66bf04-1529-4ce8-8006-30ea72ad8847	James	Anderson	customer129@example.com	+11517456129	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3fb06785-15bd-4a12-a4c4-c6f5065ada43	William	Williams	customer130@example.com	+16150194005	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e6ba20b5-1bc6-4bd5-b965-04da1e02a4af	Barbara	Garcia	customer131@example.com	+18036530438	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
089809ba-cbf8-488a-9e36-6cdbca704a3b	Joseph	Thomas	customer132@example.com	+16487899161	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
cd76ac89-9466-437c-907f-7192bf64a2a7	Sarah	Jackson	customer133@example.com	+18661434108	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
45751453-c0e6-41ee-b54c-1cba12a172fd	Elizabeth	Rodriguez	customer134@example.com	+13046465516	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9103b807-40b7-4f80-8ea9-9fd1db90eae4	Elizabeth	Lopez	customer135@example.com	+14124984960	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
d58d44b8-4779-41c1-9615-31faa67527b6	Michael	Miller	customer136@example.com	+11842541648	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a14d764e-8113-4921-bf6e-679e6b3d5954	Jennifer	Hernandez	customer137@example.com	+14214024866	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
af346183-a9ca-41a5-9289-081a5961e82f	Susan	Garcia	customer138@example.com	+19384211683	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
100c77e4-ca31-4a9d-ad31-8896e71ff7d1	Susan	Jones	customer139@example.com	+17936081338	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8c9a2a66-0240-48b6-bdc5-49ef9dbdffd6	Jessica	Rodriguez	customer140@example.com	+15754597762	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8fe65129-918e-4ec4-aa4c-e6d49de34a52	Thomas	Johnson	customer141@example.com	+15437532293	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ec0ccdce-382b-4f86-8175-1a0f5e131c7e	Joseph	Johnson	customer142@example.com	+11612279262	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
059cba18-dc8c-4980-9e36-f0bb544353f4	David	Smith	customer143@example.com	+16931472725	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4f8a8827-1e81-4eda-903d-f17d13d6f20d	Barbara	Hernandez	customer144@example.com	+19160014563	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f5357948-4643-482d-9bb1-c4fcd35d65f9	Susan	Martin	customer145@example.com	+15078444282	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4835c310-d063-465a-af8c-7dcd89c69dec	Richard	Jones	customer146@example.com	+17741947865	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c90e103c-c6d0-4d64-8ebc-39ede9cb34d7	David	Thomas	customer147@example.com	+11974233759	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
53c074f4-aded-4081-990e-a98b47581dae	David	Rodriguez	customer148@example.com	+12024442572	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
1ace6713-5741-499d-af8c-467a66851a6a	Linda	Davis	customer149@example.com	+17487169874	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b7496dbc-0d69-40bc-9c7b-1428b1ea4dd2	Charles	Hernandez	customer150@example.com	+19774243372	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c1e08ea4-cea2-4261-ba56-8ca979c21185	James	Moore	customer151@example.com	+18272971357	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
d99bc6bb-181e-4023-9b88-358e37cd9565	Linda	Brown	customer152@example.com	+16125865284	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6b2b503c-e9a3-4eee-8895-9033ff14ff71	Joseph	Garcia	customer153@example.com	+15211149258	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
59ceaa66-459d-4c08-91d7-80039dff3a2c	Patricia	Williams	customer154@example.com	+19824942170	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7354db08-10ce-4e74-9dd0-69f4acccb216	Karen	Martinez	customer155@example.com	+18943851424	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3ef487b3-ff8a-4111-bf60-de8dc2113698	Michael	Rodriguez	customer156@example.com	+19023337467	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
63071a8c-6310-4a3d-ae9f-03d7ae87aed5	Joseph	Jones	customer157@example.com	+16003425123	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a5b0df32-c754-44c1-a9bd-dab2157f16ff	Joseph	Rodriguez	customer158@example.com	+14565933764	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e0a24c43-5901-4a53-a032-5cf22e0b2457	Sarah	Gonzalez	customer159@example.com	+17293819740	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5b676686-72ba-4eb9-ad31-5b0145d28b90	Robert	Smith	customer160@example.com	+15486117445	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f64c88c1-76c4-4463-98c5-e272df24b367	James	Davis	customer161@example.com	+18863929326	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c841d3ce-66a0-45d7-adea-6cb943bccbd8	Linda	Martin	customer162@example.com	+17062833810	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
634bb08a-c49f-4e31-bd09-943e534a3960	Patricia	Smith	customer163@example.com	+16650027922	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3694f634-0f4c-4c08-aab6-eca6bc4ea8e0	Susan	Garcia	customer164@example.com	+16974884861	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
417a48a6-262f-4419-88e3-03d975ae4fd3	John	Brown	customer165@example.com	+19413404536	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
d6d59585-0a23-4c53-88c6-f7306b6b4750	Mary	Brown	customer166@example.com	+18342295314	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b4cb4e4d-502c-4541-9399-0c9bc08fc9ff	Robert	Gonzalez	customer167@example.com	+14409927972	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9ade78d8-7cca-4619-9f98-4ea75bee43f9	James	Gonzalez	customer168@example.com	+19362277424	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
03536897-277d-42ca-a14a-fcbe4453fdc6	Jessica	Lopez	customer169@example.com	+11336049598	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
96be532f-9bbd-44f7-860d-a4fb6385f8c1	Jennifer	Anderson	customer170@example.com	+18247676953	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
aa8d83ef-90bc-4e29-ad7f-2e4f830c8e48	James	Hernandez	customer171@example.com	+18150554599	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
fb67ffe9-435d-4627-8ac0-2b0b480cf3ec	Karen	Anderson	customer172@example.com	+19439024128	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
26220339-79a8-4ee9-974c-4b71dc40b64c	Susan	Moore	customer173@example.com	+13822185925	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c5383705-00cf-4e88-a392-4c0d81e76479	Barbara	Wilson	customer174@example.com	+15413195992	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b3a40f39-8562-478f-8d8d-cda166a15d9d	William	Garcia	customer175@example.com	+18327844519	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
07dd8c6d-21ef-4bcd-8b3c-f0949e542e8b	Sarah	Wilson	customer176@example.com	+13892097317	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2e94fb6f-1201-4fb6-b934-e315ae511a32	Robert	Miller	customer177@example.com	+19131899094	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
87fce43c-97a1-4ed9-be65-b421ea56806b	Jennifer	Martinez	customer178@example.com	+11888415919	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
47d07d5f-dbdc-4f85-875e-b3a898fee804	Susan	Anderson	customer179@example.com	+12338611851	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
88b6888f-fdf0-4c54-b545-167f424fe3ed	Richard	Rodriguez	customer180@example.com	+16153732522	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
517408ac-9c40-413a-a6aa-7905c44f2b9a	Linda	Johnson	customer181@example.com	+17078765226	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f8e17e44-82fa-4186-bf1e-f62fe6eb48d3	Charles	Martinez	customer182@example.com	+12682296059	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
68910c5b-37ce-4997-b779-93f796d5e893	Thomas	Rodriguez	customer183@example.com	+18090222338	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
bda700e8-ce15-4fac-9d8c-6ba4d219b9c3	Sarah	Brown	customer184@example.com	+13841026647	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
89796a8a-c2f6-4036-947f-735ce437dcaf	David	Martin	customer185@example.com	+11195193572	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ac74ef30-b22f-4121-ac71-3f3cca618b27	Elizabeth	Rodriguez	customer186@example.com	+13110374303	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
20c95687-851f-4aa5-bee4-733260d9f24f	Robert	Thomas	customer187@example.com	+15165161201	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a7554622-e285-42b3-9923-4d808b591979	Karen	Miller	customer188@example.com	+11515601113	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e99c6536-41e2-41f4-b475-74a6b130ecc2	Susan	Rodriguez	customer189@example.com	+13559438866	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9a5619cf-7c76-452e-adc9-014f8a31eb31	David	Jackson	customer190@example.com	+19171743005	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
773b05b3-578c-408f-9303-2951412cee88	Mary	Moore	customer191@example.com	+18403539934	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ed0b1188-e06d-4d92-9c42-9b08909bad5a	Barbara	Wilson	customer192@example.com	+11470813871	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7f6af66d-fb21-4635-86fa-3cb2e2ea1fb5	Thomas	Gonzalez	customer193@example.com	+11484538042	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8ac22279-56a9-427a-8da6-627172c41b0b	Michael	Garcia	customer194@example.com	+18156730197	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a684e599-9bd9-42a6-a671-64b1ecde8955	Michael	Garcia	customer195@example.com	+18914135474	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0d0fb927-c2c9-415e-b1e9-a3b4184d0583	Charles	Moore	customer196@example.com	+12100828156	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9e48707b-b346-4ae7-ad10-fecf9d23cee6	Mary	Williams	customer197@example.com	+14309865210	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f41278fd-dc73-4831-bba4-8f816ff57016	James	Garcia	customer198@example.com	+17309430583	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
48785468-f2a2-4ce1-bd48-bd72c65ac963	Jennifer	Martinez	customer199@example.com	+15027208796	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
fd11c7cd-69de-42a2-9272-51ad1c620e12	James	Martinez	customer200@example.com	+18250392577	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e85a8873-4e36-4bd8-966f-625ee4740d66	Thomas	Jackson	customer201@example.com	+16321439806	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
68658780-57e7-45b9-8219-a9ce972a2138	Elizabeth	Johnson	customer202@example.com	+11443730248	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
90ca8d85-13fd-43b7-ab4d-4f658f8b361f	Mary	Miller	customer203@example.com	+13218243219	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
1b6cdf0b-21f1-4af4-a020-2ae4fd6704b4	David	Hernandez	customer204@example.com	+14113008968	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
79788041-34e4-49bf-b74d-785a7ac1d804	David	Anderson	customer205@example.com	+17559070127	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
baee1c4b-882d-4393-87e6-086a74e92d08	James	Moore	customer206@example.com	+18194930350	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4a9a1646-fc53-4a94-9c14-3c3785d59e45	Karen	Smith	customer207@example.com	+17111557824	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5e990966-ec19-4c0a-b899-70f18229435f	James	Williams	customer208@example.com	+16929681693	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e0916586-8fbd-4a07-ba7c-9ecb0ecf91a1	Charles	Miller	customer209@example.com	+17250058596	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
722fc471-41f8-4bf9-88bd-ac4da05fd159	John	Jackson	customer210@example.com	+13411613273	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7517aa01-e9c7-4878-abaa-9fb829327d0e	Susan	Gonzalez	customer211@example.com	+16623160530	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4bcbfe6f-47d5-4519-84cf-cddc82ad73ce	David	Wilson	customer212@example.com	+14349269617	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3620e68e-e822-4f6c-8299-b0587b96f56a	Jennifer	Hernandez	customer213@example.com	+18932246034	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4e6a70db-9a4c-4854-8edc-0335f306893f	Barbara	Wilson	customer214@example.com	+15717888512	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8aedeb01-eca3-4483-adf9-ab6d930123ce	Richard	Taylor	customer215@example.com	+18735066021	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6c97217f-4e7a-4cc0-ad71-e748e481a96b	Michael	Miller	customer216@example.com	+13412166400	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ba973c64-5dc4-4ed6-8f93-c5874caa96cc	Richard	Moore	customer217@example.com	+17881381630	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9c9522e7-64d4-40b9-85ed-62b2c18a7cee	David	Rodriguez	customer218@example.com	+17398638506	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5a5dd7b6-ad6f-4e71-a1e2-394453b3b3c3	David	Garcia	customer219@example.com	+12323109307	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ce8000a1-e0e7-40f7-b59d-8524ffd800b3	Richard	Martinez	customer220@example.com	+12870340301	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
022844b8-18e8-4b12-94e6-d023bbe5b24c	Jennifer	Johnson	customer221@example.com	+17858415621	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e848db17-8b4e-41ed-bb25-0299ae635968	Mary	Wilson	customer222@example.com	+13663235799	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e049e76f-d857-4042-9fd4-e728a76e6c6c	Elizabeth	Jones	customer223@example.com	+18179534697	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
544e62f9-bc15-4e07-ae28-e9d66141cd8a	Karen	Taylor	customer224@example.com	+17308238016	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
1f60a72f-8e54-472d-b2ab-c5adab51b421	Mary	Davis	customer225@example.com	+19653288173	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c9edfab5-9daf-412c-85b3-b373c0408105	Mary	Hernandez	customer226@example.com	+16853674468	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
abe3688e-126f-4d19-9adc-9cfd4bfef0be	James	Lopez	customer227@example.com	+15978948859	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a33d1b4d-c048-48fc-9e27-2d4a7b33ab9b	Elizabeth	Gonzalez	customer228@example.com	+14709824636	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f063ff2e-6815-4921-a135-847c033a28e1	Sarah	Hernandez	customer229@example.com	+11819008595	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
fa37271a-9e4b-44b6-a141-48c32518409e	Mary	Rodriguez	customer230@example.com	+18028824808	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
66edd835-f10a-49fe-8c37-307b91b6c1f6	Thomas	Thomas	customer231@example.com	+11964141168	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f66fe2cf-0cac-4b80-818d-1161531a4e6b	Patricia	Hernandez	customer232@example.com	+15674392928	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
863428aa-572a-4878-817b-60a92148e994	William	Moore	customer233@example.com	+15785941259	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
d5bfa3c8-23ac-4388-a006-dc7d7102da31	Barbara	Taylor	customer234@example.com	+19344990558	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ffdb486d-e8e0-4876-bdf4-bc0b80a6c86b	Jessica	Johnson	customer235@example.com	+13649805114	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b49fe282-1602-4dfb-b5bb-e180cad84e2e	Elizabeth	Hernandez	customer236@example.com	+12242678789	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9ccf914a-5d14-4b64-b07f-dcb434c8926b	Joseph	Martin	customer237@example.com	+13601837103	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6088fe55-dd3f-4601-a820-a1ea0c1ebee3	Karen	Gonzalez	customer238@example.com	+15691482172	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b6c8bc08-7e34-4186-8328-a06f397468cf	Sarah	Moore	customer239@example.com	+13426744415	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
aa7a7405-53af-4dea-9214-1a4ef22bcb60	Thomas	Gonzalez	customer240@example.com	+16617127431	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
42e01ebb-b18c-49e1-bd75-a9aaea9abfe1	John	Hernandez	customer241@example.com	+15765004346	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a1f46071-8b99-498c-8c11-53a67f1dd995	Linda	Hernandez	customer242@example.com	+19379665850	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8191538d-9918-4a3f-a00d-d9e3f8a85f84	John	Garcia	customer243@example.com	+16183299222	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
a241ea52-e355-4bab-a834-356a16a1dc43	Thomas	Davis	customer244@example.com	+19998934256	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2bf983ec-14d6-4d7a-ac07-d79ad217ff19	Thomas	Hernandez	customer245@example.com	+17403884999	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f9142fb3-4c86-45f6-9ae9-722364a10efc	Patricia	Martinez	customer246@example.com	+15777676156	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7c8f9acf-f8e8-461c-a5e1-1d9392c59b10	Jessica	Miller	customer247@example.com	+14659628453	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c2b9c0ab-0fcb-4dc5-baf0-9d26f336d30d	Richard	Smith	customer248@example.com	+16542337617	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9b78c372-7277-45b8-ab2e-10c69cefb2e8	Elizabeth	Moore	customer249@example.com	+15943971825	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
05795d78-c0bf-44ba-b1e1-af2b525e87e7	Karen	Martin	customer250@example.com	+17630118920	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
bedf7b82-9445-4ca6-a66d-71505ad514ae	Michael	Taylor	customer251@example.com	+11137076086	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
f4b63269-9ea7-4f30-9afc-004ad2074cfc	Mary	Davis	customer252@example.com	+17591868011	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6e7c23f3-2fa5-45cd-bd13-efd53cbbeaef	Karen	Garcia	customer253@example.com	+15100820875	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
87c7fe27-83b2-4ff5-b746-86b9d55b203c	David	Moore	customer254@example.com	+18237205367	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
21c7fa7a-0aaf-4b93-a05c-18d87d2688dc	John	Miller	customer255@example.com	+14785548462	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e846759c-420d-47b5-9ef5-fac68a11fcd3	Patricia	Thomas	customer256@example.com	+15779512360	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
6a621a69-76a1-4382-af14-b2ecc38ffbce	Robert	Miller	customer257@example.com	+16070794341	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
70804476-5b99-434b-b038-8fa7297ab64c	Richard	Johnson	customer258@example.com	+19038442619	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
cab2f2d5-d5e7-4bc8-832f-bb67fc54d669	Michael	Anderson	customer259@example.com	+13550996805	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
d27bf548-7f48-4b51-9dca-18727064cc19	Linda	Williams	customer260@example.com	+17713990054	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
086595e2-96f3-4e14-aeea-f0287b1c399c	Joseph	Thomas	customer261@example.com	+11887416636	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
729e64df-48e5-4853-9351-db42d429931b	Patricia	Wilson	customer262@example.com	+14037072692	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
9b646662-7cd4-4855-86f4-051618eb5eb4	Sarah	Rodriguez	customer263@example.com	+17134739492	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
11a0267c-c820-4bf9-8429-7454070b6538	Jennifer	Moore	customer264@example.com	+15725612772	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
91711a94-5cb3-47fe-9741-cceb6a1cf550	Thomas	Taylor	customer265@example.com	+12510670007	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0c179f12-e24f-4f13-b818-1b62ef74eb1d	Barbara	Garcia	customer266@example.com	+11348603439	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
89778f97-6fce-4d0a-baa5-141fb621e613	David	Lopez	customer267@example.com	+15452764539	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2abca2e5-07cd-4c52-ba3c-9dd2c208510e	William	Martin	customer268@example.com	+16607732615	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
24a0ec46-9ce6-4bd7-a585-ccc0b43343b3	Patricia	Rodriguez	customer269@example.com	+15768458159	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
4571087b-1318-4c4e-ae93-ee0c108e0daf	David	Thomas	customer270@example.com	+13819928014	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
54f35ef7-573b-4e6d-b144-6bf2be5ce6f8	Mary	Smith	customer271@example.com	+11562463084	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
17028b66-ca4b-4834-b656-b73d37fccf65	Barbara	Anderson	customer272@example.com	+11838702399	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
bbd546f9-5437-4a15-ba8e-e50ee67c2004	Thomas	Gonzalez	customer273@example.com	+19896808593	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
66babc3a-b931-4c7f-aeeb-0b71ce2c3d16	William	Thomas	customer274@example.com	+16691424129	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5e1d0807-7308-4a69-a83f-663746b57492	Jennifer	Smith	customer275@example.com	+17802817160	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
fc6a9201-fc48-4521-97df-4235aaa746cc	David	Martin	customer276@example.com	+17969236664	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5bf35191-6135-46c9-a031-09d70145932f	Linda	Martinez	customer277@example.com	+18543753569	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
19d4620f-83b6-43af-91cb-fe77239e0554	Linda	Jones	customer278@example.com	+12014785725	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
63f91a12-d3e9-4ac4-8642-9281cff3981b	Barbara	Johnson	customer279@example.com	+14606879123	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
2d7ffeac-582f-48a6-a565-b115f8f34922	Patricia	Davis	customer280@example.com	+17486834603	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
233ea7d3-d24f-4342-b8e0-5c7e6d5a96f1	Mary	Martinez	customer281@example.com	+13841073748	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
562a8b30-b7a9-4bad-b427-8ffde3d0dd8d	Richard	Williams	customer282@example.com	+13752300321	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
842451a6-d250-49aa-bccd-0679bbcd1669	Barbara	Williams	customer283@example.com	+13197408820	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e8aee4bd-1e13-4c78-af70-104b5dca9ab9	Joseph	Gonzalez	customer284@example.com	+12647820993	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
99ddb124-2a7c-42f6-ab52-53056e71ec6a	Richard	Brown	customer285@example.com	+15534475838	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
61580a7f-2882-4fa4-810d-56e67ab068ca	Sarah	Lopez	customer286@example.com	+17515225558	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
57d8153f-6db7-4c6f-a020-e583e94bb76d	Michael	Williams	customer287@example.com	+14101174051	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0157a8d7-a264-40e7-a3df-9b150c3ff4cd	Sarah	Smith	customer288@example.com	+12762540935	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
1051e1b2-d064-44e6-9d2b-d1abed60f363	Barbara	Jones	customer289@example.com	+14153682039	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
e85ab902-c9db-439c-8fd9-497fc83c8fc8	James	Brown	customer290@example.com	+16925431922	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c32c7dea-41d2-4acf-ab59-e705d7877a9b	Robert	Thomas	customer291@example.com	+13317086019	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
ba240067-7018-4ecc-a3a9-58e8a8890a9d	Charles	Moore	customer292@example.com	+19813114355	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
7b3f1c01-8368-476c-8053-3e431dac2227	Karen	Taylor	customer293@example.com	+18456548872	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
5fcb60b0-4971-4100-a4f8-9ba823b724b0	Charles	Brown	customer294@example.com	+13171771902	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
616ae20e-4ec8-4037-b5d1-88f47d3bfdbe	Robert	Gonzalez	customer295@example.com	+13094705233	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
c2f3c126-ff47-41be-986c-8410d5b5ab82	James	Jackson	customer296@example.com	+14557916007	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
0fa16c5d-4fb0-49ec-92f1-ee96f90d0c34	Barbara	Lopez	customer297@example.com	+18456032791	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
b0f2fe54-950e-4ab7-aa4d-61240bfb2e8c	Charles	Lopez	customer298@example.com	+15848303834	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
54b6c64b-5f50-4706-bc0a-0205f972f47f	Thomas	Miller	customer299@example.com	+19416872701	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
8cd5cc95-37e8-4d4a-80ff-280de39d4db0	Joseph	Anderson	customer300@example.com	+18498217161	2026-08-19 23:05:12.216522+00	2026-08-19 23:05:12.216522+00
3050bc9f-bcfd-427a-9f31-fe3c9d387d66	Jos├® Agust├¡n	Mendoza Ure├▒a	joseexample@gmail.com	68937462	\N	\N
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.order_items (id, order_id, product_id, quantity, unit_price, created, modified) FROM stdin;
548715e9-09e1-4261-9a9c-538e14cd609e	c5c5c618-b33d-4375-a872-0ba4fced0dd2	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f488d90f-2da2-4fe4-a179-2be0cd262de9	5ebb9650-f2a3-4250-af75-e8a5f5e1dba4	bb3baeb6-156a-4b66-877a-70c3309563e3	1	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aafe082a-8bc1-4fbc-8d13-a1c7cdfad047	516c760c-aa9c-4f4d-b324-d6a94eba0f3c	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5b836438-a7b8-408d-ac4a-7405161d47d8	d50cd0cc-b296-4cc9-b761-aeffaa5d9f47	689a3789-11b3-40ed-b32e-b948af298ef4	1	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e9a7ab89-5536-4544-8012-9293e80b4155	5bc41f69-6c06-4d2a-b2da-0861bc426662	514aa522-6bff-4165-b78c-6b518f99dccd	1	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
71f1bcb5-ef77-4488-9a9f-b7e89631c956	aad26943-c21b-4819-9356-cb0a2bbeaa0c	a3d7efd8-15e9-4d59-b159-48b9de13c791	1	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b79b2821-f5dc-4278-9991-535fd9dc75f2	2a544346-4e45-417f-9575-e9302c591522	d620a7c3-32ec-4dca-8ed7-b5d87326818f	1	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cc0953a7-7422-4a23-93dd-9d07c2d4bb76	2ac7fc00-1f5e-4632-93fd-0de06d7c1d55	c49e6332-e143-40b8-9f4c-b23b547fe4ad	1	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
69ac8289-a519-40f7-8b28-db33c384ece5	99f40a2a-e6e0-4a58-9657-b7a785563334	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	1	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
82aea60f-fdbd-4d4d-a317-e228cae3872e	3e94664a-547c-4588-8038-49f8b8055161	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	1	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c9e71c1a-79b9-4204-91b1-82c9bc157ff4	c6ef7578-13b3-4454-9357-33d3a3421ca8	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b2a22efa-d363-455f-ae3d-a4d46a819202	636858c1-9f81-4b28-ba16-58f953d8695f	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	1	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
49da641b-2e11-4131-adcc-386e65f96e70	48dde4f0-57aa-4a79-a354-5eef33ab74be	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	1	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
32e4ef34-f16d-4e8f-9870-45348d69f8ef	91526298-0b5d-46d9-953d-d220165c4dfa	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	1	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
801c73e0-a3e9-4632-8171-240d158b90f7	59610614-6e8b-480a-904b-d8df1b841b14	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	1	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dbc8c913-15f2-4489-8227-732311158317	479cb726-fc8d-497e-a7d1-f7dc8f642509	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d791ec75-f808-420c-b0ee-f3baf98e25a7	03c06630-814b-463a-92bd-87662d923c1b	514aa522-6bff-4165-b78c-6b518f99dccd	1	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
181e94da-13df-4fa3-9853-044288d5414f	fff96c9f-6304-4684-afdc-24f9fb79f5df	bb3baeb6-156a-4b66-877a-70c3309563e3	1	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9043fb49-d7b0-4c93-b979-36752641eaf9	89856409-ee57-413f-9d24-c02239a40db3	59a062f1-5222-404d-973f-3088ac2465b1	1	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0b673687-16ea-4b21-9760-b531a5113be2	accaf494-7c3f-4f93-96bb-256198632cc7	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4f40ccf3-b68c-4e9c-94ad-d57c1fbbbe40	443975b2-2199-4d1a-9d83-59edb6c88fa6	a3d4b59a-f601-4155-8f2c-e48a8173bb97	1	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e5bbed44-2b65-44d6-a036-f5ee7db73cd7	52f621e6-e888-42b2-85be-3f9b36f2e5d9	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
81eee0b5-24d6-495b-b579-5edae3a4a448	7233d4e3-4dab-471c-8b5c-71cda89e78ef	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	1	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2f8b90aa-031e-4479-a1e4-9f6c648cfc76	69249160-ee9a-4a46-af5a-ddd22249887d	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	1	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7c802e1e-7276-4f0d-9415-f4e58d6f0368	91141b74-0513-4de7-95d4-6f7e3f7bfa33	d620a7c3-32ec-4dca-8ed7-b5d87326818f	1	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
35087e5f-7712-4db3-9ce8-7601f3e20b17	812caf18-a781-41ef-ac70-04da995fd38b	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	1	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
95b028dd-5cbd-4732-a899-2e4930786d2d	f18e6136-e33d-4d71-a965-7e5384029481	d620a7c3-32ec-4dca-8ed7-b5d87326818f	1	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
41c71799-41f3-41d1-bcdd-310152138424	dd5b10f5-38d3-4c2b-9b83-70ada0dfdeed	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	1	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c5a29691-6257-4a84-a121-d0bd45ea8687	fce9aa3c-fdf0-40c2-bfec-06a2654ac34e	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
786beb51-c96b-4cec-a668-2e2a149b0b8a	bf1f7930-0ecf-4f73-a1a2-9f5bf70cb808	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
08b8df3a-9059-4fc6-9630-8ecfcfce2782	a0555455-7454-46d2-b80b-a2991ebd653b	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
360e30ac-c419-405a-ba96-8f0025fb6f31	05b62cdd-d2cd-40ed-9a9a-8ba5da910e49	a6d85cd1-0f47-4f6b-9794-e05f81744722	1	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
79f8b9a4-70ab-4b2a-937e-87b87caa6d0a	35aa81ca-a01c-4910-b752-5dbb8f6c5cdf	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ad7874c3-e41e-47e6-acf3-a34477561969	4480d124-7015-447a-85c2-9d4705d5a27e	a3314b6c-1546-4000-a36a-a6c776247f9a	1	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5bf7218f-f038-437a-86ea-fa9703ba3616	b880c75d-0ae5-49be-8b10-43adc2661fe0	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	1	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0e02f583-d0c2-404d-beaf-b93eaa5fbd0f	7f8147df-1bd0-4287-b6af-b7f9e5c32334	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
080ed38c-35cd-409f-8e77-6e55107d50e4	1046377c-3ca2-4f05-98d3-40e0afcf6f1d	46139fb3-b443-4629-b8c1-c5ac5ff0de07	1	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
627d8b42-8832-4996-8c8c-2abdfc5c3654	dab9151e-fb52-4e13-83bf-9f225f0d4ef0	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	1	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
178df372-1dbb-42aa-b9d5-644be30fc7ba	ed96bbe9-7e20-41b4-bd27-5489e2a8f5d4	cf3800aa-7129-4651-b3d1-a44125fb51e9	1	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
52762ce6-fd2f-4c1a-a47a-55f5e6db377a	fa5efd46-4f8f-4f67-8575-004cc3c62124	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dff02d0c-b37e-49e3-b8e5-3558b30f5d76	1adfc14b-935c-47cb-abc1-3aa128f3275a	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0c69333a-b5aa-4afa-ba53-4988a25b3e84	d927c177-9948-4a70-a42c-e1311242a19e	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	1	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5d9e656c-e42f-45d1-87dd-fec069afd620	fc518724-d04c-4819-8434-8391c825317d	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	1	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9e93b2a5-4eaf-4ee5-8a52-6af5b5023344	5f8713c5-4a12-4bcf-9a54-04e81f8891bc	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	1	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8960dedb-4f82-40d5-a9bc-92d987c2fc2b	5d542225-e863-4b04-8b31-038d5b213200	c49e6332-e143-40b8-9f4c-b23b547fe4ad	1	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f4bb1cea-5f5d-4686-baad-542a7cc098b9	ad6965f6-e833-49ba-a3d2-c136f47fc0ae	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	1	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3ac16a07-ddfe-43dc-883b-71a4821a5ebe	6dcf74ce-fa7c-4e87-bfe1-e170e230b3ab	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6a6ad53b-f9a3-4aed-9116-96b27fe950fa	2fb35d73-a26b-4ff4-81f1-56bcda96aced	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	1	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aa579d84-ff1c-4aeb-9d5d-bbb6a3b11f55	c6da8964-cf9c-432a-a5b2-a23d4676975c	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	1	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9fbd895e-a8c6-4097-94c9-99ea384a55d1	c0ef7a9c-1a5f-4654-b898-83e64b14b273	57f39d16-c1e6-49df-ac39-e1e9870e55f3	1	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a436d72d-3ca1-431d-b3ad-51e0dd8d9708	08ba1eaa-9546-40a3-bb75-6d1f69fbb9ae	57f39d16-c1e6-49df-ac39-e1e9870e55f3	1	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ec80fce5-b323-4cff-a10e-8877dc21fa26	a4308cfe-801e-48e4-b987-0baa79548f52	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e55c10ed-7996-4aab-a884-221ca74ef0d0	c8cb3636-35f3-4916-a79b-79432b68d64c	a3314b6c-1546-4000-a36a-a6c776247f9a	1	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0b15d877-da64-45e0-9cc9-aef870289b2b	87ddc01e-c133-4774-a55f-6520dd350ac0	4dcb76f9-1c44-435d-b318-7eae10573f52	1	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e8be39f0-04df-4e36-8fbf-3ef6e98d5aa1	f0fb4927-ef91-4846-8aed-b9402d00f034	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b74dd9f9-e43f-49ff-baf9-7223349862ef	769029a9-1596-430f-8749-27ffa95790c0	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aa3c247d-632e-4bcb-852a-d4c1eb0a6a2f	5314c407-ab54-4e6b-ae82-c1b08adaec67	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	1	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
768a0de6-5148-4850-bb48-9c80624e267b	e7a18fb4-fe36-4f89-a432-1848bedae75d	d09d1231-6870-4c42-bea1-2f27ed6e6f63	1	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ecad8c2e-09f9-47a6-a2c9-e4ec432d76ec	f7a8a32c-0b1e-4b28-96ea-418bbb35c037	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	1	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3f374630-f107-4068-8ed6-303df49a670b	60068966-6de1-48f1-b649-08f4bb70bd7b	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
85273ce3-8b34-43f7-ba3e-ed6deb14ac52	36c3d31b-f011-4d7a-adbf-d0458c9103f2	cf3800aa-7129-4651-b3d1-a44125fb51e9	1	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a2a1543f-a16f-4cee-a81a-efbb11b2fe05	d6f5a54b-8e14-43a0-a2a3-5556498d830b	a3d4b59a-f601-4155-8f2c-e48a8173bb97	1	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8f1c92b4-fcc1-4ed9-92f5-de892c092e55	48dbccfa-d888-402b-b477-9c31e2dd73a1	59a062f1-5222-404d-973f-3088ac2465b1	1	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c3f81cf7-1c2c-4207-a945-32f71b8a2709	47d96cbc-0687-4fe8-b469-ca8a6ba29a47	7c0aeeba-d877-4f92-9be4-8cb9591261eb	1	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
530974f1-4d77-4fb1-ae67-55337b2152c5	d565941e-9a85-410b-891a-c2aca9e1b016	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	1	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5511b78f-4176-4981-9ede-a8bf5a53ddc3	59560717-a657-49b5-b501-d9aa3ff3ec51	59a062f1-5222-404d-973f-3088ac2465b1	1	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c7a15cc6-b636-4927-a2d6-3fdaf1d1e7bc	2c660b58-215e-418a-b99e-8f58acbc7a78	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	1	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2bae571b-359d-4ac3-93ac-025245d7cab3	b8b15ae0-9670-4e40-8622-307e7fe07106	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	1	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7401df5b-8a76-44e1-a4b7-ecc8874d6c5f	71dfc8c4-3539-4788-8280-58ccdf80f9f5	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d5d71648-df59-41df-b8a2-a9e5fb6674cc	9fa5ea08-fcc7-4b16-a2b0-fe5e69cf3829	a6d85cd1-0f47-4f6b-9794-e05f81744722	1	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
07bbc4f9-f76e-4f7f-af0e-da4d3a34faeb	6795ef74-6ddd-4cdd-b380-b0f7867b63df	e8288639-c50e-416c-93a8-bedb29c169f4	1	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
53382c13-885e-4715-8ecd-74bf219ee1c4	693b64ab-20f7-4305-a7f6-21a1d5ec2f90	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ee945ac0-6df9-4ea9-aab7-28ca055221b3	87ddc01e-c133-4774-a55f-6520dd350ac0	a3d4b59a-f601-4155-8f2c-e48a8173bb97	1	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
78fcfdef-bb57-491f-8127-723c80616400	4a9301d5-ed4c-4d9a-8ab2-58367120469b	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d401630c-2c22-405f-bb48-e2e1adb6768d	a0555455-7454-46d2-b80b-a2991ebd653b	a3314b6c-1546-4000-a36a-a6c776247f9a	1	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e4379aff-2d90-4eef-8e52-b056e50b7f4c	844e83ea-e851-4c60-97b5-e47c995b288f	bb3baeb6-156a-4b66-877a-70c3309563e3	1	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
19f2d917-2c8c-479e-a21e-d90b93c5bc9d	a9aaf563-b41e-4921-a7b2-691676649aba	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d24d3092-3b04-446b-9751-b31d770ea060	911075b2-d89b-48ae-b481-a161c562ed1c	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	1	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a84d9e63-c924-47dc-8239-df3b97468dfd	03d5b43d-13ac-4bb0-a643-081008d27809	b52a5f8e-5cab-4fca-8b5c-d07230467720	1	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b5be8edf-9b1c-4e14-925a-24c7cf3420ae	18abcf04-950e-4943-8ad7-c24d2a243174	57f39d16-c1e6-49df-ac39-e1e9870e55f3	1	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0a574e6c-faf3-4c3f-bcc2-e08e386322d1	4b46a60f-3332-4720-9750-62b06bddb8eb	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4a44bc4a-0202-4719-8177-a466db166fad	37dde477-e2d6-4e54-b66c-dec5e43a6216	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
affaa3d7-9733-4421-a13a-1f2954cd1a60	08139a8a-6100-4041-a468-6db30403bb5e	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	1	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8524e6f9-7758-4e2f-b595-e58fce701f83	f4861aed-3b87-4f58-bf7d-98d7b86ef078	4a71ffc2-cea5-450e-8595-bb66ab01757a	1	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fbaf0c52-2823-4f11-afe4-36c50fbc85ea	324f609d-0b11-4790-9291-ee70878d97f7	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	1	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bac36e80-58dc-4159-9882-afd52d44c2ec	9bdf95bf-03cb-4408-b8a2-fe2321cc8955	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2b5badd5-3b67-4fa4-82db-321b70533a29	b17c23d5-b919-416c-ab76-8447b1ee6901	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
902fed5e-6725-44a4-ae17-d9fab2128243	4e8a3d1f-3489-4f5c-af2c-6f51c07341e6	c2f85493-b833-48d0-900b-ae08f1aa9ff0	1	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b737ff8c-f1a5-469a-a948-d65f56fd41be	8a5eb443-e259-4d7d-86ea-c6003263e5f9	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
39dd6ec2-65f5-4154-97d4-9258cc21e339	65a1bb2c-75b4-48db-8fae-cbe8038808b8	010d6df1-03ed-4ace-a34e-e389424e9050	1	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0b47d9f1-987b-4441-865f-081fab612307	c200ea82-3aab-4e57-9140-751e3c30a1fd	e8288639-c50e-416c-93a8-bedb29c169f4	1	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0e665895-39d8-464e-a95c-1b64ba02086a	71979b3c-0eed-4490-996a-5374cb24ab7a	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e1bf6818-9861-4c4c-884d-c2bfc73c35cd	8669e169-c126-42ed-8d4a-a73d39ec8572	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	1	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c29eea19-46b7-4a8e-9919-b132ab3bf6e6	cc080dec-4631-475b-be93-623ae8eecadf	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
84141bc6-834a-43d2-83e8-3da0e1d5c72b	5caa22ea-c755-4381-abc7-80d72db51cc3	4a71ffc2-cea5-450e-8595-bb66ab01757a	1	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ae58e906-8f02-478d-81ae-b0ed49e56078	5cf4ca76-71f8-4d8c-83ec-304ca8c03cf2	c49e6332-e143-40b8-9f4c-b23b547fe4ad	1	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c418740e-b34e-40da-89cc-f78d7d699894	bb8f83df-b244-4d09-a4a5-9be604cfd19e	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0c798edd-2a1f-44e3-9508-f8ed9e17f2c9	dcaf429f-66bc-46f7-99b4-226ac442b360	276e4f43-463a-40ad-b06f-698be2cc75b9	1	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2565029e-5496-4b45-afc0-54b630a7857b	48169c92-169e-4bb8-864a-86d13b900042	93cfa5df-80d8-4387-958e-ff346ba30ab2	1	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
043aead6-30f1-41bf-831e-39b8b4499dbf	e9fe82e9-06cf-4c8a-bc2f-4dbfaa6b2e77	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e6ed2e71-329c-44ad-aec3-8194399541dd	c3623ce9-ea76-4e28-b8fc-f8816f5f3ad8	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	1	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bd41de6a-7d21-4fea-b474-83c268073054	a89f854c-8dc9-4af5-b074-2deed2a48072	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
381acb08-ffed-4802-a4cd-d93168232221	2beb8800-87cf-4764-872d-e895fae05d96	717348ce-6fee-443e-96fc-92ee6a9cae8a	1	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5cbdb78f-4d1c-4eda-9bfa-c08518cee311	85575b48-fb50-4e80-a5a6-85f8f3de49cf	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	1	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2bec85f6-d596-4839-811e-5da61964d9fe	027ccbe5-a324-4a62-b09b-bb5cd10df84b	8b435be1-19f4-4571-8643-dd261e2e6807	1	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
52245f26-9bd2-4fa3-90bd-5d59327af686	b8b15ae0-9670-4e40-8622-307e7fe07106	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf11614b-992f-4312-ae4c-41e8162f9cb5	e3474a10-ead3-4093-9cb4-028ae0bb48d2	0572c891-8efd-442f-b53f-1c1deaae2c80	1	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3e99c9bd-618e-4fae-a9c3-42a055c5130f	a7d59742-7f50-4471-8ea5-83178402e532	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	1	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
65b9c074-9c65-4568-a106-8130289d4a0f	0425fb9b-aef7-4940-a12c-1ca49264c791	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	1	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d8cd443d-bd70-47ed-a4ea-3f1b4e4f62dd	a58a064b-d986-4fe8-9496-408fd9a74bbd	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	1	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9702c409-4049-4589-b6d0-4b743fbfd0f8	c6a35ea1-6c8d-4200-b154-a60f60251c0e	a6d85cd1-0f47-4f6b-9794-e05f81744722	1	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f2322d5e-17d5-457c-a689-61c9ecb1a31b	044dce02-86ab-4d8c-bd8a-d505891ea5da	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	1	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f03c617f-d8c7-41a0-972b-901d738a261e	1f22b0c3-c64f-413d-8024-73999f786187	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a0d93fd4-e75b-489c-8017-06f4b98c0b4a	776956ce-b80b-4400-9cee-51be506da9c9	c49e6332-e143-40b8-9f4c-b23b547fe4ad	1	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bad38f80-a1ff-4be9-bd73-aa9b3144e09c	4c405a8d-b98b-4c76-9ff3-ef610cc981e5	4dcb76f9-1c44-435d-b318-7eae10573f52	1	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e5681175-5d91-41bf-acdd-4b579a6ad4ab	d9b0d672-286f-4985-9ba8-021202fa2b20	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	1	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
71b4d49a-ba03-4853-a7eb-aa2f89143076	a89f854c-8dc9-4af5-b074-2deed2a48072	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	1	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9522611b-3d5f-43df-ab59-2b84f1091250	f458c05a-d808-4264-b30c-184165903fd7	a3d4b59a-f601-4155-8f2c-e48a8173bb97	1	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0d6bb628-4b97-47ed-8c57-8dab5f9952df	af640f9e-e729-4b4a-94f4-63ca562339c2	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	1	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8e53b01a-54b9-4b80-9f57-84596b9f871d	91203bc8-6fb9-4e01-9dd8-8654800994fc	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	1	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
45960471-8441-4544-b6c8-ddf2d9d06ac3	855f61fa-3476-4c9c-8acf-9a60f057866a	4dcb76f9-1c44-435d-b318-7eae10573f52	1	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6210324e-885f-4362-a25a-aab60a4839f4	c965aa40-94ee-4a95-8c3a-a9f54d8e1b83	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b8f60a72-0d3c-40b9-8d8a-d0dba3c1ce17	88bee41b-e0b7-4fdf-9c07-6602888c7097	a974674c-a14e-4a7d-9e12-84ee4678aa68	1	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d55fa594-2cb4-4c4e-8db1-bd06c114a5c4	797ca8e3-813a-4f42-82e4-969328a4d240	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	1	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
598dd48a-ac89-42fa-8c76-f3a03c008fad	2fa63f1c-211a-48d6-b37b-17b577906e61	a974674c-a14e-4a7d-9e12-84ee4678aa68	1	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4538b028-0975-4573-8a4c-c03191e8c65e	c8cb3636-35f3-4916-a79b-79432b68d64c	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	1	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d4b89c91-f223-4d98-99a9-fa1b719a29c9	ab2d010d-3ddc-4eeb-8dd4-244a696014f8	689a3789-11b3-40ed-b32e-b948af298ef4	1	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
113a93df-044d-40e4-9932-ac7d76170cd3	68f60d2c-fd12-478b-80cf-7232eff2b77b	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5947d9ff-1ed8-42a2-975f-60bb6c6e9b81	ab2d010d-3ddc-4eeb-8dd4-244a696014f8	b52a5f8e-5cab-4fca-8b5c-d07230467720	1	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
72992d55-deae-4f47-8c28-b92ac164d03e	47735ddc-0dc8-4a7d-8c1c-0563238a8fa9	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	1	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7b2d2f80-e0de-4bdf-82c6-6b045b36ab47	9b6a6615-edfe-4a27-85bc-daf8acbd1f7b	d413cf58-d628-477f-82db-26c2199271de	1	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c25f59e3-0ef1-4c6a-8b84-2b8e301b3c72	aebe01a4-90a1-42f3-b194-de503cc1c01b	57f39d16-c1e6-49df-ac39-e1e9870e55f3	1	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
70ca9e72-d862-48c5-9202-473620cbb382	03d5b43d-13ac-4bb0-a643-081008d27809	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	1	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
86ac64da-cb85-488f-96ce-4f45e53bfec4	916b6554-61c4-4a49-958f-26f268aeacd6	8b435be1-19f4-4571-8643-dd261e2e6807	1	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b1efe7ea-4ed2-4ff6-837d-65c2cb8f629a	b6b45b42-12bc-415e-9efe-ba9357190f5e	d620a7c3-32ec-4dca-8ed7-b5d87326818f	1	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1df28ffd-6a48-42e8-8799-c0394328093f	72fc897e-e05c-4522-99cc-1c493d1a1301	c2f85493-b833-48d0-900b-ae08f1aa9ff0	1	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d82bc4c-148f-4ef9-b071-7feafcaef7f0	9debfcaa-7f57-47c0-b3f6-b00efb02dc5d	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d5990b26-8cbb-431f-96bb-f90393aa536c	6dcf74ce-fa7c-4e87-bfe1-e170e230b3ab	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	1	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aff828f4-3946-4b21-9322-c487165a9e7c	f5db4495-46be-4cd6-817f-05d538a758f2	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d5ff598-d8f8-4f6c-8bda-a666893b3570	451626db-18b1-49af-803a-1ba420462b32	514aa522-6bff-4165-b78c-6b518f99dccd	1	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cd4aa3cc-c7b6-4a77-b465-ba326d35b3cf	18abcf04-950e-4943-8ad7-c24d2a243174	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	1	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8e002da6-d60e-4b6f-bba8-f9964cca520e	baa905b9-4d5f-409a-b045-cb09375d4ba7	46139fb3-b443-4629-b8c1-c5ac5ff0de07	1	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
09be9b79-bbef-4c95-8a06-54f2618f8d6d	346df24d-f2b7-4e31-bbe3-cdea36a2370e	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	1	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7c801823-3617-438e-8a03-093dbe1aab00	71aab50c-4744-4629-8724-ac87424e7ddd	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	1	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eeb20531-9454-45ec-ad0c-36a5b5e85c80	a59a2938-29a1-447d-801e-f6b12e3300f1	83fffee0-405f-471b-896e-95e3cc01376e	1	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
00c02ed1-6d17-4fa1-a980-c023d5da9bb6	044e2d98-a9f8-4655-a344-2ff307bba8d4	c2f85493-b833-48d0-900b-ae08f1aa9ff0	1	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
37877d2d-e0f1-4333-80fd-57a84cf7f3ab	0cf1abe2-2b17-4051-ae66-d3a989ece9e7	cf3800aa-7129-4651-b3d1-a44125fb51e9	1	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c61348e3-8a79-43f0-81d8-4ff77e40cc37	5b689d60-36ee-40a5-abc2-6c25dedb38b9	7c0aeeba-d877-4f92-9be4-8cb9591261eb	1	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fe1ca3bc-4cb9-424e-86b0-497e3168dde8	c37e4e3b-586b-4192-a54c-fd25efe6fda3	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	1	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eeab9341-162c-439c-b85e-1dc17fa8789c	b300059d-f81d-4370-bc96-f7d556ea0b0c	c49e6332-e143-40b8-9f4c-b23b547fe4ad	1	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
462703bb-bf6b-44a9-91ce-064f08ab10a8	74eba45e-0a65-4e56-9185-c37d47f39713	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	1	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1a898221-9816-44ec-9a9d-69c057fde1fb	e0582ba8-cc93-4a3b-a2cc-1279952dc75e	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e364c4f9-f65f-4081-a70e-f99d84e4a562	a7d38e70-9b00-4e23-b6d1-0a8276edbe29	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	1	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9f47ff07-40fa-49ee-9ec9-275b4ee98ce3	356947bf-9525-4eae-9a7d-b9ed738725e6	93cfa5df-80d8-4387-958e-ff346ba30ab2	1	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cd06941f-daff-4315-990a-08c642578e05	e51f954e-9aa2-4b63-b18a-38db1d5edc60	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8c9c1fa8-33ca-4de8-a6e7-2a8fb61fef00	af1814d6-b892-431d-ac1f-2f432eab3672	4a71ffc2-cea5-450e-8595-bb66ab01757a	1	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a3126c8c-c1d7-4d3d-8cea-3f6c965f3610	c91d7846-9ab6-408b-bb49-d0c988ca66b1	d413cf58-d628-477f-82db-26c2199271de	1	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7c2cd28a-f8b1-4626-bb6a-91528933ac81	a12801b2-fe11-4f3c-9896-c8daffedb990	cf3800aa-7129-4651-b3d1-a44125fb51e9	1	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
30af6d5b-c64c-4cb8-a2f6-70ef540c9beb	7b673281-aff2-4412-a0dd-3723412a886a	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
95cb47bd-6627-4703-a57c-ed93f334b037	3bec968f-fe38-47d1-80fd-ca49f40c02f3	d04c5049-6e53-4505-82d7-c8e46deda892	1	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
59bade81-5058-4458-b3ce-554566d5ae03	911075b2-d89b-48ae-b481-a161c562ed1c	276e4f43-463a-40ad-b06f-698be2cc75b9	1	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
011012a4-73f1-42b3-a715-0493dad62444	8a21fc00-a84d-4934-a166-f9c52fbf9a7c	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a2057d42-daff-44ab-b449-7dc90320b554	af43b7f9-c52c-489f-be7f-3556d14d44b0	0572c891-8efd-442f-b53f-1c1deaae2c80	1	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0a782768-a3ef-4560-8069-cbb37eeb2969	201ca905-79ec-46e2-91b7-d5ad16ae121e	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	1	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e9799532-f58f-410e-b616-fca9a1b072a0	d4685600-2d80-4d01-9583-6db026cf1988	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	1	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
496033f8-19c5-4643-88e8-b21cee481264	d6e0f854-8392-446b-bf5c-7e31593a68a8	bb3baeb6-156a-4b66-877a-70c3309563e3	1	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9b8c8f44-b3d8-42a1-af86-762ee03fba8a	f1ad5537-be27-4fd8-b6b7-f39b7ff13278	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	1	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fe3158d7-ec87-4386-89ea-e4051f690bdf	41af1ad4-ab82-46c8-9507-bca0e26723e0	0572c891-8efd-442f-b53f-1c1deaae2c80	1	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
82371186-8477-452b-bad0-24550c561c53	a42701e9-480f-4e59-ba8c-bb4c728c1aad	57f39d16-c1e6-49df-ac39-e1e9870e55f3	1	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fe5f38cc-f51f-4d2d-a101-00e4b54f9f7d	15f5ccae-d11e-41cd-87ce-005825210c97	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	1	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3e8721f2-c496-43bc-b249-e9924dd7bf29	5a481a43-6837-41b5-b209-1557dca73418	d620a7c3-32ec-4dca-8ed7-b5d87326818f	1	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2dde829a-1e21-4764-8f5d-87a565f0ac61	47735ddc-0dc8-4a7d-8c1c-0563238a8fa9	cf3800aa-7129-4651-b3d1-a44125fb51e9	1	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
13d3ca9c-c332-4a3c-b1c6-157831f52e58	ce413913-153d-40ed-a54c-6f77fd2a25a3	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f548ab3d-31ae-4b0d-8e3e-f4c5362788d8	a8988ad5-6ec5-4168-868d-606284d20c59	d09d1231-6870-4c42-bea1-2f27ed6e6f63	1	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6b4aae17-c406-4380-87c9-687eb2c407ed	61af7e60-8df2-426c-be06-f866e6ed262a	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eb7d621b-2e8a-4746-b7b4-18b2a6885da6	b03a3bf9-ba71-4550-b1f9-edc9e8c38364	46139fb3-b443-4629-b8c1-c5ac5ff0de07	1	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6c4579a2-f2ce-4d6c-9848-4e886a702be4	af1814d6-b892-431d-ac1f-2f432eab3672	717348ce-6fee-443e-96fc-92ee6a9cae8a	1	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
30590b81-846e-4b4a-b0d9-cb0d0148173c	9c661a02-fe51-4046-b7b0-a82f491a858f	7c0aeeba-d877-4f92-9be4-8cb9591261eb	1	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
93f1b5df-f990-4014-8b1c-f7f4c10793da	ae711746-f5c9-4c91-b5be-e391e9cc6c89	0576930a-9c2f-4a34-8181-5757c53c7af2	1	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0a8f3b53-75e2-4705-b7e7-20ce7d227834	17d942eb-9314-4633-a9af-979492ce49c4	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1fe1c36f-eed7-4e50-9f38-8fbafb52f473	7b673281-aff2-4412-a0dd-3723412a886a	93cfa5df-80d8-4387-958e-ff346ba30ab2	1	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f528d43f-aa55-4ae0-abbc-43b2e120a563	cedacfce-ccf9-41e3-8cf0-0f4a4b372e6d	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	1	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
15875b68-d91a-4200-bf4d-dade98277a3d	3fc65409-48e2-4abd-a8f9-eb667547cc89	4a71ffc2-cea5-450e-8595-bb66ab01757a	1	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8960f6ee-5b49-4601-a8fa-89c8f4cf0de5	78416ceb-459c-4d24-a9d0-2aec836fff2e	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
00a995db-2ca3-4977-8595-a799e0169176	33e2d368-d23a-40b5-9010-c36e82235107	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bb14b080-554c-484d-9461-092517a4e7df	960efc6a-3dd2-4e8c-bffe-c113f928889b	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	1	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e3de3db5-6ad1-46fa-8d28-81c62da9f11c	e41a7b68-36ba-4923-8fd8-13a90b0254b3	46139fb3-b443-4629-b8c1-c5ac5ff0de07	1	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a8f195a6-c075-4eff-9472-b24b4497d0e0	94c5c2b8-7666-4f0f-b944-0c64412bee75	b52a5f8e-5cab-4fca-8b5c-d07230467720	1	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c3b9c0e0-ce8a-4fe1-b83d-38b9cffb2a97	b4a023a5-8311-4677-ab40-a7aafaaf1e96	a6d85cd1-0f47-4f6b-9794-e05f81744722	1	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cad06e24-e17f-4d55-a70c-30e80358ec61	26794317-eb6c-44e8-b3d8-2fc66d66092c	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	1	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0b3d31bc-be91-4da1-a07f-c4038af00f4a	65a1bb2c-75b4-48db-8fae-cbe8038808b8	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2a705b65-dcf1-4215-8525-a567d6b642cf	acafca1d-3010-405b-b5b4-0b1ba7093b21	010d6df1-03ed-4ace-a34e-e389424e9050	1	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1ad88edb-9de6-45ee-8ac0-793f2ac61f91	42aa2824-9ef8-42f1-88f0-47e0e36adc45	57f39d16-c1e6-49df-ac39-e1e9870e55f3	1	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
846cea09-2475-460c-aaa5-e47e547ac725	a2ee1fec-2eab-46bd-9095-236b911eea97	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3b60ebf3-50c5-4b07-8d5f-73a2524bace6	a2774201-c2d3-4c7c-8d17-559bb6cbee19	514aa522-6bff-4165-b78c-6b518f99dccd	1	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ee85781e-de6f-44e7-aca3-71491be0a4c6	17778224-4da1-459d-b96b-0b9005435909	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	1	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fb6c742d-0708-450c-abf7-f3982c3a7b13	d61cc827-4ffb-4ead-9872-76c34dc8d400	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
77c87bbc-539e-43b1-9108-652954bc6464	1046377c-3ca2-4f05-98d3-40e0afcf6f1d	8b435be1-19f4-4571-8643-dd261e2e6807	1	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
74f60e1d-39e8-4e81-a210-3c67b56ffd1b	3b9ce712-605d-40fe-a165-ff7579e6e4f0	8b435be1-19f4-4571-8643-dd261e2e6807	1	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b3b9529f-4c3a-4f1c-876b-26835f714a3b	54f3f6af-d087-4e8c-9307-9f876b8d2585	8b435be1-19f4-4571-8643-dd261e2e6807	1	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
620a1c63-9835-4797-b5b0-609c3bee7907	3a7e017f-ce79-4a18-a86e-ee692c42c2d1	46139fb3-b443-4629-b8c1-c5ac5ff0de07	1	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d61558c7-c37c-4d65-8600-c26a88848c66	dfc274a7-842d-439d-9d53-c76a3977d4a9	0576930a-9c2f-4a34-8181-5757c53c7af2	1	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
588a69a6-4db3-452b-a37a-db103d300b4c	3875b474-0f31-4332-b99f-9b565b00d461	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	1	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e434890f-c18a-4e25-9354-51a5b81ec4ab	42aa2824-9ef8-42f1-88f0-47e0e36adc45	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	1	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9eb2463f-860e-40e0-966d-14549fb190f5	f5534c39-5c40-4f2f-83e6-de7ec6effb3f	276e4f43-463a-40ad-b06f-698be2cc75b9	1	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
810d3007-cf7c-4666-80a8-d564766b6d07	49b006f9-4539-405f-9f94-09e38a739005	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	1	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
af9f80aa-8f32-486c-8e92-b865ce6bdea7	1afdeb54-27db-4f67-9e99-b9f7311a65f7	0576930a-9c2f-4a34-8181-5757c53c7af2	1	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8de49968-6191-42b0-bd78-2336ea80cb0b	4749bbba-8f0a-4e22-b9e0-d0bdb0a61509	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	1	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e8808058-7596-4cd6-801c-39840e42da0c	01801415-1b5a-44d3-b3c5-dde11b06547d	a3314b6c-1546-4000-a36a-a6c776247f9a	1	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c645ad21-e0a3-43f7-a679-bffdb74ed026	c17985cc-edfa-42a0-8019-4578916a0ed5	a6d85cd1-0f47-4f6b-9794-e05f81744722	1	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
223fd2ce-7a47-4d14-bd71-7df2400735c0	b2d6c82e-a8a7-467f-bb7e-63ac91d161ad	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	1	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f467fc73-129b-46a1-9f5a-05faf0f62caa	65022266-2c27-4beb-a104-3e467a525b6f	a3314b6c-1546-4000-a36a-a6c776247f9a	1	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
09f53636-198a-4cc6-b61c-0efde1576b4a	f5534c39-5c40-4f2f-83e6-de7ec6effb3f	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	1	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eb4083da-72a7-44b2-9a3e-e3b20b8df48f	f2b436e8-ee0f-4702-bd35-b758c569c219	e8288639-c50e-416c-93a8-bedb29c169f4	1	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
727eae4e-ffcd-4221-81f5-f75cc43dd75b	cbc26c58-a97a-4f2a-8831-d46909f4222f	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
612cdc5c-7507-4e60-8043-b2d6b5f4f778	7f8147df-1bd0-4287-b6af-b7f9e5c32334	46139fb3-b443-4629-b8c1-c5ac5ff0de07	1	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2ced0756-66ac-4ae8-8e14-1a64a06b53e4	f45e2a8e-7e31-4506-be04-f756e729ed7f	d413cf58-d628-477f-82db-26c2199271de	1	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
56fc78be-89fb-462e-a786-331c59a22469	9a08e78a-2854-44b0-8642-9c795d5e0160	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2d593702-324d-4032-b930-b387ac5306a5	60068966-6de1-48f1-b649-08f4bb70bd7b	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	1	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4a7adb4f-1570-4ac4-8073-b8f352c4cc3c	aa8d2619-249c-4724-878e-7acff61d3b18	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	1	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8359ebfe-2c59-4982-9e0d-c307bc254d5d	817d19b9-5383-423a-9852-6adbbfdf3d75	d413cf58-d628-477f-82db-26c2199271de	1	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
db576550-6cba-41ed-af9d-ca143b91315f	e8c6b522-6d05-4cf4-82d1-8ba2a9697f40	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	1	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
961a69ae-f950-4441-980e-2c97dbb0d2ce	516c760c-aa9c-4f4d-b324-d6a94eba0f3c	57f39d16-c1e6-49df-ac39-e1e9870e55f3	1	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
940bc5b7-f0ef-40ac-95bf-03422b312550	324f609d-0b11-4790-9291-ee70878d97f7	717348ce-6fee-443e-96fc-92ee6a9cae8a	1	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c67f2a22-33ce-4dd3-a5a8-5e3484f3f346	cdd5db0a-b50a-4d9e-acff-14f165ca987c	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1becdd69-21ab-4f91-9220-5db408973194	b300059d-f81d-4370-bc96-f7d556ea0b0c	0572c891-8efd-442f-b53f-1c1deaae2c80	1	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
53e90644-b75b-4b2b-ab1c-b422eb49d055	44734553-b21f-4269-a5c7-5a1eca042d59	a6d85cd1-0f47-4f6b-9794-e05f81744722	1	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
49f12524-e1f5-4255-9cf5-e937a1e37197	0a6da96b-f001-4aea-ae3c-0ffc9554bfd2	c2f85493-b833-48d0-900b-ae08f1aa9ff0	1	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
edc9d98e-e035-4e68-a280-b1444840cd4d	1c0b4668-5fa0-4548-88d7-e0d9d8a3dbd0	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	1	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d40290e-5817-4041-9ea3-594442354356	1df04230-0e18-4a30-bace-e09e4b25b642	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4488af11-09e9-438e-8f26-b3dc16299195	fa065969-0dee-4888-86b1-ba645d478746	d09d1231-6870-4c42-bea1-2f27ed6e6f63	1	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c0e790a3-2249-43f4-b071-eab8bcedcb51	308bcfc9-9e15-4767-8719-0c6983362044	0576930a-9c2f-4a34-8181-5757c53c7af2	1	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d63969c6-b056-4883-b21b-00267fbb8cc8	e0582ba8-cc93-4a3b-a2cc-1279952dc75e	bb3baeb6-156a-4b66-877a-70c3309563e3	1	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9eca7d0f-50f7-4fca-aba5-0d45bce89a4b	e80df973-2b1e-4e56-bd36-f7e6561ef1cf	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	1	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
56f0cd92-c824-4ac8-8161-a2e36b71392b	ce413913-153d-40ed-a54c-6f77fd2a25a3	b52a5f8e-5cab-4fca-8b5c-d07230467720	1	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4628b1e4-ad4d-4944-92af-eee07ab64596	90dd7840-d615-4dff-9ed7-2d30d487c8a6	7c0aeeba-d877-4f92-9be4-8cb9591261eb	1	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9e7eb1e6-923c-41df-9ce6-33950f091654	aa6cd53a-f9fe-4798-8398-16d9c9145fc8	d04c5049-6e53-4505-82d7-c8e46deda892	1	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fe62b95f-d502-40c2-a2fb-322b17e8ec53	413273b3-2fc5-4051-a80c-1162f72ebf60	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
30486297-120e-4efe-ad00-524f57c32798	73c2b60d-2408-4d5f-96c9-d5ca5f378304	a974674c-a14e-4a7d-9e12-84ee4678aa68	1	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c2302308-8858-49c8-9e89-fbbafe589a88	dec0af83-af62-42e5-9ebd-895fc90f4101	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	1	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ca389b61-85da-4ab3-890e-6e44b765085e	e28ccb55-281c-4856-9fce-287eeb1bf6f5	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	1	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6116d27c-0de2-4c34-a179-f830d58c2067	1dd24097-9e1c-47da-b95a-18fe766f62a9	59a062f1-5222-404d-973f-3088ac2465b1	1	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
868c3cb9-762f-4914-8c5a-1f03be18241e	c4c6c287-42f6-4a0a-82c6-234a088143fd	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	1	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
817ebc0f-8971-4d72-9cde-d499bf652489	341fda27-f537-4361-8d5e-c8f4b305f4b4	7c0aeeba-d877-4f92-9be4-8cb9591261eb	1	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
418e53d0-8051-414d-a613-1d16024ad06b	11f58ffb-d5e2-4c50-8dbd-0f8cdb47954c	83fffee0-405f-471b-896e-95e3cc01376e	1	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cb31f5aa-2355-434a-abcf-589e5811239b	ad30f787-9a73-41fd-b124-6a1aebfda11a	d09d1231-6870-4c42-bea1-2f27ed6e6f63	1	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
78a29b97-d0ec-4e0e-8b51-c43c60d20814	e2e87f75-e621-491a-b819-ed4493e15cd5	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	1	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8aa5ed6e-c99f-43dc-afc2-a39f2a2be735	20175126-96dc-42e1-b7cd-0c1e5080292c	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	1	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e340846f-74b0-4503-8589-5db45272e58e	d3e8d233-d659-48bf-b508-88654f4456e6	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	1	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dec771cc-773b-4eb0-bde9-1f9e1afd0174	e104c826-a01c-46d4-8377-44ba2c79641c	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6cd133f4-046c-4718-ac7d-51f19dca1e85	3a83046a-5888-44d2-a476-edba61d2f61a	a3d4b59a-f601-4155-8f2c-e48a8173bb97	1	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5c45f5c4-432e-4a37-a886-a7eb6f6abb55	799383a1-95d8-4e37-ba78-f001c4671517	0576930a-9c2f-4a34-8181-5757c53c7af2	1	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c8573a60-b758-4494-83e5-6c1663884fef	7007c848-cab2-4032-bcb5-10479d45f75f	c49e6332-e143-40b8-9f4c-b23b547fe4ad	1	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
53a277d8-5cf8-4e26-8d3d-abac2c1ffe91	7561b5a2-dafa-4040-a269-0cf94a64aa82	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a3ec57ca-dd21-44cd-bded-ecca8e99633e	5ec30e08-da26-4cad-9f94-906cceee5624	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	1	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a038b83b-86d7-4a6f-bb36-38dca386f57b	ae5fc031-12b6-4fe6-9b93-577caafc4c26	22bebab2-1caa-40ef-b266-639b3bb0529b	1	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
76ca1b5a-c637-4f98-90ee-f2cf6848454d	e521b981-c8b4-4317-ad69-60fe5a09e6de	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eb8736f4-26b3-44cc-8236-dbb62bad6149	c15c8ffa-2173-45a5-8438-f168f7428706	d04c5049-6e53-4505-82d7-c8e46deda892	1	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3251d03e-105c-4967-a248-7ebc00f5cac3	9e674928-6f91-4fb6-8cd3-1019d8dc07b6	cf3800aa-7129-4651-b3d1-a44125fb51e9	1	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
93a88226-666b-4907-a165-808dcdaf819f	0e81a492-af85-4203-9deb-7ecb4778cb7e	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	1	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b2f34fe0-32c4-4be4-856a-f0697f4ebc84	45b8f496-f798-4fda-8464-138b8a47793e	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	1	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8a816b8a-2f06-4270-af0b-d1855eb0526c	48b976be-368a-4840-85ee-cc79eddcf95b	4a71ffc2-cea5-450e-8595-bb66ab01757a	1	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
608deb8b-6b49-4ba6-aff7-b3dae166e4f6	6b21d51c-de82-463c-9270-2ae4867cb2d9	a3d4b59a-f601-4155-8f2c-e48a8173bb97	1	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
489eb671-03ef-476d-9986-a957600c2136	7233d4e3-4dab-471c-8b5c-71cda89e78ef	689a3789-11b3-40ed-b32e-b948af298ef4	1	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
10d889ae-0716-4093-a1e1-b9570f3d150f	2dde3f0d-bbca-42e7-a39a-c18122798bc4	d04c5049-6e53-4505-82d7-c8e46deda892	1	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bc1a2142-aed0-47a6-92f2-91297f68652e	ed91480c-f6ae-4170-8438-7aec8131f2a2	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b043b1fe-e1c5-4c87-b0ee-94c8d41efb39	3a7e017f-ce79-4a18-a86e-ee692c42c2d1	010d6df1-03ed-4ace-a34e-e389424e9050	1	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
77db79ff-dc2b-404a-a723-6f96e8c6aaf0	b0c6c50f-be7c-4412-8e92-90bd9d833b12	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
71544704-62e8-4b51-a313-d4dcae79a121	285a3163-0953-497a-aafb-57573786bbd2	46139fb3-b443-4629-b8c1-c5ac5ff0de07	1	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ed2e30f6-2ea9-44be-982b-7d4ce2f4a5b2	a98fab5d-9d6b-495f-9d5f-a37db36cee46	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a803f24a-19f4-445a-956c-282087d051cd	758f900a-2d71-4b3d-8c71-e3f67f7367b5	0572c891-8efd-442f-b53f-1c1deaae2c80	1	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bdf27afc-8a8d-4246-9a23-33020de109ef	45b8f496-f798-4fda-8464-138b8a47793e	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	1	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
93a5bdc5-b7c5-4db9-8548-fe3ee2cc654e	9fe68583-e68e-4730-9f4c-8fd11a38ed2a	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2657d2c7-f60d-43cf-8bbe-9fb9adae6509	d14600c6-42c9-40f2-b43e-7ec584e9b85e	c49e6332-e143-40b8-9f4c-b23b547fe4ad	1	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1df798f2-fd5c-429d-b5ac-7b8efa0b86c7	73f0fe3c-a749-49da-8464-91dda826c443	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	1	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a45d7a46-cd97-477e-a338-0a5db0463acd	9686583f-4293-4dfb-a862-80330ab23773	cf3800aa-7129-4651-b3d1-a44125fb51e9	1	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
65c36cbd-c633-4295-a3f7-fdcdc8cb62b5	d2656de6-f33e-4dd0-8301-6a15edb3445c	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
89c116b2-b471-4587-a4de-b49c5ba9b76e	7f3736ea-2440-4d5c-95ba-f83cbef6d72e	d04c5049-6e53-4505-82d7-c8e46deda892	1	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
911046ae-be24-4854-a88e-af69d35cabcd	47e6bbf1-6b34-4e85-8925-9b5e567fc8f4	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7dc98215-0117-4a90-8c94-85d2c4adf68c	a8130946-067b-46ae-958f-855c82395d31	d620a7c3-32ec-4dca-8ed7-b5d87326818f	1	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aab0eb68-c1a7-437e-8c40-3b0de254ff5f	263e868b-562c-4d6a-9955-9289c0c15130	93cfa5df-80d8-4387-958e-ff346ba30ab2	1	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6157a75b-1762-4244-8623-ef08e6626189	420ff426-57f9-4e43-9325-216b95263c06	4a71ffc2-cea5-450e-8595-bb66ab01757a	1	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
318f7444-cb0f-41c2-a8cb-c97011c24e6a	ef5ccddd-ed26-4e3c-b558-c5023abf4e59	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	1	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a181c17f-b82e-4552-81df-84d2eef8d58a	54c45a8c-4bb7-4d08-a12d-92b4c7307b93	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5a938b84-bf5d-4298-83d6-c1244ff5560b	54f3f6af-d087-4e8c-9307-9f876b8d2585	276e4f43-463a-40ad-b06f-698be2cc75b9	1	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dd6439cd-bbad-44f9-b6f6-d1f5dd519c82	8493ed3b-24f8-4086-8895-f68e6cdec21f	c2f85493-b833-48d0-900b-ae08f1aa9ff0	1	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d472e8ed-9be9-4889-b652-d5242abe24ea	52b5abaa-1e6f-49a0-bf75-9d131d335d29	132bac58-39fb-455c-8671-cdf50d22f000	1	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4e96a9fe-8c63-42c4-8931-236490b2ecc5	dbb04a53-5db6-4ef9-ab7c-a02e9340cff5	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	1	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a7be899d-cb7b-41fe-8310-01265f0413aa	9063fe90-e5d5-4ea4-bc3d-2bcf09f17d08	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	1	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9aaf411e-78c8-462d-af65-c6e00de4c753	c06aa566-ab50-433f-b76c-697d753690b4	a974674c-a14e-4a7d-9e12-84ee4678aa68	1	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
209db1e7-80ea-4f4b-bab7-1d2ddddd3a34	413273b3-2fc5-4051-a80c-1162f72ebf60	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	1	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
62030393-dbaf-4302-b528-6041d516ec0a	87414564-588d-447a-a234-b3462a4759f7	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	1	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3ee47ce8-23f3-4349-afde-79ebb982c514	1f22b0c3-c64f-413d-8024-73999f786187	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	1	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3202c774-b095-464c-a196-f5467c591936	c54251e6-9238-439d-aa4c-f861ab1e911d	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	1	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a3d38b08-bce8-4b34-a7fd-e471e6d63a38	c439872c-07cf-45a0-86ee-44bd81586b43	0576930a-9c2f-4a34-8181-5757c53c7af2	1	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
efad9596-3ac6-446f-8e63-8e16ecfe0c65	45043563-f40b-4c9f-a96c-0b03920cb211	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	1	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a73cd3b3-5208-4360-af66-f796a466c39b	e78fd111-2f4e-43bd-80b3-9e755eb5db56	e8288639-c50e-416c-93a8-bedb29c169f4	1	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
362718dd-1e4c-4fd2-a650-9b2295849700	0150fe46-3064-46ec-be84-b5efd8d98486	d620a7c3-32ec-4dca-8ed7-b5d87326818f	1	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ceee39a3-71fc-4e1a-934d-ff8b7e02e851	530e3b6e-83a9-4b9c-b672-118eb36ab2b4	451e1138-e4ff-44a3-955e-ee18e8464d80	1	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ce6f71ad-eceb-483b-9ce7-66a84c8686f1	39d2e9ca-24d0-4e06-8cf4-403a006ba21e	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	1	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ac2b98b1-5294-4261-8a37-de396e15b959	e2444e15-5e55-450e-8b09-22e1157f57a4	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e79fc5fa-e9df-479a-bc27-61ce9bd8b9c8	ee3fced1-7edf-471c-9b7d-5af7e827be77	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	1	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6ca42623-ea58-4daa-92a4-2025cf6f5291	e72c4678-b6e3-465c-a547-916548618acd	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	1	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5f734965-de1a-4a96-bbde-c2970c13928d	2207872e-4613-4c1a-a69b-7868607f4cda	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	1	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5412af46-644b-4e4d-89b1-428512d8f1cd	15e69b96-2a8e-446e-8be7-bf6b8f0d69fe	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	1	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b4c05a56-816a-49b8-a448-7ed3c92da7cb	baf7ec11-de03-496a-b695-94a970d2d3ba	a3314b6c-1546-4000-a36a-a6c776247f9a	1	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
103ddee8-d78c-4325-ba90-fbb8cfb644eb	732b56e8-8b03-4b17-b3a0-61e990538032	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	1	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5a0828fc-85f4-4c03-a34b-d40984e92a64	4b3e0a22-eff8-4b14-b935-b0a68f7d2e7b	83fffee0-405f-471b-896e-95e3cc01376e	1	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
940ad5aa-00ef-4717-9591-e0e06f2df1cc	471a7a4a-811b-408c-b165-8bb9d97e9333	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	1	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
687f0ed3-a6de-4553-9f75-d79560506742	81afdab1-69fa-465b-87b4-3052379de083	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0b0b92cd-fb40-43ec-9e18-bb6cb3551bee	b983bdf8-4ee7-437d-aff7-f40333b919e5	69c66949-c064-46c2-83ec-e535f5ddd424	1	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b6d8b53c-38f7-4d45-a902-5a58c8908089	82526151-948c-456c-b873-55557f652e1a	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	1	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a513824a-cdec-4144-ac86-34443198caab	e86b6520-4a1d-474f-ba58-c4dd42c7c793	a974674c-a14e-4a7d-9e12-84ee4678aa68	1	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2107754a-c80d-4bc6-9b27-b3d754d3366e	bf3139a6-986c-4d0b-b634-b781831b3dc3	c2f85493-b833-48d0-900b-ae08f1aa9ff0	1	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0f306bf6-e65b-46e2-84d0-ef3b5a5e157b	3acf71e6-35b3-4013-821c-27c57648c0a9	d09d1231-6870-4c42-bea1-2f27ed6e6f63	1	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e36f8abf-6ae4-4b4a-a0d0-ee6daf426002	e50f46d7-ce46-44c8-9e7f-36a2d3fcb092	b52a5f8e-5cab-4fca-8b5c-d07230467720	1	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f76eae7a-f284-4885-aa80-33b9f276216c	769029a9-1596-430f-8749-27ffa95790c0	0576930a-9c2f-4a34-8181-5757c53c7af2	1	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f91e637a-bdc5-49d6-8cc3-93c206c42113	aec38ac4-213f-4ed3-affd-1b138aa8ad08	b52a5f8e-5cab-4fca-8b5c-d07230467720	1	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
00968de8-ee96-4f89-b094-ab709a422153	a4a7eb0b-d59a-40bc-906e-e861ff6d675b	1c635cc6-4c91-40d2-8924-8c01ba63241f	1	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1f12f5aa-e3ad-4a11-8be1-25cd6d53fdda	a19252f1-da72-4cd9-8ceb-537ba59f0d58	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	1	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
874faa1b-c4bf-42e9-bf35-23c283d14a33	356947bf-9525-4eae-9a7d-b9ed738725e6	c2f85493-b833-48d0-900b-ae08f1aa9ff0	1	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e49728b5-1fcc-4f49-90b2-b9afec6bf589	4e6a35de-940c-4d97-b7f4-482bfa5df28c	e8288639-c50e-416c-93a8-bedb29c169f4	1	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ded9bf68-f40b-4cf5-8514-2c4c7378b129	db1575b8-4afd-4523-b5af-e940e2727bc1	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	1	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
24816032-9f63-4ec9-a22b-81f95c108210	36816ae2-8094-48cd-a720-999f984038bb	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	1	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
49b78b8e-08dd-4e00-9b73-fdb8a60f8572	2dde3f0d-bbca-42e7-a39a-c18122798bc4	689a3789-11b3-40ed-b32e-b948af298ef4	1	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
75d6bdfb-32f1-49eb-b53f-2255f9c0f1cf	52a309c0-472f-4a6c-b8de-a28550950b91	f3efdb86-bc87-43c8-9d41-912d1d821e04	1	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
705179ac-641a-4112-b2b3-a070c6243e98	b9c7df2c-9c25-4a99-a296-217e49d299e6	717348ce-6fee-443e-96fc-92ee6a9cae8a	1	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
38ee0022-c723-4295-8e23-1f45f883384a	7be28eab-46e7-45e5-a6c1-1bb5b5a0b16f	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	1	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1ac568d4-a990-4e19-942d-db41c68ce287	9fa5ea08-fcc7-4b16-a2b0-fe5e69cf3829	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	2	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ce42f96e-cf35-48bd-9c90-20060377e441	35826da2-235f-450f-a727-813395e0787a	0572c891-8efd-442f-b53f-1c1deaae2c80	2	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5aa24a7d-b231-4ed6-a8a0-0b9ddb09f723	f7a8a32c-0b1e-4b28-96ea-418bbb35c037	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
340b775f-30db-45b0-aa48-5a1affc17452	a81c37e5-8d58-43db-8a2a-4c7728d19328	c49e6332-e143-40b8-9f4c-b23b547fe4ad	2	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
69d17e07-9700-4d47-86c0-ed77cfe959b5	4d4eada2-4ccf-4783-86bc-04a208ee6b45	8b435be1-19f4-4571-8643-dd261e2e6807	2	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0c3b9910-69e6-4786-892d-6d11a4e4d8c4	71dfc8c4-3539-4788-8280-58ccdf80f9f5	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
19875749-f231-4106-b0c5-74bf12d48c76	4fb0de4f-2a58-46fd-9c4b-79075f00818e	7c0aeeba-d877-4f92-9be4-8cb9591261eb	2	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
17fb606f-5dcd-48fc-81ef-2294423c21d1	74eba45e-0a65-4e56-9185-c37d47f39713	22bebab2-1caa-40ef-b266-639b3bb0529b	2	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d56120e4-9b8e-436f-915e-e223bd81adc5	dbf7d621-bf6f-469c-8464-c8e00cc9770e	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	2	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
751b1e62-2758-4ba3-bbca-128a1fff4fe1	713fb165-3791-4111-a736-2215747f3bc8	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0da6072c-fd5b-4c05-b1e7-12b7676d343d	3854802b-a1d0-48eb-b95e-88481ebe450a	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	2	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cf351ec5-8c51-4d2c-9b09-e645eb9d72e9	b65fefaf-76ba-4050-8d8a-3394c6af05bc	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	2	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
23a57761-61f7-46da-9379-69ad40513a2c	9f0c4b13-a7b2-43e9-93e2-69f2284f915f	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cdf28a45-88bd-4cf3-9b1a-ddd2273f55f0	ad436bf5-e68d-4804-a47d-5c633a29d5d8	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
56c226a4-0c73-4267-999e-246d3fe5ed15	952b9507-5a67-472f-b604-8fe86b26ea99	4dcb76f9-1c44-435d-b318-7eae10573f52	2	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9d689cba-b841-401a-ae11-ab843a814441	86e280af-f765-40e7-82df-e0292b0693b8	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d9d56146-05f6-49fd-8641-893a55bc7663	d906ec96-9d16-43ed-ac4d-7dd375bfac16	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9c7e25b9-b0c2-4554-a7d1-bc77a367f29c	004f8fd3-0429-4918-beee-0c2b638fb8e9	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
76c693f7-8eae-4a4f-b6a9-190ae49db084	d3a0007b-3d21-47ee-a0da-c293addfe4cf	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	2	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
50936760-53a2-4303-8824-e80b76232493	3d3e84cc-3247-4432-83ad-72071bd04e24	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8d4ab9dc-728f-4f60-ba27-ebde59b69631	94417d6b-ad56-4f3b-9493-7020a3cc6607	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1ebcd59a-01c0-4c4e-ab3b-1511ae3e83f6	8c7c3138-a3c3-435b-84bc-4ce5bd09471f	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
98ea359b-94c3-47eb-9d51-b65b8610027a	ff20a0a4-6d81-40ae-8e44-ac8d28c17aac	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	2	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
47b6065c-db35-4204-903b-df19dc717a49	61d00538-bf48-4e5f-857a-3306f66377b7	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	2	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d7a0eaf-b424-48e0-9f8d-8317d7c2fc80	00e3d3e5-5297-482d-9d75-c47628808981	f3efdb86-bc87-43c8-9d41-912d1d821e04	2	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c31354b6-c454-4951-bcd8-f101d41abfad	cc5d20b5-846f-47a4-bd55-01902a13e4c1	22bebab2-1caa-40ef-b266-639b3bb0529b	2	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9d9de0b4-9748-4f1e-8fc4-14298cd350d1	bb77e096-7ede-4a8a-8798-4d125c100e88	46139fb3-b443-4629-b8c1-c5ac5ff0de07	2	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ceb02ee9-e5d9-4543-b620-684f0046ccce	139e5c95-92eb-47e7-8331-0727e3929acf	22bebab2-1caa-40ef-b266-639b3bb0529b	2	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fde51304-10bd-420f-84c5-345afd6051dd	bcf46937-cf47-40be-a416-bfe0a5523cee	46139fb3-b443-4629-b8c1-c5ac5ff0de07	2	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b3fdceeb-f031-44f0-bef7-33a81c1048d4	3bc6dd55-b9ea-4dd0-9a30-079542d6d8eb	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	2	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3fe4c526-90b8-4835-b0ae-5432eecd2183	4b3e0a22-eff8-4b14-b935-b0a68f7d2e7b	451e1138-e4ff-44a3-955e-ee18e8464d80	2	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf197e11-7064-466f-ad2e-69318ab2643c	c271dc6f-c3af-405d-bad7-25f66d65a3bc	4a71ffc2-cea5-450e-8595-bb66ab01757a	2	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
25219202-14a4-4962-b5cc-d79d5ee17402	72da683a-7dce-435e-8564-09e933f5ba0a	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ad006efa-0363-4d38-bde1-f6b32dcfbcb0	5b5aecf2-9079-4b3d-ba20-05ef52f36a78	0576930a-9c2f-4a34-8181-5757c53c7af2	2	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c366198b-95db-47e5-a6f5-a1bf3ce19696	58546a50-51f6-440b-aea1-12317d6a9f50	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
02a5f881-62e1-4a54-b4b7-1d3082b7f8b0	17d942eb-9314-4633-a9af-979492ce49c4	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b3ffb0a0-3a2b-491d-a925-ec38b5584dc1	e951189a-430f-4d8d-bcb8-43145128d68b	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0c4cb5c3-be1d-4171-ae92-710efa918e04	935b9b31-2c9a-4dc3-83c5-2453f3020916	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
694b1fdb-c5d7-4927-a4f4-a8344fea4a9d	59610614-6e8b-480a-904b-d8df1b841b14	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	2	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2055e0c7-1873-4883-b3af-6b4e5f332d33	608d81a0-84b4-4646-ac0f-011a5a71319e	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	2	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf73c416-4f2a-4324-a804-d30ead8bb2d1	dd5b10f5-38d3-4c2b-9b83-70ada0dfdeed	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1f7e553f-0852-4150-98cf-2b7b4e9919bd	b39268fb-f608-4783-b80d-1f715fb17eb3	4dcb76f9-1c44-435d-b318-7eae10573f52	2	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
237916d6-a03d-4fa1-83b7-771a12e360a5	8edf1f87-ba3a-40bd-af47-0d26ab5c34b2	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	2	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
68fadc69-6f19-4701-8994-7561fc2af3d8	fcf364e9-5e69-4a1a-afaf-bbfba14ddd6c	cf3800aa-7129-4651-b3d1-a44125fb51e9	2	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
19702c3c-80f5-4ca0-ab0d-9b510f70820d	1b389710-04b9-4756-b0e2-9a23c89d6359	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	2	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f130e4c8-8057-4560-ba76-403217b0fd23	dbeb0761-194f-4015-9563-5879f7354ea6	0572c891-8efd-442f-b53f-1c1deaae2c80	2	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
66387162-2b0b-48e8-a193-07b973c20767	bbc19f4c-bf5a-4ef2-9733-c7f55ef0ffa2	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
36b1bbd2-8fb4-41d6-ad24-235c57ed947a	42a2da6a-3c54-4ef1-b503-abd4c4a12551	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	2	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0a6e2a42-699b-47f6-a3e3-d838fe2876f7	2983d8e9-921e-4e64-ac15-0e54f0415c82	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	2	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
848a4905-ede2-4c07-83a4-8a50170475c1	dec13856-c58c-4eb3-9360-8c814c9842a8	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	2	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c34ff35e-95f4-4897-9a32-3cbee1bfe89a	346df24d-f2b7-4e31-bbe3-cdea36a2370e	d620a7c3-32ec-4dca-8ed7-b5d87326818f	2	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fc587ace-f82d-479e-9d7d-3441431b2258	dcaf429f-66bc-46f7-99b4-226ac442b360	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	2	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
669738fd-0edc-4e40-8c1c-7fac8e2e2eda	a8ec13ba-340b-46f6-ae8b-7ffbb8a5de6a	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
58f60d26-dafa-4f19-8818-7ef6fee75ff5	6d9b2dcd-2639-4166-9a91-faa2dabe9849	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a074e786-6660-47e6-8188-66952c195d4e	a18baa85-6c3c-477e-8baa-00f957633266	57f39d16-c1e6-49df-ac39-e1e9870e55f3	2	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7d1c6890-0765-41b2-a786-a83dfb07990b	c81f38af-435e-42b5-b40f-b96e1aa0ab60	4dcb76f9-1c44-435d-b318-7eae10573f52	2	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
371f1912-9bb4-49b5-abd5-fc4157e5a7bf	5956ef23-ddb6-42d5-951c-3f7ac83fe422	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1c20607d-fa0a-49e0-a086-071af57e4062	4d60e02c-390c-4a2f-9b86-be204d1a1efb	c49e6332-e143-40b8-9f4c-b23b547fe4ad	2	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
13248bfa-6478-4292-8f4f-a200e73c9426	838d47ef-a0db-43db-b7f4-d9525c425989	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
862c6e11-4a76-49b8-99ec-e19639265408	7ce6995b-3676-4097-ac72-b769a106737c	59a062f1-5222-404d-973f-3088ac2465b1	2	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
abe2b018-b099-4eda-b9a4-b66950af9225	fbc9e9a6-3f15-4094-8ef3-92f7e1591362	132bac58-39fb-455c-8671-cdf50d22f000	2	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0906f589-e461-4f55-a720-c37055e3cf17	7007c848-cab2-4032-bcb5-10479d45f75f	c2f85493-b833-48d0-900b-ae08f1aa9ff0	2	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ae002904-5f2f-4a41-954b-a0ba95f1880e	cc464465-7b49-4405-8e6f-c9e3f7c3dc69	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
02b772ff-f883-42a3-9c4a-219d9c6022ed	2beb8800-87cf-4764-872d-e895fae05d96	4a71ffc2-cea5-450e-8595-bb66ab01757a	2	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
647a37ad-4c6f-4f0b-87f3-fa3b95643cf8	7aa6fc59-ac45-4119-8c1c-9344048e9953	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	2	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
83c3f887-2127-43a3-aa0b-4993cffa2cb3	7c926317-e713-4c22-9446-777c0c2c947c	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	2	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b60b045f-87a4-486d-bb4b-3b417c1d82fa	87414564-588d-447a-a234-b3462a4759f7	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	2	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7420f216-e24c-48c0-968f-3d589ec082eb	fb044831-49df-481a-a861-0af091d76757	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	2	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
19ba0cbc-87d6-480d-b424-50b99a576834	23521e95-522d-44b5-ae88-1b545c1fd515	46139fb3-b443-4629-b8c1-c5ac5ff0de07	2	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1c55e35e-c4fd-4be2-8f1a-d17e49286c20	f3683f19-7052-44e5-bbd7-6576601bf5cc	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	2	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
251d5320-1223-4c57-a150-4c38bbd3f3ed	ca88aace-dadf-4ac5-95cd-2d82f81cb785	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	2	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b94a256b-b982-4c87-ab64-c41c8d0b3307	c1c57056-949c-45ea-b328-d6d1a4be913b	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
50e3b21f-e19e-4b61-bd1e-3f6a5b4a95ed	16d4978c-02bb-461f-b5ec-82662df34681	c49e6332-e143-40b8-9f4c-b23b547fe4ad	2	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2b3e3d78-5a17-4e3b-9ffb-75520e8e5d19	e94e7ab6-f09c-414b-a82c-ecc76c9d816a	451e1138-e4ff-44a3-955e-ee18e8464d80	2	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d505a7c-c166-4266-a9eb-cdf3b4b93db4	73e7cf8c-b884-48d0-b876-5d23a938e6f7	59a062f1-5222-404d-973f-3088ac2465b1	2	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b667aaea-0c76-453c-abd0-95dd20d88e60	279c08a6-f2bc-458c-8fb5-7df99c0a395c	b52a5f8e-5cab-4fca-8b5c-d07230467720	2	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
75364a88-dda3-4144-9336-d72cc443cea6	c8203054-2a79-4217-9ddd-78dd091ec1bd	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
067849aa-a962-42c2-9d3f-9913417315a1	214d634f-5c6a-4310-89cb-d8e876ae6e2d	0576930a-9c2f-4a34-8181-5757c53c7af2	2	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
17a64c9b-36a6-40d9-8b73-4ca362b09edf	1c518fe9-bed9-4036-9c98-e21e9e9d7e0d	132bac58-39fb-455c-8671-cdf50d22f000	2	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
61a13906-5e21-4ce7-a467-e3b6610b4687	4a126694-4f04-4e97-9975-c4db71740622	d620a7c3-32ec-4dca-8ed7-b5d87326818f	2	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1eb871ae-e814-408d-8007-a244913bf6de	bad0c2aa-9964-491c-8591-6bab03b3d307	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d286d760-b8d3-4f48-8e1b-507b2ba85768	d924c037-d938-43d9-bfe5-546550ec0a35	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	2	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3bd29203-b7e6-445c-a9c7-7779adec2931	314fe9ef-b696-4354-9f6f-4b423ed90f11	717348ce-6fee-443e-96fc-92ee6a9cae8a	2	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f01a20a4-df90-4dbb-9bf1-606323df6776	575722ca-0f8a-4f47-93f6-9eb1af9d0b84	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8f97b4c5-9502-40bc-914d-dda427645bfb	4480d124-7015-447a-85c2-9d4705d5a27e	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
262fa2e4-a6a4-403a-b28e-e964fa226ad2	8405111a-e0dd-4285-9184-ec2471beb9d2	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b517f429-42a4-43d7-820b-8c80f741030f	1643b937-34d7-47f7-872c-b13cfbc86afa	451e1138-e4ff-44a3-955e-ee18e8464d80	2	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
902b4462-bf93-4e6a-a58f-d9dd59c0b217	8bb3ce90-de43-4db7-b1ce-73244a4abd29	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
29f1e793-367f-4e9f-a47b-858f701b5d0b	acf1e7a3-eac2-49fc-94ac-dfa337383396	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a4707272-8824-4cb1-aee9-57cb48b881cd	f229222c-0878-47ea-bab5-ced6b3717a48	689a3789-11b3-40ed-b32e-b948af298ef4	2	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9390b23b-c97c-4f6b-b75b-f438b16288dd	c84aac92-cbd0-4891-afe7-c2d7b3389c73	83fffee0-405f-471b-896e-95e3cc01376e	2	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d14c650f-6566-4248-b9c6-08392588bbca	2e10d746-5aaa-433c-b01c-f0c711d9b0bf	93cfa5df-80d8-4387-958e-ff346ba30ab2	2	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4333dd0c-b4bc-4e41-8959-e86ee76500a3	3d3e84cc-3247-4432-83ad-72071bd04e24	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e0df5352-9148-48f9-bbb2-8d2ed28c64cf	e521b981-c8b4-4317-ad69-60fe5a09e6de	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	2	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
16dee1ee-027d-4d05-8396-54a594303057	f42a13a6-7ef0-4fdf-828f-8000f3a6e31e	276e4f43-463a-40ad-b06f-698be2cc75b9	2	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c427a1df-c06a-4f13-8254-19f66ccf373d	a9aaf563-b41e-4921-a7b2-691676649aba	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	2	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1e006571-92a0-4c39-bd69-087e5c3bd403	f5f36a14-bfa5-43c3-b8a9-20a73de47083	4a71ffc2-cea5-450e-8595-bb66ab01757a	2	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aae8a731-4a2c-4635-bc84-46cfbf244854	4b46a60f-3332-4720-9750-62b06bddb8eb	57f39d16-c1e6-49df-ac39-e1e9870e55f3	2	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0de9273b-154c-45fd-8fa2-db119f11daf4	092640c8-abd0-43ab-8683-890f7e70ecdd	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ad806330-d43d-4db2-86f6-62c936794d7b	c4916f9f-f844-4037-99bc-f92d7d2e0e9e	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	2	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8e0de693-4654-4b5d-b92c-ce0e8998c346	00ec46e5-9ce0-4407-ab63-a9a096e7f706	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	2	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9b2bea1d-1251-4801-af33-21b17e413691	2b96e903-7f52-4636-a975-bff401c74c44	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2e30c5b0-0337-43ff-8738-3ce415b49fc1	f18e6136-e33d-4d71-a965-7e5384029481	010d6df1-03ed-4ace-a34e-e389424e9050	2	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bc92b42e-65f1-4356-846b-09cadb791915	33f3df13-c751-4d16-81f4-9c1da9481ce5	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7120f6fd-b167-4b63-8714-c80540e0fc5a	9274cccf-789b-421a-aafd-37bb06bcef77	bb3baeb6-156a-4b66-877a-70c3309563e3	2	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c018bf19-b97c-45dd-821f-d75572e6a782	a8ec13ba-340b-46f6-ae8b-7ffbb8a5de6a	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0073f7a6-7e38-4bb3-b3c0-4cf0548ce205	f4861aed-3b87-4f58-bf7d-98d7b86ef078	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	2	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8a85f653-42f8-4db3-9503-d0137b27a798	5ec30e08-da26-4cad-9f94-906cceee5624	f3efdb86-bc87-43c8-9d41-912d1d821e04	2	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b740f2a3-a903-4081-a786-ecb6071d9f02	88354dec-632d-407f-80a4-9fc65bfbc7fc	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b2eb90fc-4f61-4061-8cfc-290c5f358d17	d41999b9-5ed9-4265-9c41-f6ac11f28998	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
237c7b8a-4941-4730-ae82-5a39bc7ef7f6	a4acc925-8ce4-4e88-9657-9168b38683d7	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	2	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f196acfd-a112-46ef-bc95-dc96ea38d9fe	a0a2d50b-3141-4dd8-89b2-f80df5a7f9fc	d413cf58-d628-477f-82db-26c2199271de	2	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
08df83ea-0180-4386-84da-2ec55676bf21	7f3736ea-2440-4d5c-95ba-f83cbef6d72e	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f9924812-1585-4b35-b8e6-9cff7b065a52	ba55550c-ef40-4cb0-a6a8-a9915bc2b447	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	2	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9c519e0e-0e17-48e6-8033-c6899ec78081	1d271e45-ea3e-4cc6-a61b-dcd76c63ec68	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2d9185ee-3599-49ee-805b-ec73c8c7481c	8661e7c2-1bf1-467e-aa63-63a48f6b8bab	0572c891-8efd-442f-b53f-1c1deaae2c80	2	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6b84575e-6205-4366-a422-3883074ee281	4c79870b-9f66-49e8-b727-08402277d796	276e4f43-463a-40ad-b06f-698be2cc75b9	2	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e8241c9b-d1ba-4d87-acce-0a933434f880	6c879577-300f-4b2e-a89e-6f6a8a381d05	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d65225c7-e22e-48e1-9176-2a4793531520	a98fab5d-9d6b-495f-9d5f-a37db36cee46	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	2	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bb82aca5-135e-4f1c-8cda-9daf99d0ed6f	fc518724-d04c-4819-8434-8391c825317d	a6d85cd1-0f47-4f6b-9794-e05f81744722	2	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
94eb8c03-e75c-4e14-a0d3-048d7f816a1a	b7209538-3934-400c-9143-e9e7d6c85296	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a77798bb-82d1-4666-a0a2-0e2c2d48d44e	c650d6a9-606e-4205-8cf7-df2d042ff88f	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a0908ae4-d751-40dc-b9b9-43e0bd3ac601	7eb79055-9032-46a2-a72f-839223df4113	a974674c-a14e-4a7d-9e12-84ee4678aa68	2	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
efc50e41-1953-4b8a-aae5-a5b811960d22	96b4dd91-5ef7-45ba-be9f-7bb80fb43773	8b435be1-19f4-4571-8643-dd261e2e6807	2	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4fc15ac9-ce0e-4ec8-9aa1-46a19d5ea963	6d2a7de3-d076-4577-b89f-4b7449155129	cf3800aa-7129-4651-b3d1-a44125fb51e9	2	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e3017f32-66d9-4a93-b976-25f1dbf06989	f45e2a8e-7e31-4506-be04-f756e729ed7f	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
87dc990c-936a-4cab-83a8-72194a380918	61af7e60-8df2-426c-be06-f866e6ed262a	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	2	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5abb9b98-c8b3-4ca4-9dcd-6f1e33eb924b	444bf5f2-f0a3-4fdd-a574-1c107c8c75ce	bb3baeb6-156a-4b66-877a-70c3309563e3	2	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4744c863-4ea3-4649-b049-4876f6b470bc	515e49d7-9df9-44d4-86cc-6454f833f834	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4f13ce6d-f9ba-45e7-83ec-8b5f119da07d	4c5efe4d-5666-47ab-96d3-1a564f2d36ba	bb3baeb6-156a-4b66-877a-70c3309563e3	2	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
76aa144d-0495-4595-9275-c3463befc027	31903a44-bab3-48db-b721-f8dc87a95d01	a974674c-a14e-4a7d-9e12-84ee4678aa68	2	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
738f422f-d48f-423b-bff0-d515b183b73e	c904ffea-4f2b-4f97-b88a-842ea5504536	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	2	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
397f56ff-7426-433c-a6ce-68199122a9e1	d8a28b2c-d6e1-4337-a467-cc4033508a78	451e1138-e4ff-44a3-955e-ee18e8464d80	2	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9ae87650-7bf6-495f-93ba-54427af935f0	c6321803-a26d-44fc-9395-0d34de43676d	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	2	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c24f1c92-9d24-44ed-87d9-e4d9a4f2d1de	96ab7248-cd91-463d-9b08-945700f7df76	f3efdb86-bc87-43c8-9d41-912d1d821e04	2	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f4de3c78-ef7b-4729-8dfa-a97cd88f4d67	baf7ec11-de03-496a-b695-94a970d2d3ba	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e3392aee-66ac-4bd8-881a-09caf269770a	60c35908-d719-4ebe-a49d-68faa88b4321	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bee04daf-94af-4dcb-98be-f852fa71b621	32a6398b-32d0-4d54-b3e4-0280acc9c79e	d413cf58-d628-477f-82db-26c2199271de	2	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f4e50d12-b44a-48c7-8f08-87d2b68e4372	bcf46937-cf47-40be-a416-bfe0a5523cee	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4812d24c-d5bf-4efa-95c3-e26896426c9f	11d38443-fda6-42be-a207-ef0a45ad70be	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	2	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
652d1e75-a712-48ec-aae5-8a4bee150128	e1eadabc-6c40-4ff3-93a9-a914dc022510	a974674c-a14e-4a7d-9e12-84ee4678aa68	2	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5356292d-6464-434b-ac98-a9790acc2bd1	d1d76ab6-6285-4aa8-aa69-df92a7f5166b	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3dd461ee-4e47-4ce2-9453-bb9735aaeaba	e80df973-2b1e-4e56-bd36-f7e6561ef1cf	57f39d16-c1e6-49df-ac39-e1e9870e55f3	2	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
195a8092-fa6a-4033-8821-dd7dd2116667	64e594d6-aacf-4e79-b12c-446250519ee6	c2f85493-b833-48d0-900b-ae08f1aa9ff0	2	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d393ba0b-3ad8-46fd-80f0-557b5d99cec8	74098f06-1217-4d94-a61f-a8329d6c6603	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a228c615-ac49-46cb-96b4-837498564a8a	c4d1a3e4-42f2-40ea-9b4d-4701ac86eb52	22bebab2-1caa-40ef-b266-639b3bb0529b	2	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aeb5b09f-fdbb-4f76-8532-6f05f3548d1e	8cd20854-aa24-4f9d-8a5d-8904c047fc30	d04c5049-6e53-4505-82d7-c8e46deda892	2	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
728f75f3-ba8e-4b95-a920-fa927aa74dd6	59128ed1-0e4b-46a7-838c-cc94859519f4	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
92f4bd4a-10bb-40c7-917e-d6fa16c47b2e	7b7f7a99-10c9-45cc-96ba-10b55cb17e78	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f64ef01d-9abe-4305-911d-963410fd1e21	2339d2a1-cc40-43b0-9b29-3d3553a3e891	717348ce-6fee-443e-96fc-92ee6a9cae8a	2	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7821b527-5078-4b2c-9fb1-d9aff278b370	3e94664a-547c-4588-8038-49f8b8055161	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
763c99fd-4996-453b-b54c-916c70741f09	42a2da6a-3c54-4ef1-b503-abd4c4a12551	4dcb76f9-1c44-435d-b318-7eae10573f52	2	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8530974c-91ae-4c1a-9b1b-9789172753f4	8edf1f87-ba3a-40bd-af47-0d26ab5c34b2	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
65068112-5c46-40c0-bb53-dbe3b008759a	61a5a951-8b4b-4cd9-8cec-2dffb9025158	4a71ffc2-cea5-450e-8595-bb66ab01757a	2	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8ba0d5ba-e79d-43ed-a995-e4c6f91735a5	3b9ce712-605d-40fe-a165-ff7579e6e4f0	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b1c24220-55d2-4abb-b358-db37bc340806	50bd0e09-24f7-4178-8fd5-e87ff0a08dba	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	2	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2c208eea-7ef4-4e34-b95a-78bc10993aba	9f0c4b13-a7b2-43e9-93e2-69f2284f915f	bb3baeb6-156a-4b66-877a-70c3309563e3	2	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9be2606c-fabb-4bf8-b994-18b6f6a92e03	2a6f71f6-716c-4a01-a19b-0fa98a18b222	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e78a5886-ed24-4099-bb29-41deeba8632c	0e41fca2-50f1-4c11-9038-eb8e5510f881	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
efcabf71-269d-4167-a64c-8ec9815811ea	0cbb5b59-8f6e-49b0-959c-182b4b61cc89	93cfa5df-80d8-4387-958e-ff346ba30ab2	2	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1798505d-1a05-4b74-ad2a-ce75ce4cb4b2	31a03291-ca89-42b9-ae38-7783fc3344c3	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	2	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dd7bbfa9-f0ca-42be-90f6-29ca43cd1c79	bb12c07d-2f74-4d5c-ad63-9e081a22572d	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e6c57d02-2324-46fc-adda-2b893da90dcc	0cf1abe2-2b17-4051-ae66-d3a989ece9e7	0572c891-8efd-442f-b53f-1c1deaae2c80	2	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1c7e3c7e-6217-486e-ba39-0a33955d276f	bb12c07d-2f74-4d5c-ad63-9e081a22572d	4dcb76f9-1c44-435d-b318-7eae10573f52	2	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c4d40ad6-f330-46b5-a6e8-a0f4597ace2f	263e868b-562c-4d6a-9955-9289c0c15130	d04c5049-6e53-4505-82d7-c8e46deda892	2	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
318db768-0be3-4df9-8e58-56032ad24dfe	115eef4f-8ef7-40f6-8c11-96bf8797549c	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
69379e06-639b-4172-ac20-f3e1b83794d1	a7d38e70-9b00-4e23-b6d1-0a8276edbe29	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	2	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ea86a556-3a01-42fb-9bba-dbc600c2f544	f9e08907-42c6-47f5-b140-df61790a7769	f3efdb86-bc87-43c8-9d41-912d1d821e04	2	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
195e252d-1456-454d-b96b-10050f191c02	3efa52b3-9e0f-47f8-80cb-1c3f096088f2	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
90794769-da69-4a43-8dc6-48dc2435a1d8	799383a1-95d8-4e37-ba78-f001c4671517	717348ce-6fee-443e-96fc-92ee6a9cae8a	2	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1a451365-7bd5-43a5-aebe-07856e0d0545	61dd598b-a1de-400e-be75-fa2f2e68d337	132bac58-39fb-455c-8671-cdf50d22f000	2	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cda052c1-ac38-4d63-a705-ccf6cfe143f1	0e41fca2-50f1-4c11-9038-eb8e5510f881	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	2	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
98b99b5f-26ed-4bcf-ae0d-9845d9c103bd	858e147d-3c40-4bcd-a1c6-d2945086db0d	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
800bf3ba-8dd1-4a1b-a930-c8e66d4595a7	cc966c0f-8d79-485a-8ffc-20d9c09f4680	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e4cefec0-0458-4dbb-9e8c-b1f51e55c09c	f49c93d1-861f-419a-9a4a-1b6911ae0288	0576930a-9c2f-4a34-8181-5757c53c7af2	2	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c534884d-1e13-4d25-af45-c9d0f2ebdef0	08139a8a-6100-4041-a468-6db30403bb5e	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	2	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e60a65a1-ecf9-4803-b5aa-0351a18848f0	1af587b5-f580-4940-9c75-b90ce23870c7	276e4f43-463a-40ad-b06f-698be2cc75b9	2	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6c66d6fd-1de1-49ba-bc24-a6e37357129a	12eb3375-0fdb-4d8e-bc9b-a3275b75e6db	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	2	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ae983de5-2322-48fc-85bc-4e7449e537ca	ad436bf5-e68d-4804-a47d-5c633a29d5d8	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b8d9ae11-d4fc-4a7e-813a-c087232e9dae	a0a71cb3-f02b-495d-8133-bcf4509d41b1	0576930a-9c2f-4a34-8181-5757c53c7af2	2	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f8331607-cc95-4e72-9e81-18f3d6f714b7	d55de0b2-f528-4a25-98c7-dae44e1ac5b1	1c635cc6-4c91-40d2-8924-8c01ba63241f	2	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b1ec50a6-5bb4-4fa4-af04-907008e442cb	1f7c3b46-846c-442f-8898-4ca8a7da4fd8	132bac58-39fb-455c-8671-cdf50d22f000	2	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
06de2769-c9fb-4eea-9ff2-34b6e3c0acd6	5fc6c03f-86bf-4a9a-a969-06d9ee1d55c6	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	2	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9a15e4f0-df96-4194-b40b-b6e6c54ff663	01801415-1b5a-44d3-b3c5-dde11b06547d	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bb9d2cce-d631-4ff0-a8cd-7d779e6b5489	60c35908-d719-4ebe-a49d-68faa88b4321	276e4f43-463a-40ad-b06f-698be2cc75b9	2	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8b9f1c84-6e8b-40c2-9200-e8be778643e4	214d634f-5c6a-4310-89cb-d8e876ae6e2d	451e1138-e4ff-44a3-955e-ee18e8464d80	2	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bcbe6bed-3d70-48a2-b87d-86fa23b9b584	2983d8e9-921e-4e64-ac15-0e54f0415c82	010d6df1-03ed-4ace-a34e-e389424e9050	2	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
21659c1c-d9e0-4063-83b1-2225c0207a75	f3e56460-8031-455d-8946-6c2496c0b472	451e1138-e4ff-44a3-955e-ee18e8464d80	2	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bd6eda4c-0f39-4c5a-90f3-e8c8ae5b8609	37dde477-e2d6-4e54-b66c-dec5e43a6216	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ad95b838-d938-4cb6-a177-d2a5c39d1fc8	6b9da4a1-bac4-442d-bb65-bea37786e021	93cfa5df-80d8-4387-958e-ff346ba30ab2	2	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7485f0b2-39d4-4d9e-aa74-2554adc3b09a	d4ee78b1-6113-408d-92dc-fa7b7907155f	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	2	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
61205ee1-64c2-455f-81b9-28127fce166a	b73619e9-fc4b-46dc-8597-508b3d607ed8	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
932b7b99-0717-4112-adf5-f31c4419ab93	17f4f2be-13f1-472c-8acb-96edb2177181	689a3789-11b3-40ed-b32e-b948af298ef4	2	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
32131c98-c6e4-4aca-870d-4956b9d477af	4e8a3d1f-3489-4f5c-af2c-6f51c07341e6	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
87a86a5d-f962-48e3-87c6-d8d80f7d2cc1	1c518fe9-bed9-4036-9c98-e21e9e9d7e0d	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	2	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6a24769e-6b97-4ef8-8556-1f60188d71b3	5c69042d-0655-4421-a532-ff8a0440c18e	7c0aeeba-d877-4f92-9be4-8cb9591261eb	2	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f1786761-84b7-4528-b666-2246ee78c5b8	837f0ed8-f90e-4018-b8d0-f75b6d85c666	717348ce-6fee-443e-96fc-92ee6a9cae8a	2	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9b421476-f811-42f3-99c5-6c8809a38ee4	e4b5b1ef-6a96-4681-a960-2d90c194c0f2	7c0aeeba-d877-4f92-9be4-8cb9591261eb	2	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b4d72ab8-c02d-47b1-9547-735afe46ab04	308bcfc9-9e15-4767-8719-0c6983362044	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	2	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6c62d674-376f-4c83-8dff-967bce10a2d7	0a318416-aac9-4f8b-ae13-abfe3e6e05d4	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	2	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7bf8c6b0-b5fe-4e96-b362-835fc4824691	fbc9e9a6-3f15-4094-8ef3-92f7e1591362	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e01495e9-c5f5-44a2-8184-c4da32391771	004f8fd3-0429-4918-beee-0c2b638fb8e9	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e8c2e4d5-e27d-4340-82d2-3513fb4ec29c	8f8f2564-0a4e-4e52-bb58-14cadde1d28b	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	2	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bd0ed7a8-960f-41f9-bc29-e4ff6bb03bf3	a1c1fd9c-b051-4f8b-8328-ee38b3f52280	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d75c0565-9cad-4e03-b6b9-41258e93b875	e9bf741b-e356-4441-83f2-086bb8cb80a8	d04c5049-6e53-4505-82d7-c8e46deda892	2	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1c005288-5436-4988-b58f-ebb0e0993932	098f7f55-55a6-4dd6-a4d8-a3b56a67b538	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	2	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b4c07663-8bd9-4699-801d-d671dd858075	59128ed1-0e4b-46a7-838c-cc94859519f4	276e4f43-463a-40ad-b06f-698be2cc75b9	2	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5049f5a9-6abe-4d14-b42e-065663edce66	cc464465-7b49-4405-8e6f-c9e3f7c3dc69	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	2	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e2e3ed51-10d9-43d7-bef9-4c41b678a661	a12801b2-fe11-4f3c-9896-c8daffedb990	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	2	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
988ba30c-4975-4b79-a42f-7dc06de9cbae	374bd850-d839-4c27-b9e8-ee9a3f72cda9	22bebab2-1caa-40ef-b266-639b3bb0529b	2	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
38e27409-2fd0-4ffb-924e-41cb97d678a1	aa8d2619-249c-4724-878e-7acff61d3b18	b52a5f8e-5cab-4fca-8b5c-d07230467720	2	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
af39ee3f-e8db-4667-b7d8-05c7172ecd7b	f4de5f3f-07b3-4c35-96f7-7ac385c475b9	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d1f5141f-68bb-40b1-b16b-495a6c902836	bd24a131-4468-4d28-8ea7-8803c1bb0e32	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aa388da8-8f8b-48f0-b604-9909a0c373ee	6bfe2447-12e1-4d99-90d0-6e0a9efae8a5	a6d85cd1-0f47-4f6b-9794-e05f81744722	2	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eae45fc9-52f3-4859-999d-6387411f0b7c	3c9c570c-0f48-43cb-b8a4-49befd2d28c7	d620a7c3-32ec-4dca-8ed7-b5d87326818f	2	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f5d1c5d1-bd44-49a1-bfd2-10f21a3100e7	553be188-d1bf-4d0d-9ff9-d58b67a5e0db	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	2	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1c831ef3-1054-41df-ab88-c5ea6798f898	d41086c3-e5f4-4151-8802-4f18de6d7b76	4a71ffc2-cea5-450e-8595-bb66ab01757a	2	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
23ae08a5-a9ca-4301-822c-a990d766f5ff	9ab2e0be-7416-45f6-95fe-420d6f467d02	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8cc7d6aa-06e3-4fcd-9565-dba70fcf170b	f0927e44-ab48-414a-8d49-35a79b90c033	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	2	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
067c310b-e57c-4374-a4ef-00e64a5a3491	e2444e15-5e55-450e-8b09-22e1157f57a4	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
be0dc404-ecd3-4585-9d53-bbc5967c7deb	5768f7e1-10f9-44e4-bae3-969e790f858c	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	2	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9d7e0be2-f037-45eb-80b9-0659b484278c	d565941e-9a85-410b-891a-c2aca9e1b016	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aae261fa-92ce-4bf3-b30c-a7ea25642614	9d93b739-1187-4976-9c6c-0a389356fecf	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6e0fad47-5c42-412a-9ec1-cf4f41c28296	ae711746-f5c9-4c91-b5be-e391e9cc6c89	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fbd63dce-5d93-4e61-a76d-4b5250bc6422	2df2b787-d9aa-4873-bc4b-33e936c4b49f	717348ce-6fee-443e-96fc-92ee6a9cae8a	2	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b97e275e-ba87-4d46-9496-a1cc3e6a6d1c	d41086c3-e5f4-4151-8802-4f18de6d7b76	b52a5f8e-5cab-4fca-8b5c-d07230467720	2	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dc62019d-56ad-46d4-81e3-f16babd7ee05	7eb79055-9032-46a2-a72f-839223df4113	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	2	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a2f4a4d7-a6b6-4bab-94dc-f29e0aee3073	cc080dec-4631-475b-be93-623ae8eecadf	a3d7efd8-15e9-4d59-b159-48b9de13c791	2	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
687494ca-738e-48f2-bb24-a63299cfbd09	f2dbfe7a-ec20-4091-a2f2-7291ad718da9	cf3800aa-7129-4651-b3d1-a44125fb51e9	2	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0368c39d-4aa8-4bdb-b745-1752a64957b3	cc22032a-d9cd-43d9-817e-82f6bb1f3c7f	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	2	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c1a9a9ef-f232-43dc-96f1-fa8ad3b7bf13	9e674928-6f91-4fb6-8cd3-1019d8dc07b6	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	2	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
01584050-5003-4c7b-827b-2300a926ff52	730bac3d-7d1c-4b55-87c3-694a6d0a9734	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5e88691d-c823-4c56-a094-3874ac8f96bc	68f60d2c-fd12-478b-80cf-7232eff2b77b	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	2	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fa220ccc-5bf5-4139-983e-77ad4b5ec933	fac6fc06-5a83-49da-a8f7-77e309b05910	a3d7efd8-15e9-4d59-b159-48b9de13c791	2	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
de4aaeeb-3ac7-4004-80fb-f300067e3341	f2b436e8-ee0f-4702-bd35-b758c569c219	59a062f1-5222-404d-973f-3088ac2465b1	2	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3d5fe30d-e8ee-4574-94e5-82212ad252cf	d14600c6-42c9-40f2-b43e-7ec584e9b85e	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	2	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e5282e34-e9c8-4751-9683-d84eaacd4640	f5f36a14-bfa5-43c3-b8a9-20a73de47083	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fa474364-77bd-4a61-b7df-cae986870b7b	c9c72dd7-7e28-4230-8d01-e3001f5b3566	4dcb76f9-1c44-435d-b318-7eae10573f52	2	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ea2196d6-5459-4d99-89ba-93b7acf9a9fc	52afba9d-c3db-4025-b708-b4486c8f9c10	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	2	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6063acc6-a9ae-4d91-8a6c-2f941c1f53e2	b44e9ce9-4575-4b75-b8f9-a52d5dd1651f	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3c6c0ad8-bb29-474d-a454-6809a67ebf59	dab9151e-fb52-4e13-83bf-9f225f0d4ef0	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	2	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
99a823b5-abaf-4042-bdb0-0b5e9ccf3856	ae5fc031-12b6-4fe6-9b93-577caafc4c26	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
96a2f29b-bd1c-4d95-a2df-299e3a74dee3	50360424-c121-41d3-9696-4a8e8b749192	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6b56d5b7-3c08-49b0-8fee-d525555cf060	5ab39d0e-f629-4ac6-8a3d-7b01edb7f87f	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e1d90e0d-ebe5-42cb-8526-c69079605c7a	cc966c0f-8d79-485a-8ffc-20d9c09f4680	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7460bce4-0a16-4668-8b27-ce9cd0d54aa3	9d93b739-1187-4976-9c6c-0a389356fecf	93cfa5df-80d8-4387-958e-ff346ba30ab2	2	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0730547e-812d-48d9-ab75-8e545517b7cd	aec38ac4-213f-4ed3-affd-1b138aa8ad08	bb3baeb6-156a-4b66-877a-70c3309563e3	2	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7aa1be33-77a8-49e9-9ab9-940809736103	cd13dd4d-e257-4c1b-a28b-592f28d2bacd	132bac58-39fb-455c-8671-cdf50d22f000	2	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9db57e34-660e-4b76-a229-dc6062f6f335	c37e4e3b-586b-4192-a54c-fd25efe6fda3	717348ce-6fee-443e-96fc-92ee6a9cae8a	2	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b0dd82f1-fcb4-4c2b-a7c1-99368cbc4805	ce549fcb-52f1-445e-b0f1-c648b9e91758	0572c891-8efd-442f-b53f-1c1deaae2c80	2	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
902fd504-ddd3-4253-acad-337c436ac119	9a08e78a-2854-44b0-8642-9c795d5e0160	0576930a-9c2f-4a34-8181-5757c53c7af2	2	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b9004edb-9b1b-42e2-8cad-608a9f5b5809	90953f41-aa0b-4642-af45-c432abb6d6bc	a974674c-a14e-4a7d-9e12-84ee4678aa68	2	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a6554cd6-c09a-40e5-83ae-a9cfdcf476c9	5b689d60-36ee-40a5-abc2-6c25dedb38b9	689a3789-11b3-40ed-b32e-b948af298ef4	2	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
737643e5-912a-4620-9684-ac75e5c4209c	49b006f9-4539-405f-9f94-09e38a739005	8b435be1-19f4-4571-8643-dd261e2e6807	2	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
58a5083e-14af-47a9-b771-cf4f16be658c	f8864236-8738-4f25-b825-b503f68690e5	1c635cc6-4c91-40d2-8924-8c01ba63241f	2	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
955dd9e4-122d-4f30-b1e1-265f9ac0729c	5314c407-ab54-4e6b-ae82-c1b08adaec67	d04c5049-6e53-4505-82d7-c8e46deda892	2	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
edd95376-1657-4bf3-94d4-ff8fa03aea40	0425fb9b-aef7-4940-a12c-1ca49264c791	59a062f1-5222-404d-973f-3088ac2465b1	2	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
82487bcd-4897-4034-b92a-af730693652f	ba6f660d-c3e0-498b-b9ba-b85491845eea	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	2	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
61982183-9477-4c8e-b0c5-79e27479b99d	77fa4b65-dadc-4f68-863b-f5fd3250ecd0	1c635cc6-4c91-40d2-8924-8c01ba63241f	2	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c22d01af-9780-4441-a6e4-7b0a51338eb4	9377b22a-92c6-4675-ae71-5b5e65345a31	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	2	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a2d15bf9-de34-494f-b082-440675427293	c33b1dec-a5e6-4e60-b5cc-85aee74cd171	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	2	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
66a6f843-8c12-4230-9654-6b8034a155f4	2d38ce28-911a-46c2-b612-631fa48c4823	1c635cc6-4c91-40d2-8924-8c01ba63241f	2	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
40f1f9d6-6193-4def-8e57-a225802602b2	b57530be-367b-43f8-8680-db9701db135f	a974674c-a14e-4a7d-9e12-84ee4678aa68	2	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1fa416c0-1a7a-4485-a158-ef9b66cc5458	423b7f53-c1b7-406b-b2bf-188fb63cc25c	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	2	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a1c1d341-3fb6-4295-8ee3-e3f31fb5be0a	26794317-eb6c-44e8-b3d8-2fc66d66092c	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	2	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
12ac8fda-be36-45a3-8965-114d10cdd5e1	c83c2c71-5eb4-4165-9a95-a900434b62f1	d04c5049-6e53-4505-82d7-c8e46deda892	2	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eff83632-bf29-4c4e-bb36-404a0500056e	5fc6c03f-86bf-4a9a-a969-06d9ee1d55c6	f3efdb86-bc87-43c8-9d41-912d1d821e04	2	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
51b90a09-5d98-401d-8997-1fc7e2345f72	553be188-d1bf-4d0d-9ff9-d58b67a5e0db	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	2	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cc066afd-5374-4be2-a5fc-118d5eb11bdb	314fe9ef-b696-4354-9f6f-4b423ed90f11	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	2	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f4284358-e747-46e9-9c16-9af32da767b4	115eef4f-8ef7-40f6-8c11-96bf8797549c	d413cf58-d628-477f-82db-26c2199271de	2	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
044a3cad-f9a7-45d4-bd50-ee9c9b73e0e1	f22cbdc2-2112-4425-b850-3545060cf81c	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
162f49af-38d7-4aed-9ff0-5374429f07e3	191b9363-66dc-4b10-bd00-33be3db58f6f	59a062f1-5222-404d-973f-3088ac2465b1	2	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d9377ed4-ace5-4cd1-9f71-5a1b38388883	05b62cdd-d2cd-40ed-9a9a-8ba5da910e49	276e4f43-463a-40ad-b06f-698be2cc75b9	2	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
516b1530-e291-402e-a8e1-d633b3b92fa4	27d9920c-3702-481d-b487-9eea6debc3e2	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e8c1eded-77d1-46a4-88d5-a996297c16d1	dbde865e-b45c-4843-a42d-803a8519524f	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	2	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
befba88f-e2a8-4c83-9dbc-3491e5b6a46c	c326d2c5-4896-4165-8323-b2baed3356d9	a6d85cd1-0f47-4f6b-9794-e05f81744722	2	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bb70b4fb-28a3-4d2a-9571-13ad364dfc22	c17985cc-edfa-42a0-8019-4578916a0ed5	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
44a19e5d-43d5-43d7-b199-696c9dbfdb7d	d55de0b2-f528-4a25-98c7-dae44e1ac5b1	451e1138-e4ff-44a3-955e-ee18e8464d80	2	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8c46e148-daa4-4842-9cda-5aaf692ccd26	acafca1d-3010-405b-b5b4-0b1ba7093b21	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	2	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
331f8f9f-9db9-4dd9-9e4f-318578352bfa	9ab2e0be-7416-45f6-95fe-420d6f467d02	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	2	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
396ca794-bbf3-45b1-8da8-b1481b7350a1	4e6a35de-940c-4d97-b7f4-482bfa5df28c	c2f85493-b833-48d0-900b-ae08f1aa9ff0	2	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b50e5462-e251-4e74-83b5-2ad19aebc058	73f0fe3c-a749-49da-8464-91dda826c443	a6d85cd1-0f47-4f6b-9794-e05f81744722	2	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2d76f419-12ff-4f65-835e-f843b27483d5	9adef5d1-e124-43e4-94c2-e3c903e5b0df	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	2	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c9f21387-99d5-45a2-abaa-40e8c4f600cd	ffb156c2-7a76-44b9-b6af-9acb6e54fdb8	7c0aeeba-d877-4f92-9be4-8cb9591261eb	2	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
945d5780-6d3a-4a39-b2cc-de3b10b50aa9	bdb0924b-95be-4e7d-ae0f-3d8e5f3dd341	93cfa5df-80d8-4387-958e-ff346ba30ab2	2	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dea7075c-f551-4c5b-ae1a-14b1f6d2abfc	44027ede-9ccc-4320-a67c-d60229ceebdd	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	2	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3b5a401f-0087-412c-877d-c9b9ff3475d1	0d9ed7a3-d5cc-4071-aad8-f1d5a5d8ea01	cf3800aa-7129-4651-b3d1-a44125fb51e9	2	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
36531bfe-6c59-4413-9a1b-eae1f5fda1a4	9ea600ef-9d68-422f-bd3b-fc110b346981	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a7be0c6c-e65a-44cb-9248-3870f4f7f911	f549700d-fd1c-42fd-9e6a-817dcb43fffc	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f75b181f-de23-4982-a73d-b3b9ffa1861e	0a4c031e-e8ba-41fd-8e82-d1fc1a7e8eae	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
89ea3ff3-7092-428f-9c27-06807b673bd7	90b91093-880b-41ea-9a24-f83aba5e9f8f	c2f85493-b833-48d0-900b-ae08f1aa9ff0	2	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1d70280f-44ce-4c1c-94df-2de30aad0bec	ba6f660d-c3e0-498b-b9ba-b85491845eea	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	2	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
93648597-7d13-4e75-8b12-317a2e24bd7f	90953f41-aa0b-4642-af45-c432abb6d6bc	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
687a74b3-5568-4cd6-bbb1-92884fee274c	44c80533-929d-45ca-8a97-b562c26e0c71	e8288639-c50e-416c-93a8-bedb29c169f4	2	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
650e616c-b67a-4e5c-80d7-e2cb01f4805d	a42701e9-480f-4e59-ba8c-bb4c728c1aad	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c1543ed4-3645-46a5-a71a-8801791c8ad4	d61cc827-4ffb-4ead-9872-76c34dc8d400	514aa522-6bff-4165-b78c-6b518f99dccd	2	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8807aafa-07ba-4688-ab33-a84836322603	b2f2ec34-152b-491f-9f99-4cc68701f096	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7a16f784-16d9-4445-af39-38dcbb289bba	d3e36229-c4c5-41f6-9905-240dc1bbbb5f	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	2	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c9dee614-809b-4093-8646-25bc7e5995d0	5e577719-4db6-49ea-bb62-03ffbe84021d	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	2	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c5f56282-e5a7-4717-9011-73b46d1942c2	fae5b1ca-a3e8-491e-bf10-6edd05f9a558	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b2471714-4dfd-4ba3-9c3d-32587560594a	f3c475e7-8fe9-463b-900c-edda96c58dd4	276e4f43-463a-40ad-b06f-698be2cc75b9	2	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3f79e5dd-c15b-4914-a214-e850d0878451	dd704203-4544-4ac0-a3fa-3d8426cff0e4	d09d1231-6870-4c42-bea1-2f27ed6e6f63	2	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6221b969-9d8e-4744-b17e-8cdeef67e924	f2bfd119-2269-4266-bde1-c727a5ddd258	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1f9c9e67-1b87-4354-9ce3-2e3f6ae00c36	5d42dc7b-48dc-49a7-a7b7-3818d2ec4146	010d6df1-03ed-4ace-a34e-e389424e9050	2	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bc8577d5-5e08-41a5-9bb7-ab1abdda5d08	46ae3a81-e550-4fc7-80e0-1b72703ac046	a3d4b59a-f601-4155-8f2c-e48a8173bb97	2	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cd97ae0f-311d-439f-9932-7a6cd2383d01	0a4c031e-e8ba-41fd-8e82-d1fc1a7e8eae	d04c5049-6e53-4505-82d7-c8e46deda892	2	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8956c754-cb26-4724-abac-49bddf61f667	77afee0d-2d41-4958-a32b-743f19543af8	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
86f46a4b-6c3a-4384-94c0-91039c8ae0a3	d1d76ab6-6285-4aa8-aa69-df92a7f5166b	a3314b6c-1546-4000-a36a-a6c776247f9a	2	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
55269e17-6ddd-4f32-9802-986955eb448a	af640f9e-e729-4b4a-94f4-63ca562339c2	d413cf58-d628-477f-82db-26c2199271de	2	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f5105cb5-b502-483c-aa14-c6f56c68c667	f3c475e7-8fe9-463b-900c-edda96c58dd4	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	2	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a5293295-cd3d-4a1b-9898-435c99132f0e	41ab8446-999e-4d57-95a6-a80b272142ab	010d6df1-03ed-4ace-a34e-e389424e9050	2	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6c81bb56-3273-44fd-a053-e9347c4d1496	91fdc0dc-5776-43fc-a20b-0be131700faf	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	2	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
326833c2-2d0e-4f73-8ece-3d096153e2c6	e9143438-ba84-4c6a-85f7-5039920e7b5f	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	2	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6784c137-def5-4eac-b4a3-00ba30a2701e	961d6395-fd19-40b7-86da-07718ac797ff	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	2	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6ccbfbab-00f2-4184-9541-f11706a3e47b	c83c2c71-5eb4-4165-9a95-a900434b62f1	010d6df1-03ed-4ace-a34e-e389424e9050	2	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
126ff584-d378-4204-8888-c5485ceab728	508923d7-8d95-4a15-9aac-e8c282109576	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	2	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7b36c033-0400-402e-ba2e-2ce12f50e605	b70087b9-1789-4c8f-ac16-efa8412e40fb	4dcb76f9-1c44-435d-b318-7eae10573f52	2	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1f9c01a4-3454-4d02-9379-446a44ea04b8	5e86351d-26d9-4fe7-b63a-fd5c94b19160	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	2	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3f2da59d-15a3-4af4-a641-f927440cc562	42adc060-24be-43f2-b1ce-1c67f25df7e6	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
775caeaf-f044-4a84-85f4-689ba8816b75	23521e95-522d-44b5-ae88-1b545c1fd515	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	2	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
acadef0f-84ff-460a-9f7f-addb2e67fef7	d927c177-9948-4a70-a42c-e1311242a19e	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	2	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c03e9c4a-585c-4a13-a9ea-66a2fe6cf071	bc0cae1d-895f-4b96-896a-2297c655aeb3	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e82abc2f-329b-4533-86a7-e612f730cee5	748b8ab9-eef0-42b6-b9f6-5146fc312890	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	2	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
274912a7-e34b-4836-8da6-f946db89cf9e	91203bc8-6fb9-4e01-9dd8-8654800994fc	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	2	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ec1a3172-c75e-4c74-947a-b4f7625949d6	bf3139a6-986c-4d0b-b634-b781831b3dc3	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	2	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
adc9de8e-25c6-415c-ba73-537cb58a9a15	9b5c1cfc-f93d-4c98-90c6-8677fefc0365	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	3	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1f83a922-d287-407a-9d04-0f6f9b9e25c8	dacadd56-d6ad-4423-994b-5e45c3b26125	83fffee0-405f-471b-896e-95e3cc01376e	3	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
312552b8-c4bd-40b6-a3b7-87c8e9a7f86b	c439872c-07cf-45a0-86ee-44bd81586b43	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d3dc2f19-25ce-4770-a5b5-dfc879169164	e7c83865-bc11-41f1-b25d-2f6a49631a83	83fffee0-405f-471b-896e-95e3cc01376e	3	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dc8cda4a-b607-49d5-8857-dd7238003c08	bf1f7930-0ecf-4f73-a1a2-9f5bf70cb808	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	3	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0ed10fb6-fe12-4f67-bc0d-3d0268ab88d9	e951189a-430f-4d8d-bcb8-43145128d68b	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	3	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d78502fa-cba5-415c-9c23-86ad2a1b21d8	f2bfd119-2269-4266-bde1-c727a5ddd258	f3efdb86-bc87-43c8-9d41-912d1d821e04	3	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6b056d6b-26e1-4c74-8ef8-450c67f77cd5	430ab126-fbce-41ab-8c2b-febaa31667e9	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3424a0cc-fc05-4dcb-94bc-333e3cfd569a	e9bf741b-e356-4441-83f2-086bb8cb80a8	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	3	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
75513ed3-8eee-4574-9626-91bdcfe40593	341fda27-f537-4361-8d5e-c8f4b305f4b4	e8288639-c50e-416c-93a8-bedb29c169f4	3	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
917c8747-bfb7-4f88-b191-09c7e5a0dfa6	c15b6587-e163-4b51-b03a-91986acea98a	132bac58-39fb-455c-8671-cdf50d22f000	3	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
07b63da2-0887-41ae-881f-86d0e6ac1ac7	995b8bba-6f52-4b02-be56-16b732c6cb2b	689a3789-11b3-40ed-b32e-b948af298ef4	3	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
255c0355-bb34-42c9-9c41-7b389f77a5c4	c4d1a3e4-42f2-40ea-9b4d-4701ac86eb52	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
74526441-9629-4787-ade4-44aba878b0a8	256f9c18-2dd4-497e-a25c-f2e848948316	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	3	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
35113ec5-7dbc-4437-871f-e3f5bdfa047f	6b58766f-679d-4a49-94d2-61c644fe4958	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7a539a96-b8bc-4cb5-929f-ae68f7c7b4c1	b852a94d-3ba8-4c38-b61f-c398dafeee66	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	3	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
89408b8a-6404-44a5-be69-abe1d38d0c00	a6e63af9-0001-4153-a046-6d47ce6b67d0	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5f1ded8b-baae-4c08-b28d-892c1f9271f9	73e7cf8c-b884-48d0-b876-5d23a938e6f7	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3c458927-44de-42be-8b43-3b82d7f9e912	bed764ee-ca9a-4db3-ab6b-534fb92740e9	59a062f1-5222-404d-973f-3088ac2465b1	3	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0bfaf8f7-6216-443c-a28b-203597ab66e9	18ee1397-aed7-49c5-a0f0-30be46063b69	010d6df1-03ed-4ace-a34e-e389424e9050	3	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e71842e3-4a79-4e54-a156-d70801c5245b	e6e17fca-d70b-47dd-ac00-919b1d5aa42c	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	3	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3531472f-ad77-4117-b14f-2cdc09d6427f	b73619e9-fc4b-46dc-8597-508b3d607ed8	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	3	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
75602332-c0dd-4dff-8b79-178a58391ef7	18ee1397-aed7-49c5-a0f0-30be46063b69	59a062f1-5222-404d-973f-3088ac2465b1	3	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d8460319-da40-4579-8c03-3450a462c907	858590d5-ce17-4c3a-8365-d283fa28542c	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
24f745fe-2fe2-4073-a70c-4a73dababfe2	e41a7b68-36ba-4923-8fd8-13a90b0254b3	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	3	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a5506817-5dc0-49c3-bbe2-f949063d87d1	6baecacb-eb21-4755-b24b-d1f6f2dd94d2	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dbee208d-5146-450f-9585-c70c6552a3f8	c06aa566-ab50-433f-b76c-697d753690b4	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	3	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8d8d7b9c-68a0-43af-8538-cf46712564a5	e777cc66-2fd3-4721-bbb9-5cba2e38b778	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1933f816-ef57-49e8-8207-d9c7bc2986d5	025cbce4-59a4-4234-8d16-b140fe081bbf	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
706d4237-84be-4b6e-bae0-2737d0adbc3d	956a682c-2ca1-4228-8af9-415aa0245200	d413cf58-d628-477f-82db-26c2199271de	3	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
82506f63-bcfc-4558-8c29-441335782648	90407b21-0a98-49aa-9517-f766d41bd954	1c635cc6-4c91-40d2-8924-8c01ba63241f	3	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
89aa1b48-625a-4478-ae29-0b7987d55156	e86b6520-4a1d-474f-ba58-c4dd42c7c793	22bebab2-1caa-40ef-b266-639b3bb0529b	3	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0001b2db-c4e3-4487-bb6e-d107032fe4cb	9a49aa68-fc63-4fd3-a5db-27fe1c7cc81a	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	3	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a1ecbb19-0cfc-4567-8a28-81dead5ec4e7	8b02889f-69eb-4711-9264-df89b26f67e1	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
00d3c539-2170-46ea-aaa1-f21e3f0dced0	d9b0d672-286f-4985-9ba8-021202fa2b20	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	3	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
10d1a853-8ace-4791-8fa5-dfd7b2b542b9	c7ee0f65-4f69-4a7e-804a-1f702b4d2521	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	3	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f93b058c-1f67-497d-8d01-a54dffae2511	efaa196f-f777-4e6f-a1c0-960360bd0159	22bebab2-1caa-40ef-b266-639b3bb0529b	3	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9a08546f-0b1a-4435-bbd2-3de5d8e02fd0	e7336e58-86fc-4eff-ba27-79c17d9a69b2	132bac58-39fb-455c-8671-cdf50d22f000	3	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
add8d149-e75e-430e-b1ef-9d8fb0a1ab36	7b9ca835-f77f-4b7d-858f-065d52384acd	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
508a53d3-2e4c-4833-9af6-fb62ccda9b28	265f10ac-9483-4a6b-a553-e485232255b4	d09d1231-6870-4c42-bea1-2f27ed6e6f63	3	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c62eaf0d-08f2-42a0-8df6-5bf00956f7d7	4a7a9432-aa51-430a-9127-4a988fefe196	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
041e7390-516e-4ce9-8b14-7196bcf95113	e94e7ab6-f09c-414b-a82c-ecc76c9d816a	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b1bef81a-d2cc-4d7b-a14a-e48c631ddf1f	d504604a-72be-4da3-93e1-331d02f111be	57f39d16-c1e6-49df-ac39-e1e9870e55f3	3	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1e85f312-6d43-43c2-a6db-d35f2892310a	07d2f56b-615c-48be-a249-189259e8052a	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d81794cc-257a-4db8-a325-930e53eb4ca8	f42a13a6-7ef0-4fdf-828f-8000f3a6e31e	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7c6b90f9-f07d-48ee-8c8c-f9373eebe5fa	7ee18102-0483-4786-a219-0bae86c50043	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	3	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bbd7f67f-67ad-461c-a537-d99d48e2836e	63a49523-020c-4bd5-9fbb-5f8b62afbf4f	d413cf58-d628-477f-82db-26c2199271de	3	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9a10b25e-ac47-4ae2-b5cd-ed00e0366466	2b96e903-7f52-4636-a975-bff401c74c44	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	3	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e100d2fb-8f36-4333-81ef-abac3db46770	fbd51374-47d4-400e-ad4a-f6085f07e540	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	3	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d71d2f5-bb96-41ec-b1ab-88e3dd151bff	b03a3bf9-ba71-4550-b1f9-edc9e8c38364	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	3	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
00833eea-f1f9-4a07-a760-da4f26656c60	b4516995-d551-438f-9f3f-855692d8f068	0572c891-8efd-442f-b53f-1c1deaae2c80	3	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
715ebb5e-6ace-4e6e-ae12-c31a3f8ad74a	47e6bbf1-6b34-4e85-8925-9b5e567fc8f4	a3d7efd8-15e9-4d59-b159-48b9de13c791	3	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
05ff6f8b-f50f-469c-8927-f922c32920f4	48dde4f0-57aa-4a79-a354-5eef33ab74be	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5a5bc347-a2de-44a0-a78c-19613a567736	8368d8d7-9090-41e4-bc90-15f7a084df5b	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
33163401-f18f-42df-94d1-b00f7683a284	c5511bd1-c7e6-4e11-96c0-a4647fc0b185	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	3	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bc1305b5-7ce6-44da-add1-701054caae5d	b54f5794-6aac-499d-a9dd-d776d9e6f900	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	3	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8ff3fe78-75dc-4567-a74e-1026c6031100	0256c3ef-2112-4e0b-8e59-a7c786b1ce86	22bebab2-1caa-40ef-b266-639b3bb0529b	3	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
38a8de3a-cdba-436f-9912-756dfbd91f81	8a7559bb-cbf5-4353-8488-90a19620c9eb	a6d85cd1-0f47-4f6b-9794-e05f81744722	3	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e50ab0da-9755-4454-8a0e-d099b2e45ef8	44c80533-929d-45ca-8a97-b562c26e0c71	0576930a-9c2f-4a34-8181-5757c53c7af2	3	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
09775119-43c6-40bb-9260-3402762c61f4	2d099782-da12-49e7-b1d0-b29b627e112a	132bac58-39fb-455c-8671-cdf50d22f000	3	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e7a51cff-4dd0-4191-8106-16b191fcddfc	201ca905-79ec-46e2-91b7-d5ad16ae121e	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	3	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6ce184f9-9c50-4e97-a206-3168411fc416	1339e152-e0ad-4ed8-a26f-7b74049677c0	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
55ca55b1-f2f8-423d-bb53-001bba4d20f3	6ef8cd0b-1df2-47e8-9a5e-bbc6a45c086f	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
957dbc67-bcb6-4f72-8768-48846e6f1a59	9bd00443-0a3e-4542-9e2e-7a5acb088627	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1605372a-8791-4883-a641-218057733003	1adfc14b-935c-47cb-abc1-3aa128f3275a	4a71ffc2-cea5-450e-8595-bb66ab01757a	3	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
07048bf9-d95c-408c-8159-731da16a8755	800c03b7-fdf5-4b25-aa80-139a387327cc	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a1d4a202-35db-435e-b7b8-3e2fae0c164c	6d5bd472-73e5-43ac-8189-8f1ffc3dd7d8	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	3	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4026a8db-951e-4e18-ad63-b29d83a8a15b	98b5e6bb-cf5c-4c63-9a3d-b997edd4d39e	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	3	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4822fe77-ed7b-4ec7-bc42-95e3a471a3b7	b0afe566-dd60-41ed-9ae1-4219cd051f34	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	3	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
86a7228b-a822-46f7-8fd1-83c0c6f30491	d0ac80b6-2fb7-4935-909f-d3e942a85d68	4dcb76f9-1c44-435d-b318-7eae10573f52	3	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
62bfc12d-5c9c-4bd1-a60e-54edcff63de7	c271dc6f-c3af-405d-bad7-25f66d65a3bc	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
14a0797c-9ed0-4171-a054-2f8b9517f1d2	f8864236-8738-4f25-b825-b503f68690e5	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
26f0ccaa-891f-45e7-9b11-54a5b6a57a16	1a32d39b-83a2-466c-b63c-08b923027649	83fffee0-405f-471b-896e-95e3cc01376e	3	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bb78e7ec-6f7c-4041-8048-c625bff306ff	99f40a2a-e6e0-4a58-9657-b7a785563334	276e4f43-463a-40ad-b06f-698be2cc75b9	3	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3e5cbfa8-8cc1-4c0f-a45c-2a4dbfd356b7	608d81a0-84b4-4646-ac0f-011a5a71319e	4dcb76f9-1c44-435d-b318-7eae10573f52	3	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
118dcdce-69a9-46de-8cb1-7f942cec6948	cdd5db0a-b50a-4d9e-acff-14f165ca987c	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	3	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
30a6210a-4279-4f5c-bd8b-27abfba44630	43dbbaa9-b760-4ac7-bdf9-c3c921fb1d5c	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	3	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
63ac9a29-a57c-4574-bfd0-89d68b0f35d8	653a8581-6413-43c3-9367-3d4df9418eab	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6b3b1ef9-47c8-43a2-b730-32e7f6b7bc3b	5ab39d0e-f629-4ac6-8a3d-7b01edb7f87f	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6f87e8ef-6538-4c4c-af06-14a78b31387b	4d60e02c-390c-4a2f-9b86-be204d1a1efb	132bac58-39fb-455c-8671-cdf50d22f000	3	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
09d86e20-1300-47ae-9713-05b803e50405	f7701bfe-5bfa-4ab5-83da-c3238a6ed29a	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7e15ba62-0b0a-45a0-be95-d29f3d7aeeb2	200e6ae5-0a35-42f6-913b-bc134776654e	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	3	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
40b49ba1-6b75-4ed3-a636-055224198e98	c904ffea-4f2b-4f97-b88a-842ea5504536	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	3	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
29a1d5b2-cf70-4b3b-b0ec-500d52321d74	f91ff990-a691-471f-8042-33fe730316ee	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	3	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
876c8794-9287-4fab-bef5-056066b1745b	1b557418-1d52-44b3-98b0-3a158948754d	c49e6332-e143-40b8-9f4c-b23b547fe4ad	3	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
23011df9-b63d-44d7-a141-ae2c749ab706	6a2d1cc6-99c9-4f6e-8820-11260d1068bf	0572c891-8efd-442f-b53f-1c1deaae2c80	3	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bd1e4607-79b3-428d-b402-42c35a95cbed	17f4f2be-13f1-472c-8acb-96edb2177181	d413cf58-d628-477f-82db-26c2199271de	3	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3bf217de-f973-48ee-9a29-18f64883641c	8ac7d68c-2fde-4ee7-92ff-6601d0d806b2	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
86fc332a-4ac3-42cc-b499-00a2e593a1b4	5956ef23-ddb6-42d5-951c-3f7ac83fe422	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d7afc568-49b6-47e9-8406-f4f7f6d6e667	479cb726-fc8d-497e-a7d1-f7dc8f642509	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	3	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
31e1be76-9668-47f7-bf71-0d9f566b52c4	f8749b98-ca89-45f4-bb70-ddcd79a085a8	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	3	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
83b69d87-9609-4933-8191-16f4ecbbeef9	2fa63f1c-211a-48d6-b37b-17b577906e61	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
329686fa-9afb-4453-af7f-1475c42137ed	5ebb9650-f2a3-4250-af75-e8a5f5e1dba4	4a71ffc2-cea5-450e-8595-bb66ab01757a	3	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d64f8cd4-96f8-48e0-82bd-c40c4c1e0b67	3a5a43ef-6aef-4a74-a960-e1cacbd6a165	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	3	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ed131452-80b1-4c3f-abc8-1bb628f3c208	b26c8b5d-0a94-4360-beec-c220e85e3f1a	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dbee9318-c190-42e2-886e-cbd10fdeed15	3f6adb83-eb45-4a3b-adf5-7e73d54adc24	010d6df1-03ed-4ace-a34e-e389424e9050	3	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
374b2149-43f2-499c-9d53-52fa23ebbd24	d3e36229-c4c5-41f6-9905-240dc1bbbb5f	d04c5049-6e53-4505-82d7-c8e46deda892	3	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
304c76b6-a33b-4ea2-8700-81f05b4852c9	54c45a8c-4bb7-4d08-a12d-92b4c7307b93	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ddf1d83b-158e-404d-9240-095116b6a108	c81f38af-435e-42b5-b40f-b96e1aa0ab60	d04c5049-6e53-4505-82d7-c8e46deda892	3	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
47408179-b985-44d7-afb9-4f6aef187179	16d4978c-02bb-461f-b5ec-82662df34681	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	3	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9f205bb3-ffcc-468f-9288-7c6d172db8f3	3d346b6b-4a74-4739-9e57-942ae8463ebf	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ff3d76cf-3198-4794-8062-0da88cd49cc7	d4685600-2d80-4d01-9583-6db026cf1988	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fb1d57e7-b75e-497c-be21-863c7999e74a	0b207123-e784-4be6-9f5e-0abcf15af13a	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	3	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
119657c2-cdb4-4a4b-81cb-ab363582a88c	408c431b-d3cd-4df8-9e8b-cbc1a6f65524	010d6df1-03ed-4ace-a34e-e389424e9050	3	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5600949f-e384-406d-957f-d8f5e0d88006	993c9ae2-c13f-4c31-ad1a-50a6fd30f7d5	e8288639-c50e-416c-93a8-bedb29c169f4	3	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1c883459-d659-46e2-a1fd-2aad23ba53be	13a181d2-ca19-40d5-8579-513a515c0029	0576930a-9c2f-4a34-8181-5757c53c7af2	3	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
87ef19c9-68b4-4c9f-805f-73398b7d6622	2a544346-4e45-417f-9575-e9302c591522	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	3	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d1594903-444a-4ed4-ba40-1e824f28c1ab	39fbd663-2bf1-441d-adcb-3d4744d75bc0	a3d4b59a-f601-4155-8f2c-e48a8173bb97	3	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8753a6a7-ca5a-4d0b-991c-054b1461161d	4a9301d5-ed4c-4d9a-8ab2-58367120469b	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	3	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cba2c136-450f-45e4-82fc-467db9743a8b	8244148e-7455-4ccf-b73b-352da6c021c8	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
70bf85f6-b30f-4ecc-a45b-e1e1635181a0	c872f669-8ab5-455d-8726-78e391c15435	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	3	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ffa0c369-730c-4154-9278-de30e7ef2376	9444571e-eb71-4ca4-9084-5d15554d3cf1	d09d1231-6870-4c42-bea1-2f27ed6e6f63	3	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b206aedc-87a2-487f-92df-22c21775427e	56033f22-72c7-4eba-9a39-d1f1935143c0	a974674c-a14e-4a7d-9e12-84ee4678aa68	3	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
357f417c-60a5-4853-844d-3e5756dcdbd8	6538d959-8ce1-46b2-9990-76b550fdd3ce	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	3	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c79549db-268d-471a-b409-0d07fdf72a66	69f5d667-1fce-412a-8f7c-abbe5f0a0380	a3d7efd8-15e9-4d59-b159-48b9de13c791	3	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
165e12cf-74b4-4d0c-a1a5-59df0eb9415c	eb81b20e-79c8-450a-b001-da34b1c4a79c	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6de40951-21d4-4093-afbe-f497787cb353	3a5a43ef-6aef-4a74-a960-e1cacbd6a165	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	3	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e5131ca5-0a31-4a61-b212-0ad4cc3e9eff	42bb08de-ecbe-4d57-aa45-e4674f62fb9f	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
94d3b25a-e0bb-446d-b935-df14fbc3c9f7	7c428075-3100-47be-84f5-79310faeaecc	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7929037b-e09c-476a-aff5-27df6d9566a3	72a6e801-362b-4def-9205-834c19c8060a	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	3	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
30c446e1-2862-45d8-94f8-91e074904c57	855f61fa-3476-4c9c-8acf-9a60f057866a	c2f85493-b833-48d0-900b-ae08f1aa9ff0	3	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dc14a80f-b5dc-41a4-882c-aebe505bf8b1	1dd24097-9e1c-47da-b95a-18fe766f62a9	0576930a-9c2f-4a34-8181-5757c53c7af2	3	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a52d41e2-2dc4-4e59-8dba-db5ad03a72e2	45043563-f40b-4c9f-a96c-0b03920cb211	d04c5049-6e53-4505-82d7-c8e46deda892	3	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
93821c9f-fd5c-47e2-82b2-5d0318a9b175	88d8cdf7-8a91-494d-8f36-db765cba34aa	c49e6332-e143-40b8-9f4c-b23b547fe4ad	3	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3be63ac4-616e-4186-874e-f90afae24e05	513019cd-5fe8-4fd3-952b-9c73641b891e	689a3789-11b3-40ed-b32e-b948af298ef4	3	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9593bd93-3f04-4347-9b26-a4d0242b28a3	285a3163-0953-497a-aafb-57573786bbd2	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8dcc7e9e-0134-4402-963f-beb0b2835c4b	bad0c2aa-9964-491c-8591-6bab03b3d307	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2658bfeb-aa07-49ff-ab26-5154335e909f	66a42d4b-4e30-40a5-9ca4-88008dc80099	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1bac1e6b-16ff-4a16-90e5-66987fc3705f	9bdf95bf-03cb-4408-b8a2-fe2321cc8955	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	3	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e4e40e6b-ddc3-441c-80af-627b1ba76e4d	0d9ed7a3-d5cc-4071-aad8-f1d5a5d8ea01	4a71ffc2-cea5-450e-8595-bb66ab01757a	3	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e25bb990-be80-4dc4-8c66-429676fbd88e	1f9fa07c-7152-4a66-b055-4902c535438f	689a3789-11b3-40ed-b32e-b948af298ef4	3	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0fc40435-d95e-4849-a8ef-c0227efa00f7	000b7502-6eea-422f-94d7-6313075dae13	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cc89a712-3647-4ca7-93dd-63aab5f33442	8fda662f-5bc3-48af-8b6c-454d54c1c13b	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
32ab6562-dd32-4ec5-8fee-0e741a777584	91526298-0b5d-46d9-953d-d220165c4dfa	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
104f5dc7-2c9b-432c-9e37-b99824585bef	349d7c20-bf2f-41d4-ba23-fce052efc0f5	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7cfef974-47dd-4102-90f2-71b740428fd2	864a2bab-88c0-418b-a0d1-872a3931fbe4	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fb0b7069-143b-46e1-af9b-9cf21ed5532b	dbb04a53-5db6-4ef9-ab7c-a02e9340cff5	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a553cd4e-3a56-41f5-be7a-ac61bfb9182c	9686583f-4293-4dfb-a862-80330ab23773	a974674c-a14e-4a7d-9e12-84ee4678aa68	3	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4171bbc4-f008-44f4-8892-e1e2db2c2190	f63a99d5-a5ea-42af-be44-e49e6292fc03	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	3	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
78c18ea8-81d9-4dd7-9a67-22745c1e20ae	12d9042c-c92a-4d76-b42e-071f8ef348bc	717348ce-6fee-443e-96fc-92ee6a9cae8a	3	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a29e786d-b195-4943-92be-761adef57029	d50cd0cc-b296-4cc9-b761-aeffaa5d9f47	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
de5ce35c-45ba-4551-9cb4-4fe9ebe4887e	1643b937-34d7-47f7-872c-b13cfbc86afa	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	3	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7c88386f-661e-4662-a5ad-c29fe5079343	eca72b78-b207-4490-809c-3a8c676e5525	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7c3f62d1-74ef-417d-9ac2-6013a65f8eb4	1b8d1d04-ca03-436e-8027-fcea93faa53e	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9653e3c2-b47c-4771-9e79-05ad70b3f562	a31f791e-bda3-4dbb-9d6c-9cc68aa02dc6	4dcb76f9-1c44-435d-b318-7eae10573f52	3	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eef1f1b2-a41a-425c-957a-eaf70acec2f8	0150fe46-3064-46ec-be84-b5efd8d98486	0576930a-9c2f-4a34-8181-5757c53c7af2	3	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cb70ccba-8c81-49a0-b6c9-ce63120d5e5b	efaa196f-f777-4e6f-a1c0-960360bd0159	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2377d82a-e1fb-48d6-907b-0deb687b0a06	d758abc3-9c6a-4e42-bdd0-76cad50aecf4	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4eb44425-8f0e-4cf8-ba14-51b21404e6a8	790a6655-7194-423c-b7f6-e4977b69a2e6	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
22e2f6ce-3bd8-42a6-a62b-693459be78bd	baa905b9-4d5f-409a-b045-cb09375d4ba7	93cfa5df-80d8-4387-958e-ff346ba30ab2	3	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dbdc67a6-f722-4e46-9163-be7a1419aa60	8244148e-7455-4ccf-b73b-352da6c021c8	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1b7ae4f0-aba0-44a2-9c7b-3a1250c26140	744a04bb-6f38-437e-a89b-39cd8b5f962b	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	3	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
abe450c2-436e-4704-98a9-969990dae525	7be28eab-46e7-45e5-a6c1-1bb5b5a0b16f	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	3	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3180a1ad-cba7-41a9-be7c-f43a3cca28ea	9a4b4a1f-4363-4606-9f45-e1d4f1f20148	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	3	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
23df8bd7-b82a-4bef-bffe-973230cbb60e	b901d8de-09a8-4186-bd7b-1a91ad726828	e8288639-c50e-416c-93a8-bedb29c169f4	3	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d7585f4b-2b33-4ef4-857d-ae141d057cee	e99c6c2c-8ea1-419f-acae-701a6e9745d7	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	3	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ea2bba04-2d45-48fa-a330-11a5cf81e91e	2bfc65ed-0a42-4c0c-978a-09e794342726	1c635cc6-4c91-40d2-8924-8c01ba63241f	3	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e3af2789-dc75-42c5-bf06-0816e5d2c5ff	61d00538-bf48-4e5f-857a-3306f66377b7	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	3	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ec558567-9cf2-4e5d-a563-9cf7897ed397	1af587b5-f580-4940-9c75-b90ce23870c7	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
86da723e-2797-409b-9835-827774cdb32c	189f726b-0b71-43ed-a5ea-a53ed75c11d1	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	3	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0f128fbf-c654-4dc9-86a8-3541fba22512	9ed69cb7-2600-494f-8324-f7281cc31dcf	0572c891-8efd-442f-b53f-1c1deaae2c80	3	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
41c68026-2854-43a4-b4bd-604a402b4e75	b852a94d-3ba8-4c38-b61f-c398dafeee66	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7c879eda-3d7e-48c8-8a2d-167232a3ff87	accaf494-7c3f-4f93-96bb-256198632cc7	4dcb76f9-1c44-435d-b318-7eae10573f52	3	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
37d02a7b-b102-41f9-9c03-ccb08786f5bb	dacadd56-d6ad-4423-994b-5e45c3b26125	a3d7efd8-15e9-4d59-b159-48b9de13c791	3	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
22e739d9-644c-4a1f-8cfe-1f4a20bc8e65	935b9b31-2c9a-4dc3-83c5-2453f3020916	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	3	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
40f42eec-77ce-4572-a2dd-8e036aed3b7e	c594f079-7f51-4ed3-a8bb-e6acd8a18c84	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	3	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
25d876ac-9f11-4924-bef8-36bde65d58c9	9f3db135-6098-4cd6-bc68-f6b396780f51	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	3	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
10851812-3146-4e35-b2df-ca2ef92c1cb4	9f95097e-fe67-480e-b63d-e3efe80d70c5	f3efdb86-bc87-43c8-9d41-912d1d821e04	3	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
87e624df-190f-41fd-bbcc-e32eac30d024	365142c8-0b5f-4c15-9568-6efc68bf8b3b	57f39d16-c1e6-49df-ac39-e1e9870e55f3	3	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
88926bff-2a5a-470d-9da6-7c9d5629a5a6	bdb0924b-95be-4e7d-ae0f-3d8e5f3dd341	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	3	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6ab7f1fe-ca2d-46f1-b6f7-c98ced612b28	513019cd-5fe8-4fd3-952b-9c73641b891e	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cc16d773-22ee-468a-a307-963287da9e02	52f621e6-e888-42b2-85be-3f9b36f2e5d9	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	3	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2e91a9d5-2830-42ff-915f-99fad82934b1	12eb3375-0fdb-4d8e-bc9b-a3275b75e6db	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fdc8f3ba-3651-47e6-b11e-b4a1d5be996a	6b58766f-679d-4a49-94d2-61c644fe4958	c2f85493-b833-48d0-900b-ae08f1aa9ff0	3	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0f4af08f-3bfb-4c2d-b3d9-4a4613840b30	8c7bbe12-5e34-4bc6-99b9-7aea5fad3845	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	3	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8bab58d3-25e7-4a3b-b962-c3409125b2bf	4c5efe4d-5666-47ab-96d3-1a564f2d36ba	4a71ffc2-cea5-450e-8595-bb66ab01757a	3	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0da67a4f-fbd3-4aa7-b512-6759979fa251	f747ae81-5d3f-402c-8f25-bdc54eaa626e	1c635cc6-4c91-40d2-8924-8c01ba63241f	3	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7a44c64f-85bf-4c80-a579-a540ab03a263	7af370a7-a058-4ce0-a3d8-760f162febe4	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
482b32da-be20-42d5-9d6b-6efc02fcb2da	3efa52b3-9e0f-47f8-80cb-1c3f096088f2	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	3	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a6ed8ca0-6e77-4dc3-9b68-5b8a8d3b581e	a59a2938-29a1-447d-801e-f6b12e3300f1	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
994e151b-8542-44ff-b130-30a8b15b4e34	27d9920c-3702-481d-b487-9eea6debc3e2	132bac58-39fb-455c-8671-cdf50d22f000	3	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2c86fbf1-5965-457c-b7cd-4d50d3b44583	6664a2a2-fd60-4046-8bd0-57263cac8c31	010d6df1-03ed-4ace-a34e-e389424e9050	3	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a08ea14a-306f-481b-b1aa-edd325a65b39	295e0d0d-150f-46c7-baba-4d037fc3da94	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	3	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d6ca0633-3517-4343-9c40-8dc830e6d720	aad26943-c21b-4819-9356-cb0a2bbeaa0c	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
39178699-c965-4369-a84c-04c78c5c44f4	7c926317-e713-4c22-9446-777c0c2c947c	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	3	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
347b40c2-4460-4f24-a39f-666b01a9dda8	38516bb5-3585-40b9-bfae-4522dca85da5	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7e302d3e-7d07-4bde-8c4a-a95547bc7e0f	d41999b9-5ed9-4265-9c41-f6ac11f28998	4dcb76f9-1c44-435d-b318-7eae10573f52	3	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f4bcefa9-e075-48ae-8fd1-9a7042af55d0	36c3d31b-f011-4d7a-adbf-d0458c9103f2	83fffee0-405f-471b-896e-95e3cc01376e	3	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c9115ce6-26b3-4bf8-b956-c9d8bdf62639	ba96e665-f89b-429d-a49d-c431095f042e	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6c32b9eb-a2ff-4f95-a758-b2ad61616f7e	6bd5f5f0-0439-422d-b1b3-cdb2500f39a7	f3efdb86-bc87-43c8-9d41-912d1d821e04	3	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6670922c-64f0-4fd2-8d3f-be4c116ea067	a453ebe8-695f-4130-b3c8-d4795f1c689b	a6d85cd1-0f47-4f6b-9794-e05f81744722	3	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
55a402d7-bca0-4f59-8656-abdaa65d45a7	420ff426-57f9-4e43-9325-216b95263c06	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
564757c3-d0a6-4cc1-abf3-68e40424ff55	8c04ef29-f905-428d-a88b-6db52e52353e	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9bf90a3d-11b4-4ce1-b9f4-3a37824ac987	bd89f426-3502-41f9-9d28-55708e611bc7	d620a7c3-32ec-4dca-8ed7-b5d87326818f	3	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
98b48aed-566f-4cb9-9556-efc91412818b	7db24315-db93-4144-ae9c-9a809c3790db	d09d1231-6870-4c42-bea1-2f27ed6e6f63	3	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
33a50c2b-721a-4637-81d0-39b3a8c7611d	69d72f04-7646-4587-94eb-1bd5d35920d8	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	3	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cc14b131-ddcc-4b58-a898-6b1182dac030	2a6f71f6-716c-4a01-a19b-0fa98a18b222	132bac58-39fb-455c-8671-cdf50d22f000	3	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
29469717-a4cc-41dc-aeba-89669ff45cb3	7b9ca835-f77f-4b7d-858f-065d52384acd	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
594cc785-da3a-499c-a205-19025f1edb02	b2d6c82e-a8a7-467f-bb7e-63ac91d161ad	d09d1231-6870-4c42-bea1-2f27ed6e6f63	3	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dcb4c21d-1e4e-450a-8426-69ac49d910d8	cbcf0bac-daa9-4256-a715-e7e993cb7972	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	3	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a30dca4a-1b82-46e4-a82b-6b823331f235	844e83ea-e851-4c60-97b5-e47c995b288f	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2efac063-91c7-4b32-912f-3c71ca3e2365	000b7502-6eea-422f-94d7-6313075dae13	a6d85cd1-0f47-4f6b-9794-e05f81744722	3	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
43e66de4-4abb-4b56-be60-918782cf19f9	c326d2c5-4896-4165-8323-b2baed3356d9	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6107484a-b4df-4cc2-8566-3817c83eb301	7aa6fc59-ac45-4119-8c1c-9344048e9953	a3d4b59a-f601-4155-8f2c-e48a8173bb97	3	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f87a75fa-e6ef-41e4-98bb-c7b968b47a59	1339e152-e0ad-4ed8-a26f-7b74049677c0	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	3	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
13d2ef06-97eb-40e0-9031-9e9dfe252451	ee3fced1-7edf-471c-9b7d-5af7e827be77	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7818a237-d7a7-4382-8c33-a7168888afb5	c3202257-214e-4d3a-b704-61e970be82f6	132bac58-39fb-455c-8671-cdf50d22f000	3	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1a54c876-96ea-45e9-8185-b7c487d6bac1	6538d959-8ce1-46b2-9990-76b550fdd3ce	e8288639-c50e-416c-93a8-bedb29c169f4	3	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9079d6f2-ea46-44ad-9eb6-3bdcd5be7c5c	143b148c-cd4a-4e46-8d50-d61f9f4c2835	010d6df1-03ed-4ace-a34e-e389424e9050	3	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
92f11387-d2a6-46fd-8268-a1947b83cfa1	1cae5f9e-29bf-4bbf-90e0-7020b2a39c97	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f9cad80b-7855-44c8-877f-5bace93960bb	a94b9132-5bf7-4ccf-b0d6-f446b1960831	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d7840df5-eaf1-4f8d-9cab-d66d716a41ac	1b8d1d04-ca03-436e-8027-fcea93faa53e	57f39d16-c1e6-49df-ac39-e1e9870e55f3	3	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0a2bf16f-e0bf-4bb1-968d-7814b9ce7453	c87e8bb3-c7b5-47a5-9dc1-3d8337f42982	4a71ffc2-cea5-450e-8595-bb66ab01757a	3	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6180b9ab-f203-44ac-82fe-ade4e69dfd71	d3a0007b-3d21-47ee-a0da-c293addfe4cf	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
487e09a1-9c9f-4c72-8d6a-15d24db06560	8dc42314-4e9b-444f-b210-c01982218c61	4a71ffc2-cea5-450e-8595-bb66ab01757a	3	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
87ddfa6d-7f37-4569-97ef-d1bf59292ef1	ee12d632-0fff-44c4-adb1-7234b09bed40	689a3789-11b3-40ed-b32e-b948af298ef4	3	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
968e80dd-75de-4b4a-905c-c571addb4cb0	d6f5a54b-8e14-43a0-a2a3-5556498d830b	4a71ffc2-cea5-450e-8595-bb66ab01757a	3	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ddebc457-00b6-4241-a101-2f89596e2bda	c6321803-a26d-44fc-9395-0d34de43676d	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a8eb04cf-316c-472c-b238-7946209e408c	50b235f7-a4a7-4e19-8aa4-b394b4df928f	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	3	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b82b13aa-2d28-454c-8d8e-bc1920f23389	5d67ef8b-4012-45d1-a4ce-b0c8d0d4ef53	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	3	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
03f2c9a6-138d-490e-9e48-eca7f9ca3f11	c4916f9f-f844-4037-99bc-f92d7d2e0e9e	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b632cae5-5b85-47fd-bf73-56eea4487e15	9fa4134a-46b0-447d-b6df-301ddb544ca9	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	3	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
340cab0f-3533-497d-a015-fc13cb12237d	6d9b2dcd-2639-4166-9a91-faa2dabe9849	1c635cc6-4c91-40d2-8924-8c01ba63241f	3	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c41d5850-65ec-408a-8dd1-80aa5ccabd4f	8c7bbe12-5e34-4bc6-99b9-7aea5fad3845	c2f85493-b833-48d0-900b-ae08f1aa9ff0	3	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
60cf5346-6c22-4c12-a495-cc49b67d9d9b	6d28569a-b338-4225-98fd-57908ef5b29b	a3d4b59a-f601-4155-8f2c-e48a8173bb97	3	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4fdb3ae6-0cdb-4d57-8b78-9d0a97acf95a	a0dd4aa2-a18c-420e-89ac-6a9508e9e606	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	3	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b639a367-5883-457c-941e-765e02b82c3b	603d977c-a6bc-4b53-b928-4f333a6777b6	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8341fa18-fa0e-4208-a5e4-928fc3dd5d3d	a9e1d432-ded3-4c8e-869d-4ccd32094d98	717348ce-6fee-443e-96fc-92ee6a9cae8a	3	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d93e0a13-1ce5-4470-8c79-8540b9a40213	a18baa85-6c3c-477e-8baa-00f957633266	59a062f1-5222-404d-973f-3088ac2465b1	3	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1b52cb38-991f-4b42-a264-a841805b839c	0e635af7-fa1b-4a85-90c1-f17070236d65	93cfa5df-80d8-4387-958e-ff346ba30ab2	3	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5ecf4d1f-3049-443c-b53f-6c4943c338cf	1db271a8-0d1f-4f36-917a-8206e0bb29bc	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	3	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1022cbc8-d745-4ead-9f7f-1098b6cb9a3c	7e0c57d9-c2c5-436d-b447-eb7e79439372	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
85c77e2d-faaa-4dae-a1c8-07f7378c7422	b54f5794-6aac-499d-a9dd-d776d9e6f900	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4b9d213f-78e9-4555-87cf-93d6822d4271	88a2d5db-9d4f-4ec8-a0c9-1716881a2b31	1c635cc6-4c91-40d2-8924-8c01ba63241f	3	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
691daf12-bef3-4743-8907-e7e7edfa9898	2bfc65ed-0a42-4c0c-978a-09e794342726	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f08aebff-1fad-40f5-8773-2916cbffe038	2d099782-da12-49e7-b1d0-b29b627e112a	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	3	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b4d26abc-3c4b-4470-899f-232514ace35a	6e08b51e-d867-4add-a181-e06f15c6f02a	c49e6332-e143-40b8-9f4c-b23b547fe4ad	3	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2df77dcd-f0c8-4694-a5d9-60170e2b234e	a7d59742-7f50-4471-8ea5-83178402e532	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
60c490e9-e065-42f4-9d83-4fda74a9b568	88bee41b-e0b7-4fdf-9c07-6602888c7097	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	3	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fefbfffb-3ee3-443d-84d8-6fe551bac652	732b56e8-8b03-4b17-b3a0-61e990538032	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	3	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4eeb9fe8-002c-4c1e-ae4a-c5778df9c812	f0df54cc-8181-4f13-b2b1-8cde49c0986e	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	3	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9408ec5a-eef4-4d32-aa49-2607a43640d1	5a481a43-6837-41b5-b209-1557dca73418	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dabdd32e-41f6-45ad-83a2-590b7bd56665	d2656de6-f33e-4dd0-8301-6a15edb3445c	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	3	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c0a3388e-12d8-4a44-94ee-d66d89361409	b65fefaf-76ba-4050-8d8a-3394c6af05bc	d413cf58-d628-477f-82db-26c2199271de	3	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
28ffb0b0-ce20-4e7d-96f7-efa4213dc240	653a8581-6413-43c3-9367-3d4df9418eab	a3d7efd8-15e9-4d59-b159-48b9de13c791	3	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
553d573c-9fe2-4dae-86ab-b1ed3ddc3430	2df2b787-d9aa-4873-bc4b-33e936c4b49f	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3c22b421-b6c1-430b-8cd2-208da1271769	fadc8cac-9b20-427c-944e-253e24f4ed19	010d6df1-03ed-4ace-a34e-e389424e9050	3	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
84bce2c2-c49f-44e1-930c-8e2d59b5c654	191b9363-66dc-4b10-bd00-33be3db58f6f	e8288639-c50e-416c-93a8-bedb29c169f4	3	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
34a6e802-7165-40ed-bc70-12f32563494a	260f3888-a093-4b45-8859-a9dfcea45a3a	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	3	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2efd8487-9bea-4b74-ba94-b2ae7eab4195	52a309c0-472f-4a6c-b8de-a28550950b91	d413cf58-d628-477f-82db-26c2199271de	3	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d057ede2-0fd6-4ffc-9617-91f980f3b81d	72da683a-7dce-435e-8564-09e933f5ba0a	a3d7efd8-15e9-4d59-b159-48b9de13c791	3	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
be80cb2d-acab-447a-8259-31568d96802d	6d5bd472-73e5-43ac-8189-8f1ffc3dd7d8	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a2244fd0-ccf4-4de5-8f4d-31171550eb25	af247be4-bd55-4087-9706-cfd038d57b4a	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
13bdab61-5a7f-4cb8-8209-b98469c6d1c7	41ab8446-999e-4d57-95a6-a80b272142ab	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	3	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f6cdaff6-99c0-4251-a5ff-fdffd36a9f68	443975b2-2199-4d1a-9d83-59edb6c88fa6	689a3789-11b3-40ed-b32e-b948af298ef4	3	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
227e6a68-1329-402b-b69f-bb2ddb14d801	5cf4ca76-71f8-4d8c-83ec-304ca8c03cf2	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
222a77ec-50cf-4bab-a968-4e7008a724cf	d85fb1db-fed1-4a8c-83de-164487338e4f	451e1138-e4ff-44a3-955e-ee18e8464d80	3	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6dd0274c-ae10-4520-9a8c-84c759591144	838d47ef-a0db-43db-b7f4-d9525c425989	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	3	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
694af76d-7b76-48ff-947a-9433f9f53c94	f8749b98-ca89-45f4-bb70-ddcd79a085a8	1c635cc6-4c91-40d2-8924-8c01ba63241f	3	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
74969669-b424-459d-b9d0-37bd52cfbb0c	117f009c-8735-4c95-960f-439f77647cae	276e4f43-463a-40ad-b06f-698be2cc75b9	3	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
84ce59fd-5fa7-4225-9d78-cb7d2551ceed	960efc6a-3dd2-4e8c-bffe-c113f928889b	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	3	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c63055f6-f22a-43bb-a5a3-0f6ed56cefaa	8c856c4a-1584-460b-9686-96270f88b8ef	276e4f43-463a-40ad-b06f-698be2cc75b9	3	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
95467b2b-ea62-42fa-9c53-21f1f21ae7f5	11d38443-fda6-42be-a207-ef0a45ad70be	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
92aeb07c-0b94-4e72-a348-8968e73974e6	61fe448a-8ffc-4288-8af1-a66a018f6253	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	3	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2a71b676-eb18-43ab-a6bb-34e9dfcb62e1	f63a99d5-a5ea-42af-be44-e49e6292fc03	a974674c-a14e-4a7d-9e12-84ee4678aa68	3	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
24763ae9-cecd-422e-a891-94038713ed3b	748b8ab9-eef0-42b6-b9f6-5146fc312890	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	3	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
50d1e877-7d41-46be-b587-03b3e5d0a959	519a3224-edfe-43c2-9511-3a75ec730492	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	3	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8f8255ca-5032-41f6-b3e9-2a043f64c6cb	e7a18fb4-fe36-4f89-a432-1848bedae75d	689a3789-11b3-40ed-b32e-b948af298ef4	3	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
03cd80ac-3503-43b6-974d-5ac90fa61a0e	9fa4134a-46b0-447d-b6df-301ddb544ca9	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	3	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
103267b4-4203-45e5-92e1-d8953d62d2a3	fa5efd46-4f8f-4f67-8575-004cc3c62124	0572c891-8efd-442f-b53f-1c1deaae2c80	3	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c9a93441-4cd1-4017-98b0-af7365b9f096	6f7981b1-88e4-466b-aced-d3f9a1f68fe6	8b435be1-19f4-4571-8643-dd261e2e6807	3	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b0662482-5815-44da-b43f-799d40b53652	dd52af66-ce5e-4585-ae75-16800b9b7d42	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	3	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
951e6c82-fab7-44bf-9a66-dfe98286015c	fbd51374-47d4-400e-ad4a-f6085f07e540	83fffee0-405f-471b-896e-95e3cc01376e	3	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3e3b019e-6eee-4fea-b72e-869ffd695f89	2e10d746-5aaa-433c-b01c-f0c711d9b0bf	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d754be62-5627-433a-b2c2-120c6243bed5	90407b21-0a98-49aa-9517-f766d41bd954	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	3	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8ab7bc2b-33ce-4285-829d-1f3030183350	f9e08907-42c6-47f5-b140-df61790a7769	d620a7c3-32ec-4dca-8ed7-b5d87326818f	3	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
89c21c82-293f-4e0d-bf8d-86ed178ff159	e3474a10-ead3-4093-9cb4-028ae0bb48d2	cf3800aa-7129-4651-b3d1-a44125fb51e9	3	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5f26abf3-ef5c-40d2-b765-9249e3331690	776956ce-b80b-4400-9cee-51be506da9c9	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	3	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ca2d9513-c5b3-4a46-b89f-9a80228e06ee	5e86351d-26d9-4fe7-b63a-fd5c94b19160	22bebab2-1caa-40ef-b266-639b3bb0529b	3	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ff3d2745-59f7-4530-9bf8-c2f3863abfb5	6327b46b-c505-488d-9af8-b4e07f3aaaec	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	3	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a870622e-904b-431b-b765-ec7669d2d4ab	fa8d55ea-e8fc-4a67-ab7d-c3a5dbf062d3	e8288639-c50e-416c-93a8-bedb29c169f4	3	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7dbc5a6b-1244-49c8-94c2-26c2a8df29c5	2ac7fc00-1f5e-4632-93fd-0de06d7c1d55	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a7dda083-fec8-41a2-96a0-b98c96958f2b	ded6f1bd-fdd4-4468-a204-cdadc1644de3	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
136578aa-7d12-4f1f-8d2c-9c4afb370a4e	cc995690-eaad-4fde-92a3-e8350ca766ef	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	3	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b8932c6e-d643-4836-bf4b-df22d3141975	71979b3c-0eed-4490-996a-5374cb24ab7a	4dcb76f9-1c44-435d-b318-7eae10573f52	3	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
05a4822c-3137-4f7b-82a0-3f955e5e1180	fa8d55ea-e8fc-4a67-ab7d-c3a5dbf062d3	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	3	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
94170264-fe82-44ce-b310-768007fa79dd	025cbce4-59a4-4234-8d16-b140fe081bbf	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	3	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e6fc82c7-2917-4bc5-9214-ff19eed46163	c8bc1084-07e2-4514-8c45-4ccca42a6147	d09d1231-6870-4c42-bea1-2f27ed6e6f63	3	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d92233f9-4587-4e30-86c5-1343ba2b3979	6c879577-300f-4b2e-a89e-6f6a8a381d05	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5cb195be-3133-45ff-a034-d7657c6bbc13	7b7f7a99-10c9-45cc-96ba-10b55cb17e78	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	3	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ece64263-505a-4d9d-92c1-84ad39eb6f29	790a6655-7194-423c-b7f6-e4977b69a2e6	d620a7c3-32ec-4dca-8ed7-b5d87326818f	3	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6321ca90-a6ae-4082-8eb7-cb3b4e7fdd3a	9ea600ef-9d68-422f-bd3b-fc110b346981	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	3	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4b0c4954-9937-4ed5-97db-b24a49a63d7e	cc22032a-d9cd-43d9-817e-82f6bb1f3c7f	b52a5f8e-5cab-4fca-8b5c-d07230467720	3	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2c2b97e3-fd56-4bc9-9e52-a8ff7933c93c	cce2c09b-b2db-43b1-aa0f-27f99bc00e3e	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	3	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f8a2e21c-e261-4d57-befc-1d5411388b02	42adc060-24be-43f2-b1ce-1c67f25df7e6	4dcb76f9-1c44-435d-b318-7eae10573f52	3	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5eacc97e-9d23-4791-8859-956ace4d6037	6f7981b1-88e4-466b-aced-d3f9a1f68fe6	514aa522-6bff-4165-b78c-6b518f99dccd	3	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
929f7843-c7fa-4d38-9ff3-0e74ae238bfa	2da40bc7-66c7-4a50-9757-e020fd04233f	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf68b6bd-9b4a-4cbc-b05e-d76de337a447	0386cbff-6b94-46c5-bda7-1cf5ae1eda6e	7c0aeeba-d877-4f92-9be4-8cb9591261eb	3	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d77c1fd-4a70-4675-b0b3-c8e6f4fbe126	e2e87f75-e621-491a-b819-ed4493e15cd5	a3314b6c-1546-4000-a36a-a6c776247f9a	3	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d2c6adc6-3b1b-4553-b778-84746922d4ba	ded6f1bd-fdd4-4468-a204-cdadc1644de3	d413cf58-d628-477f-82db-26c2199271de	3	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3d65e054-01c9-4d57-af30-a9c10f68d587	ccb60341-fa59-44bc-a85c-46fa9d1c1f53	bb3baeb6-156a-4b66-877a-70c3309563e3	3	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
357b70c2-9c81-486b-aeac-266a10b420ae	519a3224-edfe-43c2-9511-3a75ec730492	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
84ba768f-00ba-4f47-bda1-c2de844b3c38	279c08a6-f2bc-458c-8fb5-7df99c0a395c	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	3	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8424c754-df3c-4b2b-b284-204f7b3a94c6	b2fa38a2-f5bf-4541-ad23-b474ef6caf62	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	3	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6818d9db-81b1-4ccb-9466-cd4f13316119	c33b1dec-a5e6-4e60-b5cc-85aee74cd171	69c66949-c064-46c2-83ec-e535f5ddd424	3	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d92b5426-fed4-49d3-84cc-ec31a2272b58	4c79870b-9f66-49e8-b727-08402277d796	69c66949-c064-46c2-83ec-e535f5ddd424	4	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
41ed4238-cb1f-434b-adf4-03033ce56ef7	8493ed3b-24f8-4086-8895-f68e6cdec21f	f3efdb86-bc87-43c8-9d41-912d1d821e04	4	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eda6296a-54c9-4af2-89b5-ba998bb41687	5f9c0032-06b5-4331-9671-b41cdbcda8a7	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	4	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
50df7b62-c191-4983-a0d3-c5af80b72990	bd89f426-3502-41f9-9d28-55708e611bc7	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	4	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6e0bf559-27ca-4bb1-93a3-bf6483fb78c6	9ed69cb7-2600-494f-8324-f7281cc31dcf	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2c489f43-24a9-418c-9544-2723bb8e7bf6	2339d2a1-cc40-43b0-9b29-3d3553a3e891	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	4	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5d841c01-7d20-47fb-a058-0a724cf26660	78628b8d-ebdf-470f-8a42-d43a2696949e	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8a97a063-b7d4-433e-8208-c3fa83ae9d06	c1c57056-949c-45ea-b328-d6d1a4be913b	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
30eb340b-364f-449e-a824-6942c0abf2fe	f91ff990-a691-471f-8042-33fe730316ee	7c0aeeba-d877-4f92-9be4-8cb9591261eb	4	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6c6ffd1e-73cc-40cf-9777-eced1b61368a	9fe68583-e68e-4730-9f4c-8fd11a38ed2a	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	4	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5f9c14e5-db70-41b0-a689-520a13e80bf8	d108d89d-df8a-4ac1-83e1-e2341191e4d2	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
73f2e140-d34b-4dcb-98f6-da319d588e9e	a9ab15af-8535-4511-a3ef-ff5de115f343	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	4	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2ffa56cd-e09c-4729-b099-d5f01dd337d9	952b9507-5a67-472f-b604-8fe86b26ea99	cf3800aa-7129-4651-b3d1-a44125fb51e9	4	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c1a56ad1-9651-4896-814b-ee49c09eaf4c	b395778c-d57d-4c6a-80ea-a3caa387b534	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4dcd20a7-7cf7-4ff2-bb14-770793c618cb	927645e0-58ac-4361-8b53-555c3a424071	132bac58-39fb-455c-8671-cdf50d22f000	4	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a2ac507c-90ec-4990-b92e-36863e32a95e	3bec968f-fe38-47d1-80fd-ca49f40c02f3	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
15f4cfdc-9e60-47ac-aed0-0616d140dd05	83b82f54-b888-45c3-96d4-46d8726f179d	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
85ba6a76-0c51-491b-8e82-2f7758a44769	72a6e801-362b-4def-9205-834c19c8060a	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	4	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
de133832-34e0-4536-8031-2c5979a77e4c	b44e9ce9-4575-4b75-b8f9-a52d5dd1651f	8b435be1-19f4-4571-8643-dd261e2e6807	4	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4bc1138c-7be9-4964-8c9e-022681848ed0	515e49d7-9df9-44d4-86cc-6454f833f834	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	4	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9f631b7b-ab55-4757-8e79-68b4653e17b3	ca88aace-dadf-4ac5-95cd-2d82f81cb785	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	4	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f6a5822b-15d6-459b-a927-c3a8c59b033c	d2e94dce-ae9d-4aba-b1e0-4ab2ea5169c2	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	4	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
881e8849-9e43-49e4-a837-d7f1414da384	35826da2-235f-450f-a727-813395e0787a	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	4	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
256c31be-183f-4861-a314-ee9063a0b9fa	61ea9599-4c17-4692-92c4-7ddc591b742d	1c635cc6-4c91-40d2-8924-8c01ba63241f	4	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e38fa7fb-987f-4d9c-9e0d-2d5ab7f2182b	7db24315-db93-4144-ae9c-9a809c3790db	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	4	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f8b94ff2-efdf-4591-9c2f-b4a10e0149d4	993c9ae2-c13f-4c31-ad1a-50a6fd30f7d5	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	4	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
95198c7c-53d4-4691-9dfa-18d5c5174b69	50bd0e09-24f7-4178-8fd5-e87ff0a08dba	0572c891-8efd-442f-b53f-1c1deaae2c80	4	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e36a592d-271e-458f-b57e-d6ab83d581af	9bd00443-0a3e-4542-9e2e-7a5acb088627	c2f85493-b833-48d0-900b-ae08f1aa9ff0	4	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9dcc250c-06b6-4b1a-b817-4680c3232166	f458c05a-d808-4264-b30c-184165903fd7	f3efdb86-bc87-43c8-9d41-912d1d821e04	4	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4de51e1d-ac89-4032-88c8-13a6aca346b8	344bef18-b66b-49b1-a308-e750ca6dda1d	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a48e5925-f4e9-45c5-a019-cfe6c10376f3	0a318416-aac9-4f8b-ae13-abfe3e6e05d4	22bebab2-1caa-40ef-b266-639b3bb0529b	4	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c0113df2-9613-42ad-b711-889ff52d97d3	9d6e1f5f-8941-41cf-bc38-26ccec9dccdd	514aa522-6bff-4165-b78c-6b518f99dccd	4	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e0388c48-8d48-4690-ad35-0148f7c2a02a	ff86b2ac-804c-488f-bd66-a46efae54d27	d413cf58-d628-477f-82db-26c2199271de	4	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1586c498-e4e9-415b-84cd-f307c8da762c	c594f079-7f51-4ed3-a8bb-e6acd8a18c84	46139fb3-b443-4629-b8c1-c5ac5ff0de07	4	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
40257d94-62f1-44a5-9979-c9b094ede4a1	ba96e665-f89b-429d-a49d-c431095f042e	1c635cc6-4c91-40d2-8924-8c01ba63241f	4	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e130b3ff-beb7-4bee-9cb3-0f06267107f8	bed764ee-ca9a-4db3-ab6b-534fb92740e9	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	4	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c4109f81-7165-4283-aedb-a18d4b6932f9	5c69042d-0655-4421-a532-ff8a0440c18e	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	4	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c5a69ba5-8775-4f23-bea1-a9626443c43f	6abc80bf-1250-4992-8bb4-df188cd8fb2a	d09d1231-6870-4c42-bea1-2f27ed6e6f63	4	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a9c1439f-c2de-4402-9053-fffc7b7da67a	117f009c-8735-4c95-960f-439f77647cae	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	4	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f4eb7e51-f85b-42b0-bc1d-17716532380f	5d542225-e863-4b04-8b31-038d5b213200	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
783c725e-b5bb-4a7f-bbef-b0bdef9d962b	ca623a6f-5ede-4496-bac6-727fd91aab32	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	4	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4f6252a9-d8ce-4624-aa52-453495fd009a	eca72b78-b207-4490-809c-3a8c676e5525	59a062f1-5222-404d-973f-3088ac2465b1	4	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d3f9a899-628d-49ec-bd19-6601b8c82416	1f7c3b46-846c-442f-8898-4ca8a7da4fd8	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	4	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2ffa6c98-1b2d-4069-a160-6b1023e6e608	5418f393-a98e-47cc-9444-8c598899bc8d	57f39d16-c1e6-49df-ac39-e1e9870e55f3	4	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c95bb4fd-cbee-4ce9-84dc-cec76922ddfd	ed96bbe9-7e20-41b4-bd27-5489e2a8f5d4	1c635cc6-4c91-40d2-8924-8c01ba63241f	4	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c43d12ef-81cb-4c58-bed4-3a4977ef15c3	044e2d98-a9f8-4655-a344-2ff307bba8d4	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
35d11334-8f9d-4c89-a4bc-e9c3958108cf	b17c23d5-b919-416c-ab76-8447b1ee6901	59a062f1-5222-404d-973f-3088ac2465b1	4	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
218792be-07d6-4144-a3c4-1d07879fa2a9	9c661a02-fe51-4046-b7b0-a82f491a858f	132bac58-39fb-455c-8671-cdf50d22f000	4	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
78dc503c-4d57-44c1-a972-4f466438a7fe	b880c75d-0ae5-49be-8b10-43adc2661fe0	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	4	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3086ae47-66ff-4392-823e-268a5abc360c	444bf5f2-f0a3-4fdd-a574-1c107c8c75ce	57f39d16-c1e6-49df-ac39-e1e9870e55f3	4	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7e5d294d-1d46-4374-8c49-923968fb00fd	52afba9d-c3db-4025-b708-b4486c8f9c10	f3efdb86-bc87-43c8-9d41-912d1d821e04	4	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
84f535a0-d5d9-42aa-9e27-fe5ab854f835	6adcea04-a10a-4deb-bdd5-a7c8a63be6cc	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	4	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5405c4d5-46e7-4891-848e-b10974e24bd0	c890153b-4329-4b65-9233-294f3d6c3a50	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	4	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3f2c8643-a65d-483b-8964-215b31e2bc2c	44734553-b21f-4269-a5c7-5a1eca042d59	010d6df1-03ed-4ace-a34e-e389424e9050	4	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
44a010be-a85a-43d2-a3c0-e8c0e83acef8	e7336e58-86fc-4eff-ba27-79c17d9a69b2	d09d1231-6870-4c42-bea1-2f27ed6e6f63	4	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0a267525-14ad-4858-8a91-be8ddd7955f5	81afdab1-69fa-465b-87b4-3052379de083	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aff30591-ffbc-411f-babe-e813f80f7b1d	48dbccfa-d888-402b-b477-9c31e2dd73a1	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	4	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f34426fa-7cc8-41f1-a8fe-5010f12ca85d	858e147d-3c40-4bcd-a1c6-d2945086db0d	a6d85cd1-0f47-4f6b-9794-e05f81744722	4	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6f6ff142-1e92-4236-bd6a-b47d0c2c7a12	f4de5f3f-07b3-4c35-96f7-7ac385c475b9	69c66949-c064-46c2-83ec-e535f5ddd424	4	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf7091aa-5468-44d1-81b6-1e58f955f97e	a4308cfe-801e-48e4-b987-0baa79548f52	a3d4b59a-f601-4155-8f2c-e48a8173bb97	4	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
77cbee53-492f-4694-b5f8-dfd68ba28456	9b045ef9-5cb7-41b3-a09b-98ad670e5778	7c0aeeba-d877-4f92-9be4-8cb9591261eb	4	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0fe00e6e-f2c2-41ef-9d6a-64b967b364cd	098f7f55-55a6-4dd6-a4d8-a3b56a67b538	e8288639-c50e-416c-93a8-bedb29c169f4	4	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0cbca25b-dc8b-4d5c-bfac-f5b051bf6322	ed91480c-f6ae-4170-8438-7aec8131f2a2	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3e56f423-9d5c-4877-a661-db39a902f1d4	c8bc1084-07e2-4514-8c45-4ccca42a6147	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
efa7e6f8-bbd8-4208-9442-557d6ead3630	f8d66cf4-8911-4115-8c5a-ef841037ad78	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
578bfcaf-1cb5-41ac-830e-3064bc279b1a	dfc274a7-842d-439d-9d53-c76a3977d4a9	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cd92d0a1-c192-4cfd-bdc7-e6d68acd37c4	451626db-18b1-49af-803a-1ba420462b32	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	4	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b30d553b-9b72-4d33-ae54-0a91c600ec3e	9e7b1353-66d0-45e3-b3ae-c9cb9f8bd24f	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	4	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d78958ab-0ba2-4705-b6d6-619858025204	c33d164d-c1d7-4aa7-9801-0fb22f9fca9d	d04c5049-6e53-4505-82d7-c8e46deda892	4	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2b4d2f33-a729-4112-a924-87178bfbaba9	ff86b2ac-804c-488f-bd66-a46efae54d27	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
be446839-5ac6-45a9-8ac1-f7075f6b1918	25882ddb-494e-4565-8b51-0fe4abe58d9b	7c0aeeba-d877-4f92-9be4-8cb9591261eb	4	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
34079776-240a-4cf7-b891-732f49688e3d	e7c277d5-c563-4ba4-a983-f306e510eda1	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	4	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
de0ebbcc-fbd8-47e6-9021-dc82c5a760b8	c4c6c287-42f6-4a0a-82c6-234a088143fd	93cfa5df-80d8-4387-958e-ff346ba30ab2	4	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
413a4bfb-6789-4e48-a8ec-192d4a6985ae	744a04bb-6f38-437e-a89b-39cd8b5f962b	0576930a-9c2f-4a34-8181-5757c53c7af2	4	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
42861aed-50c3-41cd-9bd3-6ce63ba63af9	e4b5b1ef-6a96-4681-a960-2d90c194c0f2	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	4	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2641f7a4-77d2-4359-869b-126149347054	dbf7d621-bf6f-469c-8464-c8e00cc9770e	22bebab2-1caa-40ef-b266-639b3bb0529b	4	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
03f80952-40b7-49c9-899d-b5a81d6c6544	1f9fa07c-7152-4a66-b055-4902c535438f	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6bbdc3d4-60a4-49bb-bf76-6238ae5c12ca	3bc6dd55-b9ea-4dd0-9a30-079542d6d8eb	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	4	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6bc63ccb-b0e6-4a71-bf86-508c32cdfd5e	dbde865e-b45c-4843-a42d-803a8519524f	93cfa5df-80d8-4387-958e-ff346ba30ab2	4	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2dcd4090-35cf-407f-8478-6891290b3401	32a6398b-32d0-4d54-b3e4-0280acc9c79e	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	4	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
38d12fe5-05e9-499a-bc2a-4c8bd0a88e37	08ba1eaa-9546-40a3-bb75-6d1f69fbb9ae	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dfdfd609-bc7c-46ca-ab39-361b72df4ca8	7fa6eeec-31c6-46fa-86d7-d8e2842baa52	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5831b4a1-84b6-4fcb-96d7-efbddb48250a	a9ab15af-8535-4511-a3ef-ff5de115f343	c2f85493-b833-48d0-900b-ae08f1aa9ff0	4	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
32649bfa-63a3-42f5-b449-f1c521bea29f	de8e7e1d-1661-4cc3-a691-785a2788c70d	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	4	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4f667e04-211e-4e4b-b9ca-24873388dc36	ee148ce3-cb28-4eea-9178-332d0c6901c2	a3d4b59a-f601-4155-8f2c-e48a8173bb97	4	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b9f0f697-b30b-4f0a-96ac-23160a502801	25294912-4c23-46d2-af5f-35fc7e92ab6a	22bebab2-1caa-40ef-b266-639b3bb0529b	4	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
92bf379d-a366-42a4-8056-dbb89c907287	7aba45c3-6f0d-4c54-ac6f-377507058bd2	a974674c-a14e-4a7d-9e12-84ee4678aa68	4	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0c8a86f7-a8ed-45b1-b319-d715575f815f	86e280af-f765-40e7-82df-e0292b0693b8	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	4	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5815fef4-30a5-470f-9594-343c6314e9c8	a0dd4aa2-a18c-420e-89ac-6a9508e9e606	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	4	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
17cc7038-6e10-4d02-837c-c27c48171a2a	1dc38571-482f-4dea-a651-f0459d78cdca	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	4	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0136c98b-c561-455c-9236-5470ac572277	344bef18-b66b-49b1-a308-e750ca6dda1d	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	4	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5267b443-c56f-420a-9c45-67576a84329b	9f3db135-6098-4cd6-bc68-f6b396780f51	132bac58-39fb-455c-8671-cdf50d22f000	4	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
86134e58-0e74-4524-93bd-a0f8d2d4f987	ad30f787-9a73-41fd-b124-6a1aebfda11a	22bebab2-1caa-40ef-b266-639b3bb0529b	4	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dbf2f77a-9592-49f3-a709-d511e2b6d08a	77174641-0c1b-452f-a71d-2050810b6cdb	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	4	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6e8c8c25-5ba2-4b5d-9553-87dba3a2935e	ccb60341-fa59-44bc-a85c-46fa9d1c1f53	cf3800aa-7129-4651-b3d1-a44125fb51e9	4	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
911a8b2b-0248-4254-875e-5c17cef07bac	9001cb35-5253-42ad-86a8-2cabc01e3742	a3d4b59a-f601-4155-8f2c-e48a8173bb97	4	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
86d642d4-bcb4-48d6-a2c5-5cdbac9feb4a	f4880d4a-9e32-477a-9864-f955574d53d3	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0c6603c3-1016-444e-b500-45c0e25a3590	db1575b8-4afd-4523-b5af-e940e2727bc1	d09d1231-6870-4c42-bea1-2f27ed6e6f63	4	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
55aef916-7f42-448e-9f95-5eeb96530909	aca14bec-7868-4098-b259-9990f923dc1a	c49e6332-e143-40b8-9f4c-b23b547fe4ad	4	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a87f3f12-7168-4166-8d24-669b8ac6b4a4	fb044831-49df-481a-a861-0af091d76757	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	4	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7f421111-7b8b-4763-ac13-baa949399786	9debfcaa-7f57-47c0-b3f6-b00efb02dc5d	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
69c3da86-f836-47e3-951a-a410d6bfbd32	8bda0160-8914-486c-97e0-cf573cab7cf7	010d6df1-03ed-4ace-a34e-e389424e9050	4	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
55cca9ff-6dcb-4aa0-9843-cd3869f1c7ff	a9e1d432-ded3-4c8e-869d-4ccd32094d98	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c59b5673-dbbc-4b33-9725-500168f9ddee	18548e01-c6ce-4319-a5bc-b92bc7660286	514aa522-6bff-4165-b78c-6b518f99dccd	4	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
66f644b9-177a-4b31-9d84-10592433b9f1	5d42dc7b-48dc-49a7-a7b7-3818d2ec4146	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	4	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
05cd6113-f979-498a-a07f-d2a7c2ba59d8	0386cbff-6b94-46c5-bda7-1cf5ae1eda6e	4a71ffc2-cea5-450e-8595-bb66ab01757a	4	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d76b5811-9a63-4630-ad4c-d3c6452e6a12	cc7aa352-fe1f-4b2e-9451-a260121d0e5a	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
62d51faf-15ca-4f78-95ec-ab6937092661	d0538513-a0f4-46dc-9212-1b2835f08f64	e8288639-c50e-416c-93a8-bedb29c169f4	4	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b899cfeb-d67e-4b56-8d40-43713845a03b	77ffa843-e69b-4973-bc40-1aa69e02d958	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	4	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4d596a61-445c-4890-bfbc-9965f7d7acf7	5418f393-a98e-47cc-9444-8c598899bc8d	69c66949-c064-46c2-83ec-e535f5ddd424	4	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d32b30f5-84df-4143-b434-0a621d765d50	6664a2a2-fd60-4046-8bd0-57263cac8c31	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	4	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
767d871b-f676-46fc-9ffd-0bee722838a8	fadc8cac-9b20-427c-944e-253e24f4ed19	bb3baeb6-156a-4b66-877a-70c3309563e3	4	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
106effd1-bf27-4a4f-bdf1-7bc1f67e46a6	1e99ed0c-9f14-49f0-abfd-523f5bfdd76e	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	4	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
864bf085-58f3-4b74-b6b8-cebd966ce97a	a0a71cb3-f02b-495d-8133-bcf4509d41b1	57f39d16-c1e6-49df-ac39-e1e9870e55f3	4	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f88f0956-8094-4a52-9fa0-a6c713a11187	858590d5-ce17-4c3a-8365-d283fa28542c	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
83cc5ab8-1b73-44bd-ba35-81287ddd616d	ad6965f6-e833-49ba-a3d2-c136f47fc0ae	e8288639-c50e-416c-93a8-bedb29c169f4	4	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2a6b8ace-3c5b-43be-887f-68db90023ed1	17778224-4da1-459d-b96b-0b9005435909	8b435be1-19f4-4571-8643-dd261e2e6807	4	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d372ec27-292c-4515-b261-11a3a502ef47	d4ee78b1-6113-408d-92dc-fa7b7907155f	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	4	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
de0ad49a-0eb9-46fa-b05c-a13f58c4532e	71aab50c-4744-4629-8724-ac87424e7ddd	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a6040ddb-5ae1-4ba2-97c3-c73d4a025a1e	e7c277d5-c563-4ba4-a983-f306e510eda1	4a71ffc2-cea5-450e-8595-bb66ab01757a	4	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ddb63bcb-3948-4c20-9263-cf3d5dbc2142	85f5e8c4-c991-42e4-b2ad-d75e9c07756d	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	4	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7513e236-6cf6-4927-9ac9-e5ed975bfa50	a31f791e-bda3-4dbb-9d6c-9cc68aa02dc6	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	4	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
51247834-1b6e-472c-8cca-ff48abd4e8d0	1c0b4668-5fa0-4548-88d7-e0d9d8a3dbd0	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f62265a8-ffd9-4073-b086-5eef82499d5a	d108d89d-df8a-4ac1-83e1-e2341191e4d2	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	4	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e3468691-de3b-459d-913a-534190964330	00ec46e5-9ce0-4407-ab63-a9a096e7f706	d04c5049-6e53-4505-82d7-c8e46deda892	4	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
028f8eb3-55a8-46b9-8c56-f46fca015987	f747ae81-5d3f-402c-8f25-bdc54eaa626e	59a062f1-5222-404d-973f-3088ac2465b1	4	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
30b34b63-ee15-4f26-b175-b12f272bdf6f	dd704203-4544-4ac0-a3fa-3d8426cff0e4	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
456cf4eb-5e8f-42de-863b-6b53b9899ad8	8b02889f-69eb-4711-9264-df89b26f67e1	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6e3d3918-9a2d-4be7-99ce-8380dabe9789	3d346b6b-4a74-4739-9e57-942ae8463ebf	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	4	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2d685d31-d810-4d55-bf59-30e8c6484f30	6e3cea2a-5691-408e-a0cb-191616d8529d	a3d7efd8-15e9-4d59-b159-48b9de13c791	4	37.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
038b6b70-766e-4ac1-a2e8-056c27ac4c87	11effd28-06a5-44de-afba-b0926231a943	0572c891-8efd-442f-b53f-1c1deaae2c80	4	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6a478152-5b38-4625-b23f-225956839549	ef5ccddd-ed26-4e3c-b558-c5023abf4e59	d04c5049-6e53-4505-82d7-c8e46deda892	4	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e4c9c663-8783-49db-b9d0-79566db86d4a	a2774201-c2d3-4c7c-8d17-559bb6cbee19	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	4	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b2942492-d336-4ff5-9104-5a1909d1d0aa	ee148ce3-cb28-4eea-9178-332d0c6901c2	1c635cc6-4c91-40d2-8924-8c01ba63241f	4	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ff91a61a-3468-427f-8493-ee1bfcfce3f4	ef9303c0-315a-43e9-a6a2-6b1901a70a77	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	4	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
692837cf-f115-49ac-ac21-ea7a8ddc8e48	72fc897e-e05c-4522-99cc-1c493d1a1301	8b435be1-19f4-4571-8643-dd261e2e6807	4	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fb2f9c33-6a8c-4ef2-82c9-10c3dbe02ed9	26debe82-8a6f-47c2-972e-25a4faddd330	a6d85cd1-0f47-4f6b-9794-e05f81744722	4	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5b4d6bbf-c389-446f-b339-abd5855e2a5c	a58a064b-d986-4fe8-9496-408fd9a74bbd	0572c891-8efd-442f-b53f-1c1deaae2c80	4	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
830cbf8d-00a2-4b37-8cbe-0c1e99493772	c650d6a9-606e-4205-8cf7-df2d042ff88f	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	4	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d2b18bb4-309c-40dc-85b9-f1deed26c524	c33d164d-c1d7-4aa7-9801-0fb22f9fca9d	d413cf58-d628-477f-82db-26c2199271de	4	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6ac47e67-dcf7-4c80-b4eb-65e3bdfb7921	bc0cae1d-895f-4b96-896a-2297c655aeb3	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
18f13756-3461-481d-bb84-1d65d5cf8a25	91fdc0dc-5776-43fc-a20b-0be131700faf	276e4f43-463a-40ad-b06f-698be2cc75b9	4	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
53053501-dcf6-4106-9a0e-807754404a20	260f3888-a093-4b45-8859-a9dfcea45a3a	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	4	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2cb63668-2cc0-4f2e-a58d-dcbcebc2923e	f0df54cc-8181-4f13-b2b1-8cde49c0986e	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
57fd40ca-c28d-452c-9ba7-8bf50d8e2a6e	03c06630-814b-463a-92bd-87662d923c1b	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	4	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
63727db9-e15e-4a86-ae7c-a2e0ebb240ab	3ebf8c52-603c-4bf2-9a52-09fde8f2fae0	c2f85493-b833-48d0-900b-ae08f1aa9ff0	4	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ea2b7b80-309d-4c25-9ea7-ad53c38a4cde	1adc4dbe-3021-42a1-ae26-b4353f7c87ff	c49e6332-e143-40b8-9f4c-b23b547fe4ad	4	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c279d467-479b-4952-a6d9-b300b8f3dbcd	8e577abf-5f86-4498-9309-64f616ea275b	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a62fa174-e110-4df8-8914-33da07fdc066	f8f4bb71-1ece-473a-ae45-449381cb68bc	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	4	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
94a05f46-2354-4ef9-a012-8a1cbbd1e4b4	9d86fea3-879e-4f7b-931b-8a7bf33b08a5	010d6df1-03ed-4ace-a34e-e389424e9050	4	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5402a9ba-a6a6-4a6b-b5e3-3b7b4249c917	28a83d00-61f4-4633-9a10-39a3cf1027a4	a3d4b59a-f601-4155-8f2c-e48a8173bb97	4	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e71e19e1-b43f-4d25-b465-5b4001a7eceb	dbeb0761-194f-4015-9563-5879f7354ea6	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
32cf2591-03c9-4489-be8f-ac3b1e48ca5d	a2fbb854-4e87-4aa8-85b9-75799e0089cf	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	4	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d590b543-9187-4fa7-8b0d-fe79825a4afd	41af1ad4-ab82-46c8-9507-bca0e26723e0	8b435be1-19f4-4571-8643-dd261e2e6807	4	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
742cac5a-6616-4960-86fc-8e1167b8d040	5da7923e-37b3-4f7f-9a39-9e7044069922	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	4	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fc2f3160-db0c-4a47-b03d-334b93a175ad	349d7c20-bf2f-41d4-ba23-fce052efc0f5	010d6df1-03ed-4ace-a34e-e389424e9050	4	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5ff116c8-d0da-4778-be9e-3403b866a168	e8c6b522-6d05-4cf4-82d1-8ba2a9697f40	93cfa5df-80d8-4387-958e-ff346ba30ab2	4	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3bf408ff-743c-45bc-852c-a9a03dcc0e51	c7ee0f65-4f69-4a7e-804a-1f702b4d2521	4a71ffc2-cea5-450e-8595-bb66ab01757a	4	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf60b0c0-9cd4-4784-a310-fc6d626a8ed7	5a4ec837-021d-4179-95fe-b5d4c51b11c7	a6d85cd1-0f47-4f6b-9794-e05f81744722	4	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9b132618-26bf-4be7-900c-8ab9a7d1e440	17816150-5d60-4721-8bf6-453144e35e34	d04c5049-6e53-4505-82d7-c8e46deda892	4	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9c6fe457-e240-4e69-bed6-d77daf9f87a4	e5ebfe03-f1d3-4094-ae23-45653b24b53c	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	4	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
89bb1db9-0645-49af-9d63-3a7ce9d817c1	94417d6b-ad56-4f3b-9493-7020a3cc6607	e8288639-c50e-416c-93a8-bedb29c169f4	4	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
632c1010-b89e-45be-bd24-f7209a4b839a	af43b7f9-c52c-489f-be7f-3556d14d44b0	d09d1231-6870-4c42-bea1-2f27ed6e6f63	4	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8db61cee-364e-40f9-aa6c-d4b5463b4923	c91d7846-9ab6-408b-bb49-d0c988ca66b1	e8288639-c50e-416c-93a8-bedb29c169f4	4	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c9b34a71-6eef-4486-adb3-6b53e6f7d266	5768f7e1-10f9-44e4-bae3-969e790f858c	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6d0d9787-4293-455c-ba7f-b959ccf94b9a	f49c93d1-861f-419a-9a4a-1b6911ae0288	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	4	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
94fcb9cd-27aa-4029-84ef-c33eafb40ecb	4fb0de4f-2a58-46fd-9c4b-79075f00818e	d413cf58-d628-477f-82db-26c2199271de	4	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6b0190d6-5df6-4201-ac1e-3ae6d5ad8d58	d758abc3-9c6a-4e42-bdd0-76cad50aecf4	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	4	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c50a68e9-3bc2-47b4-8eaf-1ef01c206883	a4acc925-8ce4-4e88-9657-9168b38683d7	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
02c2d358-4c44-41d5-84e4-37a294a9ceb6	fac6fc06-5a83-49da-a8f7-77e309b05910	69c66949-c064-46c2-83ec-e535f5ddd424	4	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
51df4cca-abd1-4eb0-8ee2-0dc299af708f	933d795f-3eca-4757-9fe2-addbaf10506b	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0f8a39a0-c983-4f45-9f1f-3ed1bb0c0f75	797ca8e3-813a-4f42-82e4-969328a4d240	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d4754ac6-9d9d-4d9b-bfa1-c3a1faafb466	b13f235b-5be5-40a7-9739-7e15f6d879af	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4caa630e-b272-4647-94b2-976f4ae749a1	bf7cabde-accd-40d5-b7d6-a58fd4e541af	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e92c0cdc-a866-445a-9548-1b74beff287e	e1739e99-86b5-4525-ba85-44cf361e1761	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d5eec153-d502-441c-813c-f19109710a07	6baecacb-eb21-4755-b24b-d1f6f2dd94d2	4a71ffc2-cea5-450e-8595-bb66ab01757a	4	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
493c7427-01cc-40cb-b3da-c8e6dc8a9670	7ee18102-0483-4786-a219-0bae86c50043	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a27ebc24-d3ac-4432-806f-666c5fb3f209	1e99ed0c-9f14-49f0-abfd-523f5bfdd76e	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	4	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
aafa52c1-d4fd-4b4d-a1de-aa03ac891f6e	d6a63cae-c375-4ffc-a4fa-cf54ec217b6e	c2f85493-b833-48d0-900b-ae08f1aa9ff0	4	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
55455696-86dd-4df6-a068-5829b06dbb5d	6abc80bf-1250-4992-8bb4-df188cd8fb2a	c49e6332-e143-40b8-9f4c-b23b547fe4ad	4	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
56dfb5ee-a34a-4811-91f3-0618955e7a54	f2dbfe7a-ec20-4091-a2f2-7291ad718da9	57f39d16-c1e6-49df-ac39-e1e9870e55f3	4	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9dea9e32-bd29-40e5-a848-ee063fe8e4b8	f1ad5537-be27-4fd8-b6b7-f39b7ff13278	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e0545d6b-ca0e-4626-9e97-b5edc6b9d590	28810d2f-06da-40fa-b5f1-8a14a0c9c8aa	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	4	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
481774b5-0120-4cd0-b2a3-7132be3a7613	cce2c09b-b2db-43b1-aa0f-27f99bc00e3e	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ba825cfd-1833-42a2-ab04-0dc5e98f32a4	471a7a4a-811b-408c-b165-8bb9d97e9333	f3efdb86-bc87-43c8-9d41-912d1d821e04	4	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7abb7bf5-ce0e-4190-abce-9481ae64e5d3	f4880d4a-9e32-477a-9864-f955574d53d3	c49e6332-e143-40b8-9f4c-b23b547fe4ad	4	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6cd6574c-2a43-49f3-97dd-6c542a5fcee6	0cbb5b59-8f6e-49b0-959c-182b4b61cc89	bb3baeb6-156a-4b66-877a-70c3309563e3	4	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
53d9cc19-fe55-4ccb-8a69-6a11461bfccc	b6b45b42-12bc-415e-9efe-ba9357190f5e	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cb3efa32-d1ea-4d95-b194-2ba265891f5b	22295dfb-2523-4285-89b7-ee1b31ac46f6	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6744520b-2b9a-419b-8e52-2542a9ac5457	eb81b20e-79c8-450a-b001-da34b1c4a79c	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf52d852-e502-4237-9bbf-1efba7ed648d	ccfad263-dee6-45dc-87a6-2852fc81a70a	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
795fba09-4116-447d-9c8a-2c313c0dc519	b2f2ec34-152b-491f-9f99-4cc68701f096	93cfa5df-80d8-4387-958e-ff346ba30ab2	4	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9deecaa9-fc3d-4de6-92c2-0810886ff673	7c428075-3100-47be-84f5-79310faeaecc	e8288639-c50e-416c-93a8-bedb29c169f4	4	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
31816b44-ea17-4bd9-8ac4-5d65bfce0d53	5f8713c5-4a12-4bcf-9a54-04e81f8891bc	7c0aeeba-d877-4f92-9be4-8cb9591261eb	4	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8f5d64c0-20b0-4e87-94fd-1c69c12c770b	b901d8de-09a8-4186-bd7b-1a91ad726828	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
74ca2cd1-2c41-4724-969c-634361fd0823	0e81a492-af85-4203-9deb-7ecb4778cb7e	689a3789-11b3-40ed-b32e-b948af298ef4	4	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
74638bd6-5c68-4603-972b-e4e7c3ede3f9	a2a88528-9022-4258-ba7a-ac37ff66bf2b	a6d85cd1-0f47-4f6b-9794-e05f81744722	4	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4d89bd59-d95c-487a-8631-39101acf27fa	f7e8e12c-67ba-4bf6-b5b3-83e90d967caf	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
81482766-37b2-4746-9498-e95d23d10daf	6bfe2447-12e1-4d99-90d0-6e0a9efae8a5	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	4	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
051bad2e-ccb7-44dc-8a42-1ce3c8da930d	b0c6c50f-be7c-4412-8e92-90bd9d833b12	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	4	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e1dd60bf-29fb-49d3-9a5c-7e3973c05839	8ac7d68c-2fde-4ee7-92ff-6601d0d806b2	a3d4b59a-f601-4155-8f2c-e48a8173bb97	4	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
873135bb-5075-42b3-bf9b-dfba0d14918d	77fa4b65-dadc-4f68-863b-f5fd3250ecd0	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	4	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
09fff4ae-3832-4b48-9d69-8957ec0d08d4	2d051e98-2389-4ab1-a628-93bf5ec9f2c3	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c4ea1087-29bc-447a-8684-ad52a9bffb2b	0b207123-e784-4be6-9f5e-0abcf15af13a	c49e6332-e143-40b8-9f4c-b23b547fe4ad	4	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4bef62bd-d52b-4225-b605-03c2d58dc135	3f6adb83-eb45-4a3b-adf5-7e73d54adc24	a974674c-a14e-4a7d-9e12-84ee4678aa68	4	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
25fa439a-f00b-4cf7-a62c-d5888c07648e	a94b9132-5bf7-4ccf-b0d6-f446b1960831	0572c891-8efd-442f-b53f-1c1deaae2c80	4	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
135a1e57-1746-48cb-93e3-4e2a84e82a1b	dec13856-c58c-4eb3-9360-8c814c9842a8	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
15f3f5c1-31eb-4593-af9c-92ece9d897b5	f0927e44-ab48-414a-8d49-35a79b90c033	a3d4b59a-f601-4155-8f2c-e48a8173bb97	4	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9756dcfe-803c-46db-aeef-d7f085c94a10	fcf364e9-5e69-4a1a-afaf-bbfba14ddd6c	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ed83be7c-eef2-4539-a440-c7c8bdb63183	3a83046a-5888-44d2-a476-edba61d2f61a	4a71ffc2-cea5-450e-8595-bb66ab01757a	4	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
608b91b7-b43a-4004-a18c-2aa48e2751c8	a0a2d50b-3141-4dd8-89b2-f80df5a7f9fc	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b46d7e55-3113-44a9-b56c-968fd0688a44	de8e7e1d-1661-4cc3-a691-785a2788c70d	0576930a-9c2f-4a34-8181-5757c53c7af2	4	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5b39e137-0da9-44b6-8061-a9ede5f9bfe9	c0abef73-527c-4744-9760-e21c71b6691b	c2f85493-b833-48d0-900b-ae08f1aa9ff0	4	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3fbbe591-7c49-457c-bc6c-7ed7d4ccf368	8669e169-c126-42ed-8d4a-a73d39ec8572	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	4	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
596e4feb-949f-42ee-8baa-b18c41546e98	28a83d00-61f4-4633-9a10-39a3cf1027a4	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	4	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f726d4c2-9ea1-4e63-af36-247b1d6c6d64	14a4b2ea-0b28-4be7-a343-d9f853a7a947	c2f85493-b833-48d0-900b-ae08f1aa9ff0	4	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
60f84860-76b6-4313-a5f5-b39cfdbf0d3b	a1c1fd9c-b051-4f8b-8328-ee38b3f52280	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	4	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a9beabbc-4997-4b9a-887e-6b375e471ffc	b4a023a5-8311-4677-ab40-a7aafaaf1e96	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	4	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
48a8bbe6-888a-4f97-88d4-5b4f758bc014	9063fe90-e5d5-4ea4-bc3d-2bcf09f17d08	59a062f1-5222-404d-973f-3088ac2465b1	4	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
148e4210-d13d-4c5a-94e9-de40805467ac	82526151-948c-456c-b873-55557f652e1a	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	4	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
36e77284-a7f5-41c6-8e9a-c3e6a20b97b2	f3683f19-7052-44e5-bbd7-6576601bf5cc	132bac58-39fb-455c-8671-cdf50d22f000	4	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
83d482ca-92dc-4f1e-a7f6-0e844b60d10e	e6e17fca-d70b-47dd-ac00-919b1d5aa42c	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cc01bb58-a7f8-4673-a8eb-674cd05564ff	d11a9ff1-4e42-4ce0-9421-7776dcbdd1a2	d09d1231-6870-4c42-bea1-2f27ed6e6f63	4	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f884b831-8bd0-40c5-aa08-527cf593bab1	d8a28b2c-d6e1-4337-a467-cc4033508a78	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3a11fa54-da42-49bc-a37f-4e331b07ed14	1856970d-1219-4988-89ad-75f53fea2b9a	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	4	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
20c98f73-2f51-4df2-9fdd-7a93099ccf83	b4cc24f0-68e7-43ed-a202-b6159ff1b284	a974674c-a14e-4a7d-9e12-84ee4678aa68	4	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
31f69a4d-98c5-421a-a5ce-6aa4c60be4e7	989d0a56-8ece-427e-893d-375fd011dfa0	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c64ab6c8-8741-4d89-b1e6-d4b30ddd9340	aca14bec-7868-4098-b259-9990f923dc1a	d04c5049-6e53-4505-82d7-c8e46deda892	4	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
337c53c3-be75-4134-81e2-9e9244af3cca	fae5b1ca-a3e8-491e-bf10-6edd05f9a558	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	4	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5b52c837-5580-467e-adf8-3d35ac737095	89856409-ee57-413f-9d24-c02239a40db3	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9f84ffa8-0571-4cec-963a-1ba7b28409f5	5caa22ea-c755-4381-abc7-80d72db51cc3	a6d85cd1-0f47-4f6b-9794-e05f81744722	4	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
01693691-7436-4657-ae17-4ede6b710a45	5da7923e-37b3-4f7f-9a39-9e7044069922	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b303e3e5-be5f-4da0-8095-ba0af812a306	f229222c-0878-47ea-bab5-ced6b3717a48	b0167420-40a1-40d0-a5dd-cdfc189d0bcd	4	6.25	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5377009a-46fe-4557-9fb0-629166c2b7be	b0afe566-dd60-41ed-9ae1-4219cd051f34	e8288639-c50e-416c-93a8-bedb29c169f4	4	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
88d12976-a7ba-43e9-b895-9004c1b52c8c	785f59e8-65d1-4db9-9680-e54d2d9f3ce9	276e4f43-463a-40ad-b06f-698be2cc75b9	4	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
26a97ce9-06d6-4c3c-9f44-77177d94a34e	e1eadabc-6c40-4ff3-93a9-a914dc022510	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fc6e23ff-d18f-45d1-a628-bed6f949a247	38516bb5-3585-40b9-bfae-4522dca85da5	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	4	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
52294987-320e-4de7-9625-8d80c533ba9a	8a5a95a0-5c10-4942-88ab-60f702a5991c	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	4	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4c9e3276-b337-4247-893a-0e2239e9798b	acf1e7a3-eac2-49fc-94ac-dfa337383396	8b435be1-19f4-4571-8643-dd261e2e6807	4	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d0a52b58-6109-47a3-835e-07a43b3c0f3e	50b235f7-a4a7-4e19-8aa4-b394b4df928f	0576930a-9c2f-4a34-8181-5757c53c7af2	4	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
891a5c77-8162-4ad3-8c5f-61da6198a2c9	94c5c2b8-7666-4f0f-b944-0c64412bee75	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
68ca0f53-8e31-4ae8-9908-0cdb4de4cce4	6adcea04-a10a-4deb-bdd5-a7c8a63be6cc	276e4f43-463a-40ad-b06f-698be2cc75b9	4	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8b2865b1-0ecc-409a-b0da-168d5a2f379d	cc7aa352-fe1f-4b2e-9451-a260121d0e5a	276e4f43-463a-40ad-b06f-698be2cc75b9	4	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
eaf0ae17-3ab0-4d4c-9ccd-75d62b35f389	59afd7e2-001e-4ccc-882e-1e33a44afa82	514aa522-6bff-4165-b78c-6b518f99dccd	4	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9af28616-b326-41de-91fd-96c800f67c26	59560717-a657-49b5-b501-d9aa3ff3ec51	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	4	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1ef6e497-ca8d-41dd-9e49-49853291e97d	26debe82-8a6f-47c2-972e-25a4faddd330	514aa522-6bff-4165-b78c-6b518f99dccd	4	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4d9cee0d-edca-4129-a922-1d527932eb2d	530e3b6e-83a9-4b9c-b672-118eb36ab2b4	0572c891-8efd-442f-b53f-1c1deaae2c80	4	9.42	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c19be32a-88bc-40ed-b7c7-956c6eb8164f	5bc41f69-6c06-4d2a-b2da-0861bc426662	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	4	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b0069a0c-c15b-4a88-8b7e-9a97234a904d	2d38ce28-911a-46c2-b612-631fa48c4823	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	4	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
98abf294-161b-4db0-8058-b84ac8a72055	52b5abaa-1e6f-49a0-bf75-9d131d335d29	22bebab2-1caa-40ef-b266-639b3bb0529b	4	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bd00b0b1-e562-47d7-853d-a35c7ca753cd	20175126-96dc-42e1-b7cd-0c1e5080292c	a3d4b59a-f601-4155-8f2c-e48a8173bb97	4	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d9173243-efd5-4fb4-96cd-55940a5b31b6	8405111a-e0dd-4285-9184-ec2471beb9d2	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9ad949db-154f-4e42-8fe2-dc3356db64c2	d0538513-a0f4-46dc-9212-1b2835f08f64	57f39d16-c1e6-49df-ac39-e1e9870e55f3	4	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d60bade0-44d2-4eb3-9c6f-e7d213720762	962057bc-e3dc-4b0c-a15c-6235bd603203	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	4	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
682a6643-7b08-4845-a93c-165022e15820	f8d66cf4-8911-4115-8c5a-ef841037ad78	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d903ec1d-ceaf-4023-b18c-940a71a94725	9001cb35-5253-42ad-86a8-2cabc01e3742	451e1138-e4ff-44a3-955e-ee18e8464d80	4	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
26664382-63fb-48a1-841c-4b26f1937098	35aa81ca-a01c-4910-b752-5dbb8f6c5cdf	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
15357e10-b5a9-435c-9938-c467f4820768	07d2f56b-615c-48be-a249-189259e8052a	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	4	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d2cbf815-413b-49d2-9797-ac5568278f8a	a8130946-067b-46ae-958f-855c82395d31	010d6df1-03ed-4ace-a34e-e389424e9050	4	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b28a9f12-839b-47a7-ac38-1edbd72926e9	800c03b7-fdf5-4b25-aa80-139a387327cc	bb3baeb6-156a-4b66-877a-70c3309563e3	4	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b75e05f7-03f7-4fad-b0ca-86395114a367	7af370a7-a058-4ce0-a3d8-760f162febe4	7c0aeeba-d877-4f92-9be4-8cb9591261eb	4	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
31335e3a-c7f8-4103-8b2a-424a61e4785b	91a6d175-4759-42ea-b1e3-290cbdc5a2d7	d413cf58-d628-477f-82db-26c2199271de	4	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5fd80c6f-81cf-4524-89cc-c681933fe5ca	d85fb1db-fed1-4a8c-83de-164487338e4f	93cfa5df-80d8-4387-958e-ff346ba30ab2	4	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7217b5e5-f442-4643-baf8-1e376807843d	96ab7248-cd91-463d-9b08-945700f7df76	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4725cde4-dad6-4cdc-ae89-697320aeef92	c24fb979-58c0-4087-8a4b-d275a361204e	8b435be1-19f4-4571-8643-dd261e2e6807	4	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8431521f-2513-4549-9347-4ef49fdc3f02	6ef8cd0b-1df2-47e8-9a5e-bbc6a45c086f	8b435be1-19f4-4571-8643-dd261e2e6807	4	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f2539dbf-7407-45ea-91cd-75e5d2d07783	0e635af7-fa1b-4a85-90c1-f17070236d65	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	4	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bf3b19e2-0f5d-49e6-9bf4-32c85802f354	8c7c3138-a3c3-435b-84bc-4ce5bd09471f	a6d85cd1-0f47-4f6b-9794-e05f81744722	4	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
553f1cfb-1fcb-42da-83bd-c248523a8918	fce9aa3c-fdf0-40c2-bfec-06a2654ac34e	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
448f9921-f63e-4f30-a210-011ccfcb4d7e	77afee0d-2d41-4958-a32b-743f19543af8	132bac58-39fb-455c-8671-cdf50d22f000	4	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
718f3f70-4586-4664-886f-2548976b1e66	ee12d632-0fff-44c4-adb1-7234b09bed40	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
948e980d-ffe8-4bfb-80ef-0566e4708786	ff4e67f8-e31f-4a59-8302-02f6490310f5	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	4	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c3f3d5a1-abcc-4e30-aee0-bd089149443f	6895d518-2a61-441a-bac6-f5261c015295	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
911c3ce8-9465-4d09-95c8-e557cc9c06d4	d504604a-72be-4da3-93e1-331d02f111be	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	4	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1f815162-77d9-480c-9376-fb3dea08a254	96b4dd91-5ef7-45ba-be9f-7bb80fb43773	c49e6332-e143-40b8-9f4c-b23b547fe4ad	4	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e248ac97-205a-4f27-81b4-24c2ee49f230	3e03695e-492b-4125-bc9e-ffaeb875c595	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	4	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
50d13505-7fd1-4cda-8931-ae9418567113	8dc42314-4e9b-444f-b210-c01982218c61	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
037191e4-cfa2-4cf5-8df9-1f2b8413c363	4f0f7146-a213-443d-ab4e-2ad7f2d2eb03	d09d1231-6870-4c42-bea1-2f27ed6e6f63	4	47.18	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a9babc18-7bf2-4286-a6df-e07231ab126b	99f6ce9e-fe98-42b9-9fa3-8f7370f07a3d	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d3ce7e35-4e98-4805-8705-aed35a0c07ed	f549700d-fd1c-42fd-9e6a-817dcb43fffc	689a3789-11b3-40ed-b32e-b948af298ef4	4	32.74	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6dff55a8-3189-4ce7-bb76-5fb17ed658f3	14a4b2ea-0b28-4be7-a343-d9f853a7a947	0576930a-9c2f-4a34-8181-5757c53c7af2	4	10.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4db2ce58-201a-4d66-a5a2-d2999265a59b	29ce7a31-3ff7-4a5b-b7c2-f31290f7aa8a	57f39d16-c1e6-49df-ac39-e1e9870e55f3	4	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ebe0bf31-b71f-400d-bd02-477dcc898a48	25294912-4c23-46d2-af5f-35fc7e92ab6a	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	4	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
87bcfacf-5799-4730-8df7-fda3740760ed	be8b33b3-3359-4865-8bad-05fa8bd91040	717348ce-6fee-443e-96fc-92ee6a9cae8a	4	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
452ff250-22d8-4d68-9ab9-2b1d00504ebe	f7701bfe-5bfa-4ab5-83da-c3238a6ed29a	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	4	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4ab234a8-03c0-4271-924a-35028d287603	812caf18-a781-41ef-ac70-04da995fd38b	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4ad0da98-c683-4c32-8962-f4a244beafe9	11f58ffb-d5e2-4c50-8dbd-0f8cdb47954c	59a062f1-5222-404d-973f-3088ac2465b1	4	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1d815f7a-ac46-46d3-9c44-2bc952ea413f	4a7a9432-aa51-430a-9127-4a988fefe196	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dff8e02a-f3c5-4775-b0dd-2cf8bf1bda86	29ce7a31-3ff7-4a5b-b7c2-f31290f7aa8a	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
76d1cefb-0024-4e86-99c8-547a717c5d3b	5e577719-4db6-49ea-bb62-03ffbe84021d	132bac58-39fb-455c-8671-cdf50d22f000	4	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dbd42f82-c75f-40c9-9d6a-46380851b36e	508923d7-8d95-4a15-9aac-e8c282109576	57f39d16-c1e6-49df-ac39-e1e9870e55f3	4	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
58b02838-4ca2-422f-9da1-86240cfe2793	a2fbb854-4e87-4aa8-85b9-75799e0089cf	c2f85493-b833-48d0-900b-ae08f1aa9ff0	4	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4a8a92cc-2869-4a0a-aa23-dccbe2464b8a	f5db4495-46be-4cd6-817f-05d538a758f2	24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	4	24.17	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
64c546bf-8911-4c55-b7f9-d73130bebc40	43dbbaa9-b760-4ac7-bdf9-c3c921fb1d5c	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	4	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5f16e2f0-730a-4304-b6f0-1f4062ad8675	be8b33b3-3359-4865-8bad-05fa8bd91040	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	4	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
57c3fb11-f552-4b49-80b7-eb9b1424d7a1	6b21d51c-de82-463c-9270-2ae4867cb2d9	a974674c-a14e-4a7d-9e12-84ee4678aa68	4	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
60c85812-791a-49c7-91ad-f09dd045bf32	77ffa843-e69b-4973-bc40-1aa69e02d958	010d6df1-03ed-4ace-a34e-e389424e9050	4	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
76aa7332-36c0-4234-b518-5ae3f41e0412	c8203054-2a79-4217-9ddd-78dd091ec1bd	1c635cc6-4c91-40d2-8924-8c01ba63241f	4	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4ad71eb7-1ca7-4d6f-a117-e94aaa19af75	044dce02-86ab-4d8c-bd8a-d505891ea5da	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	4	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5e7e0d22-23a7-487c-be64-fb628da55905	bc992b1a-d3a0-4cbb-b49f-c4bd23c009b8	b52a5f8e-5cab-4fca-8b5c-d07230467720	4	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d025d9e9-385d-4022-9c0f-cd3ea76beb73	7233fdfc-f69e-4a77-8ff3-b156e607a458	4a71ffc2-cea5-450e-8595-bb66ab01757a	4	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cfedcda3-2c1f-4cb8-8e74-9fc04e46693e	6d2a7de3-d076-4577-b89f-4b7449155129	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f4530c68-2f0a-4401-b9b4-2ad033f65592	88a2d5db-9d4f-4ec8-a0c9-1716881a2b31	4dcb76f9-1c44-435d-b318-7eae10573f52	4	42.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e5e91246-fb63-4bad-be69-c2c6e5c21fe3	9444571e-eb71-4ca4-9084-5d15554d3cf1	cf3800aa-7129-4651-b3d1-a44125fb51e9	4	45.51	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f1793ce1-5959-4b6f-a191-4891471abffb	f7e8e12c-67ba-4bf6-b5b3-83e90d967caf	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	4	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bcec930d-b639-4a37-a079-237bc06de088	6795ef74-6ddd-4cdd-b380-b0f7867b63df	132bac58-39fb-455c-8671-cdf50d22f000	4	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d5fb8f0e-3e1a-4710-a266-0658199fec05	6cfb3ad1-16a5-4c2f-81f9-4ef38bdcd7fa	d04c5049-6e53-4505-82d7-c8e46deda892	4	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
025e5b3c-319e-435d-9acd-9907f6661382	c6da8964-cf9c-432a-a5b2-a23d4676975c	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	4	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ceece391-859d-449b-b2ad-9331647726d3	864a2bab-88c0-418b-a0d1-872a3931fbe4	f3efdb86-bc87-43c8-9d41-912d1d821e04	4	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c0ff6b6f-b6c4-4a11-86b9-c0e2caf86d76	d6e0f854-8392-446b-bf5c-7e31593a68a8	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	4	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fcb74f8a-018c-4f9e-81b2-0662fcb7fdc9	a9bd835a-2ede-4f96-a43d-1500212a6fd1	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	4	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4a2b0cec-9076-46cb-b8b4-4956df32c002	693b64ab-20f7-4305-a7f6-21a1d5ec2f90	d620a7c3-32ec-4dca-8ed7-b5d87326818f	4	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
bacc37e1-ccd1-4ab4-aa02-2e4f279698eb	88d8cdf7-8a91-494d-8f36-db765cba34aa	bb3baeb6-156a-4b66-877a-70c3309563e3	4	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3c1d20d0-56c9-4fb4-8310-82424af77380	18548e01-c6ce-4319-a5bc-b92bc7660286	a3314b6c-1546-4000-a36a-a6c776247f9a	4	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
49ad5150-ed1e-4625-8186-acc75f52d4a0	e5ebfe03-f1d3-4094-ae23-45653b24b53c	22bebab2-1caa-40ef-b266-639b3bb0529b	4	27.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
13db8e7d-8de1-46a9-ae7b-5bc54a836b45	bc992b1a-d3a0-4cbb-b49f-c4bd23c009b8	c49e6332-e143-40b8-9f4c-b23b547fe4ad	4	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b419711e-6422-41ff-80ae-95a4314787cd	837f0ed8-f90e-4018-b8d0-f75b6d85c666	59a062f1-5222-404d-973f-3088ac2465b1	4	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a80a1b6b-5064-4a7c-91d7-78ad61e5d7f4	785f59e8-65d1-4db9-9680-e54d2d9f3ce9	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	4	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5b495c64-d72c-437c-bafc-d596458f45e7	33f3df13-c751-4d16-81f4-9c1da9481ce5	514aa522-6bff-4165-b78c-6b518f99dccd	4	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dc181966-99d3-47d5-892e-3abe0947ee32	189489d9-0049-4f03-84f8-ddad83c1d032	59a062f1-5222-404d-973f-3088ac2465b1	4	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c8379247-84b7-47de-953a-4a578166b7e0	424ae421-026a-44b6-ad72-b3cfcf97c3b6	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	4	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9203b0f0-41ed-40dd-93c2-ca8cb6a3b6d0	3875b474-0f31-4332-b99f-9b565b00d461	6e3fcfe4-0c56-482b-9766-c4cd4c257b57	4	13.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3513d38c-31d6-4e2e-9a91-39f9435aa28d	408c431b-d3cd-4df8-9e8b-cbc1a6f65524	83fffee0-405f-471b-896e-95e3cc01376e	4	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ff32def1-98af-4950-8908-b2fa0c4b7053	0affa59c-f4d9-4b6b-98ac-924cf67b8943	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	4	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a833b99f-53ec-4c62-b3e3-a3cfa9e7729c	265f10ac-9483-4a6b-a553-e485232255b4	010d6df1-03ed-4ace-a34e-e389424e9050	4	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5862a6c0-582b-4ab8-b173-bfb3706450ae	d1d6af2e-8443-488e-a10a-44b9155f6fdf	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	5	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e390b15a-d861-43ef-8c12-d119b4b1fe01	c15b6587-e163-4b51-b03a-91986acea98a	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	5	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c2ddf686-935a-4b73-9767-aafded82ac79	0a6da96b-f001-4aea-ae3c-0ffc9554bfd2	a6d85cd1-0f47-4f6b-9794-e05f81744722	5	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
58590ad7-60eb-4c2d-a488-5e8d908e5f67	927645e0-58ac-4361-8b53-555c3a424071	b52a5f8e-5cab-4fca-8b5c-d07230467720	5	18.54	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4be0ce2f-28a8-4208-b898-d76004188d7c	4c405a8d-b98b-4c76-9ff3-ef610cc981e5	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	5	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
de4ff04b-a93f-4d9e-8927-f8d0b46103a7	e9fe82e9-06cf-4c8a-bc2f-4dbfaa6b2e77	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	5	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4112c420-5bf2-4011-8662-3780b21f9f31	69f5d667-1fce-412a-8f7c-abbe5f0a0380	8b435be1-19f4-4571-8643-dd261e2e6807	5	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
acae6283-31b3-473f-8181-af20a900d45a	d924c037-d938-43d9-bfe5-546550ec0a35	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	5	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
584b84ed-640c-499c-ad99-2a34751200e5	22295dfb-2523-4285-89b7-ee1b31ac46f6	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	5	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d90aff8a-f4da-4a2c-ae46-c12b025f5827	ef9303c0-315a-43e9-a6a2-6b1901a70a77	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	5	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c30900a9-f3c9-44b8-8e4a-c1784d68a96a	7fa6eeec-31c6-46fa-86d7-d8e2842baa52	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	5	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d3dce9a7-4ff9-4df7-9fa6-c493639c3b11	85f5e8c4-c991-42e4-b2ad-d75e9c07756d	d620a7c3-32ec-4dca-8ed7-b5d87326818f	5	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2246bf42-32bf-4519-bfbf-6825a3e29c9a	feb8e6a4-c66a-4cb4-9cd5-997d5883a603	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	5	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3b18612c-1742-40e8-8a4a-a78d144623d5	817d19b9-5383-423a-9852-6adbbfdf3d75	e34dbad8-35e4-43c7-9925-6bd49d20b2c6	5	49.66	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1c388b1c-464c-40a7-88bb-72d1c5739e20	c3202257-214e-4d3a-b704-61e970be82f6	69c66949-c064-46c2-83ec-e535f5ddd424	5	47.80	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fa59330a-e997-472b-92cf-af799e76f995	9e7b1353-66d0-45e3-b3ae-c9cb9f8bd24f	c49e6332-e143-40b8-9f4c-b23b547fe4ad	5	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d9925e6c-10a1-465f-8d6f-f9daa9260d16	a81c37e5-8d58-43db-8a2a-4c7728d19328	276e4f43-463a-40ad-b06f-698be2cc75b9	5	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3bd0f2be-1638-4ab6-80a4-28b37268e705	4dcda910-d522-485d-8d47-d8305d96cdb5	83fffee0-405f-471b-896e-95e3cc01376e	5	6.07	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9ad4d381-3848-4eb7-b214-e9e82a38bddd	b70087b9-1789-4c8f-ac16-efa8412e40fb	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	5	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f7a4d371-8078-4e46-8018-dce9d94d72be	d906ec96-9d16-43ed-ac4d-7dd375bfac16	8b435be1-19f4-4571-8643-dd261e2e6807	5	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c73d2a9c-e746-4e4b-b1a0-6e84f42003f2	9d86fea3-879e-4f7b-931b-8a7bf33b08a5	276e4f43-463a-40ad-b06f-698be2cc75b9	5	39.26	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fba684ed-4d84-4722-adb9-bd8add21c563	813ce775-70fb-422d-9671-6220988012ab	93cfa5df-80d8-4387-958e-ff346ba30ab2	5	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d6694ac3-21e6-4ef3-bad4-5522a1626777	ffcab0cf-02b4-42ee-adb1-7d5df7c04efb	f3efdb86-bc87-43c8-9d41-912d1d821e04	5	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
03a9829d-3d14-43b1-9f87-75490066d65f	7be1e598-4984-4cb4-a9b8-a663201bb86f	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	5	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c757c37e-85cb-492a-9483-9d3dd5f43909	cbcf0bac-daa9-4256-a715-e7e993cb7972	e8288639-c50e-416c-93a8-bedb29c169f4	5	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
810d639c-ba51-4942-9bc3-4ffe52869248	9d6e1f5f-8941-41cf-bc38-26ccec9dccdd	d04c5049-6e53-4505-82d7-c8e46deda892	5	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8c975021-1a15-4447-807a-4041ab4df63c	0256c3ef-2112-4e0b-8e59-a7c786b1ce86	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	5	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c501b199-8e74-4741-b3ea-bd4c0a0491cd	bf7cabde-accd-40d5-b7d6-a58fd4e541af	717348ce-6fee-443e-96fc-92ee6a9cae8a	5	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
09cdc554-6749-47b5-9d52-12a8d099bbdf	25882ddb-494e-4565-8b51-0fe4abe58d9b	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	5	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
fb5ba898-92ad-4f08-ae5b-91e395dac40b	785ada9c-bb24-4e07-928e-6f21343554ed	c2f85493-b833-48d0-900b-ae08f1aa9ff0	5	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a4985f6e-4b3a-44f4-9809-460f5ffa3b54	69249160-ee9a-4a46-af5a-ddd22249887d	4a71ffc2-cea5-450e-8595-bb66ab01757a	5	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cfe4a891-97c6-40e0-bcf3-6f617908a3a7	d6a63cae-c375-4ffc-a4fa-cf54ec217b6e	e79f8efe-4888-4eeb-97c4-b4a9f0db7513	5	49.60	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e4e2962c-4a9c-46eb-9e1a-b24d6745bc06	e2e82c3b-8e64-4e76-96e8-d563e0380e58	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	5	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2d94705a-a240-4b84-88bf-faf73ea40313	1c219f82-1ed9-4abb-b4ed-11d993d80bce	57f39d16-c1e6-49df-ac39-e1e9870e55f3	5	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
87bb1a59-1c4d-4555-87ba-a977be8842eb	3acf71e6-35b3-4013-821c-27c57648c0a9	57f39d16-c1e6-49df-ac39-e1e9870e55f3	5	30.35	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b1b55f9e-d391-40b7-9328-62f32bf55ed5	956a682c-2ca1-4228-8af9-415aa0245200	b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	5	11.01	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
41c69ab9-9b27-477e-b62c-57f2be668715	575722ca-0f8a-4f47-93f6-9eb1af9d0b84	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	5	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
68bee5f8-3406-4d11-a7b4-59707d7e0357	603d977c-a6bc-4b53-b928-4f333a6777b6	eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	5	41.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1ebf1dac-9cf8-468d-9e28-0a4d1721288a	c6ef7578-13b3-4454-9357-33d3a3421ca8	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	5	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
97dcc01c-5413-4281-9e6d-2f56e949a5de	83b82f54-b888-45c3-96d4-46d8726f179d	c49e6332-e143-40b8-9f4c-b23b547fe4ad	5	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
231114fe-e0fe-4fd3-b288-e569ab2f78ac	ccfad263-dee6-45dc-87a6-2852fc81a70a	bb3baeb6-156a-4b66-877a-70c3309563e3	5	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9844544a-716a-458c-a747-9eeb0d6d84ea	c0abef73-527c-4744-9760-e21c71b6691b	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	5	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
90b76f75-3533-460f-a9f4-d811c60a7703	31903a44-bab3-48db-b721-f8dc87a95d01	d413cf58-d628-477f-82db-26c2199271de	5	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2c9ad2d6-3bd5-484c-be0c-56c456261bab	4d0fcf77-73cb-4daf-a003-0b4902e29f97	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	5	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3f488738-04ad-4f26-812c-49aeb7f25e6d	25074d97-b264-46e5-bd81-8c40b5c94f82	59a062f1-5222-404d-973f-3088ac2465b1	5	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
374b2b31-102c-4cbc-ad24-d502de97020f	33e7d559-cd1a-49c4-9d64-c6044b36d892	f3efdb86-bc87-43c8-9d41-912d1d821e04	5	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f40378ef-e165-40a5-aaa4-db2279307b54	9b6a6615-edfe-4a27-85bc-daf8acbd1f7b	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	5	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9cb9bd5c-d6bd-4c6b-a63c-07d93d6e8d09	8a5eb443-e259-4d7d-86ea-c6003263e5f9	451e1138-e4ff-44a3-955e-ee18e8464d80	5	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3773a493-3802-4013-9971-25923d4fb12b	a9bd835a-2ede-4f96-a43d-1500212a6fd1	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	5	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
89ffc52f-d8c7-4e29-a115-c28620a78a71	3f6c72d3-cac4-4022-b4b3-774307719727	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	5	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
648ce062-9889-4c4b-8168-e522942572be	74098f06-1217-4d94-a61f-a8329d6c6603	d620a7c3-32ec-4dca-8ed7-b5d87326818f	5	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9abd32af-bb80-450e-82e2-c7438c1281a3	6cfb3ad1-16a5-4c2f-81f9-4ef38bdcd7fa	c2f85493-b833-48d0-900b-ae08f1aa9ff0	5	15.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8c296d6a-e018-45ce-a577-f7fcb390801b	9b045ef9-5cb7-41b3-a09b-98ad670e5778	451e1138-e4ff-44a3-955e-ee18e8464d80	5	21.57	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6ba27df9-4fc3-44af-bad2-f452f3ff1e64	9a49aa68-fc63-4fd3-a5db-27fe1c7cc81a	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	5	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
8df48696-4673-4b82-a7e4-5afbf60ddca2	cd13dd4d-e257-4c1b-a28b-592f28d2bacd	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	5	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5f08dc53-acef-45ea-a823-5921ffb31792	b2fa38a2-f5bf-4541-ad23-b474ef6caf62	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	5	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1d29f8b0-c541-4052-a967-f838e966bdae	28810d2f-06da-40fa-b5f1-8a14a0c9c8aa	1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	5	19.31	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
414923de-6021-4443-81b3-da38c84b5bc7	7be1e598-4984-4cb4-a9b8-a663201bb86f	d2f7ca78-5e9e-469b-8d96-e24efccfd70f	5	20.82	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c1586f21-edfc-49b0-99ab-77084d514574	58546a50-51f6-440b-aea1-12317d6a9f50	d04c5049-6e53-4505-82d7-c8e46deda892	5	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
67e99be4-47d0-451a-9de0-b8b9d6c6f1f8	b395778c-d57d-4c6a-80ea-a3caa387b534	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	5	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dba68c72-3cfb-4aeb-82d3-727c08bb52b8	ffcab0cf-02b4-42ee-adb1-7d5df7c04efb	a974674c-a14e-4a7d-9e12-84ee4678aa68	5	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f32ba3be-0c48-4107-b2a2-31ccfb071020	891c1ad3-1eb8-48d8-b714-5691dde76c3a	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	5	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
52047987-69f1-43d5-8c8a-56c89a8f062e	6bd5f5f0-0439-422d-b1b3-cdb2500f39a7	1c635cc6-4c91-40d2-8924-8c01ba63241f	5	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
585a423c-548b-4d08-b0e9-8bd8b1ec630b	3fc65409-48e2-4abd-a8f9-eb667547cc89	1c635cc6-4c91-40d2-8924-8c01ba63241f	5	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4b3b3ced-8798-4460-ad59-1ff37252d9f5	c5511bd1-c7e6-4e11-96c0-a4647fc0b185	2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	5	45.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
621d0e2c-7fed-4fad-95cb-14d3dc8fee22	c24fb979-58c0-4087-8a4b-d275a361204e	d620a7c3-32ec-4dca-8ed7-b5d87326818f	5	22.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
51d624ce-c080-453b-9297-b9de9fb09959	1adc4dbe-3021-42a1-ae26-b4353f7c87ff	8b435be1-19f4-4571-8643-dd261e2e6807	5	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
26479048-bc4d-44d4-9c91-333ee11e65e9	4a126694-4f04-4e97-9975-c4db71740622	cd847e80-5a30-460b-8dc7-ba44da3d9c7f	5	27.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
69e2550a-5663-4620-80a4-74330fe13692	4f0f7146-a213-443d-ab4e-2ad7f2d2eb03	010d6df1-03ed-4ace-a34e-e389424e9050	5	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2781ad92-23e4-4a16-be27-8d4544cac851	77174641-0c1b-452f-a71d-2050810b6cdb	f3efdb86-bc87-43c8-9d41-912d1d821e04	5	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7f8059ab-658e-4f8e-ac96-564e1d36ff9e	e2e82c3b-8e64-4e76-96e8-d563e0380e58	a3314b6c-1546-4000-a36a-a6c776247f9a	5	15.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6eb6f30c-7156-47e4-ae01-c445206d0840	6895d518-2a61-441a-bac6-f5261c015295	d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	5	11.03	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d268d516-ddb0-4f94-a84f-7aab7867720a	65022266-2c27-4beb-a104-3e467a525b6f	8b435be1-19f4-4571-8643-dd261e2e6807	5	46.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f48616d8-d7a3-401b-bdbd-e99cd7dd0a04	2fb35d73-a26b-4ff4-81f1-56bcda96aced	f3efdb86-bc87-43c8-9d41-912d1d821e04	5	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5a526491-ab14-49b4-bc4d-220b29bd75fc	6e3cea2a-5691-408e-a0cb-191616d8529d	132bac58-39fb-455c-8671-cdf50d22f000	5	32.22	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
1081111d-aa38-40c1-87aa-c85ec7633710	244289f8-4fb7-49e0-a575-c71ff2cc35d1	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	5	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3ed92ef8-d4af-4ba3-8ac9-45e609d4d828	2207872e-4613-4c1a-a69b-7868607f4cda	e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	5	16.97	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7d0678e7-776a-4f5f-bce0-6ab86ae33b75	85575b48-fb50-4e80-a5a6-85f8f3de49cf	46139fb3-b443-4629-b8c1-c5ac5ff0de07	5	44.84	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
99c3ef4a-3270-4d14-a316-bd987aaad743	48b976be-368a-4840-85ee-cc79eddcf95b	2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	5	14.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6e882948-b979-4bae-b800-1582662b7980	7ce6995b-3676-4097-ac72-b769a106737c	e8288639-c50e-416c-93a8-bedb29c169f4	5	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
74f4b3ee-ff37-42c7-92e7-8c3686464550	b13f235b-5be5-40a7-9739-7e15f6d879af	e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	5	20.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
76283778-6a44-4e07-a0ac-e3cf6928ebe8	e28ccb55-281c-4856-9fce-287eeb1bf6f5	a974674c-a14e-4a7d-9e12-84ee4678aa68	5	43.00	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b3df89e8-eadd-4610-ab47-30f15b132f82	1b389710-04b9-4756-b0e2-9a23c89d6359	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	5	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
527e18e8-da1e-4010-b1cb-6fc3fb847565	9b5c1cfc-f93d-4c98-90c6-8677fefc0365	ac4db68b-c6d8-4658-b652-08ad7b0d5c96	5	9.37	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
e6f8e903-cb60-4b9d-b4ac-89a697f25a45	c54251e6-9238-439d-aa4c-f861ab1e911d	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	5	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f60cd7b6-f295-47f5-853a-a86578689bfe	c200ea82-3aab-4e57-9140-751e3c30a1fd	717348ce-6fee-443e-96fc-92ee6a9cae8a	5	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
25ecf055-e415-4a0c-b4a3-b9557fb9a691	244289f8-4fb7-49e0-a575-c71ff2cc35d1	f3efdb86-bc87-43c8-9d41-912d1d821e04	5	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0edf1eb8-e286-4721-856c-e92da9adcd71	b39268fb-f608-4783-b80d-1f715fb17eb3	a6d85cd1-0f47-4f6b-9794-e05f81744722	5	31.75	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b1583c98-8edc-4197-8705-906ea9bcb851	c35a205d-8313-4d52-a829-87c5b0e24b52	d413cf58-d628-477f-82db-26c2199271de	5	13.61	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
2520d72c-eeb2-451a-bc6f-bb49f2c275f9	ff20a0a4-6d81-40ae-8e44-ac8d28c17aac	bb3baeb6-156a-4b66-877a-70c3309563e3	5	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
4273a5d4-9496-428c-bedf-a9cc17274fdf	15f5ccae-d11e-41cd-87ce-005825210c97	a3d4b59a-f601-4155-8f2c-e48a8173bb97	5	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
217b8975-f1e4-4517-aa44-2e23b4f6e780	b983bdf8-4ee7-437d-aff7-f40333b919e5	d04c5049-6e53-4505-82d7-c8e46deda892	5	21.91	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
dc14591a-c398-4c00-8373-bf6b9c10ba6a	c0ef7a9c-1a5f-4654-b898-83e64b14b273	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	5	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b626a60f-cc9e-4c9c-924d-4cd9a200877e	8a7559bb-cbf5-4353-8488-90a19620c9eb	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	5	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
6a8ab5c8-051e-4aed-b1a1-551f20d2b5a1	8cd20854-aa24-4f9d-8a5d-8904c047fc30	e8288639-c50e-416c-93a8-bedb29c169f4	5	24.02	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
f7e0bfd8-7843-44d8-a1df-10d5ba765517	dd52af66-ce5e-4585-ae75-16800b9b7d42	010d6df1-03ed-4ace-a34e-e389424e9050	5	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
a0153488-fe99-4e44-960b-563046b3b962	1a32d39b-83a2-466c-b63c-08b923027649	bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	5	31.04	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b0ade1ea-f251-450e-b920-c0f6affd1c6e	e7c83865-bc11-41f1-b25d-2f6a49631a83	75ae63e4-1f9d-4493-8db0-98f20c5a24b9	5	29.44	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
25e082c0-a541-4443-a670-7c57984c257a	c3623ce9-ea76-4e28-b8fc-f8816f5f3ad8	53adfa1b-0dfe-40c7-abe3-4d687f2005e1	5	30.12	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
c7356c87-fa51-4eb5-94d1-869526e22751	cf9070ce-6a09-4a39-a08e-a228b998164d	4a71ffc2-cea5-450e-8595-bb66ab01757a	5	35.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
7a0834f5-143f-44fa-b3ef-1ec056faca84	98b5e6bb-cf5c-4c63-9a3d-b997edd4d39e	cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	5	16.38	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cbb07449-c742-462c-970b-9c9c67c55b65	b4632a54-c7ce-4729-85ab-62c131835268	717348ce-6fee-443e-96fc-92ee6a9cae8a	5	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
9427fce1-9412-4bca-bdc3-1303330f90ff	b4632a54-c7ce-4729-85ab-62c131835268	7c0aeeba-d877-4f92-9be4-8cb9591261eb	5	35.59	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d34ce2d1-c03c-4106-afb4-d56ee5d62f26	e78fd111-2f4e-43bd-80b3-9e755eb5db56	b799a518-f9ef-4451-8de7-5bfbf4b75fa8	5	19.96	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
ac11ccf1-760d-4f8d-9db2-584d1d307d0d	ce549fcb-52f1-445e-b0f1-c648b9e91758	a3d4b59a-f601-4155-8f2c-e48a8173bb97	5	17.79	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
12d489bf-d0ca-4a00-a832-e2424a0066e4	139e5c95-92eb-47e7-8331-0727e3929acf	010d6df1-03ed-4ace-a34e-e389424e9050	5	11.98	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
715d57c0-4a8b-4e05-a757-720dbed02b3f	a265444a-9c23-42a7-a912-e7905915aa27	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	5	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d5a97f80-2ce3-4cb3-a423-481221c8f47b	8f8f2564-0a4e-4e52-bb58-14cadde1d28b	1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	5	12.32	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b4d58c5a-19b7-4c50-927b-683e9f81b058	b1419a70-31a8-46aa-b225-25a765e53f8b	bb3baeb6-156a-4b66-877a-70c3309563e3	5	7.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
b029830a-ed99-4545-9b17-8866299f234b	dce91275-e00d-4b0f-8276-2cf8bca1d483	514aa522-6bff-4165-b78c-6b518f99dccd	5	40.85	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d9a50a1d-9dbf-4427-bb29-bf61cdf17c79	feb8e6a4-c66a-4cb4-9cd5-997d5883a603	8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	5	37.13	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3b65e6c8-9f60-48bc-b450-2bca3942ea42	6b9da4a1-bac4-442d-bb65-bea37786e021	1c635cc6-4c91-40d2-8924-8c01ba63241f	5	26.93	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
cd541ebf-1077-4cd4-aebc-cb5cacbbe21e	64e594d6-aacf-4e79-b12c-446250519ee6	c49e6332-e143-40b8-9f4c-b23b547fe4ad	5	27.63	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
5b90eec3-d98f-42e6-9302-8835749a082c	423b7f53-c1b7-406b-b2bf-188fb63cc25c	93cfa5df-80d8-4387-958e-ff346ba30ab2	5	8.14	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
0fff9591-ed34-4222-8698-46cb4f7bfdd8	3518e0b9-229e-4c24-80bc-aa1f8f4428ec	717348ce-6fee-443e-96fc-92ee6a9cae8a	5	28.62	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
d57c6154-b8e4-4eb0-9916-52ff4afc21a6	8c04ef29-f905-428d-a88b-6db52e52353e	f3efdb86-bc87-43c8-9d41-912d1d821e04	5	19.77	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
3d23d74d-9551-4f2e-a06d-af2f340af838	143b148c-cd4a-4e46-8d50-d61f9f4c2835	59a062f1-5222-404d-973f-3088ac2465b1	5	27.92	2026-08-19 23:05:12.601172+00	2026-08-19 23:05:12.601172+00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.orders (id, table_id, customer_id, status, total_amount, created, modified) FROM stdin;
ebf8a450-d443-4b97-ab02-f0894f0a4c10	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
1ffe052d-fad6-434e-a1c7-201855cdea44	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
86b5fe5d-bb7b-4f22-bbfc-d6fc13d64438	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
1bedc78d-b431-4910-b505-88d1db20d94f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
f4239948-263b-4309-8859-1465580b66ec	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
a3cb9efd-d6b6-4857-95ab-b249764b66fc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
b1ce44cf-9e59-45ee-a46f-a30ac38adff4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
2f20c3ee-75cb-4e04-b144-67b6b2e6807c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
d100a439-74bd-46ca-83f3-b92570e31f1c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
b013054a-042c-4cec-9c95-b8ddff8b4940	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
477610bd-b58a-4b4c-a7e0-71a5897a0a33	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
b5511754-2e13-4d00-b75b-4a9e6f129d86	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
e3ca877a-6710-4049-93e4-57ce4b390796	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
886e41c0-f6d3-4138-86b0-502bf77b8d38	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	0.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.545912+00
aa8d2619-249c-4724-878e-7acff61d3b18	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	51.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
22295dfb-2523-4285-89b7-ee1b31ac46f6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	141.33	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5e86351d-26d9-4fe7-b63a-fd5c94b19160	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	142.02	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
61dd598b-a1de-400e-be75-fa2f2e68d337	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	64.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ad6965f6-e833-49ba-a3d2-c136f47fc0ae	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	142.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c17985cc-edfa-42a0-8019-4578916a0ed5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	126.11	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f5db4495-46be-4cd6-817f-05d538a758f2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	128.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d4685600-2d80-4d01-9583-6db026cf1988	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	92.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
713fb165-3791-4111-a736-2215747f3bc8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	31.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ba96e665-f89b-429d-a49d-c431095f042e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	130.61	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e7c277d5-c563-4ba4-a983-f306e510eda1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	327.56	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b6b45b42-12bc-415e-9efe-ba9357190f5e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	108.91	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1dd24097-9e1c-47da-b95a-18fe766f62a9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	58.97	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d758abc3-9c6a-4e42-bdd0-76cad50aecf4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	233.71	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
16d4978c-02bb-461f-b5ec-82662df34681	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	193.17	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6795ef74-6ddd-4cdd-b380-b0f7867b63df	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	152.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1db271a8-0d1f-4f36-917a-8206e0bb29bc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	28.11	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a2a88528-9022-4258-ba7a-ac37ff66bf2b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	127.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
aad26943-c21b-4819-9356-cb0a2bbeaa0c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	128.29	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9a4b4a1f-4363-4606-9f45-e1d4f1f20148	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	28.11	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8c04ef29-f905-428d-a88b-6db52e52353e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	163.56	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b395778c-d57d-4c6a-80ea-a3caa387b534	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	256.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
89856409-ee57-413f-9d24-c02239a40db3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	52.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9063fe90-e5d5-4ea4-bc3d-2bcf09f17d08	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	141.12	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2bfc65ed-0a42-4c0c-978a-09e794342726	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	103.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
044dce02-86ab-4d8c-bd8a-d505891ea5da	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	63.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f2b436e8-ee0f-4702-bd35-b758c569c219	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	79.86	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dbf7d621-bf6f-469c-8464-c8e00cc9770e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	136.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d3a0007b-3d21-47ee-a0da-c293addfe4cf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	164.53	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8ac7d68c-2fde-4ee7-92ff-6601d0d806b2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	113.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9001cb35-5253-42ad-86a8-2cabc01e3742	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	157.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b4cc24f0-68e7-43ed-a202-b6159ff1b284	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	172.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ad436bf5-e68d-4804-a47d-5c633a29d5d8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	106.86	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6f7981b1-88e4-466b-aced-d3f9a1f68fe6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	263.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
191b9363-66dc-4b10-bd00-33be3db58f6f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	127.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7be1e598-4984-4cb4-a9b8-a663201bb86f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	174.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bf7cabde-accd-40d5-b7d6-a58fd4e541af	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	210.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
098f7f55-55a6-4dd6-a4d8-a3b56a67b538	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	128.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a42701e9-480f-4e59-ba8c-bb4c728c1aad	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	71.99	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0affa59c-f4d9-4b6b-98ac-924cf67b8943	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	79.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
26794317-eb6c-44e8-b3d8-2fc66d66092c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	126.99	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0425fb9b-aef7-4940-a12c-1ca49264c791	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	75.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c5511bd1-c7e6-4e11-96c0-a4647fc0b185	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	278.99	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
858e147d-3c40-4bcd-a1c6-d2945086db0d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	208.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
52afba9d-c3db-4025-b708-b4486c8f9c10	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	111.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b2fa38a2-f5bf-4541-ad23-b474ef6caf62	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	164.53	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
424ae421-026a-44b6-ad72-b3cfcf97c3b6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	67.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
28810d2f-06da-40fa-b5f1-8a14a0c9c8aa	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	152.23	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
608d81a0-84b4-4646-ac0f-011a5a71319e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	187.25	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
49b006f9-4539-405f-9f94-09e38a739005	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	117.87	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5a481a43-6837-41b5-b209-1557dca73418	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	145.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
916b6554-61c4-4a49-958f-26f268aeacd6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	46.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
479cb726-fc8d-497e-a7d1-f7dc8f642509	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	165.77	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
891c1ad3-1eb8-48d8-b714-5691dde76c3a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	150.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
20175126-96dc-42e1-b7cd-0c1e5080292c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	83.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8f8f2564-0a4e-4e52-bb58-14cadde1d28b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	95.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c439872c-07cf-45a0-86ee-44bd81586b43	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	146.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d0538513-a0f4-46dc-9212-1b2835f08f64	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	217.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
636858c1-9f81-4b28-ba16-58f953d8695f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	11.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7be28eab-46e7-45e5-a6c1-1bb5b5a0b16f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	110.09	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
864a2bab-88c0-418b-a0d1-872a3931fbe4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	215.61	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
05b62cdd-d2cd-40ed-9a9a-8ba5da910e49	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	110.27	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1c0b4668-5fa0-4548-88d7-e0d9d8a3dbd0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	74.17	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a0a2d50b-3141-4dd8-89b2-f80df5a7f9fc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	104.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0386cbff-6b94-46c5-bda7-1cf5ae1eda6e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	250.45	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
73f0fe3c-a749-49da-8464-91dda826c443	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	113.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
af640f9e-e729-4b4a-94f4-63ca562339c2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	39.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
26debe82-8a6f-47c2-972e-25a4faddd330	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	290.40	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f8864236-8738-4f25-b825-b503f68690e5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	190.39	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c24fb979-58c0-4087-8a4b-d275a361204e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	300.55	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c81f38af-435e-42b5-b40f-b96e1aa0ab60	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	151.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d3e36229-c4c5-41f6-9905-240dc1bbbb5f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	114.07	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fa5efd46-4f8f-4f67-8575-004cc3c62124	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	77.86	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e7c83865-bc11-41f1-b25d-2f6a49631a83	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	165.41	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c594f079-7f51-4ed3-a8bb-e6acd8a18c84	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	228.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ee12d632-0fff-44c4-adb1-7234b09bed40	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	175.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
47d96cbc-0687-4fe8-b469-ca8a6ba29a47	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	35.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a2ee1fec-2eab-46bd-9095-236b911eea97	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	32.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8a5a95a0-5c10-4942-88ab-60f702a5991c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	37.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e51f954e-9aa2-4b63-b18a-38db1d5edc60	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	32.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fbc9e9a6-3f15-4094-8ef3-92f7e1591362	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	112.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
39fbd663-2bf1-441d-adcb-3d4744d75bc0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	53.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
324f609d-0b11-4790-9291-ee70878d97f7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	65.75	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
74098f06-1217-4d94-a61f-a8329d6c6603	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	168.73	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cc995690-eaad-4fde-92a3-e8350ca766ef	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	33.09	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5b689d60-36ee-40a5-abc2-6c25dedb38b9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	101.07	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
044e2d98-a9f8-4655-a344-2ff307bba8d4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	39.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
961d6395-fd19-40b7-86da-07718ac797ff	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	41.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e94e7ab6-f09c-414b-a82c-ecc76c9d816a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	85.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4b3e0a22-eff8-4b14-b935-b0a68f7d2e7b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	49.21	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
01801415-1b5a-44d3-b3c5-dde11b06547d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	110.15	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4e6a35de-940c-4d97-b7f4-482bfa5df28c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	54.66	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9d6e1f5f-8941-41cf-bc38-26ccec9dccdd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	272.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
244289f8-4fb7-49e0-a575-c71ff2cc35d1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	183.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5314c407-ab54-4e6b-ae82-c1b08adaec67	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	64.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
17d942eb-9314-4633-a9af-979492ce49c4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	41.02	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dd704203-4544-4ac0-a3fa-3d8426cff0e4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	171.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cc966c0f-8d79-485a-8ffc-20d9c09f4680	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	68.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c4c6c287-42f6-4a0a-82c6-234a088143fd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	62.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b57530be-367b-43f8-8680-db9701db135f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	86.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a94b9132-5bf7-4ccf-b0d6-f446b1960831	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	85.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3c9c570c-0f48-43cb-b8a4-49befd2d28c7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	45.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
36c3d31b-f011-4d7a-adbf-d0458c9103f2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	63.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3875b474-0f31-4332-b99f-9b565b00d461	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	76.61	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
117f009c-8735-4c95-960f-439f77647cae	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	316.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
60c35908-d719-4ebe-a49d-68faa88b4321	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	97.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
575722ca-0f8a-4f47-93f6-9eb1af9d0b84	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	161.94	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
515e49d7-9df9-44d4-86cc-6454f833f834	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	115.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
33e2d368-d23a-40b5-9010-c36e82235107	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	16.97	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
88354dec-632d-407f-80a4-9fc65bfbc7fc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	74.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c1c57056-949c-45ea-b328-d6d1a4be913b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	167.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8fda662f-5bc3-48af-8b6c-454d54c1c13b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	47.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d9b0d672-286f-4985-9ba8-021202fa2b20	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	97.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0a4c031e-e8ba-41fd-8e82-d1fc1a7e8eae	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	68.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3a83046a-5888-44d2-a476-edba61d2f61a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	161.47	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cf9070ce-6a09-4a39-a08e-a228b998164d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	179.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3b9ce712-605d-40fe-a165-ff7579e6e4f0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	121.11	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1cae5f9e-29bf-4bbf-90e0-7020b2a39c97	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	42.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
17778224-4da1-459d-b96b-0b9005435909	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	211.57	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cdd5db0a-b50a-4d9e-acff-14f165ca987c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	157.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
73c2b60d-2408-4d5f-96c9-d5ca5f378304	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	43.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bbc19f4c-bf5a-4ef2-9733-c7f55ef0ffa2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	31.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2a544346-4e45-417f-9575-e9302c591522	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	85.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
962057bc-e3dc-4b0c-a15c-6235bd603203	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	44.12	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a453ebe8-695f-4130-b3c8-d4795f1c689b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	95.25	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4c5efe4d-5666-47ab-96d3-1a564f2d36ba	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	123.02	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
50b235f7-a4a7-4e19-8aa4-b394b4df928f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	134.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ce413913-153d-40ed-a54c-6f77fd2a25a3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	45.47	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f7e8e12c-67ba-4bf6-b5b3-83e90d967caf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	275.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a59a2938-29a1-447d-801e-f6b12e3300f1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	47.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b03a3bf9-ba71-4550-b1f9-edc9e8c38364	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	102.77	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c0abef73-527c-4744-9760-e21c71b6691b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	161.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e0582ba8-cc93-4a3b-a2cc-1279952dc75e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	26.94	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
935b9b31-2c9a-4dc3-83c5-2453f3020916	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	55.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b26c8b5d-0a94-4360-beec-c220e85e3f1a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	47.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8c856c4a-1584-460b-9686-96270f88b8ef	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	117.78	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0150fe46-3064-46ec-be84-b5efd8d98486	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	53.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
115eef4f-8ef7-40f6-8c11-96bf8797549c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	62.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
66a42d4b-4e30-40a5-9ca4-88008dc80099	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	22.89	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
995b8bba-6f52-4b02-be56-16b732c6cb2b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	98.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e2444e15-5e55-450e-8b09-22e1157f57a4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	66.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
52f621e6-e888-42b2-85be-3f9b36f2e5d9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	115.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6895d518-2a61-441a-bac6-f5261c015295	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	169.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
513019cd-5fe8-4fd3-952b-9c73641b891e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	234.75	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
15f5ccae-d11e-41cd-87ce-005825210c97	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	138.61	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d2e94dce-ae9d-4aba-b1e0-4ab2ea5169c2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	37.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
45b8f496-f798-4fda-8464-138b8a47793e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	51.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e777cc66-2fd3-4721-bbb9-5cba2e38b778	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	47.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5d42dc7b-48dc-49a7-a7b7-3818d2ec4146	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	144.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b8b15ae0-9670-4e40-8622-307e7fe07106	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	56.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
12eb3375-0fdb-4d8e-bc9b-a3275b75e6db	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	104.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7f3736ea-2440-4d5c-95ba-f83cbef6d72e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	103.61	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c890153b-4329-4b65-9233-294f3d6c3a50	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	198.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8a7559bb-cbf5-4353-8488-90a19620c9eb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	245.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e7a18fb4-fe36-4f89-a432-1848bedae75d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	145.40	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
797ca8e3-813a-4f42-82e4-969328a4d240	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	117.32	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5da7923e-37b3-4f7f-9a39-9e7044069922	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	139.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f2dbfe7a-ec20-4091-a2f2-7291ad718da9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	212.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
279c08a6-f2bc-458c-8fb5-7df99c0a395c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	185.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c37e4e3b-586b-4192-a54c-fd25efe6fda3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	77.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7f8147df-1bd0-4287-b6af-b7f9e5c32334	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	64.61	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bf1f7930-0ecf-4f73-a1a2-9f5bf70cb808	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	120.38	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e28ccb55-281c-4856-9fce-287eeb1bf6f5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	252.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4a9301d5-ed4c-4d9a-8ab2-58367120469b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	38.06	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
189f726b-0b71-43ed-a5ea-a53ed75c11d1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	125.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b54f5794-6aac-499d-a9dd-d776d9e6f900	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	83.73	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8dc42314-4e9b-444f-b210-c01982218c61	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	222.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9b045ef9-5cb7-41b3-a09b-98ad670e5778	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	250.21	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
56033f22-72c7-4eba-9a39-d1f1935143c0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	129.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b65fefaf-76ba-4050-8d8a-3394c6af05bc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	101.07	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f9e08907-42c6-47f5-b140-df61790a7769	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	107.43	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c33d164d-c1d7-4aa7-9801-0fb22f9fca9d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	142.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
54c45a8c-4bb7-4d08-a12d-92b4c7307b93	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	89.56	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d0ac80b6-2fb7-4935-909f-d3e942a85d68	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	128.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4a126694-4f04-4e97-9975-c4db71740622	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	184.21	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1f7c3b46-846c-442f-8898-4ca8a7da4fd8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	248.32	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dab9151e-fb52-4e13-83bf-9f225f0d4ef0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	39.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bd24a131-4468-4d28-8ea7-8803c1bb0e32	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	12.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3fc65409-48e2-4abd-a8f9-eb667547cc89	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	170.57	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c87e8bb3-c7b5-47a5-9dc1-3d8337f42982	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	107.76	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9d93b739-1187-4976-9c6c-0a389356fecf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	90.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dec13856-c58c-4eb3-9360-8c814c9842a8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	189.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ffb156c2-7a76-44b9-b6af-9acb6e54fdb8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	71.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
99f6ce9e-fe98-42b9-9fa3-8f7370f07a3d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	63.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
813ce775-70fb-422d-9671-6220988012ab	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	40.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6d5bd472-73e5-43ac-8189-8f1ffc3dd7d8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	85.35	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e1eadabc-6c40-4ff3-93a9-a914dc022510	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	172.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
86e280af-f765-40e7-82df-e0292b0693b8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	135.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1c219f82-1ed9-4abb-b4ed-11d993d80bce	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	151.75	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ee3fced1-7edf-471c-9b7d-5af7e827be77	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	52.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8368d8d7-9090-41e4-bc90-15f7a084df5b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	140.55	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8e577abf-5f86-4498-9309-64f616ea275b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	67.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7fa6eeec-31c6-46fa-86d7-d8e2842baa52	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	129.21	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0cf1abe2-2b17-4051-ae66-d3a989ece9e7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	64.35	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
08ba1eaa-9546-40a3-bb75-6d1f69fbb9ae	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	116.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3d3e84cc-3247-4432-83ad-72071bd04e24	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	89.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
42aa2824-9ef8-42f1-88f0-47e0e36adc45	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	39.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
44734553-b21f-4269-a5c7-5a1eca042d59	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	79.67	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
17816150-5d60-4721-8bf6-453144e35e34	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	87.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a2fbb854-4e87-4aa8-85b9-75799e0089cf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	105.32	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c33b1dec-a5e6-4e60-b5cc-85aee74cd171	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	203.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c91d7846-9ab6-408b-bb49-d0c988ca66b1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	109.69	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
00e3d3e5-5297-482d-9d75-c47628808981	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	39.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
50360424-c121-41d3-9696-4a8e8b749192	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	55.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9686583f-4293-4dfb-a862-80330ab23773	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	174.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8a5eb443-e259-4d7d-86ea-c6003263e5f9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	124.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
63a49523-020c-4bd5-9fbb-5f8b62afbf4f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	40.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
77fa4b65-dadc-4f68-863b-f5fd3250ecd0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	103.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f2bfd119-2269-4266-bde1-c727a5ddd258	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	83.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
acf1e7a3-eac2-49fc-94ac-dfa337383396	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	235.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4fb0de4f-2a58-46fd-9c4b-79075f00818e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	125.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cc080dec-4631-475b-be93-623ae8eecadf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	92.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1b557418-1d52-44b3-98b0-3a158948754d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	82.89	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fac6fc06-5a83-49da-a8f7-77e309b05910	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	267.06	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
25074d97-b264-46e5-bd81-8c40b5c94f82	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	139.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dbb04a53-5db6-4ef9-ab7c-a02e9340cff5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	66.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c6a35ea1-6c8d-4200-b154-a60f60251c0e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	31.75	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
23521e95-522d-44b5-ae88-1b545c1fd515	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	138.02	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5cf4ca76-71f8-4d8c-83ec-304ca8c03cf2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	75.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e72c4678-b6e3-465c-a547-916548618acd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	30.12	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a265444a-9c23-42a7-a912-e7905915aa27	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	185.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f3e56460-8031-455d-8946-6c2496c0b472	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	43.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
553be188-d1bf-4d0d-9ff9-d58b67a5e0db	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	116.34	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c271dc6f-c3af-405d-bad7-25f66d65a3bc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	94.73	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
413273b3-2fc5-4051-a80c-1162f72ebf60	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	33.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
769029a9-1596-430f-8749-27ffa95790c0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	30.12	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8244148e-7455-4ccf-b73b-352da6c021c8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	97.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2207872e-4613-4c1a-a69b-7868607f4cda	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	104.81	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
39d2e9ca-24d0-4e06-8cf4-403a006ba21e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	19.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1046377c-3ca2-4f05-98d3-40e0afcf6f1d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	91.69	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9274cccf-789b-421a-aafd-37bb06bcef77	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	15.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a89f854c-8dc9-4af5-b074-2deed2a48072	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	22.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
43dbbaa9-b760-4ac7-bdf9-c3c921fb1d5c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	145.87	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e9fe82e9-06cf-4c8a-bc2f-4dbfaa6b2e77	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	102.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
28a83d00-61f4-4633-9a10-39a3cf1027a4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	219.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
356947bf-9525-4eae-9a7d-b9ed738725e6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	23.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
31a03291-ca89-42b9-ae38-7783fc3344c3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	22.06	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
799383a1-95d8-4e37-ba78-f001c4671517	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	67.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
693b64ab-20f7-4305-a7f6-21a1d5ec2f90	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	122.74	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fa065969-0dee-4888-86b1-ba645d478746	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	47.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ca88aace-dadf-4ac5-95cd-2d82f81cb785	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	226.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6b58766f-679d-4a49-94d2-61c644fe4958	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	101.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b9c7df2c-9c25-4a99-a296-217e49d299e6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	28.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5418f393-a98e-47cc-9444-8c598899bc8d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	312.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
99f40a2a-e6e0-4a58-9657-b7a785563334	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	137.74	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8669e169-c126-42ed-8d4a-a73d39ec8572	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	114.76	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fae5b1ca-a3e8-491e-bf10-6edd05f9a558	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	148.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
60068966-6de1-48f1-b649-08f4bb70bd7b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	36.30	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2d38ce28-911a-46c2-b612-631fa48c4823	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	97.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8edf1f87-ba3a-40bd-af47-0d26ab5c34b2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	131.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
44027ede-9ccc-4320-a67c-d60229ceebdd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	22.06	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b44e9ce9-4575-4b75-b8f9-a52d5dd1651f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	242.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
83b82f54-b888-45c3-96d4-46d8726f179d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	252.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e78fd111-2f4e-43bd-80b3-9e755eb5db56	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	123.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
efaa196f-f777-4e6f-a1c0-960360bd0159	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	204.33	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
451626db-18b1-49af-803a-1ba420462b32	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	239.49	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4d4eada2-4ccf-4783-86bc-04a208ee6b45	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	93.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c83c2c71-5eb4-4165-9a95-a900434b62f1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	67.78	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
25882ddb-494e-4565-8b51-0fe4abe58d9b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	203.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cbcf0bac-daa9-4256-a715-e7e993cb7972	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	231.49	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
993c9ae2-c13f-4c31-ad1a-50a6fd30f7d5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	270.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
94417d6b-ad56-4f3b-9493-7020a3cc6607	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	170.34	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3e94664a-547c-4588-8038-49f8b8055161	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	101.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c8cb3636-35f3-4916-a79b-79432b68d64c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	22.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a98fab5d-9d6b-495f-9d5f-a37db36cee46	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	58.39	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5956ef23-ddb6-42d5-951c-3f7ac83fe422	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	159.07	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f42a13a6-7ef0-4fdf-828f-8000f3a6e31e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	219.07	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
71979b3c-0eed-4490-996a-5374cb24ab7a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	148.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d41086c3-e5f4-4151-8802-4f18de6d7b76	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	108.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dd52af66-ce5e-4585-ae75-16800b9b7d42	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	109.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d4ee78b1-6113-408d-92dc-fa7b7907155f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	149.78	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ee148ce3-cb28-4eea-9178-332d0c6901c2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	178.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
42a2da6a-3c54-4ef1-b503-abd4c4a12551	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	145.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c326d2c5-4896-4165-8323-b2baed3356d9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	200.03	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c15c8ffa-2173-45a5-8438-f168f7428706	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	21.91	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bed764ee-ca9a-4db3-ab6b-534fb92740e9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	108.76	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dfc274a7-842d-439d-9d53-c76a3977d4a9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	96.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
61ea9599-4c17-4692-92c4-7ddc591b742d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	107.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a0a71cb3-f02b-495d-8133-bcf4509d41b1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	142.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a58a064b-d986-4fe8-9496-408fd9a74bbd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	83.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7aba45c3-6f0d-4c54-ac6f-377507058bd2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	172.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d6e0f854-8392-446b-bf5c-7e31593a68a8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	73.15	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
61a5a951-8b4b-4cd9-8cec-2dffb9025158	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	71.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
72da683a-7dce-435e-8564-09e933f5ba0a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	161.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1643b937-34d7-47f7-872c-b13cfbc86afa	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	105.93	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8405111a-e0dd-4285-9184-ec2471beb9d2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	155.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1adfc14b-935c-47cb-abc1-3aa128f3275a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	157.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3acf71e6-35b3-4013-821c-27c57648c0a9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	198.93	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
41af1ad4-ab82-46c8-9507-bca0e26723e0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	196.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fb044831-49df-481a-a861-0af091d76757	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	189.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
143b148c-cd4a-4e46-8d50-d61f9f4c2835	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	175.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0a6da96b-f001-4aea-ae3c-0ffc9554bfd2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	174.07	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dce91275-e00d-4b0f-8276-2cf8bca1d483	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	204.25	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d3e8d233-d659-48bf-b508-88654f4456e6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	37.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2dde3f0d-bbca-42e7-a39a-c18122798bc4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	54.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bcf46937-cf47-40be-a416-bfe0a5523cee	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	114.32	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6b21d51c-de82-463c-9270-2ae4867cb2d9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	189.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
29ce7a31-3ff7-4a5b-b7c2-f31290f7aa8a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	184.56	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bb12c07d-2f74-4d5c-ad63-9e081a22572d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	133.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cc464465-7b49-4405-8e6f-c9e3f7c3dc69	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	81.56	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f1ad5537-be27-4fd8-b6b7-f39b7ff13278	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	143.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1afdeb54-27db-4f67-9e99-b9f7311a65f7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	10.35	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4d0fcf77-73cb-4daf-a003-0b4902e29f97	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	99.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1dc38571-482f-4dea-a651-f0459d78cdca	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	111.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d6f5a54b-8e14-43a0-a2a3-5556498d830b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	125.55	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
38516bb5-3585-40b9-bfae-4522dca85da5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	243.03	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f18e6136-e33d-4d71-a965-7e5384029481	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	46.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
933d795f-3eca-4757-9fe2-addbaf10506b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	67.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
91526298-0b5d-46d9-953d-d220165c4dfa	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	177.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
36816ae2-8094-48cd-a720-999f984038bb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	14.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c15b6587-e163-4b51-b03a-91986acea98a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	201.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
35826da2-235f-450f-a727-813395e0787a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	136.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
accaf494-7c3f-4f93-96bb-256198632cc7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	155.30	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
aca14bec-7868-4098-b259-9990f923dc1a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	198.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ff20a0a4-6d81-40ae-8e44-ac8d28c17aac	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	80.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c5c5c618-b33d-4375-a872-0ba4fced0dd2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	19.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e80df973-2b1e-4e56-bd36-f7e6561ef1cf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	106.67	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6adcea04-a10a-4deb-bdd5-a7c8a63be6cc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	201.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7c428075-3100-47be-84f5-79310faeaecc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	160.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
139e5c95-92eb-47e7-8331-0727e3929acf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	114.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c965aa40-94ee-4a95-8c3a-a9f54d8e1b83	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	49.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6327b46b-c505-488d-9af8-b4e07f3aaaec	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	62.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5f8713c5-4a12-4bcf-9a54-04e81f8891bc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	153.39	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f458c05a-d808-4264-b30c-184165903fd7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	96.87	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8bb3ce90-de43-4db7-b1ce-73244a4abd29	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	12.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
07d2f56b-615c-48be-a249-189259e8052a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	196.55	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
516c760c-aa9c-4f4d-b324-d6a94eba0f3c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	57.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
64e594d6-aacf-4e79-b12c-446250519ee6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	168.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fa8d55ea-e8fc-4a67-ab7d-c3a5dbf062d3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	121.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
18ee1397-aed7-49c5-a0f0-30be46063b69	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	119.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a31f791e-bda3-4dbb-9d6c-9cc68aa02dc6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	276.89	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a18baa85-6c3c-477e-8baa-00f957633266	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	144.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
508923d7-8d95-4a15-9aac-e8c282109576	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	149.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
33f3df13-c751-4d16-81f4-9c1da9481ce5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	198.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6e08b51e-d867-4add-a181-e06f15c6f02a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	82.89	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a8988ad5-6ec5-4168-868d-606284d20c59	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	47.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bb8f83df-b244-4d09-a4a5-9be604cfd19e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	27.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bd89f426-3502-41f9-9d28-55708e611bc7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	188.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
927645e0-58ac-4361-8b53-555c3a424071	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	221.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b70087b9-1789-4c8f-ac16-efa8412e40fb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	271.23	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6664a2a2-fd60-4046-8bd0-57263cac8c31	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	147.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dbde865e-b45c-4843-a42d-803a8519524f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	71.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f0df54cc-8181-4f13-b2b1-8cde49c0986e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	114.39	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f8749b98-ca89-45f4-bb70-ddcd79a085a8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	138.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e8c6b522-6d05-4cf4-82d1-8ba2a9697f40	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	53.49	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
59128ed1-0e4b-46a7-838c-cc94859519f4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	120.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7e0c57d9-c2c5-436d-b447-eb7e79439372	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	90.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ed91480c-f6ae-4170-8438-7aec8131f2a2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	123.76	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b17c23d5-b919-416c-ab76-8447b1ee6901	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	159.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2fa63f1c-211a-48d6-b37b-17b577906e61	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	149.77	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
aebe01a4-90a1-42f3-b194-de503cc1c01b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	30.35	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e5ebfe03-f1d3-4094-ae23-45653b24b53c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	205.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
94c5c2b8-7666-4f0f-b944-0c64412bee75	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	189.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9fa4134a-46b0-447d-b6df-301ddb544ca9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	135.12	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e86b6520-4a1d-474f-ba58-c4dd42c7c793	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	124.78	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c06aa566-ab50-433f-b76c-697d753690b4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	93.91	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9ed69cb7-2600-494f-8324-f7281cc31dcf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	52.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
11effd28-06a5-44de-afba-b0926231a943	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	37.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
12d9042c-c92a-4d76-b42e-071f8ef348bc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	85.86	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
58546a50-51f6-440b-aea1-12317d6a9f50	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	165.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9f95097e-fe67-480e-b63d-e3efe80d70c5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	59.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e1739e99-86b5-4525-ba85-44cf361e1761	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	67.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2beb8800-87cf-4764-872d-e895fae05d96	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	100.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
785ada9c-bb24-4e07-928e-6f21343554ed	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	76.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dbeb0761-194f-4015-9563-5879f7354ea6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	82.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9fa5ea08-fcc7-4b16-a2b0-fe5e69cf3829	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	93.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
73e7cf8c-b884-48d0-b876-5d23a938e6f7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	78.73	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cc5d20b5-846f-47a4-bd55-01902a13e4c1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	54.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2fb35d73-a26b-4ff4-81f1-56bcda96aced	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	126.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cbc26c58-a97a-4f2a-8831-d46909f4222f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	47.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0e41fca2-50f1-4c11-9038-eb8e5510f881	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	72.74	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
201ca905-79ec-46e2-91b7-d5ad16ae121e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	74.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5ec30e08-da26-4cad-9f94-906cceee5624	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	70.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5d67ef8b-4012-45d1-a4ce-b0c8d0d4ef53	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	62.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1d271e45-ea3e-4cc6-a61b-dcd76c63ec68	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	94.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f49c93d1-861f-419a-9a4a-1b6911ae0288	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	138.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5c69042d-0655-4421-a532-ff8a0440c18e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	127.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1a32d39b-83a2-466c-b63c-08b923027649	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	173.41	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8c7c3138-a3c3-435b-84bc-4ce5bd09471f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	145.74	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
72a6e801-362b-4def-9205-834c19c8060a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	181.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
77ffa843-e69b-4973-bc40-1aa69e02d958	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	246.32	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
785f59e8-65d1-4db9-9680-e54d2d9f3ce9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	194.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2e10d746-5aaa-433c-b01c-f0c711d9b0bf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	39.17	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
54f3f6af-d087-4e8c-9307-9f876b8d2585	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	86.11	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2983d8e9-921e-4e64-ac15-0e54f0415c82	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	82.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b2f2ec34-152b-491f-9f99-4cc68701f096	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	88.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
91fdc0dc-5776-43fc-a20b-0be131700faf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	240.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
344bef18-b66b-49b1-a308-e750ca6dda1d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	120.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0a318416-aac9-4f8b-ae13-abfe3e6e05d4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	137.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
59610614-6e8b-480a-904b-d8df1b841b14	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	92.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
004f8fd3-0429-4918-beee-0c2b638fb8e9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	100.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e4b5b1ef-6a96-4681-a960-2d90c194c0f2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	154.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c4916f9f-f844-4037-99bc-f92d7d2e0e9e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	75.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d924c037-d938-43d9-bfe5-546550ec0a35	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	254.40	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7233d4e3-4dab-471c-8b5c-71cda89e78ef	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	62.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
855f61fa-3476-4c9c-8acf-9a60f057866a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	88.75	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a0dd4aa2-a18c-420e-89ac-6a9508e9e606	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	113.61	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
48b976be-368a-4840-85ee-cc79eddcf95b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	105.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c8bc1084-07e2-4514-8c45-4ccca42a6147	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	232.06	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
acafca1d-3010-405b-b5b4-0b1ba7093b21	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	111.30	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d85fb1db-fed1-4a8c-83de-164487338e4f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	97.27	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dacadd56-d6ad-4423-994b-5e45c3b26125	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	132.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4b46a60f-3332-4720-9750-62b06bddb8eb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	87.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
90dd7840-d615-4dff-9ed7-2d30d487c8a6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	35.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fce9aa3c-fdf0-40c2-bfec-06a2654ac34e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	43.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9f3db135-6098-4cd6-bc68-f6b396780f51	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	161.91	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4dcda910-d522-485d-8d47-d8305d96cdb5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	30.35	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
82526151-948c-456c-b873-55557f652e1a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	86.41	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bf3139a6-986c-4d0b-b634-b781831b3dc3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	114.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8661e7c2-1bf1-467e-aa63-63a48f6b8bab	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	18.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
444bf5f2-f0a3-4fdd-a574-1c107c8c75ce	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	136.66	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e3474a10-ead3-4093-9cb4-028ae0bb48d2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	145.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f7a8a32c-0b1e-4b28-96ea-418bbb35c037	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	62.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cc7aa352-fe1f-4b2e-9451-a260121d0e5a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	328.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
365142c8-0b5f-4c15-9568-6efc68bf8b3b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	91.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
33e7d559-cd1a-49c4-9d64-c6044b36d892	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	98.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
87414564-588d-447a-a234-b3462a4759f7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	61.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
85575b48-fb50-4e80-a5a6-85f8f3de49cf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	245.02	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b2d6c82e-a8a7-467f-bb7e-63ac91d161ad	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	171.66	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1f22b0c3-c64f-413d-8024-73999f786187	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	64.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f5f36a14-bfa5-43c3-b8a9-20a73de47083	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	127.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
03c06630-814b-463a-92bd-87662d923c1b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	84.97	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f5534c39-5c40-4f2f-83e6-de7ec6effb3f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	51.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b901d8de-09a8-4186-bd7b-1a91ad726828	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	96.34	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
37dde477-e2d6-4e54-b66c-dec5e43a6216	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	62.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
91a6d175-4759-42ea-b1e3-290cbdc5a2d7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	54.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
200e6ae5-0a35-42f6-913b-bc134776654e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	148.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9f0c4b13-a7b2-43e9-93e2-69f2284f915f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	34.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fc518724-d04c-4819-8434-8391c825317d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	91.29	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ff4e67f8-e31f-4a59-8302-02f6490310f5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	111.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9e7b1353-66d0-45e3-b3ae-c9cb9f8bd24f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	217.99	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6c879577-300f-4b2e-a89e-6f6a8a381d05	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	201.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6b9da4a1-bac4-442d-bb65-bea37786e021	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	150.93	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4d60e02c-390c-4a2f-9b86-be204d1a1efb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	151.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7af370a7-a058-4ce0-a3d8-760f162febe4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	165.25	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bc992b1a-d3a0-4cbb-b49f-c4bd23c009b8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	184.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a19252f1-da72-4cd9-8ceb-537ba59f0d58	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	14.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b852a94d-3ba8-4c38-b61f-c398dafeee66	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	153.15	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b73619e9-fc4b-46dc-8597-508b3d607ed8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	84.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4749bbba-8f0a-4e22-b9e0-d0bdb0a61509	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	11.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7db24315-db93-4144-ae9c-9a809c3790db	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	221.38	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d565941e-9a85-410b-891a-c2aca9e1b016	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	55.87	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c872f669-8ab5-455d-8726-78e391c15435	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	49.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7233fdfc-f69e-4a77-8ff3-b156e607a458	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	143.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b13f235b-5be5-40a7-9739-7e15f6d879af	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	178.81	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1b8d1d04-ca03-436e-8027-fcea93faa53e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	231.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6ef8cd0b-1df2-47e8-9a5e-bbc6a45c086f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	247.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6baecacb-eb21-4755-b24b-d1f6f2dd94d2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	185.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2d099782-da12-49e7-b1d0-b29b627e112a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	180.03	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1b389710-04b9-4756-b0e2-9a23c89d6359	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	193.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
812caf18-a781-41ef-ac70-04da995fd38b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	107.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
65a1bb2c-75b4-48db-8fae-cbe8038808b8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	44.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
78628b8d-ebdf-470f-8a42-d43a2696949e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	171.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a9bd835a-2ede-4f96-a43d-1500212a6fd1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	137.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8bda0160-8914-486c-97e0-cf573cab7cf7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	47.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d1d6af2e-8443-488e-a10a-44b9155f6fdf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	208.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
35aa81ca-a01c-4910-b752-5dbb8f6c5cdf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	44.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9fe68583-e68e-4730-9f4c-8fd11a38ed2a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	99.15	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d6a63cae-c375-4ffc-a4fa-cf54ec217b6e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	309.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
603d977c-a6bc-4b53-b928-4f333a6777b6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	331.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
77afee0d-2d41-4958-a32b-743f19543af8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	170.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
653a8581-6413-43c3-9367-3d4df9418eab	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	204.15	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0e81a492-af85-4203-9deb-7ecb4778cb7e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	151.89	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5bc41f69-6c06-4d2a-b2da-0861bc426662	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	124.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f8d66cf4-8911-4115-8c5a-ef841037ad78	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	160.44	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fadc8cac-9b20-427c-944e-253e24f4ed19	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	66.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9a49aa68-fc63-4fd3-a5db-27fe1c7cc81a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	119.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ca623a6f-5ede-4496-bac6-727fd91aab32	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	167.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4f0f7146-a213-443d-ab4e-2ad7f2d2eb03	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	248.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7c926317-e713-4c22-9446-777c0c2c947c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	176.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
65022266-2c27-4beb-a104-3e467a525b6f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	250.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
744a04bb-6f38-437e-a89b-39cd8b5f962b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	134.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3f6c72d3-cac4-4022-b4b3-774307719727	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	99.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b4632a54-c7ce-4729-85ab-62c131835268	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	321.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
263e868b-562c-4d6a-9955-9289c0c15130	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	51.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
88bee41b-e0b7-4fdf-9c07-6602888c7097	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	133.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e7336e58-86fc-4eff-ba27-79c17d9a69b2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	285.38	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
838d47ef-a0db-43db-b7f4-d9525c425989	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	98.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9b6a6615-edfe-4a27-85bc-daf8acbd1f7b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	95.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8cd20854-aa24-4f9d-8a5d-8904c047fc30	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	163.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6538d959-8ce1-46b2-9990-76b550fdd3ce	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	197.43	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4c405a8d-b98b-4c76-9ff3-ef610cc981e5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	272.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e41a7b68-36ba-4923-8fd8-13a90b0254b3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	156.23	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
48169c92-169e-4bb8-864a-86d13b900042	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	8.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2c660b58-215e-418a-b99e-8f58acbc7a78	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	31.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
61af7e60-8df2-426c-be06-f866e6ed262a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	89.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
214d634f-5c6a-4310-89cb-d8e876ae6e2d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	63.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
48dbccfa-d888-402b-b477-9c31e2dd73a1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	152.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
eb81b20e-79c8-450a-b001-da34b1c4a79c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	235.87	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cce2c09b-b2db-43b1-aa0f-27f99bc00e3e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	130.34	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
341fda27-f537-4361-8d5e-c8f4b305f4b4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	107.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ef5ccddd-ed26-4e3c-b558-c5023abf4e59	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	115.43	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e104c826-a01c-46d4-8377-44ba2c79641c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	49.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c9c72dd7-7e28-4230-8d01-e3001f5b3566	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	85.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
81afdab1-69fa-465b-87b4-3052379de083	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	87.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f63a99d5-a5ea-42af-be44-e49e6292fc03	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	240.39	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
68f60d2c-fd12-478b-80cf-7232eff2b77b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	77.21	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
14a4b2ea-0b28-4be7-a343-d9f853a7a947	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	102.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ae5fc031-12b6-4fe6-9b93-577caafc4c26	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	121.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d14600c6-42c9-40f2-b43e-7ec584e9b85e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	126.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
027ccbe5-a324-4a62-b09b-bb5cd10df84b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	46.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
91141b74-0513-4de7-95d4-6f7e3f7bfa33	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	22.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f45e2a8e-7e31-4506-be04-f756e729ed7f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	32.35	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cd13dd4d-e257-4c1b-a28b-592f28d2bacd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	294.29	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8493ed3b-24f8-4086-8895-f68e6cdec21f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	94.40	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a6e63af9-0001-4153-a046-6d47ce6b67d0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	90.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5d542225-e863-4b04-8b31-038d5b213200	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	104.87	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7b673281-aff2-4412-a0dd-3723412a886a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	55.94	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cc22032a-d9cd-43d9-817e-82f6bb1f3c7f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	83.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b983bdf8-4ee7-437d-aff7-f40333b919e5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	157.35	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
758f900a-2d71-4b3d-8c71-e3f67f7367b5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	9.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5caa22ea-c755-4381-abc7-80d72db51cc3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	162.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f4880d4a-9e32-477a-9864-f955574d53d3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	134.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f0fb4927-ef91-4846-8aed-b9402d00f034	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	16.38	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7007c848-cab2-4032-bcb5-10479d45f75f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	58.27	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d927c177-9948-4a70-a42c-e1311242a19e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	45.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
519a3224-edfe-43c2-9511-3a75ec730492	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	117.81	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c200ea82-3aab-4e57-9140-751e3c30a1fd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	167.12	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
77174641-0c1b-452f-a71d-2050810b6cdb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	297.49	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3a5a43ef-6aef-4a74-a960-e1cacbd6a165	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	187.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
989d0a56-8ece-427e-893d-375fd011dfa0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	74.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6abc80bf-1250-4992-8bb4-df188cd8fb2a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	299.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
256f9c18-2dd4-497e-a25c-f2e848948316	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	28.11	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
50bd0e09-24f7-4178-8fd5-e87ff0a08dba	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	71.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ded6f1bd-fdd4-4468-a204-cdadc1644de3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	88.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
52a309c0-472f-4a6c-b8de-a28550950b91	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	60.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d50cd0cc-b296-4cc9-b761-aeffaa5d9f47	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	123.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c3623ce9-ea76-4e28-b8fc-f8816f5f3ad8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	159.97	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
346df24d-f2b7-4e31-bbe3-cdea36a2370e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	82.39	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bad0c2aa-9964-491c-8591-6bab03b3d307	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	153.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9bd00443-0a3e-4542-9e2e-7a5acb088627	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	183.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
71dfc8c4-3539-4788-8280-58ccdf80f9f5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	101.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c35a205d-8313-4d52-a829-87c5b0e24b52	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	68.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b880c75d-0ae5-49be-8b10-43adc2661fe0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	228.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ab2d010d-3ddc-4eeb-8dd4-244a696014f8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	51.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dd5b10f5-38d3-4c2b-9b83-70ada0dfdeed	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	92.71	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
31903a44-bab3-48db-b721-f8dc87a95d01	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	154.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
47735ddc-0dc8-4a7d-8c1c-0563238a8fa9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	59.43	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
44c80533-929d-45ca-8a97-b562c26e0c71	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	79.09	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bc0cae1d-895f-4b96-896a-2297c655aeb3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	195.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2339d2a1-cc40-43b0-9b29-3d3553a3e891	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	122.76	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7561b5a2-dafa-4040-a269-0cf94a64aa82	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	16.38	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
87ddc01e-c133-4774-a55f-6520dd350ac0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	60.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
48dde4f0-57aa-4a79-a354-5eef33ab74be	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	53.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
45043563-f40b-4c9f-a96c-0b03920cb211	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	79.73	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
295e0d0d-150f-46c7-baba-4d037fc3da94	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	148.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bb77e096-7ede-4a8a-8798-4d125c100e88	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	89.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
13a181d2-ca19-40d5-8579-513a515c0029	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	31.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b7209538-3934-400c-9143-e9e7d6c85296	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	18.74	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dec0af83-af62-42e5-9ebd-895fc90f4101	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	41.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
59560717-a657-49b5-b501-d9aa3ff3ec51	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	111.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7aa6fc59-ac45-4119-8c1c-9344048e9953	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	87.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6bfe2447-12e1-4d99-90d0-6e0a9efae8a5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	143.34	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
78416ceb-459c-4d24-a9d0-2aec836fff2e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	26.93	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
952b9507-5a67-472f-b604-8fe86b26ea99	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	267.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6d9b2dcd-2639-4166-9a91-faa2dabe9849	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	162.49	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
32a6398b-32d0-4d54-b3e4-0280acc9c79e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	82.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2df2b787-d9aa-4873-bc4b-33e936c4b49f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	164.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3a7e017f-ce79-4a18-a86e-ee692c42c2d1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	56.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a8ec13ba-340b-46f6-ae8b-7ffbb8a5de6a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	106.86	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
db1575b8-4afd-4523-b5af-e940e2727bc1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	209.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1c518fe9-bed9-4036-9c98-e21e9e9d7e0d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	123.32	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4a7a9432-aa51-430a-9127-4a988fefe196	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	227.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
285a3163-0953-497a-aafb-57573786bbd2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	86.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6cfb3ad1-16a5-4c2f-81f9-4ef38bdcd7fa	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	164.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f3683f19-7052-44e5-bbd7-6576601bf5cc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	150.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
15e69b96-2a8e-446e-8be7-bf6b8f0d69fe	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	45.97	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a2774201-c2d3-4c7c-8d17-559bb6cbee19	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	224.73	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
730bac3d-7d1c-4b55-87c3-694a6d0a9734	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	31.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d504604a-72be-4da3-93e1-331d02f111be	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	239.57	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9bdf95bf-03cb-4408-b8a2-fe2321cc8955	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	157.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
69f5d667-1fce-412a-8f7c-abbe5f0a0380	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	348.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
858590d5-ce17-4c3a-8365-d283fa28542c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	237.03	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d906ec96-9d16-43ed-ac4d-7dd375bfac16	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	265.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
960efc6a-3dd2-4e8c-bffe-c113f928889b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	46.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a9aaf563-b41e-4921-a7b2-691676649aba	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	99.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3ebf8c52-603c-4bf2-9a52-09fde8f2fae0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	61.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0e635af7-fa1b-4a85-90c1-f17070236d65	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	121.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
90953f41-aa0b-4642-af45-c432abb6d6bc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	127.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9e674928-6f91-4fb6-8cd3-1019d8dc07b6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	137.45	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
be8b33b3-3359-4865-8bad-05fa8bd91040	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	191.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
790a6655-7194-423c-b7f6-e4977b69a2e6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	109.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
af1814d6-b892-431d-ac1f-2f432eab3672	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	64.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2ac7fc00-1f5e-4632-93fd-0de06d7c1d55	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	134.40	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f22cbdc2-2112-4425-b850-3545060cf81c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	74.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d41999b9-5ed9-4265-9c41-f6ac11f28998	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	220.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f8f4bb71-1ece-473a-ae45-449381cb68bc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	198.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a4acc925-8ce4-4e88-9657-9168b38683d7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	52.28	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
96b4dd91-5ef7-45ba-be9f-7bb80fb43773	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	204.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
cedacfce-ccf9-41e3-8cf0-0f4a4b372e6d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	9.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f7701bfe-5bfa-4ab5-83da-c3238a6ed29a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	162.77	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a9e1d432-ded3-4c8e-869d-4ccd32094d98	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	172.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d1d76ab6-6285-4aa8-aa69-df92a7f5166b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	56.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ad30f787-9a73-41fd-b124-6a1aebfda11a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	156.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c3202257-214e-4d3a-b704-61e970be82f6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	335.66	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
baf7ec11-de03-496a-b695-94a970d2d3ba	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	63.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
00ec46e5-9ce0-4407-ab63-a9a096e7f706	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	146.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9444571e-eb71-4ca4-9084-5d15554d3cf1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	323.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
443975b2-2199-4d1a-9d83-59edb6c88fa6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	116.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b0afe566-dd60-41ed-9ae1-4219cd051f34	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	114.83	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4480d124-7015-447a-85c2-9d4705d5a27e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	40.43	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
956a682c-2ca1-4228-8af9-415aa0245200	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	95.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
911075b2-d89b-48ae-b481-a161c562ed1c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	51.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
eca72b78-b207-4490-809c-3a8c676e5525	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	218.45	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
776956ce-b80b-4400-9cee-51be506da9c9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	64.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5b5aecf2-9079-4b3d-ba20-05ef52f36a78	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	20.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6a2d1cc6-99c9-4f6e-8820-11260d1068bf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	28.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ce549fcb-52f1-445e-b0f1-c648b9e91758	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	107.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
af247be4-bd55-4087-9706-cfd038d57b4a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	55.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7eb79055-9032-46a2-a72f-839223df4113	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	124.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
dcaf429f-66bc-46f7-99b4-226ac442b360	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	67.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a7d38e70-9b00-4e23-b6d1-0a8276edbe29	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	56.93	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
430ab126-fbce-41ab-8c2b-febaa31667e9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	55.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fbd51374-47d4-400e-ad4a-f6085f07e540	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	51.30	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
837f0ed8-f90e-4018-b8d0-f75b6d85c666	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	168.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
46ae3a81-e550-4fc7-80e0-1b72703ac046	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	35.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9c661a02-fe51-4046-b7b0-a82f491a858f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	164.47	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0256c3ef-2112-4e0b-8e59-a7c786b1ce86	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	236.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f91ff990-a691-471f-8042-33fe730316ee	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	200.29	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d108d89d-df8a-4ac1-83e1-e2341191e4d2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	288.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7ce6995b-3676-4097-ac72-b769a106737c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	175.94	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
420ff426-57f9-4e43-9325-216b95263c06	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	95.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
90b91093-880b-41ea-9a24-f83aba5e9f8f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	30.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
800c03b7-fdf5-4b25-aa80-139a387327cc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	86.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
98b5e6bb-cf5c-4c63-9a3d-b997edd4d39e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	114.99	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1adc4dbe-3021-42a1-ae26-b4353f7c87ff	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	344.77	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8a21fc00-a84d-4934-a166-f9c52fbf9a7c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	32.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9a08e78a-2854-44b0-8642-9c795d5e0160	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	47.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ae711746-f5c9-4c91-b5be-e391e9cc6c89	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	104.71	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c6ef7578-13b3-4454-9357-33d3a3421ca8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	78.57	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b4a023a5-8311-4677-ab40-a7aafaaf1e96	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	215.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
baa905b9-4d5f-409a-b045-cb09375d4ba7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	69.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
af43b7f9-c52c-489f-be7f-3556d14d44b0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	198.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fcf364e9-5e69-4a1a-afaf-bbfba14ddd6c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	262.18	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e9bf741b-e356-4441-83f2-086bb8cb80a8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	76.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ba6f660d-c3e0-498b-b9ba-b85491845eea	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	46.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5ebb9650-f2a3-4250-af75-e8a5f5e1dba4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	115.39	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c6321803-a26d-44fc-9395-0d34de43676d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	159.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b39268fb-f608-4783-b80d-1f715fb17eb3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	244.33	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9377b22a-92c6-4675-ae71-5b5e65345a31	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	38.62	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7b9ca835-f77f-4b7d-858f-065d52384acd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	106.47	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6d2a7de3-d076-4577-b89f-4b7449155129	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	181.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3f6adb83-eb45-4a3b-adf5-7e73d54adc24	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	207.94	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4c79870b-9f66-49e8-b727-08402277d796	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	269.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c8203054-2a79-4217-9ddd-78dd091ec1bd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	132.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
11d38443-fda6-42be-a207-ef0a45ad70be	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	103.84	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d11a9ff1-4e42-4ce0-9421-7776dcbdd1a2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	188.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c7ee0f65-4f69-4a7e-804a-1f702b4d2521	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	180.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b1419a70-31a8-46aa-b225-25a765e53f8b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	38.15	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3bc6dd55-b9ea-4dd0-9a30-079542d6d8eb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	220.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
308bcfc9-9e15-4767-8719-0c6983362044	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	69.23	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
732b56e8-8b03-4b17-b3a0-61e990538032	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	82.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
374bd850-d839-4c27-b9e8-ee9a3f72cda9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	54.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
423b7f53-c1b7-406b-b2bf-188fb63cc25c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	102.78	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d61cc827-4ffb-4ead-9872-76c34dc8d400	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	108.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
de8e7e1d-1661-4cc3-a691-785a2788c70d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	240.04	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
61fe448a-8ffc-4288-8af1-a66a018f6253	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	148.98	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a8130946-067b-46ae-958f-855c82395d31	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	70.55	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1339e152-e0ad-4ed8-a26f-7b74049677c0	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	177.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2da40bc7-66c7-4a50-9757-e020fd04233f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	106.77	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5768f7e1-10f9-44e4-bae3-969e790f858c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	129.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f3c475e7-8fe9-463b-900c-edda96c58dd4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	134.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6bd5f5f0-0439-422d-b1b3-cdb2500f39a7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	193.96	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
91203bc8-6fb9-4e01-9dd8-8654800994fc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	52.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
27d9920c-3702-481d-b487-9eea6debc3e2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	178.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
85f5e8c4-c991-42e4-b2ad-d75e9c07756d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	311.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a7d59742-7f50-4471-8ea5-83178402e532	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	66.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c904ffea-4f2b-4f97-b88a-842ea5504536	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	128.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
408c431b-d3cd-4df8-9e8b-cbc1a6f65524	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	60.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
748b8ab9-eef0-42b6-b9f6-5146fc312890	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	108.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ccfad263-dee6-45dc-87a6-2852fc81a70a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	62.43	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
025cbce4-59a4-4234-8d16-b140fe081bbf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	106.47	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
42bb08de-ecbe-4d57-aa45-e4674f62fb9f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	90.36	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
bdb0924b-95be-4e7d-ae0f-3d8e5f3dd341	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	49.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1856970d-1219-4988-89ad-75f53fea2b9a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	198.64	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
69249160-ee9a-4a46-af5a-ddd22249887d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	200.42	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
844e83ea-e851-4c60-97b5-e47c995b288f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	67.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c84aac92-cbd0-4891-afe7-c2d7b3389c73	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	12.14	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
530e3b6e-83a9-4b9c-b672-118eb36ab2b4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	59.25	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
fff96c9f-6304-4684-afdc-24f9fb79f5df	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	7.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
4e8a3d1f-3489-4f5c-af2c-6f51c07341e6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	50.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1e99ed0c-9f14-49f0-abfd-523f5bfdd76e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	191.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8b02889f-69eb-4711-9264-df89b26f67e1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	137.89	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a1c1fd9c-b051-4f8b-8328-ee38b3f52280	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	142.40	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ba55550c-ef40-4cb0-a6a8-a9915bc2b447	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	60.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2a6f71f6-716c-4a01-a19b-0fa98a18b222	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	170.92	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2d051e98-2389-4ab1-a628-93bf5ec9f2c3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	63.16	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e2e82c3b-8e64-4e76-96e8-d563e0380e58	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	160.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0b207123-e784-4be6-9f5e-0abcf15af13a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	138.63	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3efa52b3-9e0f-47f8-80cb-1c3f096088f2	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	154.73	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ed96bbe9-7e20-41b4-bd27-5489e2a8f5d4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	153.23	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5f9c0032-06b5-4331-9671-b41cdbcda8a7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	44.12	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f229222c-0878-47ea-bab5-ced6b3717a48	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	90.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ff86b2ac-804c-488f-bd66-a46efae54d27	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	117.60	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ccb60341-fa59-44bc-a85c-46fa9d1c1f53	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	204.93	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a4a7eb0b-d59a-40bc-906e-e861ff6d675b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	26.93	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
aec38ac4-213f-4ed3-affd-1b138aa8ad08	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	33.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9adef5d1-e124-43e4-94c2-e3c903e5b0df	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	32.76	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a0555455-7454-46d2-b80b-a2991ebd653b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	63.59	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c0ef7a9c-1a5f-4654-b898-83e64b14b273	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	130.15	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5ab39d0e-f629-4ac6-8a3d-7b01edb7f87f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	172.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
74eba45e-0a65-4e56-9185-c37d47f39713	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	68.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b300059d-f81d-4370-bc96-f7d556ea0b0c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	37.05	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
265f10ac-9483-4a6b-a553-e485232255b4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	189.46	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
25294912-4c23-46d2-af5f-35fc7e92ab6a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	233.20	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
18548e01-c6ce-4319-a5bc-b92bc7660286	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	226.56	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a9ab15af-8535-4511-a3ef-ff5de115f343	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	209.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
90407b21-0a98-49aa-9517-f766d41bd954	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	218.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
471a7a4a-811b-408c-b165-8bb9d97e9333	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	99.90	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a12801b2-fe11-4f3c-9896-c8daffedb990	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	73.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
11f58ffb-d5e2-4c50-8dbd-0f8cdb47954c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	117.75	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
260f3888-a093-4b45-8859-a9dfcea45a3a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	286.43	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ffcab0cf-02b4-42ee-adb1-7d5df7c04efb	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	313.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e2e87f75-e621-491a-b819-ed4493e15cd5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	68.19	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6d28569a-b338-4225-98fd-57908ef5b29b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	53.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
88d8cdf7-8a91-494d-8f36-db765cba34aa	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	113.41	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
08139a8a-6100-4041-a468-6db30403bb5e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	90.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9ea600ef-9d68-422f-bd3b-fc110b346981	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	232.27	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9debfcaa-7f57-47c0-b3f6-b00efb02dc5d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	131.45	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6dcf74ce-fa7c-4e87-bfe1-e170e230b3ab	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	33.51	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
2b96e903-7f52-4636-a975-bff401c74c44	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	240.74	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
000b7502-6eea-422f-94d7-6313075dae13	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	155.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
6e3cea2a-5691-408e-a0cb-191616d8529d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	312.82	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c6da8964-cf9c-432a-a5b2-a23d4676975c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	68.21	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a81c37e5-8d58-43db-8a2a-4c7728d19328	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	251.56	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f549700d-fd1c-42fd-9e6a-817dcb43fffc	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	162.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
41ab8446-999e-4d57-95a6-a80b272142ab	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	117.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3854802b-a1d0-48eb-b95e-88481ebe450a	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	48.34	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b4516995-d551-438f-9f3f-855692d8f068	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	28.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
aa6cd53a-f9fe-4798-8398-16d9c9145fc8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	21.91	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
314fe9ef-b696-4354-9f6f-4b423ed90f11	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	105.58	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9b5c1cfc-f93d-4c98-90c6-8677fefc0365	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	195.65	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e521b981-c8b4-4317-ad69-60fe5a09e6de	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	83.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
18abcf04-950e-4943-8ad7-c24d2a243174	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	76.32	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
092640c8-abd0-43ab-8683-890f7e70ecdd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	12.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
47e6bbf1-6b34-4e85-8925-9b5e567fc8f4	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	130.76	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5a4ec837-021d-4179-95fe-b5d4c51b11c7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	127.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e951189a-430f-4d8d-bcb8-43145128d68b	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	142.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
96ab7248-cd91-463d-9b08-945700f7df76	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	113.70	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
189489d9-0049-4f03-84f8-ddad83c1d032	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	111.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e9143438-ba84-4c6a-85f7-5039920e7b5f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	22.02	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
feb8e6a4-c66a-4cb4-9cd5-997d5883a603	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	433.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f747ae81-5d3f-402c-8f25-bdc54eaa626e	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	192.47	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
72fc897e-e05c-4522-99cc-1c493d1a1301	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	202.72	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
03d5b43d-13ac-4bb0-a643-081008d27809	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	27.91	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3518e0b9-229e-4c24-80bc-aa1f8f4428ec	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	143.10	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e6e17fca-d70b-47dd-ac00-919b1d5aa42c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	197.85	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c650d6a9-606e-4205-8cf7-df2d042ff88f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	156.06	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f4861aed-3b87-4f58-bf7d-98d7b86ef078	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	119.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d55de0b2-f528-4a25-98c7-dae44e1ac5b1	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	97.00	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1df04230-0e18-4a30-bace-e09e4b25b642	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	47.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d2656de6-f33e-4dd0-8301-6a15edb3445c	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	79.17	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f0927e44-ab48-414a-8d49-35a79b90c033	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	111.08	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0d9ed7a3-d5cc-4071-aad8-f1d5a5d8ea01	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	198.78	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
42adc060-24be-43f2-b1ce-1c67f25df7e6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	153.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
f4de5f3f-07b3-4c35-96f7-7ac385c475b9	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	209.94	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
349d7c20-bf2f-41d4-ba23-fce052efc0f5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	70.81	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3e03695e-492b-4125-bc9e-ffaeb875c595	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	96.68	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
d8a28b2c-d6e1-4337-a467-cc4033508a78	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	120.38	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9ab2e0be-7416-45f6-95fe-420d6f467d02	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	122.30	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
9d86fea3-879e-4f7b-931b-8a7bf33b08a5	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	244.22	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
69d72f04-7646-4587-94eb-1bd5d35920d8	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	18.75	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
817d19b9-5383-423a-9852-6adbbfdf3d75	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	261.91	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
52b5abaa-1e6f-49a0-bf75-9d131d335d29	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	141.26	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1af587b5-f580-4940-9c75-b90ce23870c7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	219.07	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
0cbb5b59-8f6e-49b0-959c-182b4b61cc89	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	46.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e50f46d7-ce46-44c8-9e7f-36a2d3fcb092	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	18.54	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
a4308cfe-801e-48e4-b987-0baa79548f52	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	CANCELLED	90.47	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7ee18102-0483-4786-a219-0bae86c50043	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	CANCELLED	193.25	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
61d00538-bf48-4e5f-857a-3306f66377b7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	132.23	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
ef9303c0-315a-43e9-a6a2-6b1901a70a77	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	199.24	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5fc6c03f-86bf-4a9a-a969-06d9ee1d55c6	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	73.48	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c4d1a3e4-42f2-40ea-9b4d-4701ac86eb52	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	101.89	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
1f9fa07c-7152-4a66-b055-4902c535438f	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	184.50	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
7b7f7a99-10c9-45cc-96ba-10b55cb17e78	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	167.01	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
8c7bbe12-5e34-4bc6-99b9-7aea5fad3845	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	96.87	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
88a2d5db-9d4f-4ec8-a0c9-1716881a2b31	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	BILLED	251.95	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
e99c6c2c-8ea1-419f-acae-701a6e9745d7	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	83.37	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
5e577719-4db6-49ea-bb62-03ffbe84021d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	141.38	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
b0c6c50f-be7c-4412-8e92-90bd9d833b12	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	IN_PROGRESS	72.80	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3d346b6b-4a74-4739-9e57-942ae8463ebf	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	85.88	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
17f4f2be-13f1-472c-8acb-96edb2177181	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	106.31	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
71aab50c-4744-4629-8724-ac87424e7ddd	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	SERVED	120.13	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
59afd7e2-001e-4ccc-882e-1e33a44afa82	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	4571087b-1318-4c4e-ae93-ee0c108e0daf	SERVED	163.40	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
c54251e6-9238-439d-aa4c-f861ab1e911d	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	BILLED	167.52	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
3bec968f-fe38-47d1-80fd-ca49f40c02f3	946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	\N	IN_PROGRESS	89.79	2026-08-19 23:05:12.545912+00	2026-08-19 23:05:12.749912+00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.payments (id, order_id, amount, payment_method, status, created, modified) FROM stdin;
64ab7c33-1a04-4a92-a32b-82e7538d66f1	ebf8a450-d443-4b97-ab02-f0894f0a4c10	1.00	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ec66b09f-7b0d-4e7b-8419-6447cf94033e	1ffe052d-fad6-434e-a1c7-201855cdea44	1.00	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c04dd3ab-592d-446a-be42-fe37f3f8505c	86b5fe5d-bb7b-4f22-bbfc-d6fc13d64438	1.00	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
10d6c8fb-8083-4eb6-94f0-7d5d4d8bfb1d	1bedc78d-b431-4910-b505-88d1db20d94f	1.00	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8a905334-086f-4980-aaf2-5121b5546595	f4239948-263b-4309-8859-1465580b66ec	1.00	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
48a57911-c6aa-45ea-8d09-f44607cba563	a3cb9efd-d6b6-4857-95ab-b249764b66fc	1.00	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
021a5642-47a6-4fe5-8a8a-601177ed1a0c	b1ce44cf-9e59-45ee-a46f-a30ac38adff4	1.00	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
00748a3c-01c4-4b73-9034-045903bcbd04	2f20c3ee-75cb-4e04-b144-67b6b2e6807c	1.00	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
80b6f5ea-6cf2-4c5e-9266-a4d8db4004bc	d100a439-74bd-46ca-83f3-b92570e31f1c	1.00	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5722e789-d2af-44c5-be16-92af42c229ec	b013054a-042c-4cec-9c95-b8ddff8b4940	1.00	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5effc2b0-4ee4-4e58-ab2a-330f62bccc3c	477610bd-b58a-4b4c-a7e0-71a5897a0a33	1.00	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bc0de9ba-b18a-4936-918c-31a363d5c59b	b5511754-2e13-4d00-b75b-4a9e6f129d86	1.00	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d7f1a6f6-b165-4c0f-9a2e-3ff86f61d4e6	e3ca877a-6710-4049-93e4-57ce4b390796	1.00	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c4ee3f72-8646-4df2-a7e3-8099c7269539	886e41c0-f6d3-4138-86b0-502bf77b8d38	1.00	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bb708d74-f37d-4d16-b73c-ac9eb8ecc24e	aa8d2619-249c-4724-878e-7acff61d3b18	51.08	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f40e7789-b350-442a-ad06-8593a2b61c9b	22295dfb-2523-4285-89b7-ee1b31ac46f6	141.33	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9981a1a2-f0f8-4f56-9ada-1fe94aa56126	5e86351d-26d9-4fe7-b63a-fd5c94b19160	142.02	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d3aa4f3b-5ffc-4e7a-a40c-0a7bceb9a12d	61dd598b-a1de-400e-be75-fa2f2e68d337	64.44	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
922a8a7e-eace-420d-9571-a9b409b9697d	ad6965f6-e833-49ba-a3d2-c136f47fc0ae	142.05	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f1564d7f-0061-4663-acf4-991b31540565	c17985cc-edfa-42a0-8019-4578916a0ed5	126.11	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d510b5fa-d55f-48b4-8cf2-e04d82d085da	f5db4495-46be-4cd6-817f-05d538a758f2	128.90	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1aca7230-adf4-4556-b9ba-48e124e42dad	d4685600-2d80-4d01-9583-6db026cf1988	92.50	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ade11228-1033-4b22-80a6-9a523fc8addd	713fb165-3791-4111-a736-2215747f3bc8	31.58	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
da2fe360-628a-4441-8745-50012d7ad837	ba96e665-f89b-429d-a49d-c431095f042e	130.61	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e5057bc2-0413-4791-9d3f-d446cfc781b9	e7c277d5-c563-4ba4-a983-f306e510eda1	327.56	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
93a7c414-d56d-4480-be64-e62baaa406a7	b6b45b42-12bc-415e-9efe-ba9357190f5e	108.91	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9cef50c3-033e-423d-aea7-57a09e12eec0	1dd24097-9e1c-47da-b95a-18fe766f62a9	58.97	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3a0375d8-122f-4964-a8ac-5afb24bbfdcb	d758abc3-9c6a-4e42-bdd0-76cad50aecf4	233.71	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9cd3e58d-b371-4ed1-ab92-f4d9bb9d9a2c	16d4978c-02bb-461f-b5ec-82662df34681	193.17	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2fec76ab-602c-4d6a-b84d-486f48849a59	6795ef74-6ddd-4cdd-b380-b0f7867b63df	152.90	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8c287c6f-838d-4359-ba3a-375deb7fce73	1db271a8-0d1f-4f36-917a-8206e0bb29bc	28.11	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
76f6f54f-f43a-46c7-8cac-ebab13fd88df	a2a88528-9022-4258-ba7a-ac37ff66bf2b	127.00	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d28f6176-6e97-4270-80ad-6322aa60deb8	aad26943-c21b-4819-9356-cb0a2bbeaa0c	128.29	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fd5c73ca-9462-435e-b19e-41b6a8bd1b74	9a4b4a1f-4363-4606-9f45-e1d4f1f20148	28.11	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d023d261-2eeb-4775-a4f2-f3d0591dd04c	8c04ef29-f905-428d-a88b-6db52e52353e	163.56	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b02f7b25-705a-4481-8029-f84a4914a158	b395778c-d57d-4c6a-80ea-a3caa387b534	256.01	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
95a5be50-42fb-472c-a91e-21473d444d24	89856409-ee57-413f-9d24-c02239a40db3	52.20	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
07f77c94-afdb-432d-8f24-08994f92a6af	9063fe90-e5d5-4ea4-bc3d-2bcf09f17d08	141.12	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
75e6871a-5021-4d34-b662-6c0fc4bf53f0	2bfc65ed-0a42-4c0c-978a-09e794342726	103.68	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
08c089ba-9d60-461b-8002-5e978f2975e4	044dce02-86ab-4d8c-bd8a-d505891ea5da	63.28	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e6a51b19-8a07-4ef1-95b5-6d0752ee0d43	f2b436e8-ee0f-4702-bd35-b758c569c219	79.86	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2ab8dba2-667b-4006-862f-b99325da7249	dbf7d621-bf6f-469c-8464-c8e00cc9770e	136.88	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
488584ac-2db2-4abd-a862-215031dc5029	d3a0007b-3d21-47ee-a0da-c293addfe4cf	164.53	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
960c48c4-1bb3-4e23-ab6b-12017b95f3b7	8ac7d68c-2fde-4ee7-92ff-6601d0d806b2	113.16	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
794eef5d-da25-468d-94dd-d627194681c2	9001cb35-5253-42ad-86a8-2cabc01e3742	157.44	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f7f0b529-0407-4260-8d9d-a12677cf7023	b4cc24f0-68e7-43ed-a202-b6159ff1b284	172.00	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8a504936-62d7-47fb-9ab0-ff2083b2710f	ad436bf5-e68d-4804-a47d-5c633a29d5d8	106.86	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ccaffed0-fce1-4880-bcee-1122e3abeef4	6f7981b1-88e4-466b-aced-d3f9a1f68fe6	263.10	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
72a81728-b89f-4612-8233-3db90044ae52	191b9363-66dc-4b10-bd00-33be3db58f6f	127.90	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7b6971d5-693f-4d9a-881d-ffe7b6c842b7	7be1e598-4984-4cb4-a9b8-a663201bb86f	174.10	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5b7f6ab7-a738-4f05-aef9-f2d3eada3963	bf7cabde-accd-40d5-b7d6-a58fd4e541af	210.98	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4e1826e0-45a5-46c2-9979-41fbaabeebc5	098f7f55-55a6-4dd6-a4d8-a3b56a67b538	128.84	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3f3428f3-3bd3-447a-8706-ae906bf1e392	a42701e9-480f-4e59-ba8c-bb4c728c1aad	71.99	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
50d54624-848d-445c-a73f-695ab5bd3115	0affa59c-f4d9-4b6b-98ac-924cf67b8943	79.84	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2cce7105-42b9-4e66-8b42-570355e9b290	26794317-eb6c-44e8-b3d8-2fc66d66092c	126.99	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8d2eca71-ae8f-4363-863a-0cd03044ca30	0425fb9b-aef7-4940-a12c-1ca49264c791	75.80	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d8aeb1ac-b052-4c04-9f92-5d966e94abac	c5511bd1-c7e6-4e11-96c0-a4647fc0b185	278.99	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
43037d5a-0d3f-45cd-8303-1dfe2d1d9d94	858e147d-3c40-4bcd-a1c6-d2945086db0d	208.70	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b17da3ed-a5cf-4acf-808a-a9f41c9f6c17	52afba9d-c3db-4025-b708-b4486c8f9c10	111.84	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
18371fac-8417-4ecc-b896-1c2d6aaa1ff5	b2fa38a2-f5bf-4541-ad23-b474ef6caf62	164.53	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3b558e29-9a87-45d6-838a-1dfbbe86354f	424ae421-026a-44b6-ad72-b3cfcf97c3b6	67.88	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8106535d-d850-4514-8586-0e5f2987b6b9	28810d2f-06da-40fa-b5f1-8a14a0c9c8aa	152.23	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
56bb1a90-aac3-4612-b338-772cba267b78	608d81a0-84b4-4646-ac0f-011a5a71319e	187.25	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3643ca8a-0440-4927-a93b-cb9b8836f1fa	49b006f9-4539-405f-9f94-09e38a739005	117.87	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3626ed96-f208-45a8-b018-59a193961f5c	5a481a43-6837-41b5-b209-1557dca73418	145.18	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
091f5c21-df03-445d-9035-b5e86ce97b31	916b6554-61c4-4a49-958f-26f268aeacd6	46.85	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
430e77ab-f998-4b60-8f48-5466870c96d6	479cb726-fc8d-497e-a7d1-f7dc8f642509	165.77	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3b9a0e32-f6e3-4abd-9193-e73785b7f502	891c1ad3-1eb8-48d8-b714-5691dde76c3a	150.60	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5bff1580-3e86-445a-a30a-b7b78ff6e627	20175126-96dc-42e1-b7cd-0c1e5080292c	83.48	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e0df1712-a717-49a2-b46a-2ff4e490a7aa	8f8f2564-0a4e-4e52-bb58-14cadde1d28b	95.54	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6ff0c551-8291-495f-9cdc-9b857ba8d6f8	c439872c-07cf-45a0-86ee-44bd81586b43	146.88	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
760ca24f-7173-47b0-9a9d-584991b109df	d0538513-a0f4-46dc-9212-1b2835f08f64	217.48	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
beb0f195-f622-47be-a544-61bffe06b862	636858c1-9f81-4b28-ba16-58f953d8695f	11.01	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5a650c37-66e1-4d02-8fe0-307e3a730fe6	7be28eab-46e7-45e5-a6c1-1bb5b5a0b16f	110.09	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1d91dd8c-3a6f-4e15-93ef-358948bc3687	864a2bab-88c0-418b-a0d1-872a3931fbe4	215.61	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
122637d2-9f0f-4a87-8e10-cd9110330f30	05b62cdd-d2cd-40ed-9a9a-8ba5da910e49	110.27	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b580917b-8b20-4f2d-92d6-e6e9a8177f0f	1c0b4668-5fa0-4548-88d7-e0d9d8a3dbd0	74.17	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bfc4a23c-6c5b-4c0b-affa-a13c39db22cc	a0a2d50b-3141-4dd8-89b2-f80df5a7f9fc	104.46	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9c3af0bd-aff4-452e-9a40-e8f4a95b674d	0386cbff-6b94-46c5-bda7-1cf5ae1eda6e	250.45	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
300f9664-f894-42a9-953c-f24950f36986	73f0fe3c-a749-49da-8464-91dda826c443	113.10	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3709f8fc-0b5b-4e0e-acf0-e2ecf8c411df	af640f9e-e729-4b4a-94f4-63ca562339c2	39.54	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3f5a4e4d-efa8-4fa2-a58f-407f15b7bd45	26debe82-8a6f-47c2-972e-25a4faddd330	290.40	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
25ab4bf4-1b6c-4648-99bc-9abe2c5e88c4	f8864236-8738-4f25-b825-b503f68690e5	190.39	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b7d72a39-285e-4ca1-827f-a5d3e512e0b9	c24fb979-58c0-4087-8a4b-d275a361204e	300.55	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
19693f4e-135c-4447-b7a0-cf355c1eca07	c81f38af-435e-42b5-b40f-b96e1aa0ab60	151.31	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ea61d286-46b8-497c-9839-db3659166fac	d3e36229-c4c5-41f6-9905-240dc1bbbb5f	114.07	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c7fd9fdd-11de-45f1-9530-516abd1948f4	fa5efd46-4f8f-4f67-8575-004cc3c62124	77.86	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
634a6011-2c1c-4044-961a-1cf87f97436a	e7c83865-bc11-41f1-b25d-2f6a49631a83	165.41	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
362cdd1e-b714-4909-aff5-0c3b4f839f9a	c594f079-7f51-4ed3-a8bb-e6acd8a18c84	228.50	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
58289c53-b9ee-4bc8-849b-acbe334d049d	ee12d632-0fff-44c4-adb1-7234b09bed40	175.46	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bee535bc-89c2-4f23-8211-c0d7b1a7e113	47d96cbc-0687-4fe8-b469-ca8a6ba29a47	35.59	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
231ff79b-55d3-46bb-9f12-7d8da212c790	a2ee1fec-2eab-46bd-9095-236b911eea97	32.22	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e0066bd5-f68d-4358-970c-2d20dc4c5e62	8a5a95a0-5c10-4942-88ab-60f702a5991c	37.48	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bdc6e9aa-1b0b-44da-8644-b586df41bfe9	e51f954e-9aa2-4b63-b18a-38db1d5edc60	32.22	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f3fdd4a6-4c82-4f37-b496-47823e7c3b8d	fbc9e9a6-3f15-4094-8ef3-92f7e1591362	112.48	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8f7701c2-eae3-4847-a410-d53d59d63977	39fbd663-2bf1-441d-adcb-3d4744d75bc0	53.37	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
76ab070e-cf78-4151-a4a3-c38a85281333	324f609d-0b11-4790-9291-ee70878d97f7	65.75	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
79a303d2-7537-4544-aa41-b240649edb53	74098f06-1217-4d94-a61f-a8329d6c6603	168.73	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cc6192ff-e614-47cc-9f70-1b6d4cba24b6	cc995690-eaad-4fde-92a3-e8350ca766ef	33.09	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1b6cd75c-384b-4670-a54b-fb024840ec0b	5b689d60-36ee-40a5-abc2-6c25dedb38b9	101.07	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2f9d2c05-28c2-49e9-a0cf-07ba0579c3bb	044e2d98-a9f8-4655-a344-2ff307bba8d4	39.60	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
57689e19-edcc-4981-99c1-1262c095ae8f	961d6395-fd19-40b7-86da-07718ac797ff	41.64	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0c5d2a87-dfa2-4c51-b18c-4f5c008f3536	e94e7ab6-f09c-414b-a82c-ecc76c9d816a	85.14	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
397ac06e-e4fb-480f-aa51-ce5202367a79	4b3e0a22-eff8-4b14-b935-b0a68f7d2e7b	49.21	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
67418519-2e9d-4413-8015-e27708f0346a	01801415-1b5a-44d3-b3c5-dde11b06547d	110.15	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
faa741c5-49a4-4eaa-b387-f64b7665926b	4e6a35de-940c-4d97-b7f4-482bfa5df28c	54.66	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
dd569448-4d70-49d6-8d74-ac234bff0687	9d6e1f5f-8941-41cf-bc38-26ccec9dccdd	272.95	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
eece5ab8-ac27-43d2-b667-7d9240614dec	244289f8-4fb7-49e0-a575-c71ff2cc35d1	183.70	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b4e00fd8-d078-47a5-8ba0-7fabb4b318a5	5314c407-ab54-4e6b-ae82-c1b08adaec67	64.64	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d4262250-db9c-4eae-a952-ef32139cb2ff	17d942eb-9314-4633-a9af-979492ce49c4	41.02	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5413b836-b495-4d69-bf05-f5a34ca569bb	dd704203-4544-4ac0-a3fa-3d8426cff0e4	171.60	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
68fa37e6-761f-476c-b71d-50de78781b08	cc966c0f-8d79-485a-8ffc-20d9c09f4680	68.08	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
792d3968-147e-4749-8306-448eb400e4b1	c4c6c287-42f6-4a0a-82c6-234a088143fd	62.68	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1018fbe8-1c68-4173-aa90-1902b6ac4710	b57530be-367b-43f8-8680-db9701db135f	86.00	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b41a3124-a21f-4824-9244-199785615cba	a94b9132-5bf7-4ccf-b0d6-f446b1960831	85.05	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b86a79a2-ac58-4e94-84b8-7bdbcc30f65e	3c9c570c-0f48-43cb-b8a4-49befd2d28c7	45.26	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fb755ea1-f6e0-4d63-9a6e-fc2eb73e604e	36c3d31b-f011-4d7a-adbf-d0458c9103f2	63.72	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e515b129-d75b-44cb-8f31-0bf81058cf29	3875b474-0f31-4332-b99f-9b565b00d461	76.61	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4837965d-6a8a-4b36-a7ea-fe0953264749	117f009c-8735-4c95-960f-439f77647cae	316.18	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c9929fb0-7353-4fd0-8058-cf386137e7d7	60c35908-d719-4ebe-a49d-68faa88b4321	97.26	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4f86e88a-a7ef-4244-b229-aaa84d17d9c8	575722ca-0f8a-4f47-93f6-9eb1af9d0b84	161.94	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0e36092e-2f14-458e-a269-7aa9607f5753	515e49d7-9df9-44d4-86cc-6454f833f834	115.42	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3caed8ea-3181-4ca7-9006-d69a9937cb2a	33e2d368-d23a-40b5-9010-c36e82235107	16.97	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2162d711-9a23-42ae-9c4d-cf31176041c9	88354dec-632d-407f-80a4-9fc65bfbc7fc	74.26	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7b85fc88-759d-4a5a-8a79-8b9f44527701	c1c57056-949c-45ea-b328-d6d1a4be913b	167.98	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9cc551a1-cfea-455c-921b-48e6a2c20046	8fda662f-5bc3-48af-8b6c-454d54c1c13b	47.37	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
93b154b4-e252-4b7f-bb88-d4aaea907a53	d9b0d672-286f-4985-9ba8-021202fa2b20	97.37	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
eaa63178-42e9-43b0-bebc-e4ba31b1d56e	0a4c031e-e8ba-41fd-8e82-d1fc1a7e8eae	68.46	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c89e40a6-419c-41f6-a665-052eae2e426b	3a83046a-5888-44d2-a476-edba61d2f61a	161.47	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a9a080a3-77bc-4ffe-9e0a-c8c3a88eb5eb	cf9070ce-6a09-4a39-a08e-a228b998164d	179.60	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e1cac8c2-7f10-4f6a-9152-de7583cdb57b	3b9ce712-605d-40fe-a165-ff7579e6e4f0	121.11	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1babd05a-b038-4455-87d5-b1c57aa9aabb	1cae5f9e-29bf-4bbf-90e0-7020b2a39c97	42.00	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6f758eeb-eaf4-40c9-81e6-bf7984f687d8	17778224-4da1-459d-b96b-0b9005435909	211.57	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b7fd983d-49da-4ab1-aa16-aab37aa244c5	cdd5db0a-b50a-4d9e-acff-14f165ca987c	157.68	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6394c476-f25b-4ccb-a9ef-77b8ba5e7c37	73c2b60d-2408-4d5f-96c9-d5ca5f378304	43.00	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
caccc28b-e762-4911-83be-2ea28260597f	bbc19f4c-bf5a-4ef2-9733-c7f55ef0ffa2	31.58	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9c4d6f6a-4535-4931-88a2-efb400dadc62	2a544346-4e45-417f-9575-e9302c591522	85.42	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7dc99508-cba2-47bc-a2ef-50248c11cd2d	962057bc-e3dc-4b0c-a15c-6235bd603203	44.12	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e8b6e404-ffc3-4430-a579-e2b2e5a56efb	a453ebe8-695f-4130-b3c8-d4795f1c689b	95.25	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
32c7d642-7112-42dd-aed1-f8ec3a692695	4c5efe4d-5666-47ab-96d3-1a564f2d36ba	123.02	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
53f6f4d4-da99-4372-be26-33c6bc0ab2d6	50b235f7-a4a7-4e19-8aa4-b394b4df928f	134.52	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
eaa8c6b6-8be2-428f-b808-9223f4824854	ce413913-153d-40ed-a54c-6f77fd2a25a3	45.47	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c5467241-4c37-4014-9669-d73a30744144	f7e8e12c-67ba-4bf6-b5b3-83e90d967caf	275.64	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8331932f-6790-49d5-981b-a5f4b68999a8	a59a2938-29a1-447d-801e-f6b12e3300f1	47.83	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8cbf3557-30bc-4434-a835-af85e1646839	b03a3bf9-ba71-4550-b1f9-edc9e8c38364	102.77	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
393ca956-22f6-4571-aa16-cf54be5ee14e	c0abef73-527c-4744-9760-e21c71b6691b	161.08	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
85161caf-5f95-40df-93d0-d627f8033f41	e0582ba8-cc93-4a3b-a2cc-1279952dc75e	26.94	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
999212e9-1daa-4082-a49f-caf400d6bc49	935b9b31-2c9a-4dc3-83c5-2453f3020916	55.70	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3f7464a2-98fb-4f50-b247-8cb48619f1b9	b26c8b5d-0a94-4360-beec-c220e85e3f1a	47.37	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4500d1ea-d6da-4e1a-ba4b-e7ea7c1d406e	8c856c4a-1584-460b-9686-96270f88b8ef	117.78	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
33ea330e-0377-460e-ae73-04c62a4a2fe3	0150fe46-3064-46ec-be84-b5efd8d98486	53.68	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
45e55ef3-b02c-43a9-b5fd-974e077c7caa	115eef4f-8ef7-40f6-8c11-96bf8797549c	62.80	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
41543300-a351-4294-a5a6-7aeab28fbb0d	66a42d4b-4e30-40a5-9ca4-88008dc80099	22.89	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c9fbfc59-4682-4064-be63-321a4b42717f	995b8bba-6f52-4b02-be56-16b732c6cb2b	98.22	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
02c19837-d784-4206-9620-64244e03e6a3	e2444e15-5e55-450e-8b09-22e1157f57a4	66.54	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0bb08c47-897e-4a6f-9fea-82049faaa8ee	52f621e6-e888-42b2-85be-3f9b36f2e5d9	115.59	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b6ca1406-61f6-4b2f-8a17-57495f936ebe	6895d518-2a61-441a-bac6-f5261c015295	169.63	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8c749d8e-526b-43e3-a1aa-49aa075f25a6	513019cd-5fe8-4fd3-952b-9c73641b891e	234.75	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d571b138-aaa7-435c-854c-9bbb96b93c05	15f5ccae-d11e-41cd-87ce-005825210c97	138.61	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d625a68a-65ae-4368-9d90-350810a0475e	d2e94dce-ae9d-4aba-b1e0-4ab2ea5169c2	37.48	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f387c5a1-9f73-4717-8b9f-0797870fff4a	45b8f496-f798-4fda-8464-138b8a47793e	51.96	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b64e140d-ff0c-4138-9a8f-3931f602472b	e777cc66-2fd3-4721-bbb9-5cba2e38b778	47.37	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ce9c121b-eed6-42dd-8f7a-7f350a546819	5d42dc7b-48dc-49a7-a7b7-3818d2ec4146	144.44	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3ec29cc4-6416-4ceb-9eba-51dfe46e8f61	b8b15ae0-9670-4e40-8622-307e7fe07106	56.37	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e2a7dd1b-7843-47e4-bbf4-7b3d47e81aff	12eb3375-0fdb-4d8e-bc9b-a3275b75e6db	104.08	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
092b2590-0c52-4c57-81a9-6b938f6f1bd4	7f3736ea-2440-4d5c-95ba-f83cbef6d72e	103.61	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4e949e47-cd40-497c-86b5-e47b8c108970	c890153b-4329-4b65-9233-294f3d6c3a50	198.64	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ba13b5e7-b3e6-494f-9146-097ff3b44076	8a7559bb-cbf5-4353-8488-90a19620c9eb	245.85	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6d2d590d-e1cc-4a74-91f6-4995d4c580b0	e7a18fb4-fe36-4f89-a432-1848bedae75d	145.40	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
80f32d0b-05f7-46b2-95d4-4e8cdc210c6d	797ca8e3-813a-4f42-82e4-969328a4d240	117.32	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ba410fd5-056b-40d5-a007-a60ee82234c4	5da7923e-37b3-4f7f-9a39-9e7044069922	139.48	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1d988241-bc5d-4670-902a-ba9510c45af5	f2dbfe7a-ec20-4091-a2f2-7291ad718da9	212.42	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5a70360e-eadf-4224-9c67-ede8cd6594c8	279c08a6-f2bc-458c-8fb5-7df99c0a395c	185.88	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9c234ebe-2f9d-41c9-87e6-f1ff19356e6f	c37e4e3b-586b-4192-a54c-fd25efe6fda3	77.20	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b3693b18-9a1f-4741-987a-5df780d8b251	7f8147df-1bd0-4287-b6af-b7f9e5c32334	64.61	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4983af2a-b3d8-4727-9627-e03f38986258	bf1f7930-0ecf-4f73-a1a2-9f5bf70cb808	120.38	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7c951068-3159-494a-96c5-a4669faefe72	e28ccb55-281c-4856-9fce-287eeb1bf6f5	252.13	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3c827514-2cf9-4e23-a592-e297971e476e	4a9301d5-ed4c-4d9a-8ab2-58367120469b	38.06	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b7fbdba8-0749-4bb4-859b-ebb277f5adf3	189f726b-0b71-43ed-a5ea-a53ed75c11d1	125.37	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
38d1a2fc-8651-423d-8275-136f06700341	b54f5794-6aac-499d-a9dd-d776d9e6f900	83.73	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
61f9c613-e9ce-4ebf-ac60-054e8b1aa4bd	8dc42314-4e9b-444f-b210-c01982218c61	222.24	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9e6c913c-746b-4243-9686-420b1a29113e	9b045ef9-5cb7-41b3-a09b-98ad670e5778	250.21	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c9e51c0f-8f5a-4f11-b25c-920a6ae8ecce	56033f22-72c7-4eba-9a39-d1f1935143c0	129.00	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ed418491-48f7-4e2c-bb1d-ed3b6bd58246	b65fefaf-76ba-4050-8d8a-3394c6af05bc	101.07	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
df5527a5-0a73-468f-a7fa-55f7b9e92aea	f9e08907-42c6-47f5-b140-df61790a7769	107.43	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b3ff8735-4cd1-4099-851c-6f7d01f757f6	c33d164d-c1d7-4aa7-9801-0fb22f9fca9d	142.08	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1f2a488f-1a3d-4ef7-b8be-e7106a144446	54c45a8c-4bb7-4d08-a12d-92b4c7307b93	89.56	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
70a247ae-b60f-46e1-be6c-3f7d19b116c4	d0ac80b6-2fb7-4935-909f-d3e942a85d68	128.37	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6403bb47-ccbd-46ea-ba39-07a3aaa4ddfa	4a126694-4f04-4e97-9975-c4db71740622	184.21	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2a5f2592-d0ad-4b56-9226-da1c00839c8d	1f7c3b46-846c-442f-8898-4ca8a7da4fd8	248.32	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2f3580a0-9928-4f2f-acaf-12fd9572a0a2	dab9151e-fb52-4e13-83bf-9f225f0d4ef0	39.01	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bb858b16-10bd-43c8-b685-2aca1b7ff127	bd24a131-4468-4d28-8ea7-8803c1bb0e32	12.50	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d3443a62-917a-4383-a848-ea6d37bd9014	3fc65409-48e2-4abd-a8f9-eb667547cc89	170.57	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7d3a374c-a869-48cb-acb8-1a65755c9d5c	c87e8bb3-c7b5-47a5-9dc1-3d8337f42982	107.76	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
28164c63-df78-46eb-8938-3c5176436ecf	9d93b739-1187-4976-9c6c-0a389356fecf	90.54	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a4e9e571-53a8-4b76-9790-8567b0562f13	dec13856-c58c-4eb3-9360-8c814c9842a8	189.72	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
10141c3d-ceb7-487d-937d-ccd8f9b44c15	ffb156c2-7a76-44b9-b6af-9acb6e54fdb8	71.18	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
14580b64-4946-4216-b510-513f93b93e14	99f6ce9e-fe98-42b9-9fa3-8f7370f07a3d	63.16	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cd43b4c2-ca2b-463f-b768-25d517eb8a4c	813ce775-70fb-422d-9671-6220988012ab	40.70	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
595dfc6b-665d-456f-b422-1417aff8b7f1	6d5bd472-73e5-43ac-8189-8f1ffc3dd7d8	85.35	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5401359c-a89d-4595-9e60-ba179a59d367	e1eadabc-6c40-4ff3-93a9-a914dc022510	172.28	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
aee63446-a524-4c0e-9664-71c85a989d26	86e280af-f765-40e7-82df-e0292b0693b8	135.98	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a0c21e56-619d-4615-929a-e32b7c7bc4f2	1c219f82-1ed9-4abb-b4ed-11d993d80bce	151.75	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7b357fd7-39d2-403d-a797-36eb1165659f	ee3fced1-7edf-471c-9b7d-5af7e827be77	52.79	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b1fa12d8-6fa4-4ef8-a1e0-211e9b8cdaa4	8368d8d7-9090-41e4-bc90-15f7a084df5b	140.55	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
247a1df6-3b3e-4f8d-b175-391b50af9879	8e577abf-5f86-4498-9309-64f616ea275b	67.88	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
80dd1c29-2656-4bbe-b0e4-00fb76ab4f2d	7fa6eeec-31c6-46fa-86d7-d8e2842baa52	129.21	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
155661fb-eddb-4abd-bbec-5ff25ad694ce	0cf1abe2-2b17-4051-ae66-d3a989ece9e7	64.35	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c2851b29-ead5-4ea9-9e98-c4d0c2aeee38	08ba1eaa-9546-40a3-bb75-6d1f69fbb9ae	116.63	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ec60a03c-006f-43cb-b42b-cd9c5e4400f4	3d3e84cc-3247-4432-83ad-72071bd04e24	89.68	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
677ab07b-33a8-44b6-a718-fd37d3b8df4c	42aa2824-9ef8-42f1-88f0-47e0e36adc45	39.72	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4b416245-6421-4ea2-8ef8-cf7f7b98b908	44734553-b21f-4269-a5c7-5a1eca042d59	79.67	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
dc51b07e-151e-4539-a9c9-8ecfeb8b4306	17816150-5d60-4721-8bf6-453144e35e34	87.64	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f7597d95-9899-4451-95d8-96a5745799a6	a2fbb854-4e87-4aa8-85b9-75799e0089cf	105.32	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
50ed70c0-743a-4632-a650-aca0d1fb0e55	c33b1dec-a5e6-4e60-b5cc-85aee74cd171	203.64	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
05cb09ee-a05c-4cdb-9519-cdde963213fe	c91d7846-9ab6-408b-bb49-d0c988ca66b1	109.69	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9a04f073-30c5-4576-9cff-8e0d44ae31ec	00e3d3e5-5297-482d-9d75-c47628808981	39.54	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
44afa73b-594c-4b29-8bd4-b683e3d32ab3	50360424-c121-41d3-9696-4a8e8b749192	55.58	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a521ad0c-a648-48b5-92a6-9d0f2bc19ac4	9686583f-4293-4dfb-a862-80330ab23773	174.51	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a5e719c0-08a7-4bb0-97ea-a29507212aa0	8a5eb443-e259-4d7d-86ea-c6003263e5f9	124.82	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1fb16902-c304-4aa4-8dde-b00b0701dad7	63a49523-020c-4bd5-9fbb-5f8b62afbf4f	40.83	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
37d46ae2-24c3-4f8f-9d23-9da8883af86a	77fa4b65-dadc-4f68-863b-f5fd3250ecd0	103.14	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
875cf18e-c34c-45de-addd-43723523dedc	f2bfd119-2269-4266-bde1-c727a5ddd258	83.95	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1350c616-df81-4142-b4b2-4dd0bb83a3f6	acf1e7a3-eac2-49fc-94ac-dfa337383396	235.44	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c48094f1-03a7-42aa-a944-f2a4ca32a5d2	4fb0de4f-2a58-46fd-9c4b-79075f00818e	125.62	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cf1d668b-3abf-4cc1-9ce8-1721ed9da4c9	cc080dec-4631-475b-be93-623ae8eecadf	92.24	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7e1ef7c4-d9cc-4f68-af6c-a756f60e637e	1b557418-1d52-44b3-98b0-3a158948754d	82.89	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0bb69a8c-10bb-457a-b613-dfcb2a11b34a	fac6fc06-5a83-49da-a8f7-77e309b05910	267.06	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b7cfe82c-b370-4186-b0e1-938e7e066497	25074d97-b264-46e5-bd81-8c40b5c94f82	139.60	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
460bfe95-68f1-4710-9563-926515b5ba93	dbb04a53-5db6-4ef9-ab7c-a02e9340cff5	66.65	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
08e51187-e7ee-4da5-887d-7fc9e11e7240	c6a35ea1-6c8d-4200-b154-a60f60251c0e	31.75	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
784b36af-e42c-419d-ad68-1485d3560daa	23521e95-522d-44b5-ae88-1b545c1fd515	138.02	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6bf51903-3bfc-4f8a-81b5-8cce9711e8fa	5cf4ca76-71f8-4d8c-83ec-304ca8c03cf2	75.00	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
02cf13c3-4523-4e2b-9caf-2f517d1df2e9	e72c4678-b6e3-465c-a547-916548618acd	30.12	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d14d956d-934f-491c-a599-89a15b4e453a	a265444a-9c23-42a7-a912-e7905915aa27	185.65	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
93adb229-c144-4680-bcfa-2bbc95636384	f3e56460-8031-455d-8946-6c2496c0b472	43.14	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c86a36ad-0d35-41d0-889e-6e939243d743	553be188-d1bf-4d0d-9ff9-d58b67a5e0db	116.34	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4b450580-5b57-4a8c-a760-3bcbf8c68ebc	c271dc6f-c3af-405d-bad7-25f66d65a3bc	94.73	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
51c734cb-abf4-43f4-93d4-73a45fdcf651	413273b3-2fc5-4051-a80c-1162f72ebf60	33.51	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4867df62-9b6d-4fb7-98bc-ba9b43ac9902	769029a9-1596-430f-8749-27ffa95790c0	30.12	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5a273fc5-7c06-4b18-acec-ea2cb0944270	8244148e-7455-4ccf-b73b-352da6c021c8	97.62	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fbda7f03-5527-41eb-8580-e0a3f84ab61c	2207872e-4613-4c1a-a69b-7868607f4cda	104.81	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e8c71dab-7930-4c29-90b7-dd63cfa89e6d	39d2e9ca-24d0-4e06-8cf4-403a006ba21e	19.31	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
60b2382e-c6ef-46a3-bfc4-f19d905c74ee	1046377c-3ca2-4f05-98d3-40e0afcf6f1d	91.69	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
85aabdd9-b515-4ba2-b60c-9995c2c5ed4e	9274cccf-789b-421a-aafd-37bb06bcef77	15.26	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5c935559-44d3-4672-9c1e-36f67875eeb8	a89f854c-8dc9-4af5-b074-2deed2a48072	22.63	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7080cc79-9c09-40ae-ae02-e43bbea13bde	43dbbaa9-b760-4ac7-bdf9-c3c921fb1d5c	145.87	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e507bcf4-e304-4038-9407-39c4e7828908	e9fe82e9-06cf-4c8a-bc2f-4dbfaa6b2e77	102.22	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
338c30cf-7010-4882-ad24-6311f31afefa	28a83d00-61f4-4633-9a10-39a3cf1027a4	219.68	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
476ace12-78d7-422b-8667-9642d922a2ae	356947bf-9525-4eae-9a7d-b9ed738725e6	23.46	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fc8fca57-1446-4485-ae5c-2ce733e209fa	31a03291-ca89-42b9-ae38-7783fc3344c3	22.06	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4252f98a-14d8-45c4-b5a2-15efd7bc431c	799383a1-95d8-4e37-ba78-f001c4671517	67.59	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
12038383-2b67-460d-a4a1-af20a272ee49	693b64ab-20f7-4305-a7f6-21a1d5ec2f90	122.74	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
540de56b-7256-4480-ad3c-c8f65707aebe	fa065969-0dee-4888-86b1-ba645d478746	47.18	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
aa0b8530-c6fe-4f70-b313-346920c96107	ca88aace-dadf-4ac5-95cd-2d82f81cb785	226.04	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5cdddcb3-3e41-4600-aa7e-aeda6597dfa3	6b58766f-679d-4a49-94d2-61c644fe4958	101.58	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cbf9225f-0283-4a83-bd76-fe6f5a427df5	b9c7df2c-9c25-4a99-a296-217e49d299e6	28.62	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
38dc17f2-522a-4353-a442-9ccd33d007b7	5418f393-a98e-47cc-9444-8c598899bc8d	312.60	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c5cae494-cf0f-49a4-aabf-7006b37f4740	99f40a2a-e6e0-4a58-9657-b7a785563334	137.74	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
58b2ff7f-1ceb-4d07-ab30-f8f6589be320	8669e169-c126-42ed-8d4a-a73d39ec8572	114.76	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
356f637d-91e6-494e-850a-18ef37806773	fae5b1ca-a3e8-491e-bf10-6edd05f9a558	148.80	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a26c252a-aec0-4875-9911-935bba71d082	60068966-6de1-48f1-b649-08f4bb70bd7b	36.30	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
dc5ca7c0-7e4a-4eaf-b2df-f400b0f35490	2d38ce28-911a-46c2-b612-631fa48c4823	97.98	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e0102df3-ebb5-4779-aeb9-3af0fbad0cc1	8edf1f87-ba3a-40bd-af47-0d26ab5c34b2	131.62	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
78e53fd0-a8d5-40c1-89cb-505c1fa527bc	44027ede-9ccc-4320-a67c-d60229ceebdd	22.06	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1e1ab0ce-936c-481f-b50b-141320da869e	b44e9ce9-4575-4b75-b8f9-a52d5dd1651f	242.98	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6cceff96-b62b-48a6-97fc-a8efcae2daef	83b82f54-b888-45c3-96d4-46d8726f179d	252.63	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fbda4806-3905-451f-968e-e43a37018137	e78fd111-2f4e-43bd-80b3-9e755eb5db56	123.82	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
41214cec-433d-4c48-80f5-bbf2ac4d880a	efaa196f-f777-4e6f-a1c0-960360bd0159	204.33	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cbb82318-58ba-4eab-acaa-b37d4756c5e4	451626db-18b1-49af-803a-1ba420462b32	239.49	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a3a3bb21-3250-4b04-ab4d-1c06c07c297a	4d4eada2-4ccf-4783-86bc-04a208ee6b45	93.70	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
78595299-9c10-4633-8f11-aa08a010d953	c83c2c71-5eb4-4165-9a95-a900434b62f1	67.78	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
656167a9-063f-4aef-a90f-6c247f6e044a	25882ddb-494e-4565-8b51-0fe4abe58d9b	203.96	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9c38a07d-f1b4-468a-9a9f-6c36858e944f	cbcf0bac-daa9-4256-a715-e7e993cb7972	231.49	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
66a166ac-4add-41cc-bda4-47e30b735736	993c9ae2-c13f-4c31-ad1a-50a6fd30f7d5	270.46	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f9d32bc0-4842-4a5f-999e-ebbb03a9f64f	94417d6b-ad56-4f3b-9493-7020a3cc6607	170.34	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f9329181-1d68-4ba6-b567-c700627c58b3	3e94664a-547c-4588-8038-49f8b8055161	101.31	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8ed60071-67a0-4bf6-ac78-57dfd4356e8d	c8cb3636-35f3-4916-a79b-79432b68d64c	22.04	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d7194fa8-5d29-42eb-8d75-0ca22f9a23e2	a98fab5d-9d6b-495f-9d5f-a37db36cee46	58.39	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a40c4e38-8571-48c2-8a7d-bef1ba6f9f9f	5956ef23-ddb6-42d5-951c-3f7ac83fe422	159.07	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
937670e6-4f7f-477c-be90-177f791deab8	f42a13a6-7ef0-4fdf-828f-8000f3a6e31e	219.07	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3c6e08ac-8d7a-4b14-baa9-1223ab370575	71979b3c-0eed-4490-996a-5374cb24ab7a	148.14	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e866dfb1-d331-4cff-ab4c-6c18a58fc24d	d41086c3-e5f4-4151-8802-4f18de6d7b76	108.92	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
81267005-9411-48a7-b508-2c5b5f5c7f18	dd52af66-ce5e-4585-ae75-16800b9b7d42	109.04	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b84cc2e9-c53b-4e66-aaf2-999355228ae1	d4ee78b1-6113-408d-92dc-fa7b7907155f	149.78	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9f99e3d7-45fe-4def-94ce-169272efb72e	ee148ce3-cb28-4eea-9178-332d0c6901c2	178.88	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9bb41241-68d0-4a41-8826-ea9a89166b64	42a2da6a-3c54-4ef1-b503-abd4c4a12551	145.82	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2ef42b86-423d-4bf4-acc3-7020240bcdfb	c326d2c5-4896-4165-8323-b2baed3356d9	200.03	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fb6e2154-2635-467e-a260-d14429a3d4a3	c15c8ffa-2173-45a5-8438-f168f7428706	21.91	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9ca026d-0790-4f71-beab-7ae2833a52dc	bed764ee-ca9a-4db3-ab6b-534fb92740e9	108.76	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d70d7bea-ada3-4365-bdad-c127a682f286	dfc274a7-842d-439d-9d53-c76a3977d4a9	96.63	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c5f29213-459c-4f47-8f8c-8bc208cec307	61ea9599-4c17-4692-92c4-7ddc591b742d	107.72	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d1f64084-4cc0-4ac5-8a0f-6cbee320f69b	a0a71cb3-f02b-495d-8133-bcf4509d41b1	142.10	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
158dda26-13a8-40c7-8736-b0f2f80173b4	a58a064b-d986-4fe8-9496-408fd9a74bbd	83.65	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ea72bb38-0515-4ab7-9fa9-f4302df44a3b	7aba45c3-6f0d-4c54-ac6f-377507058bd2	172.00	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
47ed9fff-bbcb-4cb8-98d1-8b8c5a11ffc3	d6e0f854-8392-446b-bf5c-7e31593a68a8	73.15	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
dbb8bf44-f88d-417d-9e66-31f92fdbf3d7	61a5a951-8b4b-4cd9-8cec-2dffb9025158	71.84	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5c36917e-faa4-4420-bb1e-cf47211da6d3	72da683a-7dce-435e-8564-09e933f5ba0a	161.83	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c7160da8-a5fc-4355-9f52-e397abbc6b72	1643b937-34d7-47f7-872c-b13cfbc86afa	105.93	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
baba8911-7887-456a-871f-3ce8735a7ea3	8405111a-e0dd-4285-9184-ec2471beb9d2	155.10	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9e95ebd0-42c5-463c-bf04-b388851bb180	1adfc14b-935c-47cb-abc1-3aa128f3275a	157.36	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c1fcbdc2-359c-4916-8dec-a8fdf08998ea	3acf71e6-35b3-4013-821c-27c57648c0a9	198.93	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2d7be4c1-a603-400c-9cd0-e3e3f3dc759d	41af1ad4-ab82-46c8-9507-bca0e26723e0	196.82	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5f2164a8-8c4b-4803-b45b-8ffd3b3f7798	fb044831-49df-481a-a861-0af091d76757	189.22	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6afd1bf4-8bc5-4d99-9247-128806c17df1	143b148c-cd4a-4e46-8d50-d61f9f4c2835	175.54	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9ce5fda3-338b-4b08-be61-aa70a5d80482	0a6da96b-f001-4aea-ae3c-0ffc9554bfd2	174.07	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b33bf8c2-5eb8-454c-8498-1ce15a663e16	dce91275-e00d-4b0f-8276-2cf8bca1d483	204.25	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9936b5b9-e2a1-48fc-99cb-679a07826dc8	d3e8d233-d659-48bf-b508-88654f4456e6	37.13	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1abbf196-5238-4cf4-aa4c-1982021e3496	2dde3f0d-bbca-42e7-a39a-c18122798bc4	54.65	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fc712742-ae0a-4ad9-8db3-952d2b1949a3	bcf46937-cf47-40be-a416-bfe0a5523cee	114.32	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
57692059-5baa-49fa-9b22-bf44f6bfb42e	6b21d51c-de82-463c-9270-2ae4867cb2d9	189.79	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9cd84ae-94b7-4fb3-a4a1-8f8352f1d53e	29ce7a31-3ff7-4a5b-b7c2-f31290f7aa8a	184.56	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3a3159a0-95c1-4a21-b8ab-bccfb48a79f3	bb12c07d-2f74-4d5c-ad63-9e081a22572d	133.62	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6f4f5c12-3676-490f-b753-8598575e6f79	cc464465-7b49-4405-8e6f-c9e3f7c3dc69	81.56	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0ef2bbad-387e-4724-86e1-a9ff45dcfd31	f1ad5537-be27-4fd8-b6b7-f39b7ff13278	143.92	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
531ad3b5-bca3-43c4-8e19-c820063702f9	1afdeb54-27db-4f67-9e99-b9f7311a65f7	10.35	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
856f3456-5263-4674-a6b7-9184cd747e8b	4d0fcf77-73cb-4daf-a003-0b4902e29f97	99.80	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
785a0f1d-dcb0-420f-b493-dd5512b59a2c	1dc38571-482f-4dea-a651-f0459d78cdca	111.16	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3e69afac-943a-4f50-a9b8-e9cc5f8e2296	d6f5a54b-8e14-43a0-a2a3-5556498d830b	125.55	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b7645e47-6e73-424b-8261-a6bfb24b7b71	38516bb5-3585-40b9-bfae-4522dca85da5	243.03	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f6233509-0d82-42c9-8c8e-c8edb311728a	f18e6136-e33d-4d71-a965-7e5384029481	46.59	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8c21ec6d-5e10-4372-9ace-604a3ac97c11	933d795f-3eca-4757-9fe2-addbaf10506b	67.88	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3ba530d0-bd79-41ba-8da4-f5351ee74398	91526298-0b5d-46d9-953d-d220165c4dfa	177.68	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cddbe8c7-f05f-4ac6-b148-3b5b5d795e77	36816ae2-8094-48cd-a720-999f984038bb	14.00	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0853c398-bc3e-4a00-a2e1-b5523c57246e	c15b6587-e163-4b51-b03a-91986acea98a	201.31	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3cfe199e-dbdb-4848-907a-710e527ff3ab	35826da2-235f-450f-a727-813395e0787a	136.60	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9b3341b-1765-4eee-9e02-0bce5a06ee23	accaf494-7c3f-4f93-96bb-256198632cc7	155.30	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
95ba5d78-2a42-4ffe-9a4f-aee29dd9c7e0	aca14bec-7868-4098-b259-9990f923dc1a	198.16	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fcbd9f26-4197-4db8-9f91-c8786af8261e	ff20a0a4-6d81-40ae-8e44-ac8d28c17aac	80.01	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
34bf34fb-3924-4cf8-bcb1-4368d9a3c1ac	c5c5c618-b33d-4375-a872-0ba4fced0dd2	19.31	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6e5633e6-dd7c-4fb1-ad5e-7b723aa8048c	e80df973-2b1e-4e56-bd36-f7e6561ef1cf	106.67	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bc452b50-bcee-4461-8915-03b8c41e32db	6adcea04-a10a-4deb-bdd5-a7c8a63be6cc	201.16	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5258a19e-d4cd-4969-b6f7-b961fa4bb32e	7c428075-3100-47be-84f5-79310faeaecc	160.79	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c1f5005b-9a6a-4c55-b923-b316758f841d	139e5c95-92eb-47e7-8331-0727e3929acf	114.42	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
35028f93-44a1-4fb7-bf03-32510246477d	c965aa40-94ee-4a95-8c3a-a9f54d8e1b83	49.60	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ca2db62c-0985-4e19-8769-65e41bd05bcb	6327b46b-c505-488d-9af8-b4e07f3aaaec	62.46	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
64d6cc12-5490-4aa5-a2ad-1039f32d527a	5f8713c5-4a12-4bcf-9a54-04e81f8891bc	153.39	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2dfcef69-b097-4130-9381-d5700a7de213	f458c05a-d808-4264-b30c-184165903fd7	96.87	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
47cb77d6-f4fd-45b8-b501-c42175f1e1c1	8bb3ce90-de43-4db7-b1ce-73244a4abd29	12.50	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a0c0b079-da93-4c75-8a80-74a7314bdc91	07d2f56b-615c-48be-a249-189259e8052a	196.55	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e29409ef-7dcb-491e-9b68-946799eea236	516c760c-aa9c-4f4d-b324-d6a94eba0f3c	57.28	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c6eb58bf-c714-4f80-8c79-67f99c3b2268	64e594d6-aacf-4e79-b12c-446250519ee6	168.79	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2c803e3f-4fed-47e0-b166-c12cacedc657	fa8d55ea-e8fc-4a67-ab7d-c3a5dbf062d3	121.20	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9c9b90fe-603b-4d76-9167-935f9893b5aa	18ee1397-aed7-49c5-a0f0-30be46063b69	119.70	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fa40a6cc-3244-4ebd-9318-2c58d610e654	a31f791e-bda3-4dbb-9d6c-9cc68aa02dc6	276.89	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bc54809f-c762-4e72-b3ef-b8e9cf9eada8	a18baa85-6c3c-477e-8baa-00f957633266	144.46	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0e0d0b1a-929d-4575-b763-9fd8fd79bf57	508923d7-8d95-4a15-9aac-e8c282109576	149.24	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8914c25e-622e-45e4-b872-ca5be94b81de	33f3df13-c751-4d16-81f4-9c1da9481ce5	198.98	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6931640f-ca14-4298-8cf9-5914d960d5a8	6e08b51e-d867-4add-a181-e06f15c6f02a	82.89	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
83930461-b918-4336-be99-b8abfc9a0179	a8988ad5-6ec5-4168-868d-606284d20c59	47.18	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8df7651a-dcd0-48cb-a4b4-962172c7e18b	bb8f83df-b244-4d09-a4a5-9be604cfd19e	27.26	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1a6519c4-370b-490e-b780-8b6798989d24	bd89f426-3502-41f9-9d28-55708e611bc7	188.37	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
267393fa-e406-49f0-8684-fef8bb0570ce	927645e0-58ac-4361-8b53-555c3a424071	221.58	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9493761-ceb9-430a-a071-89d55a3d6bf8	b70087b9-1789-4c8f-ac16-efa8412e40fb	271.23	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d909c7a0-d6a2-4fbc-b2e3-168cd3f1d4d9	6664a2a2-fd60-4046-8bd0-57263cac8c31	147.10	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
86fc13ed-9965-42d9-a16a-9778eb1be36b	dbde865e-b45c-4843-a42d-803a8519524f	71.18	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
baf6b138-993c-4abe-92e7-dd00fd951ce0	f0df54cc-8181-4f13-b2b1-8cde49c0986e	114.39	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bd495cb6-e8e2-46b2-8269-6a322c22e890	f8749b98-ca89-45f4-bb70-ddcd79a085a8	138.72	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c260019d-5139-406e-a860-74145e17ee44	e8c6b522-6d05-4cf4-82d1-8ba2a9697f40	53.49	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cca2a944-420b-4982-9826-f9597d98ef92	59128ed1-0e4b-46a7-838c-cc94859519f4	120.16	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
84547ce3-0122-4ffc-92ce-cf5ccbc6ce95	7e0c57d9-c2c5-436d-b447-eb7e79439372	90.36	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
63552deb-9133-4839-ba73-7334087ac015	ed91480c-f6ae-4170-8438-7aec8131f2a2	123.76	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d3a6a3c9-de5d-434a-9d41-8cab7f37fc49	b17c23d5-b919-416c-ab76-8447b1ee6901	159.48	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2f8b6f5d-c578-41ad-92f5-625e5d8fc905	2fa63f1c-211a-48d6-b37b-17b577906e61	149.77	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
63359bc1-69a0-4633-a41c-7bfd27687dd2	aebe01a4-90a1-42f3-b194-de503cc1c01b	30.35	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7379058c-8027-4402-bbac-db2a7603b81a	e5ebfe03-f1d3-4094-ae23-45653b24b53c	205.72	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cc69f8b3-8210-4fcc-b819-8b91d5d8bda8	94c5c2b8-7666-4f0f-b944-0c64412bee75	189.70	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ade5055b-4489-40aa-b218-ca497537d555	9fa4134a-46b0-447d-b6df-301ddb544ca9	135.12	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7fd8343a-4d66-4c08-82d8-4476abaf172f	e86b6520-4a1d-474f-ba58-c4dd42c7c793	124.78	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0eb76682-1512-44a6-9e10-1300848df0dd	c06aa566-ab50-433f-b76c-697d753690b4	93.91	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7b8b5998-4ab0-48f1-9e66-f4219f75324c	9ed69cb7-2600-494f-8324-f7281cc31dcf	52.54	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5fd9f642-0afb-4146-8e01-a85fbd028506	11effd28-06a5-44de-afba-b0926231a943	37.68	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0c6f4dbd-5a7e-4db4-b98e-71ba39d979ae	12d9042c-c92a-4d76-b42e-071f8ef348bc	85.86	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3f0bb706-16fd-4a94-bc9b-1dbc017a6d03	58546a50-51f6-440b-aea1-12317d6a9f50	165.13	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4a9d11ec-3d64-4dbb-8f52-a2f4a28ee366	9f95097e-fe67-480e-b63d-e3efe80d70c5	59.31	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1e0c93a1-00a4-4196-b957-489f636d618f	e1739e99-86b5-4525-ba85-44cf361e1761	67.88	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4d47188f-32b0-4128-92fe-b3a0521903ae	2beb8800-87cf-4764-872d-e895fae05d96	100.46	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e954ac8f-6bdd-4f0a-ac76-cf02c33fd2c9	785ada9c-bb24-4e07-928e-6f21343554ed	76.60	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c7539772-31a4-4439-90bb-b5b1b35c1726	dbeb0761-194f-4015-9563-5879f7354ea6	82.00	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b2e40e56-3707-4f22-841e-95edcc96b5ac	9fa5ea08-fcc7-4b16-a2b0-fe5e69cf3829	93.83	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
48edfbb1-d55f-428d-b0e1-e7d793450fd8	73e7cf8c-b884-48d0-b876-5d23a938e6f7	78.73	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
286b1918-8fbf-4ba6-8afa-f4e9ebc93ec8	cc5d20b5-846f-47a4-bd55-01902a13e4c1	54.52	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d6a3fab5-165a-4f86-a24d-1fbc25d6204a	2fb35d73-a26b-4ff4-81f1-56bcda96aced	126.64	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ba583134-9ac0-4796-8c49-c1b1e1dcf9e4	cbc26c58-a97a-4f2a-8831-d46909f4222f	47.80	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
846e610e-2b1f-4c65-bf1c-a0d3d1c01531	0e41fca2-50f1-4c11-9038-eb8e5510f881	72.74	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5df64871-44bd-4547-95b0-9d048cf4d811	201ca905-79ec-46e2-91b7-d5ad16ae121e	74.82	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
56790b8e-7831-4691-9798-9f01173e5eda	5ec30e08-da26-4cad-9f94-906cceee5624	70.58	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7a2b8cd2-698b-4619-9d9e-49c88d7efdce	5d67ef8b-4012-45d1-a4ce-b0c8d0d4ef53	62.46	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5062dbcf-b838-4fb7-b00b-f5d2a086ab29	1d271e45-ea3e-4cc6-a61b-dcd76c63ec68	94.36	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c03b2c89-c1f0-4606-a855-d8a33420e2fe	f49c93d1-861f-419a-9a4a-1b6911ae0288	138.46	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
04f64188-f31f-4755-8c41-fa64c0fe034a	5c69042d-0655-4421-a532-ff8a0440c18e	127.18	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6d4e3ade-8fda-4481-b620-083b2fbbb0e9	1a32d39b-83a2-466c-b63c-08b923027649	173.41	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
62d606dd-28a6-46af-b2a1-fc9c8e0025a9	8c7c3138-a3c3-435b-84bc-4ce5bd09471f	145.74	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
279c0be1-f44d-4a07-8226-9cb79f802b3b	72a6e801-362b-4def-9205-834c19c8060a	181.05	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fc7ae923-79ca-4ef9-82d7-6aa122cc5652	77ffa843-e69b-4973-bc40-1aa69e02d958	246.32	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c71cffe4-a185-40fd-8fcd-28ab99c27d60	785f59e8-65d1-4db9-9680-e54d2d9f3ce9	194.52	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
797e913d-338b-44bc-bbc6-90bcc5814a7a	2e10d746-5aaa-433c-b01c-f0c711d9b0bf	39.17	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3a8de129-c520-46fe-9575-522ba7bc9557	54f3f6af-d087-4e8c-9307-9f876b8d2585	86.11	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7023d305-f137-4a8a-8d7e-4e6008545df9	2983d8e9-921e-4e64-ac15-0e54f0415c82	82.84	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5a776d1f-d935-4a32-8ece-72249ef6efae	b2f2ec34-152b-491f-9f99-4cc68701f096	88.14	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
eeab39c6-88ed-423a-a4d4-b5189bc137f7	91fdc0dc-5776-43fc-a20b-0be131700faf	240.62	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2997d07c-af33-4e00-b31b-b5fe2a83101f	344bef18-b66b-49b1-a308-e750ca6dda1d	120.96	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fb0c598f-7582-4b7c-9543-6a26ac84acd6	0a318416-aac9-4f8b-ae13-abfe3e6e05d4	137.04	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a87ae816-7c7b-41bb-8d98-565fffafde6e	59610614-6e8b-480a-904b-d8df1b841b14	92.95	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2dc6c3e5-2425-49b6-875d-4335168132ec	004f8fd3-0429-4918-beee-0c2b638fb8e9	100.44	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4f44bb14-1e0f-4946-aaaa-31e6c78fb00c	e4b5b1ef-6a96-4681-a960-2d90c194c0f2	154.90	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
962f203a-57ff-4352-80cf-871119b37093	c4916f9f-f844-4037-99bc-f92d7d2e0e9e	75.37	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
085e6df2-b972-4307-8979-2f6c9157cbee	d924c037-d938-43d9-bfe5-546550ec0a35	254.40	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e3449410-30b9-45b9-8844-6867564a0812	7233d4e3-4dab-471c-8b5c-71cda89e78ef	62.18	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2a00b7e2-1f10-42b9-94ae-faf3e1011bc9	855f61fa-3476-4c9c-8acf-9a60f057866a	88.75	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d62d23ef-2e3b-4009-b65e-75eb121bb78c	a0dd4aa2-a18c-420e-89ac-6a9508e9e606	113.61	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bfd04d4e-ad80-4dd8-be9c-84db7ef63d4e	48b976be-368a-4840-85ee-cc79eddcf95b	105.92	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
82d07621-57af-4610-8555-1a9d74c19cc1	c8bc1084-07e2-4514-8c45-4ccca42a6147	232.06	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a520f67b-ad63-4d82-9107-cfe9f2e584b7	acafca1d-3010-405b-b5b4-0b1ba7093b21	111.30	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f31b85a9-98fe-400a-8aab-878822d994a6	d85fb1db-fed1-4a8c-83de-164487338e4f	97.27	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4b8fcdc8-c43a-40a5-94a0-394ff3af8f97	dacadd56-d6ad-4423-994b-5e45c3b26125	132.00	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
51322f2a-17fd-4acf-b129-e7a5f7aae667	4b46a60f-3332-4720-9750-62b06bddb8eb	87.63	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bb2e581d-05f8-4cb9-a8ab-af9210a58397	90dd7840-d615-4dff-9ed7-2d30d487c8a6	35.59	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c010c2ac-4ffa-41e7-8a6a-a00ed3e0a21b	fce9aa3c-fdf0-40c2-bfec-06a2654ac34e	43.59	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6a92cab5-b9e9-4176-930a-f6c5a30dba8a	9f3db135-6098-4cd6-bc68-f6b396780f51	161.91	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ff12022c-0551-437c-bc13-5da6a23c7f64	4dcda910-d522-485d-8d47-d8305d96cdb5	30.35	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
677d9967-59be-4aec-ac15-0524eccc887f	82526151-948c-456c-b873-55557f652e1a	86.41	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0e210429-91c2-4e61-bd2b-2df03cef61cd	bf3139a6-986c-4d0b-b634-b781831b3dc3	114.64	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a93faa47-0e92-4bc4-8b45-576d3f662287	8661e7c2-1bf1-467e-aa63-63a48f6b8bab	18.84	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fd038a71-a4cf-4457-a5aa-28c47d3b148a	444bf5f2-f0a3-4fdd-a574-1c107c8c75ce	136.66	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a26d1a5d-2c3f-45f8-b086-eb53c87298a5	e3474a10-ead3-4093-9cb4-028ae0bb48d2	145.95	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
307c8113-341f-4e01-8a1c-5ae8463ff4e0	f7a8a32c-0b1e-4b28-96ea-418bbb35c037	62.62	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ba94caca-e24c-43e4-903b-38941cd39201	cc7aa352-fe1f-4b2e-9451-a260121d0e5a	328.20	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0a66dc1d-f860-47c2-bb7e-4246116f6bc9	365142c8-0b5f-4c15-9568-6efc68bf8b3b	91.05	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
88e1f043-fd6b-47ac-8cba-bc2587fe2e65	33e7d559-cd1a-49c4-9d64-c6044b36d892	98.85	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
280f4173-66d7-4ec1-8584-5ee0e678fc5e	87414564-588d-447a-a234-b3462a4759f7	61.82	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e0c6f207-30ce-4fff-a801-6ac062b775f9	85575b48-fb50-4e80-a5a6-85f8f3de49cf	245.02	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
99bf5a91-93e1-4d33-aa8b-12469867c2dc	b2d6c82e-a8a7-467f-bb7e-63ac91d161ad	171.66	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b640f6c0-000a-4142-aae9-5319240e3538	1f22b0c3-c64f-413d-8024-73999f786187	64.18	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a785721d-070a-44d5-827b-04ab857a7ef4	f5f36a14-bfa5-43c3-b8a9-20a73de47083	127.42	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fd028375-c823-487a-8875-2d76936ea2e6	03c06630-814b-463a-92bd-87662d923c1b	84.97	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
12caa3fa-103f-4481-9dc4-0a44ce59ec5e	f5534c39-5c40-4f2f-83e6-de7ec6effb3f	51.58	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6a4ebb86-a297-4d95-a514-c7771ef5eee9	b901d8de-09a8-4186-bd7b-1a91ad726828	96.34	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
585bf089-06ba-48eb-a983-99675e1b127d	37dde477-e2d6-4e54-b66c-dec5e43a6216	62.51	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d7915a51-a06c-4650-8323-73eabac4907a	91a6d175-4759-42ea-b1e3-290cbdc5a2d7	54.44	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d04ee0bd-072a-4945-b0c6-002a59ad4b73	200e6ae5-0a35-42f6-913b-bc134776654e	148.98	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4e291d49-4f50-4166-8a02-f168342db83b	9f0c4b13-a7b2-43e9-93e2-69f2284f915f	34.00	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
42a26997-7190-4af5-94de-408ab93cb31e	fc518724-d04c-4819-8434-8391c825317d	91.29	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f8410e18-a802-4552-aec8-17d54cbe80eb	ff4e67f8-e31f-4a59-8302-02f6490310f5	111.16	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c8f3ef16-f965-4581-b60c-54034246dff0	9e7b1353-66d0-45e3-b3ae-c9cb9f8bd24f	217.99	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3735d229-5dd7-42e6-9253-449fd64d0ab8	6c879577-300f-4b2e-a89e-6f6a8a381d05	201.13	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d17db631-30f7-4d90-ae4f-0d3b33002095	6b9da4a1-bac4-442d-bb65-bea37786e021	150.93	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3e807edc-593a-4989-b254-44a002bda924	4d60e02c-390c-4a2f-9b86-be204d1a1efb	151.92	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
93e2cbf5-8a86-494e-8bec-f6dcb3b29d26	7af370a7-a058-4ce0-a3d8-760f162febe4	165.25	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
74b81b8e-5f20-4a96-84b2-0da4932a7bdb	bc992b1a-d3a0-4cbb-b49f-c4bd23c009b8	184.68	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e9e40678-6769-4fc7-8e4e-ff14db37dffd	a19252f1-da72-4cd9-8ceb-537ba59f0d58	14.00	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2d8600de-31c3-4510-a2f5-844d1466317e	b852a94d-3ba8-4c38-b61f-c398dafeee66	153.15	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a202e677-3c87-452c-9075-fc1d61792f51	b73619e9-fc4b-46dc-8597-508b3d607ed8	84.72	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5cfb730f-b7ea-43e3-a191-ae07d6fe5b73	4749bbba-8f0a-4e22-b9e0-d0bdb0a61509	11.01	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f0b7bc90-e954-4304-b48f-ae5ea1315b54	7db24315-db93-4144-ae9c-9a809c3790db	221.38	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3d3be35b-75a0-4928-995a-420e5a8d2800	d565941e-9a85-410b-891a-c2aca9e1b016	55.87	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
70524683-bc7b-40e0-854f-97e8f479ede2	c872f669-8ab5-455d-8726-78e391c15435	49.14	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7c1d0114-bc5b-4c07-9fdd-897076fce4b2	7233fdfc-f69e-4a77-8ff3-b156e607a458	143.68	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a046ad0b-6617-4fe7-b1ef-bcac98f918a9	b13f235b-5be5-40a7-9739-7e15f6d879af	178.81	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7499c157-bf07-4d90-946f-e28196c7f142	1b8d1d04-ca03-436e-8027-fcea93faa53e	231.60	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4e44095f-5817-44d7-a88f-0e89bb4bc725	6ef8cd0b-1df2-47e8-9a5e-bbc6a45c086f	247.28	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3aaf6fef-659b-4c70-a7b2-eb2441240142	6baecacb-eb21-4755-b24b-d1f6f2dd94d2	185.44	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c456f0cb-7c7a-4665-abad-dbde48d54055	2d099782-da12-49e7-b1d0-b29b627e112a	180.03	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
baaed0a0-0c6b-4f71-ad6d-dce56632f8d7	1b389710-04b9-4756-b0e2-9a23c89d6359	193.82	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
efb57fad-23e4-4a7c-9d92-d759f48cc0a8	812caf18-a781-41ef-ac70-04da995fd38b	107.36	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f5d5ac89-ba87-4822-8e84-a539a0ec3d99	65a1bb2c-75b4-48db-8fae-cbe8038808b8	44.20	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
949c1e8f-e8ee-41b9-8999-4f23317f7c0a	78628b8d-ebdf-470f-8a42-d43a2696949e	171.16	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ca10a9e6-954c-4483-b515-bd7db2b9479c	a9bd835a-2ede-4f96-a43d-1500212a6fd1	137.58	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
74d5dc57-98c6-4321-ac42-bc3b5ce89eab	8bda0160-8914-486c-97e0-cf573cab7cf7	47.92	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3eaad3af-9aca-4b6a-b25b-00ad018bfb39	d1d6af2e-8443-488e-a10a-44b9155f6fdf	208.95	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
acdab9c3-4dfd-4003-8393-d00c77fe6fb4	35aa81ca-a01c-4910-b752-5dbb8f6c5cdf	44.05	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1d848f9c-4e23-4eb4-a39e-da982a565870	9fe68583-e68e-4730-9f4c-8fd11a38ed2a	99.15	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b433556d-4b40-4036-abc7-c2c242ffe3c5	d6a63cae-c375-4ffc-a4fa-cf54ec217b6e	309.28	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c955602e-981a-4290-b21a-6e5de92b0bcf	603d977c-a6bc-4b53-b928-4f333a6777b6	331.50	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a054b938-6c91-4139-a2a3-154d11ba13c5	77afee0d-2d41-4958-a32b-743f19543af8	170.52	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
febb8ff1-d87c-49b8-8ce6-ce3960d58ed2	653a8581-6413-43c3-9367-3d4df9418eab	204.15	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0b0e9fe5-c56a-4e09-88c9-3e700efda288	0e81a492-af85-4203-9deb-7ecb4778cb7e	151.89	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
46e4a0df-0acb-465b-8484-d5caf6958209	5bc41f69-6c06-4d2a-b2da-0861bc426662	124.13	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
71790aef-7d1f-4819-bc0c-6abab69fac95	f8d66cf4-8911-4115-8c5a-ef841037ad78	160.44	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
678e497b-09e0-44a4-9ccd-d4cb713df94d	fadc8cac-9b20-427c-944e-253e24f4ed19	66.46	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e58729ef-8e13-4f69-ac76-4e165d580de2	9a49aa68-fc63-4fd3-a5db-27fe1c7cc81a	119.36	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2181d9ec-ef04-4449-91ff-c894a97e4846	ca623a6f-5ede-4496-bac6-727fd91aab32	167.16	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b06edfd1-26eb-4094-8b3f-fb5c4b7244fc	4f0f7146-a213-443d-ab4e-2ad7f2d2eb03	248.62	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6f8e0cf1-ca63-452f-bf52-5cbe668b3172	7c926317-e713-4c22-9446-777c0c2c947c	176.80	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f4a1f109-4089-4668-a201-11892793dc80	65022266-2c27-4beb-a104-3e467a525b6f	250.04	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
21bd0ff7-679a-4f8f-8b63-a27334d496ee	744a04bb-6f38-437e-a89b-39cd8b5f962b	134.52	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5c7d40a2-6c77-4d6c-b10e-72b04412d19f	3f6c72d3-cac4-4022-b4b3-774307719727	99.80	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4a62088a-c8ed-4544-a39c-22b5cd54fe1c	b4632a54-c7ce-4729-85ab-62c131835268	321.05	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a254fa6f-a3b1-4101-9381-991102d5c6fe	263e868b-562c-4d6a-9955-9289c0c15130	51.96	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fb2ea08d-4acc-4335-9e5e-6a5ec24a573d	88bee41b-e0b7-4fdf-9c07-6602888c7097	133.36	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d7f8aa67-3ff6-49bc-b40e-57b9d99c02a0	e7336e58-86fc-4eff-ba27-79c17d9a69b2	285.38	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f14ba128-231a-4a70-8403-bd78541c15f1	838d47ef-a0db-43db-b7f4-d9525c425989	98.37	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
30803454-fd93-4c39-80b9-d96f1249a0f6	9b6a6615-edfe-4a27-85bc-daf8acbd1f7b	95.51	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
710c1e3d-e005-4ff8-8c8f-6a3ce2121575	8cd20854-aa24-4f9d-8a5d-8904c047fc30	163.92	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f3377697-31d3-46c7-8590-37b6d917a6a2	6538d959-8ce1-46b2-9990-76b550fdd3ce	197.43	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
32453a1e-e5b3-499b-8f12-dfb68b9e7dea	4c405a8d-b98b-4c76-9ff3-ef610cc981e5	272.64	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
104d8009-fa7f-4a1c-a319-c04dc46a85b9	e41a7b68-36ba-4923-8fd8-13a90b0254b3	156.23	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
29040ee7-0a63-4781-afa4-adef7ebf95ce	48169c92-169e-4bb8-864a-86d13b900042	8.14	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ee19a152-3278-469c-98ca-2ecdaf01ff6a	2c660b58-215e-418a-b99e-8f58acbc7a78	31.04	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
463e6ec8-a24c-4cf8-8074-9624cb7dd283	61af7e60-8df2-426c-be06-f866e6ed262a	89.52	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a46f7361-8fd0-4ea5-95d1-3dbd26c7ee8f	214d634f-5c6a-4310-89cb-d8e876ae6e2d	63.84	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bd9be56d-f35b-49f5-96ae-5a60c8f4b9f0	48dbccfa-d888-402b-b477-9c31e2dd73a1	152.08	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f7570085-1267-4be2-a7d0-f35d1848f67e	eb81b20e-79c8-450a-b001-da34b1c4a79c	235.87	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8fe810ef-5fc2-430c-9c97-cf8b25a592c7	cce2c09b-b2db-43b1-aa0f-27f99bc00e3e	130.34	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0225ea60-a225-4f37-a460-9d3033173028	341fda27-f537-4361-8d5e-c8f4b305f4b4	107.65	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c4e75e04-aac4-44f1-a603-ec3393b051e5	ef5ccddd-ed26-4e3c-b558-c5023abf4e59	115.43	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5e0db363-3c11-4ff1-aee7-b8edfae5ead9	e104c826-a01c-46d4-8377-44ba2c79641c	49.60	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
00a54db1-611f-48c7-b61f-ea991199c486	c9c72dd7-7e28-4230-8d01-e3001f5b3566	85.58	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3ce57c8b-e354-47db-ba57-5348b76a900b	81afdab1-69fa-465b-87b4-3052379de083	87.65	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
79ce380c-5b4d-4e0c-b95a-0a53c654547a	f63a99d5-a5ea-42af-be44-e49e6292fc03	240.39	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2a9c43a6-6be2-4d5f-8018-1057355b46b4	68f60d2c-fd12-478b-80cf-7232eff2b77b	77.21	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f1c51582-0bff-46f3-9cd3-327dc4506de4	14a4b2ea-0b28-4be7-a343-d9f853a7a947	102.68	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
70d817b6-fa84-4458-b16f-124fb93b95f0	ae5fc031-12b6-4fe6-9b93-577caafc4c26	121.62	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f13f3e3f-ecae-43f8-ad3d-936f244d90e9	d14600c6-42c9-40f2-b43e-7ec584e9b85e	126.95	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0a7172c3-73d6-4cf2-ac7a-b3c5fa12ac3e	027ccbe5-a324-4a62-b09b-bb5cd10df84b	46.85	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
85cf2dc7-3d99-408b-ab06-3661819449fd	91141b74-0513-4de7-95d4-6f7e3f7bfa33	22.63	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7f83f454-2d43-4e5f-b816-de882bce4ddb	f45e2a8e-7e31-4506-be04-f756e729ed7f	32.35	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a568a899-f327-49e0-8bad-8c412438198a	cd13dd4d-e257-4c1b-a28b-592f28d2bacd	294.29	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1cd40335-075e-4ac1-babd-037e5df152a8	8493ed3b-24f8-4086-8895-f68e6cdec21f	94.40	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
270df731-ef53-434f-afae-7a30faa063ab	a6e63af9-0001-4153-a046-6d47ce6b67d0	90.36	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fa612e29-e5b4-42f8-b892-8baa03e7a7d2	5d542225-e863-4b04-8b31-038d5b213200	104.87	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2ebc7ca7-44c8-4793-b56f-e57edf832a0f	7b673281-aff2-4412-a0dd-3723412a886a	55.94	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
01075f52-e7f6-4189-98ce-7cfcb5de7a1c	cc22032a-d9cd-43d9-817e-82f6bb1f3c7f	83.46	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f14d7721-1383-42e6-bd2b-30abf069114e	b983bdf8-4ee7-437d-aff7-f40333b919e5	157.35	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a2ab1411-2364-4f3f-898a-e028a9ba0523	758f900a-2d71-4b3d-8c71-e3f67f7367b5	9.42	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0e88869a-c6f2-4042-a811-19d25875744a	5caa22ea-c755-4381-abc7-80d72db51cc3	162.92	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c171fe6a-bd81-46ed-bc75-6008b8e3fdd1	f4880d4a-9e32-477a-9864-f955574d53d3	134.80	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
101d5f5f-3a28-406d-8c75-c9c67b0cbb9d	f0fb4927-ef91-4846-8aed-b9402d00f034	16.38	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
52575102-4b85-4aa4-9192-6c188a1ec593	7007c848-cab2-4032-bcb5-10479d45f75f	58.27	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6874dce8-1df1-4f44-a9dc-a9eb4214f425	d927c177-9948-4a70-a42c-e1311242a19e	45.08	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
44120cbf-c185-4255-9af6-c15037bc990c	519a3224-edfe-43c2-9511-3a75ec730492	117.81	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cbc1fb62-8314-44dc-b246-a13e279bd855	c200ea82-3aab-4e57-9140-751e3c30a1fd	167.12	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
738c5ad7-acca-47fc-9efd-4485ca896dc4	77174641-0c1b-452f-a71d-2050810b6cdb	297.49	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b21f56d5-a3f1-4ae9-b320-345049d1aaab	3a5a43ef-6aef-4a74-a960-e1cacbd6a165	187.83	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c7bfda85-6f06-4c5b-9e4d-caf7588984bc	989d0a56-8ece-427e-893d-375fd011dfa0	74.16	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
78c43df6-49b4-4bd5-bf60-237fe1e8b212	6abc80bf-1250-4992-8bb4-df188cd8fb2a	299.24	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0f5fb72b-2b15-4d69-8d91-d10d7978fe11	256f9c18-2dd4-497e-a25c-f2e848948316	28.11	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0f953731-6c51-42f0-a502-4c0ff8a8b6c7	50bd0e09-24f7-4178-8fd5-e87ff0a08dba	71.62	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
03f95bac-0c40-4d2b-b0c6-c798a1203696	ded6f1bd-fdd4-4468-a204-cdadc1644de3	88.20	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2761a9f9-c9f4-4f09-9d8e-b4aaadb63e2b	52a309c0-472f-4a6c-b8de-a28550950b91	60.60	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
081df6f7-ed8b-4c2f-8174-d30ab1cc3dc4	d50cd0cc-b296-4cc9-b761-aeffaa5d9f47	123.10	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
03ed0128-affb-46cf-819a-163c1dcdb513	c3623ce9-ea76-4e28-b8fc-f8816f5f3ad8	159.97	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
659a24f2-31a9-4c1c-81b8-1be395d2b131	346df24d-f2b7-4e31-bbe3-cdea36a2370e	82.39	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
87b25cd9-1ba0-48ea-8d12-647fd773ce6a	bad0c2aa-9964-491c-8591-6bab03b3d307	153.05	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2d7efa9d-0540-476d-af0c-d672c44b5a94	9bd00443-0a3e-4542-9e2e-7a5acb088627	183.83	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0bf7d876-c13b-4828-9ec4-c8cdc2856a2c	71dfc8c4-3539-4788-8280-58ccdf80f9f5	101.52	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
22877519-986c-405e-b10c-32f6607556d0	c35a205d-8313-4d52-a829-87c5b0e24b52	68.05	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f0495589-3b74-423e-bb2c-c56af0aab2e4	b880c75d-0ae5-49be-8b10-43adc2661fe0	228.52	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bfbda399-f846-436e-b090-5f79c9bea741	ab2d010d-3ddc-4eeb-8dd4-244a696014f8	51.28	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6af811e8-55a2-4b06-a07a-3e59dfe1f2d9	dd5b10f5-38d3-4c2b-9b83-70ada0dfdeed	92.71	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cda87f63-c994-44ba-9d4e-a72b14f65db1	31903a44-bab3-48db-b721-f8dc87a95d01	154.05	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7c51785a-48a9-4f09-96ce-1cb99246e86e	47735ddc-0dc8-4a7d-8c1c-0563238a8fa9	59.43	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fba427c5-07ea-413f-8939-882203dad64d	44c80533-929d-45ca-8a97-b562c26e0c71	79.09	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d460ffd2-5d11-450d-a80e-92a2291d90f2	bc0cae1d-895f-4b96-896a-2297c655aeb3	195.80	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
43b4ff8b-6427-45fc-82a9-bd526538e841	2339d2a1-cc40-43b0-9b29-3d3553a3e891	122.76	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2a540c97-2890-4fba-b3b9-8e66aebb36d1	7561b5a2-dafa-4040-a269-0cf94a64aa82	16.38	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b5cf9f4e-bcb9-40f5-9764-26da36f5acea	87ddc01e-c133-4774-a55f-6520dd350ac0	60.58	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f4e41f98-0c82-49a2-a107-68b722c9de7c	48dde4f0-57aa-4a79-a354-5eef33ab74be	53.01	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
59835451-9e7e-48b2-86c4-3e2ec94d45e2	45043563-f40b-4c9f-a96c-0b03920cb211	79.73	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
acb4c091-edce-4590-8cdc-17cb528ba9c3	295e0d0d-150f-46c7-baba-4d037fc3da94	148.98	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
34876e27-f55d-4bab-8481-bd0f295c135d	bb77e096-7ede-4a8a-8798-4d125c100e88	89.68	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
edd0f0a7-6bd7-4295-ae6d-a3cde70d9957	13a181d2-ca19-40d5-8579-513a515c0029	31.05	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1b26510e-36b9-40e2-be5b-a4f53b35424f	b7209538-3934-400c-9143-e9e7d6c85296	18.74	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3ed39848-ac2c-450c-a804-00298cf239e5	dec0af83-af62-42e5-9ebd-895fc90f4101	41.79	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a7d4f545-29e9-4c18-8d26-940637994d7b	59560717-a657-49b5-b501-d9aa3ff3ec51	111.20	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
645d959b-af98-4940-be3b-186c7e1e559a	7aa6fc59-ac45-4119-8c1c-9344048e9953	87.31	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9116c6ac-24b0-4fbd-9650-21447dfcbfe7	6bfe2447-12e1-4d99-90d0-6e0a9efae8a5	143.34	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
34e257fd-8c9e-4350-9776-63d05601bfc1	78416ceb-459c-4d24-a9d0-2aec836fff2e	26.93	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0adb5c89-0665-4e20-bee3-b078930d0097	952b9507-5a67-472f-b604-8fe86b26ea99	267.62	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4fc364c0-1639-4ce6-892f-3e6630eedaf7	6d9b2dcd-2639-4166-9a91-faa2dabe9849	162.49	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
06afb158-6819-4106-b297-ad8520f95569	32a6398b-32d0-4d54-b3e4-0280acc9c79e	82.90	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
43c9d510-b9f6-4686-9880-9779d01829d8	2df2b787-d9aa-4873-bc4b-33e936c4b49f	164.01	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3aab9899-76a4-4779-8df4-e73b22c441e6	3a7e017f-ce79-4a18-a86e-ee692c42c2d1	56.82	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4f683cdf-70c2-414d-bfa4-45c3cf2a9f4c	a8ec13ba-340b-46f6-ae8b-7ffbb8a5de6a	106.86	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fd26fea2-bee8-4887-82f4-84be79ca5742	db1575b8-4afd-4523-b5af-e940e2727bc1	209.54	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
773c51f0-e67c-4e6b-b0f9-1797c1e1cc6e	1c518fe9-bed9-4036-9c98-e21e9e9d7e0d	123.32	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6a20205d-c4ec-4706-865f-7e4446b3f51e	4a7a9432-aa51-430a-9127-4a988fefe196	227.05	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
332d2094-168d-4726-a691-66b75d37695a	285a3163-0953-497a-aafb-57573786bbd2	86.84	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6a06d7f1-8e3c-4b62-9727-d11828ed3273	6cfb3ad1-16a5-4c2f-81f9-4ef38bdcd7fa	164.24	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
77617f45-1cef-427f-9be7-c1c90f79ee42	f3683f19-7052-44e5-bbd7-6576601bf5cc	150.90	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8e019ac8-7ea6-4ed8-920b-3033df597f06	15e69b96-2a8e-446e-8be7-bf6b8f0d69fe	45.97	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c65c5ae1-1429-4579-bb8e-4e908a344246	a2774201-c2d3-4c7c-8d17-559bb6cbee19	224.73	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
54563fb2-de2f-4089-8ca3-08af1467f366	730bac3d-7d1c-4b55-87c3-694a6d0a9734	31.58	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9dea79be-f830-48c1-8661-7319ce7323df	d504604a-72be-4da3-93e1-331d02f111be	239.57	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4545d23a-0c47-405d-ab8f-5ccd887e06fd	9bdf95bf-03cb-4408-b8a2-fe2321cc8955	157.22	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c97b1cf2-4073-4cd0-ad33-63f1c6059ab6	69f5d667-1fce-412a-8f7c-abbe5f0a0380	348.04	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3db81620-9576-4f48-b3e9-b4ce68b1c612	858590d5-ce17-4c3a-8365-d283fa28542c	237.03	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
43fa79e1-b5c1-4393-af4d-fd57c604bd21	d906ec96-9d16-43ed-ac4d-7dd375bfac16	265.83	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
130ab673-c0af-486f-8b33-47335847cb7b	960efc6a-3dd2-4e8c-bffe-c113f928889b	46.54	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
96e05474-1f23-45e1-8f5a-071ff0faf805	a9aaf563-b41e-4921-a7b2-691676649aba	99.96	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a19006ca-516d-44d5-82d6-7fddb63604b7	3ebf8c52-603c-4bf2-9a52-09fde8f2fae0	61.28	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
54f1d069-1b3e-43fa-8377-394d4a34990f	0e635af7-fa1b-4a85-90c1-f17070236d65	121.10	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fd557c28-828c-42a2-adee-fe6f1e45a5a5	90953f41-aa0b-4642-af45-c432abb6d6bc	127.64	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
90d7d729-1ecf-4504-a477-4f25a27d553c	9e674928-6f91-4fb6-8cd3-1019d8dc07b6	137.45	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
eebe26de-3103-4de6-8277-63ba8bce629e	be8b33b3-3359-4865-8bad-05fa8bd91040	191.72	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
114f0c7f-f4f9-4234-95c3-9290b1e059ff	790a6655-7194-423c-b7f6-e4977b69a2e6	109.65	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4e81cd7b-a374-4550-ac9c-a7ce66e5f35b	af1814d6-b892-431d-ac1f-2f432eab3672	64.54	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fd74a17f-e943-40d9-bd64-224494cb71f5	2ac7fc00-1f5e-4632-93fd-0de06d7c1d55	134.40	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d5ca8cde-9f82-42f0-9853-03e60119e5cd	f22cbdc2-2112-4425-b850-3545060cf81c	74.26	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8749a3fe-4775-42fc-9fd1-0a4aca17071b	d41999b9-5ed9-4265-9c41-f6ac11f28998	220.31	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
95f7e6aa-4603-4517-b68f-4f9db79abd6b	f8f4bb71-1ece-473a-ae45-449381cb68bc	198.64	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
cfb9e228-b689-4818-9ef3-fbbb1cfc056d	a4acc925-8ce4-4e88-9657-9168b38683d7	52.28	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8d45bfb6-f804-424f-a39c-28a3793107a0	96b4dd91-5ef7-45ba-be9f-7bb80fb43773	204.22	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
be2703f3-8b17-417f-8e48-8d9a01b000dc	cedacfce-ccf9-41e3-8cf0-0f4a4b372e6d	9.37	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
7b511937-6788-42ff-bb4a-0779a846c929	f7701bfe-5bfa-4ab5-83da-c3238a6ed29a	162.77	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c923eb4e-2544-4cb1-acc5-98382045ec1b	a9e1d432-ded3-4c8e-869d-4ccd32094d98	172.14	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e9759b36-2f49-4b22-9385-9c17fe8ce6ef	d1d76ab6-6285-4aa8-aa69-df92a7f5166b	56.22	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
11d5011f-0842-4fe4-a9ae-f53666ce9941	ad30f787-9a73-41fd-b124-6a1aebfda11a	156.22	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
27edf1a8-4a5e-453c-bfd2-67eee596de42	c3202257-214e-4d3a-b704-61e970be82f6	335.66	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a38eb6ca-26ca-4832-9c5e-d9a0fa495588	baf7ec11-de03-496a-b695-94a970d2d3ba	63.83	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
99691845-8376-4e6f-b5d9-1bdc1e51cf8f	00ec46e5-9ce0-4407-ab63-a9a096e7f706	146.52	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
62d5dbb5-2608-4cbe-83e1-2c22bf3eef4f	9444571e-eb71-4ca4-9084-5d15554d3cf1	323.58	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1e39c6a7-2700-4790-ac0a-37421883fbd7	443975b2-2199-4d1a-9d83-59edb6c88fa6	116.01	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9c7ce525-7de3-4edc-99fa-3edc99a72cf4	b0afe566-dd60-41ed-9ae1-4219cd051f34	114.83	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
99c7415e-9414-4fe4-8adf-65ed0d3e5ddf	4480d124-7015-447a-85c2-9d4705d5a27e	40.43	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
539df9a7-380b-4082-ba2b-f22b3aa5c84c	956a682c-2ca1-4228-8af9-415aa0245200	95.88	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d6a9b2d3-e905-4f5e-90ec-4152c08cc3f7	911075b2-d89b-48ae-b481-a161c562ed1c	51.58	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9e7ff6b3-e65a-471c-a936-092aa4735cc5	eca72b78-b207-4490-809c-3a8c676e5525	218.45	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1608ca4f-e704-40df-97a1-4d5c559f07c8	776956ce-b80b-4400-9cee-51be506da9c9	64.59	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d1ca8ca4-5559-4c09-a380-1ed817abfbaf	5b5aecf2-9079-4b3d-ba20-05ef52f36a78	20.70	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5c2189e4-1d80-4cf1-9aaa-3f210adec926	6a2d1cc6-99c9-4f6e-8820-11260d1068bf	28.26	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6f457677-a6d2-44d5-9c3c-27faee50f8e0	ce549fcb-52f1-445e-b0f1-c648b9e91758	107.79	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6735105b-7f44-4a9b-b807-d61f1bbc560c	af247be4-bd55-4087-9706-cfd038d57b4a	55.62	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
12b97097-7ca2-445e-91ba-22307d16bdd4	7eb79055-9032-46a2-a72f-839223df4113	124.62	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9637886-7da5-43a7-a54e-004f45cfbde0	dcaf429f-66bc-46f7-99b4-226ac442b360	67.10	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f961da9d-c56c-4671-ab6d-d800e5bd9725	a7d38e70-9b00-4e23-b6d1-0a8276edbe29	56.93	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
92a56e5b-68eb-4abd-9fd1-3fa5f3df1c84	430ab126-fbce-41ab-8c2b-febaa31667e9	55.62	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
00aee40d-34bd-4b37-ae14-526a31087eb3	fbd51374-47d4-400e-ad4a-f6085f07e540	51.30	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
afadc913-3c59-4680-893f-a692949cfa8c	837f0ed8-f90e-4018-b8d0-f75b6d85c666	168.92	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
186d7c7e-60ec-4c32-868a-4e2f9fb91b00	46ae3a81-e550-4fc7-80e0-1b72703ac046	35.58	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a24cbc67-0328-4edb-b7fb-74697e8425c4	9c661a02-fe51-4046-b7b0-a82f491a858f	164.47	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
78882e93-b9fc-4279-94fa-6d0e9720e954	0256c3ef-2112-4e0b-8e59-a7c786b1ce86	236.98	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f656eedb-5d7c-496e-a9b7-be82360b9bb5	f91ff990-a691-471f-8042-33fe730316ee	200.29	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2bb9c428-81a8-47c1-9655-66a90dffbb65	d108d89d-df8a-4ac1-83e1-e2341191e4d2	288.92	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fa6161a8-f396-4c38-aaee-2898ca7c24db	7ce6995b-3676-4097-ac72-b769a106737c	175.94	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4970f3f4-6c1e-4ec2-a962-751bf210e89c	420ff426-57f9-4e43-9325-216b95263c06	95.80	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
950f5446-906e-4930-8ab1-308f570c0beb	90b91093-880b-41ea-9a24-f83aba5e9f8f	30.64	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1c1ffb33-96b2-4953-86ac-ccce89bba0df	800c03b7-fdf5-4b25-aa80-139a387327cc	86.14	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4a9a1b74-e172-4c2b-9d1b-b23b7fda11e0	98b5e6bb-cf5c-4c63-9a3d-b997edd4d39e	114.99	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fecd02be-6d8a-4657-9618-4b9718cc4bfb	1adc4dbe-3021-42a1-ae26-b4353f7c87ff	344.77	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b7e5a1f0-dee5-481b-89da-42b9cf31f639	8a21fc00-a84d-4934-a166-f9c52fbf9a7c	32.22	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
15a23f5c-bbf0-4a04-89db-2cab82df9cae	9a08e78a-2854-44b0-8642-9c795d5e0160	47.96	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
be35b071-1de1-4720-ad76-5798df3c5179	ae711746-f5c9-4c91-b5be-e391e9cc6c89	104.71	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3c579889-423f-4fdb-9861-46a974272da0	c6ef7578-13b3-4454-9357-33d3a3421ca8	78.57	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
44cfe59d-cab7-4b45-a97f-54e90f274eaa	b4a023a5-8311-4677-ab40-a7aafaaf1e96	215.63	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5e70219a-ab16-4740-be04-8f2f4fea36fa	baa905b9-4d5f-409a-b045-cb09375d4ba7	69.26	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c22cd0e0-7e19-403e-b9a1-5d31f0885a1c	af43b7f9-c52c-489f-be7f-3556d14d44b0	198.14	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9d15094-1c0e-4ce4-b63d-6dcfe3653d69	fcf364e9-5e69-4a1a-afaf-bbfba14ddd6c	262.18	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d7945fe6-fb36-4680-9991-11d00a4e940c	e9bf741b-e356-4441-83f2-086bb8cb80a8	76.85	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f4dd0603-e6b6-49d3-b7d9-19a541d3ab9c	ba6f660d-c3e0-498b-b9ba-b85491845eea	46.58	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e66c30a4-4227-4c99-9006-9cacc7dbb669	5ebb9650-f2a3-4250-af75-e8a5f5e1dba4	115.39	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
893d7a36-989a-49cd-857c-6fd5c80fdeb9	c6321803-a26d-44fc-9395-0d34de43676d	159.08	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4445a851-0687-410d-87f1-813b7c8a8004	b39268fb-f608-4783-b80d-1f715fb17eb3	244.33	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4151929f-ec23-433b-a256-377ccad16d41	9377b22a-92c6-4675-ae71-5b5e65345a31	38.62	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e0f89f55-eb1d-4621-a363-a2e3861d839d	7b9ca835-f77f-4b7d-858f-065d52384acd	106.47	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
dce307ca-79f4-4e26-a299-8dd7ce7e0f3f	6d2a7de3-d076-4577-b89f-4b7449155129	181.54	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
43956ff9-2748-4c61-bdfa-e8101d79f1d4	3f6adb83-eb45-4a3b-adf5-7e73d54adc24	207.94	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2bbd126f-a5fa-4321-b65a-c583f18adc3c	4c79870b-9f66-49e8-b727-08402277d796	269.72	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f778c9cf-8d3a-40c5-aee2-d7cd72b3de58	c8203054-2a79-4217-9ddd-78dd091ec1bd	132.36	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5c14735f-19d8-468c-a59e-96d14377e672	11d38443-fda6-42be-a207-ef0a45ad70be	103.84	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d159aa1e-094a-4a5e-8fde-ae9570f57328	d11a9ff1-4e42-4ce0-9421-7776dcbdd1a2	188.72	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b3831467-5f48-4c7b-9bdd-4b5953ba5e6b	c7ee0f65-4f69-4a7e-804a-1f702b4d2521	180.64	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
63fe12eb-62f2-4c9a-8b1a-987d6f0bb762	b1419a70-31a8-46aa-b225-25a765e53f8b	38.15	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
41777900-e03c-46cd-8d6b-235e3e6c752b	3bc6dd55-b9ea-4dd0-9a30-079542d6d8eb	220.42	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
25c05cb0-51d5-41ba-844e-b6af325acf9f	308bcfc9-9e15-4767-8719-0c6983362044	69.23	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b62b888a-27f6-4111-b2a2-1712e368d45b	732b56e8-8b03-4b17-b3a0-61e990538032	82.10	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
229dbb07-3fdb-4fb4-a86b-51fde8eaf044	374bd850-d839-4c27-b9e8-ee9a3f72cda9	54.52	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d9c5c117-c6e3-4830-b1f3-7006740b9e29	423b7f53-c1b7-406b-b2bf-188fb63cc25c	102.78	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3a597306-af4a-43c5-b407-74f53a974783	d61cc827-4ffb-4ead-9872-76c34dc8d400	108.96	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4a23f38f-df4b-4846-ad5b-712636d526fe	de8e7e1d-1661-4cc3-a691-785a2788c70d	240.04	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0ece7cad-dba4-4420-a80a-a534ff1e02b6	61fe448a-8ffc-4288-8af1-a66a018f6253	148.98	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
81daa471-25eb-4a21-b8c0-10ccff31db53	a8130946-067b-46ae-958f-855c82395d31	70.55	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f4d8fef3-1b42-489b-98dd-35f604cc846f	1339e152-e0ad-4ed8-a26f-7b74049677c0	177.51	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
676db8e9-503c-4353-8b5d-b984d1204335	2da40bc7-66c7-4a50-9757-e020fd04233f	106.77	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a1ded174-3f3e-4065-b7be-9925b62e8d02	5768f7e1-10f9-44e4-bae3-969e790f858c	129.14	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e0aee2cd-c4b6-4fb3-9989-d63a4b3460f4	f3c475e7-8fe9-463b-900c-edda96c58dd4	134.10	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a717e17d-b3b7-4225-9091-b6cdbf165ba0	6bd5f5f0-0439-422d-b1b3-cdb2500f39a7	193.96	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a412afff-9ef2-4df8-a8f8-68d22f161dbc	91203bc8-6fb9-4e01-9dd8-8654800994fc	52.24	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8d385c37-5440-48cf-b9c1-eed8acd529d0	27d9920c-3702-481d-b487-9eea6debc3e2	178.36	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
02e4703d-d632-42b5-9416-48803fdda75b	85f5e8c4-c991-42e4-b2ad-d75e9c07756d	311.79	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3fb09477-4bc4-473c-a432-932f11620364	a7d59742-7f50-4471-8ea5-83178402e532	66.13	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1f40d625-5cd0-4566-b7d9-653ede3a32a1	c904ffea-4f2b-4f97-b88a-842ea5504536	128.24	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
83dba317-6b53-44da-abca-a470dbef0dcf	408c431b-d3cd-4df8-9e8b-cbc1a6f65524	60.22	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c753aa53-7b7d-451a-a1a9-dbb11ff81dc9	748b8ab9-eef0-42b6-b9f6-5146fc312890	108.01	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bbe56b7e-5f8a-4a33-a716-89f7bd04372e	ccfad263-dee6-45dc-87a6-2852fc81a70a	62.43	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
25f3aeb0-60af-42e1-8c0a-79a8223d122c	025cbce4-59a4-4234-8d16-b140fe081bbf	106.47	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
85e7e298-f05a-4db4-89b3-42292a47dedf	42bb08de-ecbe-4d57-aa45-e4674f62fb9f	90.36	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1d9935f2-77f8-4a23-a864-cd5568668f54	bdb0924b-95be-4e7d-ae0f-3d8e5f3dd341	49.37	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
08c0f017-099f-4977-80e2-5f594fbd2925	1856970d-1219-4988-89ad-75f53fea2b9a	198.64	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e962f672-540a-4245-b2af-0b4417f1c3f2	69249160-ee9a-4a46-af5a-ddd22249887d	200.42	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3139b097-a203-445f-876a-9f68308647a2	844e83ea-e851-4c60-97b5-e47c995b288f	67.51	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
36d581c2-a039-4f64-8eb7-2de4efb11926	c84aac92-cbd0-4891-afe7-c2d7b3389c73	12.14	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2029225f-43ff-47c4-980e-8c6efa248572	530e3b6e-83a9-4b9c-b672-118eb36ab2b4	59.25	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
561f0c57-c088-4e52-b296-059d64ba940b	fff96c9f-6304-4684-afdc-24f9fb79f5df	7.63	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
62b88d8c-5cb3-475b-9a2e-a77b3ed48d80	4e8a3d1f-3489-4f5c-af2c-6f51c07341e6	50.90	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d9b77c73-c9ec-4e33-b838-2be84c46e843	1e99ed0c-9f14-49f0-abfd-523f5bfdd76e	191.00	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
aa81eaba-e6c1-4069-a241-7abf4b40ae12	8b02889f-69eb-4711-9264-df89b26f67e1	137.89	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
97bdf97f-f3df-49f8-b720-1ef6951bd334	a1c1fd9c-b051-4f8b-8328-ee38b3f52280	142.40	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a70ad5fa-2b37-49bb-afad-68c989f5b6e6	ba55550c-ef40-4cb0-a6a8-a9915bc2b447	60.24	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ccc2e972-8877-4b0a-87d8-ec63b6af9b9d	2a6f71f6-716c-4a01-a19b-0fa98a18b222	170.92	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
93aa8df8-296b-46ba-b7f6-9fff9af477f8	2d051e98-2389-4ab1-a628-93bf5ec9f2c3	63.16	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4a1017b5-badc-416f-8a74-36b8f261b6f7	e2e82c3b-8e64-4e76-96e8-d563e0380e58	160.85	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f1b9dd81-7333-4afe-b8db-9a67e2d507af	0b207123-e784-4be6-9f5e-0abcf15af13a	138.63	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4b0bbb09-b6d1-4ba8-b9c3-e42dcb795634	3efa52b3-9e0f-47f8-80cb-1c3f096088f2	154.73	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1c0fa6b5-3204-481c-956b-94dd305184ee	ed96bbe9-7e20-41b4-bd27-5489e2a8f5d4	153.23	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f9810298-0ab9-4be3-9ee6-918bdb233a71	5f9c0032-06b5-4331-9671-b41cdbcda8a7	44.12	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3c02e0ef-0249-4b51-87f5-3536d54ee857	f229222c-0878-47ea-bab5-ced6b3717a48	90.48	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
29dfa601-2051-4a55-98a8-0465ec20cbb8	ff86b2ac-804c-488f-bd66-a46efae54d27	117.60	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
98777481-1a65-47ff-858e-0ab865d87331	ccb60341-fa59-44bc-a85c-46fa9d1c1f53	204.93	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
facd7110-9d34-4cc8-9560-71304c0f4f94	a4a7eb0b-d59a-40bc-906e-e861ff6d675b	26.93	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
91b428e1-46f4-4125-9beb-936e02e5eaea	aec38ac4-213f-4ed3-affd-1b138aa8ad08	33.80	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0f73cafc-d494-457f-8ca3-6f6e0cd323f8	9adef5d1-e124-43e4-94c2-e3c903e5b0df	32.76	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8985b570-3953-4d99-99c1-0435cddea2ff	a0555455-7454-46d2-b80b-a2991ebd653b	63.59	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b4652352-e86f-4079-a68b-404f3b1646a8	c0ef7a9c-1a5f-4654-b898-83e64b14b273	130.15	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3117f2db-ee48-4b83-83b0-4c742ccdaf43	5ab39d0e-f629-4ac6-8a3d-7b01edb7f87f	172.13	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
16fb210f-684a-45fa-b566-8c09cc23bdca	74eba45e-0a65-4e56-9185-c37d47f39713	68.52	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ad1fa691-f088-4ac4-ac8f-738737aede57	b300059d-f81d-4370-bc96-f7d556ea0b0c	37.05	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
94d96709-7b49-4efc-beb1-0a0f73d822c1	265f10ac-9483-4a6b-a553-e485232255b4	189.46	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
58c3f59e-5463-49af-bf47-735f6dec3931	25294912-4c23-46d2-af5f-35fc7e92ab6a	233.20	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fd37a034-f75b-4b90-8b10-8994a8bcb7df	18548e01-c6ce-4319-a5bc-b92bc7660286	226.56	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9b75c24-134a-40e3-aab8-b7b4cf87da6a	a9ab15af-8535-4511-a3ef-ff5de115f343	209.80	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2921a01f-debf-4d31-9c8e-c4bacbd14343	90407b21-0a98-49aa-9517-f766d41bd954	218.70	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9607cbef-58e9-4498-bf88-5d802bcb431f	471a7a4a-811b-408c-b165-8bb9d97e9333	99.90	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2046fae4-3ca1-4fdb-88e8-c897419b6eb5	a12801b2-fe11-4f3c-9896-c8daffedb990	73.51	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fee4e528-2b1b-410e-b4fa-411f0c20cda9	11f58ffb-d5e2-4c50-8dbd-0f8cdb47954c	117.75	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a1c003c8-76d1-45ce-94ea-32ca56f79761	260f3888-a093-4b45-8859-a9dfcea45a3a	286.43	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e93cfa3a-0791-4cb2-980c-a6508ffb2f30	ffcab0cf-02b4-42ee-adb1-7d5df7c04efb	313.85	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
8cf59bdc-e6c8-4c50-8310-a1e8f1b906e7	e2e87f75-e621-491a-b819-ed4493e15cd5	68.19	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ba254e0e-055e-4957-b4cb-0ac7eb402c4f	6d28569a-b338-4225-98fd-57908ef5b29b	53.37	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
98c20381-f6dc-4cc7-b792-a558c58f2bf7	88d8cdf7-8a91-494d-8f36-db765cba34aa	113.41	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d9c5b744-d9e3-443b-8041-19f30d7ff0d3	08139a8a-6100-4041-a468-6db30403bb5e	90.13	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c191a2fe-4df4-40b4-9bc2-064f203b6a59	9ea600ef-9d68-422f-bd3b-fc110b346981	232.27	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d8a538b6-ee05-4ef9-a664-ba8659294ef0	9debfcaa-7f57-47c0-b3f6-b00efb02dc5d	131.45	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
11b55ba1-6b2f-4750-ab91-ecfec2353030	6dcf74ce-fa7c-4e87-bfe1-e170e230b3ab	33.51	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
39407400-eb8a-4b3c-aa8a-82bccc161f80	2b96e903-7f52-4636-a975-bff401c74c44	240.74	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a1689bb3-2575-4462-b55b-b4cf3d8b9ab8	000b7502-6eea-422f-94d7-6313075dae13	155.13	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5e4a650f-844b-4e18-8850-9a309bc95ac4	6e3cea2a-5691-408e-a0cb-191616d8529d	312.82	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
18fcc229-2216-4b1b-ae65-9aa98b845380	c6da8964-cf9c-432a-a5b2-a23d4676975c	68.21	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a4edbf5f-028c-4561-8531-26a1ce58b1a7	a81c37e5-8d58-43db-8a2a-4c7728d19328	251.56	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ec7d77c5-bebf-4941-9e44-e534627d60f8	f549700d-fd1c-42fd-9e6a-817dcb43fffc	162.54	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b5d6393a-bfb1-4f12-b5a6-337e49bab406	41ab8446-999e-4d57-95a6-a80b272142ab	117.08	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
402d3f8c-93cc-4df7-99a8-32a1536cfc21	3854802b-a1d0-48eb-b95e-88481ebe450a	48.34	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f6764b06-e12f-4cdd-869b-64ceb5bbaa7a	b4516995-d551-438f-9f3f-855692d8f068	28.26	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f1ed5b40-5aab-40a5-9917-a0b7f04cb616	aa6cd53a-f9fe-4798-8398-16d9c9145fc8	21.91	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
22c22f94-8daa-4ede-a99e-0c4fd5ba568e	314fe9ef-b696-4354-9f6f-4b423ed90f11	105.58	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
32f78b45-ee4c-4c3c-9e72-3b7ccef7309f	9b5c1cfc-f93d-4c98-90c6-8677fefc0365	195.65	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6c08d3c7-0780-4493-8a6f-5474ee4cda54	e521b981-c8b4-4317-ad69-60fe5a09e6de	83.54	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e5888a24-fd30-43e3-92db-2c52f8deafa5	18abcf04-950e-4943-8ad7-c24d2a243174	76.32	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
60a2e710-7810-4d3f-b5f3-4e0e804d8ec2	092640c8-abd0-43ab-8683-890f7e70ecdd	12.50	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bfa7ec64-a85d-409e-a385-9f6d2ab4d57f	47e6bbf1-6b34-4e85-8925-9b5e567fc8f4	130.76	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3a80cff1-a07d-48d0-aed4-bdb56cf58013	5a4ec837-021d-4179-95fe-b5d4c51b11c7	127.00	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5f164de9-2e1e-48ed-99a5-b0a2619f327d	e951189a-430f-4d8d-bcb8-43145128d68b	142.85	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
0223ba3c-2132-41f8-a77b-6d2f9dcc33aa	96ab7248-cd91-463d-9b08-945700f7df76	113.70	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
298eab4d-7ed7-487c-82f0-1d75cb6e00f1	189489d9-0049-4f03-84f8-ddad83c1d032	111.68	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
754561b5-c366-47c0-9a8d-6003cd3a3ef2	e9143438-ba84-4c6a-85f7-5039920e7b5f	22.02	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fb0fc7ee-a673-4a58-b06f-739250a25e61	feb8e6a4-c66a-4cb4-9cd5-997d5883a603	433.95	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b047a997-0361-408b-9a41-55fe31359d0b	f747ae81-5d3f-402c-8f25-bdc54eaa626e	192.47	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
d8e417a9-623f-4b49-82c1-de1f0a256b0e	72fc897e-e05c-4522-99cc-1c493d1a1301	202.72	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e07326dc-0985-427d-bd48-649033ccff5d	03d5b43d-13ac-4bb0-a643-081008d27809	27.91	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9b6fbd4d-9a72-4f96-8035-859b5db4c4d5	3518e0b9-229e-4c24-80bc-aa1f8f4428ec	143.10	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
ce93d526-0653-4d70-924d-97f7e0fa955f	e6e17fca-d70b-47dd-ac00-919b1d5aa42c	197.85	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b08d3ed1-28ba-4ecd-b61a-70ec0180ba8a	c650d6a9-606e-4205-8cf7-df2d042ff88f	156.06	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
50dbafb2-0a0c-46d9-b0ea-13ae098c2667	f4861aed-3b87-4f58-bf7d-98d7b86ef078	119.50	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9718d1db-d0fa-41d4-89b7-0075414107d2	d55de0b2-f528-4a25-98c7-dae44e1ac5b1	97.00	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c7083032-5626-4b62-80d0-06929f527a85	1df04230-0e18-4a30-bace-e09e4b25b642	47.80	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
45609de5-29c5-4ea7-97c9-0355eb130fce	d2656de6-f33e-4dd0-8301-6a15edb3445c	79.17	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
82fbdc36-b899-4f04-aad1-d546dba7357b	f0927e44-ab48-414a-8d49-35a79b90c033	111.08	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
42b955f1-c94f-4eb9-a173-d67b8e9bdead	0d9ed7a3-d5cc-4071-aad8-f1d5a5d8ea01	198.78	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
52ebb7e8-c225-4eee-83c7-1c66c17ca4de	42adc060-24be-43f2-b1ce-1c67f25df7e6	153.01	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5db19e61-1e96-4327-b721-eabf43b01767	f4de5f3f-07b3-4c35-96f7-7ac385c475b9	209.94	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
fbf908f2-adde-41de-bee9-df716325793f	349d7c20-bf2f-41d4-ba23-fce052efc0f5	70.81	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
60fe6c5a-654d-44f0-ae13-0eae9b1931a1	3e03695e-492b-4125-bc9e-ffaeb875c595	96.68	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
c6425ccf-cf25-47e4-9feb-3df3b8c03f77	d8a28b2c-d6e1-4337-a467-cc4033508a78	120.38	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b0b8e470-85ac-4545-b623-4b89fd3a232d	9ab2e0be-7416-45f6-95fe-420d6f467d02	122.30	OTHER	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
bf4d427c-e2fd-4460-a777-26172f0c943d	9d86fea3-879e-4f7b-931b-8a7bf33b08a5	244.22	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
887571e4-8583-428f-9e8e-0cb80955028b	69d72f04-7646-4587-94eb-1bd5d35920d8	18.75	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
08af3b5c-6240-4e00-ae6a-763cece4cc97	817d19b9-5383-423a-9852-6adbbfdf3d75	261.91	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9be68528-fd6d-4fcb-b733-4aee8fac8c06	52b5abaa-1e6f-49a0-bf75-9d131d335d29	141.26	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
3ae7304f-4615-4b73-ab4e-53a2f155bd19	1af587b5-f580-4940-9c75-b90ce23870c7	219.07	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
70c11523-fca5-4731-a08f-82e94e38edde	0cbb5b59-8f6e-49b0-959c-182b4b61cc89	46.80	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
caa744b0-2985-42ca-a32c-acf4d61ec908	e50f46d7-ce46-44c8-9e7f-36a2d3fcb092	18.54	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
a2f1a8da-4d3c-4e71-9803-7041b8dcf799	a4308cfe-801e-48e4-b987-0baa79548f52	90.47	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
5c713ac4-4e8a-4e07-9f03-c148fa61d5f0	7ee18102-0483-4786-a219-0bae86c50043	193.25	CASH	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
457dbc75-1a8b-49f5-9c34-38441694c930	61d00538-bf48-4e5f-857a-3306f66377b7	132.23	QR	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2893fbd9-e5dc-4f36-a7a6-2c9f92c4ca0d	ef9303c0-315a-43e9-a6a2-6b1901a70a77	199.24	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
f692e2b6-9ab5-473f-9416-3e4b79ee0323	5fc6c03f-86bf-4a9a-a969-06d9ee1d55c6	73.48	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
2fd9b6a8-b2e2-46d3-b975-e350601e3ef5	c4d1a3e4-42f2-40ea-9b4d-4701ac86eb52	101.89	OTHER	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4c7aabc1-7d8a-4a2b-a235-10e2fb8c7133	1f9fa07c-7152-4a66-b055-4902c535438f	184.50	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e63bf7f4-6dde-48f9-b14e-88f6ea08ccbc	7b7f7a99-10c9-45cc-96ba-10b55cb17e78	167.01	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
6c366d5d-6f2f-46ec-8b6e-96523ce10132	8c7bbe12-5e34-4bc6-99b9-7aea5fad3845	96.87	CREDIT_CARD	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
b9fbc27d-8326-456f-87bd-7ea7e04a508e	88a2d5db-9d4f-4ec8-a0c9-1716881a2b31	251.95	QR	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
e1079ae6-5a44-4838-ab0e-a9dd80ac5990	e99c6c2c-8ea1-419f-acae-701a6e9745d7	83.37	CASH	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
64b2c882-a8cb-4e03-8969-bf5ab6c20ffe	5e577719-4db6-49ea-bb62-03ffbe84021d	141.38	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
4fe54d4d-da78-4beb-abd1-d5f5deb5d0f9	b0c6c50f-be7c-4412-8e92-90bd9d833b12	72.80	OTHER	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
dfa21a5d-5b6f-4b5e-86b0-75a6d5e4c448	3d346b6b-4a74-4739-9e57-942ae8463ebf	85.88	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
15abb0fc-f775-4fc4-83fc-343c9ed84aea	17f4f2be-13f1-472c-8acb-96edb2177181	106.31	CREDIT_CARD	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
79ea8ed2-427b-4e5b-9e1e-a4213b6747f1	71aab50c-4744-4629-8724-ac87424e7ddd	120.13	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
53264b1b-7e9a-4f14-a428-e1ea502f717a	59afd7e2-001e-4ccc-882e-1e33a44afa82	163.40	CASH	PENDING	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
9da482ad-76af-4190-abca-4f28ce83d3be	c54251e6-9238-439d-aa4c-f861ab1e911d	167.52	CREDIT_CARD	COMPLETED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
1d1cfad5-5b95-4e6d-b50c-50a86c2775e5	3bec968f-fe38-47d1-80fd-ca49f40c02f3	89.79	QR	FAILED	2026-08-19 23:05:12.803229+00	2026-08-19 23:05:12.803229+00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.products (id, name, description, current_price, is_available, created, modified, category_id) FROM stdin;
f3efdb86-bc87-43c8-9d41-912d1d821e04	BBQ Ribs 9	Description for product 9	19.77	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	24051b82-ee81-44d3-8431-21c79a6de38b
010d6df1-03ed-4ace-a34e-e389424e9050	BBQ Ribs 29	Description for product 29	11.98	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	24051b82-ee81-44d3-8431-21c79a6de38b
eb53e2ca-6e88-4fc1-875b-61a0d2fe1d6d	BBQ Ribs 49	Description for product 49	41.79	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	24051b82-ee81-44d3-8431-21c79a6de38b
a3d7efd8-15e9-4d59-b159-48b9de13c791	Beef Burger 3	Description for product 3	37.93	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	2c23a3bd-bf73-4593-8df0-4deadde507b0
e34dbad8-35e4-43c7-9925-6bd49d20b2c6	Beef Burger 23	Description for product 23	49.66	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	2c23a3bd-bf73-4593-8df0-4deadde507b0
93cfa5df-80d8-4387-958e-ff346ba30ab2	Beef Burger 43	Description for product 43	8.14	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	2c23a3bd-bf73-4593-8df0-4deadde507b0
0576930a-9c2f-4a34-8181-5757c53c7af2	Caesar Salad 2	Description for product 2	10.35	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
4dcb76f9-1c44-435d-b318-7eae10573f52	Caprese Salad 10	Description for product 10	42.79	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
c49e6332-e143-40b8-9f4c-b23b547fe4ad	Greek Salad 18	Description for product 18	27.63	f	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
d413cf58-d628-477f-82db-26c2199271de	Caesar Salad 22	Description for product 22	13.61	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
e8288639-c50e-416c-93a8-bedb29c169f4	Caprese Salad 30	Description for product 30	24.02	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
1c635cc6-4c91-40d2-8924-8c01ba63241f	Greek Salad 38	Description for product 38	26.93	f	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
6e3fcfe4-0c56-482b-9766-c4cd4c257b57	Caesar Salad 42	Description for product 42	13.92	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
451e1138-e4ff-44a3-955e-ee18e8464d80	Caprese Salad 50	Description for product 50	21.57	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
bd89e6c9-5fe0-49cd-bbb6-bff9d668724a	Chicken Alfredo 19	Description for product 19	31.04	f	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	c4136a9f-8c90-41f9-b78d-3c9b42ad5891
53adfa1b-0dfe-40c7-abe3-4d687f2005e1	Chicken Alfredo 39	Description for product 39	30.12	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	c4136a9f-8c90-41f9-b78d-3c9b42ad5891
69c66949-c064-46c2-83ec-e535f5ddd424	Chicken Alfredo 59	Description for product 59	47.80	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	c4136a9f-8c90-41f9-b78d-3c9b42ad5891
2058c1f9-ef4c-447c-8b8b-403ea16d2c0c	Chicken Wings 6	Description for product 6	14.00	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	ee6e9380-42cf-4b45-9990-77ed4cee3362
a974674c-a14e-4a7d-9e12-84ee4678aa68	Chicken Wings 26	Description for product 26	43.00	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	ee6e9380-42cf-4b45-9990-77ed4cee3362
83fffee0-405f-471b-896e-95e3cc01376e	Chicken Wings 46	Description for product 46	6.07	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	ee6e9380-42cf-4b45-9990-77ed4cee3362
e7ef9c60-3e97-456d-b8a1-7fe6bfb83e10	Club Sandwich 15	Description for product 15	20.93	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	646a9069-a07b-4a40-8582-5dfd3a9d9e1a
d09d1231-6870-4c42-bea1-2f27ed6e6f63	Club Sandwich 35	Description for product 35	47.18	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	646a9069-a07b-4a40-8582-5dfd3a9d9e1a
e79f8efe-4888-4eeb-97c4-b4a9f0db7513	Club Sandwich 55	Description for product 55	49.60	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	646a9069-a07b-4a40-8582-5dfd3a9d9e1a
514aa522-6bff-4165-b78c-6b518f99dccd	Fish Tacos 7	Description for product 7	40.85	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	6068e937-200e-4440-8645-1000355131fa
8d3381e7-900c-4b5d-8af6-9fdb65f3a3dc	Fish Tacos 27	Description for product 27	37.13	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	6068e937-200e-4440-8645-1000355131fa
132bac58-39fb-455c-8671-cdf50d22f000	Fish Tacos 47	Description for product 47	32.22	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	6068e937-200e-4440-8645-1000355131fa
22bebab2-1caa-40ef-b266-639b3bb0529b	French Onion Soup 14	Description for product 14	27.26	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	96526bf4-fd5c-4c73-bc60-98a12392b05d
d04c5049-6e53-4505-82d7-c8e46deda892	French Onion Soup 34	Description for product 34	21.91	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	96526bf4-fd5c-4c73-bc60-98a12392b05d
57f39d16-c1e6-49df-ac39-e1e9870e55f3	French Onion Soup 54	Description for product 54	30.35	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	96526bf4-fd5c-4c73-bc60-98a12392b05d
46139fb3-b443-4629-b8c1-c5ac5ff0de07	Grilled Salmon 1	Description for product 1	44.84	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
a3314b6c-1546-4000-a36a-a6c776247f9a	Shrimp Cocktail 12	Description for product 12	15.79	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
2ed474ca-a098-4cd9-b7aa-f0abb53ea50e	Lobster Roll 17	Description for product 17	45.97	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
d2f7ca78-5e9e-469b-8d96-e24efccfd70f	Fried Calamari 20	Description for product 20	20.82	f	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
75ae63e4-1f9d-4493-8db0-98f20c5a24b9	Grilled Salmon 21	Description for product 21	29.44	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
bb3baeb6-156a-4b66-877a-70c3309563e3	Margherita Pizza 4	Description for product 4	7.63	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	fd11af55-3b2f-4448-abb0-5bca763c7ec6
8b435be1-19f4-4571-8643-dd261e2e6807	Margherita Pizza 24	Description for product 24	46.85	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	fd11af55-3b2f-4448-abb0-5bca763c7ec6
cc472b75-5c03-4c2d-ad64-1c5c66cf8f58	Margherita Pizza 44	Description for product 44	16.38	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	fd11af55-3b2f-4448-abb0-5bca763c7ec6
c2f85493-b833-48d0-900b-ae08f1aa9ff0	Pasta Carbonara 5	Description for product 5	15.32	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	c4136a9f-8c90-41f9-b78d-3c9b42ad5891
7c0aeeba-d877-4f92-9be4-8cb9591261eb	Pasta Carbonara 25	Description for product 25	35.59	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	c4136a9f-8c90-41f9-b78d-3c9b42ad5891
24b63735-65ac-4bd0-8ff6-f14d9e7d56a5	Pasta Carbonara 45	Description for product 45	24.17	f	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	c4136a9f-8c90-41f9-b78d-3c9b42ad5891
b52a5f8e-5cab-4fca-8b5c-d07230467720	Vegetable Curry 8	Description for product 8	18.54	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	6a82efaa-055a-437f-81ed-64e7f53726f5
b799a518-f9ef-4451-8de7-5bfbf4b75fa8	Vegetable Curry 28	Description for product 28	19.96	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	6a82efaa-055a-437f-81ed-64e7f53726f5
d620a7c3-32ec-4dca-8ed7-b5d87326818f	Vegetable Curry 48	Description for product 48	22.63	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	6a82efaa-055a-437f-81ed-64e7f53726f5
b79bbf4b-dd07-41ff-b7eb-4aef6b56ed27	Mushroom Risotto 11	Description for product 11	11.01	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	ffada9fd-cce5-4c54-9db8-3fde536d992d
a3d4b59a-f601-4155-8f2c-e48a8173bb97	Mushroom Risotto 31	Description for product 31	17.79	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	ffada9fd-cce5-4c54-9db8-3fde536d992d
ac4db68b-c6d8-4658-b652-08ad7b0d5c96	Mushroom Risotto 51	Description for product 51	9.37	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	ffada9fd-cce5-4c54-9db8-3fde536d992d
4a71ffc2-cea5-450e-8595-bb66ab01757a	Steak Frites 13	Description for product 13	35.92	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	7c71932f-6d83-41b0-8675-65c30058cfce
0572c891-8efd-442f-b53f-1c1deaae2c80	Steak Frites 33	Description for product 33	9.42	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	7c71932f-6d83-41b0-8675-65c30058cfce
1bf6bb5e-ea92-48cf-9f8b-0c602730c4f4	Steak Frites 53	Description for product 53	12.32	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	7c71932f-6d83-41b0-8675-65c30058cfce
276e4f43-463a-40ad-b06f-698be2cc75b9	Nachos Supreme 16	Description for product 16	39.26	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	0f7aebf2-f4d5-4d24-b2a6-ae33a6f1d178
cf3800aa-7129-4651-b3d1-a44125fb51e9	Nachos Supreme 36	Description for product 36	45.51	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	0f7aebf2-f4d5-4d24-b2a6-ae33a6f1d178
cd847e80-5a30-460b-8dc7-ba44da3d9c7f	Nachos Supreme 56	Description for product 56	27.79	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	0f7aebf2-f4d5-4d24-b2a6-ae33a6f1d178
717348ce-6fee-443e-96fc-92ee6a9cae8a	Greek Salad 58	Description for product 58	28.62	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	710e7f8e-fc0e-4e31-a351-9e1ff6b844c4
a6d85cd1-0f47-4f6b-9794-e05f81744722	Shrimp Cocktail 32	Description for product 32	31.75	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
689a3789-11b3-40ed-b32e-b948af298ef4	Lobster Roll 37	Description for product 37	32.74	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
d0e3fc26-42c2-49fd-8ca3-c005b63aa01d	Fried Calamari 40	Description for product 40	11.03	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
e9b9cb0f-ccf5-4b1e-9ecd-57e76bf8d271	Grilled Salmon 41	Description for product 41	16.97	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
59a062f1-5222-404d-973f-3088ac2465b1	Shrimp Cocktail 52	Description for product 52	27.92	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
b0167420-40a1-40d0-a5dd-cdfc189d0bcd	Lobster Roll 57	Description for product 57	6.25	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
1c0fca8d-5f0e-4a86-b79b-6839c9a11e8c	Fried Calamari 60	Description for product 60	19.31	t	2026-08-19 23:05:12.382761+00	2026-08-19 23:05:12.382761+00	158099f1-4154-4e3d-a1d5-f172fd58747a
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.reservations (id, customer_id, table_id, reservation_time, status, created, modified) FROM stdin;
c2db8fa9-1aec-4988-95be-1efd67cbcc23	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
592b0569-37e2-427c-8c25-541c68d8a909	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
73c13071-f59c-4055-a317-67392761a8ab	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7dc9bf6f-838b-4eb3-aa0c-efc531d9ee69	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a93678f5-814e-4809-a440-737d85558d97	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
584f3ced-ef17-4f04-8b11-bfbb6f3be663	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a71f1796-f8e3-4661-8011-e56e8728b1c7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-16 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1b32ec04-faff-4927-837c-7640b22b4f25	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d8d66d07-8784-4c60-a62a-6a859d6262db	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
db1f30d2-31ab-456e-a92e-e1b7b3d01646	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8955054c-e0b2-4c11-87e0-352ae2eb5de8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6bb338ce-8697-4c23-a591-4b0750bb0022	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 07:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ee299c30-9402-42e0-add9-5b62c8399b67	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-18 01:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
db372de9-97ac-485c-964e-cd7aec67c0ee	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
39c8fe3e-e112-47cb-a357-012375e3d021	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
603f2e5e-81bd-49e2-8d3a-3dc7bb559ed9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-21 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fe14daa1-ef3c-49e6-a3fc-0878620e0083	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
37c80360-7f4a-45dc-9fe2-8e7300194740	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-03 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
cc7710e1-83b8-48e4-892f-8756a3866841	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
42252232-ac79-4bfe-9a70-d12dc6c1dcad	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4cd9e4e9-c81d-432f-bb94-036975f4b4d5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-18 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d08da272-8b34-44a3-9690-2f49d8ddf030	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 10:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1fd81b46-bf95-4cec-bb2e-57c92189105e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8727a91a-af59-4636-a0a7-4ae2f2c454f2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
30cca771-7214-4d0e-a658-f432d41d810d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d96900be-d975-48b0-a238-038fabd5b255	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
33a33969-a0d4-4358-b54a-d66ea9556bdc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4a6bf79e-f283-4f9a-8719-aa1f0e2af6e0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a98e9486-044c-4bcf-a586-bf0b139523b8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
890327c1-04f6-4eb2-aeba-6abae8dc890c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d4953179-58be-4fcf-8e52-9ac7fdba73a3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c8bc3046-a9dc-4f42-8f61-c38c1513f8b8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-31 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5fb37c12-7e9a-4259-9334-3f024338e4c7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 01:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e1e6fe64-12ef-4280-bc51-fba2a15306a0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
14063024-7e2e-4592-b411-09160adb07c3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
46c8705b-3e5e-4dc5-a49d-03fb356c1783	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 08:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
44610702-9bfe-4b5e-afda-81744c9dd952	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-10 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
93d51077-1faf-4d6e-9dfd-a0b35cd2e9a2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
150f81d8-fb68-4239-ab2d-3416ffb05c0d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
cd746980-eac5-4997-b834-5c7b0794bd21	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d8fda2fd-6c6a-4880-95a2-ab8b2b798a5e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8cf6860e-34eb-43c8-a9c3-20a5d9b4fa2d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-15 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
603ba1c6-13dd-43d0-9b84-f9b92e67da51	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6ead3aab-30fc-49d8-b5b4-8a7e1d812f23	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5781b0b7-6bad-415c-a24a-ce88ab1078ad	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a7bd6b9c-254e-440c-925c-7dec1b556b3b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-08 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3abe53cc-936c-4adf-affb-b1be73f1963b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c7951eff-092a-4b64-8283-9548c8e4c907	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-17 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8aed7f32-ef7c-4c6d-8e08-9f2e0ebfab9f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
410f7c7b-505a-4dc4-9c20-49a8a1cff4ba	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e573a196-1517-4ed3-ba17-978957a18bd9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-17 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c2a2214e-2ab7-4df7-900c-758d7ddd6ca8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 07:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2942fb02-af13-4c24-b666-8c7d3e042871	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
07e24e66-bab1-4c61-b38e-e998c73c40ae	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8eec9b35-252b-4984-a003-c54c04516493	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
372958ce-f7a1-4b21-8b6c-4ff320d1478c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
34b61d42-f087-4921-92ef-4bfca9b0eb38	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c3276e00-bddb-4e55-ab7b-ad671a4a2e79	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-10 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
320d60ab-d3b0-43e2-8c99-5143b6791db2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
87cafa7d-d4d9-42a6-ba59-cee2d1b8f6b9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
39c8823f-cf8b-4cce-a914-3995cb811a25	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-02 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3a503718-a96a-4158-9025-5f45df8befe6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
cf2bf78f-bb67-4c9c-9ccd-f5ccdf9a0513	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 03:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
33806a18-23d1-4d34-9daf-a4be201178a7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7c0fd7b9-ebcc-4815-bc04-8ea1e0337f90	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4cd8280d-31d7-4b06-926e-5db3e05e106c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-28 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b3134400-9010-418e-88de-6d0da83f2bc4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
20451514-e629-4cd0-8792-a1381758c400	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1ce7a4d1-7b4d-45ad-8930-e67ab1e7df95	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
40395fd5-e81a-4d11-8294-ec28bc83bcc7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
626fff8b-7dcc-4e65-ba4f-4de5846e8e9d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3c237385-1f6f-4147-bab2-df15fdea3bcf	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1a149899-c7a2-4eb5-9be1-90b47c8cbef7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0a11bad6-2627-46c6-a865-d96390f701e9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-22 03:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ed672ead-192a-4a51-974d-7f4fabe60f92	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-28 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
059dc657-eef1-49c9-9b0e-cc67a063b289	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d9eb2860-69a6-4459-854e-14f1c66a772c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-27 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
10c7c404-1754-441a-9e40-4e66b8010222	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e58e885a-8321-4b8e-b8a8-a43b48ab2842	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9324e5fa-8518-4348-8a63-e11431546f5f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e0ebd3a0-5b79-4277-97c4-930edc014cc9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-18 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
968eedfe-b31c-4acd-b314-4b6dd52fee93	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fa870bf7-28ac-418c-9030-2fef4424b887	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c88dd674-dcaf-4d7d-a072-bc4430cb5379	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ca3fb0ef-8b02-4175-a582-6ee93115b03a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bed713b1-9365-4b5e-a1ec-c01ffc5e8193	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 10:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2c3a3931-5c7b-46a2-a605-326c56d793e0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b6a50259-77f8-45ef-94fc-df01fd950c5a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2936d086-18de-426d-b544-76fe323a3f07	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0a4ae55b-3173-4b8a-b2e8-fc28f0f4d764	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-08 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
07b5cc48-e6a0-407e-ab2b-0d04a58e0ad9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-08 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b4dd798f-a16a-4bb4-920f-e3e48c602c7d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f933c565-42f3-4b23-88de-579da3a6f20a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
55df37dc-a745-476b-abb4-7787185e97cf	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-10 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f0241fc0-1d67-4df3-a075-ed2effada6d6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-02 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
271ee157-fa8b-469d-b145-d3764ec08fab	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-08 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
340e0963-c5c4-444d-92f2-eaf64c8e8c3c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ff833650-38d5-4e88-aea9-8cd286ff2860	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4e994a7a-bf91-483e-adf4-cf257c064892	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fdcd52ae-4886-4bc3-96bc-7f4a390ab81c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f1da66d4-b329-472b-a8b7-3e01eba884bc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
39dbb1f2-8aa2-4d4f-9e56-87b0da05d781	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6edea0a7-e2de-40a3-9f98-c372a5d06e0f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a4defe67-17ba-4276-a84f-58aea4335994	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
290a2e88-5546-4096-8418-2337b9801317	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ebd7083c-8cff-47aa-a458-a17900b24f5f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
032a2f89-84bc-435f-9879-1b9098c1c2c5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
25f8cf38-eb75-4bcd-bb3c-2edd5311e0cb	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2f40032c-11e3-4118-b802-a7d8789bcc5e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
03c8a80a-3e40-49b0-ae59-486cf1f0fbff	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-21 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
42696353-8a23-4360-a088-ad074ba047df	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 10:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5206ded2-96cc-4f8f-b65b-8e44fd5badc2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-11 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c1d38196-62c4-4936-94a0-9ff72b65331f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4bd3a741-4c57-454e-97a4-21698d07110c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
54b88d5b-c0e7-4a36-b6c7-8ce4015b9ec2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
08dbae42-62d8-46c2-8aa5-e6b2123d23c9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ef518acb-5d85-489f-9a5d-9e8aa954e0a9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-11 09:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8fca821b-a6d8-43d5-b858-986adb7ab801	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-28 04:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
06a883d1-7da5-4a4e-ab5c-11ba6914e419	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8d1b77dc-117e-42f2-9904-4c3833ddeefc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2cd0efb8-5562-48d8-b700-a5762bb08573	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b9903cb6-1213-4729-bc66-a10b54e24216	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
62df56ea-edfe-4213-91e2-5c9783a4028d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ab6e8113-5c1e-4a02-aee5-87330eb31e13	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f25625dd-7382-4ac8-800d-255aa26d247a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ef1ec0a2-af54-455b-a497-6b7850ce0918	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-17 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
06803589-09a6-42af-9da4-af07f1d1b917	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-18 01:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d881ae92-7e61-416f-ab99-40469d405550	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
601518b5-075f-4705-ae5e-434fcc7300ad	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c88b10fc-960f-424e-8bc7-b0e3380af8f4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0b83eaf0-e5fa-4931-8a3a-3a60bfec9b32	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1a295b9f-70f9-410a-ad75-c00479c566a0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-18 04:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
83b2ab52-95eb-470b-97a2-aedf4bdb44c7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5814bff2-e17a-4738-bd94-8bf52d8d8b61	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a7729db8-e5b7-42ef-93cc-942542de9f4c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d648a6a8-bbec-4d2f-a988-f3c382a43e8d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6e53ee5c-e25f-4825-a69a-1ae86cb4619d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-02 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3cafe504-3200-4f43-9d88-83fdc4d4e357	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3481573e-14ff-4568-b473-ee6ae02329ff	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c1e4d535-c619-47d5-8a60-5e8bec1796c2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
112f0c05-25d8-4bfc-b97b-681553e880b8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
be38422b-8526-4cda-8ac7-7ed8812c0fd1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6944c86d-7387-4c1e-8e36-3908cb922310	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-08 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f54a24b3-8d32-4add-bf37-27b1cafef749	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 08:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bde6b682-9a4e-4c7a-97e5-4eb98313d163	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c5ed139a-5a1d-411a-8e59-b1522f378c8d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
51cdbf93-a7e3-4fd7-8c2d-aab9f2695675	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 01:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e180ec02-73d0-4ed4-b701-6abffaa6a267	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 03:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4db9eb8a-6cc7-4aae-a441-0b218e7f6986	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
08f5d86a-6cb9-4be8-9643-880f92de025b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2d476343-0fe1-4a85-b1fd-e87f032337f9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bb863308-1614-42fa-a809-f88b628812ab	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-08 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9765df7e-1c8a-48e1-b97b-9e08f2efce09	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
31ba9a6e-d6d7-49bf-9591-bf609735ad6c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-08 04:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b14629a6-01be-4aa1-9df4-4bd2fb316ffc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c15aa40b-bfce-4d07-8f8d-7365ef45ec2c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5b412f4f-225e-4b43-98b3-205cbe752f7f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a56d6f14-7694-48af-9761-301ff882c86e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5310f67a-2099-4176-b9e6-2761432f9870	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
31bca42e-c1c0-48fc-b8c0-bde088b1f380	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
43e35f1d-fb63-43bd-a68d-09dabbacd960	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
51c2739d-c5cd-48dc-b803-0b766696935f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 10:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ecbe7b5d-9ef7-473c-9fb5-a310c98673f6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-16 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
21522d30-8f3f-4152-ba7c-4ee3d204cf81	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3539ff6b-14ea-46e1-ab74-d0fb2def1222	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-21 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4ceb2557-64d2-4eae-b8c4-6b7c182570bc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
589d179b-a16f-493b-909c-47ea0955d109	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 09:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
576bb7d0-43d4-429e-961f-6b44fa687283	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bec9d3ab-8349-4f8a-8115-97e0e505d507	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
49d14e6f-9d7f-4755-968b-2976775c836c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5f1453ab-1539-4c12-a472-3849e4ba8bdb	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
62cedba4-15ec-4922-ad38-253e4e6e0c3b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
74b18ae7-120d-4c11-82a3-e8d92fdb71f3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
54ccae13-930d-43cd-a5e8-9d2a465bd0aa	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a9717576-a010-49fc-abea-a36f8fbcf056	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0ed9a485-5fbd-4ccb-ac38-cdba2aef5174	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
92180226-e0f4-4252-be60-be3a5301253b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-18 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
97bb052f-ba46-4adb-a4f0-aa4c0ef34af7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-22 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
18aef358-8abd-4569-84f2-811d6ba4baa9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3d3e0f54-1063-410d-bdbc-5e094bd9a4c3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
567feee1-4a0e-4d2f-a989-886c99b4ecef	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-17 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
01adfe96-2c32-48dc-a070-03285c378ea7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-17 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d365aa03-38e3-4266-9d4e-efdb30f6ca8e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-18 04:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
faf5f320-8dc1-4248-9f4f-62d83e838bee	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
93bd40d0-a50f-4f26-a0e0-a7f34901df17	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
efc1150f-c825-45ed-a619-92ae42d9b549	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a7ce207e-7b17-4783-8820-f8e997c14f91	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ce06b33f-985f-47f1-8eb3-30407cfcdb4f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
cdcd95bb-d3b5-4f0c-a1cb-06f9a3c84395	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6e740c4e-d63e-48b2-8bc5-54b4a28ca6a1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4410ef10-00f1-4d00-9218-6bbfa0ec11b7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c46f6e47-e59d-48ab-9d69-c0f95837d396	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2e792fa2-e4b5-4d91-b3fa-d238bda54f6f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
65c4690f-5604-48f5-83a4-cf9ea885ff5f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2a3da2dc-8fd4-41e0-83a1-32fa6181fa1c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6df71488-06cd-43fa-8b08-f4d26b5e452e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
114d6de2-a80f-40eb-93b8-1daa0f247e19	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-03 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
92930a95-299a-444b-80c7-35774a2b6e07	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-16 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
60feb735-83f3-4229-a1aa-94268c51617a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-03 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
75b679ba-769c-49c0-a54a-165035951711	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
28a78f4f-e932-4fad-82e2-2c00db14e224	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
540fad2a-74cb-413f-a74e-3e2240a876c3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-02 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f717c075-311b-4b60-8118-17053a10c616	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a444eb7b-3aeb-439b-a9cf-16c916405741	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d965e602-722e-47de-a67e-79281cae80b5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 09:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8ce89c2e-a208-4ede-95d6-640311dac5fc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-28 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
465adde3-75bb-41aa-b311-c3607c166270	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a25e8b57-c228-487f-89a0-4bd65d3e6f79	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2d508e24-335e-4640-822b-40a07a7994ab	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
148aa168-d18b-4a0b-bb0a-09b96ebec09e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
571d6a14-3db1-4e1e-a871-2f9393ad487a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7d041275-e954-4740-90d0-278bb2d82a28	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 07:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
573171f5-2886-46d6-9865-8524dc19c00f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3e1bf21c-b26b-49ca-93ac-888df3c30518	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-05 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
21fd5a5c-7378-4cd8-8618-398062346e0f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
398c5279-895b-44c6-8aed-9452662d68b8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
088a5d75-9a19-49c2-a0f0-f8b5aba98f1c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6e00287c-9a34-45a6-b0ff-78be791f3485	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
194489a4-d892-482c-b565-1282d68398a8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
28a2e3f3-bfa9-4d11-a164-2006702a04ce	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
199560a3-ede2-4c2c-999f-d6fc41a654c6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-09 08:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
175d4e27-a7f8-4ec1-9fae-b9cd44d4c5cc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-15 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
467247e8-612a-4847-b487-a8becc8c8a35	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0606f725-e1ac-4a3c-8fea-079dd03ce84a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-28 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3d04d78f-c251-48e0-99b0-d40134fb5925	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
900767da-d7aa-452c-8b35-1c3aaa961956	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-11 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b87f89ad-ce94-4cbc-bdbf-44ef0d2f2b8b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0635f24e-d667-43c0-a319-53cd91a92f5d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3593e616-10ad-4b1b-abcc-93daaf5491b5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ea5c21d6-b24f-4c63-beb3-9578a352a704	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-05 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
86c4510b-94cc-4392-95be-70448c03d921	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e58305e5-50ac-4128-aa7a-483ce955eb4e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
94228046-9ec4-49df-8979-cb25b64a8024	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a6e09756-e3c5-4132-a245-40da0d138233	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6b48476c-0fa0-417f-b927-967b3c173321	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-05 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ed5527fb-57e0-44cd-ba2f-67d1612f9798	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e328183a-d7be-48f9-aa65-7d44b8c35450	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-31 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
62903329-249d-47c9-aa0f-cf73a8a4d181	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 09:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8b951fee-4b80-4f64-94ef-b6c90caa3209	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9f5c566d-a278-4a0b-8b30-859314909a22	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9ddf5fdb-be41-4b03-a7df-4d856b1bfe51	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
13bee204-7766-423b-a3fc-ce8ad217fead	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-16 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
24d24686-bb2c-47d3-bf82-04166427c4c3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2abce4d0-c464-4d48-9a43-856a7fc4c44a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-15 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6df94cc7-499f-4287-88e9-85afe3018825	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f6476bd3-2280-4b1d-901a-b82e07e9ec5e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-10 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b7c44962-598f-47af-a8d5-1b0624fbf60b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6e69e8db-d48c-4ac3-8412-557a4a4ef51f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c7f6b253-4b04-47bd-ae80-c8f491a079e1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-03 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
33b0b5f5-e5a2-4d76-89c1-2f110d1b4501	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 04:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8c98446a-9a4e-4b63-9af2-ec109afabf18	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
14e01e1a-1090-464b-ab24-e59601edd51a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-21 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7861de5a-7efb-47cd-9461-a972f5f64a48	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b1219716-b668-4741-82ab-02eed288aa0c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 03:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
98838845-ccd4-4ff3-afa2-c980260f4c17	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c053cb6e-e009-453f-82cb-15065d5112be	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 03:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
80f4bcf4-2c38-4bc9-8572-2dfeb14ce96a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 07:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
377be45f-24ae-46f1-8c3c-d9c1abdd0e22	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5df48901-4b10-444b-9510-0d85da7b97fd	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f17a1fa9-be96-4243-8009-e00c49f92c9d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
438e10c4-c288-4f43-b606-33fe576247e1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 07:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bfac5082-ea4b-4fdf-97e8-f1297c3c0067	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9107d69e-c7d5-4aaf-a170-4960a370e1d4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
26ea26f8-7354-47de-befc-d7380fe5c1c1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0b167d92-f8c1-41b1-b8e9-30ac4dca9dd4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f2224e47-2c29-4af8-be7e-95dd8eeff66b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
da1c6208-f08f-4851-8210-0721f04af4fb	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7d6293d2-28ae-4e54-b23e-5f8ffa28f2f3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-08 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8bd57037-f6d8-40ff-b701-f9222bd0e406	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d359514a-1bad-4b21-bdfb-9a729af59bbe	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2786047b-5138-4983-89da-5cddaaa788e9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0f5b9490-7ec3-4fbd-a8fc-29a6986c67bb	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e7d9749f-1fa7-4565-8866-ccfb04df07a2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ee497591-d634-4b81-81ba-033c065a710d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-09 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fd735657-7269-4bfe-a2fb-bef3bff19713	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d7b70404-2f17-472f-bb2b-4372d2ddccdf	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
acc14142-7945-4587-9c7d-4571decbbe76	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
334248c4-d170-4d2d-be2f-6062fecb3cc6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-11 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1caa4120-8286-47fa-9ea2-e5cdd55fa06d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 07:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
18889780-8493-47bd-a89c-639013d4c395	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d761017d-961a-4d39-81b9-85c589430e6e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
294c44bf-a9cc-41ac-950e-136cb3c8a369	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
40638dd1-2efa-4d31-b69b-ee42afa88806	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6916fd6d-5ce3-47d7-a52c-4f2d485f3d4d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-21 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e184a8ad-5b7d-4cd6-8173-926b73cb8ea0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
12542c66-2a2d-4968-b0be-ae12cb6b3885	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-21 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1193e77d-4875-452e-9bfb-5ba06b779f62	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c8d468f5-ce1d-471d-894a-47f1a88903bb	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2fc7ecbd-25ea-46c5-b7e3-6a6657ddad63	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-22 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f9e0284e-d075-4ca3-8195-c96ab066f886	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
85bb8175-535c-464b-9584-09c404a727e8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
240423f6-6fdb-49db-86b1-da478e21c37e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e4de0d1e-a8a0-447e-b6ea-f89f5037912d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d5e145a7-e709-4e1e-ad34-3a687a9c30ef	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-08 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
22b4abca-606d-4925-a668-eed6bb6f53a3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
59ccdadc-c92f-4a75-8d4f-72425399f14e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-09 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5ce442d4-ebc2-4ce5-b829-915cfc3fcc97	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8f75eec5-c31f-4dc3-a9cb-85601784f830	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-02 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
378daf14-954c-4c51-aded-c2102bf5a17e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c7ea36f2-ed0c-4371-9c6a-930dd6f9bddf	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
cb5301fc-8519-4084-b6db-3e7c8fdb1f3d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d98bc931-50bf-4a20-9943-35712939d090	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
324bd96d-8251-4a7e-92e3-6d8f441cd0c7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
57da475b-7974-4f68-896f-4c467b708088	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
be78ff2d-d8b0-4a93-9b8b-0f268f1d390d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
83c67941-f189-4644-937f-5ef084889946	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 10:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d1c604fe-a172-4fc9-9254-8a26d3d04dda	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d800ef86-616b-4025-a2fc-c093c92d8fc4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b1aa63fa-483a-4671-896b-f3e3afb8bac4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 08:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a1525c7c-e662-498a-9bcc-207ea604692a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-21 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a49af5ee-8ccd-4341-9fdd-7cc5ecdff42e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-31 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6a3596e1-240c-4b4f-864a-116352308528	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a359decb-ffbd-4a67-b316-6740edee2c71	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-16 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0e3aacf7-65ea-4796-95c0-70e9502e4b48	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6f03340f-6cf2-49e2-843d-072e4cf78e41	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-28 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8edd4a07-7175-48db-bb22-5e9c354a8d62	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-12 09:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
dc4a3cdd-0b0a-493f-a404-02527a87c9dc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
76c4ec95-3eee-4a55-bec3-f673e302b0c7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6c288b06-82e8-4d2f-a762-0f5cb9564e74	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9bbcdd75-62cd-430e-96de-554b3cb82ca3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-16 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
99e3d0f8-5b1a-4993-bf1b-442732b073cb	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ccf4a5c6-6881-4801-86b2-6b0803289fe9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-24 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7549e766-d0f2-428e-a8ee-06eae8824a90	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-09 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4496b67c-5e65-4ae1-9a49-0f675f3ed7f7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-05 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
367ac2d0-290f-40e1-8f14-3df56dc8156e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 01:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d7987a74-b78c-47ff-bc9d-275c44be8bc9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9c2eb956-27fe-4f2c-9327-6a0953fb4f37	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-02 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7cd16842-7a3d-48f4-9f49-66ddbea9e0ac	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-31 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
306909f8-cd2e-4a7a-821f-c62a4ae98509	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f30daefc-6b23-4020-b061-d8b72182ae4a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-17 01:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d2dc1486-f65d-4851-94ac-4bb08ed929e6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-09 01:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
284035f2-7692-4f9b-a033-36b76ed04dee	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-22 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bbf37be0-a40f-4441-b518-8732bf527896	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-21 06:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2d7e61e5-1ba0-480e-b097-967b0441aae2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
70541337-7aa2-4d01-9651-deaca51bc3a2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f88488c1-913c-4d08-aecc-d984ccfdd15f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9aa18138-59e3-42cd-8d39-90e7d1235978	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6fa2bfce-c3a2-481f-9014-738aea13348f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d2b8ef36-e576-4811-80bc-a56356631666	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e276572e-4fde-400e-b652-2525e96a0aea	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1b9d6c9f-8206-4742-a842-35f55ab6fa2a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e02f8a87-bfd3-42d0-b714-96936cb91fa5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-03 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2644e5c4-cf5e-4f9f-9b54-f6e6fa254ad9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-31 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
66eeb97c-1d65-41a5-b000-e9a6015ac399	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
268bb9e1-f8e7-49e9-8c8d-0eab3cce27f0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
90ece0a8-ac88-4720-ac4d-ffe9cc2685bf	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a90531cd-c688-425b-bf53-81bfe192dcdc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7dfd279e-d7f6-4c76-ad1b-130b384b5031	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2bf60380-b963-4208-adb6-de6c62aa5d6c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9997c041-d326-4a41-ae60-4a767059970a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
28654a33-2b9b-49e7-9ea7-27f44bab098c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 03:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3175109b-5e46-4b93-99e0-00eca84737b0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
90b442c7-73f7-4830-a5d7-7cf3b9a9ee67	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
98fa3db1-ebec-468c-b5af-cf2e1dd755d1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
72a4c61d-affa-4352-852b-996da4d8fae6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-10 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
84c38f2c-2c77-4be2-9d4b-a2306fcaecd7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1384904d-4d4d-4f07-84b5-f5bdc64fe704	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1358bc1d-2809-4cb2-b062-f74104e304f2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-17 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3ebd7019-c910-49fb-8632-b7e219ea5e72	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
639b1a96-d9b9-48b0-856f-93938293559c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e668a503-12ed-4283-862a-3a015e3f04e5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f6eaeaa6-21b2-4d67-8138-e3c2348304e2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3deb4167-c324-42cf-ad6a-8924bebcb876	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6de8e39f-fb3d-4684-8d0d-47700507ec23	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-09 07:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2a6d903a-d336-4f9f-9f47-e788a19239df	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9635fc33-9075-4ada-acd1-8e3167fc0bb9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-10 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
23dd7492-f023-4766-a90a-7115a92eac67	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
96bea443-7416-404f-8a52-978cbac53155	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f43a40ee-3e4d-4d23-8f24-6900080acc3d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a9eb210c-75f3-4f2b-842b-23eac41679b8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-15 07:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3f69e014-73d5-4185-b724-4329872932db	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 07:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3aa7053f-de4c-4897-bfcd-f850f2eb2475	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9cee89e6-3b30-48b7-8de1-528d1f29e300	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-02 07:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f05e853f-9eb6-4faa-b883-674d01366716	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4d32fdf8-19e5-461e-a589-d92d506bcb21	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-27 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2a26397d-a1f3-45c2-a80b-ab7902722e43	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7bb23184-cc32-4513-bfaf-db21e11c3108	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
28fee21a-4145-4b92-b725-889aefbc9ace	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-27 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2596b1db-2b05-488c-bdb5-4b21079d09f7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-29 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
40eaf701-b805-49cc-b5ea-7a435438dace	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b10294e9-50eb-4a35-9ff9-0acb83eabe75	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a734b680-642f-45da-8678-4a29bb2aac7a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
235c3e00-012c-4455-a606-dc2408cd3945	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
81137040-710f-4931-8032-974ab7baf6b0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
129a24c6-a8e4-409b-a938-ca8c57b260ca	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
63d6abbd-b28d-4b34-a3cd-22207017b731	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-05 09:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
561222fa-d667-4382-ac45-081d1ec21273	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-22 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6057c833-2d4d-41d5-acf0-c3fdc05d5598	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b75642b0-cecd-461a-922f-49cc384c6cf3	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3e0c809a-2e40-4b2e-b02e-72ecd57304ef	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1de6b05d-d67a-403d-836e-0e043e999ff5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 23:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d8e8036f-4a02-4524-9445-7e6548b9e211	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 04:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ce8cea7c-c6cc-4d4b-aa7f-e6130e95a00d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fba82101-8a50-4ad7-aa9c-84528d5c1cb0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6916744d-a9a6-479c-a28a-d7aa3043cd96	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-10 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b7723836-2d94-49e5-9b1a-0f84b2cc5cf0	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d986b6f5-b3d3-44e7-a295-79b9121654a9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-02 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f92d64df-8d79-449e-a537-420efa5a0451	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-23 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d89b9d1a-b74f-4422-89b6-a8e98fc7867c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
df7f189c-f450-4b48-b254-15a8d3150379	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 08:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
aebca968-2118-419d-ad05-5b0326a0a280	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
faa2b118-59f7-4206-97f8-2cc9c79df5a1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 04:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d49c949d-754f-4b9d-adb4-45b72dba8ae1	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2663c28b-2b3c-444b-a4d2-3ae7b399d5ae	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9cf6ae96-d8a4-461d-91ae-9f1f1427234d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fcd54120-46e7-49e5-9ab5-574ff3016e68	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
78fe0597-6f54-40c5-a78c-1ef822dd4711	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 07:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c29b69b8-53e9-48f5-a953-8b8119bc85e4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6feea0d9-26d8-4fce-a43f-d1032da3857d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
381395c9-dc1d-4d89-9f0b-7b5958c88bf7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 09:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4fc77f1e-3e8c-4ec5-a1db-8ce39cf12536	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8d535292-4893-48c5-bd3a-566d07317aee	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4f5143b1-25f8-4052-92c0-41b793a0ff45	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0745ff5e-0808-4a76-9705-56d30aafec79	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3c44793e-a975-438c-b42e-adde2112867f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ee8ea55a-c033-45eb-ab10-50c503c82677	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-05 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b09ab7ea-05fb-4acd-bdea-7aaab9cfd85b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8b6629d2-650e-406c-9f74-ae5b35552f3c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-17 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
991ded0e-a6de-4c13-887a-0ed750cff247	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-08 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c0297bd8-f9a2-48d0-aa7f-5a134927949c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-08 10:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bd9aca3c-5a7f-4ec0-8379-b8020204d8a8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-03 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
afd23a2d-206e-4fd9-b0da-effc57949043	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-08 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5e27a1b0-63b5-426e-96bf-b9cdd9f715b4	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-26 06:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bf722eea-5160-40ed-a82a-6e2d3ec7e9c8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 07:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
274f3e03-2363-4628-b24d-6953bcb0b43d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-15 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
126368cd-5c80-45e7-8cb9-98cd0031fcbe	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a42dabd2-86f5-41b1-bd51-61c81ed110ad	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-29 07:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
98a7b80c-9504-461a-b029-325bccbed64d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-03 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0809f032-8c82-4ecf-b758-161efebd073d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-07 08:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2c86d566-84ec-4d76-a755-df30fa86adda	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
89e51c56-8302-4ba4-ab9a-b3d5eb6a04bf	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c02183c7-da6c-493b-b383-5f79804a6a61	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
02a7ea08-c84c-4926-8d8d-608d2f0272b8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8d95a1ac-85a6-4df0-8904-7df10e5fe33a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-15 08:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6898eb10-4932-4519-b43f-3bf02eac5329	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 09:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
96994095-080a-4370-b217-ba96ee4a766c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-10 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d49cf119-1892-4431-b650-47ffbfc421ca	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
78858098-3536-49f5-aa96-3d654cbf2188	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 07:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1241b648-a81a-46dc-8a77-f35e4775379a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 09:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3e7665fb-d283-4cf8-b1a1-be636d98cc2f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-01 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b2eb8fbd-e820-4edc-9e29-920df095d415	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-21 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
207e955d-e741-4587-9018-26f79d2c7c3c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 05:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
07510b32-9132-4e32-89b6-381382544fe2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fffb8e29-7ee5-4b6a-a927-0f10559dfe1c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-31 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ef611b2f-c348-4d10-938f-541e9bce2841	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6614ec01-2cbc-46f7-8ccf-b684b9690fc9	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4cd98b00-ee4d-4563-904c-a12e9b934c1f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-31 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e4c85d57-4ce1-48ec-9c5e-bc7d2eedc74c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
75998e00-7a7f-4560-88f9-b9804e7b363d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3b64de44-c256-4b63-b273-8eff9b77b31c	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 02:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
68d3fe59-cc4e-4dde-a06d-83e5a93f0832	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-15 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
63dadbc7-5e7e-4ab1-9a1b-4026cedddf7d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-01 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1478dbf8-d673-4a3d-a5b6-798059a3b6e2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-09 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f4bc4c7c-d4bc-40e4-a27b-c675a2aacf2a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-13 23:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
5999e5cb-8155-4427-89ec-4b640100ce44	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
9c238b47-e478-4c9a-a7ac-7137818c8bab	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-13 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
14ce8976-92c9-4429-859c-e75728f70b28	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1b65c9fd-4a60-4d59-902c-1a915a0e3b06	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
cc81e3ee-8ec7-47a6-8412-306ba48b2c7f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-06 05:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e10cec12-118b-48e9-aef7-5959958d14a2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
23fec03f-9ac9-42c6-b415-5c4b44471083	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 10:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
3e9218b9-f1f7-4864-991d-9ca0b7b21a08	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fac56ad6-10b2-444c-9001-169e8eaf4a1e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
8be4c95d-0259-4eb7-917b-29efc4baacf7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-30 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
e3ffc085-ea5a-45c2-8e43-dadfa874f898	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-08 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
11a88df7-cec9-40d7-b1a5-fc8315c2933e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-05 10:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
85f1d61a-8775-48ca-80ed-5fca97301f64	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-02 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0269b011-65bb-4053-a827-365425fe1aa5	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-11 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
77903c05-2a79-48d5-8d22-303d130d90f7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-04 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
0135e0c8-9735-4940-8335-6c28f479a06a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-02 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7d52a617-51f8-411f-80f5-fdc840398c6b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 02:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
2e356cbb-ac30-4a86-8f6c-7c0472da825a	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-14 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
25a31712-1979-46dc-aae7-af1489b8b8ac	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 03:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6afbbe2c-f4c9-4a45-ad7c-279807cfd793	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-26 03:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
7d824f41-2df7-4518-b027-663af0cd09ab	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-23 03:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
bb73550a-c77e-4282-8f34-00436ee332bc	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-27 05:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f7ea2334-0e29-4dc0-a4a6-845bc7febb15	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-21 02:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
84247289-530b-4a60-a162-9a0c7a8371a7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-30 04:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
dbf9e83a-df9f-4db0-980d-e9880041af7e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-16 07:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
c7d56a63-db96-4a1e-82ce-8669dbc8ca2e	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-19 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
16af992a-aedf-4118-92f2-cf3165bfae79	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 01:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d3ad9f5b-787a-4fa5-b2ef-b88c35c675fb	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-25 08:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
b81f219b-c5b3-469b-92db-84c04f5b3c57	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-04 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
036d547e-e81e-4aff-b06f-ba3af65fb8b6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-16 00:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
59c77dc1-ddf8-4976-b257-9fbacdda4066	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-12 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
1b0e2d36-a226-468b-a6fe-89ee84534115	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-24 02:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
72df8939-bdcf-486b-a2ad-b728678ce0c7	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-25 04:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f7270d04-03a4-46e5-a302-26181ea07394	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 01:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
a0189035-2996-457e-bd9b-0478db25f58d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-08 08:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
ddcbd820-f18c-4264-9749-ae8aba28a5d8	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-06 23:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
752a1ffc-6759-4123-8f50-4ce5e3a9be3d	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-20 05:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4deb5db4-fe99-40f5-acad-b42643a8e905	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-14 00:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
4574b713-9bf0-4ae6-83a9-aa36efbeb40b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-02 06:05:12.399933+00	PENDING	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
f352e6fd-cd70-4487-b757-00fc1e13723f	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 01:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
d20113b2-ded8-43cc-b891-db6ac3d39a2b	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-28 06:05:12.399933+00	CONFIRMED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
dc0beb64-dae2-4b77-a4d1-900b97b086d6	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-09 03:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
fa5773c5-90ce-4405-90a0-c5009834e1a2	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-07-31 00:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
6907a2b4-da36-4200-87ac-11e67e218d27	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-09-07 00:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
697c18db-6310-4f44-be1c-40546f70de80	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-18 23:05:12.399933+00	CANCELLED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
249278ff-2c2a-4c5f-8f66-84853b219900	3d1339fe-bf82-4458-b2fc-90e2f7fe13b3	d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	2026-08-22 04:05:12.399933+00	COMPLETED	2026-08-19 23:05:12.399933+00	2026-08-19 23:05:12.399933+00
\.


--
-- Data for Name: tables; Type: TABLE DATA; Schema: content; Owner: -
--

COPY content.tables (id, table_number, capacity, is_active, created, modified) FROM stdin;
9b531201-2b6f-4965-9c8b-e0cc05a56ac3	1	6	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
14683656-15d1-4f55-90f5-83cf20960ee5	2	7	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
9fde048e-b60b-4cd4-87b8-106d5929629f	3	9	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
a3489487-83b9-40ef-baad-003084b57147	4	3	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
0c0aab26-c686-4c1b-a44b-34eb22375ecd	5	4	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
d3e16ef1-2c23-4de1-a24b-448adbcaab63	6	9	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
0fe6e5e5-8313-402f-8bda-069db5be953c	7	4	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
630c1682-6fdf-4b7e-a7a5-1e218d0661e9	8	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
20572afd-c15c-4182-bb63-8d5db84db1aa	9	4	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
7fed9d94-6300-432f-8865-1a03fdabc489	10	3	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
4ad2c440-4691-4cde-934c-82ad800b6f99	11	3	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
25899d2d-b5c8-4199-8b16-c387f8ef1bf1	12	8	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
22f1d800-c4c1-4daa-a974-71c3181f7ea6	13	8	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
98f619cb-7d6d-4704-a272-c6080fc9943a	14	6	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
946c4bcb-1319-4f6b-a4d5-b65c41b67d2b	15	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
4f5dab9e-a2e1-4bbf-a6a1-160a6035c51f	16	5	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
9edbf69a-7117-4094-b39b-156dec366bff	17	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
c8ff8b80-9f2b-4fe9-b797-8b3bc47c4362	18	8	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
b4ebba5e-d660-48be-b385-448ccff29e8a	19	7	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
4a280918-1f8b-4cbe-8efd-ddb0779186bb	20	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
7ba9dc0b-f326-4cc6-9c1b-f7bfbca0b86f	21	7	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
a0f7a935-73b4-48f4-97e2-ee7c627826e8	22	6	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
b08d9b0c-998c-4a14-b218-46cc2ffb61a2	23	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
17e43282-e21c-4bc3-97e3-e184c7a6865a	24	8	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
156da78e-d4fe-4c6d-b943-96c3fe42d62d	25	3	f	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
11a1c98e-a06c-4047-9266-5e7e6aab2b07	26	3	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
55e600d6-9d56-4939-8146-a719361b1a6d	27	7	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
83654182-fe22-452a-a8fc-0c8e80b6947c	28	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
def7f54c-5196-4ded-9d0b-e66b492a5fef	29	6	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
d6a508a3-9696-4149-8bfd-8c9157ae3a6d	30	5	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
025330c0-f257-4fd5-93a1-724e3f206326	31	5	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
5520cb62-225e-4002-8538-ec7ccca8c230	32	8	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
ee9d656b-06fe-4eeb-8741-1b972ca2de69	33	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
cf89b407-ba27-4fb7-8755-2e0e63e3e9de	34	5	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
eddbc066-9c4b-49eb-a09a-c5c65bf06df9	35	5	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
b5702677-1220-4398-a19a-5a0235cb6cb8	36	5	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
d5bfb51f-8cd6-46fc-b9c0-c7b757c1eb4e	37	8	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
41305a8c-b49c-4e38-a55d-fdbe21d019bb	38	2	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
96f95b38-75a0-4003-a766-f39a3bdf83a1	39	5	f	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
613b018d-97f8-4894-99d5-5236c1c63a31	40	5	t	2026-08-19 23:05:12.361554+00	2026-08-19 23:05:12.361554+00
\.


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: tables tables_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- Name: tables tables_table_number_key; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.tables
    ADD CONSTRAINT tables_table_number_key UNIQUE (table_number);


--
-- Name: order_items uq_order_product; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.order_items
    ADD CONSTRAINT uq_order_product UNIQUE (order_id, product_id);


--
-- Name: customer_created_idx; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX customer_created_idx ON content.customers USING btree (created);


--
-- Name: orders_created_idx; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX orders_created_idx ON content.orders USING btree (created);


--
-- Name: reservations_reservation_time_idx; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX reservations_reservation_time_idx ON content.reservations USING btree (reservation_time);


--
-- Name: order_items fk_item_order; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.order_items
    ADD CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES content.orders(id) ON DELETE CASCADE;


--
-- Name: order_items fk_item_product; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.order_items
    ADD CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES content.products(id) ON DELETE RESTRICT;


--
-- Name: orders fk_order_customer; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.orders
    ADD CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES content.customers(id) ON DELETE RESTRICT;


--
-- Name: orders fk_order_table; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.orders
    ADD CONSTRAINT fk_order_table FOREIGN KEY (table_id) REFERENCES content.tables(id) ON DELETE RESTRICT;


--
-- Name: payments fk_payment_order; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.payments
    ADD CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES content.orders(id) ON DELETE RESTRICT;


--
-- Name: products fk_product_category; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.products
    ADD CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES content.categories(id) ON DELETE RESTRICT;


--
-- Name: reservations fk_reservation_customer; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.reservations
    ADD CONSTRAINT fk_reservation_customer FOREIGN KEY (customer_id) REFERENCES content.customers(id) ON DELETE RESTRICT;


--
-- Name: reservations fk_reservation_table; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.reservations
    ADD CONSTRAINT fk_reservation_table FOREIGN KEY (table_id) REFERENCES content.tables(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict pz94lTKNaveHdJR59uAADB6zbaJw8WfEGvJt8XcJktkBz2LWdpRbYfOKA5zO01I

