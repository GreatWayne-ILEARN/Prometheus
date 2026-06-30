--
-- PostgreSQL database dump
--

\restrict AefKdAqjzPHegFSOTHVJpZtz4KCXfjdh8SQXcicV1dy8K58ged7gbNQ2eLuGwcd

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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
-- Name: ad_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.ad_status AS ENUM (
    'draft',
    'active',
    'paused',
    'archived'
);


ALTER TYPE public.ad_status OWNER TO postgres;

--
-- Name: age_band; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.age_band AS ENUM (
    '18_24',
    '25_34',
    '35_44',
    '45_54',
    '55_plus'
);


ALTER TYPE public.age_band OWNER TO postgres;

--
-- Name: education_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.education_level AS ENUM (
    'primary',
    'secondary',
    'bachelors',
    'masters',
    'phd',
    'other'
);


ALTER TYPE public.education_level OWNER TO postgres;

--
-- Name: employment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.employment_status AS ENUM (
    'employed',
    'self_employed',
    'student',
    'unemployed',
    'retired'
);


ALTER TYPE public.employment_status OWNER TO postgres;

--
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'male',
    'female'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- Name: points_source; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.points_source AS ENUM (
    'review',
    'share_bonus',
    'multiplier',
    'admin_grant',
    'redemption'
);


ALTER TYPE public.points_source OWNER TO postgres;

--
-- Name: question_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.question_type AS ENUM (
    'multiple_choice',
    'rating',
    'open_text',
    'emoji',
    'yes_no'
);


ALTER TYPE public.question_type OWNER TO postgres;

--
-- Name: redemption_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.redemption_status AS ENUM (
    'pending',
    'processing',
    'completed',
    'failed'
);


ALTER TYPE public.redemption_status OWNER TO postgres;

--
-- Name: redemption_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.redemption_type AS ENUM (
    'airtime',
    'cash',
    'voucher'
);


ALTER TYPE public.redemption_type OWNER TO postgres;

--
-- Name: review_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.review_status AS ENUM (
    'in_progress',
    'completed',
    'abandoned'
);


ALTER TYPE public.review_status OWNER TO postgres;

--
-- Name: reward_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.reward_type AS ENUM (
    'wildcard',
    'general'
);


ALTER TYPE public.reward_type OWNER TO postgres;

--
-- Name: role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role AS ENUM (
    'reviewer',
    'brand',
    'admin',
    'super_admin'
);


ALTER TYPE public.role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ad_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ad_packages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    ad_slots integer DEFAULT 1 NOT NULL,
    duration_days integer DEFAULT 30 NOT NULL,
    max_impressions integer DEFAULT 10000 NOT NULL,
    weight integer DEFAULT 1 NOT NULL,
    featured boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.ad_packages OWNER TO postgres;

--
-- Name: ad_rewards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ad_rewards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ad_id uuid NOT NULL,
    type public.reward_type DEFAULT 'general'::public.reward_type NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    reward_value_text text NOT NULL,
    discount_code text,
    max_claims integer,
    claims_count integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.ad_rewards OWNER TO postgres;

--
-- Name: ads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ads (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    brand_id uuid NOT NULL,
    title text NOT NULL,
    description text,
    asset_url text NOT NULL,
    asset_type text DEFAULT 'image'::text NOT NULL,
    min_watch_seconds integer DEFAULT 15 NOT NULL,
    point_reward integer DEFAULT 10 NOT NULL,
    multiplier_factor numeric(3,1) DEFAULT 1.0 NOT NULL,
    proverb_question text,
    proverb_answer text,
    proverb_bonus_points integer DEFAULT 5 NOT NULL,
    status public.ad_status DEFAULT 'draft'::public.ad_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.ads OWNER TO postgres;

--
-- Name: answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    review_session_id uuid NOT NULL,
    question_id uuid NOT NULL,
    answer_text text,
    answer_value text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.answers OWNER TO postgres;

--
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    company_name text NOT NULL,
    website text,
    logo_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- Name: events_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_type text NOT NULL,
    actor_id uuid,
    entity_type text,
    entity_id uuid,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.events_log OWNER TO postgres;

--
-- Name: leaderboard_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leaderboard_snapshots (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    week_start date NOT NULL,
    points_total integer DEFAULT 0 NOT NULL,
    rank integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.leaderboard_snapshots OWNER TO postgres;

--
-- Name: platform_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platform_settings (
    key text NOT NULL,
    value text NOT NULL,
    label text NOT NULL,
    description text,
    type text DEFAULT 'string'::text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.platform_settings OWNER TO postgres;

--
-- Name: points_ledger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.points_ledger (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    amount integer NOT NULL,
    source public.points_source NOT NULL,
    reference_id uuid,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.points_ledger OWNER TO postgres;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ad_id uuid NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    question_type public.question_type NOT NULL,
    question_text text NOT NULL,
    options jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: redemptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redemptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    amount_points integer NOT NULL,
    redemption_type public.redemption_type NOT NULL,
    status public.redemption_status DEFAULT 'pending'::public.redemption_status NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.redemptions OWNER TO postgres;

--
-- Name: review_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    ad_id uuid NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    watch_seconds integer,
    points_awarded integer,
    status public.review_status DEFAULT 'in_progress'::public.review_status NOT NULL,
    comment text
);


ALTER TABLE public.review_sessions OWNER TO postgres;

--
-- Name: reviewer_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviewer_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    gender public.gender,
    age_band public.age_band,
    state text,
    employment_status public.employment_status,
    education_level public.education_level,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reviewer_profiles OWNER TO postgres;

--
-- Name: reward_claims; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reward_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    reward_id uuid NOT NULL,
    user_id uuid NOT NULL,
    redemption_code text NOT NULL,
    claimed_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reward_claims OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    username text NOT NULL,
    role public.role DEFAULT 'reviewer'::public.role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: ad_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ad_packages (id, name, description, price, ad_slots, duration_days, max_impressions, weight, featured, active, created_at) FROM stdin;
f51b604b-4af0-43cf-bb64-3a1c9440753e	Starter	One 1,000-impression bundle. Great for testing a new campaign.	1000000.00	1	0	1000	1	f	t	2026-05-02 18:20:19.622354+00
41b0d067-0367-4821-9f7f-029a3ee0fe0a	Growth	Ten 1,000-impression bundles at 15% off. Run up to 3 campaigns in parallel.	8500000.00	3	0	10000	3	t	t	2026-05-02 18:20:19.622354+00
a1088b3e-45f7-4151-a582-75e2ef0c20db	Enterprise	One hundred 1,000-impression bundles at 25% off. Maximum reach with priority support.	75000000.00	10	0	100000	10	f	t	2026-05-02 18:20:19.622354+00
\.


--
-- Data for Name: ad_rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ad_rewards (id, ad_id, type, title, description, reward_value_text, discount_code, max_claims, claims_count, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: ads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ads (id, brand_id, title, description, asset_url, asset_type, min_watch_seconds, point_reward, multiplier_factor, status, created_at, updated_at) FROM stdin;
b816c046-cefc-430c-a25b-6c35f958302d	63af4274-2b9a-4ed2-92df-ddbed5395ada	MTN Nigeria — Everywhere You Go	Connecting millions of Nigerians every day.	RUGYXRQstIA	youtube	15	60	3.0	active	2026-05-02 18:55:37.274225+00	2026-05-02 18:55:37.274225+00
c1cab6b8-e3bc-47b6-8548-cc680334e9e4	63af4274-2b9a-4ed2-92df-ddbed5395ada	MTN MoMo — Send Money Instantly	Fast, safe mobile money for all Nigerians.	l8uWWss0Z5U	youtube	15	50	2.5	active	2026-05-02 18:55:37.278533+00	2026-05-02 18:55:37.278533+00
14b04d8c-bc32-4d08-888b-0fbe91892099	5f273b8f-210e-4d9a-af9f-c302b1367dc3	Airtel Nigeria — Smart Connect	Staying connected has never been smarter.	C6O7W7IxlRY	youtube	15	55	2.5	active	2026-05-02 18:55:37.281743+00	2026-05-02 18:55:37.281743+00
374c69af-4d8e-46d7-8722-dcb86b5ea2f7	5f273b8f-210e-4d9a-af9f-c302b1367dc3	Airtel Nigeria — 4G Broadband	Experience blazing-fast 4G connectivity.	YKWHzr0Z4eU	youtube	15	45	2.0	active	2026-05-02 18:55:37.285795+00	2026-05-02 18:55:37.285795+00
dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	3f95955a-57a4-45fe-8a09-deab8e230f74	Guinness Nigeria — Made of Black	The iconic stout, proudly brewed in Nigeria.	66HuFrMZWMo	youtube	15	80	2.0	active	2026-05-02 18:55:37.288547+00	2026-05-02 18:55:37.288547+00
c1fe2aec-5508-4711-990d-3dbc1fb761e0	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	Dangote Cement — Building Nigeria	Powering Nigeria's infrastructure revolution.	5aw4An785Ck	youtube	15	65	2.5	active	2026-05-02 18:55:37.292058+00	2026-05-02 18:55:37.292058+00
f7fd0f69-bde1-4106-89fc-7d44f2aff71c	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	Dangote Group — Africa's Pride	Africa's largest industrial conglomerate.	g_TCfV-7fvs	youtube	15	90	3.0	active	2026-05-02 18:55:37.295596+00	2026-05-02 18:55:37.295596+00
738c03da-61f1-4a1c-8f01-20d1291976c1	f295cb46-da6d-4c73-890f-28732facfc5c	Jumia Nigeria — Shop Smarter	Nigeria's leading e-commerce platform.	JYBMh0OWPzM	youtube	15	40	2.0	active	2026-05-02 18:55:37.297965+00	2026-05-02 18:55:37.297965+00
e67e8615-3271-4803-a62b-88d366d64b1d	ded94e43-a1ad-4b31-9fa2-326755a569b6	GTBank — 737 Mobile Banking	Banking at your fingertips, 24/7.	VZwHrpX8IBM	youtube	15	60	1.5	active	2026-05-02 18:55:37.302154+00	2026-05-02 18:55:37.302154+00
ac7bc6c8-9e8a-4339-be22-96a688c0389f	44b3ebb7-d738-467c-ba8a-623f842434da	Indomie Nigeria — My Own Indomie	Nigeria's favourite instant noodles.	rwSjs8MsjdM	youtube	15	35	1.5	active	2026-05-02 18:55:37.377311+00	2026-05-02 18:55:37.377311+00
5f85fa0b-6587-4856-912f-9772585b97d9	44b3ebb7-d738-467c-ba8a-623f842434da	Indomie Nigeria — New Flavours	Bold new tastes for every Nigerian.	uK2v63spr8M	youtube	15	40	1.5	active	2026-05-02 18:55:37.380193+00	2026-05-02 18:55:37.380193+00
01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	c406889a-f7e1-4d3c-b77e-1e0a523fd197	Peak Milk — Nourishing Generations	Premium dairy nutrition for the whole family.	ZGZjAiegnnI	youtube	15	45	2.0	active	2026-05-02 18:55:37.383104+00	2026-05-02 18:55:37.383104+00
301643d2-f5c4-461e-9df9-c47f64cfeeed	c3a88881-2115-4124-938b-232c6a8f87d1	Flutterwave — Move Money Everywhere	Africa's leading payment technology company.	NKL_vkkfk34	youtube	15	70	2.5	active	2026-05-02 18:55:37.385872+00	2026-05-02 18:55:37.385872+00
2e2c4657-6463-4b6f-9384-4e339a31b103	e04c892f-a6b5-4f72-bd49-b122b3e72830	Paystack — Accept Payments in Africa	The easiest way to accept payments online.	ckqAG7KVIP0	youtube	15	65	2.0	active	2026-05-02 18:55:37.390522+00	2026-05-02 18:55:37.390522+00
e42ebb20-c389-488c-a5f0-fe9886830947	b76ae32f-4539-4fa7-813f-9d4e94c760e0	TestCampaign71379		https://www.example.com/video.mp4	video	15	10	1.0	draft	2026-05-02 21:04:54.645141+00	2026-05-02 21:04:54.645141+00
b5c91f32-6eb5-40e6-a543-a3a3d5da11d0	66b9a100-eef0-46fb-8c9e-b03f7b38158e	TestCampaign53070		https://example.com/ad.mp4	video	15	10	1.0	draft	2026-05-02 21:15:45.630311+00	2026-05-02 21:15:45.630311+00
\.


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answers (id, review_session_id, question_id, answer_text, answer_value, created_at) FROM stdin;
7bd21d27-926d-4991-b3e1-9e2ce7ce02b0	aed14e3c-8644-4711-8e63-53ebf90d0003	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:31.921137+00
7e8397e4-cc34-41a0-b771-d5b7dba549b6	aed14e3c-8644-4711-8e63-53ebf90d0003	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:31.921137+00
8b84957c-f75b-4fb6-9624-6dce16a09240	aed14e3c-8644-4711-8e63-53ebf90d0003	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:31.921137+00
ba6ea9cb-88ea-4aed-a84c-c723a2590f7b	aed14e3c-8644-4711-8e63-53ebf90d0003	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:31.921137+00
d82aae0d-2ff7-4868-a756-44b18e380b6d	aed14e3c-8644-4711-8e63-53ebf90d0003	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:31.921137+00
d11eb009-2404-4828-aa99-ab49d528ccc4	aed14e3c-8644-4711-8e63-53ebf90d0003	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:31.921137+00
78285ad9-642e-4c88-a2d0-89eb909184f0	aed14e3c-8644-4711-8e63-53ebf90d0003	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:31.921137+00
704329bd-b221-4b4c-9aea-064d61b7f683	aed14e3c-8644-4711-8e63-53ebf90d0003	85d46e14-1258-44db-8c69-be4f7888de87	Solid ad. Dangote's dominance in the cement sector is well-deserved.	\N	2026-05-04 11:14:31.921137+00
7b40b165-c5c1-47da-853b-44bd996cb368	5f246d58-8a72-4117-b89b-417ea2f9d554	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:31.9339+00
fa77848c-9d5d-4ddd-ab64-38258a6604cb	5f246d58-8a72-4117-b89b-417ea2f9d554	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:31.9339+00
a2045fb6-e95b-45e4-ae8a-83d09e214882	5f246d58-8a72-4117-b89b-417ea2f9d554	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:31.9339+00
f0f78a2f-9daf-4d08-8e3a-696fa508d58c	5f246d58-8a72-4117-b89b-417ea2f9d554	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:31.9339+00
fd7df842-96a7-4174-8e22-792f692f235a	5f246d58-8a72-4117-b89b-417ea2f9d554	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:31.9339+00
54fdc519-5d7a-4a4a-8444-f0ef1aefa45a	5f246d58-8a72-4117-b89b-417ea2f9d554	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:31.9339+00
51c2a44e-9440-435b-8e86-2f4a03c0f589	5f246d58-8a72-4117-b89b-417ea2f9d554	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:31.9339+00
700ed91f-f25c-4034-936a-9c1faf49919e	5f246d58-8a72-4117-b89b-417ea2f9d554	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	My family has been using Dangote for over a decade. No regrets.	\N	2026-05-04 11:14:31.9339+00
338189c7-c64e-4a3d-b38e-bee0a2407be7	519ad0bb-4815-48d0-9ab9-6bebe71a847b	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:31.942849+00
9f4ed099-1e01-4896-8666-9bd8e01b50ef	519ad0bb-4815-48d0-9ab9-6bebe71a847b	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:31.942849+00
31844e23-1152-42d8-986d-53efd05b0770	519ad0bb-4815-48d0-9ab9-6bebe71a847b	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:31.942849+00
74d3ef08-05f6-4991-9de2-b5fc401fe455	519ad0bb-4815-48d0-9ab9-6bebe71a847b	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:31.942849+00
ecc9aedf-ec34-4402-aabb-20464a34826d	519ad0bb-4815-48d0-9ab9-6bebe71a847b	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:31.942849+00
291234d5-0855-467e-bda4-aadeaf39a812	519ad0bb-4815-48d0-9ab9-6bebe71a847b	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:31.942849+00
c27d2a84-a522-42bf-927b-92d6e08ac5f4	519ad0bb-4815-48d0-9ab9-6bebe71a847b	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:31.942849+00
a4bf7f1d-3f84-4330-a4b6-c607c19f4288	519ad0bb-4815-48d0-9ab9-6bebe71a847b	85d46e14-1258-44db-8c69-be4f7888de87	The ad made me want to upgrade my home renovation project with Dangote.	\N	2026-05-04 11:14:31.942849+00
62fdab2e-860f-41b5-bcfd-bfb8b6ca19d2	1f9a4c26-3784-4615-b977-901285e26e40	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:31.953494+00
20ca62c1-f897-4491-8a36-5e22f3ced647	1f9a4c26-3784-4615-b977-901285e26e40	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:31.953494+00
94fcaeaa-4f4d-49e4-a38b-faf412df59f0	1f9a4c26-3784-4615-b977-901285e26e40	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:31.953494+00
13c658ee-2203-4442-90ac-5bbb51237ab6	1f9a4c26-3784-4615-b977-901285e26e40	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:31.953494+00
83cd364e-953b-4423-8c58-f0db65a6070f	1f9a4c26-3784-4615-b977-901285e26e40	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:31.953494+00
e0b1a168-ed5c-41d0-bb8f-0bdaa16cf7c6	1f9a4c26-3784-4615-b977-901285e26e40	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:31.953494+00
2e5cde8b-76f9-44b7-8735-13529696dde3	1f9a4c26-3784-4615-b977-901285e26e40	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:31.953494+00
beb2f441-3648-4bf1-8fe8-bce489f5463b	1f9a4c26-3784-4615-b977-901285e26e40	85d46e14-1258-44db-8c69-be4f7888de87	The ad made me want to upgrade my home renovation project with Dangote.	\N	2026-05-04 11:14:31.953494+00
a61044cd-e8e3-4f04-a6a3-0d98df6986fd	d81301b4-6a6b-4120-bdc9-f80e829f951b	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:31.962035+00
775ac3f4-243b-4a56-949c-feb8926367fb	d81301b4-6a6b-4120-bdc9-f80e829f951b	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:31.962035+00
4da4b39a-e723-4b7c-87b2-03fe13cc200e	d81301b4-6a6b-4120-bdc9-f80e829f951b	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:31.962035+00
2070d3b3-2004-4d24-985d-b738401734e6	d81301b4-6a6b-4120-bdc9-f80e829f951b	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:31.962035+00
0a90929b-b753-4dc6-9038-dbe8c2909239	d81301b4-6a6b-4120-bdc9-f80e829f951b	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:31.962035+00
fc0fc506-d80d-4e92-b15c-26b483866dab	d81301b4-6a6b-4120-bdc9-f80e829f951b	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:31.962035+00
0895ef94-299c-47da-85e8-8f7c43395636	d81301b4-6a6b-4120-bdc9-f80e829f951b	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:31.962035+00
1011b470-e5cb-4ce9-9b42-4b058d9cb4f6	d81301b4-6a6b-4120-bdc9-f80e829f951b	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Short, punchy, to the point. Excellent advertising from the Dangote brand.	\N	2026-05-04 11:14:31.962035+00
6f5f3f0e-8db2-4e2d-b6bd-4c65df4a2728	ff0b8cd1-f7e1-454a-8bf4-b80953001163	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:31.972428+00
59568a05-8b5b-470b-8db2-e880d637e684	ff0b8cd1-f7e1-454a-8bf4-b80953001163	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:31.972428+00
e9d799e2-5224-4997-b4c7-ccfdb09cf73f	ff0b8cd1-f7e1-454a-8bf4-b80953001163	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:31.972428+00
127ad813-681b-4d94-8e5f-82b895a19450	ff0b8cd1-f7e1-454a-8bf4-b80953001163	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:31.972428+00
8d7eaeb8-1670-4330-9ed6-155e1643259e	ff0b8cd1-f7e1-454a-8bf4-b80953001163	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:31.972428+00
e26fcd6b-a502-4c8f-93f3-1a6f09b0a88f	ff0b8cd1-f7e1-454a-8bf4-b80953001163	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:31.972428+00
5daaa84f-103a-4050-a947-ee8dea1d970e	ff0b8cd1-f7e1-454a-8bf4-b80953001163	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:31.972428+00
c531bc05-63c8-4aa5-b24c-1b7ef0ddecbd	ff0b8cd1-f7e1-454a-8bf4-b80953001163	85d46e14-1258-44db-8c69-be4f7888de87	As a civil engineer, I appreciate the technical accuracy in the messaging.	\N	2026-05-04 11:14:31.972428+00
00d32ce6-d09f-4268-9d08-868bc13fae25	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:31.981016+00
335d28e0-cb2a-4418-ac3b-1739e5df9ae5	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:31.981016+00
d552123f-7884-4672-9a8e-833f214f96f7	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:31.981016+00
1ae1bcda-8bf9-49af-aff0-5779ab28a382	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:31.981016+00
ae1a9df9-15c6-4d34-b375-26c8ebb9fa3c	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:31.981016+00
13970267-5f4a-4c1f-994c-cc5be81f8774	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:31.981016+00
bca702ee-69db-4f54-b677-83ea317e08a6	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:31.981016+00
24483b04-631d-40da-9300-0aee9849da87	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Short, punchy, to the point. Excellent advertising from the Dangote brand.	\N	2026-05-04 11:14:31.981016+00
c3e99994-96f3-4dd4-89bf-9e8042c166c4	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:31.989252+00
faf18771-9a7d-4c53-9ee8-0a886064988f	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:31.989252+00
d6bf0814-9023-47b2-8865-6a515cb3f62a	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:31.989252+00
1ee82f1a-8958-4c80-8c5a-e98e956f49da	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:31.989252+00
a2645e7c-48f1-4eba-944b-a06f645fee67	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:31.989252+00
9c164a49-4dff-494f-acda-88c82302d12e	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:31.989252+00
a3d012b4-8652-4a65-9822-447c89b656b6	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:31.989252+00
9b866832-924b-4dde-82a5-a82c5de982f6	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	85d46e14-1258-44db-8c69-be4f7888de87	As a civil engineer, I appreciate the technical accuracy in the messaging.	\N	2026-05-04 11:14:31.989252+00
22b49cda-97ea-4134-9366-4edf81487e72	86ea4497-f522-43a8-8b5f-a5f55764140e	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:31.998128+00
e5be79a1-7946-4d09-a013-0423115a5a29	86ea4497-f522-43a8-8b5f-a5f55764140e	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:31.998128+00
eb554812-838f-4ec4-8067-fefc38bef39c	86ea4497-f522-43a8-8b5f-a5f55764140e	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:31.998128+00
792285d9-0472-42c1-b1f5-83e5499a8023	86ea4497-f522-43a8-8b5f-a5f55764140e	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:31.998128+00
bfb9634b-c16a-43f4-acee-f3f068cdb203	86ea4497-f522-43a8-8b5f-a5f55764140e	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:31.998128+00
b4a655f3-32f0-483a-9190-1b4973117dff	86ea4497-f522-43a8-8b5f-a5f55764140e	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:31.998128+00
ae74d684-ac8e-44a0-b6cc-bee50996552b	86ea4497-f522-43a8-8b5f-a5f55764140e	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:31.998128+00
d5774e73-802e-40ec-8cb3-fb20e9d3f539	86ea4497-f522-43a8-8b5f-a5f55764140e	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Price point is competitive for the quality. Ad represents that well.	\N	2026-05-04 11:14:31.998128+00
0f04666d-474b-4f1f-b3b0-1e364395885f	33e822c3-d9f8-4d7c-b54b-22de258bb819	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.007258+00
c525e473-52e1-4e95-a93f-fc967a5607dd	33e822c3-d9f8-4d7c-b54b-22de258bb819	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.007258+00
73c686c9-1c97-47f1-830e-28671a61d2e6	33e822c3-d9f8-4d7c-b54b-22de258bb819	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.007258+00
397a6b8b-b7e6-4c62-bb1f-8ac225dccc4c	33e822c3-d9f8-4d7c-b54b-22de258bb819	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.007258+00
ae5423b8-4f8e-41d3-869d-25446dbc92e9	33e822c3-d9f8-4d7c-b54b-22de258bb819	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.007258+00
94440c8c-7e37-41a8-995c-de854570314a	33e822c3-d9f8-4d7c-b54b-22de258bb819	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.007258+00
006c3545-8190-4782-af0a-1a30681f8168	33e822c3-d9f8-4d7c-b54b-22de258bb819	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.007258+00
70a98915-4570-41dc-bef7-467c32e2d97a	33e822c3-d9f8-4d7c-b54b-22de258bb819	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Price point is competitive for the quality. Ad represents that well.	\N	2026-05-04 11:14:32.007258+00
7f6d5242-bcd7-42a3-9e68-40b566ed80ef	e19427a2-6b47-4a4a-834b-02507465a048	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.016472+00
96ee933f-a4d8-491f-859d-642fa2b43b8c	e19427a2-6b47-4a4a-834b-02507465a048	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.016472+00
869cabf4-f658-4d0f-b3da-2551a823b40f	e19427a2-6b47-4a4a-834b-02507465a048	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.016472+00
695bb4e2-209f-47cd-8937-03d23551f05e	e19427a2-6b47-4a4a-834b-02507465a048	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.016472+00
1ed7fd75-0d14-4862-8e0d-d4a7dd89f6aa	e19427a2-6b47-4a4a-834b-02507465a048	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.016472+00
ed6ae31c-7480-43d7-a4f2-b34cf2396b08	e19427a2-6b47-4a4a-834b-02507465a048	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.016472+00
18158905-f9ca-42f3-b1f4-4218f36447a3	e19427a2-6b47-4a4a-834b-02507465a048	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.016472+00
c962744e-611e-4eae-b145-7eed29648d76	e19427a2-6b47-4a4a-834b-02507465a048	85d46e14-1258-44db-8c69-be4f7888de87	The brand trust is already there, the ad just reinforced it for me.	\N	2026-05-04 11:14:32.016472+00
f699fe56-f99f-442f-a232-8290857c49bb	fad6dbfc-7de2-4476-b51c-750d501ffc7b	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.025201+00
176c9233-aae1-40d5-9e07-25e07ddeb372	fad6dbfc-7de2-4476-b51c-750d501ffc7b	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.025201+00
a278e4e3-ac46-447e-b0a3-482be09b0671	fad6dbfc-7de2-4476-b51c-750d501ffc7b	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:32.025201+00
85bc05e3-a509-4bb6-832f-dcd2e32d2f4b	fad6dbfc-7de2-4476-b51c-750d501ffc7b	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.025201+00
11d3d71a-19d3-4ecd-8193-9b0eb4700b9d	fad6dbfc-7de2-4476-b51c-750d501ffc7b	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.025201+00
ad21bc2b-a5a5-4cca-90af-11bf7f6a66a3	fad6dbfc-7de2-4476-b51c-750d501ffc7b	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.025201+00
21b0a52a-e6c7-4a00-ada1-ead2ed9407db	fad6dbfc-7de2-4476-b51c-750d501ffc7b	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.025201+00
cbff3801-144c-4b5a-8e7c-f855140f81ea	fad6dbfc-7de2-4476-b51c-750d501ffc7b	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Would love to see Dangote expand into more product lines. Exciting times.	\N	2026-05-04 11:14:32.025201+00
9b93224d-7713-492d-9429-3d4ce3cd1e65	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.034552+00
2fe86f88-fe8c-4138-8571-20e08f4a189d	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.034552+00
c5a801e6-7f25-4e52-a166-29b8a047f057	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.034552+00
a4d25c72-1288-47b9-9fac-5a175fbe7901	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.034552+00
9a3fa158-f431-425d-8762-abf6d628b749	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.034552+00
df816f9d-48de-44d8-b9d7-769e5009e999	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:32.034552+00
47c2c171-a7f4-4f82-bd05-4cb02f887b61	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.034552+00
5c439ed5-5a6d-4396-b256-55b702b97db5	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	85d46e14-1258-44db-8c69-be4f7888de87	The brand trust is already there, the ad just reinforced it for me.	\N	2026-05-04 11:14:32.034552+00
5c2ab5ee-a062-4cf6-a6ef-962e1c87ff2b	1f66b721-9c99-4104-8453-f74e26a97bd9	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.043781+00
3a225593-aeff-4214-8537-ac02a4d24dd4	1f66b721-9c99-4104-8453-f74e26a97bd9	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.043781+00
fc36c55e-58f7-49fd-a9f8-2731acf092e3	1f66b721-9c99-4104-8453-f74e26a97bd9	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.043781+00
1c53487f-c7c1-4202-a38e-941f4d1bb059	1f66b721-9c99-4104-8453-f74e26a97bd9	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.043781+00
3d268edd-19f6-45d1-94fc-18afb1435ab6	1f66b721-9c99-4104-8453-f74e26a97bd9	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.043781+00
c6637269-e6c9-4324-a25c-75a8002c4162	1f66b721-9c99-4104-8453-f74e26a97bd9	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.043781+00
0cc12ff5-bebc-473f-aac0-b0fa35f0e89a	1f66b721-9c99-4104-8453-f74e26a97bd9	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.043781+00
71932b04-49fe-46cd-97ea-f95f61939920	1f66b721-9c99-4104-8453-f74e26a97bd9	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Would love to see Dangote expand into more product lines. Exciting times.	\N	2026-05-04 11:14:32.043781+00
3adcf6d4-d3a8-492b-9f3e-fc420b5f44e6	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.052854+00
6950fd71-88d7-481d-9c92-ebdad8634bfb	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.052854+00
90d29cae-71a4-49dc-81ae-2086aca936ee	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.052854+00
09b43abd-3d21-4944-b0da-90a2d3f9ceb0	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.052854+00
e7a3e7a8-afb2-4a99-970e-16c761f08920	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.052854+00
0225e8c5-c669-42bf-ae17-762505ce0eae	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.052854+00
1983096b-ff23-43bd-9889-2b5e6a4209ec	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.052854+00
542fefe3-9cd4-47e9-ad86-42a159629ee5	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	85d46e14-1258-44db-8c69-be4f7888de87	The ad could use more local language elements — more Pidgin maybe?	\N	2026-05-04 11:14:32.052854+00
2811f840-fcca-4d37-ae04-3ed30664914d	0eaad796-af46-4fd7-9a52-6ef43f7285d4	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.062513+00
16b50c08-8c8d-4e84-b0b9-e118513401cc	0eaad796-af46-4fd7-9a52-6ef43f7285d4	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.062513+00
709bfcf7-1210-4519-b31c-199f73325175	0eaad796-af46-4fd7-9a52-6ef43f7285d4	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.062513+00
6c57b60b-27a3-4b0b-b96a-60c99162bc96	0eaad796-af46-4fd7-9a52-6ef43f7285d4	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.062513+00
d557aab9-05a0-4c07-a6ce-066000482b49	0eaad796-af46-4fd7-9a52-6ef43f7285d4	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.062513+00
abdeab5c-bc27-421b-984e-10e9c47d93d9	0eaad796-af46-4fd7-9a52-6ef43f7285d4	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.062513+00
be349b38-428d-457f-a04c-3ed575018c38	0eaad796-af46-4fd7-9a52-6ef43f7285d4	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.062513+00
d2be701e-28c6-465f-b94f-8d818de6788c	0eaad796-af46-4fd7-9a52-6ef43f7285d4	85d46e14-1258-44db-8c69-be4f7888de87	The ad could use more local language elements — more Pidgin maybe?	\N	2026-05-04 11:14:32.062513+00
3becdfd6-8618-4a60-b6d6-b257a03348b1	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.070839+00
e1dc3eee-b4b6-475c-8bd4-1aabe2d674a0	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.070839+00
d659d80c-7ec9-4693-bc51-6de6073ba8e4	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.070839+00
3e2b0865-afbb-41d5-be6d-e9696b731c7c	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.070839+00
033d896b-04b3-4cfa-90ca-0e56361dbe5a	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.070839+00
e684ba17-69a2-4091-9721-d13e670f8a8d	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.070839+00
12ef0ebd-dc1d-422e-9def-9f301df49a28	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.070839+00
a473f417-53de-4e3f-a3c9-cf1a2ecfe671	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very strong brand. The ad did justice to what Dangote represents.	\N	2026-05-04 11:14:32.070839+00
c57e41d0-2941-417d-9149-240e9a3cd2b6	f4f06ada-6682-426f-8345-50820fc29b9f	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.079831+00
2d861111-3a7d-4a35-bfcc-5ec7c4924751	f4f06ada-6682-426f-8345-50820fc29b9f	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.079831+00
d7123dea-1b5b-4868-916b-9836014c4dec	f4f06ada-6682-426f-8345-50820fc29b9f	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:32.079831+00
660fdd87-227f-4318-bfca-6e80c7016f00	f4f06ada-6682-426f-8345-50820fc29b9f	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.079831+00
58996a72-4f4a-4aca-9bfe-94bb1e44daf4	f4f06ada-6682-426f-8345-50820fc29b9f	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.079831+00
8248bc59-5931-48a0-bdcf-bf2c05ff9e19	f4f06ada-6682-426f-8345-50820fc29b9f	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.079831+00
bb9d531a-e476-461f-9df9-07c9f5522e52	f4f06ada-6682-426f-8345-50820fc29b9f	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.079831+00
ddb6e00d-b61a-4307-98d8-e7ea53841967	f4f06ada-6682-426f-8345-50820fc29b9f	85d46e14-1258-44db-8c69-be4f7888de87	Saw this ad at the right time — currently building a house in Abuja.	\N	2026-05-04 11:14:32.079831+00
26449869-bb04-4585-b622-f017434bf247	d8b70f29-6926-4660-8e24-b7e839a01364	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.088064+00
6715f6c3-276f-4875-8f72-28a679c47327	d8b70f29-6926-4660-8e24-b7e839a01364	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.088064+00
21962452-db5d-434b-9dfb-e8ec80f89071	d8b70f29-6926-4660-8e24-b7e839a01364	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:32.088064+00
50c8841d-3e28-4bc9-9deb-10d67367a78f	d8b70f29-6926-4660-8e24-b7e839a01364	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.088064+00
6bdc40c8-cbde-488f-af7d-9c2319a8db18	d8b70f29-6926-4660-8e24-b7e839a01364	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.088064+00
0856ed33-2c8f-4491-9b6c-3be7bc464658	d8b70f29-6926-4660-8e24-b7e839a01364	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.088064+00
3602e90e-fe88-4d14-b8ff-a4ecdcedfc01	d8b70f29-6926-4660-8e24-b7e839a01364	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.088064+00
132264bd-13cd-41d8-a551-221ea2dbd463	d8b70f29-6926-4660-8e24-b7e839a01364	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very strong brand. The ad did justice to what Dangote represents.	\N	2026-05-04 11:14:32.088064+00
f016fbad-531e-445b-9b78-7bc6da4d6cc3	f66abedd-56d0-40bf-9528-ebe17d92ad37	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.095728+00
1fc3bd71-e5a4-4fd7-bd25-b34c7db8fc87	f66abedd-56d0-40bf-9528-ebe17d92ad37	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.095728+00
2b172a27-8adf-4249-a47b-7254e42003e7	f66abedd-56d0-40bf-9528-ebe17d92ad37	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.095728+00
138de91e-5e3d-44d2-b0d7-802aa77dda83	f66abedd-56d0-40bf-9528-ebe17d92ad37	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.095728+00
1e63ecf3-ead6-49f3-9133-3c0376212921	f66abedd-56d0-40bf-9528-ebe17d92ad37	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.095728+00
ecd0299a-7102-4a43-b092-008934219da8	f66abedd-56d0-40bf-9528-ebe17d92ad37	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:32.095728+00
c23da930-288d-45a9-8ea3-b59051b5e6cb	f66abedd-56d0-40bf-9528-ebe17d92ad37	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.095728+00
71ae9b88-c729-43cc-bcb3-90ba05e9fd0f	f66abedd-56d0-40bf-9528-ebe17d92ad37	85d46e14-1258-44db-8c69-be4f7888de87	Saw this ad at the right time — currently building a house in Abuja.	\N	2026-05-04 11:14:32.095728+00
e1246e1e-a34b-40cc-8f37-6363075be249	4acfd2c8-28d3-468d-b41c-26148c7b721b	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.103727+00
fd6c8679-2e16-4211-a8f5-766a66de9e19	4acfd2c8-28d3-468d-b41c-26148c7b721b	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.103727+00
952d45fc-913a-4712-85d1-78625e9d6da3	4acfd2c8-28d3-468d-b41c-26148c7b721b	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.103727+00
056752c6-b193-43fb-becf-9e9b18b38ca6	4acfd2c8-28d3-468d-b41c-26148c7b721b	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.103727+00
df3e2f9f-4d58-4409-be4b-869638b77d0c	4acfd2c8-28d3-468d-b41c-26148c7b721b	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.103727+00
9c593b18-2791-4690-a37b-23988ed32232	4acfd2c8-28d3-468d-b41c-26148c7b721b	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.103727+00
42bed232-eb3e-4a27-aaec-6f037b7f271e	4acfd2c8-28d3-468d-b41c-26148c7b721b	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.103727+00
803eaa0b-1457-41a2-9d33-f21a6db58bc1	4acfd2c8-28d3-468d-b41c-26148c7b721b	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote is synonymous with quality in Nigeria. Ad reflects that perfectly.	\N	2026-05-04 11:14:32.103727+00
90332166-99cb-435f-a307-c1533128dfa1	36fe1791-6e25-4546-a8ad-fbe83025788c	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.112273+00
3af1e3ff-9b39-4176-9efa-4066530f37c0	36fe1791-6e25-4546-a8ad-fbe83025788c	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.112273+00
2a894e5c-0788-402c-86d8-63e881a88fbe	36fe1791-6e25-4546-a8ad-fbe83025788c	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:32.112273+00
577e874a-fc64-4e37-a013-744e0c04c9ed	36fe1791-6e25-4546-a8ad-fbe83025788c	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.112273+00
b9aa7e98-4eae-44a1-9652-674bcb375f8a	36fe1791-6e25-4546-a8ad-fbe83025788c	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.112273+00
d4819594-fea0-4713-88b5-af454da9fbb7	36fe1791-6e25-4546-a8ad-fbe83025788c	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.112273+00
f2be0dbf-c909-48d3-a1bb-ffae7dbdd553	36fe1791-6e25-4546-a8ad-fbe83025788c	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.112273+00
2d527bf8-e6f8-4e0c-aeaa-7d3b97775edd	36fe1791-6e25-4546-a8ad-fbe83025788c	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote is synonymous with quality in Nigeria. Ad reflects that perfectly.	\N	2026-05-04 11:14:32.112273+00
c3aa245d-15d8-4632-8eb8-c112184a6ea4	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.121723+00
a67a7957-0f06-41df-abe5-5a649d157456	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.121723+00
b983e7df-2045-47b1-b918-d63b73e58e24	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.121723+00
5a8e3e77-8220-43be-92aa-d86e9193581b	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.121723+00
fd9cf296-265a-41af-b264-99bb9c6c1722	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.121723+00
735429dd-51a1-486d-8381-430cfc6fe88c	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.121723+00
8c278435-508c-4c38-b7be-60a23a94a166	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.121723+00
93a7e936-7e71-4afa-8303-d77d2e1aa37c	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	85d46e14-1258-44db-8c69-be4f7888de87	Good production quality. The message about durability really hit home.	\N	2026-05-04 11:14:32.121723+00
f72ded77-2c8e-46ef-a415-80d1213e33db	74107e84-8b72-430e-bb87-8978a0369607	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.13076+00
ba979988-202f-49ef-ad58-4f1b6b5a8156	74107e84-8b72-430e-bb87-8978a0369607	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.13076+00
a672cfc0-c67a-43b0-b52d-65d7226436fa	74107e84-8b72-430e-bb87-8978a0369607	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.13076+00
d79dc4ad-18a0-4eaf-96df-5a29c32745df	74107e84-8b72-430e-bb87-8978a0369607	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.13076+00
76339876-c5c5-4ccf-a830-83e678e04a5d	74107e84-8b72-430e-bb87-8978a0369607	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.13076+00
46c1cdcf-8f36-42ff-9a97-c2b7e0b5c116	74107e84-8b72-430e-bb87-8978a0369607	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.13076+00
5bd4f958-62f8-4ce2-9a0a-c8e181f92d02	74107e84-8b72-430e-bb87-8978a0369607	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.13076+00
a4bc6af8-1337-47fa-b152-7bd535c82184	74107e84-8b72-430e-bb87-8978a0369607	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	I've recommended Dangote cement to my clients many times. Great ad.	\N	2026-05-04 11:14:32.13076+00
ce3727d5-7358-4f64-9003-014b5226cbc4	6c50d066-3f19-4e0e-851e-d022ff907c70	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.139614+00
78e4a5d0-6d27-4a12-8054-0c66844b1926	6c50d066-3f19-4e0e-851e-d022ff907c70	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.139614+00
1ca9ba2c-e3a0-43ff-adf1-16d82bc9a902	6c50d066-3f19-4e0e-851e-d022ff907c70	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.139614+00
a85e5701-90cf-46e2-90fa-72dc9fe6ff44	6c50d066-3f19-4e0e-851e-d022ff907c70	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.139614+00
678587a7-00ae-4730-ac82-b0f772d892d2	6c50d066-3f19-4e0e-851e-d022ff907c70	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.139614+00
761f29ca-e944-43d5-ac20-0b996588e6c6	6c50d066-3f19-4e0e-851e-d022ff907c70	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:32.139614+00
f79c1454-891f-455b-afc6-1b62de66e48c	6c50d066-3f19-4e0e-851e-d022ff907c70	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.139614+00
6a64dca0-8564-4e13-b33f-ad451499096c	6c50d066-3f19-4e0e-851e-d022ff907c70	85d46e14-1258-44db-8c69-be4f7888de87	Good production quality. The message about durability really hit home.	\N	2026-05-04 11:14:32.139614+00
319fb393-00f9-483f-a904-4822b34d9c6a	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.161255+00
8dd359e3-5da8-4f02-95a2-fe13cd0882a7	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.161255+00
ef301a4c-76a3-45de-95af-44271e290868	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:32.161255+00
acee9d6e-a14b-4c22-ae5d-db6c3688d8a2	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.161255+00
e51ccf90-a769-45c1-bd85-50677ddebde4	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.161255+00
7414569d-3ee4-4211-b7ae-0dc61549f3b6	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.161255+00
f143bf21-aef3-40dc-8a9e-56ecd371b2eb	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.161255+00
7b308c3e-9f62-414e-8eae-81b4199fb343	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	I've recommended Dangote cement to my clients many times. Great ad.	\N	2026-05-04 11:14:32.161255+00
be1b3a97-0a0d-419b-8bc8-7becf0b1b9e1	0e07a3de-6603-4c96-befc-10baa022b55d	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.170224+00
14760b9b-1a13-4a8c-9f02-700fb224ed94	0e07a3de-6603-4c96-befc-10baa022b55d	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.170224+00
6c65c41b-2f9b-4ef5-9173-7788dfdaec60	0e07a3de-6603-4c96-befc-10baa022b55d	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.170224+00
b3403b74-8ef9-40cf-8689-1461c1fca4bb	0e07a3de-6603-4c96-befc-10baa022b55d	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.170224+00
3d1c37ab-b3db-4094-9720-584e9659c192	0e07a3de-6603-4c96-befc-10baa022b55d	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.170224+00
34bbfdf9-d909-4d7d-8a14-1d06fe204844	0e07a3de-6603-4c96-befc-10baa022b55d	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:32.170224+00
12fdd03d-f14f-4ae2-8e95-f6bf2cf0a03b	0e07a3de-6603-4c96-befc-10baa022b55d	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.170224+00
e93d9fbf-3ddb-458b-9459-2e9d38902c52	0e07a3de-6603-4c96-befc-10baa022b55d	85d46e14-1258-44db-8c69-be4f7888de87	The ad feels authentic — not overdone. Real Nigerian feel to it.	\N	2026-05-04 11:14:32.170224+00
20004a2c-6ffa-4b38-b70d-f3fc19b38310	156d587c-9c4a-4f17-af75-44f52003ae94	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.183736+00
be64290a-17f6-4101-9fe9-48cca3bdda2d	156d587c-9c4a-4f17-af75-44f52003ae94	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:32.183736+00
401ec1d6-9d19-4546-a8ab-b3be0017604e	156d587c-9c4a-4f17-af75-44f52003ae94	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.183736+00
240ee2fa-12f9-4324-b2fd-171688b3a6ec	156d587c-9c4a-4f17-af75-44f52003ae94	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.183736+00
66adda4f-83d6-43be-b313-2a01009574d1	156d587c-9c4a-4f17-af75-44f52003ae94	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.183736+00
822c1a6c-9b72-4cd3-9182-a357d322afe8	156d587c-9c4a-4f17-af75-44f52003ae94	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.183736+00
cbc21224-6d2c-4c27-815d-f6020b9beb6f	156d587c-9c4a-4f17-af75-44f52003ae94	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.183736+00
c6e7d560-7af5-4748-ac55-73e1a7b31255	156d587c-9c4a-4f17-af75-44f52003ae94	85d46e14-1258-44db-8c69-be4f7888de87	The ad feels authentic — not overdone. Real Nigerian feel to it.	\N	2026-05-04 11:14:32.183736+00
4dae91b7-0c3c-4d01-bbaf-b85695f7021b	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.193552+00
fd41ac4a-fb6c-4831-b9cf-92351dd4891a	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.193552+00
d74133a0-57e7-41e4-ba8f-f94fae1fed24	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:32.193552+00
69f03a05-6b3b-4433-86bb-eba543db2335	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.193552+00
f313ec31-d0f0-4c6e-a932-46f8ad95d49b	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.193552+00
e52c1aa6-40fd-421c-8682-9baf1b843b21	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.193552+00
9db65d4b-bd6b-47cd-a844-b4b1651c950a	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.193552+00
9410802d-f584-4081-bc2b-55b3358e5f0a	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Watched it twice. The confidence in the brand comes through clearly.	\N	2026-05-04 11:14:32.193552+00
4fadfc97-74d8-4a74-b5c6-496cc8046d76	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.202445+00
b731ede0-c457-4939-9df1-3ead94c405d1	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.202445+00
390edffe-fd62-4033-b39a-f0af53d9f70f	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.202445+00
87eff2ec-cbb0-4b3c-be89-ad26474c4625	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.202445+00
52b46934-26c8-4e61-80c8-157b5039a909	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.202445+00
f721e0cb-0757-4b19-b3f6-08ba429c6eba	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.202445+00
0a6acef7-9601-482e-8393-f2258dbc4ae5	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.202445+00
5caadee0-172f-468c-9290-efba1ae42f1d	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	85d46e14-1258-44db-8c69-be4f7888de87	As a mother building a home for my children, Dangote gives me confidence.	\N	2026-05-04 11:14:32.202445+00
ee2c31cb-4e2a-46a8-aac2-a37414dd4d7d	c268bfdb-370f-4499-bb61-31f47d76af83	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.212131+00
93810344-9c91-4db3-9431-29fa6347a54d	c268bfdb-370f-4499-bb61-31f47d76af83	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.212131+00
477b9de6-76e7-4087-a1ba-62d0bbc1a9f5	c268bfdb-370f-4499-bb61-31f47d76af83	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:32.212131+00
e1fbd708-49dd-4c27-b024-07186c8e5421	c268bfdb-370f-4499-bb61-31f47d76af83	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.212131+00
e54a778b-60c2-4bb8-a04b-569a0b47715b	c268bfdb-370f-4499-bb61-31f47d76af83	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.212131+00
13a0f50c-a2e6-4e41-a6e5-5f800aaa57c9	c268bfdb-370f-4499-bb61-31f47d76af83	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.212131+00
fd2c3004-bda3-48c0-b23a-abe2bc18652b	c268bfdb-370f-4499-bb61-31f47d76af83	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.212131+00
f932ddd8-73bc-48ac-bf9c-d56b376ee84c	c268bfdb-370f-4499-bb61-31f47d76af83	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Watched it twice. The confidence in the brand comes through clearly.	\N	2026-05-04 11:14:32.212131+00
3cefd832-624b-4aa9-b2e6-999d469e508e	9b112d12-582a-461c-b384-921294608edf	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.221259+00
daad2ad0-72f3-4620-b079-0fc1327b99ad	9b112d12-582a-461c-b384-921294608edf	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.221259+00
b8ff557d-18ed-49ac-968b-382c7386758c	9b112d12-582a-461c-b384-921294608edf	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.221259+00
2b332e04-b626-4e02-8a27-39bbf9ef8370	9b112d12-582a-461c-b384-921294608edf	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.221259+00
d4810254-bd08-448d-b070-db590f484cca	9b112d12-582a-461c-b384-921294608edf	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.221259+00
6c9bb2b1-5356-43b4-99cf-2c23b4ecf018	9b112d12-582a-461c-b384-921294608edf	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.221259+00
ee0ca46b-56a3-4531-8870-f07dbe495992	9b112d12-582a-461c-b384-921294608edf	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.221259+00
852acc94-70c3-404c-ad5a-5f6eea385fa1	9b112d12-582a-461c-b384-921294608edf	85d46e14-1258-44db-8c69-be4f7888de87	As a mother building a home for my children, Dangote gives me confidence.	\N	2026-05-04 11:14:32.221259+00
07605d4b-bbf0-4420-87c7-3288f25caa5f	e292f08d-56e6-4181-adb9-0547d7e38bb4	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.229798+00
ec7528b0-895b-4af3-8073-20da9f05fbc4	e292f08d-56e6-4181-adb9-0547d7e38bb4	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.229798+00
37878716-31fe-477c-8f86-4ebdd7a0a298	e292f08d-56e6-4181-adb9-0547d7e38bb4	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.229798+00
00c2fb3b-eb10-4b88-b74b-7a7a0078214f	e292f08d-56e6-4181-adb9-0547d7e38bb4	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.229798+00
28040e55-abef-4ed7-ad30-4311104de563	e292f08d-56e6-4181-adb9-0547d7e38bb4	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.229798+00
a1895727-94f5-43b9-b64b-d80dcfea757a	e292f08d-56e6-4181-adb9-0547d7e38bb4	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.229798+00
a9d4afdc-02d8-4554-a852-e7b5c09d2d4b	e292f08d-56e6-4181-adb9-0547d7e38bb4	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.229798+00
a772361c-d6c7-4203-8fb0-dd9ea01cbb96	e292f08d-56e6-4181-adb9-0547d7e38bb4	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Great campaign! Dangote should also show more about their flour products.	\N	2026-05-04 11:14:32.229798+00
6c95f457-0a90-4b1d-bd49-38f93bd5d8a1	80fbd6de-3bbe-450a-a76c-d99427f7e73f	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.238462+00
6d93bb57-f276-432d-9f83-1f3e5c2a25f9	80fbd6de-3bbe-450a-a76c-d99427f7e73f	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.238462+00
28c7adb9-dd23-48f0-89b1-b294a6518a03	80fbd6de-3bbe-450a-a76c-d99427f7e73f	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.238462+00
144a0052-f40f-493e-9386-64743989d093	80fbd6de-3bbe-450a-a76c-d99427f7e73f	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.238462+00
42df2e69-3666-4a42-be3b-27f1cf6378b0	80fbd6de-3bbe-450a-a76c-d99427f7e73f	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.238462+00
a83449ae-c70e-45e3-8f9c-41bb1791d9d1	80fbd6de-3bbe-450a-a76c-d99427f7e73f	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.238462+00
e4ba5a3b-3177-43da-94ef-e9ce8b976bd0	80fbd6de-3bbe-450a-a76c-d99427f7e73f	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.238462+00
92cb8f7d-48e8-4fd9-8742-764cc0097c3d	80fbd6de-3bbe-450a-a76c-d99427f7e73f	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Great campaign! Dangote should also show more about their flour products.	\N	2026-05-04 11:14:32.238462+00
5fd3ff00-3848-4ebe-8cd1-759eb2abe2f4	65b6caac-5deb-410a-9d6c-b7c89718a49a	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.247905+00
f17500b8-dc1d-4b1d-b8c5-a23a355291ee	65b6caac-5deb-410a-9d6c-b7c89718a49a	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.247905+00
ee65ca2f-5d1b-46c5-8cd1-0c736e415a91	65b6caac-5deb-410a-9d6c-b7c89718a49a	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.247905+00
97d36823-c741-42b5-8aea-6d93c10a19e1	65b6caac-5deb-410a-9d6c-b7c89718a49a	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.247905+00
b35e700a-9fc8-438b-8c73-70a6c8ffc272	65b6caac-5deb-410a-9d6c-b7c89718a49a	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.247905+00
4d9f2d7c-a182-4386-88ff-73afe608c022	65b6caac-5deb-410a-9d6c-b7c89718a49a	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.247905+00
a85eec23-1f93-453e-9eff-13177c59c67e	65b6caac-5deb-410a-9d6c-b7c89718a49a	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.247905+00
8693748e-753c-46b8-b4ff-f30924e12256	65b6caac-5deb-410a-9d6c-b7c89718a49a	85d46e14-1258-44db-8c69-be4f7888de87	The testimonial angle works well. Nigerians trust word of mouth.	\N	2026-05-04 11:14:32.247905+00
2a7d9cb1-d801-4fa4-b8e5-2d4a00dbe7c8	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.255405+00
76acc714-9b52-4bec-b1c8-bade76f29698	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.255405+00
350b4ab7-5681-4548-88a1-5e7ab1934242	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.255405+00
f36c0baf-77c2-48e2-8eca-3d322d5a6035	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.255405+00
e5ddc3f1-fcbe-4803-9995-f70bdfe75f5f	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.255405+00
8f7fbdee-2700-447a-aff3-6ef23c65c34d	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.255405+00
86992455-bb1f-4c33-af19-7b4b4acc1651	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.255405+00
f26069e7-3e02-4b93-a02c-41ae612b6249	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Love how the ad shows the product in real construction scenarios.	\N	2026-05-04 11:14:32.255405+00
b5d4fa30-4f22-41fd-acc5-cc24fd0e1ca0	cc66ef4b-10d8-4c88-a875-7fd044894b61	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.265755+00
94e0d19b-fa80-48f6-9e9e-809560af5aef	cc66ef4b-10d8-4c88-a875-7fd044894b61	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.265755+00
fc3335be-0c60-4ce3-aff7-f5b1089af0f1	cc66ef4b-10d8-4c88-a875-7fd044894b61	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.265755+00
37bbac4e-4094-4649-8592-ddfa84d5b7e3	cc66ef4b-10d8-4c88-a875-7fd044894b61	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.265755+00
08aa78fa-ace4-41cd-80e8-d42b56bcffa1	cc66ef4b-10d8-4c88-a875-7fd044894b61	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.265755+00
4391b0c6-eeb6-492b-b759-4a2baa36240f	cc66ef4b-10d8-4c88-a875-7fd044894b61	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.265755+00
e44134a3-4f59-4583-99df-dcb49f8d8f9e	cc66ef4b-10d8-4c88-a875-7fd044894b61	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.265755+00
6c6aad4b-f6cd-4cfe-8c9a-5c4c02b2e572	cc66ef4b-10d8-4c88-a875-7fd044894b61	85d46e14-1258-44db-8c69-be4f7888de87	The testimonial angle works well. Nigerians trust word of mouth.	\N	2026-05-04 11:14:32.265755+00
5fde4697-cc9b-469b-8e14-48653bb2517f	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.27399+00
2d0e8984-9301-425a-96b0-558394bb1e83	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.27399+00
26839209-2948-458e-9c43-1399e62d5b85	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.27399+00
f4f74fde-e978-45e6-90c1-b3ef38d7a076	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.27399+00
6958771c-70f5-40dd-8a04-08d1e3d51c6f	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.27399+00
a3e533ed-9c47-4ea6-90dc-599498fa2d9e	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.27399+00
099f1f0c-7f7b-4b8b-88cc-0ea6eb331f81	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.27399+00
fe7cf004-96e1-4ad6-a7b0-83c4e333d70b	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Love how the ad shows the product in real construction scenarios.	\N	2026-05-04 11:14:32.27399+00
724016c4-95a4-453c-b7b1-d64c038d7a72	3541824c-3878-457c-a2a2-d463275cb923	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.283081+00
0eeae140-98a7-4662-be40-eed075899926	3541824c-3878-457c-a2a2-d463275cb923	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.283081+00
2545058f-79bf-4e40-ae4b-86ce9a35f370	3541824c-3878-457c-a2a2-d463275cb923	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:32.283081+00
9547ec28-c6b2-4266-8bc6-32d8557b5e7b	3541824c-3878-457c-a2a2-d463275cb923	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.283081+00
d9ddb0bf-05ab-4cd1-9623-c191cdf6d832	3541824c-3878-457c-a2a2-d463275cb923	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.283081+00
5c1d4d19-6adc-4f08-b904-2de3774e4b56	3541824c-3878-457c-a2a2-d463275cb923	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:32.283081+00
75e589c3-d045-40aa-8b2a-394ba547e221	3541824c-3878-457c-a2a2-d463275cb923	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.283081+00
87693d51-eaae-4c05-81a6-75b676b16234	3541824c-3878-457c-a2a2-d463275cb923	85d46e14-1258-44db-8c69-be4f7888de87	My village people use Dangote exclusively. Very trustworthy brand.	\N	2026-05-04 11:14:32.283081+00
84dc1ca0-9877-41d2-9ab6-91359581b7d0	2a5d24c1-663e-48ae-93d7-1c176d632f39	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.291039+00
0c514e96-b59c-4e41-8e7c-3a1ae678cc2a	2a5d24c1-663e-48ae-93d7-1c176d632f39	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.291039+00
032df81a-2aad-4baa-b66e-9abcd4d100ee	2a5d24c1-663e-48ae-93d7-1c176d632f39	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.291039+00
7e380d46-2dc6-41fb-9be8-d9e3f3dcc063	2a5d24c1-663e-48ae-93d7-1c176d632f39	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.291039+00
76ae8da2-52fc-4cc7-a23a-e3272be6a72f	2a5d24c1-663e-48ae-93d7-1c176d632f39	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.291039+00
7060b6ee-4e23-4d94-b30e-a39e8fadf28b	2a5d24c1-663e-48ae-93d7-1c176d632f39	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.291039+00
87d8e2be-5439-4ac7-821d-4aecd1d1e2d2	2a5d24c1-663e-48ae-93d7-1c176d632f39	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.291039+00
45c4cd29-5fde-4756-a7c2-7db92799167d	2a5d24c1-663e-48ae-93d7-1c176d632f39	85d46e14-1258-44db-8c69-be4f7888de87	My village people use Dangote exclusively. Very trustworthy brand.	\N	2026-05-04 11:14:32.291039+00
37d1e2e6-9f83-4188-a095-78ebac770e01	8b8d9163-6e91-4064-9a12-9c209112a14b	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.29998+00
2fbd27d5-99fc-4c3e-abdf-f2ec4fe37494	8b8d9163-6e91-4064-9a12-9c209112a14b	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.29998+00
8bc22fa4-e818-4260-bec9-1eeb46580ffc	8b8d9163-6e91-4064-9a12-9c209112a14b	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:32.29998+00
4a9a0ce1-5be7-4b72-95a3-be79ca389f65	8b8d9163-6e91-4064-9a12-9c209112a14b	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.29998+00
19b0a4a2-8ae7-41e5-9c0e-80abe8231138	8b8d9163-6e91-4064-9a12-9c209112a14b	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.29998+00
7a0be0dd-0306-4b9f-a101-e183dc380939	8b8d9163-6e91-4064-9a12-9c209112a14b	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.29998+00
1419f9ab-8438-4faa-b26b-46243f9d2460	8b8d9163-6e91-4064-9a12-9c209112a14b	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.29998+00
b365190e-b325-4e26-b097-5b7fac38b6c4	8b8d9163-6e91-4064-9a12-9c209112a14b	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad was engaging from start to finish. No dull moments.	\N	2026-05-04 11:14:32.29998+00
13a7f1ab-c69b-4914-82cc-d0c2ce8bfff7	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.309179+00
e86484c9-67fa-4276-b0a9-5025b84c1ef3	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.309179+00
9ba18928-8664-4a9f-acbd-fe0bfd8f8c3c	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.309179+00
c5f88ccb-b4ad-4c63-ad6f-ef2f48880a41	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.309179+00
c2f957d9-f2e7-4662-8766-021bf8db0e37	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.309179+00
e6750a50-82da-4fc5-910b-36d7d18b7633	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.309179+00
442db1c8-0369-40ed-b4bf-a4192ba40edb	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.309179+00
b6edbb96-b1dd-4eec-a92e-6d3a665c6f38	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	85d46e14-1258-44db-8c69-be4f7888de87	Dangote is doing great work for Nigeria's economy. Ad reflects that.	\N	2026-05-04 11:14:32.309179+00
ca3330b2-e2d7-44c6-ba88-49947bf50542	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.317972+00
091561ec-3cae-4866-a804-399c1b7da568	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.317972+00
72aacd5f-5065-436a-bf85-5b6addc9aeb4	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:32.317972+00
e4722ff3-8705-4c9e-a0b2-6dcd684892d1	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.317972+00
d002c004-844c-4b8b-b5d7-470987147c80	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.317972+00
f1fe86f6-98b4-46d1-8384-3fc08bbdf3b6	177a5447-12a8-4949-8621-f08437390dba	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.571173+00
5a41133d-4ee6-4aa5-8bb7-f689016e4418	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.317972+00
f0159fb6-7bb1-4d0e-8f69-8fdf9678e00a	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.317972+00
a5aa00ce-d841-4692-97a1-7c00050d7a7b	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad was engaging from start to finish. No dull moments.	\N	2026-05-04 11:14:32.317972+00
58171d6c-1dce-42b8-b070-a37030417d0d	78912820-0591-4e12-a542-edc20172d705	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.326402+00
39cd4f8f-29cc-4c91-933b-6bc726e2d7f5	78912820-0591-4e12-a542-edc20172d705	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.326402+00
9a3676bc-1aa9-45ca-b052-32e74c1acbd6	78912820-0591-4e12-a542-edc20172d705	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.326402+00
0892e1a8-6845-4e9d-9322-602ab58c5dfb	78912820-0591-4e12-a542-edc20172d705	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.326402+00
fdd5db9b-2e8d-46f6-9768-617be2de1f91	78912820-0591-4e12-a542-edc20172d705	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.326402+00
5f0a92e8-2139-466b-ae67-c61b3635e4f2	78912820-0591-4e12-a542-edc20172d705	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.326402+00
2b79f1db-b2c3-4c52-a67b-440c2b72acc9	78912820-0591-4e12-a542-edc20172d705	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.326402+00
5cad8477-1ad3-4680-8bba-1543988c5747	78912820-0591-4e12-a542-edc20172d705	85d46e14-1258-44db-8c69-be4f7888de87	Dangote is doing great work for Nigeria's economy. Ad reflects that.	\N	2026-05-04 11:14:32.326402+00
84f20412-2141-4cbe-b996-aa46347acecc	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.33644+00
718688c6-36d2-49a1-b8a1-5b7430ae1ab3	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.33644+00
0275839f-40bf-4dfb-892b-94eb6cf86501	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.33644+00
70adbd93-0450-42f2-8b63-3d721237189b	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.33644+00
d9f82f2a-f4ab-4a30-b97b-9529b00bb160	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.33644+00
d972ba53-8111-4145-9a9d-f25ce5fd9358	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.33644+00
7684febb-6838-4e37-9e9b-25452f2ba698	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.33644+00
3e7f4bd5-d809-4773-8aac-c2f2a5071da9	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Clear messaging, strong brand presence. Would watch again.	\N	2026-05-04 11:14:32.33644+00
e8e5423c-6064-4978-b72f-5377fd66e0f1	90e97409-0a49-4473-95a8-8c36818b566e	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.346883+00
01e2957c-4ad1-40d8-9d8f-5fedd8347c86	90e97409-0a49-4473-95a8-8c36818b566e	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.346883+00
b7a9a6a0-fc6c-42df-9417-2624bd07b2b1	90e97409-0a49-4473-95a8-8c36818b566e	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.346883+00
278bb802-bba2-4810-a88b-9c1bbd3b0688	90e97409-0a49-4473-95a8-8c36818b566e	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.346883+00
c4571315-c1b4-4c3b-be19-ef84990f0e31	90e97409-0a49-4473-95a8-8c36818b566e	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.346883+00
6e4fe61c-f06a-4248-bc98-82457e76680c	90e97409-0a49-4473-95a8-8c36818b566e	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.346883+00
4d7a48ec-66fb-4fc8-b1fc-4adc60164518	90e97409-0a49-4473-95a8-8c36818b566e	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.346883+00
4576354b-5e3a-4254-8eca-6de2f658b716	90e97409-0a49-4473-95a8-8c36818b566e	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Clear messaging, strong brand presence. Would watch again.	\N	2026-05-04 11:14:32.346883+00
1dc21d32-ece1-49c7-b660-ec7f5dab6572	1f68e0e5-5aee-4e65-ac90-030fceddf762	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.356199+00
e1c0d42e-ea5c-4c32-8e30-3ea2ce76fd0e	1f68e0e5-5aee-4e65-ac90-030fceddf762	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.356199+00
c2ee459b-3d3f-4c66-bdea-7f1f575c2ffa	1f68e0e5-5aee-4e65-ac90-030fceddf762	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.356199+00
3179fa2d-fc69-4237-9d40-6977e8665157	1f68e0e5-5aee-4e65-ac90-030fceddf762	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.356199+00
c2d27f1a-f714-4640-9185-d29a9ef96c77	1f68e0e5-5aee-4e65-ac90-030fceddf762	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.356199+00
a83cd72b-def6-4d33-8ba7-f4b66c819e41	1f68e0e5-5aee-4e65-ac90-030fceddf762	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.356199+00
795bdd18-bb6e-436b-bb13-aa34e0885bb6	1f68e0e5-5aee-4e65-ac90-030fceddf762	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.356199+00
82d55577-0b5c-4b7c-b851-3f6da7ff871c	1f68e0e5-5aee-4e65-ac90-030fceddf762	85d46e14-1258-44db-8c69-be4f7888de87	The ad reminded me to place an order for my building project in Lagos.	\N	2026-05-04 11:14:32.356199+00
5a33492f-7684-479f-b913-2ddc34e3e276	4febb231-2806-4e16-8755-e092d92206d8	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.364189+00
4c343c8f-6166-4099-8d3a-342874e89a0e	4febb231-2806-4e16-8755-e092d92206d8	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.364189+00
1d8e9d66-48d1-482e-bd9f-627831cfc807	4febb231-2806-4e16-8755-e092d92206d8	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.364189+00
d847b341-9fbe-46c8-b52a-d06333cc2b7d	4febb231-2806-4e16-8755-e092d92206d8	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.364189+00
b67ee72f-d1f2-4631-924f-c63075428db9	4febb231-2806-4e16-8755-e092d92206d8	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.364189+00
81436222-3e47-4819-8d50-68c380f18e34	4febb231-2806-4e16-8755-e092d92206d8	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.364189+00
27d53699-9d32-4aeb-ac52-1c10bc6a930a	4febb231-2806-4e16-8755-e092d92206d8	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.364189+00
7ca70a02-4170-4e1f-8428-cf0385666a62	4febb231-2806-4e16-8755-e092d92206d8	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Excellent quality, excellent ad. Five stars from me.	\N	2026-05-04 11:14:32.364189+00
9dc4d956-3a5c-445a-87b8-c2dcea749851	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.373141+00
6443689c-f01a-469c-a0d4-89152f801ff2	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:32.373141+00
b24b3cb3-684e-44e8-b07d-c1d307371196	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.373141+00
799cd2ce-58f6-47bd-802a-6d1c59297375	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.373141+00
16366487-d599-4c0a-a191-4cef318b5b1e	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.373141+00
d2c4a194-f481-4cab-8d1c-6c262b91e143	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.373141+00
c0b13c19-1c91-469b-a8c6-3a4fb06fbc2c	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.373141+00
ea7c44b4-caa7-4691-8f18-a0c520bf5300	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	85d46e14-1258-44db-8c69-be4f7888de87	The ad reminded me to place an order for my building project in Lagos.	\N	2026-05-04 11:14:32.373141+00
a3752f57-5a4a-4349-989b-2183c6cace39	515c1d52-978d-4e4d-92c7-a99a5b62d690	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.381277+00
1a20ec41-1f00-41de-b30a-df613b476480	515c1d52-978d-4e4d-92c7-a99a5b62d690	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.381277+00
55cf5f59-0980-45ff-a535-46fe8c3430a5	515c1d52-978d-4e4d-92c7-a99a5b62d690	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.381277+00
ea6a1c50-e995-4a62-99a3-f7b09db4c039	515c1d52-978d-4e4d-92c7-a99a5b62d690	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.381277+00
7349e99d-476b-40b7-b025-fc8ea42d86c5	515c1d52-978d-4e4d-92c7-a99a5b62d690	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.381277+00
338c0035-c7d7-456c-9d3f-87275a6b7130	515c1d52-978d-4e4d-92c7-a99a5b62d690	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.381277+00
2629cb35-fab3-458b-8929-69102876e9b4	515c1d52-978d-4e4d-92c7-a99a5b62d690	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.381277+00
f5305a08-1799-44b5-8ef1-e314cb2d6a99	515c1d52-978d-4e4d-92c7-a99a5b62d690	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Excellent quality, excellent ad. Five stars from me.	\N	2026-05-04 11:14:32.381277+00
e8349f76-0771-48db-8704-0ed8395ae0d1	4dfba325-40ab-440a-96ff-794a78f627c5	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.390701+00
2a949fd4-cfa9-48b7-bef2-82c8a8377b38	4dfba325-40ab-440a-96ff-794a78f627c5	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:32.390701+00
c9c0c122-a231-48f7-af6b-04326fe882e9	4dfba325-40ab-440a-96ff-794a78f627c5	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.390701+00
292343dd-11b3-4943-98c1-7b3c5859d5b9	4dfba325-40ab-440a-96ff-794a78f627c5	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.390701+00
e20aebc2-564a-4bab-b9fd-b820e744fb4d	4dfba325-40ab-440a-96ff-794a78f627c5	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.390701+00
83f01f9e-c6d6-47b0-89c3-39cea612b619	4dfba325-40ab-440a-96ff-794a78f627c5	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.390701+00
ab17d20d-b7b0-4c3f-8fcd-38e1c29cf1b9	4dfba325-40ab-440a-96ff-794a78f627c5	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.390701+00
d3803cd4-aa5e-463c-92c3-2d2d2ad79cd3	4dfba325-40ab-440a-96ff-794a78f627c5	85d46e14-1258-44db-8c69-be4f7888de87	I liked how the ad focused on strength and durability. That's what matters.	\N	2026-05-04 11:14:32.390701+00
95b042fa-d6bf-4a7d-8817-a3dc90a90f7b	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.399617+00
17f0d304-9791-45c7-ae58-c5e043a56d99	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.399617+00
7ccdc396-0868-42b0-9f85-de8e73b1a4d3	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:32.399617+00
0983ff76-8110-47b8-b43c-b615144c3c45	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.399617+00
a6846f14-aa0e-4cd2-9894-a4d2ecfc4686	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.399617+00
cd297a32-a90e-4b1e-8534-e6e764cbff88	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.399617+00
28c17c5a-ac9d-4100-8537-6d2099482dab	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.399617+00
b4b53f17-a712-47c9-b5fe-55b29e88a124	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	85d46e14-1258-44db-8c69-be4f7888de87	I liked how the ad focused on strength and durability. That's what matters.	\N	2026-05-04 11:14:32.399617+00
800d18d1-e148-4a60-89b7-6218d96b9b9d	be4796ff-4e4f-4d30-9d71-8b98a825211e	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.408524+00
72b89e04-f32a-4f6b-a3f9-0d3d5a117128	be4796ff-4e4f-4d30-9d71-8b98a825211e	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.408524+00
2a3f1993-dbe1-4226-a1ce-31bdc7ccfd45	be4796ff-4e4f-4d30-9d71-8b98a825211e	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.408524+00
d7a61dda-b1d0-429c-8941-20695d3d46b0	be4796ff-4e4f-4d30-9d71-8b98a825211e	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.408524+00
c9657940-6f58-4558-a690-dd618cb7c50b	be4796ff-4e4f-4d30-9d71-8b98a825211e	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.408524+00
f2e01f3b-fdfd-49f5-9845-860b9e5269fa	be4796ff-4e4f-4d30-9d71-8b98a825211e	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.408524+00
30821e4e-c358-44e5-8879-424f0e548496	be4796ff-4e4f-4d30-9d71-8b98a825211e	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.408524+00
4534f8c3-826a-46c5-9032-433a55d11cd1	be4796ff-4e4f-4d30-9d71-8b98a825211e	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The campaign speaks directly to builders and homeowners. Very targeted.	\N	2026-05-04 11:14:32.408524+00
d89b9935-6c01-485f-ac6a-fa2ccafe1e4b	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.417966+00
aa474787-03bd-44e6-bbc3-bd37f5634bb3	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.417966+00
7fa9e761-d65c-4d25-bbc9-5d7944bb145a	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.417966+00
dc115e65-4b7a-40a3-a84c-bc5473fb0761	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.417966+00
9ef1d0f1-73cb-4457-9b43-8aacea6644c2	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.417966+00
440d08a5-b325-4e45-a0cc-aa3b67e2110c	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.417966+00
6906040c-fc6b-4164-80b7-74847670ed13	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.417966+00
310776d7-1622-424c-830a-742fc4493414	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	85d46e14-1258-44db-8c69-be4f7888de87	Would have liked more info on pricing but overall a solid ad.	\N	2026-05-04 11:14:32.417966+00
071be3b9-4951-42a2-9fd7-f3cc44e07f91	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.42695+00
7e8324ce-af11-4487-bc87-1ad2caf5dd0a	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.42695+00
c0969978-7c5b-4010-b367-dcc85bbe2605	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.42695+00
891eeacd-f6f1-4c2d-b855-725e2632d476	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.42695+00
fb003d78-adc7-43aa-9149-68571f3a2469	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.42695+00
e865fa98-eb23-4af8-9e87-0598b16fefb3	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.42695+00
683bbd15-d720-4090-a4b4-9e861d163546	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.42695+00
0c4d6948-1427-4e49-92b4-1a77c916ca46	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The campaign speaks directly to builders and homeowners. Very targeted.	\N	2026-05-04 11:14:32.42695+00
34e2fabf-2f29-4ab9-a0f1-45ec66a76714	c048f72a-b2ee-4172-b57f-6e61e25c323b	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.436233+00
9dfd7772-9ad9-4838-bc91-eb76a8db1c1e	c048f72a-b2ee-4172-b57f-6e61e25c323b	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.436233+00
ceed356e-1f39-4502-933f-aa3c963851f0	c048f72a-b2ee-4172-b57f-6e61e25c323b	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.436233+00
98bb22e4-58c7-418c-b20d-0f5a759db885	c048f72a-b2ee-4172-b57f-6e61e25c323b	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.436233+00
add51d60-c8b7-420f-be14-125e78216e05	c048f72a-b2ee-4172-b57f-6e61e25c323b	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.436233+00
2c470e4e-06c1-4887-97d8-35f8c6576e74	c048f72a-b2ee-4172-b57f-6e61e25c323b	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.436233+00
cf0b4385-27d2-4f70-b4c1-38cd29d228ac	c048f72a-b2ee-4172-b57f-6e61e25c323b	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.436233+00
b03aed61-0115-4af8-a02d-84059ec888b2	c048f72a-b2ee-4172-b57f-6e61e25c323b	85d46e14-1258-44db-8c69-be4f7888de87	Would have liked more info on pricing but overall a solid ad.	\N	2026-05-04 11:14:32.436233+00
72de51b6-c8d6-4215-8355-e5db896703d0	325e95e1-cf75-4237-b192-4108dfb5b9ce	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.44559+00
37029709-ed03-41f7-ad4b-1e173a59990c	325e95e1-cf75-4237-b192-4108dfb5b9ce	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:32.44559+00
b08eb2e8-1b72-435a-9459-1483fd8b3972	325e95e1-cf75-4237-b192-4108dfb5b9ce	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.44559+00
c45cfa1a-3f53-4cfa-8b82-3a508f2ddadd	325e95e1-cf75-4237-b192-4108dfb5b9ce	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.44559+00
d3859cf3-10fb-4ea0-911a-3280c3a59edf	325e95e1-cf75-4237-b192-4108dfb5b9ce	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.44559+00
90296f61-91e0-46c6-a383-e4af0e5b52a8	325e95e1-cf75-4237-b192-4108dfb5b9ce	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.44559+00
9243f05c-a37b-491f-9e8c-cb043d1bc473	325e95e1-cf75-4237-b192-4108dfb5b9ce	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.44559+00
aeeae768-ae49-4408-8818-568a86b52905	325e95e1-cf75-4237-b192-4108dfb5b9ce	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote brand always delivers. This ad is no exception.	\N	2026-05-04 11:14:32.44559+00
e31ef3ed-3b1e-45c1-aa93-f1d20157f725	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.454143+00
78ba3e47-e680-4a30-90c5-cdc75fc3b993	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.454143+00
2282964a-6f52-45fb-8cf1-77d9bff4445b	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:32.454143+00
5316c63e-265a-4db0-bcd3-079f53ce705f	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.454143+00
a7fa0c44-99d7-499e-94b7-6b59e130d1af	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.454143+00
e571809c-0c42-44fc-85b7-f1a4751c70e0	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.454143+00
9e9afae3-9d56-427d-bfe7-28b69d2072e7	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.454143+00
467fcfc5-33a2-4383-9ab3-398535836cf8	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote brand always delivers. This ad is no exception.	\N	2026-05-04 11:14:32.454143+00
1ef011a2-fd3d-48f5-976a-c49ebaad12fd	b8e0723a-1a1e-495a-9182-778122c42f4b	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.462337+00
5812269d-77f9-4861-9271-40a377e5437f	b8e0723a-1a1e-495a-9182-778122c42f4b	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.462337+00
5d816498-f5c4-4039-92d4-a077a46f2b49	b8e0723a-1a1e-495a-9182-778122c42f4b	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.462337+00
22d533ce-ee9f-4442-b11b-6ca15a8da60d	b8e0723a-1a1e-495a-9182-778122c42f4b	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.462337+00
9fc56d62-b72e-487d-aabc-97ca6e1ceb39	b8e0723a-1a1e-495a-9182-778122c42f4b	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.462337+00
a58f4780-3b5b-44fd-806a-7bfeca9b0f06	b8e0723a-1a1e-495a-9182-778122c42f4b	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.462337+00
d5384cb0-78de-49e2-9baf-4fe87cdb7536	b8e0723a-1a1e-495a-9182-778122c42f4b	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.462337+00
d18e948a-a078-4481-a9dd-d17882684665	b8e0723a-1a1e-495a-9182-778122c42f4b	85d46e14-1258-44db-8c69-be4f7888de87	The visuals were stunning. Shows construction in a positive Nigerian light.	\N	2026-05-04 11:14:32.462337+00
447dc5a9-d0c4-4889-82d6-483eb9069a26	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.470902+00
74cadcff-b361-4508-aec4-3851d3fae843	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.470902+00
72021349-0d3f-4c71-b38f-0b4c7b8eff1e	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.470902+00
926a463f-bece-410d-af44-21a5606ac98b	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.470902+00
ac9d23db-f698-47cf-bdc6-68e5e972c771	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.470902+00
ef891aa5-00bb-488b-812e-7493a0609c87	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.470902+00
a9b53c38-eedc-4b07-ae27-b2885e7b3d99	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.470902+00
c7e024d2-d0b2-48a4-af94-018621b89467	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	As a quantity surveyor, I specify Dangote in all my projects. Great ad.	\N	2026-05-04 11:14:32.470902+00
c579a04f-5c8e-4edd-8bda-d309c10b8822	246352f8-8aad-4b58-ac0e-8e95952af2a1	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.480949+00
f880e5cf-e111-4779-947f-08f55f80dccc	246352f8-8aad-4b58-ac0e-8e95952af2a1	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.480949+00
4c7db986-4971-49af-8182-6b05a1bea194	246352f8-8aad-4b58-ac0e-8e95952af2a1	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.480949+00
754fdc6f-192f-4700-a49c-660036ea4e70	246352f8-8aad-4b58-ac0e-8e95952af2a1	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.480949+00
6d5962ed-2553-42c1-b837-776919f23741	246352f8-8aad-4b58-ac0e-8e95952af2a1	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.480949+00
2813f9a4-e02b-4f8e-805f-d571f682a827	246352f8-8aad-4b58-ac0e-8e95952af2a1	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.480949+00
85305025-a41a-4bf0-b48e-8cd2fa700fb0	246352f8-8aad-4b58-ac0e-8e95952af2a1	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.480949+00
e23c28be-2cc5-49dd-b2d3-5f619743616f	246352f8-8aad-4b58-ac0e-8e95952af2a1	85d46e14-1258-44db-8c69-be4f7888de87	The visuals were stunning. Shows construction in a positive Nigerian light.	\N	2026-05-04 11:14:32.480949+00
556856b7-2409-462f-8e57-19842ec51bc8	177a5447-12a8-4949-8621-f08437390dba	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.571173+00
353339b9-0014-4042-add1-e4637ddca56a	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.489325+00
a464446d-1521-4dee-a772-6a21bd3b00a0	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.489325+00
64d5ebb8-ed03-418e-9432-52573c2eb309	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:32.489325+00
75d114e9-d7e6-4347-9867-ac669249872d	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.489325+00
6888349c-ab84-4a0a-a4b9-8886f91eb5b5	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.489325+00
c6b4b9bf-89b6-4c79-9dea-743b920bf75d	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.489325+00
e8cbf30f-7c7f-467c-b67f-4bc4d4f82036	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.489325+00
8a7d519f-0fae-49d2-82de-c20ed5705f03	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	As a quantity surveyor, I specify Dangote in all my projects. Great ad.	\N	2026-05-04 11:14:32.489325+00
50496348-e5fe-490d-9988-412c4eb70f37	1194ae8a-04b2-4479-bee7-afe012ff1090	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.498293+00
feab47cf-151c-46dc-bbdb-22bb7c5a98c7	1194ae8a-04b2-4479-bee7-afe012ff1090	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.498293+00
93d1624e-e4cc-458d-b2f3-e527ff44736c	1194ae8a-04b2-4479-bee7-afe012ff1090	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:32.498293+00
9bbb3f27-73f8-4ba2-a847-2e5a47893ba0	1194ae8a-04b2-4479-bee7-afe012ff1090	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.498293+00
46e9e74e-c6af-4607-b4e3-c69458631736	1194ae8a-04b2-4479-bee7-afe012ff1090	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.498293+00
68d21b73-d2c3-41a5-a848-1ebebf86b2b9	1194ae8a-04b2-4479-bee7-afe012ff1090	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.498293+00
e2d24bd3-f9c1-4534-a7a7-5f71ea13323b	1194ae8a-04b2-4479-bee7-afe012ff1090	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.498293+00
170b9803-e57b-4741-9f49-8cf3f99c6ba2	1194ae8a-04b2-4479-bee7-afe012ff1090	85d46e14-1258-44db-8c69-be4f7888de87	The ad captures the essence of why Dangote is Nigeria's #1 brand.	\N	2026-05-04 11:14:32.498293+00
e1554387-f2a4-42e3-870f-d150a7181f30	3f7da559-98d1-4bcc-8365-a075ebd290f1	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.507301+00
cc17e547-fc75-433b-bd9a-8cca01ac0494	3f7da559-98d1-4bcc-8365-a075ebd290f1	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.507301+00
f01d2b9d-4219-4196-9f80-5a47338aaa2b	3f7da559-98d1-4bcc-8365-a075ebd290f1	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:32.507301+00
97238b37-e41e-46a4-b337-2f96c9606d7c	3f7da559-98d1-4bcc-8365-a075ebd290f1	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.507301+00
fa3ba280-d3c1-4e83-8e5a-1b1704be3626	3f7da559-98d1-4bcc-8365-a075ebd290f1	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.507301+00
6eb64c58-cb43-4013-9cb4-48c9e48e0fa0	3f7da559-98d1-4bcc-8365-a075ebd290f1	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.507301+00
84fa4c23-41c1-490d-91bf-24a184587c61	3f7da559-98d1-4bcc-8365-a075ebd290f1	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.507301+00
a8e7f7a4-d3a1-4f03-86e2-42a040ae9aa9	3f7da559-98d1-4bcc-8365-a075ebd290f1	85d46e14-1258-44db-8c69-be4f7888de87	The ad captures the essence of why Dangote is Nigeria's #1 brand.	\N	2026-05-04 11:14:32.507301+00
5512a8dc-5c71-45f5-a0c1-80f1655c4bd0	d13804bc-663a-4f64-8194-5bc500792242	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.516116+00
d89ee438-ddab-4456-b179-28005436c53a	d13804bc-663a-4f64-8194-5bc500792242	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:32.516116+00
df178703-46f2-4312-9cc2-791fa92fd5d3	d13804bc-663a-4f64-8194-5bc500792242	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.516116+00
6ee0562a-9a1c-400d-a487-f1392d36ed96	d13804bc-663a-4f64-8194-5bc500792242	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.516116+00
8503f65f-06d7-4a18-9a4d-205a22bf8c56	d13804bc-663a-4f64-8194-5bc500792242	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.516116+00
b4fb497e-6555-4c6c-9dd9-1d6d79be84e9	d13804bc-663a-4f64-8194-5bc500792242	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.516116+00
50fb7449-a916-4b20-8af4-8d90d29893d7	d13804bc-663a-4f64-8194-5bc500792242	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.516116+00
a11c3077-dd23-4671-8db9-bf2baf9e145a	d13804bc-663a-4f64-8194-5bc500792242	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very motivating. Made me proud to be Nigerian seeing this brand succeed.	\N	2026-05-04 11:14:32.516116+00
86ef4d2c-a2a4-4fd1-8319-c908624d962b	766fc026-db0b-4ba2-bf65-aec3147ad9c1	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.524578+00
ea21970a-ca3f-40f4-9eb7-d911d3502ba8	766fc026-db0b-4ba2-bf65-aec3147ad9c1	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.524578+00
d7b35cfb-91f9-4374-9a5b-23d49d69e745	766fc026-db0b-4ba2-bf65-aec3147ad9c1	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:32.524578+00
74bf2656-f500-45dc-ad61-48e08600776f	766fc026-db0b-4ba2-bf65-aec3147ad9c1	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.524578+00
9a7723c6-5e7d-4365-b1c0-1af3827e0cdf	766fc026-db0b-4ba2-bf65-aec3147ad9c1	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.524578+00
b163d319-f8f7-4c77-a640-40f3c0fff9e8	766fc026-db0b-4ba2-bf65-aec3147ad9c1	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.524578+00
a06c5734-9134-443b-88e4-14e25146d6aa	766fc026-db0b-4ba2-bf65-aec3147ad9c1	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.524578+00
4c863553-b1e7-47cc-8395-82bb0d89b15b	766fc026-db0b-4ba2-bf65-aec3147ad9c1	85d46e14-1258-44db-8c69-be4f7888de87	The music in the ad was catchy. Stayed with me afterwards.	\N	2026-05-04 11:14:32.524578+00
a171de88-0847-4ce2-974b-2eff083dea76	a6c50394-a89d-48ec-8e74-bea785ba2851	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.533546+00
70efe13f-b8b1-4714-8286-485e50e1f404	a6c50394-a89d-48ec-8e74-bea785ba2851	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.533546+00
0e4db3e3-cb30-4071-b0b8-fcc4dded8452	a6c50394-a89d-48ec-8e74-bea785ba2851	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.533546+00
7604be22-fd02-4475-8a29-704a3e51fcc4	a6c50394-a89d-48ec-8e74-bea785ba2851	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.533546+00
39f524e8-00f9-4ea4-a70d-e8f21c368b4a	a6c50394-a89d-48ec-8e74-bea785ba2851	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.533546+00
b7074b64-3251-453b-9415-9b564cbe0c01	a6c50394-a89d-48ec-8e74-bea785ba2851	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.533546+00
be455fdd-827c-4858-8a20-8b194ce04d9f	a6c50394-a89d-48ec-8e74-bea785ba2851	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.533546+00
abfab087-c3d8-4caf-914b-2741e8621e1e	a6c50394-a89d-48ec-8e74-bea785ba2851	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very motivating. Made me proud to be Nigerian seeing this brand succeed.	\N	2026-05-04 11:14:32.533546+00
2b2bb3b9-d75e-400f-9219-933f04f86065	788d08fe-1793-40f6-8bcb-08bf7da77497	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.543446+00
437e673f-6aae-4f3c-b734-34407c2c3f0e	788d08fe-1793-40f6-8bcb-08bf7da77497	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.543446+00
7ae123d1-daa6-4bd1-a60e-617c45e9f548	788d08fe-1793-40f6-8bcb-08bf7da77497	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:32.543446+00
60def3b9-d4c6-4cce-932f-dd54855a5f54	788d08fe-1793-40f6-8bcb-08bf7da77497	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.543446+00
0453bd7e-8f75-4496-b303-e7f7c708e955	788d08fe-1793-40f6-8bcb-08bf7da77497	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.543446+00
323ec337-5af1-4ec8-a4c7-692addefc0af	788d08fe-1793-40f6-8bcb-08bf7da77497	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.543446+00
036aeaee-26b0-4320-bb2d-0f5d9a09ed39	788d08fe-1793-40f6-8bcb-08bf7da77497	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.543446+00
66152c92-21f8-4aff-bf57-4905defd8009	788d08fe-1793-40f6-8bcb-08bf7da77497	85d46e14-1258-44db-8c69-be4f7888de87	The music in the ad was catchy. Stayed with me afterwards.	\N	2026-05-04 11:14:32.543446+00
44a2cf40-8294-4f9f-91af-8c9128962ee8	51d754be-acd8-4060-806a-83607ab58b41	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.552932+00
5c0f1772-07d5-4c2c-b245-43a1b3905234	51d754be-acd8-4060-806a-83607ab58b41	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.552932+00
076e50df-c084-482e-adc1-9aa920e78288	51d754be-acd8-4060-806a-83607ab58b41	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.552932+00
b1c9f8bd-348b-4224-82d8-6300b15abf11	51d754be-acd8-4060-806a-83607ab58b41	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.552932+00
7fc34892-a664-47ab-911b-b6dd11bb45ce	51d754be-acd8-4060-806a-83607ab58b41	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.552932+00
f1daef80-cadd-47ac-9af0-0ba6e471a930	51d754be-acd8-4060-806a-83607ab58b41	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.552932+00
b6442c70-b5eb-4d67-9b9d-9050c978c967	51d754be-acd8-4060-806a-83607ab58b41	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.552932+00
1d3087af-5944-460a-bdaf-1e2fdbb88ddd	51d754be-acd8-4060-806a-83607ab58b41	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Product messaging was spot on. Would recommend to fellow contractors.	\N	2026-05-04 11:14:32.552932+00
078d19f3-1fc9-4c76-814c-13a7d1d08a80	7e4d6e75-b8f9-4817-8a60-996218899499	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.562148+00
128eb9b4-2bc6-4e5b-9ef2-6a086bd1f910	7e4d6e75-b8f9-4817-8a60-996218899499	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.562148+00
5228b118-1b9b-41ee-a35f-8001a68d0053	7e4d6e75-b8f9-4817-8a60-996218899499	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:32.562148+00
3763c188-363d-4991-a029-80d9a8b50b82	7e4d6e75-b8f9-4817-8a60-996218899499	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.562148+00
5de1506b-37b1-4518-91ee-b0361ca33702	7e4d6e75-b8f9-4817-8a60-996218899499	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.562148+00
e6c2dc40-79f8-4a01-9d03-28f008760544	7e4d6e75-b8f9-4817-8a60-996218899499	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.562148+00
e50390e2-ba7f-4f78-b135-59a370a05236	7e4d6e75-b8f9-4817-8a60-996218899499	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.562148+00
c1582457-34ed-431f-89c0-9163a49fbca9	7e4d6e75-b8f9-4817-8a60-996218899499	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Product messaging was spot on. Would recommend to fellow contractors.	\N	2026-05-04 11:14:32.562148+00
4562e479-5e25-469a-8ed3-ee6020dcf8a4	177a5447-12a8-4949-8621-f08437390dba	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.571173+00
cc36aa9b-c454-4423-a526-49a29956ac2a	177a5447-12a8-4949-8621-f08437390dba	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.571173+00
127b6385-6d84-40c1-982f-1a6524657c5e	177a5447-12a8-4949-8621-f08437390dba	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.571173+00
cc1b2b3c-0ea2-47c4-bb19-7fa370377dd8	177a5447-12a8-4949-8621-f08437390dba	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.571173+00
3031b1b8-7eca-4502-99d7-397790478fdb	177a5447-12a8-4949-8621-f08437390dba	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.571173+00
8b65eb41-4ecb-49a1-830a-e8635d4376fd	177a5447-12a8-4949-8621-f08437390dba	85d46e14-1258-44db-8c69-be4f7888de87	Too short but very impactful. Quality over quantity — like the cement!	\N	2026-05-04 11:14:32.571173+00
25f058f0-6a5f-4527-9dee-b6e148607232	c2083c67-18dc-450e-a93a-e2477b88e6d0	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.584219+00
bdb5e2cc-ef73-4ebe-8134-aaa0af377506	c2083c67-18dc-450e-a93a-e2477b88e6d0	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.584219+00
1aac7dcb-7017-4e75-aaaa-1f4bdfca5a96	c2083c67-18dc-450e-a93a-e2477b88e6d0	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.584219+00
419a6a45-3eef-43ab-ad60-e93c1b278975	c2083c67-18dc-450e-a93a-e2477b88e6d0	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.584219+00
4568ce50-2aa8-4099-ae50-7cdd7f570abb	c2083c67-18dc-450e-a93a-e2477b88e6d0	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.584219+00
17bdc567-4e78-4065-907f-155d8a118795	c2083c67-18dc-450e-a93a-e2477b88e6d0	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.584219+00
2e5bd160-07b4-4e30-af18-61c88db5b440	c2083c67-18dc-450e-a93a-e2477b88e6d0	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.584219+00
07f84c2b-321a-40b8-af73-839c0fd5fff3	c2083c67-18dc-450e-a93a-e2477b88e6d0	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	I've switched to Dangote from foreign brands. No going back.	\N	2026-05-04 11:14:32.584219+00
ed97c229-b040-4557-929c-990540a64776	b5efae7e-a07a-41c5-a0cd-76885114ee0d	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.593309+00
882043f2-7dc2-4ca5-b556-269d41233613	b5efae7e-a07a-41c5-a0cd-76885114ee0d	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.593309+00
414c9cef-c3ec-4c6b-a8ee-6500ce1ee778	b5efae7e-a07a-41c5-a0cd-76885114ee0d	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.593309+00
9176a490-7fb7-4e82-8fa5-e00caf87a560	b5efae7e-a07a-41c5-a0cd-76885114ee0d	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.593309+00
b75553ad-751e-45a0-8fa7-249b6dfd1af4	b5efae7e-a07a-41c5-a0cd-76885114ee0d	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.593309+00
1c53558b-e660-430c-b9d5-226c4426c802	b5efae7e-a07a-41c5-a0cd-76885114ee0d	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.593309+00
ac0e7fd8-057e-405a-a1b9-5fa46832e99b	b5efae7e-a07a-41c5-a0cd-76885114ee0d	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.593309+00
a20f6d49-b424-4cc7-a148-a2a25a395570	b5efae7e-a07a-41c5-a0cd-76885114ee0d	85d46e14-1258-44db-8c69-be4f7888de87	Too short but very impactful. Quality over quantity — like the cement!	\N	2026-05-04 11:14:32.593309+00
092a1403-396a-48c7-bf06-5a02320be92b	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.60559+00
dd6306f6-ffc7-4622-88a8-fa375d5731d4	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.60559+00
9d460bd3-fc41-406e-a224-47e058388a33	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.60559+00
37e35402-fe80-4210-bc6d-7a623ae602d9	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.60559+00
88fee07b-5dd7-4710-9ebc-7a97db0ece10	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.60559+00
dfe98565-5f9c-4196-8d76-06e8b67369a3	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.60559+00
c0c5413c-b8a2-410d-8711-a3a4dc193fbd	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.60559+00
7872292f-43da-47bf-83c7-40258b67ebd0	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	I've switched to Dangote from foreign brands. No going back.	\N	2026-05-04 11:14:32.60559+00
e54804af-7618-4863-8eb3-fc26e4687c4d	b5d4b921-d02e-4af5-8f37-a8416813ad16	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.614804+00
9d01eb1a-6127-4834-bb8a-90b7f4a64438	b5d4b921-d02e-4af5-8f37-a8416813ad16	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.614804+00
d94507f0-b012-46fd-9c7d-ba14a2499c0a	b5d4b921-d02e-4af5-8f37-a8416813ad16	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.614804+00
9a1dc8a3-44e4-4530-9ca9-74f7f14cfd2e	b5d4b921-d02e-4af5-8f37-a8416813ad16	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.614804+00
ea341a98-90da-457a-a370-31140a2f1653	b5d4b921-d02e-4af5-8f37-a8416813ad16	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.614804+00
8477b3ec-016b-41d7-ab5d-2a416b677df6	b5d4b921-d02e-4af5-8f37-a8416813ad16	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.614804+00
5417ec82-cffd-43ed-b425-80bded1cf120	b5d4b921-d02e-4af5-8f37-a8416813ad16	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.614804+00
aa68ea53-40a4-4f33-abfc-0652595a995e	b5d4b921-d02e-4af5-8f37-a8416813ad16	85d46e14-1258-44db-8c69-be4f7888de87	The ad gave me confidence in the product for my upcoming project in Imo.	\N	2026-05-04 11:14:32.614804+00
ab1d71a4-7924-4c74-a54d-474d4a0c6506	0eec84ee-7ce5-4400-83d2-a0d661751544	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.624488+00
bf3a05e5-d98b-411c-8fb6-dd810139e639	0eec84ee-7ce5-4400-83d2-a0d661751544	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.624488+00
7e07eada-4805-4205-a187-d1c879135ac8	0eec84ee-7ce5-4400-83d2-a0d661751544	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.624488+00
edc65f01-e569-4ec3-b2d4-7809b9a56610	0eec84ee-7ce5-4400-83d2-a0d661751544	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.624488+00
3fbc16f1-332b-4ca6-bf78-f7e58f9836da	0eec84ee-7ce5-4400-83d2-a0d661751544	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.624488+00
ccf99e32-2af4-4819-b1f6-697a21b51929	0eec84ee-7ce5-4400-83d2-a0d661751544	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.624488+00
445cd6fa-7ec5-413d-8b67-f2af1f64261e	0eec84ee-7ce5-4400-83d2-a0d661751544	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.624488+00
2156ce3a-0c61-4cee-be15-c992bd26e6ee	0eec84ee-7ce5-4400-83d2-a0d661751544	85d46e14-1258-44db-8c69-be4f7888de87	The ad gave me confidence in the product for my upcoming project in Imo.	\N	2026-05-04 11:14:32.624488+00
bcde88bf-f7ea-4e84-bd30-9f33714c8142	fb95a422-edfb-4c45-bf2e-e65e8069c999	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.632726+00
9ac891a8-9a9b-413d-a47e-7191290e0b29	fb95a422-edfb-4c45-bf2e-e65e8069c999	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.632726+00
c7798f86-3c80-4738-b0f1-2a2cafaaede9	fb95a422-edfb-4c45-bf2e-e65e8069c999	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.632726+00
fbb60121-74bf-464b-90f6-dfe8bbf1a590	fb95a422-edfb-4c45-bf2e-e65e8069c999	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.632726+00
95aff68b-b80d-4a92-87a9-b31afff24c62	fb95a422-edfb-4c45-bf2e-e65e8069c999	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.632726+00
59d182b8-e205-47d0-8759-e357e6354a8b	fb95a422-edfb-4c45-bf2e-e65e8069c999	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.632726+00
5b0124f4-87bb-4c28-9d70-e4585f825879	fb95a422-edfb-4c45-bf2e-e65e8069c999	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.632726+00
1a8b370c-4666-41ec-ace6-1b5bddb62dc0	fb95a422-edfb-4c45-bf2e-e65e8069c999	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote's reach across Nigeria is impressive. Ad captures the scale well.	\N	2026-05-04 11:14:32.632726+00
6a0a30db-e2d5-4164-a6a9-815ceb1b6e4d	869178d9-d558-48a3-98d7-7774c3e523c1	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.641861+00
897127e3-ac6c-4fdf-828a-3fef999e95de	869178d9-d558-48a3-98d7-7774c3e523c1	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.641861+00
42153a89-0afd-4c7f-a017-3b8040ee64be	869178d9-d558-48a3-98d7-7774c3e523c1	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.641861+00
251abf3f-71c9-4d1a-83c3-cc89fc1d7288	869178d9-d558-48a3-98d7-7774c3e523c1	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.641861+00
a696fd82-b89f-4681-9c6a-d822e85a2ebb	869178d9-d558-48a3-98d7-7774c3e523c1	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.641861+00
f48fc4ff-06a5-4353-8dcb-3abd7466030b	869178d9-d558-48a3-98d7-7774c3e523c1	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.641861+00
9eb6cf05-0633-4afc-97c1-4a1709cf041f	869178d9-d558-48a3-98d7-7774c3e523c1	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.641861+00
d390a5ea-8624-4f4a-b494-aa7a9671fd80	869178d9-d558-48a3-98d7-7774c3e523c1	85d46e14-1258-44db-8c69-be4f7888de87	Simple, effective, trustworthy. That's Dangote and that's this ad.	\N	2026-05-04 11:14:32.641861+00
93516eb9-6c3f-403f-8e10-bc5834a9f2ed	e2c095ee-3f78-4cbf-9606-d7551402dead	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.65091+00
e5218f37-6945-4bb9-8aab-a6d105e52bbd	e2c095ee-3f78-4cbf-9606-d7551402dead	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.65091+00
a2535ed5-95e9-4dde-a1d1-3d72024cee32	e2c095ee-3f78-4cbf-9606-d7551402dead	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.65091+00
379808b9-0a5a-4fab-a210-4761764c10c6	e2c095ee-3f78-4cbf-9606-d7551402dead	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.65091+00
3dd61660-5e78-493d-96b5-76953f6396df	e2c095ee-3f78-4cbf-9606-d7551402dead	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.65091+00
d55a5b09-cc92-43e8-986d-b0cb02b4966a	e2c095ee-3f78-4cbf-9606-d7551402dead	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.65091+00
3af68931-1be3-4e5a-86c4-b196f39f631d	e2c095ee-3f78-4cbf-9606-d7551402dead	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.65091+00
00e7e0ec-d986-456b-8644-5abeb249b335	e2c095ee-3f78-4cbf-9606-d7551402dead	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote's reach across Nigeria is impressive. Ad captures the scale well.	\N	2026-05-04 11:14:32.65091+00
682fa7e2-8978-4e51-9cc9-d4420d7149ea	9ee51098-feb5-49a0-9228-7465769e5fb8	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.66093+00
208198de-c0a6-4b7c-a8bf-92de2cfa8f5e	9ee51098-feb5-49a0-9228-7465769e5fb8	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.66093+00
9011159f-a1e8-4b36-bfa4-d9ecb7f1d6c1	9ee51098-feb5-49a0-9228-7465769e5fb8	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.66093+00
e538c747-43dc-4e0b-ad1d-efa9c633a517	9ee51098-feb5-49a0-9228-7465769e5fb8	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.66093+00
821da537-5a7c-4d24-9878-bb7ec0849101	9ee51098-feb5-49a0-9228-7465769e5fb8	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.66093+00
d7404c4a-0671-40eb-90f1-c178f30128a7	9ee51098-feb5-49a0-9228-7465769e5fb8	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.66093+00
698b21b0-8867-463a-af09-b1ba2201163c	9ee51098-feb5-49a0-9228-7465769e5fb8	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.66093+00
02215193-744a-49ea-9a9b-a439a08e2fab	9ee51098-feb5-49a0-9228-7465769e5fb8	85d46e14-1258-44db-8c69-be4f7888de87	Simple, effective, trustworthy. That's Dangote and that's this ad.	\N	2026-05-04 11:14:32.66093+00
4f88a72d-73bb-4d55-8189-25982eb1b175	f9640389-d66d-4682-8bb5-2ece151c0108	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.67046+00
18bbe534-d7f4-4402-916a-de2f9004dc1f	f9640389-d66d-4682-8bb5-2ece151c0108	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.67046+00
29c9a1de-4ad2-46e1-83e1-be1d988f46f8	f9640389-d66d-4682-8bb5-2ece151c0108	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.67046+00
1a9db1d0-e7bd-4a27-8ae7-a9a7a4c9cf88	f9640389-d66d-4682-8bb5-2ece151c0108	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.67046+00
92b8e749-f129-438f-a7d4-bff399ad38b1	f9640389-d66d-4682-8bb5-2ece151c0108	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.67046+00
8ba646cc-39d8-4962-9b27-d24468598da6	f9640389-d66d-4682-8bb5-2ece151c0108	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.67046+00
29eecd0e-ff44-4377-a3ff-330d7e35e1d6	f9640389-d66d-4682-8bb5-2ece151c0108	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.67046+00
8988a290-3fb6-45a7-a68e-d59ea235f1b1	f9640389-d66d-4682-8bb5-2ece151c0108	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad touched on infrastructure development — very timely for Nigeria.	\N	2026-05-04 11:14:32.67046+00
84a9f9f8-a487-40e8-b2f3-74e7ffc3c116	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.679955+00
75ddb515-0a47-4631-b044-c19bb391d41a	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.679955+00
79236323-f368-4652-9e5b-3624b624ddb0	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.679955+00
b3878a6a-560d-47f6-a276-f6935a18e4c2	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.679955+00
64b51e0c-fc77-4b45-939d-5b53102aa771	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.679955+00
19aa57fd-d28a-4ee6-ab08-64ff1ebe6251	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.679955+00
1ba4b0b4-143e-4c75-bfce-68c5cd700d12	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.679955+00
24c7debd-c454-4f6c-b7e2-11b8e9bbedc9	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad touched on infrastructure development — very timely for Nigeria.	\N	2026-05-04 11:14:32.679955+00
c6a4efdc-648e-4a07-a591-85dcb468939b	8679c977-1114-4478-b6c1-8faef5a75997	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.688526+00
17d1e9cf-2d88-4dbd-9988-6efd5d112bae	8679c977-1114-4478-b6c1-8faef5a75997	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.688526+00
6d80fa31-c706-4d07-855b-3eb8d57e5642	8679c977-1114-4478-b6c1-8faef5a75997	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.688526+00
8bf3d2f2-ed87-4eb1-a9f9-6ab43498776c	8679c977-1114-4478-b6c1-8faef5a75997	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.688526+00
07e58186-9cbb-4cd5-9824-c6211a57cfdf	8679c977-1114-4478-b6c1-8faef5a75997	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.688526+00
836c4bf2-5dc8-4180-b521-684f4cf15d7a	8679c977-1114-4478-b6c1-8faef5a75997	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.688526+00
79b7c168-a5ab-406d-a1e8-73102df1ed76	8679c977-1114-4478-b6c1-8faef5a75997	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.688526+00
79c9166c-d755-42ca-aa7b-5f7e702bcc81	8679c977-1114-4478-b6c1-8faef5a75997	85d46e14-1258-44db-8c69-be4f7888de87	Watched with my husband. We're both convinced to use Dangote for our project.	\N	2026-05-04 11:14:32.688526+00
e2db4073-d763-4264-b18f-b0dd9be45bf7	a5d8f3a9-0325-489b-90d2-195bf59756c0	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.698452+00
8881f350-7c89-48cb-960e-3af280d66d86	a5d8f3a9-0325-489b-90d2-195bf59756c0	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:32.698452+00
75e0a65e-b2bb-40cd-b1ee-8b451072097e	a5d8f3a9-0325-489b-90d2-195bf59756c0	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.698452+00
1f8e5d65-aff7-4649-bf03-e013546014f9	a5d8f3a9-0325-489b-90d2-195bf59756c0	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.698452+00
1500cc88-0f21-49cd-b4b4-6c392a2f8025	a5d8f3a9-0325-489b-90d2-195bf59756c0	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.698452+00
c258cf3b-b950-4f66-a533-168cd6b9bb9d	a5d8f3a9-0325-489b-90d2-195bf59756c0	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.698452+00
cd53d637-7727-4061-84a3-150601f2a4f3	a5d8f3a9-0325-489b-90d2-195bf59756c0	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.698452+00
b920d746-7ec3-4de3-b659-4b90eaee1ec8	a5d8f3a9-0325-489b-90d2-195bf59756c0	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	A little more detail on specifications would be useful but overall great.	\N	2026-05-04 11:14:32.698452+00
acee99f0-276e-48f1-b19f-9d535874c099	dad0e79c-6c81-44f7-8647-4b0351d39ddc	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.707668+00
e808c54b-5c7f-4b5e-9f02-f031e49f7c7f	dad0e79c-6c81-44f7-8647-4b0351d39ddc	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.707668+00
17187b85-ee61-4dc8-89ae-967c7ac4ca83	dad0e79c-6c81-44f7-8647-4b0351d39ddc	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.707668+00
c2df739c-4f1b-4584-b77d-cc16d68be131	dad0e79c-6c81-44f7-8647-4b0351d39ddc	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.707668+00
8230cb98-25d3-4d77-915d-015fac12ebdb	dad0e79c-6c81-44f7-8647-4b0351d39ddc	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.707668+00
8251e92f-7ed6-4f51-930e-1a2145826f50	dad0e79c-6c81-44f7-8647-4b0351d39ddc	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.707668+00
de3fe41c-282c-453e-bf37-d3faf4adafc7	dad0e79c-6c81-44f7-8647-4b0351d39ddc	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.707668+00
63112494-0582-4b87-a255-b150dbf1edfb	dad0e79c-6c81-44f7-8647-4b0351d39ddc	85d46e14-1258-44db-8c69-be4f7888de87	Watched with my husband. We're both convinced to use Dangote for our project.	\N	2026-05-04 11:14:32.707668+00
3a5aa043-a07f-46ea-b295-2665851cb79f	ba01412a-a0ce-427b-938e-c9704654315c	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.716306+00
b38e8b13-67a4-49df-9386-191a8176affe	ba01412a-a0ce-427b-938e-c9704654315c	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.716306+00
9d0250b8-de2f-4015-beb1-36a83f5a7b67	ba01412a-a0ce-427b-938e-c9704654315c	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:32.716306+00
92466ab2-41d9-417d-a06e-eebf22bec490	ba01412a-a0ce-427b-938e-c9704654315c	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.716306+00
e916df96-3e40-4c19-b2c7-6a19edab1d83	ba01412a-a0ce-427b-938e-c9704654315c	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.716306+00
5b92b6ab-5913-4ddd-b8dc-9cee4ab2f07c	ba01412a-a0ce-427b-938e-c9704654315c	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.716306+00
9941d510-1f00-4314-895b-bb02cac7319f	ba01412a-a0ce-427b-938e-c9704654315c	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.716306+00
b08d4275-2551-41a9-8009-9f14cc84ab57	ba01412a-a0ce-427b-938e-c9704654315c	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	A little more detail on specifications would be useful but overall great.	\N	2026-05-04 11:14:32.716306+00
f49e5a19-be72-4355-b3e1-e5f55db5db9f	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.725306+00
6b316e46-e375-4f60-999d-7362d9fc0984	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.725306+00
622df700-13d1-4357-ac41-436fb804b20e	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:32.725306+00
3f34ca5d-3088-454c-a78e-89f0a9e6802e	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.725306+00
bc18186a-13ec-4fc8-8fc3-0fb31d84e2b4	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.725306+00
2e83dc5e-f7cc-4063-8112-6909a50f8d90	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.725306+00
0be1a021-95ff-4793-8458-a7ad4640a989	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.725306+00
b7e8fe4d-043b-49ca-b1e0-de6792d78e79	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	85d46e14-1258-44db-8c69-be4f7888de87	Love the emphasis on Nigerian excellence in the ad creative.	\N	2026-05-04 11:14:32.725306+00
136a02b1-9a17-4a82-9b70-6af215232d71	247cd269-734b-4589-91a5-b112a67d9ad8	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.733547+00
3103f9ad-f41a-450c-8f0f-3387906ceab6	247cd269-734b-4589-91a5-b112a67d9ad8	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.733547+00
400cebae-0823-40f2-a144-47c0a5921b3e	247cd269-734b-4589-91a5-b112a67d9ad8	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.733547+00
f21e4eff-9924-41cd-8186-82c4c5d8dd38	247cd269-734b-4589-91a5-b112a67d9ad8	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.733547+00
082d69f6-5f4c-41d3-a901-37b20de57835	247cd269-734b-4589-91a5-b112a67d9ad8	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.733547+00
44332c35-365c-4870-a8e0-a049c975807b	247cd269-734b-4589-91a5-b112a67d9ad8	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.733547+00
ace29fad-2301-4129-a70e-024a5e6310f5	247cd269-734b-4589-91a5-b112a67d9ad8	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.733547+00
c82e10f9-fcb9-4fdd-83a8-c992e7c38e7a	247cd269-734b-4589-91a5-b112a67d9ad8	85d46e14-1258-44db-8c69-be4f7888de87	Love the emphasis on Nigerian excellence in the ad creative.	\N	2026-05-04 11:14:32.733547+00
5e32084e-4a01-4020-a1df-050832916dfc	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.743272+00
43e0ea58-4f8b-4784-ac3b-2b2d510d2934	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.743272+00
54725bd6-f93b-4173-b7c7-4e0244bde67e	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.743272+00
3dadc992-6074-4bb2-acae-23591ef98617	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.743272+00
e4b18993-ce59-4623-b334-13617cc35e97	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.743272+00
9003366e-fd45-4629-bda3-bbf993bc0a47	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.743272+00
11dc33b8-2cc8-49f6-be6d-541c14cd178c	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.743272+00
063a1327-0284-4c1d-a897-c433e35cab0c	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Strong visuals, strong message. Aligns with Dangote's market positioning.	\N	2026-05-04 11:14:32.743272+00
bcc76cdb-d0f5-42ad-9012-a6bb0955ce00	8bf00840-696c-4021-bdc3-90cf0d30980c	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.751885+00
47d5142c-c1d5-4c25-a587-d93ccf5d116f	8bf00840-696c-4021-bdc3-90cf0d30980c	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.751885+00
7b370c5f-48af-4537-b431-7151b585497e	8bf00840-696c-4021-bdc3-90cf0d30980c	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:32.751885+00
9ce55c7f-7660-4988-aae9-5b7508f726f5	8bf00840-696c-4021-bdc3-90cf0d30980c	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:32.751885+00
4c8a67a4-98a2-4f12-92b3-f702453937f1	8bf00840-696c-4021-bdc3-90cf0d30980c	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.751885+00
27615786-d14d-4966-9a26-8ab4304a0d3e	8bf00840-696c-4021-bdc3-90cf0d30980c	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.751885+00
89c5d2ac-9dfa-4c8b-818c-e40eb6195917	8bf00840-696c-4021-bdc3-90cf0d30980c	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.751885+00
464cc349-6de8-425a-8f13-b4697edfcc81	8bf00840-696c-4021-bdc3-90cf0d30980c	85d46e14-1258-44db-8c69-be4f7888de87	Dangote is feeding Nigeria and building Nigeria. This ad shows both.	\N	2026-05-04 11:14:32.751885+00
f561e1fe-e13c-4666-85ec-feb303c034d2	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.760753+00
9d4cd4b9-b932-4d89-9ed2-f036ef8277d7	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.760753+00
28f75394-c511-4ec0-ac89-4bfd2ea4db12	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.760753+00
aeb2b28a-d573-41d8-a84f-40ea0cae4677	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:32.760753+00
82c58898-f303-470a-9b09-76b35a10e352	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.760753+00
46ba29c1-cc52-4060-af0d-d6f08aea4938	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.760753+00
23b2444c-6fd0-4bd0-8af1-390f622676f1	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.760753+00
d5bb214b-e3de-421c-bd84-39799622b78d	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Strong visuals, strong message. Aligns with Dangote's market positioning.	\N	2026-05-04 11:14:32.760753+00
7331264d-43a0-44fd-9546-a96a52e41143	35d629b6-d438-436f-a956-3a3320bbe26c	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.769648+00
89f68b72-a891-4320-b823-3dab8e9f713a	35d629b6-d438-436f-a956-3a3320bbe26c	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.769648+00
d9e355f9-c67d-416b-87a6-153b31dfd64a	35d629b6-d438-436f-a956-3a3320bbe26c	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.769648+00
b082b593-d175-4e54-8d82-afd5292e5715	35d629b6-d438-436f-a956-3a3320bbe26c	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.769648+00
2736cc06-713a-4eda-bbb6-dc1f138fc777	35d629b6-d438-436f-a956-3a3320bbe26c	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.769648+00
4d498dd3-cdfe-4715-947d-f98d61a8a999	35d629b6-d438-436f-a956-3a3320bbe26c	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.769648+00
a110758c-3488-4daf-988d-5ad48143fbf2	35d629b6-d438-436f-a956-3a3320bbe26c	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.769648+00
9b447b23-0020-42fe-9a33-750ef7db388c	35d629b6-d438-436f-a956-3a3320bbe26c	85d46e14-1258-44db-8c69-be4f7888de87	Dangote is feeding Nigeria and building Nigeria. This ad shows both.	\N	2026-05-04 11:14:32.769648+00
09560b68-8b24-453f-be4c-33a8824b7db7	a168986a-8bb6-449e-97df-2b50e115b53a	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.778617+00
6fdf2bd4-96bd-4241-a443-536fbfcbea6d	a168986a-8bb6-449e-97df-2b50e115b53a	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.778617+00
33d0e323-8845-4621-be50-68e1213ed324	a168986a-8bb6-449e-97df-2b50e115b53a	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:32.778617+00
d949ad0b-35b5-4e78-8786-708002f8b673	a168986a-8bb6-449e-97df-2b50e115b53a	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.778617+00
45494628-c53f-4b24-a8e3-74932f78b61b	a168986a-8bb6-449e-97df-2b50e115b53a	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.778617+00
f71569ab-4d8c-4960-b383-c327699ff0fd	a168986a-8bb6-449e-97df-2b50e115b53a	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.778617+00
eb2bc866-c338-4cdc-8457-2f3f83822f31	a168986a-8bb6-449e-97df-2b50e115b53a	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:32.778617+00
e5abf4c2-939d-486c-98da-b65f31b02693	a168986a-8bb6-449e-97df-2b50e115b53a	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad's focus on reliability matches my personal experience with the product.	\N	2026-05-04 11:14:32.778617+00
fb1f7fe9-1341-4b5f-8548-538ae98d0a2c	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.789295+00
c99c9561-d4ec-4dc7-b544-7e88777c3b6c	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.789295+00
07bcc25d-cf12-404c-9e86-a601225015d9	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:32.789295+00
25f3e69b-c9a0-4659-b6a5-5e14e0c23244	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.789295+00
2f12d3f0-3b8c-4da8-8541-560ad07a7652	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.789295+00
d27bab72-ca31-4431-8607-348b273cf2d0	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.789295+00
31420d7d-9a58-4bf5-94f8-f910b428b91a	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.789295+00
22bbe3a6-24ba-4729-b178-4a1f87263fec	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad's focus on reliability matches my personal experience with the product.	\N	2026-05-04 11:14:32.789295+00
756fabae-bf14-4104-9f52-7f7f08887449	baff260d-e0e8-47bb-85da-68da285ffcc5	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.79856+00
785d438a-faa0-4fb0-a839-9b63a3112f65	baff260d-e0e8-47bb-85da-68da285ffcc5	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.79856+00
776356c2-2885-4f2e-9a34-3a4897345fe8	baff260d-e0e8-47bb-85da-68da285ffcc5	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.79856+00
8b263295-1b02-408f-b944-fc5cec450326	baff260d-e0e8-47bb-85da-68da285ffcc5	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.79856+00
bb1dcd04-79ac-4339-a17d-efc0fc084ce6	baff260d-e0e8-47bb-85da-68da285ffcc5	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.79856+00
8824a8f9-8091-473e-a443-7a5e5c5f6e54	baff260d-e0e8-47bb-85da-68da285ffcc5	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.79856+00
90f2a428-2da9-4abd-ab02-a9a775a9d79b	baff260d-e0e8-47bb-85da-68da285ffcc5	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.79856+00
821b6a05-b616-4197-b032-26f6a2bb0b7c	baff260d-e0e8-47bb-85da-68da285ffcc5	85d46e14-1258-44db-8c69-be4f7888de87	Made me think about switching from my current supplier to Dangote.	\N	2026-05-04 11:14:32.79856+00
38b5afa8-e0e1-4ef6-9e0f-3bc06159ff29	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.806531+00
c55863ac-137f-4972-8690-af1c41ace711	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.806531+00
0a5abc79-00ff-4cd7-851a-d90a10a1f062	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.806531+00
928d4657-3aaa-4fc8-86cd-f3270ae229d5	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.806531+00
26b6d92b-e46d-4dad-9a05-b16e66538c76	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.806531+00
6dd7566c-daa4-4fc9-ba78-cb5e108c7dd4	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:32.806531+00
16afa408-cbb6-4dfa-aa29-f62393e6a253	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.806531+00
f2615cf9-6d2f-4bf0-ab6b-e3c04baa29fc	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Great job on the ad! Dangote is truly transforming Nigeria.	\N	2026-05-04 11:14:32.806531+00
f738f03b-d950-4c5c-bbb9-b94d82416763	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.816856+00
1ba67b27-e809-4514-a843-1d032d967d1d	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.816856+00
7885d09a-a643-44cc-8cac-a913e3e38f6d	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.816856+00
95645c93-5377-4866-b6bb-5f192278c426	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.816856+00
21db65b2-7cd4-460e-9416-2df1ce1ef835	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.816856+00
12f24ff7-664f-40ac-a402-4dd4d59c812b	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.816856+00
1cba426b-841c-4ca2-ad7e-d696ffe89657	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.816856+00
bab80c7c-afca-4aed-a6b2-7691f0a56f1a	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	85d46e14-1258-44db-8c69-be4f7888de87	Made me think about switching from my current supplier to Dangote.	\N	2026-05-04 11:14:32.816856+00
e6409646-5201-4a02-8507-22e57912a33a	ec163ffe-d8df-4b63-9219-ddb6f4b49222	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.826587+00
f23b5c37-9df4-428b-9fb4-fab4dbfe2347	ec163ffe-d8df-4b63-9219-ddb6f4b49222	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.826587+00
d5f70b92-e762-4e4f-a377-82451f48f220	ec163ffe-d8df-4b63-9219-ddb6f4b49222	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.826587+00
2fa11a5f-4fdd-4611-b487-6da7543b2e78	ec163ffe-d8df-4b63-9219-ddb6f4b49222	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.826587+00
3e1ab32c-f7f0-45f5-aca0-b14c63664f6a	ec163ffe-d8df-4b63-9219-ddb6f4b49222	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:32.826587+00
6fa38fcd-f625-452d-b796-39a6a5538b1b	ec163ffe-d8df-4b63-9219-ddb6f4b49222	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.826587+00
c8b4f819-c7ef-4392-aa70-e40629829a96	ec163ffe-d8df-4b63-9219-ddb6f4b49222	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:32.826587+00
017c218a-3c31-4417-af81-390877751eb1	ec163ffe-d8df-4b63-9219-ddb6f4b49222	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Great job on the ad! Dangote is truly transforming Nigeria.	\N	2026-05-04 11:14:32.826587+00
d2902b32-0ae5-48da-8e32-c3fe1796786e	fc67de83-23d9-46d4-80ee-277c7ef2747e	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.836189+00
5c15ff7c-eb34-4f73-a4c4-7b0bc9fd5873	fc67de83-23d9-46d4-80ee-277c7ef2747e	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.836189+00
97482cb5-f432-439e-b122-0d2bcada74a9	fc67de83-23d9-46d4-80ee-277c7ef2747e	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:32.836189+00
61035327-f5f0-4cdc-b6e8-d35c5482b96c	fc67de83-23d9-46d4-80ee-277c7ef2747e	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.836189+00
93056395-cbeb-4394-ba28-865f578c1d7e	fc67de83-23d9-46d4-80ee-277c7ef2747e	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.836189+00
a1940714-988d-4948-844d-a0c92228512c	fc67de83-23d9-46d4-80ee-277c7ef2747e	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:32.836189+00
1ae12446-763c-477d-b615-78f61f854b9b	fc67de83-23d9-46d4-80ee-277c7ef2747e	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.836189+00
b3bb3608-7de8-4bcd-8705-ad5500679d53	fc67de83-23d9-46d4-80ee-277c7ef2747e	85d46e14-1258-44db-8c69-be4f7888de87	Cement quality has always been top-notch. Glad they're advertising more.	\N	2026-05-04 11:14:32.836189+00
33478c56-6871-4814-8e81-7731c53f8f8a	cfc482ed-c2d3-46d1-8791-128c5f34df76	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.845316+00
cb2a42bc-af36-4226-aa7d-eef64a43e6fc	cfc482ed-c2d3-46d1-8791-128c5f34df76	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.845316+00
1e01d290-2cbb-456b-a241-f131526bfbc8	cfc482ed-c2d3-46d1-8791-128c5f34df76	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.845316+00
6b72fd3c-7f63-4cf5-9b3e-20231ac71c5e	cfc482ed-c2d3-46d1-8791-128c5f34df76	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.845316+00
c479aed9-b3b7-40c4-ae3b-faffc44e7e09	cfc482ed-c2d3-46d1-8791-128c5f34df76	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.845316+00
15c22508-a30b-4b4f-8248-4b6221511dd6	cfc482ed-c2d3-46d1-8791-128c5f34df76	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.845316+00
3144cc15-28ef-4c12-b76f-4dd93d5c9b35	cfc482ed-c2d3-46d1-8791-128c5f34df76	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.845316+00
ef0510df-d2e5-4ddc-a7d7-7ef0260023ca	cfc482ed-c2d3-46d1-8791-128c5f34df76	85d46e14-1258-44db-8c69-be4f7888de87	Cement quality has always been top-notch. Glad they're advertising more.	\N	2026-05-04 11:14:32.845316+00
4e349112-b2df-4c2f-af9f-b0954a77bb17	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.854526+00
c80d3c54-4409-40f6-8f81-c22dc6211016	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.854526+00
e99b5c85-27c4-4bdc-8e4a-d0d73d0af0d7	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:32.854526+00
86dea553-2cdf-4d99-a925-12d45899d623	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.854526+00
2a991253-e087-4814-af6a-fb75dc0bb66e	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.854526+00
f4dcf207-82a5-46e8-b531-7a2da484b0a8	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:32.854526+00
722b275d-1adf-4e43-ab2d-9101c06b7606	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.854526+00
3c00624e-01a4-4e2e-8f8d-b728b7eaab32	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad was professional and I liked the Nigerian talent featured in it.	\N	2026-05-04 11:14:32.854526+00
9cf30f05-ab7e-4c8e-a605-7bf5900c960a	598ecc55-d9aa-4326-afc8-623beef05841	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.865192+00
06bd9805-c983-4a32-b4bb-79b599c31724	598ecc55-d9aa-4326-afc8-623beef05841	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:32.865192+00
880947b5-8b03-4aa4-a028-d53fc8adb582	598ecc55-d9aa-4326-afc8-623beef05841	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.865192+00
5b2bc850-2509-4e2e-b467-c6cc0335bc4c	598ecc55-d9aa-4326-afc8-623beef05841	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.865192+00
6754baa5-8934-4bc4-8ed0-3ace36598860	598ecc55-d9aa-4326-afc8-623beef05841	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.865192+00
efaa4f84-674e-4dd0-8bb5-2ee28cd17609	598ecc55-d9aa-4326-afc8-623beef05841	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:32.865192+00
2de3f051-c6d1-4de2-94f2-8abfdef83b2c	598ecc55-d9aa-4326-afc8-623beef05841	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.865192+00
a7d78625-6b76-441e-ae83-e22017cbd33e	598ecc55-d9aa-4326-afc8-623beef05841	85d46e14-1258-44db-8c69-be4f7888de87	As a real estate developer, Dangote cement is my go-to. Love this ad.	\N	2026-05-04 11:14:32.865192+00
8a9d0a97-433f-4780-8454-a0d229e9881d	0f59293b-5e72-4ae5-8af1-34558e08341d	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.878934+00
f2646d08-e3ee-44a0-a971-85ad2863d705	0f59293b-5e72-4ae5-8af1-34558e08341d	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.878934+00
b0df69cf-568f-4a25-b086-fcc7680e823e	0f59293b-5e72-4ae5-8af1-34558e08341d	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.878934+00
393a97c0-c4f0-4aff-a397-b9e5870a9f0e	0f59293b-5e72-4ae5-8af1-34558e08341d	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.878934+00
e408320c-7ca0-4397-9954-216265311fbd	0f59293b-5e72-4ae5-8af1-34558e08341d	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.878934+00
a8164d32-6d16-4736-8f1e-d871c6b157f0	0f59293b-5e72-4ae5-8af1-34558e08341d	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.878934+00
fd5576b2-95ff-4e98-a91c-fb2b90534d44	0f59293b-5e72-4ae5-8af1-34558e08341d	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.878934+00
7c3f0cb7-f9b8-4408-bf99-5e743df344d4	0f59293b-5e72-4ae5-8af1-34558e08341d	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad was professional and I liked the Nigerian talent featured in it.	\N	2026-05-04 11:14:32.878934+00
1c040d36-e3cf-4d22-a19d-1ef6c9a48a6c	f2906241-4a32-46c4-8612-66fd1653c851	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.888633+00
01be4a64-4a37-4ae1-92f1-717ee36de41b	f2906241-4a32-46c4-8612-66fd1653c851	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.888633+00
3deb1da4-6386-418f-9ecf-9165dbba2627	f2906241-4a32-46c4-8612-66fd1653c851	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.888633+00
b91ac502-daca-422f-aa5a-24685ff0b549	f2906241-4a32-46c4-8612-66fd1653c851	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.888633+00
3b99c480-a40b-433e-9ab7-0e379b6e2ce4	f2906241-4a32-46c4-8612-66fd1653c851	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:32.888633+00
52048793-c8ff-4862-ab3b-5291dcc93abe	f2906241-4a32-46c4-8612-66fd1653c851	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.888633+00
e2908706-66ca-4cee-b621-58930daac62e	f2906241-4a32-46c4-8612-66fd1653c851	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:32.888633+00
0cf9f7f9-e85e-4918-94a6-3df3477c497d	f2906241-4a32-46c4-8612-66fd1653c851	85d46e14-1258-44db-8c69-be4f7888de87	As a real estate developer, Dangote cement is my go-to. Love this ad.	\N	2026-05-04 11:14:32.888633+00
c89fe6c7-2386-43fe-a43b-7dc133eae4cd	f2be7f80-5f81-472d-b8ce-05a7c9726b85	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.897596+00
4e300008-c95e-4269-91cb-e25dfb1bf80d	f2be7f80-5f81-472d-b8ce-05a7c9726b85	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.897596+00
ac21839f-8266-418f-a613-ebe11d8f9123	f2be7f80-5f81-472d-b8ce-05a7c9726b85	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:32.897596+00
66514def-a62c-40ef-bd70-54b8ac92ff84	f2be7f80-5f81-472d-b8ce-05a7c9726b85	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.897596+00
ce65329a-3490-4cea-9362-3a9a55b5ea74	f2be7f80-5f81-472d-b8ce-05a7c9726b85	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:32.897596+00
24e4714e-a634-4ead-96fc-ab3910f4af57	f2be7f80-5f81-472d-b8ce-05a7c9726b85	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.897596+00
a294ef96-2a3f-4c56-bc66-6c0f6cca6d5f	f2be7f80-5f81-472d-b8ce-05a7c9726b85	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.897596+00
9837cb3a-1f06-4721-8c85-b49775603e55	f2be7f80-5f81-472d-b8ce-05a7c9726b85	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad was persuasive without being pushy. Perfect for the brand.	\N	2026-05-04 11:14:32.897596+00
af4843f0-79fd-4cf5-afb3-6b40c925ff86	92c4832b-7c95-495d-ae94-f92b75728a43	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.905675+00
1ffd2abc-0eac-4f8d-ad72-f0320b57b8c5	92c4832b-7c95-495d-ae94-f92b75728a43	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.905675+00
9dc980d8-e801-4d5d-a5e3-7853cc843eb0	92c4832b-7c95-495d-ae94-f92b75728a43	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:32.905675+00
87f23871-efe8-4f2d-89f6-383910575eb0	92c4832b-7c95-495d-ae94-f92b75728a43	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.905675+00
15a6e029-922b-420a-9e0a-e6f22d306f7c	92c4832b-7c95-495d-ae94-f92b75728a43	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.905675+00
94039bb9-dbd0-4b96-a725-3a72e215b116	92c4832b-7c95-495d-ae94-f92b75728a43	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.905675+00
b25a699b-5050-4fb8-bc08-44d90eed8e03	92c4832b-7c95-495d-ae94-f92b75728a43	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.905675+00
17477efc-ce0e-4ab0-b38e-826478c05f11	92c4832b-7c95-495d-ae94-f92b75728a43	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad was persuasive without being pushy. Perfect for the brand.	\N	2026-05-04 11:14:32.905675+00
d1e3b0f3-1c08-4480-8599-c34766e766a3	46c6188e-d270-48eb-b60c-9d3fb0391258	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:32.914846+00
05f433c3-beb4-4bf9-8a6a-68cf49215683	46c6188e-d270-48eb-b60c-9d3fb0391258	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:32.914846+00
7cf1c424-eb3e-454e-b952-2c7d58db2f08	46c6188e-d270-48eb-b60c-9d3fb0391258	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:32.914846+00
48e4647e-333c-4924-934b-a285fb9af8b8	46c6188e-d270-48eb-b60c-9d3fb0391258	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.914846+00
2b04cbd5-c644-4dc2-8924-8ee0b4f86f78	46c6188e-d270-48eb-b60c-9d3fb0391258	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:32.914846+00
6ae609fb-7c54-4dfb-9b5b-b84443fa81f9	46c6188e-d270-48eb-b60c-9d3fb0391258	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:32.914846+00
c438db6f-c75a-4466-af4c-3b6e2255bee3	46c6188e-d270-48eb-b60c-9d3fb0391258	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:32.914846+00
aa5e0aeb-67b9-462f-8e09-cfcecf9f9935	46c6188e-d270-48eb-b60c-9d3fb0391258	85d46e14-1258-44db-8c69-be4f7888de87	Reminds me why I've been loyal to Dangote for so many years.	\N	2026-05-04 11:14:32.914846+00
645a6767-deb6-427e-a6a7-bc3e70d6a001	ae6e1545-240a-4613-be86-54051780e6cb	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:32.925231+00
e68592ce-8fff-46eb-91a2-3c9197a4718c	ae6e1545-240a-4613-be86-54051780e6cb	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:32.925231+00
ea8db17f-9374-4ad1-8bac-b9a4a74650fe	ae6e1545-240a-4613-be86-54051780e6cb	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:32.925231+00
cfe709f4-63ac-40ab-8d2f-63db2e0015bd	ae6e1545-240a-4613-be86-54051780e6cb	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.925231+00
7ce7ddf2-b9c3-4b63-ad99-a9f7ac6e3cf9	ae6e1545-240a-4613-be86-54051780e6cb	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.925231+00
31b558a8-eba2-4100-b144-094733095a2f	ae6e1545-240a-4613-be86-54051780e6cb	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:32.925231+00
07677d88-9d01-4667-936e-d801d043d6f6	ae6e1545-240a-4613-be86-54051780e6cb	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:32.925231+00
a3750489-b5f5-4299-8208-12aeb938c515	ae6e1545-240a-4613-be86-54051780e6cb	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Excellent campaign. Shows Dangote understands their Nigerian customers.	\N	2026-05-04 11:14:32.925231+00
fa85f0fe-72bd-4b08-b999-47473b07d695	5dcae94e-5a83-4b96-9b3b-55af29de54ed	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.938496+00
bcaaa0b1-1bdc-4c5a-b8a9-37d8a02d706a	5dcae94e-5a83-4b96-9b3b-55af29de54ed	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:32.938496+00
352e0c03-ff3d-4a5e-be27-b077e5d1d05b	5dcae94e-5a83-4b96-9b3b-55af29de54ed	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:32.938496+00
211feaa9-0536-4862-8583-c3d0913fb94f	5dcae94e-5a83-4b96-9b3b-55af29de54ed	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.938496+00
a9caeffd-764a-4375-a2ca-7225d3bbc43a	5dcae94e-5a83-4b96-9b3b-55af29de54ed	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.938496+00
4eb0afe6-ac59-4f21-a71f-3b89c7cac672	5dcae94e-5a83-4b96-9b3b-55af29de54ed	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.938496+00
f8a88226-a37c-4b9e-bfdd-db1b2c570ab2	5dcae94e-5a83-4b96-9b3b-55af29de54ed	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.938496+00
ed71a5fe-1c42-4261-a993-e0a4cdc32dff	5dcae94e-5a83-4b96-9b3b-55af29de54ed	85d46e14-1258-44db-8c69-be4f7888de87	Reminds me why I've been loyal to Dangote for so many years.	\N	2026-05-04 11:14:32.938496+00
d61627da-80a9-43e6-b4de-2dbf5ffe1cd4	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:32.947554+00
9e05f7a9-473a-4c49-b278-0edb6f250efa	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:32.947554+00
08332223-7392-49a8-8ecd-cb1fa3a97d4c	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:32.947554+00
fc9be730-4067-4c7d-bf45-554cb40249dc	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.947554+00
e942f994-4105-4dd6-93d8-5927784e1bbb	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.947554+00
19feee39-a7bf-40b8-9371-48714bdcb56d	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:32.947554+00
859ac09e-f9bd-42a6-9acd-c7340728051c	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.947554+00
cbff8f3f-6339-4c9b-be11-cdb70412f1f2	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Excellent campaign. Shows Dangote understands their Nigerian customers.	\N	2026-05-04 11:14:32.947554+00
fae54b57-a468-464f-b43a-783ba912d546	e271bc4e-f681-4fbd-b335-aa7cfd14114b	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.956298+00
b1a7c5db-a3d9-4cd1-8044-a865f6e6ae56	e271bc4e-f681-4fbd-b335-aa7cfd14114b	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.956298+00
5455e65a-1b06-4d24-a6f1-ba708f5eef30	e271bc4e-f681-4fbd-b335-aa7cfd14114b	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:32.956298+00
ddd6b93d-c7ab-42d1-8675-12726b2dc048	e271bc4e-f681-4fbd-b335-aa7cfd14114b	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:32.956298+00
b02914da-2331-4078-b0dd-ab724724127a	e271bc4e-f681-4fbd-b335-aa7cfd14114b	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.956298+00
75ce4f85-7a8d-4dff-a87f-7fc932feb433	e271bc4e-f681-4fbd-b335-aa7cfd14114b	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:32.956298+00
1d4e4a61-9f3a-43b4-a342-831a51d683cc	e271bc4e-f681-4fbd-b335-aa7cfd14114b	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.956298+00
0e20e59f-88e1-454a-8b87-2ce941da31a6	e271bc4e-f681-4fbd-b335-aa7cfd14114b	85d46e14-1258-44db-8c69-be4f7888de87	The ad was engaging for my demographic — working class Nigerian.	\N	2026-05-04 11:14:32.956298+00
d5227219-2575-4231-aa57-12fdcdf1c87d	52aeec76-af5e-460e-81c9-e86700a009c5	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.964361+00
925fc914-8a7d-4c70-97c4-b04b135cb7f4	52aeec76-af5e-460e-81c9-e86700a009c5	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.964361+00
12574cd4-4c86-4a9c-baa7-0a96b2730186	52aeec76-af5e-460e-81c9-e86700a009c5	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:32.964361+00
57aa2537-b64c-4dac-99e0-3221fee0061b	52aeec76-af5e-460e-81c9-e86700a009c5	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.964361+00
f231bcd1-c3eb-48d9-99eb-b51779ce1d30	52aeec76-af5e-460e-81c9-e86700a009c5	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:32.964361+00
afb1022b-c15d-4205-b0cf-6b50e428416c	52aeec76-af5e-460e-81c9-e86700a009c5	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:32.964361+00
e187279f-060d-48ea-b1f4-d96e00a2df8d	52aeec76-af5e-460e-81c9-e86700a009c5	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:32.964361+00
d048a2d5-9532-4143-8e92-1c02e736e782	52aeec76-af5e-460e-81c9-e86700a009c5	85d46e14-1258-44db-8c69-be4f7888de87	The ad was engaging for my demographic — working class Nigerian.	\N	2026-05-04 11:14:32.964361+00
cd970a6d-6e8e-497a-a7a3-257e2fb9dc0f	703fb958-cb27-4df9-96a1-7d5979921d55	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:32.973505+00
4f1f59e2-3928-4609-a92b-3b51755f09a2	703fb958-cb27-4df9-96a1-7d5979921d55	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:32.973505+00
88aa7ff4-d7ad-42a4-bce9-edb33f6ceded	703fb958-cb27-4df9-96a1-7d5979921d55	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:32.973505+00
c5002a21-5a1a-47bd-9166-96ae39f73548	703fb958-cb27-4df9-96a1-7d5979921d55	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:32.973505+00
d5f9c5c1-2682-47a0-8c15-72cc82781180	703fb958-cb27-4df9-96a1-7d5979921d55	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:32.973505+00
5248b6ce-d4c4-4c9d-b20f-bc751dc1a844	703fb958-cb27-4df9-96a1-7d5979921d55	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.973505+00
71c0a718-ff10-483b-97bc-5293ed9592ca	703fb958-cb27-4df9-96a1-7d5979921d55	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.973505+00
f0c99c08-e3b6-49ed-9c77-0913a3688c9c	703fb958-cb27-4df9-96a1-7d5979921d55	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Would love to see Dangote advertise their sugar and flour products too.	\N	2026-05-04 11:14:32.973505+00
0a260083-4f70-41cd-bc51-ba4211f227dc	173844bb-b248-4d89-86ad-37562e2f1590	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:32.9842+00
a8db9b81-75e0-4548-8bb3-698fe92d3322	173844bb-b248-4d89-86ad-37562e2f1590	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:32.9842+00
90efaef5-3fe7-4bd9-b7e2-da30e6febc9e	173844bb-b248-4d89-86ad-37562e2f1590	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:32.9842+00
f56f6187-d225-4cf9-b28b-504fe48871a3	173844bb-b248-4d89-86ad-37562e2f1590	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:32.9842+00
c2a35db3-4023-43a3-9c4b-885abbb94639	173844bb-b248-4d89-86ad-37562e2f1590	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:32.9842+00
da2db8c6-cbc9-413a-a606-534c198b6d3d	173844bb-b248-4d89-86ad-37562e2f1590	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:32.9842+00
dd0db168-466b-4e7d-bfae-9e662f093be6	173844bb-b248-4d89-86ad-37562e2f1590	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:32.9842+00
34c0af37-9c13-4d13-b610-cc29e183959d	173844bb-b248-4d89-86ad-37562e2f1590	85d46e14-1258-44db-8c69-be4f7888de87	The imagery of strong Nigerian homes built with Dangote was powerful.	\N	2026-05-04 11:14:32.9842+00
76bee318-4407-4b54-a659-b21b35536f2e	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:32.993697+00
44520eaa-4743-45e8-afcc-aece0b9a1fa0	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:32.993697+00
244f8736-0cba-47e9-9f48-4e1c96a1efdc	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:32.993697+00
3496b55a-d4a6-4fcc-bef2-c927993eae06	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:32.993697+00
a2573bd9-e5c9-4bc4-8831-a2633600ecbb	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:32.993697+00
15572b1a-88aa-4e63-a556-fefe11ec1856	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:32.993697+00
d90dddd4-e34a-4cf6-8278-b9cba9879861	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:32.993697+00
44093f3c-692b-4825-9810-8545b087a0b1	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Would love to see Dangote advertise their sugar and flour products too.	\N	2026-05-04 11:14:32.993697+00
433ad683-b709-42c4-83ed-c760645dca65	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.003136+00
4ed448d5-d89f-45b6-bb86-fe4994addbca	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.003136+00
fdac2c1e-5ae6-460b-915f-00e36e71be5f	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.003136+00
63141654-5d4e-43da-8b27-19510db9ab88	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.003136+00
85ee6513-af20-48cd-a306-3bf1a9c74a38	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.003136+00
8a833040-c743-468b-8922-f14d155d3702	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.003136+00
e9296086-bd25-475b-83d9-c54924c7de73	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.003136+00
cce55fed-c343-41a1-9f08-9954530c24cf	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	85d46e14-1258-44db-8c69-be4f7888de87	The imagery of strong Nigerian homes built with Dangote was powerful.	\N	2026-05-04 11:14:33.003136+00
7d0ef401-1fdf-4abb-88e7-34a4d2a7523d	4532fc0a-4929-453c-9b7c-53b0267fdefb	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.012945+00
7f4b6708-fe29-43a6-8cbd-8e1776c1f525	4532fc0a-4929-453c-9b7c-53b0267fdefb	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.012945+00
bff331d4-e0af-4488-95ce-17f03ca10d6c	4532fc0a-4929-453c-9b7c-53b0267fdefb	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:33.012945+00
21dc9ec1-4bce-4203-9d84-7054ae999a04	4532fc0a-4929-453c-9b7c-53b0267fdefb	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.012945+00
9f15462c-9318-4f66-9da6-75ae0962161b	4532fc0a-4929-453c-9b7c-53b0267fdefb	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.012945+00
fb5f8aa4-4f47-452f-9381-6a1fc31a505d	4532fc0a-4929-453c-9b7c-53b0267fdefb	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.012945+00
da021b46-5c6b-4be5-ab97-4c556b9e2233	4532fc0a-4929-453c-9b7c-53b0267fdefb	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.012945+00
2a77da94-1a60-4224-bef5-6eea53cf67ac	4532fc0a-4929-453c-9b7c-53b0267fdefb	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad felt genuine and not like typical corporate advertising. Refreshing.	\N	2026-05-04 11:14:33.012945+00
d9b6474e-067c-4073-85ff-49abfab74da6	35188bca-4987-4cb6-a29e-1c5e2a325710	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.021471+00
7d68ea1f-7760-4fac-a5db-100f138d1753	35188bca-4987-4cb6-a29e-1c5e2a325710	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.021471+00
f2dbe665-f973-4073-a7d6-2fbd57d123f2	35188bca-4987-4cb6-a29e-1c5e2a325710	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:33.021471+00
f32b9cdb-cae1-42a3-99fc-5ecc422590de	35188bca-4987-4cb6-a29e-1c5e2a325710	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:33.021471+00
2b8ae980-a9c6-4c3a-ba54-cc8a31d21426	35188bca-4987-4cb6-a29e-1c5e2a325710	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.021471+00
a2a01557-b474-48b8-82a5-78b8967e0166	35188bca-4987-4cb6-a29e-1c5e2a325710	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.021471+00
8bae4579-0cbe-4bb8-b912-6dc10ffdcef8	35188bca-4987-4cb6-a29e-1c5e2a325710	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.021471+00
c4b63d77-b591-4f8c-8bd6-73de3ee9cd98	35188bca-4987-4cb6-a29e-1c5e2a325710	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad felt genuine and not like typical corporate advertising. Refreshing.	\N	2026-05-04 11:14:33.021471+00
df05110a-750a-4e72-a6db-d9159a894f7e	9074a1f7-6ffa-4bac-9e15-693f6219ae01	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.031608+00
4dd78a15-d0a5-4543-95b3-56983f4fef7e	9074a1f7-6ffa-4bac-9e15-693f6219ae01	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.031608+00
5663d96d-9a37-4885-ae7d-394d880be130	9074a1f7-6ffa-4bac-9e15-693f6219ae01	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:33.031608+00
2f9a44fb-8695-4ee9-917e-5d90d41613d1	9074a1f7-6ffa-4bac-9e15-693f6219ae01	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:33.031608+00
d6865073-d96c-4607-bc94-c3ead5695187	9074a1f7-6ffa-4bac-9e15-693f6219ae01	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.031608+00
c14a4b85-8594-46d5-b3e6-7910e492732e	9074a1f7-6ffa-4bac-9e15-693f6219ae01	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.031608+00
8d08caae-8453-478f-a1ac-b1642c68a318	9074a1f7-6ffa-4bac-9e15-693f6219ae01	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.031608+00
19afd449-0cfc-4602-b835-1654905027f9	9074a1f7-6ffa-4bac-9e15-693f6219ae01	85d46e14-1258-44db-8c69-be4f7888de87	I'm in construction. This ad speaks directly to me. Very relevant.	\N	2026-05-04 11:14:33.031608+00
f20387ef-0c36-40e9-9cce-a8404071cdb4	410a6c83-b8fd-4948-b839-77ecb801b209	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.040542+00
3604e80e-bcb8-47fc-9a36-615de0204655	410a6c83-b8fd-4948-b839-77ecb801b209	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.040542+00
05de722b-a13b-4f7d-bed4-7e5bcede8e44	410a6c83-b8fd-4948-b839-77ecb801b209	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.040542+00
1d630634-859e-423e-ae89-035f177b47b4	410a6c83-b8fd-4948-b839-77ecb801b209	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.040542+00
b8fb1268-1982-473a-aadd-143ae2d47fd5	410a6c83-b8fd-4948-b839-77ecb801b209	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.040542+00
3d769a62-dd23-4a01-a3bc-ae2bc2e0fe8c	410a6c83-b8fd-4948-b839-77ecb801b209	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.040542+00
a5376100-3d77-45ca-aa57-05c26de9d8f4	410a6c83-b8fd-4948-b839-77ecb801b209	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.040542+00
b1ca9d7c-9440-4018-b29b-8db99e813ba7	410a6c83-b8fd-4948-b839-77ecb801b209	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The comparison with imported cement is implied but effective.	\N	2026-05-04 11:14:33.040542+00
25d9996e-3155-4731-a241-9f674d8271cb	c8dea943-2e1a-4575-90bc-244da15fefec	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.049079+00
922fa14a-d4a8-4492-b603-fe3097929e93	c8dea943-2e1a-4575-90bc-244da15fefec	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.049079+00
308b35e0-5c12-413f-8332-bb722ea4518a	c8dea943-2e1a-4575-90bc-244da15fefec	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.049079+00
92f2acc2-aed7-47a3-a5e8-0d768bfec717	c8dea943-2e1a-4575-90bc-244da15fefec	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.049079+00
990abe10-321a-4616-951b-c8eaad29d1c7	c8dea943-2e1a-4575-90bc-244da15fefec	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.049079+00
08a1214e-7766-4860-820e-0d2a2862798c	c8dea943-2e1a-4575-90bc-244da15fefec	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.049079+00
fe136dd9-2c2b-4b07-b9b6-ab8daab6f84e	c8dea943-2e1a-4575-90bc-244da15fefec	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.049079+00
ed081243-b341-4251-84dd-e18baae19ea0	c8dea943-2e1a-4575-90bc-244da15fefec	85d46e14-1258-44db-8c69-be4f7888de87	I'm in construction. This ad speaks directly to me. Very relevant.	\N	2026-05-04 11:14:33.049079+00
2666569f-5a78-4d01-8bc9-7c2f0e368e0c	b604fd50-c0c9-4b7c-8b32-892518e7df64	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.058787+00
980d1d14-79c6-494c-aa73-9f789c5a229d	b604fd50-c0c9-4b7c-8b32-892518e7df64	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.058787+00
847d9799-57d1-436d-bc6c-171d9e673ce9	b604fd50-c0c9-4b7c-8b32-892518e7df64	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.058787+00
a22219e4-be7d-47a1-a2b1-24c799091742	b604fd50-c0c9-4b7c-8b32-892518e7df64	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.058787+00
467880e7-463c-4df1-8b6b-cbf481d6c7ac	b604fd50-c0c9-4b7c-8b32-892518e7df64	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.058787+00
5e41fd7b-2f13-415f-821d-d02130c87e4b	b604fd50-c0c9-4b7c-8b32-892518e7df64	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.058787+00
67130e0d-6b54-4114-8cc8-226230b2766f	b604fd50-c0c9-4b7c-8b32-892518e7df64	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.058787+00
195b8ee7-ae12-4d89-b013-283278c2ebd1	b604fd50-c0c9-4b7c-8b32-892518e7df64	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The comparison with imported cement is implied but effective.	\N	2026-05-04 11:14:33.058787+00
3368af77-6455-458e-8886-02b95462a465	977d50ea-7bf5-420d-abd7-90570ea155dd	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.067801+00
5c3ee167-d604-4740-a68e-4e8e0595bbdb	977d50ea-7bf5-420d-abd7-90570ea155dd	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.067801+00
3962d3bc-70f8-49f3-be19-e45d49362091	977d50ea-7bf5-420d-abd7-90570ea155dd	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.067801+00
554b9e55-d776-4430-bcbd-a32441820413	977d50ea-7bf5-420d-abd7-90570ea155dd	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.067801+00
f63ee301-8ce3-4f77-a1f3-9fd3b269676e	977d50ea-7bf5-420d-abd7-90570ea155dd	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.067801+00
996ac4d7-ac0d-4508-9641-5692391e95f7	977d50ea-7bf5-420d-abd7-90570ea155dd	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.067801+00
4a32190d-0166-4303-8466-5a2ac9fe017d	977d50ea-7bf5-420d-abd7-90570ea155dd	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.067801+00
8a909d1e-a6dc-4f77-bb36-0d894ea7221a	977d50ea-7bf5-420d-abd7-90570ea155dd	85d46e14-1258-44db-8c69-be4f7888de87	Trusted brand, great ad. Will share this with my estate agent network.	\N	2026-05-04 11:14:33.067801+00
ca93223e-bf88-4425-bf9f-69013596bb89	4977a03d-d6ef-4840-a294-1037d4241336	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.077359+00
70d81274-0851-48f5-9b43-d2b2ea75ac44	4977a03d-d6ef-4840-a294-1037d4241336	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.077359+00
cd84816f-0ccd-40cd-8c53-7f63405e2ea7	4977a03d-d6ef-4840-a294-1037d4241336	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.077359+00
d202587c-996f-4b15-a8a5-23d69752c663	4977a03d-d6ef-4840-a294-1037d4241336	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.077359+00
78827074-93ae-4b23-90be-30d7582d3c57	4977a03d-d6ef-4840-a294-1037d4241336	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.077359+00
57f97307-33dd-4fe8-9684-94ac987cb168	4977a03d-d6ef-4840-a294-1037d4241336	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:33.077359+00
889434da-eb7c-4979-acec-4c915da963f4	4977a03d-d6ef-4840-a294-1037d4241336	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.077359+00
e2902cdb-ce13-4f9b-827b-8efa0332cf01	4977a03d-d6ef-4840-a294-1037d4241336	85d46e14-1258-44db-8c69-be4f7888de87	Trusted brand, great ad. Will share this with my estate agent network.	\N	2026-05-04 11:14:33.077359+00
f3dfd5ac-4e60-4fb0-8f7a-59be1ec7c85c	b3989144-79e1-493a-b84e-46072edf1ccb	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.086222+00
839c5169-73e9-4758-91d5-b877b9d76ec6	b3989144-79e1-493a-b84e-46072edf1ccb	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.086222+00
9ccc5702-c4ef-4889-81f7-2ababa60116d	b3989144-79e1-493a-b84e-46072edf1ccb	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.086222+00
ba6246c9-4744-4209-b050-22a865c3d0f0	b3989144-79e1-493a-b84e-46072edf1ccb	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.086222+00
b09513ad-6c48-4c7b-826d-2eff8f810ef9	b3989144-79e1-493a-b84e-46072edf1ccb	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.086222+00
470ff484-03d1-453e-be3f-c17faf67baaa	b3989144-79e1-493a-b84e-46072edf1ccb	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.086222+00
0c6a8a5a-0d4b-4d42-97e3-a5a4704b35cc	b3989144-79e1-493a-b84e-46072edf1ccb	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.086222+00
e7e1efc3-60a8-494d-b143-be45053aebad	b3989144-79e1-493a-b84e-46072edf1ccb	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The durability angle resonates with me as someone building to last.	\N	2026-05-04 11:14:33.086222+00
2a4a830c-d433-4089-ab36-ed32221d754c	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.094535+00
6632e24d-88a5-46f0-bbd7-262be02b829a	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.094535+00
a15a7d08-6721-4166-b602-e36aa23338ec	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:33.094535+00
c7d7bda5-e6b7-475c-b008-f7e86b586a57	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.094535+00
385128f6-2958-4767-8a3d-41fc47199bb7	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.094535+00
27361744-c52d-4a63-bbf6-edf719216c05	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:33.094535+00
44ebba43-b523-4fd2-86df-6c394d31aabc	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.094535+00
55702558-b526-4015-9680-645668a0bc0b	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	85d46e14-1258-44db-8c69-be4f7888de87	Beautiful execution. Shows Dangote knows their audience.	\N	2026-05-04 11:14:33.094535+00
bcd8f5d2-2330-48f5-8f14-1dc9bf507411	d3070228-9738-4934-b9f4-745ccb758fcb	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.104276+00
66d199a7-792b-4234-b85e-a197405fe5aa	d3070228-9738-4934-b9f4-745ccb758fcb	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:33.104276+00
37c5d723-6e68-4db1-850b-3678257a1bdf	d3070228-9738-4934-b9f4-745ccb758fcb	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.104276+00
63c956ff-f450-41ab-ae77-bdd4bc0ca35c	d3070228-9738-4934-b9f4-745ccb758fcb	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.104276+00
4ce76326-5808-4682-8874-0eed5ffaa9b5	d3070228-9738-4934-b9f4-745ccb758fcb	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.104276+00
84f31433-c3a3-49f2-bd13-a3394839f4cb	d3070228-9738-4934-b9f4-745ccb758fcb	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.104276+00
9647ca9f-5a25-42eb-b987-44680eb24964	d3070228-9738-4934-b9f4-745ccb758fcb	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.104276+00
45e1d442-372c-4bf2-9efd-bbc4ed24d1e0	d3070228-9738-4934-b9f4-745ccb758fcb	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The durability angle resonates with me as someone building to last.	\N	2026-05-04 11:14:33.104276+00
90dd61dd-336d-40a3-aa56-d3bd75dace41	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.113238+00
5dd59c98-d2ac-4333-994d-a96502ec328e	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.113238+00
a07979af-487d-46de-aaa3-fc80cc5f0434	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.113238+00
f4619f25-8d33-4397-ba7c-bcb008bc4a9f	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.113238+00
91a1f750-a9c7-4b9f-b154-c2eaf7ac526c	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.113238+00
0575824a-7916-4eb4-a3ea-dcae525cec98	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.113238+00
a5df11f6-e026-4560-ba0d-8c8733a208ff	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.113238+00
f020c1a1-c1af-4510-8160-c2870b28c214	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	85d46e14-1258-44db-8c69-be4f7888de87	Beautiful execution. Shows Dangote knows their audience.	\N	2026-05-04 11:14:33.113238+00
887713dd-9c5a-4204-a3f0-724ca861f46c	627e513e-fcbb-4517-ba73-9b138601ae62	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.134458+00
4ca1bc17-f886-4caa-8cc3-2c21eee07a94	627e513e-fcbb-4517-ba73-9b138601ae62	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.134458+00
02957918-0246-4622-8fcf-961cd28790e7	627e513e-fcbb-4517-ba73-9b138601ae62	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.134458+00
4dd2671c-99e2-4000-ac1f-922789a49ed7	627e513e-fcbb-4517-ba73-9b138601ae62	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.134458+00
549a63d5-598b-49bc-aafc-543204430b79	627e513e-fcbb-4517-ba73-9b138601ae62	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.134458+00
011f71ae-8576-49e1-8bd2-59ed2c70ebd3	627e513e-fcbb-4517-ba73-9b138601ae62	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.134458+00
a60f2a4e-d4e2-415b-989f-4d60015aaf4d	627e513e-fcbb-4517-ba73-9b138601ae62	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:33.134458+00
a1177def-de0f-4785-9a72-807dc501e306	627e513e-fcbb-4517-ba73-9b138601ae62	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very relevant to my life right now as I'm renovating my property.	\N	2026-05-04 11:14:33.134458+00
b1c37085-992d-47b7-80f3-10dbef5e6895	8882d436-cd20-4bfd-9c34-a28ad1263558	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.144389+00
400356f7-72be-4a94-884b-7c0f1cae5e73	8882d436-cd20-4bfd-9c34-a28ad1263558	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.144389+00
364491b4-e4d2-4f78-b90c-63df280a11e7	8882d436-cd20-4bfd-9c34-a28ad1263558	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.144389+00
bdd6269e-2ed9-41e7-9ca6-c571cfcf0551	8882d436-cd20-4bfd-9c34-a28ad1263558	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.144389+00
ab64d366-1709-45e3-af94-052765ea57df	8882d436-cd20-4bfd-9c34-a28ad1263558	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:33.144389+00
1b97a846-83d7-4631-a5bc-25b41c19da40	8882d436-cd20-4bfd-9c34-a28ad1263558	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.144389+00
040983d9-efba-4888-b7d8-5922249dc9c0	8882d436-cd20-4bfd-9c34-a28ad1263558	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.144389+00
43e0e744-74ea-4659-af48-b610f7cae569	8882d436-cd20-4bfd-9c34-a28ad1263558	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very relevant to my life right now as I'm renovating my property.	\N	2026-05-04 11:14:33.144389+00
906f1f07-18a5-4e4f-bf9d-450db82ac7c7	cef20cad-ff54-414b-9e73-97f6ff2d3a59	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.152874+00
597a5f51-5124-4ea6-b232-8503784dca83	cef20cad-ff54-414b-9e73-97f6ff2d3a59	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.152874+00
7e7cdfe7-5494-4c63-8e67-fc50894e552e	cef20cad-ff54-414b-9e73-97f6ff2d3a59	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.152874+00
1539f2c1-bfeb-4945-bec7-a373ef4d50b7	cef20cad-ff54-414b-9e73-97f6ff2d3a59	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.152874+00
8f8124da-6d79-4f40-a36e-abeaae25d548	cef20cad-ff54-414b-9e73-97f6ff2d3a59	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.152874+00
aec88bea-3647-45f3-86b9-b0ef4ed4e5c2	cef20cad-ff54-414b-9e73-97f6ff2d3a59	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.152874+00
be91d686-59e0-4e9b-b7c7-4ed52de03060	cef20cad-ff54-414b-9e73-97f6ff2d3a59	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.152874+00
ec559cc0-f75a-4964-b999-4e0eee175860	cef20cad-ff54-414b-9e73-97f6ff2d3a59	85d46e14-1258-44db-8c69-be4f7888de87	The pride of using Nigerian products came through in the ad.	\N	2026-05-04 11:14:33.152874+00
29daf137-e218-4562-9f7c-52e238fd9c7c	e4d765b2-5044-49a3-be06-f6eceb49abd9	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.163062+00
dd373450-f013-4626-b1e0-ade19c63886c	e4d765b2-5044-49a3-be06-f6eceb49abd9	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.163062+00
85d1bc49-c49e-4266-947a-ed4bafa6b00e	e4d765b2-5044-49a3-be06-f6eceb49abd9	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.163062+00
57777f1c-6f7a-4c7c-bd6d-b256fdea559a	e4d765b2-5044-49a3-be06-f6eceb49abd9	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.163062+00
10f0bada-3e01-430a-bd59-8c866c2deaf4	e4d765b2-5044-49a3-be06-f6eceb49abd9	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.163062+00
ff32734b-8b73-4faf-9614-7b8a42c45251	e4d765b2-5044-49a3-be06-f6eceb49abd9	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.163062+00
cb950b47-8c01-4823-bd2a-f204947665af	e4d765b2-5044-49a3-be06-f6eceb49abd9	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.163062+00
3ed814ad-3e4d-431c-bb04-2a77349d830e	e4d765b2-5044-49a3-be06-f6eceb49abd9	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Good pacing. Didn't feel too long or too rushed.	\N	2026-05-04 11:14:33.163062+00
02099b90-1479-44e7-b9b2-4aa637f80663	32a962e5-ca81-4017-abc7-5c8060a04db7	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.171709+00
25d818ae-2903-4e89-bd18-163a7907eb1a	32a962e5-ca81-4017-abc7-5c8060a04db7	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.171709+00
ee3e7f3f-e9ff-4093-b238-a63855841b98	32a962e5-ca81-4017-abc7-5c8060a04db7	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.171709+00
72e169ee-1e14-4569-af85-0319da6dcd01	32a962e5-ca81-4017-abc7-5c8060a04db7	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.171709+00
da157735-d528-43a2-9ba5-7cee957d3069	32a962e5-ca81-4017-abc7-5c8060a04db7	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.171709+00
5d068db2-d9ad-4cca-9df0-80520f5e97ff	32a962e5-ca81-4017-abc7-5c8060a04db7	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.171709+00
a2c3f295-df90-4bc4-92f5-b23bf5576701	32a962e5-ca81-4017-abc7-5c8060a04db7	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.171709+00
0038b320-5152-4854-a9cc-24777d65bb50	32a962e5-ca81-4017-abc7-5c8060a04db7	85d46e14-1258-44db-8c69-be4f7888de87	The pride of using Nigerian products came through in the ad.	\N	2026-05-04 11:14:33.171709+00
d6286958-9d43-40dc-9a03-bfe9a6a3ebfd	f56f5f4d-247c-4747-94ce-755de5f352f8	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.180802+00
cc5dbf9a-9702-4c72-87e6-9324b0976f51	f56f5f4d-247c-4747-94ce-755de5f352f8	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.180802+00
6317825e-88db-42e4-805b-d1c584a1486c	f56f5f4d-247c-4747-94ce-755de5f352f8	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.180802+00
4d320d55-f174-4bdf-a343-529ab000375a	f56f5f4d-247c-4747-94ce-755de5f352f8	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.180802+00
3d57e862-6abc-477c-95ea-c58d96435a8a	f56f5f4d-247c-4747-94ce-755de5f352f8	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.180802+00
f0e200f9-f897-43c3-8519-289af73dd691	f56f5f4d-247c-4747-94ce-755de5f352f8	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.180802+00
e7b29fd9-9402-4c11-89f5-7ba81b570c7c	f56f5f4d-247c-4747-94ce-755de5f352f8	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.180802+00
18b3afc1-99f4-47d1-82cb-9abfb9622fce	f56f5f4d-247c-4747-94ce-755de5f352f8	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Good pacing. Didn't feel too long or too rushed.	\N	2026-05-04 11:14:33.180802+00
85a651d6-cb72-4067-aedb-68559fd0ca87	df2e9b6b-45eb-439c-9773-e8d21122a513	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.188778+00
58cb0621-0334-4c67-a3be-b9a155522914	df2e9b6b-45eb-439c-9773-e8d21122a513	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.188778+00
9ac12eed-0893-4a8f-ba69-d0b759694f10	df2e9b6b-45eb-439c-9773-e8d21122a513	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:33.188778+00
f2b7ab3f-adc9-4fec-a451-37414fcb1a68	df2e9b6b-45eb-439c-9773-e8d21122a513	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.188778+00
3af74e94-31d5-4c79-b24a-9740e10423e2	df2e9b6b-45eb-439c-9773-e8d21122a513	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.188778+00
1b700a10-c497-4fa9-a37e-adf459894265	df2e9b6b-45eb-439c-9773-e8d21122a513	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.188778+00
2e19bf46-05cb-4b8e-a657-511c4f23996d	df2e9b6b-45eb-439c-9773-e8d21122a513	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.188778+00
b42c7bd3-caee-4903-8a26-d394ec7dc1f3	df2e9b6b-45eb-439c-9773-e8d21122a513	85d46e14-1258-44db-8c69-be4f7888de87	Dangote should do more ads like this across all platforms.	\N	2026-05-04 11:14:33.188778+00
6d5ae9ef-04a2-4eb3-8379-182eb6e961d5	66c3be0e-e271-4cef-9f15-dac27663dca6	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.198745+00
4f97c20e-c1e4-49cd-aa93-535836e939f2	66c3be0e-e271-4cef-9f15-dac27663dca6	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.198745+00
990295b8-9fb9-47ce-a86b-87fe54afdde7	66c3be0e-e271-4cef-9f15-dac27663dca6	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.198745+00
516f3914-0be6-4b72-8a8c-ff0ef5c1fae5	66c3be0e-e271-4cef-9f15-dac27663dca6	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.198745+00
bb1cb511-4a85-489d-8539-95b88c5c9216	66c3be0e-e271-4cef-9f15-dac27663dca6	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.198745+00
4235a67a-e06a-4040-8d76-a6bd90b8d6b0	66c3be0e-e271-4cef-9f15-dac27663dca6	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.198745+00
acdda38e-5017-413f-8e1b-281ceaf7d820	66c3be0e-e271-4cef-9f15-dac27663dca6	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.198745+00
0e2777c6-d98c-4fa8-9bf6-f11c72321fec	66c3be0e-e271-4cef-9f15-dac27663dca6	85d46e14-1258-44db-8c69-be4f7888de87	Dangote should do more ads like this across all platforms.	\N	2026-05-04 11:14:33.198745+00
8840cac0-d1c3-4c40-9198-c80759393f48	9dba5125-28d7-45d6-b0ae-d735a78494f5	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.207409+00
b1a1c362-a5a4-4206-803f-8cba9b1b7268	9dba5125-28d7-45d6-b0ae-d735a78494f5	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.207409+00
3a8643ff-22ea-44f9-ab0b-13ef14fa5dbf	9dba5125-28d7-45d6-b0ae-d735a78494f5	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.207409+00
0090aecf-a8b5-4d5b-923d-52915ebd0fe8	9dba5125-28d7-45d6-b0ae-d735a78494f5	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.207409+00
24c4e771-61a9-48b1-ab6b-cf4ea46e0f09	9dba5125-28d7-45d6-b0ae-d735a78494f5	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:33.207409+00
28591ac6-e5d2-459b-b72c-c9d316cd8394	9dba5125-28d7-45d6-b0ae-d735a78494f5	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.207409+00
9b01dcc9-0f22-404c-a75e-1ea5b55a6fd7	9dba5125-28d7-45d6-b0ae-d735a78494f5	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.207409+00
d7bc10e2-752e-4fbb-a5a7-26406efd6172	9dba5125-28d7-45d6-b0ae-d735a78494f5	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The sustainability message was subtle but I caught it. Well done.	\N	2026-05-04 11:14:33.207409+00
6a9b85ec-cac4-456b-bab0-447ab7d9bf16	e2e9def1-a736-47c5-9c76-9855b343d5e0	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.216427+00
0e55a136-d510-4928-9188-d2cdf99477f9	e2e9def1-a736-47c5-9c76-9855b343d5e0	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.216427+00
17f87c8e-f4cf-4c5f-9798-7311d64193c4	e2e9def1-a736-47c5-9c76-9855b343d5e0	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.216427+00
eb2dfa61-1122-41fd-ba9c-248bc21d3046	e2e9def1-a736-47c5-9c76-9855b343d5e0	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.216427+00
160d3e49-b047-4ebb-86d6-9d665d7c1883	e2e9def1-a736-47c5-9c76-9855b343d5e0	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.216427+00
2f0a5b86-eac9-40b5-bff7-64e5451fe128	e2e9def1-a736-47c5-9c76-9855b343d5e0	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:33.216427+00
cc85012f-b807-422a-8d18-e85d0c760fd6	e2e9def1-a736-47c5-9c76-9855b343d5e0	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.216427+00
cb1d33e8-3349-4dc8-9961-a39ae7ed03a9	e2e9def1-a736-47c5-9c76-9855b343d5e0	85d46e14-1258-44db-8c69-be4f7888de87	Made me curious to visit the Dangote website for more information.	\N	2026-05-04 11:14:33.216427+00
e2bac35a-d1af-4ae9-97e1-8c2f9c516f15	30a69f7b-062d-4fe1-ae56-c89001007830	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.225305+00
59e227f0-8a26-4f36-bc74-d60af7dfb20d	30a69f7b-062d-4fe1-ae56-c89001007830	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.225305+00
f22aabfe-bd71-429c-b667-1ab1681cb33c	30a69f7b-062d-4fe1-ae56-c89001007830	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:33.225305+00
331f1aa4-a6d7-4485-8a51-53e1bf672fae	30a69f7b-062d-4fe1-ae56-c89001007830	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:33.225305+00
ceff3a4a-e32b-4295-bb66-555882767a6a	30a69f7b-062d-4fe1-ae56-c89001007830	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.225305+00
210bd0b8-33ad-4017-b4ad-f612acb22a5f	30a69f7b-062d-4fe1-ae56-c89001007830	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.225305+00
643567c2-b16d-426a-b6b0-8eb8a78a4768	30a69f7b-062d-4fe1-ae56-c89001007830	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.225305+00
74edcfaa-31ee-4e98-b268-256a9be28730	30a69f7b-062d-4fe1-ae56-c89001007830	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The sustainability message was subtle but I caught it. Well done.	\N	2026-05-04 11:14:33.225305+00
a9b72669-6444-470e-9deb-ed68e88d27a4	91084e76-306a-424f-a5a7-be098480ea96	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.234719+00
f0b6f5e3-9320-445e-a864-0bf69addae36	91084e76-306a-424f-a5a7-be098480ea96	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.234719+00
bdcab387-2a04-47b6-a18f-69f458b64ceb	91084e76-306a-424f-a5a7-be098480ea96	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.234719+00
27912190-6e3b-47d5-b185-7ae4a5ff8bb6	91084e76-306a-424f-a5a7-be098480ea96	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.234719+00
730b22b4-0ee5-4346-955c-e00841d93cd8	91084e76-306a-424f-a5a7-be098480ea96	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.234719+00
2b569a7a-08d8-441c-a610-b67253def9ce	91084e76-306a-424f-a5a7-be098480ea96	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.234719+00
3c2e3e76-4a88-425a-926a-fa71569191b5	91084e76-306a-424f-a5a7-be098480ea96	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.234719+00
3aebcdc3-8aab-492d-bbea-32b001fb1e66	91084e76-306a-424f-a5a7-be098480ea96	85d46e14-1258-44db-8c69-be4f7888de87	Made me curious to visit the Dangote website for more information.	\N	2026-05-04 11:14:33.234719+00
c5efc7f3-7b3d-4708-abf5-c05f02286121	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.244111+00
f9a321e0-1839-4f8b-982d-018a0e3f8d35	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.244111+00
f8c677ba-8755-4641-a114-08f396c24bbc	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.244111+00
fdbfb03a-374f-4d60-8d6e-aec1ecdb217f	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.244111+00
0d9cd730-a0ce-4bd1-b705-cac5d91c9dbc	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.244111+00
bac9a0a9-6d3f-495b-bfa9-74d0610be795	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.244111+00
79cb37b6-5a0d-470d-907e-2d0af979a19f	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.244111+00
9260c604-edf6-4903-a414-88ad6f44dc83	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad spoke to both individual buyers and large-scale contractors. Smart.	\N	2026-05-04 11:14:33.244111+00
df2a4df7-abf5-456c-94a7-efcdf42f95f1	a20a39ae-7136-4fab-a55b-a85cb05c8b24	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.253503+00
259f544e-6df0-4f96-aff7-0ea5a46268a8	a20a39ae-7136-4fab-a55b-a85cb05c8b24	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.253503+00
11a968ef-3c56-48d1-87b8-fa382420acfe	a20a39ae-7136-4fab-a55b-a85cb05c8b24	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:33.253503+00
723b1953-b9af-4973-9b4c-703e876c28d4	a20a39ae-7136-4fab-a55b-a85cb05c8b24	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:33.253503+00
b508b0e5-b06a-4966-a74d-2b11f070e1b2	a20a39ae-7136-4fab-a55b-a85cb05c8b24	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:33.253503+00
5732da55-fc36-4cdf-ab15-d6f88ecd697d	a20a39ae-7136-4fab-a55b-a85cb05c8b24	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.253503+00
8476b309-faad-44f0-95e1-9127da1498b4	a20a39ae-7136-4fab-a55b-a85cb05c8b24	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.253503+00
eabe51a5-2acd-4e14-9082-2c42cdd0bbd8	a20a39ae-7136-4fab-a55b-a85cb05c8b24	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad spoke to both individual buyers and large-scale contractors. Smart.	\N	2026-05-04 11:14:33.253503+00
772913d8-5dd3-43a8-8098-7f75a80fc3d2	3d27283c-4903-46ca-8a18-8f5c6fb38602	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.262104+00
6fb38b99-c3b1-4893-962d-ec64629a235c	3d27283c-4903-46ca-8a18-8f5c6fb38602	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.262104+00
fa27a477-b975-47d2-91d1-db163413ad76	3d27283c-4903-46ca-8a18-8f5c6fb38602	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.262104+00
3b01b7cd-03d6-4265-8ead-f8b09cb11ce1	3d27283c-4903-46ca-8a18-8f5c6fb38602	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.262104+00
393b042b-6460-4bde-b342-019d7173f8aa	3d27283c-4903-46ca-8a18-8f5c6fb38602	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.262104+00
474b73a5-f271-4847-ad32-26309680b651	3d27283c-4903-46ca-8a18-8f5c6fb38602	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.262104+00
d0062fd0-3f70-4dc0-94a6-04320b4351ad	3d27283c-4903-46ca-8a18-8f5c6fb38602	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.262104+00
fec5c5f0-162a-4f7e-9a59-38871b5e5745	3d27283c-4903-46ca-8a18-8f5c6fb38602	85d46e14-1258-44db-8c69-be4f7888de87	Nigerian brands like Dangote deserve more visibility. This ad helps.	\N	2026-05-04 11:14:33.262104+00
d39cc28c-3331-4274-8b29-59e91d08cc3e	a3305cb0-3cca-44a9-884b-94063b8de50a	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.270833+00
30d65126-7935-432b-88e3-295806f14068	a3305cb0-3cca-44a9-884b-94063b8de50a	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:33.270833+00
8301e5b8-fb26-45df-93d2-64b630da6adf	a3305cb0-3cca-44a9-884b-94063b8de50a	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:33.270833+00
ca27b372-3b07-47a1-8837-8595b6d9017d	a3305cb0-3cca-44a9-884b-94063b8de50a	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.270833+00
f48579b1-4bab-4895-8d0b-f52cc6089cad	a3305cb0-3cca-44a9-884b-94063b8de50a	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.270833+00
b09a3fdb-1a52-4ec6-8dde-fbfaa35561d3	a3305cb0-3cca-44a9-884b-94063b8de50a	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.270833+00
97850652-cb43-4084-b0b7-b11553a96e08	a3305cb0-3cca-44a9-884b-94063b8de50a	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:33.270833+00
c162f102-0f41-4fd9-94f0-92b90c2483a2	22c898e0-fa78-4295-851e-37023f60ecc5	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.366586+00
a78f0aaf-9546-4463-a312-34ca72266cb8	a3305cb0-3cca-44a9-884b-94063b8de50a	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	I'm in Kaduna and Dangote cement is everywhere here. Good ad.	\N	2026-05-04 11:14:33.270833+00
cc6e126e-9edb-4b9a-ac59-19449b0a1fa8	87998689-c9ed-4a2c-8c0a-cd047d3787b0	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.279147+00
93262415-00cd-4dc9-bf7a-6c3c5c4c5403	87998689-c9ed-4a2c-8c0a-cd047d3787b0	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.279147+00
be7be867-39fc-4005-873e-ce6c48ed21e4	87998689-c9ed-4a2c-8c0a-cd047d3787b0	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.279147+00
1cd4ad6f-b38a-45e4-8472-e2035871122f	87998689-c9ed-4a2c-8c0a-cd047d3787b0	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.279147+00
1b2f6a12-3c3c-4a8d-a370-dfe5b3ab5c3a	87998689-c9ed-4a2c-8c0a-cd047d3787b0	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.279147+00
5fd7654a-5654-44e7-84e3-5464e6e6620b	87998689-c9ed-4a2c-8c0a-cd047d3787b0	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:33.279147+00
9bebedb1-3b6a-48f8-b456-58fba8130ab4	87998689-c9ed-4a2c-8c0a-cd047d3787b0	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.279147+00
24bdb6a9-690f-4c66-b4f1-c8be13f21c11	87998689-c9ed-4a2c-8c0a-cd047d3787b0	85d46e14-1258-44db-8c69-be4f7888de87	Nigerian brands like Dangote deserve more visibility. This ad helps.	\N	2026-05-04 11:14:33.279147+00
93f47e63-d071-4bd7-9209-bf1af99def13	b4b24a11-2c4b-42cb-9119-8a60b46ce117	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.289761+00
1e46686e-6edc-4285-968f-ed7ea48590b0	b4b24a11-2c4b-42cb-9119-8a60b46ce117	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.289761+00
9edf0ce9-fdc3-49fb-9801-385bf438635b	b4b24a11-2c4b-42cb-9119-8a60b46ce117	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.289761+00
1eef945d-619e-4abf-abfd-b2ae47232e49	b4b24a11-2c4b-42cb-9119-8a60b46ce117	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.289761+00
a011b5de-856b-4704-9470-b5ea43166caf	b4b24a11-2c4b-42cb-9119-8a60b46ce117	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.289761+00
be494a17-225d-460e-87a7-f434feb7d0a6	b4b24a11-2c4b-42cb-9119-8a60b46ce117	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.289761+00
91f4a73b-393e-468b-82f7-158668227412	b4b24a11-2c4b-42cb-9119-8a60b46ce117	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.289761+00
f2d8a20e-3a9c-4eba-a3b2-5206964da694	b4b24a11-2c4b-42cb-9119-8a60b46ce117	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	I'm in Kaduna and Dangote cement is everywhere here. Good ad.	\N	2026-05-04 11:14:33.289761+00
bf49ba9a-2d0c-489f-b3e1-415cdb4a6a79	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.299382+00
0a185cae-5d77-4986-b68a-b965b1fc94ea	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.299382+00
46466a1c-95dc-4515-bea5-0e3d9d5890c8	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:33.299382+00
f8f2e456-38bc-4fa0-9a28-fd24c7e7d0d3	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.299382+00
93460135-ce25-46fd-a446-e2a2e609080c	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.299382+00
f767748e-506d-4597-811f-490ad9593709	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.299382+00
af945c82-8ad6-4c09-8c29-6d959c6a7f06	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.299382+00
b0e99873-d5fb-4c73-9e28-f1e587368c50	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	85d46e14-1258-44db-8c69-be4f7888de87	The call to action at the end was clear and actionable.	\N	2026-05-04 11:14:33.299382+00
604b0316-194f-43cb-a541-0b82938ba218	b37e1b83-3b15-4313-839d-6224a90b9ff9	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.308434+00
f6d69361-fde2-4001-9b74-f010ff4f6b30	b37e1b83-3b15-4313-839d-6224a90b9ff9	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.308434+00
89d7dd03-758a-422b-940c-fd9096af9d04	b37e1b83-3b15-4313-839d-6224a90b9ff9	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:33.308434+00
debacdd7-e58b-4e68-a764-9705ef6406ea	b37e1b83-3b15-4313-839d-6224a90b9ff9	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.308434+00
f5b50701-1e74-4464-a236-47b8ff582485	b37e1b83-3b15-4313-839d-6224a90b9ff9	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.308434+00
1984782a-f666-4eb1-b4a4-2dc8876b1f97	b37e1b83-3b15-4313-839d-6224a90b9ff9	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.308434+00
923228ff-d6be-4858-b78a-9b0394970971	b37e1b83-3b15-4313-839d-6224a90b9ff9	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.308434+00
084fdb25-cea9-42d9-917d-08f654639d5e	b37e1b83-3b15-4313-839d-6224a90b9ff9	85d46e14-1258-44db-8c69-be4f7888de87	The call to action at the end was clear and actionable.	\N	2026-05-04 11:14:33.308434+00
5fbcc74b-52fb-4ea6-9fa1-b19fa242afb2	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.317862+00
78730ceb-3027-41d5-839f-7fd90ba7101f	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.317862+00
3ce450be-ec31-4147-8a94-d59da522d017	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.317862+00
ae7e46ab-1819-4058-abdc-0e43fa2c0642	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.317862+00
b6d9dd6e-ece2-4a7d-acea-bf16e020dafd	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.317862+00
4e3808d7-fca3-4740-96f7-b977aade7ecb	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.317862+00
93049c28-94ab-4619-add7-737462540184	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.317862+00
50f52f5b-59e2-4550-92b7-3c8825e9b06e	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Watching this from Port Harcourt — Dangote is big here too!	\N	2026-05-04 11:14:33.317862+00
e5243fc5-02dd-400f-8e86-cc2edd863791	4201927d-7141-4612-aae3-c4ba21761d67	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.327411+00
37ae52a3-00f4-4571-8164-58e120a0d1d4	4201927d-7141-4612-aae3-c4ba21761d67	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.327411+00
7d535681-1a94-48be-bbe6-cf3b69cb0094	4201927d-7141-4612-aae3-c4ba21761d67	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.327411+00
dddf3a59-84c3-49d3-9db2-a4299e407b82	4201927d-7141-4612-aae3-c4ba21761d67	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.327411+00
a05f9ffe-7e6c-4b54-a9ce-a840e4eb68c9	4201927d-7141-4612-aae3-c4ba21761d67	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.327411+00
ed7cbade-bbd0-4e71-80fd-56b2d5de3bbb	4201927d-7141-4612-aae3-c4ba21761d67	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.327411+00
2d2039b7-7ca8-441f-8fd8-1e79c36a852a	4201927d-7141-4612-aae3-c4ba21761d67	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.327411+00
94fe58ff-761e-4cdc-a313-b25918a1b9e1	4201927d-7141-4612-aae3-c4ba21761d67	85d46e14-1258-44db-8c69-be4f7888de87	The emphasis on job creation resonated with me. Patriotic angle worked.	\N	2026-05-04 11:14:33.327411+00
1dc82afc-e363-4414-8173-0ffa61ef7bd0	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.337402+00
f7ede206-a137-40df-acd8-d513a6b04681	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.337402+00
1efc1245-4028-4a38-aec3-509dd4308bfc	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.337402+00
9f7e8fbb-d30d-4d0a-b8b4-0cb7f98d3fc4	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.337402+00
7eaf22b3-b4b5-4098-bdec-3ea5576c747a	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.337402+00
f1612c3c-da4f-4de5-b946-76925b9cfa74	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.337402+00
60e501a2-3260-42c5-92d7-292dac902852	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:33.337402+00
28dd80f8-7e4b-4c80-89ed-1d22e5a08d74	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Watching this from Port Harcourt — Dangote is big here too!	\N	2026-05-04 11:14:33.337402+00
e0c28b1e-2b46-4604-aa01-6ba44bba9d8f	0ba32da1-325e-4cf2-a80b-6253906c65d5	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.347626+00
7feb845f-a7a2-4963-9553-a7de497e77c2	0ba32da1-325e-4cf2-a80b-6253906c65d5	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.347626+00
15cbec5a-a9ab-4373-921c-c83b800e9cd5	0ba32da1-325e-4cf2-a80b-6253906c65d5	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:33.347626+00
df2c7a81-2f0e-48e4-8900-a85a3fef950a	0ba32da1-325e-4cf2-a80b-6253906c65d5	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.347626+00
43d1a575-b860-455e-b03f-c617e85d9621	0ba32da1-325e-4cf2-a80b-6253906c65d5	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.347626+00
4424d6f3-1b13-41df-84fa-2a7b00720660	0ba32da1-325e-4cf2-a80b-6253906c65d5	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.347626+00
446bf700-7d94-4fe0-8cb9-dd5753f5d277	0ba32da1-325e-4cf2-a80b-6253906c65d5	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.347626+00
0a1d909e-eab6-4fa5-9f37-429462937b14	0ba32da1-325e-4cf2-a80b-6253906c65d5	85d46e14-1258-44db-8c69-be4f7888de87	The emphasis on job creation resonated with me. Patriotic angle worked.	\N	2026-05-04 11:14:33.347626+00
034af445-a0b0-4d8a-95f4-90ae84a8026c	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.356481+00
bed1a91c-329c-406f-bc4d-c7c5caecc482	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.356481+00
51816f21-6cdb-4c06-821c-8c4a5fd2baaa	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.356481+00
492a42dc-16c9-489e-bbe1-a82a8e93a3b3	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.356481+00
39201704-d8d9-4a75-8a55-7f1fe65afb48	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:33.356481+00
5929f629-a795-4f52-aee5-73ac470c7072	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.356481+00
ed48263e-49fa-4fc7-a24e-db7abd097f4a	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.356481+00
bd3a1c53-4add-4e4e-ab40-e11f0e9a33fc	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Overall impression: very positive. Would watch more Dangote ads.	\N	2026-05-04 11:14:33.356481+00
ad7a3a73-d25c-42f8-befe-736b3378cc3a	22c898e0-fa78-4295-851e-37023f60ecc5	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.366586+00
9e9cad1a-0f45-4890-a796-2011c40b18fa	22c898e0-fa78-4295-851e-37023f60ecc5	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:33.366586+00
d319ce33-80c4-4d0e-830d-45bc276c1162	22c898e0-fa78-4295-851e-37023f60ecc5	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.366586+00
43e5f679-d167-4f0c-8618-61fa56c99d7c	22c898e0-fa78-4295-851e-37023f60ecc5	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.366586+00
1ae84720-19e4-49f0-aacd-d0dd7c739490	22c898e0-fa78-4295-851e-37023f60ecc5	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.366586+00
10a2f23e-d13a-4934-acbf-475f23030ec7	22c898e0-fa78-4295-851e-37023f60ecc5	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:33.366586+00
9410fb83-1bb8-419a-8f50-9c746eeaf34c	22c898e0-fa78-4295-851e-37023f60ecc5	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Overall impression: very positive. Would watch more Dangote ads.	\N	2026-05-04 11:14:33.366586+00
fa31f459-abca-4262-acf4-9352ea3ceefd	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.375332+00
8b365bd1-1059-4116-be73-fb34873bd940	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.375332+00
f0dbbc0b-2d6e-4a5b-ba1e-09cd486b64e0	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.375332+00
0756595c-c8ee-4ce8-adac-8d7274f3cf10	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.375332+00
e90f1de0-0f45-48dd-8284-fd596618c4a4	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.375332+00
c63b2c78-367b-4ac0-ab62-30aa11468f1d	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.375332+00
b8b725e7-7ec2-4e13-9726-f9938967a9d5	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.375332+00
0a65d285-69c6-4186-b90b-ce6fdad372a3	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	85d46e14-1258-44db-8c69-be4f7888de87	Short and punchy is the right approach for this type of product.	\N	2026-05-04 11:14:33.375332+00
fb0abe63-c09b-43db-83ee-19c89d38315e	d8b58fb7-6847-4b92-af14-c57a6992a0e3	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.384541+00
2bf47783-d990-4797-9864-43dc2f1a3df8	d8b58fb7-6847-4b92-af14-c57a6992a0e3	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.384541+00
66e29c54-426e-4d1c-9be0-1e054af6345d	d8b58fb7-6847-4b92-af14-c57a6992a0e3	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:33.384541+00
79f4bf9a-af53-4d77-b9b4-e665a5321dc5	d8b58fb7-6847-4b92-af14-c57a6992a0e3	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.384541+00
f5895f80-7c3d-4aa3-b869-dc5451319ab2	d8b58fb7-6847-4b92-af14-c57a6992a0e3	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.384541+00
500161d4-4557-4038-9455-139bbf241f09	d8b58fb7-6847-4b92-af14-c57a6992a0e3	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.384541+00
ddf7c549-e915-4517-8d88-b126f90b3915	d8b58fb7-6847-4b92-af14-c57a6992a0e3	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.384541+00
677b42e7-7b83-4309-bc45-52e4c3d4c9ef	d8b58fb7-6847-4b92-af14-c57a6992a0e3	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad reinforces why Dangote remains the gold standard in Nigeria.	\N	2026-05-04 11:14:33.384541+00
357ea510-9d1e-498c-91c1-3b166781af87	5bc1e70c-516f-450e-b621-a690072cb520	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.393308+00
8cd23e2b-391b-4e33-a581-3149a4130ce3	5bc1e70c-516f-450e-b621-a690072cb520	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.393308+00
3cec1eb8-9da5-4d45-9817-b304db147285	5bc1e70c-516f-450e-b621-a690072cb520	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.393308+00
067f3815-f926-4940-ae23-8e9999f0717e	5bc1e70c-516f-450e-b621-a690072cb520	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.393308+00
dc0fe0b9-d361-4e3a-a259-1f646518f97a	5bc1e70c-516f-450e-b621-a690072cb520	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.393308+00
b15d04c9-6675-4643-9ad8-bdbd7fb8a2d0	5bc1e70c-516f-450e-b621-a690072cb520	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:33.393308+00
d9e2f394-9eb0-4ef6-80bb-3a5ff88a906f	5bc1e70c-516f-450e-b621-a690072cb520	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.393308+00
9681bb2e-5ee0-4e1e-868e-915cfc9b9504	5bc1e70c-516f-450e-b621-a690072cb520	85d46e14-1258-44db-8c69-be4f7888de87	Short and punchy is the right approach for this type of product.	\N	2026-05-04 11:14:33.393308+00
492b17e3-954f-4c59-95ce-785a450fa812	fd4c4135-2ae3-45ad-98f4-665c40358d53	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.402534+00
a821efde-c516-4cad-af63-23cbd0ccbee8	fd4c4135-2ae3-45ad-98f4-665c40358d53	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.402534+00
5dbe615f-2230-4c2c-9fb8-9ea738dda2f1	fd4c4135-2ae3-45ad-98f4-665c40358d53	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:33.402534+00
4db50682-2b4e-4098-90b8-778dc7ffff78	fd4c4135-2ae3-45ad-98f4-665c40358d53	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.402534+00
8a24d2f9-485d-477a-9f5c-f09b91516050	fd4c4135-2ae3-45ad-98f4-665c40358d53	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.402534+00
9ad051e1-ebac-48ae-985b-b5fc81c8617e	fd4c4135-2ae3-45ad-98f4-665c40358d53	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.402534+00
992825cc-a14a-4665-8967-194b11be84d0	fd4c4135-2ae3-45ad-98f4-665c40358d53	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.402534+00
3fc74e61-c332-405e-9e22-f779dc88cd8f	fd4c4135-2ae3-45ad-98f4-665c40358d53	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad reinforces why Dangote remains the gold standard in Nigeria.	\N	2026-05-04 11:14:33.402534+00
62301e7b-12f0-4ae6-9a61-a899ef35b9bf	63b866f3-85d9-4109-baea-e31f82852fe2	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.4111+00
d2cbdf6a-2834-4c6e-88d8-5bcff8e19c8f	63b866f3-85d9-4109-baea-e31f82852fe2	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.4111+00
0cfc1f16-8ea7-4c9a-88d9-f6d877c867d0	63b866f3-85d9-4109-baea-e31f82852fe2	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.4111+00
0c729b59-3996-4902-aaa4-8829446e2ebb	63b866f3-85d9-4109-baea-e31f82852fe2	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.4111+00
8ec25956-6db0-4113-8128-7aff202c4845	63b866f3-85d9-4109-baea-e31f82852fe2	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.4111+00
c39b1dd2-c544-4ffe-8066-8c6973dc2e3e	63b866f3-85d9-4109-baea-e31f82852fe2	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:33.4111+00
bfe22e0e-77c8-4183-abaf-19df9b6d732b	63b866f3-85d9-4109-baea-e31f82852fe2	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.4111+00
da2c7dde-8266-4232-9892-9512003ca5cc	63b866f3-85d9-4109-baea-e31f82852fe2	85d46e14-1258-44db-8c69-be4f7888de87	As a civil engineering student, this ad is inspiring for our industry.	\N	2026-05-04 11:14:33.4111+00
013dc2a8-3344-4d79-89dc-2a85546f46b1	d2beef58-ab46-430f-ac2a-00e12818f8c2	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.42173+00
907a6559-78ce-49a3-8bd8-0984a1c3ce6c	d2beef58-ab46-430f-ac2a-00e12818f8c2	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:33.42173+00
86cd093b-3eb5-4084-a8db-55c8f041c316	d2beef58-ab46-430f-ac2a-00e12818f8c2	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.42173+00
59791d1b-9304-4f28-9080-9dca9fd9565f	d2beef58-ab46-430f-ac2a-00e12818f8c2	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.42173+00
e9108965-ef09-4f4f-b93f-6d7615fea834	d2beef58-ab46-430f-ac2a-00e12818f8c2	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.42173+00
2038a403-c511-4e6c-8adb-68413480c840	d2beef58-ab46-430f-ac2a-00e12818f8c2	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:33.42173+00
74f57563-1631-435b-b3bf-e0346867aec7	d2beef58-ab46-430f-ac2a-00e12818f8c2	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.42173+00
8bcc04ed-9073-4250-a56c-b158b3373175	d2beef58-ab46-430f-ac2a-00e12818f8c2	85d46e14-1258-44db-8c69-be4f7888de87	As a civil engineering student, this ad is inspiring for our industry.	\N	2026-05-04 11:14:33.42173+00
09b3329c-9003-4aaf-b6c8-7fdaa511dd36	734290b2-d00a-4d9e-953e-cbaaca25247a	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.430171+00
ff9f5a2e-0323-4c8e-8bff-72ce6cdce2e1	734290b2-d00a-4d9e-953e-cbaaca25247a	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.430171+00
23884b2d-fb5c-4919-b6e1-4a8e0e7b779e	734290b2-d00a-4d9e-953e-cbaaca25247a	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:33.430171+00
901fcc16-19d9-4760-b80e-e726f6e1d066	734290b2-d00a-4d9e-953e-cbaaca25247a	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.430171+00
3bbb1691-925b-46d1-8ba9-c969567d1944	734290b2-d00a-4d9e-953e-cbaaca25247a	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:33.430171+00
48da2e97-8008-4865-aaab-96258f2a6191	734290b2-d00a-4d9e-953e-cbaaca25247a	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.430171+00
ebc15ee3-2217-4cf9-a005-9258d93a1c11	734290b2-d00a-4d9e-953e-cbaaca25247a	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.430171+00
94c492b4-f2b4-4ec7-acde-ce598429d74c	734290b2-d00a-4d9e-953e-cbaaca25247a	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very confident brand voice. Exactly what Dangote should project.	\N	2026-05-04 11:14:33.430171+00
7ec2f6c9-d829-481d-a4ca-e9390392f9d3	20acd977-8ac6-4ab6-9585-9d3c8827bb98	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.440653+00
16a2f71a-cf6e-4e7a-8f6b-c9c0319d5b35	20acd977-8ac6-4ab6-9585-9d3c8827bb98	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:33.440653+00
979c3910-3f1c-4c9a-90bf-426ad9efd090	20acd977-8ac6-4ab6-9585-9d3c8827bb98	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:33.440653+00
58fbfbe0-4b31-4df5-b41c-014a11222e44	20acd977-8ac6-4ab6-9585-9d3c8827bb98	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.440653+00
f10565ca-f6bc-4658-8a7b-1bba759d4c75	20acd977-8ac6-4ab6-9585-9d3c8827bb98	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.440653+00
22296494-cca6-4ebb-86e5-8c2fd81323c3	20acd977-8ac6-4ab6-9585-9d3c8827bb98	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:33.440653+00
0d1e8d47-0846-4f67-a7c7-076f30e4584e	20acd977-8ac6-4ab6-9585-9d3c8827bb98	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.440653+00
131518ad-6f90-4b4a-8543-4821baa3cf76	20acd977-8ac6-4ab6-9585-9d3c8827bb98	85d46e14-1258-44db-8c69-be4f7888de87	Touched on quality, durability, and trust. Hit all the right notes.	\N	2026-05-04 11:14:33.440653+00
b9587e87-55fb-48e2-9bb7-49dc44f06a27	eb6c03b6-516b-48ed-b206-d9c83a15129c	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.448971+00
4f3fc5cb-38a2-47c2-8aa5-4454931727cb	eb6c03b6-516b-48ed-b206-d9c83a15129c	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.448971+00
c4cda335-a1c3-4ad8-9cfd-14b9be5a603f	eb6c03b6-516b-48ed-b206-d9c83a15129c	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.448971+00
3467fa3f-e085-43bc-9dab-b51cd6e34ecb	eb6c03b6-516b-48ed-b206-d9c83a15129c	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.448971+00
272f2b10-1ae3-40c6-981d-37127b3e1a89	eb6c03b6-516b-48ed-b206-d9c83a15129c	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.448971+00
d6f78b65-050c-4a61-9714-83fd37aae9a1	eb6c03b6-516b-48ed-b206-d9c83a15129c	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:33.448971+00
1bbf4461-d07b-4d0f-b36e-d4acd3a8d958	eb6c03b6-516b-48ed-b206-d9c83a15129c	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.448971+00
9fa1813b-7afd-4ec1-92b8-16cdbf338770	eb6c03b6-516b-48ed-b206-d9c83a15129c	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very confident brand voice. Exactly what Dangote should project.	\N	2026-05-04 11:14:33.448971+00
0fde1bf2-5575-4e64-b211-825816485c23	db8e306b-483d-4651-9066-bb63e3b92c9d	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.458701+00
0244d9fd-9138-4e47-bb6f-ac2fa17286e2	db8e306b-483d-4651-9066-bb63e3b92c9d	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.458701+00
7a1319f6-96cc-4bca-801b-7133a52376b6	db8e306b-483d-4651-9066-bb63e3b92c9d	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.458701+00
a0127e99-09ec-4d26-b32e-84b4780f3271	db8e306b-483d-4651-9066-bb63e3b92c9d	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.458701+00
373d262b-8ed3-45a1-b655-126021630e68	db8e306b-483d-4651-9066-bb63e3b92c9d	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.458701+00
624b3b42-373e-47c9-8ebb-9a319d433018	db8e306b-483d-4651-9066-bb63e3b92c9d	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.458701+00
4e4364fd-5b4d-4223-adfb-8de7e04ba61a	db8e306b-483d-4651-9066-bb63e3b92c9d	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.458701+00
3f637303-0972-4eb0-8c61-48e5ea3db04b	db8e306b-483d-4651-9066-bb63e3b92c9d	85d46e14-1258-44db-8c69-be4f7888de87	Touched on quality, durability, and trust. Hit all the right notes.	\N	2026-05-04 11:14:33.458701+00
8b60c235-af10-4cb0-b99e-38c80c891a65	b837b636-d54e-477a-90af-e493cd94ab47	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.469516+00
1284b959-f2c7-40d2-b0a1-7a05547cb2f3	b837b636-d54e-477a-90af-e493cd94ab47	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.469516+00
91c8198b-0ed4-47d4-832a-5fc20b895967	b837b636-d54e-477a-90af-e493cd94ab47	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.469516+00
3bfdddae-2957-4a63-9b0a-f8ed9337990d	b837b636-d54e-477a-90af-e493cd94ab47	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.469516+00
e8a23df4-20af-4596-9083-6975d837da3a	b837b636-d54e-477a-90af-e493cd94ab47	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.469516+00
4ad2c3f4-ec6d-47a2-804f-9f8c6c651098	b837b636-d54e-477a-90af-e493cd94ab47	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.469516+00
02576567-8426-456b-bc1e-866cdc5dfc3c	b837b636-d54e-477a-90af-e493cd94ab47	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:33.469516+00
9ac0b080-fe5a-4327-895f-e849e589a13c	b837b636-d54e-477a-90af-e493cd94ab47	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Fantastic campaign. Glad to be reviewing content from Dangote.	\N	2026-05-04 11:14:33.469516+00
3f9c17d4-f787-4c03-a082-670df00b3c0e	84dfaac3-c40f-47ab-862a-6463665a6f60	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.478191+00
e29f072a-9cb7-4856-a960-8ecf3946c7ee	84dfaac3-c40f-47ab-862a-6463665a6f60	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.478191+00
93dee6d4-4b38-422b-baf1-2dce26cbeb65	84dfaac3-c40f-47ab-862a-6463665a6f60	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.478191+00
4c21b88e-1cc4-4311-8d29-c12f665bbe19	84dfaac3-c40f-47ab-862a-6463665a6f60	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.478191+00
98e0a5c8-b426-4195-94af-3b90d67cd859	84dfaac3-c40f-47ab-862a-6463665a6f60	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.478191+00
194fee93-a524-4b39-a531-ff273567e77e	84dfaac3-c40f-47ab-862a-6463665a6f60	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.478191+00
e887236a-e85b-4dd8-acf2-686d7dfc90b3	84dfaac3-c40f-47ab-862a-6463665a6f60	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.478191+00
ccc7890f-5cc7-4504-9300-2867349c448e	84dfaac3-c40f-47ab-862a-6463665a6f60	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Fantastic campaign. Glad to be reviewing content from Dangote.	\N	2026-05-04 11:14:33.478191+00
aa9a16c7-4c76-4204-a7b0-452cfe5b39de	6bffd0bb-4656-48f2-88dc-0d78419ba453	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.486657+00
d7bd86e4-7bd8-41a1-aa46-434435f3eb2c	6bffd0bb-4656-48f2-88dc-0d78419ba453	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.486657+00
8cf443b5-28b3-4ad6-b3ff-6618e2d31356	6bffd0bb-4656-48f2-88dc-0d78419ba453	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.486657+00
5ae0b84e-5c05-4dff-ad6a-4301dcee076c	6bffd0bb-4656-48f2-88dc-0d78419ba453	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.486657+00
8d9cc5cd-1864-45b4-9191-e6282984d6d4	6bffd0bb-4656-48f2-88dc-0d78419ba453	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.486657+00
9d3941e5-f6f2-4d5b-b6e5-b7ede9145868	6bffd0bb-4656-48f2-88dc-0d78419ba453	36302c68-7999-4abb-a2f0-7d51f757801d	\N	None of the above	2026-05-04 11:14:33.486657+00
f8508b8d-9fae-47b2-9faa-5cfb5a4d3b7c	6bffd0bb-4656-48f2-88dc-0d78419ba453	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.486657+00
f28620ab-097d-44b4-bd66-7cce07da69d2	6bffd0bb-4656-48f2-88dc-0d78419ba453	85d46e14-1258-44db-8c69-be4f7888de87	The Nigerian landscape in the ad background was a nice touch.	\N	2026-05-04 11:14:33.486657+00
6300f2c0-4279-416c-b546-5377e6eddd71	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.495529+00
03900f64-fd42-4698-9af9-57c92724bc94	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.495529+00
c42f062e-9f1e-4aa7-9a24-841b4147b7f1	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.495529+00
e513674c-a8b7-4401-8b1a-22cb0b25aa43	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.495529+00
168a5c17-cd28-4571-85df-e33629ecab54	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.495529+00
cf2c1e58-9d93-451a-a925-616fe34e1123	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.495529+00
5c032753-5d5d-4df8-908f-dc1746b81776	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Neutral	2026-05-04 11:14:33.495529+00
529ef58b-e2ef-441f-9c9d-d47533040c70	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad was clear about the value proposition. No confusion.	\N	2026-05-04 11:14:33.495529+00
1a9fc95b-2b24-4208-8acc-fd24eb58554a	1d238bb8-7afd-4d31-b56e-57cd8831025d	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.505697+00
913ae367-3555-474d-b993-839f82373de3	1d238bb8-7afd-4d31-b56e-57cd8831025d	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.505697+00
6a330b41-8f5c-40ba-a78b-a7aa757108b7	1d238bb8-7afd-4d31-b56e-57cd8831025d	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.505697+00
edee690d-9f8e-4815-8b2b-fdff90d8e404	1d238bb8-7afd-4d31-b56e-57cd8831025d	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.505697+00
17e53bec-c917-4be4-80f2-f89176538c24	1d238bb8-7afd-4d31-b56e-57cd8831025d	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.505697+00
a74823ed-ea0f-4baa-9bf4-3a099d9faa61	1d238bb8-7afd-4d31-b56e-57cd8831025d	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.505697+00
779c8e5d-4b1f-4264-85f8-ec5e7e45d788	1d238bb8-7afd-4d31-b56e-57cd8831025d	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.505697+00
2d4c5910-990e-43db-9646-1121e7e55d8f	1d238bb8-7afd-4d31-b56e-57cd8831025d	85d46e14-1258-44db-8c69-be4f7888de87	The Nigerian landscape in the ad background was a nice touch.	\N	2026-05-04 11:14:33.505697+00
df2d8e51-c03d-4e4c-93d1-267fd77875fb	adea2112-7829-48ad-9f0b-3c3dc8c08d28	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.514924+00
b0866266-80ec-49ce-b063-edb138024a85	adea2112-7829-48ad-9f0b-3c3dc8c08d28	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.514924+00
fdcbd245-6bec-4694-ae43-0bd0951ace26	adea2112-7829-48ad-9f0b-3c3dc8c08d28	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:33.514924+00
6b98334c-ae28-4ba1-81a0-021f6ca14cc8	adea2112-7829-48ad-9f0b-3c3dc8c08d28	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:33.514924+00
45511992-0efc-427d-806f-2142caca43f0	adea2112-7829-48ad-9f0b-3c3dc8c08d28	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:33.514924+00
63f40317-3eb7-4f48-9ac0-a24182bf1ba5	adea2112-7829-48ad-9f0b-3c3dc8c08d28	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.514924+00
489ccbc0-69a8-4420-afe2-0d21555aa897	adea2112-7829-48ad-9f0b-3c3dc8c08d28	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Very proud and supportive	2026-05-04 11:14:33.514924+00
11aa6a6b-630e-418d-a5ee-d9c969db5c96	adea2112-7829-48ad-9f0b-3c3dc8c08d28	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Ad was clear about the value proposition. No confusion.	\N	2026-05-04 11:14:33.514924+00
55e70868-f68e-480d-ab0e-a061cd9ca74f	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.523485+00
3b0cce51-500f-4e03-9d9c-d28a6e0a5646	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.523485+00
fa6c583d-d656-4a8e-ae30-73e7b42a0aac	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.523485+00
f6ffd354-091c-448d-bb63-d028fb762ec3	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.523485+00
17d1c73f-a3bc-45e6-af64-834c55355ac2	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.523485+00
0b9cfb3b-8696-42c4-a901-b16230428860	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.523485+00
c552acff-2b21-4836-83ab-1fdec16ecd7c	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.523485+00
94259326-2986-49dc-8cc4-637af41da2cb	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	85d46e14-1258-44db-8c69-be4f7888de87	Love how Dangote is investing in digital advertising. Smart move.	\N	2026-05-04 11:14:33.523485+00
9d33959d-2a7c-4bcc-a196-1380a427d37b	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.533271+00
800dde74-a866-4abc-9b60-754efccd7e55	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.533271+00
8df4ac6b-5021-4b3a-9ff1-6f0eb7c9df2a	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.533271+00
fae8488c-aece-4664-a583-da9ed0b6667a	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	3	2026-05-04 11:14:33.533271+00
f81c264a-c0db-4dd3-9b46-4c2cbb7bd780	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.533271+00
f796b65d-8b80-45bf-a1ee-53ddba8b9f8f	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.533271+00
290254a2-d6ab-4886-b77a-70f3fc0bca92	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.533271+00
144e45d8-2179-4da6-b059-8360101ff4a4	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	85d46e14-1258-44db-8c69-be4f7888de87	Love how Dangote is investing in digital advertising. Smart move.	\N	2026-05-04 11:14:33.533271+00
d98bd5f2-823f-48c2-aaec-d9a16176ee5c	325fa6ac-a019-4517-a701-d21afb713a6d	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.542665+00
3b2cc56e-8f45-4275-9bc7-1eb41825c539	325fa6ac-a019-4517-a701-d21afb713a6d	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.542665+00
e25fdd37-b4f3-46dd-a8c5-32bbda902f7d	325fa6ac-a019-4517-a701-d21afb713a6d	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:33.542665+00
f67750d3-7024-4122-ad22-66cd579a695e	325fa6ac-a019-4517-a701-d21afb713a6d	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.542665+00
8d3ca88d-2c3a-4312-b764-840f44873dfa	325fa6ac-a019-4517-a701-d21afb713a6d	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Much more positive	2026-05-04 11:14:33.542665+00
ef52418b-f65e-4398-b6c0-f487a3c8485f	325fa6ac-a019-4517-a701-d21afb713a6d	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.542665+00
870d4e2c-2c7a-4383-a540-7b424f693ffd	325fa6ac-a019-4517-a701-d21afb713a6d	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.542665+00
39350f1e-138c-4717-823d-100707000d97	325fa6ac-a019-4517-a701-d21afb713a6d	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The production values are high — befitting a brand of Dangote's stature.	\N	2026-05-04 11:14:33.542665+00
d21ce2d8-ce7f-4459-a774-d58061d433fb	fd98f02a-fe56-4913-aa50-2253cd443515	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.552399+00
5aa2c940-ed3b-487f-addb-2768d1a312b9	fd98f02a-fe56-4913-aa50-2253cd443515	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.552399+00
00275fb7-ada4-4faf-bcd9-1cdb64494672	fd98f02a-fe56-4913-aa50-2253cd443515	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.552399+00
e9e0ebf4-f29a-4342-9c1d-d8af8f95fc1c	fd98f02a-fe56-4913-aa50-2253cd443515	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.552399+00
27ab2140-8c79-4d10-baaf-2e76859222b1	fd98f02a-fe56-4913-aa50-2253cd443515	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.552399+00
dce3f7b2-a602-469d-87d9-edac4e35aa2b	fd98f02a-fe56-4913-aa50-2253cd443515	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.552399+00
bc0cd8bc-7728-4618-902c-6d98f8396fa6	fd98f02a-fe56-4913-aa50-2253cd443515	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.552399+00
26bfe0fd-4053-4899-ac4f-f2bf6e18e21f	fd98f02a-fe56-4913-aa50-2253cd443515	85d46e14-1258-44db-8c69-be4f7888de87	Watching from Enugu. Dangote is very popular here for construction.	\N	2026-05-04 11:14:33.552399+00
31e8aaaa-b4f4-4a0c-a3a7-05fc183c2576	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.561968+00
ea188d64-7bc7-4a3c-96ce-5b6a37563f22	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.561968+00
28d95399-7c61-426e-9a79-6ff3e367cffa	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:33.561968+00
e0f5cb18-854a-44f9-85f4-81df27f8b514	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.561968+00
b5d4738c-e588-4338-9109-9b22986ebe74	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.561968+00
d670ac54-afd5-44ec-b8be-a0b3a2ebf668	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.561968+00
512f2ed7-36c1-4999-9863-02fecb6750e9	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.561968+00
af473c76-c26e-4cf7-ac38-ed84c7ece4d3	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The production values are high — befitting a brand of Dangote's stature.	\N	2026-05-04 11:14:33.561968+00
81ea8520-14bd-4669-9520-bfb282de2624	eb9bd312-f0ac-417b-b844-e54cf4e075fb	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.570144+00
aaed855d-2bab-4e24-8e6c-b7c4bfa7f678	eb9bd312-f0ac-417b-b844-e54cf4e075fb	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.570144+00
e0abb065-77f5-4fe0-b9c4-fe9797556ddc	eb9bd312-f0ac-417b-b844-e54cf4e075fb	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.570144+00
94de110d-efce-4e10-ad06-30407306262c	eb9bd312-f0ac-417b-b844-e54cf4e075fb	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.570144+00
59d6ff61-2d48-439e-bbd7-0da1d84a415b	eb9bd312-f0ac-417b-b844-e54cf4e075fb	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.570144+00
2eb6791f-04e9-4325-9653-f2b490107c13	eb9bd312-f0ac-417b-b844-e54cf4e075fb	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.570144+00
5860f243-b109-4b72-a71f-f0fa9fb5b2d7	eb9bd312-f0ac-417b-b844-e54cf4e075fb	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.570144+00
5b986942-172d-4a88-be3a-a6d2e7a34e22	eb9bd312-f0ac-417b-b844-e54cf4e075fb	85d46e14-1258-44db-8c69-be4f7888de87	Watching from Enugu. Dangote is very popular here for construction.	\N	2026-05-04 11:14:33.570144+00
d62063c2-8fbd-4672-8e81-6778761ae9a5	dd77da3f-6285-4045-83db-91807ac9b749	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.579518+00
19bcfe9e-3d0e-4e5a-8a2a-8e14977557f0	dd77da3f-6285-4045-83db-91807ac9b749	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.579518+00
f07c0977-dbcd-4917-ab7f-bef1ca25cd08	dd77da3f-6285-4045-83db-91807ac9b749	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.579518+00
b3167b2c-fe4d-42f0-a569-46302888918b	dd77da3f-6285-4045-83db-91807ac9b749	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.579518+00
eda711ca-75ef-44ff-a0fa-1aa354445576	dd77da3f-6285-4045-83db-91807ac9b749	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.579518+00
9f5d8cf2-7817-47e3-b1d8-273ee4c5ff51	dd77da3f-6285-4045-83db-91807ac9b749	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Logistics / Transport	2026-05-04 11:14:33.579518+00
0c62328a-cd46-411a-8bf6-0d24f8233bf9	dd77da3f-6285-4045-83db-91807ac9b749	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.579518+00
b685e83c-8fcd-4397-8ea8-1c297571edab	dd77da3f-6285-4045-83db-91807ac9b749	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad made an emotional connection for me. That's effective advertising.	\N	2026-05-04 11:14:33.579518+00
1fd194ab-954a-4aad-a6a3-2e97fc3d4a14	b970045c-2c1e-4042-8d10-3f4fcb44326c	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.589148+00
1f30afc3-3a77-4c36-b88d-a3b2823691d9	b970045c-2c1e-4042-8d10-3f4fcb44326c	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.589148+00
59dfc1bc-e7bf-4d3e-88be-783ba180be61	b970045c-2c1e-4042-8d10-3f4fcb44326c	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.589148+00
e198e00f-f004-492b-8c59-be103b08f56f	b970045c-2c1e-4042-8d10-3f4fcb44326c	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.589148+00
91fba197-d899-4f65-85e7-dcb63d24a7d2	b970045c-2c1e-4042-8d10-3f4fcb44326c	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.589148+00
e52fefd9-7b11-48dc-a4b2-4a89e0ef80c7	b970045c-2c1e-4042-8d10-3f4fcb44326c	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.589148+00
f3d26c0b-cdb2-435d-8029-125e362d364e	b970045c-2c1e-4042-8d10-3f4fcb44326c	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.589148+00
5a4a41f6-24f2-4bc1-a25f-efe5229dbd3a	b970045c-2c1e-4042-8d10-3f4fcb44326c	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The ad made an emotional connection for me. That's effective advertising.	\N	2026-05-04 11:14:33.589148+00
7ac5e6bf-4c1e-4e5a-b6dd-112a66dae6ce	b43d393b-18fd-4222-84be-e9a02d4f4014	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.598154+00
67521446-0c21-421c-b309-a488a2dd8bdc	b43d393b-18fd-4222-84be-e9a02d4f4014	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.598154+00
ba517d43-e3af-415a-86e8-c99688b5e323	b43d393b-18fd-4222-84be-e9a02d4f4014	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.598154+00
22b1bebb-53d7-4103-9988-ffef274b7eb5	b43d393b-18fd-4222-84be-e9a02d4f4014	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.598154+00
bb74c8ae-0c98-4f07-ad26-04a075a905af	b43d393b-18fd-4222-84be-e9a02d4f4014	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.598154+00
36ffd735-64ba-43a7-ac99-95884e6a9fea	b43d393b-18fd-4222-84be-e9a02d4f4014	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.598154+00
069b6854-d85e-43da-ba9a-2076d55aca4a	b43d393b-18fd-4222-84be-e9a02d4f4014	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.598154+00
c34e1d75-cd2a-49d8-9ea3-e64fa8c9838a	b43d393b-18fd-4222-84be-e9a02d4f4014	85d46e14-1258-44db-8c69-be4f7888de87	I'd give this ad a 10/10 for clarity, relevance, and brand alignment.	\N	2026-05-04 11:14:33.598154+00
bce38cf2-6248-4e88-b23e-6980f2ca1c24	8a449245-6285-4e9c-b412-713b4ec40f9d	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.607192+00
e55e0988-2ef4-4e59-91cb-94a0415efb61	8a449245-6285-4e9c-b412-713b4ec40f9d	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.607192+00
b2004cdb-dda3-42ee-82ca-386f3fbd20a7	8a449245-6285-4e9c-b412-713b4ec40f9d	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Happy / Entertained	2026-05-04 11:14:33.607192+00
9d8a3f3a-4183-4b31-ab33-b5650f8ec8a8	8a449245-6285-4e9c-b412-713b4ec40f9d	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.607192+00
c4a41848-1779-46f8-825b-5012899f3fc9	8a449245-6285-4e9c-b412-713b4ec40f9d	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.607192+00
175fa97d-5970-4064-803b-3b4aac540f1c	8a449245-6285-4e9c-b412-713b4ec40f9d	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.607192+00
537ea2c2-1364-4437-b4f9-b536b4788402	8a449245-6285-4e9c-b412-713b4ec40f9d	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.607192+00
97046ec2-ade8-4dd6-a891-189003a5468f	8a449245-6285-4e9c-b412-713b4ec40f9d	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The Dangote cement ad really resonated with me. Quality is undeniable!	\N	2026-05-04 11:14:33.607192+00
d17e5b8c-2c5b-46a9-8e82-c177a888e7b9	20ec81ca-6a65-475a-9897-2b67712fd4bc	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.615803+00
c3777e20-9855-465a-8069-7c73a169c4c7	20ec81ca-6a65-475a-9897-2b67712fd4bc	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.615803+00
823f5622-44e4-4aa6-a755-4a5788ea3bed	20ec81ca-6a65-475a-9897-2b67712fd4bc	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.615803+00
6c331563-a43d-4641-a5b9-958b7b839618	20ec81ca-6a65-475a-9897-2b67712fd4bc	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.615803+00
62c1c635-74ec-4333-a4b6-212c7e96f71b	20ec81ca-6a65-475a-9897-2b67712fd4bc	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.615803+00
54be206f-641a-4c6e-a454-fede689c5eca	20ec81ca-6a65-475a-9897-2b67712fd4bc	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.615803+00
c65b582b-9da9-452b-91ce-cb786119b1d1	20ec81ca-6a65-475a-9897-2b67712fd4bc	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.615803+00
e645a751-ee87-45c2-a643-37c1529db646	20ec81ca-6a65-475a-9897-2b67712fd4bc	85d46e14-1258-44db-8c69-be4f7888de87	I'd give this ad a 10/10 for clarity, relevance, and brand alignment.	\N	2026-05-04 11:14:33.615803+00
5ba151fa-a664-497b-852c-10f9b52996d4	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.624552+00
fc7598ac-1e53-4493-9a53-39527012e9f3	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:33.624552+00
805ace48-9ede-44ae-ac4e-458067b4695d	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.624552+00
41d2db79-37e1-4b8b-bb61-9826d5374cef	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.624552+00
1e783237-1d98-4b17-b09b-664196549c72	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.624552+00
30f032f0-9c95-48b8-86dd-dcf92b1e87b5	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.624552+00
ef0954d6-44ed-4394-9745-7336729ae1c4	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.624552+00
d44564fb-cda0-4552-afcc-a0b711be9cb6	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	The Dangote cement ad really resonated with me. Quality is undeniable!	\N	2026-05-04 11:14:33.624552+00
74ff5acb-bfd6-4840-8f2f-1670353ac23e	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.634368+00
bed4f910-b411-4bef-8e29-d5313263b4f0	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.634368+00
ce6bd051-b295-45b4-b273-119435339634	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Happy / Entertained	2026-05-04 11:14:33.634368+00
59ab3f71-1537-414c-8eb7-5953c1cef77f	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.634368+00
d0008e1e-9354-47af-9509-b7928704898a	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	No change	2026-05-04 11:14:33.634368+00
93045ca7-5575-4492-baa5-96b222cb2845	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Agriculture / Food production	2026-05-04 11:14:33.634368+00
80729be9-85fe-4f83-82ce-f742f136af68	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.634368+00
c0c5626a-5747-4bf1-8944-90bd5b0139b5	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	85d46e14-1258-44db-8c69-be4f7888de87	I've used Dangote products for years. Great to see them on this platform.	\N	2026-05-04 11:14:33.634368+00
3d092195-7d69-4df0-a212-e5e9499c73d1	e0728c97-46d0-4171-a257-436008b88a65	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.643969+00
6bb83fec-27b6-433c-81d0-c5a084b2745e	e0728c97-46d0-4171-a257-436008b88a65	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.643969+00
23865bd1-cff0-4851-b55b-e246084bce89	e0728c97-46d0-4171-a257-436008b88a65	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.643969+00
27ee9722-c384-421e-b673-cd4b7072a896	e0728c97-46d0-4171-a257-436008b88a65	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.643969+00
d6075dc2-23b4-4f70-8b5e-d03b26ee9fce	e0728c97-46d0-4171-a257-436008b88a65	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.643969+00
113a7b0b-11e2-4a3f-9507-fec7f4ec2054	e0728c97-46d0-4171-a257-436008b88a65	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.643969+00
cb3fc1f5-c289-4548-8d9e-d3e0be5c2de7	e0728c97-46d0-4171-a257-436008b88a65	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.643969+00
2282d781-6d40-48cc-801a-219d030385a6	e0728c97-46d0-4171-a257-436008b88a65	85d46e14-1258-44db-8c69-be4f7888de87	I've used Dangote products for years. Great to see them on this platform.	\N	2026-05-04 11:14:33.643969+00
fa4656a2-5168-4346-af62-05ef2b5035ee	f2c5b24a-7002-4cf0-9ebd-4817ab110300	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.653082+00
7f10b721-858c-454b-9a97-cd857118fe96	f2c5b24a-7002-4cf0-9ebd-4817ab110300	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.653082+00
c84cf0e6-2cfb-4769-b446-68d2da2f6631	f2c5b24a-7002-4cf0-9ebd-4817ab110300	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.653082+00
dfd8138b-c05b-4e1f-ab0c-1127d6cce856	f2c5b24a-7002-4cf0-9ebd-4817ab110300	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.653082+00
592f76f3-5fe1-4d60-9705-9e18085ee594	f2c5b24a-7002-4cf0-9ebd-4817ab110300	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.653082+00
7da4d98c-5c32-4497-9494-6efad617ea7d	f2c5b24a-7002-4cf0-9ebd-4817ab110300	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Construction / Real estate	2026-05-04 11:14:33.653082+00
3ab33ead-9f1c-4ec0-bd09-ded736d2ca55	f2c5b24a-7002-4cf0-9ebd-4817ab110300	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.653082+00
665c6219-55d6-41ca-aaee-198e41a248f9	f2c5b24a-7002-4cf0-9ebd-4817ab110300	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very professional ad. Dangote is truly a pride of Africa.	\N	2026-05-04 11:14:33.653082+00
8082e95a-6d89-40eb-b62b-71111930cf82	36ce9f6d-dd95-4e25-b630-62db3e81d957	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.662368+00
97871bc8-ae72-4729-963e-96528024ad89	36ce9f6d-dd95-4e25-b630-62db3e81d957	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.662368+00
08762f91-dcf7-4404-8800-9dfa265ae847	36ce9f6d-dd95-4e25-b630-62db3e81d957	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.662368+00
dda033e9-1f35-4888-ba73-5ab67b5dc560	36ce9f6d-dd95-4e25-b630-62db3e81d957	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.662368+00
367b647f-26c5-4ff2-b5dc-be08995a18fb	36ce9f6d-dd95-4e25-b630-62db3e81d957	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Less positive than before	2026-05-04 11:14:33.662368+00
bd756539-9b89-4a80-9168-562141d98cbd	36ce9f6d-dd95-4e25-b630-62db3e81d957	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.662368+00
6f01d7a8-86a0-4d01-a998-9b8529bf6591	36ce9f6d-dd95-4e25-b630-62db3e81d957	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.662368+00
2c678d94-afe1-4e80-9e8a-d4d835a4b2a2	36ce9f6d-dd95-4e25-b630-62db3e81d957	85d46e14-1258-44db-8c69-be4f7888de87	The ad was clear and informative. Would definitely recommend Dangote cement.	\N	2026-05-04 11:14:33.662368+00
76f29f7c-37e7-42c2-9824-c6d56075376b	197bb758-943a-48a1-b906-591277454a13	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.670918+00
be0d946f-c3ff-49ec-8976-1c4dc397e8d1	197bb758-943a-48a1-b906-591277454a13	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.670918+00
0a0ac2ba-42d4-4b09-96b0-425250d93b99	197bb758-943a-48a1-b906-591277454a13	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Curious	2026-05-04 11:14:33.670918+00
e9c553f8-68a1-4829-8768-f99bb2a9a692	197bb758-943a-48a1-b906-591277454a13	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.670918+00
23da5ed7-33e2-48ae-b3a5-eee5c9e941ac	197bb758-943a-48a1-b906-591277454a13	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.670918+00
1b541d2b-e7ce-41a7-88bc-5d49a2512209	197bb758-943a-48a1-b906-591277454a13	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.670918+00
c21bbfee-1f58-4ce2-967f-c7dc2730e8d3	197bb758-943a-48a1-b906-591277454a13	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.670918+00
cbf0a3fa-71a0-44dd-9d10-2692184107d2	197bb758-943a-48a1-b906-591277454a13	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very professional ad. Dangote is truly a pride of Africa.	\N	2026-05-04 11:14:33.670918+00
1eebfef6-fae7-497f-b9d6-b0c24ea12ba4	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.68065+00
52549e5d-6bc5-4369-a9b2-3390c308abcf	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.68065+00
5c61a456-542d-45c3-8cfc-4421ff59b4aa	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.68065+00
b2f22f07-e9ed-47ce-bc05-56a7489e52f6	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.68065+00
3b17a732-2f01-40d5-9441-9cdbaa2b6450	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.68065+00
6bbc0995-4531-4740-9ceb-162a7f449799	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Logistics / Transport	2026-05-04 11:14:33.68065+00
4d4e4710-431b-4607-bf83-44a5e6b4c253	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.68065+00
43739c87-e7b6-4827-a18c-b0fd0c5f64be	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	85d46e14-1258-44db-8c69-be4f7888de87	The ad was clear and informative. Would definitely recommend Dangote cement.	\N	2026-05-04 11:14:33.68065+00
af7d7b81-a048-4a89-b4c6-8ab17f565edf	f01440cc-3ec2-449a-874d-3972827d2d2b	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.690948+00
8e8d0af8-9c5d-4265-bd60-d75696c824be	f01440cc-3ec2-449a-874d-3972827d2d2b	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.690948+00
5b675eb4-2420-4009-9d12-a45884864de1	f01440cc-3ec2-449a-874d-3972827d2d2b	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.690948+00
c6022e5d-4a15-4592-9fc4-ed68e0b426c3	f01440cc-3ec2-449a-874d-3972827d2d2b	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.690948+00
22e7519b-70ca-4c3a-abb4-37b333f09188	f01440cc-3ec2-449a-874d-3972827d2d2b	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.690948+00
03814e99-7c0a-417a-9cf3-29fd9346074c	f01440cc-3ec2-449a-874d-3972827d2d2b	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.690948+00
971751f1-f62c-40e3-8775-70c90e585c3c	f01440cc-3ec2-449a-874d-3972827d2d2b	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.690948+00
de0371e1-3a4f-427a-9f87-18e37292e5a5	f01440cc-3ec2-449a-874d-3972827d2d2b	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Impressive! Shows why Dangote leads the market in Nigeria.	\N	2026-05-04 11:14:33.690948+00
904ae882-1aad-4210-af83-95393be38e4f	7a165eff-7218-42c5-a7d0-a22c3f8058be	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.701044+00
7c781c93-61dd-4b32-a274-8a292ef33f7f	7a165eff-7218-42c5-a7d0-a22c3f8058be	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.701044+00
8a8d4b44-2ab4-4be1-91b2-137582e8c82b	7a165eff-7218-42c5-a7d0-a22c3f8058be	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:33.701044+00
5c725922-1bf5-4336-b2e0-6343df0d2349	7a165eff-7218-42c5-a7d0-a22c3f8058be	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.701044+00
fc45319d-5455-4424-a74b-b87ac43ef26e	7a165eff-7218-42c5-a7d0-a22c3f8058be	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Less positive than before	2026-05-04 11:14:33.701044+00
3654911b-e2db-4146-8710-dc39701b3ba7	7a165eff-7218-42c5-a7d0-a22c3f8058be	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.701044+00
7227a90e-a27e-43ff-a8b8-f170b5819d9a	7a165eff-7218-42c5-a7d0-a22c3f8058be	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.701044+00
53069b57-d437-406c-b7fd-a1106d5f3789	7a165eff-7218-42c5-a7d0-a22c3f8058be	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Impressive! Shows why Dangote leads the market in Nigeria.	\N	2026-05-04 11:14:33.701044+00
9f6ae494-dcad-4482-a951-24e1c955c3a8	e27dfc85-f62d-4cf5-b07c-80800fe861da	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.711051+00
5360d1fb-7e96-4260-aeed-97727560dadf	e27dfc85-f62d-4cf5-b07c-80800fe861da	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	3	2026-05-04 11:14:33.711051+00
b77c86e7-4dcd-43b0-a5c3-7e31644aff8e	e27dfc85-f62d-4cf5-b07c-80800fe861da	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Unconvinced	2026-05-04 11:14:33.711051+00
7703a867-d96b-43ea-bb6d-e7a549bfddba	e27dfc85-f62d-4cf5-b07c-80800fe861da	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.711051+00
6315d049-6767-43b0-99a3-6bac4aa551b9	e27dfc85-f62d-4cf5-b07c-80800fe861da	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.711051+00
f24465c7-b77b-474f-8a64-b0b24cc9baf3	e27dfc85-f62d-4cf5-b07c-80800fe861da	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Construction / Real estate	2026-05-04 11:14:33.711051+00
7f72e178-41af-4683-b52e-2e9e0f4bc605	e27dfc85-f62d-4cf5-b07c-80800fe861da	c48e791f-c727-46ce-b872-cfe535262db6	\N	Neutral	2026-05-04 11:14:33.711051+00
8b93b25c-9201-46bf-bd32-2d98193d6aa6	e27dfc85-f62d-4cf5-b07c-80800fe861da	85d46e14-1258-44db-8c69-be4f7888de87	As a contractor, I trust Dangote cement above all others. The ad confirms it.	\N	2026-05-04 11:14:33.711051+00
5775a2f4-4e1a-4af7-9d0d-6c5d72368b9e	9c31935b-68b4-49e0-85cf-bf1453603d04	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.720198+00
f5f74394-2077-4cde-ad70-dcf0561d246b	9c31935b-68b4-49e0-85cf-bf1453603d04	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	5	2026-05-04 11:14:33.720198+00
78e524de-5a76-4993-a740-3a892c219619	9c31935b-68b4-49e0-85cf-bf1453603d04	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Neutral	2026-05-04 11:14:33.720198+00
cd5bf6ce-a3e8-4139-940e-6191ec71b0e0	9c31935b-68b4-49e0-85cf-bf1453603d04	553f5653-6e53-4e10-9b12-8f933df889fc	\N	5	2026-05-04 11:14:33.720198+00
22d1054c-5ddf-4567-94cf-189bd864b62c	9c31935b-68b4-49e0-85cf-bf1453603d04	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.720198+00
fa0bb789-cd51-440a-a96d-d60fee4d56f5	9c31935b-68b4-49e0-85cf-bf1453603d04	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.720198+00
a362fbd8-763f-47de-b2ca-08191f7676f7	9c31935b-68b4-49e0-85cf-bf1453603d04	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.720198+00
663a777e-7ccf-4eb4-bbc4-77432f3f5011	9c31935b-68b4-49e0-85cf-bf1453603d04	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very relatable ad for everyday Nigerians. Thumbs up!	\N	2026-05-04 11:14:33.720198+00
87a992bd-31eb-4ebf-9586-c549a8d9e342	091c6288-f640-465b-b89f-73d708be0798	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Never heard of it before	2026-05-04 11:14:33.729777+00
b4d33d55-7196-4358-853b-1380bb5e35e0	091c6288-f640-465b-b89f-73d708be0798	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	4	2026-05-04 11:14:33.729777+00
6460fdad-b8cb-4e69-84eb-56d64a28bf3b	091c6288-f640-465b-b89f-73d708be0798	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Neutral	2026-05-04 11:14:33.729777+00
99c95bee-f619-4317-ba2c-0e4d489b69c5	091c6288-f640-465b-b89f-73d708be0798	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.729777+00
127b2002-7944-4920-b422-beb574a878e0	091c6288-f640-465b-b89f-73d708be0798	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.729777+00
a643940b-f667-4bdb-baa3-f22d76bff7b8	091c6288-f640-465b-b89f-73d708be0798	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:33.729777+00
333fdd0e-27ff-40f9-96fd-deff447af9c3	091c6288-f640-465b-b89f-73d708be0798	c48e791f-c727-46ce-b872-cfe535262db6	\N	Sceptical about quality	2026-05-04 11:14:33.729777+00
6efca105-a7a1-4066-b83c-b2664c638488	091c6288-f640-465b-b89f-73d708be0798	85d46e14-1258-44db-8c69-be4f7888de87	As a contractor, I trust Dangote cement above all others. The ad confirms it.	\N	2026-05-04 11:14:33.729777+00
f7fe0a36-df72-49b7-b40d-a7957a328c56	ddd34d9f-8979-4095-90e7-57a0037e7f35	773f200e-2d4b-4bb8-bcf1-349141603877	\N	I've seen it but never used it	2026-05-04 11:14:33.738127+00
7e637497-2d73-4578-af66-83707b2e3d67	ddd34d9f-8979-4095-90e7-57a0037e7f35	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	3	2026-05-04 11:14:33.738127+00
a1f78e10-9d4f-4d20-9a59-82ccf5a4b1b9	ddd34d9f-8979-4095-90e7-57a0037e7f35	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Inspired	2026-05-04 11:14:33.738127+00
cd2da979-ba9a-4e49-b514-f76f877d2d01	ddd34d9f-8979-4095-90e7-57a0037e7f35	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.738127+00
c59c9bc0-7c41-446d-aad0-9e3c85c48807	ddd34d9f-8979-4095-90e7-57a0037e7f35	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	Slightly more positive	2026-05-04 11:14:33.738127+00
147c0c7a-5c20-421c-ac39-226a66dac366	ddd34d9f-8979-4095-90e7-57a0037e7f35	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Agriculture / Food production	2026-05-04 11:14:33.738127+00
b98506f4-4793-48fc-8363-26626fce68ad	ddd34d9f-8979-4095-90e7-57a0037e7f35	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.738127+00
f989fabe-eeda-4e6f-958a-0d5624084943	ddd34d9f-8979-4095-90e7-57a0037e7f35	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Very relatable ad for everyday Nigerians. Thumbs up!	\N	2026-05-04 11:14:33.738127+00
5cafdadd-aa8c-4a1a-8074-d9db2d2072a1	b5403e89-71c6-4a98-ae9a-8aa225be72bb	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.746739+00
3c54de50-3a55-40a7-9d4b-4f3f213ca05a	b5403e89-71c6-4a98-ae9a-8aa225be72bb	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.746739+00
ba6e0f78-baf2-4926-b22b-89e8e4f4981d	b5403e89-71c6-4a98-ae9a-8aa225be72bb	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Curious	2026-05-04 11:14:33.746739+00
b88afe45-88f0-4193-aee2-50dec080c559	b5403e89-71c6-4a98-ae9a-8aa225be72bb	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	5	2026-05-04 11:14:33.746739+00
8f1541b8-3d1d-42d3-9e51-99e1e2c8d0bf	b5403e89-71c6-4a98-ae9a-8aa225be72bb	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.746739+00
d2f9b53a-e210-423d-ac6d-134053c63210	b5403e89-71c6-4a98-ae9a-8aa225be72bb	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:33.746739+00
37a77b4a-e3d5-4856-83c3-acc3b089ebf5	b5403e89-71c6-4a98-ae9a-8aa225be72bb	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.746739+00
100add6d-e2b4-419a-b0ad-d780c1ceb28f	b5403e89-71c6-4a98-ae9a-8aa225be72bb	85d46e14-1258-44db-8c69-be4f7888de87	Love the patriotic feel of the campaign. Made in Nigeria, used across Africa.	\N	2026-05-04 11:14:33.746739+00
1976281c-155f-4f78-8f80-52194b329965	862825fc-bdde-41ba-8a71-c43dcae272d9	1104b704-0d13-437d-958c-1bcdac0858d0	\N	I've seen it but never used it	2026-05-04 11:14:33.755658+00
604adc29-1c99-43b0-9618-2dcb7bce3c19	862825fc-bdde-41ba-8a71-c43dcae272d9	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.755658+00
4d224da7-0594-485b-8c8d-185914d64c4f	862825fc-bdde-41ba-8a71-c43dcae272d9	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Inspired	2026-05-04 11:14:33.755658+00
b238b4b3-8a17-48cd-b236-c4b1b98d353a	862825fc-bdde-41ba-8a71-c43dcae272d9	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.755658+00
57fde1cb-1e58-4cfa-9fe0-0b2feb202cf4	862825fc-bdde-41ba-8a71-c43dcae272d9	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Slightly more positive	2026-05-04 11:14:33.755658+00
71948df4-5031-47a5-b8ef-5b3cf67f361c	862825fc-bdde-41ba-8a71-c43dcae272d9	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:33.755658+00
3690dcae-c7b7-441b-84bf-0ed8a8cbb2dc	862825fc-bdde-41ba-8a71-c43dcae272d9	c48e791f-c727-46ce-b872-cfe535262db6	\N	Very proud and supportive	2026-05-04 11:14:33.755658+00
14cd8171-e741-4543-917f-a9f3553e99b1	862825fc-bdde-41ba-8a71-c43dcae272d9	85d46e14-1258-44db-8c69-be4f7888de87	Love the patriotic feel of the campaign. Made in Nigeria, used across Africa.	\N	2026-05-04 11:14:33.755658+00
54ced3c4-1a77-4ffa-b1d0-c0d4deae8536	97826de9-5942-48db-a55e-190c0fdd6abd	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Never heard of it before	2026-05-04 11:14:33.764425+00
e4004625-3806-46cc-bccd-87ff95bd166b	97826de9-5942-48db-a55e-190c0fdd6abd	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.764425+00
bb7c97b0-89bb-4f83-9cc0-63ebb03fecee	97826de9-5942-48db-a55e-190c0fdd6abd	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Excited	2026-05-04 11:14:33.764425+00
4c3aa562-1294-4d8d-89ef-0949e10f8254	97826de9-5942-48db-a55e-190c0fdd6abd	553f5653-6e53-4e10-9b12-8f933df889fc	\N	4	2026-05-04 11:14:33.764425+00
ec218962-b38c-463d-a909-6d78940aa92f	97826de9-5942-48db-a55e-190c0fdd6abd	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.764425+00
dfe24781-0db0-46e6-a927-aca531fd1cf3	97826de9-5942-48db-a55e-190c0fdd6abd	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	None of the above	2026-05-04 11:14:33.764425+00
62a986e7-dbf2-4dcc-b37e-e0b204365c4a	97826de9-5942-48db-a55e-190c0fdd6abd	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Sceptical about quality	2026-05-04 11:14:33.764425+00
0e08139f-54f6-4e8a-8181-da44eceb73e6	97826de9-5942-48db-a55e-190c0fdd6abd	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote products are everywhere in Kano. Good to see the ad campaign.	\N	2026-05-04 11:14:33.764425+00
6555b71b-f244-4386-9f68-a9e026bf73b9	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	1104b704-0d13-437d-958c-1bcdac0858d0	\N	Very familiar – I use it regularly	2026-05-04 11:14:33.77307+00
9c20ed78-b69a-43a8-8b4e-e190ecac3923	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	e143a94c-4739-4e80-a6f9-e02e0e05938e	\N	5	2026-05-04 11:14:33.77307+00
5cb840a7-e352-4048-a759-5ec20e5833da	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	4b941580-6d06-4c52-926b-9a6cad7eb761	\N	Excited	2026-05-04 11:14:33.77307+00
00b571df-dcbe-411d-b781-315b1645fa45	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	df03dc38-9011-471a-9c14-e2f7e97d12e1	\N	4	2026-05-04 11:14:33.77307+00
25b97f2d-99f3-4579-8202-2d076d1080aa	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	\N	Much more positive	2026-05-04 11:14:33.77307+00
a08e1d3b-a85c-4d2b-a0c0-b7614f3ee1c1	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	36302c68-7999-4abb-a2f0-7d51f757801d	\N	Manufacturing / Industry	2026-05-04 11:14:33.77307+00
154f7355-1ff4-4cf2-87c4-2d3212e940a8	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	c48e791f-c727-46ce-b872-cfe535262db6	\N	Positive but cautious	2026-05-04 11:14:33.77307+00
fd497010-6f59-43ef-b686-a76655e73a46	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	85d46e14-1258-44db-8c69-be4f7888de87	The quality message came through clearly. Will buy again.	\N	2026-05-04 11:14:33.77307+00
7ac177e6-3c36-4eb2-b61f-ee11c75ad3ff	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	773f200e-2d4b-4bb8-bcf1-349141603877	\N	Somewhat familiar – I've heard of it	2026-05-04 11:14:33.781744+00
82bdc4a8-9d12-4d2e-bc21-536f11e3b904	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	5fab2044-c664-4ace-85f0-79099de6b4fa	\N	4	2026-05-04 11:14:33.781744+00
963b5d47-5bda-4b16-9b5b-86f82068bef3	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	37909205-6195-4f87-bdd3-e942e1fa38e2	\N	Unconvinced	2026-05-04 11:14:33.781744+00
1ff19c12-521a-4015-a51f-b0418371cc07	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	553f5653-6e53-4e10-9b12-8f933df889fc	\N	3	2026-05-04 11:14:33.781744+00
a89f9a89-4b77-4305-9261-ccab355e04b6	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	c7611a11-c94f-4fb3-9c1f-80b7817f078d	\N	No change	2026-05-04 11:14:33.781744+00
6ca40a52-4a79-4248-84eb-f0657d6762a5	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	159e18e5-f8d4-4e78-b771-05bdec42ca1b	\N	Manufacturing / Industry	2026-05-04 11:14:33.781744+00
6e32d9ed-4ca3-4467-b22a-bc384c7cbcce	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	85ba0f3b-7556-41a8-ba2e-73d121bc7f92	\N	Positive but cautious	2026-05-04 11:14:33.781744+00
27347f5e-713f-4f2b-9cf4-34ce6338c946	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	0ce0c6d6-8bf8-4eb6-a036-98cde250e436	Dangote products are everywhere in Kano. Good to see the ad campaign.	\N	2026-05-04 11:14:33.781744+00
\.


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brands (id, user_id, company_name, website, logo_url, created_at) FROM stdin;
63af4274-2b9a-4ed2-92df-ddbed5395ada	fe6047ce-7709-4778-bdde-40dd92a18dba	MTN Nigeria	\N	\N	2026-05-02 18:55:37.21956+00
5f273b8f-210e-4d9a-af9f-c302b1367dc3	a88502c0-1135-4146-b87a-1405e5093171	Airtel Nigeria	\N	\N	2026-05-02 18:55:37.22627+00
3f95955a-57a4-45fe-8a09-deab8e230f74	ae9b9099-8d0f-4303-8ee8-3bb6151e6a04	Guinness Nigeria	\N	\N	2026-05-02 18:55:37.23057+00
c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	Dangote Group	\N	\N	2026-05-02 18:55:37.234783+00
f295cb46-da6d-4c73-890f-28732facfc5c	d500cde9-eaca-4d95-86c1-f2ef11058887	Jumia Nigeria	\N	\N	2026-05-02 18:55:37.23899+00
ded94e43-a1ad-4b31-9fa2-326755a569b6	907f1369-c234-415b-a698-a6eae4c4c186	GTBank Nigeria	\N	\N	2026-05-02 18:55:37.242255+00
44b3ebb7-d738-467c-ba8a-623f842434da	0b4d81ce-b952-4b2b-9da6-08d82268274b	Indomie Nigeria	\N	\N	2026-05-02 18:55:37.249233+00
c406889a-f7e1-4d3c-b77e-1e0a523fd197	b20140d7-cb29-4d13-897d-806e3992c88f	Peak Milk Nigeria	\N	\N	2026-05-02 18:55:37.255547+00
c3a88881-2115-4124-938b-232c6a8f87d1	b5f0aa75-6efb-4d7c-9ff9-0a8449977f7c	Flutterwave	\N	\N	2026-05-02 18:55:37.264067+00
e04c892f-a6b5-4f72-bd49-b122b3e72830	1b5c5409-c401-444a-84c0-f7e0757348d0	Paystack	\N	\N	2026-05-02 18:55:37.271048+00
312ed543-8d8e-4723-84d0-8fcfb7ed1202	fe6047ce-7709-4778-bdde-40dd92a18dba	MTN Nigeria	https://mtn.com.ng	\N	2026-05-02 19:36:14.780995+00
f7ea304c-1872-4175-9c31-805c914fbee4	907f1369-c234-415b-a698-a6eae4c4c186	GTBank Nigeria	https://gtbank.com	\N	2026-05-02 19:36:14.795905+00
b7a7a82e-1708-4a43-aa7b-bf5041dce59c	b5f0aa75-6efb-4d7c-9ff9-0a8449977f7c	Flutterwave	https://flutterwave.com	\N	2026-05-02 19:36:14.801702+00
d05972bd-1393-4989-80df-bff25b6f1c59	1b5c5409-c401-444a-84c0-f7e0757348d0	Paystack	https://paystack.com	\N	2026-05-02 19:36:14.807271+00
bac47cba-612b-4b7e-97e9-f04a2b748eec	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	Dangote Group	https://dangote.com	\N	2026-05-02 19:36:14.811552+00
bd0944f8-6018-455d-9a2f-2c2f2ab8365e	d500cde9-eaca-4d95-86c1-f2ef11058887	Jumia Nigeria	https://jumia.com.ng	\N	2026-05-02 19:36:14.816022+00
cfdc1b59-629c-4282-bd88-209329bd4f4a	a88502c0-1135-4146-b87a-1405e5093171	Airtel Nigeria	https://ng.airtel.com	\N	2026-05-02 19:36:14.820019+00
58627dff-9e81-4632-90cb-b37788c55619	ae9b9099-8d0f-4303-8ee8-3bb6151e6a04	Guinness Nigeria	https://guinness.com	\N	2026-05-02 19:36:14.825547+00
069547fa-dc30-475d-8bfa-4c6bb84c0e3c	0b4d81ce-b952-4b2b-9da6-08d82268274b	Indomie Nigeria	https://indomie.com.ng	\N	2026-05-02 19:36:14.830644+00
516eb21b-10df-431c-a50d-8ed4e205d7b4	b20140d7-cb29-4d13-897d-806e3992c88f	Peak Milk (FrieslandCampina)	https://peakmilk.com.ng	\N	2026-05-02 19:36:14.834438+00
48f99ead-04ea-49cf-bb7f-0984e88f3033	14e57746-0fc0-4a07-971b-a422e57d2b7a	SafeBoda Nigeria	https://safeboda.com	\N	2026-05-02 19:36:14.838578+00
1b219fea-675b-4899-8c84-f5ee92ba2930	43079cf5-db3f-4f58-b30e-c2205aa0444e	Club Beer (Nigerian Breweries)	https://nbplc.com	\N	2026-05-02 19:36:14.843302+00
ff3e91ac-99b1-49c3-9543-fdc1c20daa19	65f4f8a1-c065-44f4-8662-3205d557b004	Legend Extra Stout	https://nbplc.com	\N	2026-05-02 19:36:14.849497+00
209fa0e0-3261-40b7-b63e-889bcaca0e90	61abef6b-4917-4d0a-a6d0-5f50137a6a71	Acme Corp	https://acme.demo	\N	2026-05-02 19:36:14.854013+00
1242dfdc-b760-4f83-a381-5b2b25468e91	4fd1f0dc-bb89-4897-8ee8-e4eb98e26cdd	TechWave	https://techwave.demo	\N	2026-05-02 19:36:14.859388+00
65a1f033-9d57-4eb0-a491-84faab3796e0	105ea61a-fa47-47f5-a7bf-f576b41b75b8	Test Corp	\N	\N	2026-05-02 21:00:02.800231+00
b76ae32f-4539-4fa7-813f-9d4e94c760e0	135d7699-6e7b-4a84-8b38-3c1ac65a1340	Test Corp	\N	\N	2026-05-02 21:04:06.865394+00
66b9a100-eef0-46fb-8c9e-b03f7b38158e	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	brand453070	\N	\N	2026-05-02 21:15:03.880518+00
03163ac7-5f6e-4428-9b08-9e7d523710f4	fe6047ce-7709-4778-bdde-40dd92a18dba	MTN Nigeria	https://mtn.com.ng	\N	2026-05-03 13:53:36.829973+00
0e47cc6b-8690-402a-b545-52aa90981f45	907f1369-c234-415b-a698-a6eae4c4c186	GTBank Nigeria	https://gtbank.com	\N	2026-05-03 13:53:36.870149+00
a05c8d2c-b7ae-483c-9979-24d6cca2d195	b5f0aa75-6efb-4d7c-9ff9-0a8449977f7c	Flutterwave	https://flutterwave.com	\N	2026-05-03 13:53:36.876002+00
05dea71d-59c6-465d-89e5-e17c6d675e22	1b5c5409-c401-444a-84c0-f7e0757348d0	Paystack	https://paystack.com	\N	2026-05-03 13:53:36.881351+00
6f6a202c-c65e-4140-bc4e-7213d3b327a9	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	Dangote Group	https://dangote.com	\N	2026-05-03 13:53:36.886151+00
f6fb3dc0-9b76-4e8a-a230-b0e1fa8fac1e	d500cde9-eaca-4d95-86c1-f2ef11058887	Jumia Nigeria	https://jumia.com.ng	\N	2026-05-03 13:53:36.891066+00
0abae6af-3d08-4a8b-a4e5-83105c8847b9	a88502c0-1135-4146-b87a-1405e5093171	Airtel Nigeria	https://ng.airtel.com	\N	2026-05-03 13:53:36.8961+00
f8e1613b-4d45-4ad1-b5f7-2df97484bc88	ae9b9099-8d0f-4303-8ee8-3bb6151e6a04	Guinness Nigeria	https://guinness.com	\N	2026-05-03 13:53:36.900998+00
7cef1a65-6a45-4a05-b83d-28e79b40de6f	0b4d81ce-b952-4b2b-9da6-08d82268274b	Indomie Nigeria	https://indomie.com.ng	\N	2026-05-03 13:53:36.905333+00
2bf12706-d42a-4c14-93d2-6f7a9000e902	b20140d7-cb29-4d13-897d-806e3992c88f	Peak Milk (FrieslandCampina)	https://peakmilk.com.ng	\N	2026-05-03 13:53:36.910746+00
52e929f8-c011-4b30-b5fc-48c770418e5e	14e57746-0fc0-4a07-971b-a422e57d2b7a	SafeBoda Nigeria	https://safeboda.com	\N	2026-05-03 13:53:36.915057+00
2b54fdb2-9ffd-45ae-8ed4-f7f2729656eb	43079cf5-db3f-4f58-b30e-c2205aa0444e	Club Beer (Nigerian Breweries)	https://nbplc.com	\N	2026-05-03 13:53:36.919831+00
a6b5a0b8-f234-480b-8af4-fd63076ce108	65f4f8a1-c065-44f4-8662-3205d557b004	Legend Extra Stout	https://nbplc.com	\N	2026-05-03 13:53:36.924439+00
4819885c-27ad-419f-bf94-ceea6e8457c8	61abef6b-4917-4d0a-a6d0-5f50137a6a71	Acme Corp	https://acme.demo	\N	2026-05-03 13:53:36.929388+00
265e2dba-04c8-4fba-9879-544684072c3e	4fd1f0dc-bb89-4897-8ee8-e4eb98e26cdd	TechWave	https://techwave.demo	\N	2026-05-03 13:53:36.934355+00
\.


--
-- Data for Name: events_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_log (id, event_type, actor_id, entity_type, entity_id, metadata, created_at) FROM stdin;
9fb82770-f6cc-4bfc-90b0-420c307c8038	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	6c9d6eff-fd26-4581-bc7e-eababed61a21	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "pointsAwarded": 15}	2026-05-02 17:37:57.874399+00
8faa05af-4cd9-4de9-b207-ccceae932ba0	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	73805821-b677-4b5d-9414-8c63653ad83b	{"adId": "72d0b61e-bdfa-4110-9050-0155d2463ed7", "pointsAwarded": 20}	2026-05-02 17:37:57.882427+00
de6358cb-fb84-44eb-ac15-1e6e4d1ef734	review_submitted	1c1ba66f-1c47-43b9-b3c6-d314426eb145	review_session	d2b715b0-8b31-4d46-b843-648292c2610f	{"adId": "72d0b61e-bdfa-4110-9050-0155d2463ed7", "pointsAwarded": 20}	2026-05-02 17:37:57.890059+00
d6d505c7-a891-4629-abca-c46a04dfd96b	review_submitted	e89a4458-7ea7-41d9-bb3c-fce388d89786	review_session	c738c298-8a6b-48c2-861f-368b9e8e29a6	{"adId": "14d52d62-329d-4eb9-af5d-03e46fe9a347", "pointsAwarded": 25}	2026-05-02 17:37:57.899739+00
31a80a75-8c62-42ae-9f57-da8ae04a94a6	review_submitted	e89a4458-7ea7-41d9-bb3c-fce388d89786	review_session	d1543b06-d2d7-4bd4-9755-efa7c5366530	{"adId": "30717d98-bed3-4121-8897-01e48eac8a41", "pointsAwarded": 30}	2026-05-02 17:37:57.907727+00
46d50754-63aa-4500-b580-82678b4760d6	review_submitted	e89a4458-7ea7-41d9-bb3c-fce388d89786	review_session	f783a787-0a0e-46bd-8234-4182abed09f6	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "pointsAwarded": 40}	2026-05-02 17:37:57.916+00
45b8773a-a9db-41da-8638-f9deefb0486d	review_submitted	6902ee2a-e1dc-4185-badf-9c0d01e2711e	review_session	81af4e6e-242c-4ca5-9aef-3a5c61750222	{"adId": "30717d98-bed3-4121-8897-01e48eac8a41", "pointsAwarded": 30}	2026-05-02 17:37:57.925346+00
df1d2c41-01ea-4393-8af3-ec06f3cc4d25	review_submitted	b01b170f-5d12-448a-bab4-1aae4c19007d	review_session	6182c375-fda3-4ac6-ba77-1a456914a714	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "pointsAwarded": 40}	2026-05-02 17:37:57.933322+00
29e6484a-5aee-45f9-b99e-23e802f2b500	review_submitted	0bdfe30f-eb98-4a61-8aee-873a46e3bf40	review_session	d57fe98d-e238-4dab-9bf5-99772fb75a3b	{"adId": "72d0b61e-bdfa-4110-9050-0155d2463ed7", "pointsAwarded": 12}	2026-05-02 17:37:57.942552+00
a72d9ab4-61ee-4149-8314-b614ebce4852	review_submitted	0bdfe30f-eb98-4a61-8aee-873a46e3bf40	review_session	fd1b917d-ece5-4ac5-95ec-46e9f592dc93	{"adId": "14d52d62-329d-4eb9-af5d-03e46fe9a347", "pointsAwarded": 18}	2026-05-02 17:37:57.95722+00
38bb1c35-e535-441a-b7df-ea0993937b96	review_submitted	0bdfe30f-eb98-4a61-8aee-873a46e3bf40	review_session	1b8e7dbd-0a46-4d18-b81b-5a0d7a2999bd	{"adId": "30717d98-bed3-4121-8897-01e48eac8a41", "pointsAwarded": 22}	2026-05-02 17:37:57.965969+00
ef0e94ca-f665-4059-84c1-0b7418f27e3f	review_submitted	ef469f0d-6242-4385-9125-a99beb8c6cd1	review_session	e22f2c34-a481-400d-8209-1e454772cb36	{"adId": "14d52d62-329d-4eb9-af5d-03e46fe9a347", "pointsAwarded": 18}	2026-05-02 17:37:57.976036+00
7ee009c7-b59c-412f-b664-5725d69e12b1	review_submitted	ff53cafa-c092-4b35-bf55-8b03054f62e7	review_session	ca1790cf-4f03-44a6-a2f3-69d4a47d517e	{"adId": "30717d98-bed3-4121-8897-01e48eac8a41", "pointsAwarded": 22}	2026-05-02 17:37:57.983649+00
e1090f6d-e005-4373-902b-5c7dcadda07d	review_submitted	ff53cafa-c092-4b35-bf55-8b03054f62e7	review_session	5b3ba3a7-a287-42e1-9a84-63cd6fc125f8	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "pointsAwarded": 28}	2026-05-02 17:37:57.991553+00
c4bd1cf1-8083-4b6e-874a-16157f1ed861	review_submitted	ff53cafa-c092-4b35-bf55-8b03054f62e7	review_session	ac113119-98b8-485d-9907-3e1f78efb5ec	{"adId": "72d0b61e-bdfa-4110-9050-0155d2463ed7", "pointsAwarded": 35}	2026-05-02 17:37:58.00412+00
4c280555-facb-4e63-97ee-a7f33d9ec750	review_submitted	196ede38-71c7-4ad7-bee5-d3dfbd43a752	review_session	b41f77f4-d1b8-46c5-b0c4-174408e54b85	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "pointsAwarded": 28}	2026-05-02 17:37:58.013807+00
ad503fca-dcd6-42ed-a485-c334a25a7991	review_submitted	196ede38-71c7-4ad7-bee5-d3dfbd43a752	review_session	ff160ad8-5e28-4e5a-8100-4a6ee2ea4f9d	{"adId": "72d0b61e-bdfa-4110-9050-0155d2463ed7", "pointsAwarded": 35}	2026-05-02 17:37:58.024545+00
cfc88829-8e23-4e88-a264-01df52107398	review_submitted	ab994e97-fe94-48ea-8e4d-cd937f113249	review_session	0dfe7338-9fbe-4d54-89fa-3f527899c88d	{"adId": "72d0b61e-bdfa-4110-9050-0155d2463ed7", "pointsAwarded": 35}	2026-05-02 17:37:58.033967+00
b41294e8-4118-4fd0-b091-92289abb5e8b	user_register	741fbf4b-afda-422f-a134-b5c51dd972f4	user	741fbf4b-afda-422f-a134-b5c51dd972f4	{"role": "reviewer", "email": "test@test.com"}	2026-05-02 17:38:12.10181+00
5ab278c8-4b93-4673-9179-205ebfa36b50	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:38:25.102041+00
f66bfb4f-3a17-4400-98ed-d77873eba620	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:38:37.839793+00
c19c0d00-445e-4e0f-94bc-3ee791cb9cb0	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	a62cce75-d475-4005-b40d-6b03ec27db5d	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6"}	2026-05-02 17:38:38.519978+00
1f2e92c2-69eb-4142-a244-d68786df7dd4	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	a62cce75-d475-4005-b40d-6b03ec27db5d	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "answerCount": 5}	2026-05-02 17:38:38.902946+00
88c337ba-5d5f-4f1c-bafa-9e63222cdcd6	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	a62cce75-d475-4005-b40d-6b03ec27db5d	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "watchSeconds": 20, "pointsAwarded": 15}	2026-05-02 17:38:38.912935+00
60a77ded-bb91-45dc-a304-5b916c6dae7c	points_awarded	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"amount": 15, "source": "review", "referenceId": "a62cce75-d475-4005-b40d-6b03ec27db5d"}	2026-05-02 17:38:38.915216+00
e669d759-6d2a-480c-8eac-c3647afdb82f	user_login	61abef6b-4917-4d0a-a6d0-5f50137a6a71	user	61abef6b-4917-4d0a-a6d0-5f50137a6a71	{"role": "brand"}	2026-05-02 17:38:52.88449+00
d562a4ea-1771-4821-b157-404317b7a29d	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:38:56.108783+00
646bc21a-6eb4-49dd-a6b0-286b18068fdf	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:46:03.413293+00
8027e3c4-ec93-466a-b7e9-06560f545ff6	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	97e4d68a-a9b6-4589-8286-b0b51b8825d4	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6"}	2026-05-02 17:46:06.979027+00
5f652e26-dc50-46e5-a257-abbe8cb54023	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:46:45.675383+00
91ece61b-33ce-4695-9b38-4f0071e114cb	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d400bcfc-fdd9-42c1-9c0a-233fa21607e3	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6"}	2026-05-02 17:46:46.53814+00
9c33f13d-3ffd-4fff-b6e4-79ed2a1f718c	ad_view_complete	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d400bcfc-fdd9-42c1-9c0a-233fa21607e3	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "watchSeconds": 20}	2026-05-02 17:46:47.453812+00
a0315fa1-8dd5-43ed-9846-4a74cb4d3280	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d400bcfc-fdd9-42c1-9c0a-233fa21607e3	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "answerCount": 5, "watchSeconds": 20, "pointsAwarded": 15}	2026-05-02 17:46:47.458607+00
60869aea-5cd7-48b6-9242-eb0af5e70eab	points_awarded	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"amount": 15, "source": "review", "referenceId": "d400bcfc-fdd9-42c1-9c0a-233fa21607e3"}	2026-05-02 17:46:47.465879+00
9937671e-7c08-4d88-be2d-548709d273d8	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:46:49.601684+00
b382f64e-3abf-445b-afe4-bbae2257cba5	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:53:55.44851+00
ec4d8c60-136f-47d0-98e2-261a1311d495	user_register	98abd0b2-a97c-40b9-a1dc-03142d6eea61	user	98abd0b2-a97c-40b9-a1dc-03142d6eea61	{"role": "brand", "email": "newbrand@test.com"}	2026-05-02 17:53:56.007176+00
db0dee6e-da03-41b5-8f2a-480a41c6996c	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:53:57.353001+00
2c53154d-16c5-42d3-99a7-1ef7cdd042f4	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:54:03.214754+00
eb28f2a4-995b-4273-aa7e-096d1de05aa1	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:54:04.198148+00
92223ce7-8bdf-4d0d-a381-7dafe161c0bd	leaderboard_updated	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 17:54:04.33207+00
d1463fe1-68ee-4c7c-9ec9-0c0eff3ab62f	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:55:44.17856+00
6dfb39e8-4182-4934-b6e7-0a34b3a7ba04	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:55:44.641437+00
75e299c2-d9e2-43dd-8d76-9762523cfed7	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:55:58.231003+00
36773fc6-c888-4f9e-8419-12bcabbc2c77	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:55:58.596208+00
404140dc-a462-4648-b785-479eac5e6905	user_login	61abef6b-4917-4d0a-a6d0-5f50137a6a71	user	61abef6b-4917-4d0a-a6d0-5f50137a6a71	{"role": "brand"}	2026-05-02 17:55:58.960019+00
bdd34252-6de2-4c17-94a8-584e4617dc41	user_register	9c9b308b-e68b-44f6-80c4-8d52adc0e97d	user	9c9b308b-e68b-44f6-80c4-8d52adc0e97d	{"role": "brand", "email": "testbrand2@example.com"}	2026-05-02 17:55:59.646221+00
6290f13e-ad84-467b-8c1e-29fccda44662	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:56:21.367116+00
39c01a05-1c8a-434c-a900-f965f8883c43	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:56:21.784918+00
f22df997-7607-4fe9-be22-1e968a2d2065	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6"}	2026-05-02 17:56:22.880207+00
bfc746ad-2b7d-46a0-b148-0c72b3d82cb7	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "8e0ad065-1283-4b12-ae9e-2dde3274530e", "answerValue": "3"}	2026-05-02 17:56:23.520543+00
841967a6-3b82-4cce-8dce-f1b0adddbc8a	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "c2b78a4f-27b4-4c0b-b498-d36244720e36", "answerValue": "3"}	2026-05-02 17:56:23.520543+00
8614ed34-2f3f-4964-9d65-b1175dae84b0	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "da0e6f70-07c6-4ada-8511-a42883b6d83f", "answerValue": "3"}	2026-05-02 17:56:23.520543+00
bca77708-d10e-4ca1-8b66-ccd87d186b05	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "326637bc-0419-4e60-8876-ae39164170d3", "answerValue": "3"}	2026-05-02 17:56:23.520543+00
af624607-f107-45b9-b85f-195cf3fae1b8	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "a171ccea-0d71-4cbe-bf3e-5bc330ef81b8", "answerValue": "3"}	2026-05-02 17:56:23.520543+00
8b8d5637-a0c1-4a58-97b8-dca52bc7b8e4	ad_view_complete	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "watchSeconds": 20}	2026-05-02 17:56:23.520543+00
d1890e96-278a-4f29-b053-f2ecb41f6704	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "answerCount": 5, "watchSeconds": 20, "pointsAwarded": 15}	2026-05-02 17:56:23.520543+00
5f371f77-6b79-4719-ae8b-055a5b8ee172	points_awarded	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"amount": 15, "source": "review", "referenceId": "d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2"}	2026-05-02 17:56:23.520543+00
8990f5c3-ad7b-4ca8-a12a-0799d5f41cee	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:56:35.761909+00
6a18db91-0939-4549-b37a-3d9d1deb6ac1	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:56:36.140801+00
c5512d1b-8fb8-483a-a322-0994f5757552	leaderboard_updated	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 17:56:36.592883+00
e46410d9-1c00-4d5a-97d7-f0c1040347de	leaderboard_updated	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"action": "events_export", "filters": {}}	2026-05-02 17:56:36.8321+00
6a99de61-fe3e-4c88-ac6c-5a52bc32e832	user_register	06a1e7e1-ac24-4ca5-8740-24a2c1a71378	user	06a1e7e1-ac24-4ca5-8740-24a2c1a71378	{"role": "brand", "email": "newbrand99@test.com"}	2026-05-02 17:56:37.493856+00
e467e2f8-b5b0-4d5c-8aac-eb83a22d28a5	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 17:58:05.183482+00
82453c1c-c924-4869-9fa2-8faf508d786f	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 17:58:05.593941+00
2bdda257-7816-4348-96aa-aaf43d3d5dbb	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6"}	2026-05-02 17:58:06.19201+00
03d33658-5f4f-42b8-a071-13643135d2ed	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "8e0ad065-1283-4b12-ae9e-2dde3274530e", "answerValue": "3"}	2026-05-02 17:58:06.434819+00
04eefba6-0035-4a37-9fa3-c1634f89fdf2	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "c2b78a4f-27b4-4c0b-b498-d36244720e36", "answerValue": "3"}	2026-05-02 17:58:06.434819+00
f26a9e42-74c7-4063-8048-e809a5951be5	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "da0e6f70-07c6-4ada-8511-a42883b6d83f", "answerValue": "3"}	2026-05-02 17:58:06.434819+00
a077de42-0390-4be1-84dc-45c6a58c5a40	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "326637bc-0419-4e60-8876-ae39164170d3", "answerValue": "3"}	2026-05-02 17:58:06.434819+00
e477038c-a5a2-4bf3-9186-63ea0f04dfea	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "a171ccea-0d71-4cbe-bf3e-5bc330ef81b8", "answerValue": "3"}	2026-05-02 17:58:06.434819+00
937bcce8-3446-44a7-8eb2-a59987e2e4f6	ad_view_complete	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "watchSeconds": 20}	2026-05-02 17:58:06.434819+00
bb2d502f-5cf0-4cb1-9447-72d3a8363c69	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	1e462776-dd9a-4176-ac53-db54bd91ad8a	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "answerCount": 5, "watchSeconds": 20, "pointsAwarded": 15}	2026-05-02 17:58:06.434819+00
07b9d7c6-7336-47bb-a530-d4f68bf9382e	points_awarded	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"amount": 15, "source": "review", "referenceId": "1e462776-dd9a-4176-ac53-db54bd91ad8a"}	2026-05-02 17:58:06.434819+00
ac2ded87-643c-4347-a5dc-c754ee3e6480	leaderboard_updated	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 17:58:06.980242+00
973c4277-2100-491a-aeb9-e603275e3867	leaderboard_updated	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"action": "events_export", "filters": {}}	2026-05-02 17:58:07.217223+00
11fda9a2-b981-41f2-9be3-6591f5592604	user_register	572284ed-7fb3-4f13-8c43-24976496bdc4	user	572284ed-7fb3-4f13-8c43-24976496bdc4	{"role": "brand", "email": "brandx99@test.com"}	2026-05-02 17:58:07.977812+00
d4aa548b-a88f-49e1-893a-f8c22eacced8	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 18:03:16.438548+00
cf171b95-5037-455f-abb3-0d563dc9c685	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 18:03:16.823483+00
35064ac3-3fd2-49c5-9637-d390add04368	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6"}	2026-05-02 18:03:17.435661+00
43229f54-d5c7-4948-9c80-945eaaace75b	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "8e0ad065-1283-4b12-ae9e-2dde3274530e", "answerValue": "3"}	2026-05-02 18:03:17.701159+00
edfa7b0d-9758-4ff7-b2f0-eb76da10412e	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "c2b78a4f-27b4-4c0b-b498-d36244720e36", "answerValue": "3"}	2026-05-02 18:03:17.701159+00
906ee590-056b-43f3-82dc-495dc6e8b9af	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "da0e6f70-07c6-4ada-8511-a42883b6d83f", "answerValue": "3"}	2026-05-02 18:03:17.701159+00
b693c3be-ce78-4c5b-90ae-6d512d6cafc6	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "326637bc-0419-4e60-8876-ae39164170d3", "answerValue": "3"}	2026-05-02 18:03:17.701159+00
eae9387e-f2be-497e-9902-24701c2cc742	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "a171ccea-0d71-4cbe-bf3e-5bc330ef81b8", "answerValue": "3"}	2026-05-02 18:03:17.701159+00
c7e70808-b758-4058-a260-95866f34ed35	ad_view_complete	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "watchSeconds": 20}	2026-05-02 18:03:17.701159+00
00765d11-94dc-4e7a-841e-5c288eb69033	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	58821e3b-c352-436f-9f33-9438dcaee2c2	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "answerCount": 5, "watchSeconds": 20, "pointsAwarded": 15}	2026-05-02 18:03:17.701159+00
e834c5f8-299e-485e-b4e0-e53574c40dc0	points_awarded	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"amount": 15, "source": "review", "referenceId": "58821e3b-c352-436f-9f33-9438dcaee2c2"}	2026-05-02 18:03:17.701159+00
19e1d1fc-2bec-4f43-800d-e9c7f47fe10f	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 18:03:18.478842+00
90f3c345-ed24-4552-9ca7-4cb9a2776e8e	leaderboard_updated	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"action": "events_export", "filters": {}}	2026-05-02 18:03:18.736307+00
04c34078-e836-448a-bfe2-30bf318df3ff	user_register	1380e418-cbad-4825-acbf-4bdb91bf1c5f	user	1380e418-cbad-4825-acbf-4bdb91bf1c5f	{"role": "brand", "email": "brandz100@test.com"}	2026-05-02 18:03:19.465086+00
6af72923-e648-4098-b02b-4088337142f3	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 18:08:29.222827+00
6b4d96fc-d4fc-42ca-a1bd-f62d936f2342	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 18:08:29.643978+00
6e3b2cbb-7926-45ee-8c3e-c89848be10ba	user_login	61abef6b-4917-4d0a-a6d0-5f50137a6a71	user	61abef6b-4917-4d0a-a6d0-5f50137a6a71	{"role": "brand"}	2026-05-02 18:08:30.036069+00
6c82013d-4567-4536-95f6-6318973ad905	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 3, "total": 4, "offset": 0}	2026-05-02 18:08:30.176475+00
0407be8a-172c-4435-b0c0-83c8aa010eee	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 1, "total": 4, "offset": 0}	2026-05-02 18:08:30.455653+00
3c55622c-3688-4c86-b27a-8858484daf1d	ad_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad	33e06c54-8275-40a4-bb24-150b5718d6c6	{"title": "Acme Widget Pro — Summer Launch"}	2026-05-02 18:08:30.614428+00
c59d9ec8-b476-4077-afee-df3d85b1ac02	profile_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 18:08:30.733494+00
e7f60e7e-f3ed-4bbe-9683-7d07f46b3d75	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 110}	2026-05-02 18:08:30.866053+00
61115913-edd4-442c-b72c-9e239075faca	points_ledger_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"limit": 3, "total": 7, "offset": 0}	2026-05-02 18:08:31.001855+00
fe9c4ea5-818d-4990-868d-aa50af946cb2	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6"}	2026-05-02 18:08:31.126953+00
9dfa2838-9781-4d00-9bb4-c678b2a9ccd7	ad_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad	33e06c54-8275-40a4-bb24-150b5718d6c6	{"title": "Acme Widget Pro — Summer Launch"}	2026-05-02 18:08:31.247035+00
0c751abb-394f-4dbb-9d95-e1dcf1e9d247	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "8e0ad065-1283-4b12-ae9e-2dde3274530e", "answerValue": "3"}	2026-05-02 18:08:31.372812+00
49cfd92a-bea4-4ae0-92b3-1d3c38e7542c	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "c2b78a4f-27b4-4c0b-b498-d36244720e36", "answerValue": "3"}	2026-05-02 18:08:31.372812+00
13c68491-7969-4fdf-8f3b-0e8bbd95e871	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "da0e6f70-07c6-4ada-8511-a42883b6d83f", "answerValue": "3"}	2026-05-02 18:08:31.372812+00
417b4dfa-07eb-4f55-98df-e8ae6b8c18b8	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "326637bc-0419-4e60-8876-ae39164170d3", "answerValue": "3"}	2026-05-02 18:08:31.372812+00
34f4941f-83c1-4498-8fd4-05d503b3862c	question_answered	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "questionId": "a171ccea-0d71-4cbe-bf3e-5bc330ef81b8", "answerValue": "3"}	2026-05-02 18:08:31.372812+00
be166cda-040d-4577-9516-917f7f9f46b4	ad_view_complete	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "watchSeconds": 20}	2026-05-02 18:08:31.372812+00
b0cef649-9e60-4b12-ad10-5019e29a6cb5	review_submitted	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	b80003c2-2656-4bbc-812f-bd144dcd6821	{"adId": "33e06c54-8275-40a4-bb24-150b5718d6c6", "answerCount": 5, "watchSeconds": 20, "pointsAwarded": 15}	2026-05-02 18:08:31.372812+00
bdb40bab-812e-4b58-bcb7-16ea09aa1161	points_awarded	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"amount": 15, "source": "review", "referenceId": "b80003c2-2656-4bbc-812f-bd144dcd6821"}	2026-05-02 18:08:31.372812+00
8d1d2b94-d219-439e-888a-7e26e6093565	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 18:08:44.927506+00
103787b1-9351-4a2d-ac05-27ee67ec52b2	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 18:08:45.353549+00
39bd8486-38f6-437a-94eb-7fdd7f242732	user_login	61abef6b-4917-4d0a-a6d0-5f50137a6a71	user	61abef6b-4917-4d0a-a6d0-5f50137a6a71	{"role": "brand"}	2026-05-02 18:08:45.746435+00
7604e3c9-5ccc-438a-9960-0ebee5394ba5	brand_ads_viewed	61abef6b-4917-4d0a-a6d0-5f50137a6a71	brand	dee85837-6a1c-47a8-9b25-8cc85015ec56	{"adCount": 3}	2026-05-02 18:08:45.833115+00
6bb28a3d-cb8d-4128-bd89-90508048931f	brand_stats_viewed	61abef6b-4917-4d0a-a6d0-5f50137a6a71	brand	dee85837-6a1c-47a8-9b25-8cc85015ec56	{"totalAds": 3, "activeAds": 2}	2026-05-02 18:08:45.947677+00
8631ec59-2def-4167-9255-c0fe213f7ee4	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 115, "filters": {}}	2026-05-02 18:08:46.073193+00
c1f18a4d-4b56-429a-b80e-369c20f8ddff	admin_ads_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 5, "filters": {}}	2026-05-02 18:08:46.341539+00
41f72739-3b96-4732-81cf-de27c2553799	admin_users_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 19, "filters": {}}	2026-05-02 18:08:46.462221+00
01baa123-672d-4772-b5cb-2b3a3744e5e4	admin_events_exported	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"filters": {}, "rowsExported": 500}	2026-05-02 18:08:46.582386+00
30ef1dab-1699-4821-9fa4-11a1cfa7bf29	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 18:08:46.661667+00
5dce15a4-e399-4a7f-97dc-4f155b20d397	leaderboard_history_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weeksReturned": 2, "weeksRequested": 2}	2026-05-02 18:08:46.805379+00
e6658c86-a2a3-479d-b653-db89b551c431	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 121, "filters": {}}	2026-05-02 18:08:47.952816+00
c95c050a-3db2-4ccd-b829-e06afb19e585	user_register	6c240835-a66f-4aa5-a782-2f3343334a73	user	6c240835-a66f-4aa5-a782-2f3343334a73	{"role": "brand", "email": "brandz202@test.com"}	2026-05-02 18:08:48.406377+00
b3216158-a393-4fd7-8bf2-f567ae2e5969	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 18:11:59.095582+00
a3053bac-9cb4-4476-aae2-570496740a5b	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 18:11:59.595742+00
894feb0f-a013-47d6-9856-57f096c7a160	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 18:11:59.719722+00
8701cfce-fd07-48d3-b44c-67cee32204aa	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 18:11:59.719942+00
d4042eb3-f749-41c6-8359-74d25860b410	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 7, "filters": {"eventType": "leaderboard_updated"}}	2026-05-02 18:12:00.845949+00
779407ae-ff9d-4fca-9198-206ab0697c14	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 128, "filters": {}}	2026-05-02 18:12:00.970514+00
60e9012c-5ca5-4d4c-9a37-62b4e3602ddb	user_register	4550cf82-811c-45ae-805b-24ecda62029d	user	4550cf82-811c-45ae-805b-24ecda62029d	{"role": "reviewer", "email": "testreviewer99@test.com"}	2026-05-02 18:34:08.955537+00
dc81e3dd-3300-44c7-835e-8d67cbdfa2eb	user_login	4550cf82-811c-45ae-805b-24ecda62029d	user	4550cf82-811c-45ae-805b-24ecda62029d	{"role": "reviewer"}	2026-05-02 18:34:09.402829+00
2fc6042f-8c04-4888-babb-7a458104b3bf	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 18:34:41.892138+00
a3536afc-477a-4ea5-a408-3cbeeba26e46	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 18:38:19.547834+00
3f360708-38a1-42bc-8fcc-8829d191e3c1	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-02 18:39:36.828162+00
3a9893c0-aa0d-4b4b-8773-50f0b987c8f6	admin_events_queried	\N	platform_settings	\N	{"action": "get_settings"}	2026-05-02 18:39:36.899914+00
24b52010-8c86-4952-89c6-6e7cde15efef	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 135, "filters": {}}	2026-05-02 18:39:36.934876+00
2cfba1a0-af30-4610-a0ec-42dff57cbd70	admin_ads_queried	\N	ad_packages	\N	{"action": "list_packages"}	2026-05-02 18:39:36.935142+00
f69c9ef2-e693-462c-a19f-db8f783aa53e	admin_ads_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 25, "filters": {}}	2026-05-02 18:39:36.952756+00
2d6c2722-70fc-4b34-a7ed-1cc54958e8d0	admin_users_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 25, "filters": {}}	2026-05-02 18:39:36.956557+00
4424d221-363b-44fc-8079-9b609494871d	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-02 18:40:28.514831+00
cf687e69-8abb-417e-b985-614d2393a4a2	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-02 18:40:28.635442+00
52e135a3-6fd9-423b-bb87-94dc606039db	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 18:40:28.662765+00
51b72fc1-1345-41c2-8fef-ecbbdfb98b29	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-02 18:40:28.682386+00
6ca99598-57ff-484e-8076-8f97981c358d	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 24, "offset": 0}	2026-05-02 18:40:28.802939+00
360b7987-eb2f-41dc-9e0b-14a46dd949d7	user_login	96ad3008-f19a-4450-acb8-536cb371e4a5	user	96ad3008-f19a-4450-acb8-536cb371e4a5	{"role": "super_admin"}	2026-05-02 19:47:18.924747+00
1ce6d717-67f8-4d59-85e5-a977387e56e9	user_register	105ea61a-fa47-47f5-a7bf-f576b41b75b8	user	105ea61a-fa47-47f5-a7bf-f576b41b75b8	{"role": "brand", "email": "brand-test-1777755590732@example.com"}	2026-05-02 21:00:02.800231+00
d1c3fe94-c650-461a-89c4-2ed2bd024d82	profile_viewed	105ea61a-fa47-47f5-a7bf-f576b41b75b8	user	105ea61a-fa47-47f5-a7bf-f576b41b75b8	{"role": "brand"}	2026-05-02 21:00:03.130042+00
e2cc1338-f069-4cb1-8d7b-f190c01c3326	brand_ads_viewed	105ea61a-fa47-47f5-a7bf-f576b41b75b8	brand	65a1f033-9d57-4eb0-a491-84faab3796e0	{"adCount": 0}	2026-05-02 21:00:03.449743+00
dbce5c74-17ba-40eb-812f-0b81911e4723	brand_stats_viewed	105ea61a-fa47-47f5-a7bf-f576b41b75b8	brand	65a1f033-9d57-4eb0-a491-84faab3796e0	{"totalAds": 0, "activeAds": 0}	2026-05-02 21:00:03.478971+00
054f5860-4c83-4f70-84f2-a5d4a9e3fafd	user_register	135d7699-6e7b-4a84-8b38-3c1ac65a1340	user	135d7699-6e7b-4a84-8b38-3c1ac65a1340	{"role": "brand", "email": "brand1777755771379@test.com"}	2026-05-02 21:04:06.865394+00
5e7fbbb0-311f-462e-a07f-10d8879ffdd5	profile_viewed	135d7699-6e7b-4a84-8b38-3c1ac65a1340	user	135d7699-6e7b-4a84-8b38-3c1ac65a1340	{"role": "brand"}	2026-05-02 21:04:06.94846+00
bc1a1222-b79f-4199-bcd3-a15280954c48	brand_ads_viewed	135d7699-6e7b-4a84-8b38-3c1ac65a1340	brand	b76ae32f-4539-4fa7-813f-9d4e94c760e0	{"adCount": 0}	2026-05-02 21:04:07.064452+00
c1099815-f677-483d-a525-64771381cf05	brand_stats_viewed	135d7699-6e7b-4a84-8b38-3c1ac65a1340	brand	b76ae32f-4539-4fa7-813f-9d4e94c760e0	{"totalAds": 0, "activeAds": 0}	2026-05-02 21:04:07.083933+00
202f6793-9382-4c04-83f7-ad9db274b300	ad_created	135d7699-6e7b-4a84-8b38-3c1ac65a1340	ad	e42ebb20-c389-488c-a5f0-fe9886830947	{"title": "TestCampaign71379", "brandId": "b76ae32f-4539-4fa7-813f-9d4e94c760e0", "questionCount": 1}	2026-05-02 21:04:54.645141+00
09f49045-7eaf-4df2-93e6-9ef271181fc6	brand_ad_viewed	135d7699-6e7b-4a84-8b38-3c1ac65a1340	ad	e42ebb20-c389-488c-a5f0-fe9886830947	{"title": "TestCampaign71379", "brandId": "b76ae32f-4539-4fa7-813f-9d4e94c760e0"}	2026-05-02 21:04:54.819634+00
175e7c1f-d652-4895-9457-e359324e7fed	brand_ad_stats_viewed	135d7699-6e7b-4a84-8b38-3c1ac65a1340	ad	e42ebb20-c389-488c-a5f0-fe9886830947	{"brandId": "b76ae32f-4539-4fa7-813f-9d4e94c760e0"}	2026-05-02 21:04:54.860364+00
ef004a3d-3850-4951-ad9d-43fe0f4d138b	user_register	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	user	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	{"role": "brand", "email": "brand1777756453070@test.com"}	2026-05-02 21:15:03.880518+00
a80ebf26-4da7-4984-b367-514ec22e7188	profile_viewed	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	user	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	{"role": "brand"}	2026-05-02 21:15:04.179602+00
80a46bc2-b4c6-4aa9-8724-a44aacec6899	brand_ads_viewed	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	brand	66b9a100-eef0-46fb-8c9e-b03f7b38158e	{"adCount": 0}	2026-05-02 21:15:04.29121+00
0688072c-d589-40e1-851e-fdc5b0ecbbcd	brand_stats_viewed	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	brand	66b9a100-eef0-46fb-8c9e-b03f7b38158e	{"totalAds": 0, "activeAds": 0}	2026-05-02 21:15:04.309049+00
931e378f-b942-433a-a2c3-c5cc73e47d47	ad_created	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	ad	b5c91f32-6eb5-40e6-a543-a3a3d5da11d0	{"title": "TestCampaign53070", "brandId": "66b9a100-eef0-46fb-8c9e-b03f7b38158e", "questionCount": 0}	2026-05-02 21:15:45.630311+00
2b8e87f4-9ec9-4609-b301-247e9a772c25	brand_ad_stats_viewed	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	ad	b5c91f32-6eb5-40e6-a543-a3a3d5da11d0	{"brandId": "66b9a100-eef0-46fb-8c9e-b03f7b38158e"}	2026-05-02 21:15:48.344425+00
2559df13-a3bf-4715-a1c3-e6b137e21d6e	brand_ad_viewed	985de5ae-27d8-44d0-b2c2-fc0b32d65a19	ad	b5c91f32-6eb5-40e6-a543-a3a3d5da11d0	{"title": "TestCampaign53070", "brandId": "66b9a100-eef0-46fb-8c9e-b03f7b38158e"}	2026-05-02 21:15:48.366632+00
a8b86f41-0503-4695-be9c-bf8ad7568129	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 13:55:51.453186+00
e4c3d998-1351-4602-a197-9411fb20c69d	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 13:56:07.276565+00
9ceccc84-b763-47f7-9797-744f59edb2d2	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-03 13:56:07.662843+00
2a21ed30-676b-41fd-8525-6e917fc0bb0e	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 13:56:08.030825+00
b1b599c1-553b-4891-9749-71195ee361ea	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 13:56:08.39516+00
e32907fb-e9f4-4ca4-9dee-cba0acecf800	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 13:56:30.748738+00
4feaf408-cf17-49e8-b031-1242fffc41b3	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 13:56:45.748456+00
5f5620a2-825e-4764-ad58-b904fa1b9194	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 14:00:26.127089+00
a46e1a79-4cc9-42e8-b5e7-ae809cbe0b64	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 14:00:26.188328+00
d7293ce6-30fd-4bac-97b4-d042ac0a11dd	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 14:00:26.233331+00
df3b128a-9168-4eee-9d4f-7fed287e29c8	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 14:00:26.257135+00
b2404769-f16d-487c-baf6-f801b3e24d23	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 14:00:38.18857+00
436584ca-19e4-4f00-ab57-2d9ad2e766eb	brand_ad_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"title": "Dangote Group — Africa's Pride", "brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:00:48.596551+00
3f8e12ae-2a1b-4423-a25e-aa82a234777c	brand_ad_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:00:48.621799+00
4eeed25f-76e9-4f70-ac64-71b80bea3cf2	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 14:01:22.64489+00
1f15e698-bb53-48f7-bb05-53a4fb6efbce	brand_ad_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"title": "Dangote Group — Africa's Pride", "brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:01:22.677203+00
df5e996b-bb64-4ccd-9bb5-f2cf8b1c05d7	brand_ad_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:01:22.710865+00
3de86726-aa90-4646-97e4-0c032e3b1603	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:04:01.949631+00
da778b3e-85d3-4856-a4f2-96e6d9157c49	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 14:05:47.594438+00
eb8d4c31-5d6b-4b03-8e71-03b634c4c99a	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 14:05:47.641847+00
0819e169-d068-46a1-88ff-c47e7c1f94b0	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 14:05:47.675908+00
77d35cdc-1192-4d07-bacc-de63d1da680d	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 14:05:47.6894+00
43536643-b07d-4a6a-89ea-67eef319e5b3	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 14:06:05.269614+00
5d6e21c1-a4ad-49d2-887c-9ab3180888b3	brand_ad_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"title": "Dangote Group — Africa's Pride", "brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:06:11.87164+00
6ddcb353-9001-4c82-bc68-847cacd6da70	brand_ad_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:06:11.896645+00
f3f931a6-0dd0-4110-8d3d-d3e185f7c6e4	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 14:06:35.644658+00
98cc419a-26b7-434d-be1b-a1c551b5895a	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 17:15:18.293322+00
883b38de-419e-44f2-b413-abf30ba62807	brand_ad_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"title": "Dangote Group — Africa's Pride", "brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:06:35.674743+00
74b1e4f4-f1c3-437c-8338-990838c9393b	brand_ad_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 14:06:35.708383+00
a5d66f72-0fd2-4238-b24e-ddda16deaf68	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:11:40.667077+00
25c88e6d-114d-46c6-81ec-7f38795a5ce8	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-03 14:11:40.710954+00
a6f2d554-c49e-4937-8b6b-efd61455ed8c	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-03 14:11:40.757181+00
a79faf6f-cd7c-46cf-8d02-6604ef9946db	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:11:40.824584+00
78164ec5-e3e4-4376-9714-822b3e1c2388	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:11:40.87614+00
e6ceded9-ad30-4cf8-9208-6e5af5356e5f	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:13:04.951245+00
7f010d6a-1e17-414a-aa26-8493058664cc	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-03 14:13:05.007322+00
3e1f807b-0891-4092-9818-e5b6146106d3	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:13:05.016102+00
f429f3fa-0794-4ee9-aee2-12c921dd1d5c	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:13:05.025152+00
cbe00b88-7db5-475d-b2dd-0323447f3790	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-03 14:13:05.043393+00
f5d0b463-aae4-46cb-8427-50aea1e1b16c	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-03 14:17:06.421601+00
37a9f550-4eb6-43c2-bc68-28ec1f60a3ed	admin_ads_queried	\N	ad_packages	\N	{"action": "list_packages"}	2026-05-03 14:17:06.583191+00
404c9407-0e94-4170-aeec-d3de33fac1db	admin_events_queried	\N	platform_settings	\N	{"action": "get_settings"}	2026-05-03 14:17:06.585886+00
4b15743f-89c8-46f4-b646-5df1d4e680b9	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 202, "filters": {}}	2026-05-03 14:17:06.587405+00
24c20c20-6fdc-4891-9b74-9c6fb2214ccd	admin_users_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 38, "filters": {}}	2026-05-03 14:17:23.301165+00
35a35eb0-935e-47c9-adaa-9f3981bb30ab	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:21:35.053225+00
46afc10f-dc40-49d1-9386-6897a6bd6afa	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:21:35.130775+00
919e2518-3b42-408b-a5ad-f6d9b4262764	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:21:35.133197+00
62fdab9a-11dd-4846-b2c6-54c680e362e5	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-03 14:21:35.14731+00
8f49f6d8-3a94-44ad-b71e-baf2c585571e	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-03 14:21:35.177809+00
ce0cf26a-8973-43af-9dbd-62ee36e04a09	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:21:41.237001+00
9855339f-2eaa-4559-b13b-93531d4827e4	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:21:41.24695+00
88fbe739-11a7-4e5a-a4cb-fae6a72ab751	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-03 14:21:46.47035+00
a240de9d-91ec-4a3d-8abb-383cdbafe35b	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:21:46.49295+00
aa6e0f86-d5c1-4341-b17f-72618a12f0d1	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:21:46.493139+00
b2bf0c6c-8823-4113-94c5-8db91cdd8dda	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-03 14:21:46.509346+00
de476826-9bc8-462d-a963-d562c3dd11df	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:24:17.675324+00
fc8f9aa0-9d31-4bc5-86f9-fa12df0d574f	profile_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:24:17.728983+00
b4e3194e-7e91-49d6-b976-e5f242650c19	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:24:41.443143+00
a3eff097-a770-43ae-9a34-659d4fbe7ca5	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:24:41.519554+00
27540b1d-acd0-479d-b433-758354373be3	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-03 14:24:41.52894+00
4044e98d-2c55-4c57-a07a-88f3658b8a4e	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:24:41.53595+00
bcf75588-7919-4541-937e-c5a77366236f	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-03 14:24:41.549485+00
865b2132-ce74-4dea-9b5d-92fa9f497554	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:24:47.545191+00
6040cd22-a038-4c9d-872f-22133e612e5f	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:24:47.556845+00
d1977c02-d65e-40cd-b0cf-207a8e7a5b09	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-03 14:24:54.030556+00
6cfa433d-8681-4788-b66f-7c258ae90e6f	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:24:54.066722+00
7a0a0059-cd46-423c-8793-8de3a689ac81	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-03 14:24:54.074648+00
f019465b-3770-4e5f-be27-9c5346c757d3	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-04-27", "entriesCount": 10}	2026-05-03 14:24:54.080448+00
05b6eaa8-7c20-4e49-8e50-6a8aacd47e12	ad_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	{"title": "Guinness Nigeria — Made of Black"}	2026-05-03 14:24:59.783825+00
da66c939-ae8f-45b9-a32f-581fe12d1329	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	fa5ce023-e934-4799-8847-5d422eb74e70	{"adId": "dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3"}	2026-05-03 14:24:59.79009+00
d932f32b-102f-45d5-9d31-a998e6714b29	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:27:00.695902+00
027a7f7b-a4b3-426a-91f4-cd8989903e96	profile_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:27:00.749993+00
3ae4180b-48f3-4998-8a63-bee36ccc95f0	profile_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-03 14:27:19.326853+00
978a72b4-da20-4c43-9b60-5334770a1303	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 17:14:46.998466+00
906380d6-1d4e-4d74-bafe-2034a9343dc3	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 17:14:47.261515+00
b185171b-f3a1-441b-a38d-a2690d388214	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 17:14:47.368179+00
aea79405-276c-424e-ab53-cc82784b5c94	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 17:14:47.374394+00
e14f3483-d122-4e9f-af7d-49746509d4b7	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 17:14:53.530752+00
7adf3de9-ab69-4b54-a355-4d129deb397b	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 17:14:53.568525+00
f31180e8-c09a-4391-8bed-36d317393d10	brand_ad_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"title": "Dangote Group — Africa's Pride", "brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 17:14:59.293221+00
da21b34e-afab-438e-8369-4569369a77de	brand_ad_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 17:14:59.31763+00
61a419b0-81ab-49ec-94bb-6743508f4af1	brand_ad_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"title": "Dangote Group — Africa's Pride", "brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 17:15:18.328002+00
19460648-8179-4a1e-846e-3849d929f512	brand_ad_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 17:15:18.359389+00
5361690e-3218-41e3-b52a-0a2de350f067	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 22:13:19.159606+00
3234830c-c658-4bf8-b160-09c65e0cb359	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 22:13:19.822064+00
7128ca83-2b47-496b-a934-c54f0a3ed08b	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 22:13:20.143701+00
dfda33eb-5d64-4be7-8eb4-19a69621a28a	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:13:21.043939+00
54cd71e6-b5b2-408e-9d84-d7399e62f3c2	brand_ad_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"title": "Dangote Group — Africa's Pride", "brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 22:13:33.100827+00
a2c53b54-0287-461a-aeb0-a6aa45f4078e	brand_ad_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	ad	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	{"brandId": "c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803"}	2026-05-03 22:13:33.12795+00
c0ede92b-eacb-4bf1-9b1c-499c688c494a	brand.ai_summary.generated	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adId": "f7fd0f69-bde1-4106-89fc-7d44f2aff71c"}	2026-05-03 22:14:05.255321+00
4e3264f9-dd57-41bc-8a50-279fc45cf3ba	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:14:27.192602+00
520c9ca2-464b-4956-859b-57ada5b451f4	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 22:14:28.072926+00
c3c4084d-cfbf-4d5e-ae40-47b5a0d23fac	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:14:47.801626+00
779bbabb-7e0d-4f70-b281-0b832481e55b	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 22:14:54.27015+00
045191d9-38da-425b-9949-cec19c9e7263	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:14:54.280169+00
fa8e7b8c-adf9-48ae-96a2-2a92bbc5c89d	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:15:05.993285+00
2421b526-55f7-41c2-8f61-5faf8b5df4df	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:15:07.781296+00
f7736ae8-76ae-46a8-a837-7372d98bcd2d	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:15:10.286528+00
0439b407-ec39-4ee6-8eea-98b3ab682916	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 22:15:10.297986+00
21e3e99e-8ed7-4a16-95ff-4dcef3507000	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:15:18.87784+00
89ac66d7-04e8-42ce-a2f7-20c4947448a8	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 22:15:27.488879+00
dd9f48aa-8f5c-45ed-96bb-98915caaf438	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 22:15:27.499878+00
8ec7f356-b7f1-43a2-8836-bd322715b76b	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 23:27:26.921988+00
f7cfcc09-86d7-4c5d-a8f7-c3c68b64d96d	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 23:27:27.382564+00
8662df9c-f252-4bcc-8234-91e7b833139c	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 23:27:27.404494+00
c0dbff32-61dc-41c9-ac0c-4674c6c8dd75	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-03 23:44:21.802389+00
7f31f0ab-ce17-4814-b479-0f70a691da6e	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-03 23:44:22.455298+00
7f63d3cd-dfbf-497f-805a-366576d36cb0	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-03 23:44:22.456729+00
440d768b-92a4-4bc9-be14-8186e67af0af	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:14:53.354582+00
e48a9fac-5bcb-40b5-9dfa-b11f4dac095d	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:15:16.15176+00
9199d8f9-6296-4712-8238-7887874ff1ff	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:15:28.547306+00
992b31ed-f59e-4542-b099-fc895e8011f1	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:15:37.501942+00
43956558-ea6d-4511-92b2-f0ec446bea1b	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:15:40.338043+00
9ca3d696-6b55-4b64-bd78-7cfd79b85c79	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:17:00.679607+00
e3441fe4-beb0-4da1-8d17-dbe2d93c046f	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:17:00.70395+00
89ddeae0-1dca-4246-bb10-dd65c1039038	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:17:30.267137+00
a05f6122-93c2-43fd-b45a-92185b8ff879	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:19:30.809863+00
2815f6a7-58a1-4140-b601-588d7fb8ed09	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:19:30.860303+00
09ce8d5c-dea5-4cec-a1ef-b49687b7e02f	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:19:51.761993+00
653f9119-c4f5-40f0-bc3f-7ed5df2c7fb0	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:21:49.071565+00
9ede609e-6d62-4524-b4a1-6168e0df81dc	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:21:49.103044+00
528e5391-4fc3-4048-aea4-e1b6563ad01f	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 11:23:27.836317+00
3d3631f6-89bc-49a9-92db-7036c3733245	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-04 11:23:27.901598+00
8e742547-1332-49f8-9102-b93f4d746407	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 11:23:27.919103+00
8aad9469-cf21-4750-b2d9-68f9450f9a36	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-04 11:23:27.95624+00
e2a900f0-d5e4-4f57-bae1-4073856c3efc	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 11:23:27.957315+00
45b82a8f-2c98-47ab-ac40-744debdb9e34	ad_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad	b816c046-cefc-430c-a25b-6c35f958302d	{"title": "MTN Nigeria — Everywhere You Go"}	2026-05-04 11:23:42.014486+00
e241d386-4642-4de0-959c-0f603d152572	ad_view_start	85ec9791-dc91-46cb-b7da-51f8af983a04	review_session	738e0026-1828-495e-bc19-3b5a6764175d	{"adId": "b816c046-cefc-430c-a25b-6c35f958302d"}	2026-05-04 11:23:42.027647+00
bef38ada-f744-474d-a928-19ff831d1c49	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:24:09.448345+00
a7284284-eb5a-4429-ad5f-be6bf024d941	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:24:17.006444+00
bbf6a804-8cbb-4a7a-91ac-15cfd70879e7	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 11:41:49.449217+00
37b98ea5-de7b-4aca-91e4-3518116c4219	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 12:49:47.747349+00
16de7eff-562b-4fab-acd5-27e34bfc9dfe	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 13:18:05.186849+00
3f31852c-9470-41c4-9671-042122dff028	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 13:18:06.206383+00
bd772ccc-c528-4c67-aa04-675c712531ad	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 13:18:54.446906+00
a54d2654-3333-4c1a-bc94-19819f992bbe	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 14:12:45.130237+00
f25c8eff-8af4-4e56-8b53-b60f972ac664	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 14:30:05.958559+00
0efb0dee-cff3-4754-ac2b-e598ddd29adc	brand.ai_summary.generated	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adId": null}	2026-05-04 14:32:26.849602+00
ac1a090c-8510-4651-9cf0-1031fff0742c	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 14:44:08.070059+00
b5e6420c-2492-4716-a9a6-b16c87e08b60	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 16:27:03.835661+00
9439bab6-8ae0-42a0-b0a0-c6ece82f53b5	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 16:44:04.709492+00
14192974-5a3b-40fd-b646-4cfcca914b00	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 21:32:18.279407+00
00adf541-59c6-413f-8068-de3782c7b1d7	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 21:32:18.865882+00
266594d4-2137-49d4-ab4c-123148671f50	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 21:45:54.017652+00
9b9e09e9-3e49-4cef-a3c1-5d3acdbc4360	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-04 21:45:54.582203+00
172c9cb6-5d21-493d-8276-e5ea02316c52	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-04 21:45:54.636878+00
d0cbec1d-41af-4766-bffb-f967239bb1d3	brand_stats_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"totalAds": 2, "activeAds": 2}	2026-05-04 21:47:08.939195+00
c3622169-4089-4d2d-b66a-926fa54cd570	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-04 21:47:08.959739+00
a71843bb-5d85-4d25-aa0c-1d3908578a8a	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 22:26:31.337223+00
810fd9e0-bbe8-4fdb-8b55-e6d3824cc6e4	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:26:32.748857+00
afa26560-e206-4b36-8afd-5f9860c37de7	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-04 22:26:33.204058+00
623c0731-c7e2-41f9-96fa-c83a1ab1feda	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 22:29:08.098726+00
4d4ade03-1069-40b9-950f-82eb845ace91	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-04 22:29:08.204064+00
8665a35e-4ce5-4288-9295-0843b22b3f42	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-04 22:29:08.216377+00
8fc87f71-3c1d-474b-b81d-6d743d4723c0	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 22:29:08.217809+00
0149c684-a33d-4f54-a41a-d7bc72f95699	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 22:29:08.249324+00
86541849-6404-4074-ae0a-b7294518122b	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:29:32.958306+00
0b6a29d9-89be-47f9-9cbd-4aa98789eb93	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:29:32.978015+00
56029110-0a8e-4e10-81bb-57e9d90e1092	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:29:58.890589+00
1336b3f7-ed35-4f39-b6a5-5b42fbcafb3f	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:31:01.852975+00
7f088eaa-846d-44de-a5c4-1a894fa1b639	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:31:25.659123+00
bb6ecb6f-c61a-4bee-a2c4-cc147c9f0d2a	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 22:32:03.317155+00
6f6f8d6a-39a8-4bdf-ac98-8c75026a73ec	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-04 22:32:03.395048+00
ed48ccdc-7f4e-4a5b-b8f4-6afcc45a0fde	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 22:32:03.395364+00
b1fb7299-cda1-42f6-8aca-b9f80401cad3	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 22:32:03.415924+00
c5cc835e-c8a9-4e2f-8605-068319d66de8	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-04 22:32:03.43728+00
d4a2e4d2-ac14-4693-997c-72aaeab62f39	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:32:28.130467+00
2e0e735c-fcf5-41ef-8ecf-ead3cc7e2655	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:32:28.15898+00
8eecbcb6-39bf-4ead-98f5-a4ee15a8221a	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-04 22:32:49.230636+00
1633b370-82cd-42c3-b7ff-9569eb4c67ff	profile_viewed	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-04 22:32:49.25061+00
053cbe14-ac1f-4e41-ab23-dc2c13864be1	admin_users_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 138, "filters": {}}	2026-05-04 22:32:49.296866+00
bd06ced1-c100-4a05-a651-534354ee6934	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 334, "filters": {}}	2026-05-04 22:32:49.306856+00
a1597e20-5afd-4ea1-b32d-a6c9274e8f7a	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:33:09.974067+00
9d2d4d02-af66-490b-a7f3-f64595993c21	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:33:10.02671+00
a87aa834-2c54-41ec-8e11-b19d89aa6b7e	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:33:14.223131+00
debbbe44-0d4b-407c-9819-048981c0d25c	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:33:25.807261+00
8fa0ad66-425e-45b2-adbf-9da43bf219f6	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:33:25.827403+00
e047fc9b-6cff-45b0-8352-0be9423cb8e7	profile_viewed	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-04 22:33:25.989338+00
070c9ca3-17e2-4c75-ae36-28d3964c9015	admin_users_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 138, "filters": {}}	2026-05-04 22:33:26.080789+00
5ae928e8-acee-4b73-826c-8fa487927631	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 341, "filters": {}}	2026-05-04 22:33:26.083295+00
1d3d1df3-b611-4b1e-8216-b33846bd70b1	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:33:26.146056+00
12636bf8-6ca0-49b8-b30f-e25d05c89e00	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 22:37:14.774481+00
d5e3da37-0bff-47b6-a863-b4c58550d051	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:06:17.379065+00
36f54c10-9c76-4f07-854d-bf669966ba3d	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:06:17.641611+00
35c1ccf8-45bb-4013-ad45-5e466f3d34fa	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:06:36.764507+00
571fdeeb-05fa-4821-bbac-1e4aadc5c1f6	user_login	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 23:06:42.363583+00
80e5e994-c9be-4a66-8803-8d5b81fe5426	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-04 23:06:42.396171+00
e7b798e7-4d5b-4e11-8f68-4061f2d80e6e	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 23:06:42.397853+00
19dbc4ab-7c4e-4dc7-9e73-f5b7fabf9ef9	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-04 23:06:42.416924+00
44a25a39-2a91-43ae-9541-20f99b5fbb12	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 23:06:42.420433+00
6cc9ed1d-d8b9-4c6b-a69d-32b848b8e389	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:06:51.044686+00
48da7786-9bd4-4b6c-83d6-a02d5ee5a2e4	profile_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 23:06:55.908305+00
ceb256bf-7550-4a85-8870-97c38516265a	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-04 23:06:56.037172+00
1d842426-d648-4d0e-9d4e-d5c0b3a5841a	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-04 23:06:56.049288+00
1d5c23ed-8431-4482-add6-44ead2430a2e	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 23:06:56.079316+00
46ba3a97-e0b0-41f6-a4ca-c23614c430a2	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 23:06:56.242734+00
9c733130-a472-45c8-9161-7156709d05bc	profile_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"role": "reviewer"}	2026-05-04 23:07:14.118975+00
b7983548-2ec5-4968-b40a-6bc7cb91f373	points_balance_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	user	85ec9791-dc91-46cb-b7da-51f8af983a04	{"balance": 125}	2026-05-04 23:07:14.213877+00
89e4d3f0-e367-4062-8e95-0e7d7389bdcd	leaderboard_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 23:07:14.25952+00
9026f810-b693-4294-b55b-b9ff89cbd75f	leaderboard_updated	\N	leaderboard	\N	{"weekStart": "2026-05-04", "entriesCount": 10}	2026-05-04 23:07:14.307273+00
cf5cddc3-b2cc-4c30-8005-b8d9a7402ce3	ad_feed_viewed	85ec9791-dc91-46cb-b7da-51f8af983a04	ad_feed	\N	{"limit": 10, "total": 14, "offset": 0}	2026-05-04 23:07:14.353281+00
bfca9746-90bc-407e-b0be-62cf81121991	user_login	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-04 23:07:35.02151+00
63f1159f-d910-4789-88b3-fd653dd6995e	profile_viewed	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-04 23:07:35.088432+00
a94046aa-4991-4fbf-8c2c-6d0fc7fb0d1c	admin_users_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 138, "filters": {}}	2026-05-04 23:07:35.20224+00
0573be38-6f4d-4760-8adf-3932ab58ee1c	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 366, "filters": {}}	2026-05-04 23:07:35.206169+00
9f1acbe4-c5bc-40ea-b409-f72e93d4328a	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:07:59.290282+00
d0b79cae-a048-4d63-ac16-ef4fdddc5fbe	profile_viewed	7218e299-4644-4f20-b480-8b59fee930eb	user	7218e299-4644-4f20-b480-8b59fee930eb	{"role": "admin"}	2026-05-04 23:09:37.594788+00
8868dec2-2e0b-4822-b7d9-3f60113aaefe	admin_users_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 138, "filters": {}}	2026-05-04 23:09:37.676337+00
d8049722-bc77-43d1-825e-5e0cf4ceb5a7	admin_events_queried	7218e299-4644-4f20-b480-8b59fee930eb	admin	\N	{"total": 371, "filters": {}}	2026-05-04 23:09:37.714296+00
06c45210-fffc-4708-84db-cb70f6f3fbde	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:11:17.340784+00
1fc0b24c-531b-4601-8e64-ee63309b984a	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:11:17.648167+00
d3652176-518b-46ca-b765-bc1d228e1e4f	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:18:10.760649+00
6578ad75-5b32-4df6-9ed5-7d64bf8388a4	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:18:11.072216+00
899d42b0-d85c-44f4-bfc1-e088c3d596a8	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-04 23:19:31.556129+00
bcafc3a3-4b73-4564-9184-2e88fef5dddf	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:22:45.263359+00
698914cb-7674-4108-8655-162cce2389ff	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:24:38.205756+00
8f5c3063-245d-42cf-8d06-bcc15b0ebaff	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:24:59.614948+00
1234fd9a-109c-494e-bf7d-fc6bd027f3de	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:26:36.001535+00
db880c81-256f-4847-8731-97e1d873fc63	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:27:35.869554+00
89260d49-18f0-46ea-bc43-ff53eae358ca	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:28:02.778179+00
e95b569c-2f6b-4796-9970-67cdaf5fbd6b	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:28:02.811999+00
70ce490c-1159-4cac-affd-cbebd222897a	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:29:09.202914+00
9ced960d-0c0d-4200-ba71-656eaf1aa95b	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:29:13.339963+00
8821882d-b33f-4a4c-a319-c44d8e487196	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:33:49.405059+00
7fd3d0ce-3e49-4509-bcee-7b8440d37fe8	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:34:01.936245+00
4ab352ef-b04b-4550-af87-2c2958f85aab	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:34:01.956734+00
27a2e86c-bb2a-4108-a0ad-bfcf77fe1748	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:34:39.786895+00
90f5e7d0-6f57-40fe-bc38-16c5186b61ed	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:34:43.780335+00
0bc20332-0a60-41c8-877d-db7962586ba0	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:35:50.460189+00
15b66b1c-bfdc-47f9-8b34-48bf026d3fbb	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:36:24.689861+00
40deb296-75bf-4a4d-9846-fdab966b881f	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:36:24.719217+00
0bd6a47d-16c2-48f0-9080-15f535572f8b	brand_ads_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	brand	c9f6179f-15ad-4aa5-9ae9-4ea1ce6ea803	{"adCount": 2}	2026-05-04 23:37:00.41703+00
26ef2a93-745b-41e3-a743-c6df2387c82c	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:37:38.187504+00
0f31170b-8bae-415c-8cb7-6a67e9c71b1b	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:37:38.871675+00
ebf24229-298d-43fd-9926-5a91e030fbe3	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:39:17.444423+00
b988c66e-f06c-4504-b285-a521cedb2f27	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:39:17.469804+00
677606b4-555e-4a1b-9c03-3f2aa5016beb	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:40:11.943452+00
03d1ffd1-5ed0-4434-8db4-c1eb4c9d412c	user_login	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:41:21.820012+00
7b3b8b67-5846-43b6-89e4-6a250e63b919	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:41:21.877586+00
2bb309a7-5c4f-4bd6-af32-bf5afe86b7cd	profile_viewed	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	user	e37ee3e7-9abf-4312-bb8b-ff2606c14a41	{"role": "brand"}	2026-05-04 23:41:56.049946+00
\.


--
-- Data for Name: leaderboard_snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leaderboard_snapshots (id, user_id, week_start, points_total, rank, created_at) FROM stdin;
6a225ca6-cf78-4212-a7be-850763b0fa10	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	2026-05-04	266	1	2026-05-04 23:07:14.260459+00
63df35a8-0b2d-4c90-90ed-50923ed5386c	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	2026-05-04	263	2	2026-05-04 23:07:14.260459+00
a3cead69-cf37-47e4-a7a6-4057ae58ca38	7f8d51b9-6769-40a2-8690-48eabb1fc122	2026-05-04	258	3	2026-05-04 23:07:14.260459+00
b3ff4064-bb3d-4215-bead-ea07bd14c9c8	412657a8-b0db-4dc9-a50e-e9358092e49a	2026-05-04	256	4	2026-05-04 23:07:14.260459+00
e164b3bf-90d3-4616-a962-b147f8e62c4d	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	2026-05-04	255	5	2026-05-04 23:07:14.260459+00
3c7200c1-a786-40fc-a5e6-76ccd1dd8fe6	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	2026-05-04	255	6	2026-05-04 23:07:14.260459+00
ccdfca18-19d3-470c-a75d-9e7de84d340d	15753795-0698-4fd8-898d-cd03f4ee0a9e	2026-05-04	249	7	2026-05-04 23:07:14.260459+00
67284ca0-5579-4a50-8349-e9d157241c4e	21b0e483-154e-4e6a-a9ca-3c56585e36b0	2026-05-04	248	8	2026-05-04 23:07:14.260459+00
98400257-8cad-4bc4-b973-feb655c2b5bf	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	2026-05-04	247	9	2026-05-04 23:07:14.260459+00
b3f8699d-dc87-48e6-ae0d-e790a7038e0e	b9c3be6b-8da0-4414-bf50-69410fa774bb	2026-05-04	245	10	2026-05-04 23:07:14.260459+00
f3a50903-73df-4cf5-aa20-92efe32b8d7b	85ec9791-dc91-46cb-b7da-51f8af983a04	2026-04-27	125	1	2026-05-03 14:24:54.06656+00
c0dfb533-9f7f-4e3a-bd8e-28d5ae4c77b9	e89a4458-7ea7-41d9-bb3c-fce388d89786	2026-04-27	95	2	2026-05-03 14:24:54.06656+00
37fdea56-0fb3-49fc-aa9e-3c8371f0325d	ff53cafa-c092-4b35-bf55-8b03054f62e7	2026-04-27	85	3	2026-05-03 14:24:54.06656+00
62e9a5b6-d237-43ba-9791-1859e2cfdc2a	196ede38-71c7-4ad7-bee5-d3dfbd43a752	2026-04-27	63	4	2026-05-03 14:24:54.06656+00
e3a11e1a-4f8c-4f7e-ad6f-f50b35d0f819	0bdfe30f-eb98-4a61-8aee-873a46e3bf40	2026-04-27	52	5	2026-05-03 14:24:54.06656+00
2f7fca12-1dae-4617-bbe5-6af8974b9b4b	b01b170f-5d12-448a-bab4-1aae4c19007d	2026-04-27	40	6	2026-05-03 14:24:54.06656+00
e177b38d-0364-47ca-954b-b1f2e266e3ba	ab994e97-fe94-48ea-8e4d-cd937f113249	2026-04-27	35	7	2026-05-03 14:24:54.06656+00
8166c83d-3ee3-4295-9125-c651af24f9b8	6902ee2a-e1dc-4185-badf-9c0d01e2711e	2026-04-27	30	8	2026-05-03 14:24:54.06656+00
d96fd61a-584e-4b2e-944b-b9e46c824051	1c1ba66f-1c47-43b9-b3c6-d314426eb145	2026-04-27	20	9	2026-05-03 14:24:54.06656+00
497addbe-560d-41ed-b995-1e24b314203a	ef469f0d-6242-4385-9125-a99beb8c6cd1	2026-04-27	18	10	2026-05-03 14:24:54.06656+00
\.


--
-- Data for Name: platform_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.platform_settings (key, value, label, description, type, updated_at) FROM stdin;
platform_name	AdSpot	Platform Name	The name of the platform displayed to users	string	2026-05-02 18:20:13.274644+00
point_value_usd	0.001	Point Value (USD)	USD value per point earned by reviewers	number	2026-05-02 18:20:13.274644+00
min_watch_seconds	15	Minimum Watch Seconds	Default minimum seconds a reviewer must watch before earning points	number	2026-05-02 18:20:13.274644+00
max_point_reward	100	Max Point Reward Per Ad	Maximum points a single ad can award	number	2026-05-02 18:20:13.274644+00
leaderboard_weeks	4	Leaderboard History Weeks	Number of past weeks shown in leaderboard history	number	2026-05-02 18:20:13.274644+00
review_multiplier_enabled	true	Review Multiplier Enabled	Whether brand multiplier factors are applied to point rewards	boolean	2026-05-02 18:20:13.274644+00
registration_open	true	Registration Open	Whether new user registration is allowed	boolean	2026-05-02 18:20:13.274644+00
featured_brands_limit	6	Featured Brands on Landing	Number of brand logos shown on the landing page	number	2026-05-02 18:20:13.274644+00
landing_video_count	8	Landing Page Video Count	Number of videos shown in the landing page showcase	number	2026-05-02 18:20:13.274644+00
redemption_min_points	500	Minimum Redemption Points	Minimum points required to initiate a redemption	number	2026-05-02 18:20:13.274644+00
demo_mode	true	Demo Mode	When enabled, seeded demo accounts (.demo emails) are included in all stats and feeds. Disable before going live so only real production data is served.	boolean	2026-06-01 13:59:14.752925+00
min_watch_seconds_default	15	Default Min Watch Time (seconds)	Minimum seconds a reviewer must watch an ad before points are awarded. Brands may override this per ad.	number	2026-06-01 13:59:15.127732+00
point_reward_default	25	Default Point Reward	Points awarded per completed review when the brand has not set a custom amount.	number	2026-06-01 13:59:15.140013+00
leaderboard_size	10	Leaderboard Size	Number of top reviewers shown on the weekly leaderboard.	number	2026-06-01 13:59:15.143205+00
max_daily_reviews	50	Max Daily Reviews Per User	Maximum ad reviews a single reviewer may complete in one calendar day.	number	2026-06-01 13:59:15.146711+00
\.


--
-- Data for Name: points_ledger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.points_ledger (id, user_id, amount, source, reference_id, description, created_at) FROM stdin;
b00df161-dab8-4512-9691-f5ea2f038bc2	85ec9791-dc91-46cb-b7da-51f8af983a04	15	review	6c9d6eff-fd26-4581-bc7e-eababed61a21	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:37:57.870913+00
131ababb-0f6a-40ba-9f09-d4eb01182add	85ec9791-dc91-46cb-b7da-51f8af983a04	20	review	73805821-b677-4b5d-9414-8c63653ad83b	Completed review for "Acme Home Edition — New Features"	2026-05-02 17:37:57.879723+00
961da487-5094-402d-b993-b3750fcb531c	1c1ba66f-1c47-43b9-b3c6-d314426eb145	20	review	d2b715b0-8b31-4d46-b843-648292c2610f	Completed review for "Acme Home Edition — New Features"	2026-05-02 17:37:57.887281+00
9c51d5e9-9d20-410c-8deb-c794e3be84cd	e89a4458-7ea7-41d9-bb3c-fce388d89786	25	review	c738c298-8a6b-48c2-861f-368b9e8e29a6	Completed review for "TechWave Cloud Platform"	2026-05-02 17:37:57.89697+00
c3a91b40-27d6-467b-9f72-cd2f9b4aeb43	e89a4458-7ea7-41d9-bb3c-fce388d89786	30	review	d1543b06-d2d7-4bd4-9755-efa7c5366530	Completed review for "TechWave Mobile SDK Beta"	2026-05-02 17:37:57.905324+00
5ab4c742-f6a7-4041-b697-d85a52900958	e89a4458-7ea7-41d9-bb3c-fce388d89786	40	review	f783a787-0a0e-46bd-8234-4182abed09f6	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:37:57.913291+00
0e34a730-abc5-4b13-9d7b-1f1553f460bc	6902ee2a-e1dc-4185-badf-9c0d01e2711e	30	review	81af4e6e-242c-4ca5-9aef-3a5c61750222	Completed review for "TechWave Mobile SDK Beta"	2026-05-02 17:37:57.922334+00
91c133b9-d5ff-4f19-9fba-f6ceb3d142cb	b01b170f-5d12-448a-bab4-1aae4c19007d	40	review	6182c375-fda3-4ac6-ba77-1a456914a714	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:37:57.930793+00
22891b86-5ecc-4142-afec-815298bc8900	0bdfe30f-eb98-4a61-8aee-873a46e3bf40	12	review	d57fe98d-e238-4dab-9bf5-99772fb75a3b	Completed review for "Acme Home Edition — New Features"	2026-05-02 17:37:57.939358+00
6a9a88f5-0ac5-4ee1-9db7-f35cba4c87a8	0bdfe30f-eb98-4a61-8aee-873a46e3bf40	18	review	fd1b917d-ece5-4ac5-95ec-46e9f592dc93	Completed review for "TechWave Cloud Platform"	2026-05-02 17:37:57.953634+00
1db68ef1-a28c-4ae9-966d-50be848382fe	0bdfe30f-eb98-4a61-8aee-873a46e3bf40	22	review	1b8e7dbd-0a46-4d18-b81b-5a0d7a2999bd	Completed review for "TechWave Mobile SDK Beta"	2026-05-02 17:37:57.963151+00
8c5b41e3-0a58-4fda-9c4a-3b58118298bc	ef469f0d-6242-4385-9125-a99beb8c6cd1	18	review	e22f2c34-a481-400d-8209-1e454772cb36	Completed review for "TechWave Cloud Platform"	2026-05-02 17:37:57.973224+00
089b1bc9-4240-47d1-b7c5-05c439ada74f	ff53cafa-c092-4b35-bf55-8b03054f62e7	22	review	ca1790cf-4f03-44a6-a2f3-69d4a47d517e	Completed review for "TechWave Mobile SDK Beta"	2026-05-02 17:37:57.98143+00
47067715-e3a0-4907-9ea8-03dbfa302e8d	ff53cafa-c092-4b35-bf55-8b03054f62e7	28	review	5b3ba3a7-a287-42e1-9a84-63cd6fc125f8	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:37:57.988795+00
241878b1-9584-45ae-a346-21059ba5cf58	ff53cafa-c092-4b35-bf55-8b03054f62e7	35	review	ac113119-98b8-485d-9907-3e1f78efb5ec	Completed review for "Acme Home Edition — New Features"	2026-05-02 17:37:57.999279+00
27b66b59-74cb-45ff-9534-6fd9976f7074	196ede38-71c7-4ad7-bee5-d3dfbd43a752	28	review	b41f77f4-d1b8-46c5-b0c4-174408e54b85	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:37:58.010641+00
952276df-10b7-40a2-b1e0-6784a46a3879	196ede38-71c7-4ad7-bee5-d3dfbd43a752	35	review	ff160ad8-5e28-4e5a-8100-4a6ee2ea4f9d	Completed review for "Acme Home Edition — New Features"	2026-05-02 17:37:58.021133+00
37bcb95d-928f-4525-ae6b-9dd01528e9d3	ab994e97-fe94-48ea-8e4d-cd937f113249	35	review	0dfe7338-9fbe-4d54-89fa-3f527899c88d	Completed review for "Acme Home Edition — New Features"	2026-05-02 17:37:58.031091+00
cd0f9940-2b4c-41d8-b993-e165b50c4c4f	85ec9791-dc91-46cb-b7da-51f8af983a04	15	review	a62cce75-d475-4005-b40d-6b03ec27db5d	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:38:38.91073+00
60516939-abae-4c5e-9551-f27f06916166	85ec9791-dc91-46cb-b7da-51f8af983a04	15	review	d400bcfc-fdd9-42c1-9c0a-233fa21607e3	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:46:47.447097+00
e27b349e-8fae-4fa6-8688-46a9940c1229	85ec9791-dc91-46cb-b7da-51f8af983a04	15	review	d26ca88f-e4cb-4ee2-9a9f-bd80998c97f2	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:56:23.520543+00
2e65c454-474b-49b3-8b8b-f97c76bac0cd	85ec9791-dc91-46cb-b7da-51f8af983a04	15	review	1e462776-dd9a-4176-ac53-db54bd91ad8a	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 17:58:06.434819+00
8bc5a2b7-e3f4-41e8-8cb5-a617572d90bf	85ec9791-dc91-46cb-b7da-51f8af983a04	15	review	58821e3b-c352-436f-9f33-9438dcaee2c2	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 18:03:17.701159+00
eb7e32c9-9969-4773-af25-9eca082d0c8c	85ec9791-dc91-46cb-b7da-51f8af983a04	15	review	b80003c2-2656-4bbc-812f-bd144dcd6821	Completed review for "Acme Widget Pro — Summer Launch"	2026-05-02 18:08:31.372812+00
ef3ad41b-3fbc-4369-b4f6-552d62b65bbd	844f4ae8-0c18-4556-8196-518df739b1a7	60	review	aed14e3c-8644-4711-8e63-53ebf90d0003	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:31.927045+00
204ccf94-8e20-40ee-93ce-a2dbda95b437	411cbccc-9d5e-45be-ad3c-90f99f13a1a9	83	review	5f246d58-8a72-4117-b89b-417ea2f9d554	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:31.936498+00
9a1e2890-91e7-4cae-84fe-be03d8ac5f22	411cbccc-9d5e-45be-ad3c-90f99f13a1a9	68	review	519ad0bb-4815-48d0-9ab9-6bebe71a847b	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:31.947105+00
f7a5e503-a6d5-4bcf-84f2-70f520026e8b	de513c1b-475b-4888-a59f-8f3beaf5955f	65	review	1f9a4c26-3784-4615-b977-901285e26e40	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:31.956543+00
c1bda219-2306-4ec1-95d8-501d9f0de8ba	de513c1b-475b-4888-a59f-8f3beaf5955f	91	review	d81301b4-6a6b-4120-bdc9-f80e829f951b	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:31.965996+00
6d860c1a-3cc6-4b6b-92ff-606e6a0d784d	de513c1b-475b-4888-a59f-8f3beaf5955f	71	review	ff0b8cd1-f7e1-454a-8bf4-b80953001163	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:31.975395+00
e36cbff5-023e-4ab7-8e80-ff05edd2eb31	58f512f8-49f5-4127-882c-f7e89ba5ddcb	95	review	38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:31.983916+00
745c67b8-5c9b-4b9c-817d-2184ecf47c9e	2080eedb-b15f-4a3c-978d-59145268d6dc	64	review	50db2bde-4b4d-4ece-a4c4-51cb082f30ca	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:31.992392+00
ec89e1ba-8137-4aad-8fa7-e191ad91a502	2080eedb-b15f-4a3c-978d-59145268d6dc	87	review	86ea4497-f522-43a8-8b5f-a5f55764140e	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.001048+00
b7626b62-e5d4-44a9-bd1e-556646106c64	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	90	review	33e822c3-d9f8-4d7c-b54b-22de258bb819	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.010204+00
3678f2f5-8798-4a04-8b64-aa4ef10bf4f8	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	71	review	e19427a2-6b47-4a4a-834b-02507465a048	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.01957+00
783de558-5acd-4c54-80e1-f6b3fa3b3fb2	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	94	review	fad6dbfc-7de2-4476-b51c-750d501ffc7b	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.028617+00
f9231fad-e3f9-4c41-9e13-d850a1044233	5abc318c-dd54-4f4b-9498-69407fa70fe0	61	review	c7633ef4-e9d1-4caa-8b11-e833fe7c406b	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.038209+00
c9e68a0b-9f7d-46e8-a5b6-8a854245d62a	e115d60e-e348-4ec0-96b1-5247203a3b31	91	review	1f66b721-9c99-4104-8453-f74e26a97bd9	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.047132+00
6f2e7517-0e6f-437d-ade8-2b5b15889434	e115d60e-e348-4ec0-96b1-5247203a3b31	69	review	01d35acb-1c0d-4fb1-ba01-75c65fb455f0	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.056146+00
45ab5be3-78a0-4d73-b2a9-8dcf2a8687a1	d481280c-9d2c-4fe5-b549-0ec647499af5	65	review	0eaad796-af46-4fd7-9a52-6ef43f7285d4	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.065124+00
12ade6ac-733f-4d0b-9530-ded131023fc1	d481280c-9d2c-4fe5-b549-0ec647499af5	98	review	e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.073637+00
a6e1bfb4-c23b-43e6-b7e3-cc9ccef52234	d481280c-9d2c-4fe5-b549-0ec647499af5	65	review	f4f06ada-6682-426f-8345-50820fc29b9f	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.082948+00
8c13de06-0cdf-45d7-8943-7980d23730c8	706d3279-0e2d-40b0-aa1d-578c435f3b42	84	review	d8b70f29-6926-4660-8e24-b7e839a01364	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.090788+00
3e5d63aa-ac49-4f86-876c-cb330faaa242	b4cc310b-b857-4f04-a8d6-988cb89bc481	71	review	f66abedd-56d0-40bf-9528-ebe17d92ad37	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.09803+00
f0c433e9-933d-4bab-958a-b36be52ebf5c	b4cc310b-b857-4f04-a8d6-988cb89bc481	90	review	4acfd2c8-28d3-468d-b41c-26148c7b721b	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.1064+00
9bab8dc9-f184-4f6c-b323-cabd7e70aaae	6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	90	review	36fe1791-6e25-4546-a8ad-fbe83025788c	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.115202+00
774600a2-d63f-4342-91bd-48ef45f3a766	6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	61	review	b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.124471+00
fe778219-dd88-41d0-8c9f-5a0552d9fe7f	6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	83	review	74107e84-8b72-430e-bb87-8978a0369607	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.133903+00
3dfa898d-5528-4bfd-92a9-7f0c80e4e482	4a468db0-bb0d-4696-984a-a7e68ba0c80f	61	review	6c50d066-3f19-4e0e-851e-d022ff907c70	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.142343+00
93c451ef-3c38-48e7-9f5e-16e98f1015d7	fc410940-03db-4881-ba08-b2516b91b02a	86	review	45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.164557+00
63859e75-c894-4127-bc9e-a216de5fa035	fc410940-03db-4881-ba08-b2516b91b02a	59	review	0e07a3de-6603-4c96-befc-10baa022b55d	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.173591+00
6af7c856-fb8b-4843-849f-c2ff59bc16f3	352944b9-b107-418b-8420-ce5f98e1ed4f	70	review	156d587c-9c4a-4f17-af75-44f52003ae94	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.186733+00
68e9756a-a1ee-4bee-81dc-a4739313fedc	352944b9-b107-418b-8420-ce5f98e1ed4f	88	review	b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.196589+00
bd554679-3cc3-4364-b191-7bd320e11ebf	352944b9-b107-418b-8420-ce5f98e1ed4f	63	review	114b9d96-bd00-42cf-b7ac-d3261bb22d8d	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.205861+00
4294c294-a2ee-431f-86cb-c4a5a31de7ea	e5d58143-9ec0-43aa-b649-487b7168c422	93	review	c268bfdb-370f-4499-bb61-31f47d76af83	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.214924+00
03c0b840-7609-4a22-b4e6-0428d810a1b9	9ab9438c-f1c6-484e-8305-907dbf16d44d	64	review	9b112d12-582a-461c-b384-921294608edf	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.224171+00
47d11d2e-106a-43a5-9bd7-859abbc58340	9ab9438c-f1c6-484e-8305-907dbf16d44d	86	review	e292f08d-56e6-4181-adb9-0547d7e38bb4	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.232777+00
a0ef6b90-d369-413b-b28f-8bac81d1d2a3	412657a8-b0db-4dc9-a50e-e9358092e49a	89	review	80fbd6de-3bbe-450a-a76c-d99427f7e73f	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.241439+00
8df346e6-caed-4930-91ac-872a6ff9610e	412657a8-b0db-4dc9-a50e-e9358092e49a	70	review	65b6caac-5deb-410a-9d6c-b7c89718a49a	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.250229+00
fc5fdf66-2c71-4089-91e5-2cf0ecea436f	412657a8-b0db-4dc9-a50e-e9358092e49a	97	review	7af64dee-6253-4cc9-a415-7e7b09fb8f5f	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.258562+00
50315fde-d280-46fa-be97-d68cb54cfff1	48ca762c-7c2a-4525-8861-372e5c49cd6d	61	review	cc66ef4b-10d8-4c88-a875-7fd044894b61	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.26852+00
9ddddbb6-cbf1-41f2-9ccd-880d926fc151	7d012f0b-5aa8-4bf7-88f1-191a8ce0288c	94	review	f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.277109+00
9cf64485-40d4-4b85-b8d2-38f8708edd2e	7d012f0b-5aa8-4bf7-88f1-191a8ce0288c	70	review	3541824c-3878-457c-a2a2-d463275cb923	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.285379+00
09dc8727-7c97-4931-8139-20e94bed5146	cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	62	review	2a5d24c1-663e-48ae-93d7-1c176d632f39	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.294094+00
182dc553-4754-4342-8147-1af64f783f4a	cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	89	review	8b8d9163-6e91-4064-9a12-9c209112a14b	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.303351+00
af092d47-cf12-4cdd-8d3f-5a15b9c36313	cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	61	review	c593c54c-b8d7-4c10-ab20-cfc88375c5e1	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.312218+00
510975b7-7512-488d-8672-f84afc0c8211	43ea8459-f0f4-41fb-98e7-1714b9ce81ea	98	review	6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.320285+00
dec91bcb-b1ad-4785-b211-1826917ad61a	027161c5-87ac-425c-9ca9-e82f1007e47b	71	review	78912820-0591-4e12-a542-edc20172d705	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.329852+00
7ae99e57-3255-4c00-8bc5-4d503af54940	027161c5-87ac-425c-9ca9-e82f1007e47b	98	review	62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.339176+00
df19882c-0839-45cf-b093-cc7c49adce47	21b0e483-154e-4e6a-a9ca-3c56585e36b0	95	review	90e97409-0a49-4473-95a8-8c36818b566e	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.34996+00
59eb7541-bf0a-4a95-a99e-fd156d88fe95	21b0e483-154e-4e6a-a9ca-3c56585e36b0	59	review	1f68e0e5-5aee-4e65-ac90-030fceddf762	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.359205+00
8dc99c11-b707-4761-a732-f2ab79ffe9c1	21b0e483-154e-4e6a-a9ca-3c56585e36b0	94	review	4febb231-2806-4e16-8755-e092d92206d8	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.36731+00
d62382ff-b37d-4682-b213-ef82110b0cf7	1c19d853-8e34-4aab-b2d3-30db3dd91239	69	review	6f3c6697-ec65-4cc9-9f54-d6af30271b4a	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.376031+00
eaa4f0e0-0e2d-4e89-9004-93d53e18b18c	3fec7d15-2923-4f36-aaee-cb49b84a2901	99	review	515c1d52-978d-4e4d-92c7-a99a5b62d690	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.384186+00
a9ba8f8b-0624-48f3-8afe-6fba362ba4f1	3fec7d15-2923-4f36-aaee-cb49b84a2901	67	review	4dfba325-40ab-440a-96ff-794a78f627c5	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.393961+00
0632b35c-7d11-4d38-b385-60bf4bfa0f65	76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	59	review	6bcc520f-95e5-4ee1-8a64-2a381408e9c4	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.402968+00
f8a2c70f-aca0-4c5e-8575-032d3cc5aa88	76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	82	review	be4796ff-4e4f-4d30-9d71-8b98a825211e	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.411513+00
b1c36381-de2c-4b30-a9b3-3d9daf7b6e4a	76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	67	review	95adca7c-a568-4f0f-9783-2cf2ea5b3f08	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.421222+00
2ca05924-9b5b-4348-ae9c-7a87937392ee	38c4aba5-0612-4f86-aa76-a47db8320cff	93	review	5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.429824+00
2adb9f40-300b-429e-a710-a84eabc0bf68	3e38a0b3-aefb-4bf7-8a5a-24e03f590de3	68	review	c048f72a-b2ee-4172-b57f-6e61e25c323b	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.439136+00
7277f931-9206-478b-aa59-56789e006e30	3e38a0b3-aefb-4bf7-8a5a-24e03f590de3	88	review	325e95e1-cf75-4237-b192-4108dfb5b9ce	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.448304+00
6dec28bc-b99d-4d75-919c-26ed102b9371	8e19c3fb-7be8-4aa5-b5bd-af171861b57c	85	review	0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.457161+00
738adaf9-08c7-4a18-ad71-7ce67da81ce5	8e19c3fb-7be8-4aa5-b5bd-af171861b57c	62	review	b8e0723a-1a1e-495a-9182-778122c42f4b	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.465234+00
327af472-62b8-417a-bdfc-4fb52f5abae3	8e19c3fb-7be8-4aa5-b5bd-af171861b57c	97	review	d657581c-46ea-4bfa-bb37-3fe6ceb75d61	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.474564+00
fc75a2c7-170c-4137-b299-b96ec9a60476	28d15e56-e782-4bad-9ce9-9c479390cac4	68	review	246352f8-8aad-4b58-ac0e-8e95952af2a1	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.483233+00
172f54d6-3e79-4d72-98cb-9044840f49a6	bd9cf8c9-aa13-4139-ae09-789c33a46b33	82	review	66bc0d66-2a8f-439b-ab93-fdaa1a83056d	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.492456+00
5bff6010-17cb-4f50-90ef-a07d77d1e6af	bd9cf8c9-aa13-4139-ae09-789c33a46b33	62	review	1194ae8a-04b2-4479-bee7-afe012ff1090	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.501461+00
7291b740-81e6-4d3e-853a-278f82cc01ac	ab043822-4518-4915-b133-b9320ab0fd16	66	review	3f7da559-98d1-4bcc-8365-a075ebd290f1	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.509665+00
eba2b11e-5968-4fe3-8675-b4342a6df528	ab043822-4518-4915-b133-b9320ab0fd16	93	review	d13804bc-663a-4f64-8194-5bc500792242	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.519209+00
083e198d-04dd-4337-9287-bdf1cde555fe	ab043822-4518-4915-b133-b9320ab0fd16	68	review	766fc026-db0b-4ba2-bf65-aec3147ad9c1	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.527373+00
e7b3746f-3a13-4c9a-a18e-064b61480edd	104ac577-7486-41a2-8d57-1ff9792e7c1b	97	review	a6c50394-a89d-48ec-8e74-bea785ba2851	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.536934+00
d80f5e83-81d5-4550-b534-5814b628053b	f6c1113f-8c5d-4ebd-b8e6-1a306d832280	61	review	788d08fe-1793-40f6-8bcb-08bf7da77497	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.546215+00
a255814e-4b0e-4656-980b-adf9c3cb2277	f6c1113f-8c5d-4ebd-b8e6-1a306d832280	92	review	51d754be-acd8-4060-806a-83607ab58b41	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.556122+00
69c875c7-60c2-414b-ba45-9746357c16b5	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	98	review	7e4d6e75-b8f9-4817-8a60-996218899499	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.564762+00
42330e4a-4e52-4e63-ab41-22c890f501c3	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	71	review	177a5447-12a8-4949-8621-f08437390dba	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.574304+00
c7451c24-5f50-4aac-905d-0711bd07a041	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	97	review	c2083c67-18dc-450e-a93a-e2477b88e6d0	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.587155+00
d311d6ca-4d2c-4b06-ba60-0f7f3d70cd48	240e8cfc-eed0-44a4-89bc-d9145a6ebeed	64	review	b5efae7e-a07a-41c5-a0cd-76885114ee0d	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.5966+00
32ab3e90-0aac-4ef8-86c4-7af84eb573ba	5fdd91fd-1a88-4a80-aa84-1766dbf34344	87	review	bb8ffeac-9854-4601-9b47-98d4d0c86bb1	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.60842+00
28a6a226-e8c9-4d54-8be5-80b4147170da	5fdd91fd-1a88-4a80-aa84-1766dbf34344	65	review	b5d4b921-d02e-4af5-8f37-a8416813ad16	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.61832+00
157e2073-1093-4156-a6e5-e53f07088069	7eebcbb6-338d-4d54-b25e-dba123a39d2a	64	review	0eec84ee-7ce5-4400-83d2-a0d661751544	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.627289+00
474ffb10-cfed-421b-acc9-dffd88305d4c	7eebcbb6-338d-4d54-b25e-dba123a39d2a	96	review	fb95a422-edfb-4c45-bf2e-e65e8069c999	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.636004+00
7a9d7373-3a9f-471e-9550-6d0e4632f737	7eebcbb6-338d-4d54-b25e-dba123a39d2a	63	review	869178d9-d558-48a3-98d7-7774c3e523c1	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.64519+00
c8d04a05-c7de-447c-8064-75357b2f13c8	e46b6720-49db-4e3d-b6cd-d849cb0c9eeb	87	review	e2c095ee-3f78-4cbf-9606-d7551402dead	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.654992+00
10ccb2da-eee0-418b-b61e-369d311f12dc	edaa49fd-dd8c-4d7f-8ab3-2a8a01863e7f	66	review	9ee51098-feb5-49a0-9228-7465769e5fb8	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.663737+00
3d41e4ff-5c2f-4f3c-b785-70c62069579a	edaa49fd-dd8c-4d7f-8ab3-2a8a01863e7f	83	review	f9640389-d66d-4682-8bb5-2ece151c0108	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.673643+00
2b1c0148-15b9-4864-94cc-edd6f04f18ad	766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	88	review	a3bcc324-3431-42d0-bb72-97bf8a25f4c4	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.682524+00
0217c056-6078-4e85-87ce-7445df156c38	766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	62	review	8679c977-1114-4478-b6c1-8faef5a75997	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.691878+00
e9308897-4e22-460c-bac5-843a7ed5c7b1	766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	87	review	a5d8f3a9-0325-489b-90d2-195bf59756c0	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.701389+00
2aca6732-9470-4825-8201-ec1a65640b59	4987c977-6c68-4103-9863-6e0adfc4f276	66	review	dad0e79c-6c81-44f7-8647-4b0351d39ddc	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.710427+00
e2218507-911c-4106-834e-c4eff8cb424b	ad185731-3f7e-4950-a9af-01962006c9e0	95	review	ba01412a-a0ce-427b-938e-c9704654315c	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.719428+00
796fe6f4-b552-4bf7-b747-b8957aee5b53	ad185731-3f7e-4950-a9af-01962006c9e0	65	review	216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.727981+00
0860b359-a582-44cb-be43-35f7b177796a	e1d417cb-810f-49ae-8ea7-2eeac36ec593	71	review	247cd269-734b-4589-91a5-b112a67d9ad8	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.73664+00
f5eb6b01-3101-4017-bbf9-19ae996ed839	e1d417cb-810f-49ae-8ea7-2eeac36ec593	90	review	93484672-5ac3-4bc8-bf8f-c79db5bc16d4	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.746463+00
54f8edaf-24d0-46c9-8e5f-d39aa40e8c3c	e1d417cb-810f-49ae-8ea7-2eeac36ec593	59	review	8bf00840-696c-4021-bdc3-90cf0d30980c	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.755015+00
f1ad628e-d705-4205-8af4-7ed2f3ea4167	f3ca9228-81d7-4fd1-9f0f-abf29cbe5cfb	84	review	cade1e7e-bb65-4df8-bcaa-a8ff9385a378	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.763996+00
93486ca7-c541-452d-9fe4-4aa570da0ae9	71b28923-6de8-47ee-88b4-f235a2a6373f	67	review	35d629b6-d438-436f-a956-3a3320bbe26c	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.772794+00
f447a031-df57-4543-b6f6-d0797c7a38d6	71b28923-6de8-47ee-88b4-f235a2a6373f	95	review	a168986a-8bb6-449e-97df-2b50e115b53a	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.783032+00
41b9bd9f-aae2-40b4-9230-a5fb3e4f6818	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	91	review	29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.792622+00
a89b73b8-e576-409a-8cf5-d5cfb1a689ff	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	63	review	baff260d-e0e8-47bb-85da-68da285ffcc5	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.801138+00
2bf18694-c3e9-4765-a1fd-f02ed4876b6b	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	93	review	c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.809608+00
349c2e06-bd92-439a-9859-061b244786b9	11c233d8-13db-4b03-a065-b452f15b371a	60	review	1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.820677+00
9dd4e377-1b38-492a-931c-84ea41530ddd	64d8b8ef-cc91-4410-b2a9-d455a7c6a9f8	88	review	ec163ffe-d8df-4b63-9219-ddb6f4b49222	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.830331+00
f6ad9adf-6963-453e-9ff4-935147ff1721	64d8b8ef-cc91-4410-b2a9-d455a7c6a9f8	68	review	fc67de83-23d9-46d4-80ee-277c7ef2747e	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.839188+00
ba644665-249a-49e2-afa8-90dc6362dadd	17a2da93-6d4d-46a1-bb3d-ec5aa7850445	63	review	cfc482ed-c2d3-46d1-8791-128c5f34df76	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.848396+00
bf5985ac-29b6-4dfc-aa3d-d7f296c172a8	17a2da93-6d4d-46a1-bb3d-ec5aa7850445	92	review	283560ca-2bf6-445f-a2bb-4dbe12e61fd8	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.857675+00
b380b5f6-c085-487b-9eea-fd95b4c05b88	17a2da93-6d4d-46a1-bb3d-ec5aa7850445	63	review	598ecc55-d9aa-4326-afc8-623beef05841	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.870028+00
7d0474d5-080e-4b8c-94a7-8abfe829e9dc	1d3b38c3-dcfe-419c-ab19-744d2fe7733e	99	review	0f59293b-5e72-4ae5-8af1-34558e08341d	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.881359+00
dba8534a-d0b7-4932-8871-1a4fe68fc013	03cfc327-5d88-43c7-8612-31e7a5a8a833	60	review	f2906241-4a32-46c4-8612-66fd1653c851	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.892024+00
01e5ada2-1275-4bd6-ae67-7e34157dd987	03cfc327-5d88-43c7-8612-31e7a5a8a833	92	review	f2be7f80-5f81-472d-b8ce-05a7c9726b85	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.900168+00
3a127cdf-dc52-4c4f-ab82-40e3e0b8f49e	72d87e8e-f5c1-48e6-b047-c94fab9c7393	91	review	92c4832b-7c95-495d-ae94-f92b75728a43	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.908803+00
05f2d05f-68cb-4b25-b27f-b253b2e55f82	72d87e8e-f5c1-48e6-b047-c94fab9c7393	62	review	46c6188e-d270-48eb-b60c-9d3fb0391258	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.918393+00
9c3a7818-a64b-4912-a165-3b8f6058dcad	72d87e8e-f5c1-48e6-b047-c94fab9c7393	82	review	ae6e1545-240a-4613-be86-54051780e6cb	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.92848+00
adb76acb-d0b8-4e94-b9ac-6db19b6ec997	0d08839e-ebe9-4f14-b879-8c56c0044f33	63	review	5dcae94e-5a83-4b96-9b3b-55af29de54ed	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.941642+00
0880c35e-dbb5-4cb0-9dee-3cbb2471500c	7b982e66-76e6-438f-939a-77344b934380	81	review	de03a911-1330-4f3b-a2c4-6b6eadaac1b5	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.950652+00
b941f0e8-c683-4da9-88a6-c6b1547edca1	7b982e66-76e6-438f-939a-77344b934380	67	review	e271bc4e-f681-4fbd-b335-aa7cfd14114b	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.95892+00
12f4062d-5fae-4478-be18-5a6249d64e34	e7da5f29-e44a-4585-81fd-2244675f45fd	62	review	52aeec76-af5e-460e-81c9-e86700a009c5	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.96804+00
45ffc670-a5ce-4e75-9493-a1f16eb3d7e4	e7da5f29-e44a-4585-81fd-2244675f45fd	82	review	703fb958-cb27-4df9-96a1-7d5979921d55	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.976673+00
295bf63e-29af-4ea6-934e-e7610ebfdc66	e7da5f29-e44a-4585-81fd-2244675f45fd	63	review	173844bb-b248-4d89-86ad-37562e2f1590	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:32.987555+00
7316472f-6cde-4d79-bc3b-b214e382e7ee	39add4d6-53a8-4896-984f-f247a9d5a2b7	92	review	415bc80b-4ffc-45f6-95e0-75ae29c8bf05	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:32.997041+00
d2bb97cb-9fb0-4269-b527-07743861bbe5	f8bcd338-39b0-4186-830f-228e55604064	63	review	5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.006482+00
e47c884e-675a-4e3a-99c6-d8a6b7873c3e	f8bcd338-39b0-4186-830f-228e55604064	81	review	4532fc0a-4929-453c-9b7c-53b0267fdefb	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.01551+00
5d3b4e31-71a2-405d-b499-94c2985f8b45	b9c3be6b-8da0-4414-bf50-69410fa774bb	89	review	35188bca-4987-4cb6-a29e-1c5e2a325710	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.024741+00
8d8e1a7c-c255-41e1-9137-a436f5820830	b9c3be6b-8da0-4414-bf50-69410fa774bb	63	review	9074a1f7-6ffa-4bac-9e15-693f6219ae01	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.034466+00
d1f3401c-e5ca-439e-825b-0b7a9366be9f	b9c3be6b-8da0-4414-bf50-69410fa774bb	93	review	410a6c83-b8fd-4948-b839-77ecb801b209	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.04364+00
eda343a6-8be6-4619-97b8-818cfcd193d0	7b9e7324-16e7-4b01-944d-4f6ff9384366	65	review	c8dea943-2e1a-4575-90bc-244da15fefec	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.051898+00
545ccb6e-c130-4b2f-a58d-52e824a22ec4	8c7c19e3-3bd3-4b95-be5c-9f793d8db656	94	review	b604fd50-c0c9-4b7c-8b32-892518e7df64	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.062217+00
c0599196-a0bd-44ca-843a-c17f8bac4162	8c7c19e3-3bd3-4b95-be5c-9f793d8db656	60	review	977d50ea-7bf5-420d-abd7-90570ea155dd	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.070538+00
fe3200c8-3962-461e-a658-3d2778219bfb	9550b05b-35a6-40e9-af4d-c83a83a2a96d	62	review	4977a03d-d6ef-4840-a294-1037d4241336	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.080483+00
a911174a-2f0f-4987-bbdd-42c6aa51f185	9550b05b-35a6-40e9-af4d-c83a83a2a96d	94	review	b3989144-79e1-493a-b84e-46072edf1ccb	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.08913+00
bc07247e-1ee1-4951-a1f3-996206377cf4	9550b05b-35a6-40e9-af4d-c83a83a2a96d	67	review	998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.097832+00
d6428509-2ffa-4a91-910f-e3396d561cb2	d93b2055-e8b3-4438-bb78-b7f288ae6e2c	97	review	d3070228-9738-4934-b9f4-745ccb758fcb	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.107761+00
8f99ecf7-23ec-4313-af99-7c6f2303aefb	9f7fa566-ec18-426f-b374-86b4596716ac	64	review	abe5e74a-a60b-4dfb-a6fd-9973e375ff23	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.116426+00
54d394eb-7355-404c-9d17-5ef9564d2afc	9f7fa566-ec18-426f-b374-86b4596716ac	97	review	627e513e-fcbb-4517-ba73-9b138601ae62	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.137584+00
0527bb4c-c90f-4a68-9b0b-5f6cabc392d8	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	99	review	8882d436-cd20-4bfd-9c34-a28ad1263558	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.147045+00
25f65889-a881-47ef-b7f2-dab3a2fd0bb8	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	70	review	cef20cad-ff54-414b-9e73-97f6ff2d3a59	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.156443+00
6293c2c7-5e40-4ca7-ae17-f18674129bb4	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	94	review	e4d765b2-5044-49a3-be06-f6eceb49abd9	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.16564+00
edd3b993-c69e-4b89-8479-66b67d1e07ee	6890c0e7-eab0-4edd-8922-1186632c105b	60	review	32a962e5-ca81-4017-abc7-5c8060a04db7	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.175176+00
31ee12aa-f07f-4fb4-a510-a251bcb7aa10	a0d8b8d9-fb84-4b41-9928-aa4abfa255b4	90	review	f56f5f4d-247c-4747-94ce-755de5f352f8	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.183213+00
f9114d6d-0b35-4ff7-97c7-335d4f4ed0c9	a0d8b8d9-fb84-4b41-9928-aa4abfa255b4	61	review	df2e9b6b-45eb-439c-9773-e8d21122a513	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.192261+00
215c8fca-67b5-419a-a5e3-611624b3504a	4dfa4e2b-263f-4271-93c0-3e3af55a2f15	64	review	66c3be0e-e271-4cef-9f15-dac27663dca6	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.201551+00
d11c57b1-72f0-48ad-a4fd-c9c9eeb31638	4dfa4e2b-263f-4271-93c0-3e3af55a2f15	85	review	9dba5125-28d7-45d6-b0ae-d735a78494f5	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.210511+00
697f23c8-f642-4e61-9f78-fe443adf296f	4dfa4e2b-263f-4271-93c0-3e3af55a2f15	69	review	e2e9def1-a736-47c5-9c76-9855b343d5e0	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.218923+00
d08d8b62-8694-426a-b6ec-338461e51ec6	773a0438-e576-4ad7-b14f-5aefd011304c	88	review	30a69f7b-062d-4fe1-ae56-c89001007830	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.228441+00
031413f8-73c4-462e-97ec-94dda953b26e	3a5b9d93-ed69-4d00-8ab2-8122511c2ec2	63	review	91084e76-306a-424f-a5a7-be098480ea96	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.237728+00
10ed96a6-df2b-44d4-a23d-8653aea9f831	3a5b9d93-ed69-4d00-8ab2-8122511c2ec2	95	review	a6d2d43a-550b-4b26-89bd-c9479dd35e5c	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.247303+00
2fcc71e5-6b0f-466f-8fe3-ef54c65ceda2	3d6078c0-3a00-4652-8a0f-0aea34ef2e16	86	review	a20a39ae-7136-4fab-a55b-a85cb05c8b24	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.256076+00
8dd66f11-906f-47c5-baab-5701e310be93	3d6078c0-3a00-4652-8a0f-0aea34ef2e16	65	review	3d27283c-4903-46ca-8a18-8f5c6fb38602	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.265137+00
5d8ce7dc-bdb7-4474-829d-e3689b6472fb	3d6078c0-3a00-4652-8a0f-0aea34ef2e16	93	review	a3305cb0-3cca-44a9-884b-94063b8de50a	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.273445+00
e0923e5b-93f4-46f8-b3c5-686e282a4547	641e883e-1fcc-44d7-b61f-45bf45daae83	69	review	87998689-c9ed-4a2c-8c0a-cd047d3787b0	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.282597+00
d9013ef4-7f97-491e-96ab-5b55fb482362	2d6bf6ed-8785-41e6-a41a-0f80907edeb0	90	review	b4b24a11-2c4b-42cb-9119-8a60b46ce117	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.293431+00
3035fd5a-0ed9-434e-857b-96691dd1fe8f	2d6bf6ed-8785-41e6-a41a-0f80907edeb0	60	review	a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.302571+00
b9dba3a0-9a0f-4cce-873a-ae5049b5fcab	221c08f9-07f2-4b22-a19a-86db67c5c7ba	66	review	b37e1b83-3b15-4313-839d-6224a90b9ff9	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.311426+00
14010659-89ec-427a-ad8b-e523d3e552fa	221c08f9-07f2-4b22-a19a-86db67c5c7ba	93	review	a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.321048+00
83546362-bc12-48f0-85df-330337a03f7b	221c08f9-07f2-4b22-a19a-86db67c5c7ba	65	review	4201927d-7141-4612-aae3-c4ba21761d67	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.331335+00
f58447cd-717d-4ba1-bbbe-c66507d21fed	5ac1cdcd-c7bf-42b3-bc27-96aa3b745080	87	review	553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.341036+00
ef66d740-b355-47d1-b87f-fc0bd658403f	9221e178-bf98-4523-9701-37a463c71ff5	63	review	0ba32da1-325e-4cf2-a80b-6253906c65d5	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.350392+00
7a01684b-2458-44c0-bebb-5f0030832565	9221e178-bf98-4523-9701-37a463c71ff5	93	review	f6ea718e-4222-47ed-bcd1-b86c3c4aee33	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.359786+00
7b4c4ecd-bd14-4fe6-bcba-30f76d742a78	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	93	review	22c898e0-fa78-4295-851e-37023f60ecc5	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.369268+00
d880ad19-4537-4657-bff6-9f9b15b088f9	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	64	review	9a3f6aeb-47d0-433d-bec9-db5d8eb238be	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.378584+00
29ae1527-c4e1-49ed-a8c4-fbc0208416ab	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	98	review	d8b58fb7-6847-4b92-af14-c57a6992a0e3	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.387785+00
d216c329-6c7d-418e-b9aa-8edfa4c03bc8	fc553e0f-1b13-4104-93b7-db4d61313ca1	70	review	5bc1e70c-516f-450e-b621-a690072cb520	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.396422+00
4079748d-db61-4d24-ade4-94abb351159e	b015caff-4ca4-4999-9acf-b99c11df8215	93	review	fd4c4135-2ae3-45ad-98f4-665c40358d53	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.405126+00
65c69b49-8b36-41cb-a40f-810eadd132a4	b015caff-4ca4-4999-9acf-b99c11df8215	62	review	63b866f3-85d9-4109-baea-e31f82852fe2	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.415489+00
577f64fd-2294-48eb-8e5b-adfedd3685ea	9014881d-e2e6-49b3-b386-4883f4e380ba	61	review	d2beef58-ab46-430f-ac2a-00e12818f8c2	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.424146+00
5ca0a273-3171-4f54-891e-0ec43084c2f5	9014881d-e2e6-49b3-b386-4883f4e380ba	87	review	734290b2-d00a-4d9e-953e-cbaaca25247a	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.43418+00
974efcd3-9f62-4dbc-957f-d3aa87d8df35	9014881d-e2e6-49b3-b386-4883f4e380ba	66	review	20acd977-8ac6-4ab6-9585-9d3c8827bb98	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.443594+00
71717760-451b-4311-af66-cb09575d7ecc	8a22e5e3-618d-4e9d-a8e6-83aa38ecae41	93	review	eb6c03b6-516b-48ed-b206-d9c83a15129c	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.452157+00
b032a5a2-84f8-4ccc-90a5-da8e1d421282	5b90a702-4abe-4847-8549-70228af35bc5	59	review	db8e306b-483d-4651-9066-bb63e3b92c9d	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.462231+00
e966c48b-0380-43ea-bf94-9aef76408b93	5b90a702-4abe-4847-8549-70228af35bc5	95	review	b837b636-d54e-477a-90af-e493cd94ab47	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.472552+00
059616d4-aa6d-4d26-adc6-e16eaf3121dc	15753795-0698-4fd8-898d-cd03f4ee0a9e	94	review	84dfaac3-c40f-47ab-862a-6463665a6f60	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.480908+00
0b70d812-6bb8-4bf6-9944-72afb860d506	15753795-0698-4fd8-898d-cd03f4ee0a9e	61	review	6bffd0bb-4656-48f2-88dc-0d78419ba453	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.489977+00
6b2d34ca-ecbd-4b5b-8ca0-58fe3d85e707	15753795-0698-4fd8-898d-cd03f4ee0a9e	94	review	05e0d3a5-6806-4d6f-9864-f88f2eb0b917	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.498646+00
fb15cd28-fed3-4ddc-8ace-d30da7f9ca2d	9c4ae611-b83a-4f21-bbc9-c2f5115feed2	59	review	1d238bb8-7afd-4d31-b56e-57cd8831025d	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.508972+00
4e6fecf4-def1-4b98-b690-9ded088652be	575a77de-f3b5-4fcf-a3b7-bb3c71766358	85	review	adea2112-7829-48ad-9f0b-3c3dc8c08d28	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.517485+00
91fcfc01-332e-4e7f-9350-dce0bf6147a7	575a77de-f3b5-4fcf-a3b7-bb3c71766358	70	review	b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.526804+00
2f4449f0-5065-4520-99e2-d73ac9f96bc9	f90ee443-8fcf-4dbb-aeaa-273e90484c41	68	review	48b7da8c-a0d4-4636-b810-75a3e9eb08d3	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.536266+00
db718c9f-2ffa-4f2b-baf2-4e74055775f3	f90ee443-8fcf-4dbb-aeaa-273e90484c41	92	review	325fa6ac-a019-4517-a701-d21afb713a6d	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.546082+00
90a38000-f69f-4bb6-9147-1b29f38adbd4	f90ee443-8fcf-4dbb-aeaa-273e90484c41	69	review	fd98f02a-fe56-4913-aa50-2253cd443515	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.555764+00
a821a21d-f375-4845-9a14-66e64e79ff0c	c3bd05bf-c22f-422b-91bc-b4ee405913fd	84	review	97f7f26e-f082-4c4d-b2dd-27e0a4062d83	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.564977+00
4617404e-6cdc-4f56-b532-f160e3d278ac	430fef7b-211e-4617-a19d-7feafd030d6c	61	review	eb9bd312-f0ac-417b-b844-e54cf4e075fb	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.573337+00
99022e25-6d49-4bc0-ba83-133583fe6356	430fef7b-211e-4617-a19d-7feafd030d6c	92	review	dd77da3f-6285-4045-83db-91807ac9b749	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.583067+00
954df9f5-1400-49ff-9ed3-74bba78e8afb	f4456d9b-7c4e-4a9c-9f23-b6139bf60906	90	review	b970045c-2c1e-4042-8d10-3f4fcb44326c	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.592174+00
8875bcda-5cb6-42e8-b76b-5980bb83af22	f4456d9b-7c4e-4a9c-9f23-b6139bf60906	71	review	b43d393b-18fd-4222-84be-e9a02d4f4014	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.601242+00
9c3b9483-e784-49b4-8178-df3c913442c9	f4456d9b-7c4e-4a9c-9f23-b6139bf60906	83	review	8a449245-6285-4e9c-b412-713b4ec40f9d	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.610087+00
d9dad5ce-8d1f-493c-8548-8313ee1e39b0	9064b7c5-d14e-43d5-ac45-21518e4a1502	70	review	20ec81ca-6a65-475a-9897-2b67712fd4bc	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.618929+00
e957471a-161f-4936-8a47-bc2b6c286768	e7f044e8-487b-4995-83b7-0900b6aab267	94	review	4de05ad6-46bf-4a09-b484-fc40bbfd8e23	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.627725+00
431d0a80-b5d4-4dce-b36a-c51b8377e979	e7f044e8-487b-4995-83b7-0900b6aab267	67	review	525414ea-3ff1-446d-8e5e-74f03b6bb4ec	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.637383+00
98d32a87-87a5-4f65-9078-aa0bb0d82fff	0a708c77-9b65-4843-aac8-a4da7a150572	68	review	e0728c97-46d0-4171-a257-436008b88a65	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.647357+00
909c9a39-0a5b-4106-a2e2-d7d66d073c9d	0a708c77-9b65-4843-aac8-a4da7a150572	98	review	f2c5b24a-7002-4cf0-9ebd-4817ab110300	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.656332+00
508e9bb1-40bd-4df8-b897-8c4eb104b4df	0a708c77-9b65-4843-aac8-a4da7a150572	67	review	36ce9f6d-dd95-4e25-b630-62db3e81d957	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.665471+00
6e70642b-bc30-49b0-b7da-eabd5554ed59	259b82b4-1ffb-477f-add3-15b08f061e2d	84	review	197bb758-943a-48a1-b906-591277454a13	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.673981+00
3972c615-42ad-4048-aed2-beb1f346049f	c0e4a2c4-cd8a-4dcd-9f99-89d0019a24fb	70	review	5a98bf41-39db-4f91-9c9f-5df5d4b211aa	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.684405+00
71d9e5bc-2e98-462b-a46a-8b6ea369ad30	c0e4a2c4-cd8a-4dcd-9f99-89d0019a24fb	90	review	f01440cc-3ec2-449a-874d-3972827d2d2b	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.693609+00
d798a76a-4477-42cd-bf56-a5faa10ab57c	7f8d51b9-6769-40a2-8690-48eabb1fc122	97	review	7a165eff-7218-42c5-a7d0-a22c3f8058be	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.704568+00
2f876d9b-e9c3-4341-9f43-85adf1ff8b51	7f8d51b9-6769-40a2-8690-48eabb1fc122	68	review	e27dfc85-f62d-4cf5-b07c-80800fe861da	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.713706+00
9e8b2994-e648-4b9c-87ce-ca11f5034081	7f8d51b9-6769-40a2-8690-48eabb1fc122	93	review	9c31935b-68b4-49e0-85cf-bf1453603d04	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.723362+00
331350e3-cdb9-41e3-9d0b-b76cbcf54399	5401247a-d1c6-4747-aef1-6fac25c8a188	69	review	091c6288-f640-465b-b89f-73d708be0798	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.732475+00
2f749dfc-d11a-45e3-83e9-1cdf6a412226	4fee828d-a7c5-4a87-bd4d-ed04decf7bdb	94	review	ddd34d9f-8979-4095-90e7-57a0037e7f35	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.741201+00
2eac2e3f-5720-45c8-b258-2f1fc07f4704	4fee828d-a7c5-4a87-bd4d-ed04decf7bdb	63	review	b5403e89-71c6-4a98-ae9a-8aa225be72bb	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.749246+00
7c3e1384-ea13-494d-8aa7-feecf8522db0	b0c8b78d-e858-4e7c-9a07-14d288480618	59	review	862825fc-bdde-41ba-8a71-c43dcae272d9	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.758836+00
611f68b6-5535-4de5-8864-2311f56c7b13	b0c8b78d-e858-4e7c-9a07-14d288480618	86	review	97826de9-5942-48db-a55e-190c0fdd6abd	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.767512+00
8b36fb6b-326a-4a9f-a232-5db2a683885c	b0c8b78d-e858-4e7c-9a07-14d288480618	63	review	d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	Completed review for "Dangote Cement — Building Nigeria"	2026-05-04 11:14:33.776308+00
36b0903d-fe83-49f7-81c1-cfd3a648b0ee	a350339b-d835-42f1-8e65-fcc50920a097	87	review	7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	Completed review for "Dangote Group — Africa's Pride"	2026-05-04 11:14:33.784376+00
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, ad_id, sort_order, question_type, question_text, options, created_at) FROM stdin;
d08a9ee3-d26e-4ea1-b71a-0298849ed8d0	b816c046-cefc-430c-a25b-6c35f958302d	0	multiple_choice	Before watching this ad, how familiar were you with MTN Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.437332+00
fda1f591-a17b-498b-8f16-7a34efaa041d	b816c046-cefc-430c-a25b-6c35f958302d	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.442574+00
8423a757-2e19-418d-a87d-46180f683eb7	b816c046-cefc-430c-a25b-6c35f958302d	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.445246+00
b5909cfb-41b0-4124-b371-d60fc3002dbd	b816c046-cefc-430c-a25b-6c35f958302d	3	rating	How likely are you to try or use MTN Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.448375+00
45102780-83b3-45a2-af08-b2ba96c548a7	b816c046-cefc-430c-a25b-6c35f958302d	4	multiple_choice	After watching this ad, your impression of MTN Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.451859+00
35fb7149-0870-46d8-a1d2-f2dc1c50cf42	b816c046-cefc-430c-a25b-6c35f958302d	5	multiple_choice	Which mobile network are you currently subscribed to?	["MTN", "Airtel", "Glo", "9mobile", "I use multiple"]	2026-05-02 19:20:51.454195+00
a562b821-92db-48d6-b793-9b53304a9074	b816c046-cefc-430c-a25b-6c35f958302d	6	multiple_choice	What matters most to you when choosing a mobile network?	["Network coverage", "Affordable data bundles", "Fast internet speed", "Customer support", "Value-for-money offers"]	2026-05-02 19:20:51.457183+00
fb9d4254-d2b3-490d-ad52-161347f104a5	b816c046-cefc-430c-a25b-6c35f958302d	7	open_text	In your own words, what is the single most memorable thing about this MTN Nigeria ad?	\N	2026-05-02 19:20:51.460837+00
7b9e414f-b07d-4701-b8e6-f00a445f9f5d	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	0	multiple_choice	Before watching this ad, how familiar were you with MTN Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.465155+00
ce850cd7-863c-4783-bda9-a56fd0882c04	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.467766+00
167c2716-a48d-43db-92ca-c21df0cdcf64	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.470541+00
24a8207b-a93b-434b-a098-97f174fd9c17	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	3	rating	How likely are you to try or use MTN Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.473353+00
ec7559c9-bea4-4297-8434-cd2a19a09cb4	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	4	multiple_choice	After watching this ad, your impression of MTN Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.476898+00
6e8a5baf-2a95-45e3-8f8c-24469c7f9ad6	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	5	multiple_choice	Which mobile network are you currently subscribed to?	["MTN", "Airtel", "Glo", "9mobile", "I use multiple"]	2026-05-02 19:20:51.479609+00
d457646f-b85c-4b80-b22a-c495335121f1	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	6	multiple_choice	What matters most to you when choosing a mobile network?	["Network coverage", "Affordable data bundles", "Fast internet speed", "Customer support", "Value-for-money offers"]	2026-05-02 19:20:51.482912+00
c3127aeb-59f3-4470-932b-9a3401e253df	c1cab6b8-e3bc-47b6-8548-cc680334e9e4	7	open_text	In your own words, what is the single most memorable thing about this MTN Nigeria ad?	\N	2026-05-02 19:20:51.48607+00
520ad1a4-e033-4482-be59-2d78fc0041bf	14b04d8c-bc32-4d08-888b-0fbe91892099	0	multiple_choice	Before watching this ad, how familiar were you with Airtel Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.489266+00
fdee17e4-5f9b-4d64-830b-488dd10a6ecb	14b04d8c-bc32-4d08-888b-0fbe91892099	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.491773+00
9a63a3e4-a6d7-49f8-a017-0b2550aa6585	14b04d8c-bc32-4d08-888b-0fbe91892099	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.49497+00
4dac6c2e-4f6a-4986-8466-db587ac29be0	14b04d8c-bc32-4d08-888b-0fbe91892099	3	rating	How likely are you to try or use Airtel Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.497883+00
b8a1e92a-20c5-4300-9885-6d1c121e79a5	14b04d8c-bc32-4d08-888b-0fbe91892099	4	multiple_choice	After watching this ad, your impression of Airtel Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.500554+00
60b9b9f5-eaf5-484f-aa12-287861253cc3	14b04d8c-bc32-4d08-888b-0fbe91892099	5	multiple_choice	Which mobile network are you currently subscribed to?	["MTN", "Airtel", "Glo", "9mobile", "I use multiple"]	2026-05-02 19:20:51.503336+00
bf83edcc-bacf-457d-b3f0-69be3d739f23	14b04d8c-bc32-4d08-888b-0fbe91892099	6	multiple_choice	What matters most to you when choosing a mobile network?	["Network coverage", "Affordable data bundles", "Fast internet speed", "Customer support", "Value-for-money offers"]	2026-05-02 19:20:51.505234+00
6f3ea69a-0d43-40f2-8435-b0c9b17f552a	14b04d8c-bc32-4d08-888b-0fbe91892099	7	open_text	In your own words, what is the single most memorable thing about this Airtel Nigeria ad?	\N	2026-05-02 19:20:51.50808+00
14ff0d92-b4ec-4a7c-8b2a-488e171a07d4	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	0	multiple_choice	Before watching this ad, how familiar were you with Airtel Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.511738+00
04f27047-39ab-443e-ad34-3863b28dfeb5	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.514975+00
934b12ef-2765-405e-abc2-7dc19a343835	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.517301+00
d9d68717-a455-4474-a7bc-b0ce57a178dc	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	3	rating	How likely are you to try or use Airtel Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.519714+00
7df412c8-5fc0-4728-b3b1-2db4b1beb0c7	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	4	multiple_choice	After watching this ad, your impression of Airtel Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.521709+00
684311b9-ea19-4718-90fd-fb3acdaa1e23	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	5	multiple_choice	Which mobile network are you currently subscribed to?	["MTN", "Airtel", "Glo", "9mobile", "I use multiple"]	2026-05-02 19:20:51.523637+00
1fe56c9a-6e06-42dc-a2f4-c263e176fd53	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	6	multiple_choice	What matters most to you when choosing a mobile network?	["Network coverage", "Affordable data bundles", "Fast internet speed", "Customer support", "Value-for-money offers"]	2026-05-02 19:20:51.526752+00
4f6c6c78-ade7-4a94-a159-2cd1b52cd682	374c69af-4d8e-46d7-8722-dcb86b5ea2f7	7	open_text	In your own words, what is the single most memorable thing about this Airtel Nigeria ad?	\N	2026-05-02 19:20:51.532748+00
4bdae91c-6741-47e8-8679-07d20f3dc45c	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	0	multiple_choice	Before watching this ad, how familiar were you with Guinness Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.535861+00
b6fa7567-f026-475a-8e63-9f6613ea09ae	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.538575+00
777938dc-062d-452d-b87d-7966be80a0ce	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.541689+00
36205061-e0c7-4591-9d79-000b9369d029	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	3	rating	How likely are you to try or use Guinness Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.544049+00
0eac2072-2ff0-4b94-ac4e-0d95cfc723ff	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	4	multiple_choice	After watching this ad, your impression of Guinness Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.546495+00
888157fe-6a0d-4b3b-be4b-d21863f82c72	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	5	multiple_choice	How often do you consume alcoholic beverages?	["Several times a week", "Once a week", "A few times a month", "Occasionally / social events", "Never"]	2026-05-02 19:20:51.548924+00
1800931f-4de2-417f-9766-f8608aaaeac1	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	6	multiple_choice	What's your preferred type of alcoholic drink?	["Stout / dark beer", "Lager beer", "Spirits / whisky", "Wine", "I don't drink alcohol"]	2026-05-02 19:20:51.55199+00
40096d66-e3b4-4c58-a667-68f05676950b	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	7	open_text	In your own words, what is the single most memorable thing about this Guinness Nigeria ad?	\N	2026-05-02 19:20:51.55523+00
1104b704-0d13-437d-958c-1bcdac0858d0	c1fe2aec-5508-4711-990d-3dbc1fb761e0	0	multiple_choice	Before watching this ad, how familiar were you with Dangote Group?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.558837+00
e143a94c-4739-4e80-a6f9-e02e0e05938e	c1fe2aec-5508-4711-990d-3dbc1fb761e0	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.560746+00
4b941580-6d06-4c52-926b-9a6cad7eb761	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.563135+00
df03dc38-9011-471a-9c14-e2f7e97d12e1	c1fe2aec-5508-4711-990d-3dbc1fb761e0	3	rating	How likely are you to try or use Dangote Group in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.565714+00
1fa12770-4c88-4b1c-9a5d-9b51a0f1e683	c1fe2aec-5508-4711-990d-3dbc1fb761e0	4	multiple_choice	After watching this ad, your impression of Dangote Group is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.567819+00
36302c68-7999-4abb-a2f0-7d51f757801d	c1fe2aec-5508-4711-990d-3dbc1fb761e0	5	multiple_choice	Are you involved in any of the following sectors?	["Construction / Real estate", "Manufacturing / Industry", "Agriculture / Food production", "Logistics / Transport", "None of the above"]	2026-05-02 19:20:51.570939+00
c48e791f-c727-46ce-b872-cfe535262db6	c1fe2aec-5508-4711-990d-3dbc1fb761e0	6	multiple_choice	How do you feel about Nigerian-owned businesses competing globally?	["Very proud and supportive", "Positive but cautious", "Neutral", "Sceptical about quality"]	2026-05-02 19:20:51.57365+00
85d46e14-1258-44db-8c69-be4f7888de87	c1fe2aec-5508-4711-990d-3dbc1fb761e0	7	open_text	In your own words, what is the single most memorable thing about this Dangote Group ad?	\N	2026-05-02 19:20:51.575951+00
773f200e-2d4b-4bb8-bcf1-349141603877	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	0	multiple_choice	Before watching this ad, how familiar were you with Dangote Group?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.579248+00
5fab2044-c664-4ace-85f0-79099de6b4fa	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.581893+00
37909205-6195-4f87-bdd3-e942e1fa38e2	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.584473+00
553f5653-6e53-4e10-9b12-8f933df889fc	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	3	rating	How likely are you to try or use Dangote Group in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.58697+00
c7611a11-c94f-4fb3-9c1f-80b7817f078d	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	4	multiple_choice	After watching this ad, your impression of Dangote Group is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.589844+00
159e18e5-f8d4-4e78-b771-05bdec42ca1b	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	5	multiple_choice	Are you involved in any of the following sectors?	["Construction / Real estate", "Manufacturing / Industry", "Agriculture / Food production", "Logistics / Transport", "None of the above"]	2026-05-02 19:20:51.592348+00
85ba0f3b-7556-41a8-ba2e-73d121bc7f92	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	6	multiple_choice	How do you feel about Nigerian-owned businesses competing globally?	["Very proud and supportive", "Positive but cautious", "Neutral", "Sceptical about quality"]	2026-05-02 19:20:51.595291+00
0ce0c6d6-8bf8-4eb6-a036-98cde250e436	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	7	open_text	In your own words, what is the single most memorable thing about this Dangote Group ad?	\N	2026-05-02 19:20:51.597838+00
930e61b6-59e4-42a7-80d0-ee9fdf21ada5	738c03da-61f1-4a1c-8f01-20d1291976c1	0	multiple_choice	Before watching this ad, how familiar were you with Jumia Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.601659+00
96030378-ec7c-4bb7-96ed-3091f45e894e	738c03da-61f1-4a1c-8f01-20d1291976c1	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.604562+00
3b01a1cd-39c2-4a7b-8e1c-b261afd29f82	738c03da-61f1-4a1c-8f01-20d1291976c1	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.608355+00
9bc7492f-bd02-4291-803a-4f7530cf1ca4	738c03da-61f1-4a1c-8f01-20d1291976c1	3	rating	How likely are you to try or use Jumia Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.611206+00
07db265f-94ef-4b9a-9166-460871bbe353	738c03da-61f1-4a1c-8f01-20d1291976c1	4	multiple_choice	After watching this ad, your impression of Jumia Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.613817+00
1af1f8e0-90c0-4a7b-978d-1ed6de7b0f25	738c03da-61f1-4a1c-8f01-20d1291976c1	5	multiple_choice	How often do you shop online?	["Weekly", "Monthly", "A few times a year", "Rarely", "Never – I prefer physical stores"]	2026-05-02 19:20:51.616291+00
9595b7b4-24cd-453d-8f67-725a444d5107	738c03da-61f1-4a1c-8f01-20d1291976c1	6	multiple_choice	What's your biggest concern when shopping online in Nigeria?	["Fake / substandard products", "Delivery delays", "Payment security", "Poor customer service", "I have no major concerns"]	2026-05-02 19:20:51.618935+00
ac8be9a9-e646-40a8-a999-a676f8207605	738c03da-61f1-4a1c-8f01-20d1291976c1	7	open_text	In your own words, what is the single most memorable thing about this Jumia Nigeria ad?	\N	2026-05-02 19:20:51.621436+00
a45f836f-1e28-4560-95d6-dd9de5434349	e67e8615-3271-4803-a62b-88d366d64b1d	0	multiple_choice	Before watching this ad, how familiar were you with GTBank Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.625235+00
56615175-a6b9-4532-a409-12d9ea95caea	e67e8615-3271-4803-a62b-88d366d64b1d	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.627501+00
231084a8-11e4-4e4f-9a67-6d68df4a123b	e67e8615-3271-4803-a62b-88d366d64b1d	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.630309+00
507249d0-0829-4e30-8f05-19f6d562e100	e67e8615-3271-4803-a62b-88d366d64b1d	3	rating	How likely are you to try or use GTBank Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.633032+00
53891118-61c3-4566-bf56-205863500883	e67e8615-3271-4803-a62b-88d366d64b1d	4	multiple_choice	After watching this ad, your impression of GTBank Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.635096+00
09edeb42-d0d8-4b4a-ae91-ddfbadb6eef7	e67e8615-3271-4803-a62b-88d366d64b1d	5	multiple_choice	Do you currently use GTBank for banking?	["Yes – it's my main bank", "Yes – but as a secondary bank", "No – but I'm open to it", "No – not interested"]	2026-05-02 19:20:51.639085+00
0cc02740-bdd9-49e9-a29f-12d61a35afc7	e67e8615-3271-4803-a62b-88d366d64b1d	6	multiple_choice	How do you prefer to do most of your banking?	["Mobile app", "USSD (*737#)", "Internet banking", "Branch visit", "POS / Agent banking"]	2026-05-02 19:20:51.642053+00
3b660e60-99c6-4072-8c77-8bf540e2d538	e67e8615-3271-4803-a62b-88d366d64b1d	7	open_text	In your own words, what is the single most memorable thing about this GTBank Nigeria ad?	\N	2026-05-02 19:20:51.643999+00
56e8926a-08a5-4ee5-8815-0f0cedbe3344	ac7bc6c8-9e8a-4339-be22-96a688c0389f	0	multiple_choice	Before watching this ad, how familiar were you with Indomie Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.648083+00
1be59220-6412-42c1-b1de-14d5cad07083	ac7bc6c8-9e8a-4339-be22-96a688c0389f	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.650622+00
8eb02087-1a96-4b08-9f58-28aa0c9677f8	ac7bc6c8-9e8a-4339-be22-96a688c0389f	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.653782+00
aba4eecb-e978-491b-983f-fe9fb7cf5aa0	ac7bc6c8-9e8a-4339-be22-96a688c0389f	3	rating	How likely are you to try or use Indomie Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.656052+00
9bb5bd51-b7ac-43fb-867e-e390784c7a2c	ac7bc6c8-9e8a-4339-be22-96a688c0389f	4	multiple_choice	After watching this ad, your impression of Indomie Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.658849+00
f7e2c3e9-8842-48c7-83b2-fe6d6d9a89bb	ac7bc6c8-9e8a-4339-be22-96a688c0389f	5	multiple_choice	How often do you eat Indomie noodles?	["Daily", "Several times a week", "Once a week", "A few times a month", "Rarely"]	2026-05-02 19:20:51.661385+00
52df006a-2acb-4138-9a42-3bbd925852c1	ac7bc6c8-9e8a-4339-be22-96a688c0389f	6	multiple_choice	Where do you most often buy Indomie?	["Supermarket / shoprite", "Neighborhood provision store", "Open market", "Online delivery", "Not applicable"]	2026-05-02 19:20:51.664775+00
2da73bf4-af42-4084-b3b2-ae7630e2e8f7	ac7bc6c8-9e8a-4339-be22-96a688c0389f	7	open_text	In your own words, what is the single most memorable thing about this Indomie Nigeria ad?	\N	2026-05-02 19:20:51.668532+00
14c7a7de-a519-443f-91a8-263212878c8e	5f85fa0b-6587-4856-912f-9772585b97d9	0	multiple_choice	Before watching this ad, how familiar were you with Indomie Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.672113+00
27a0c9c9-dba4-4982-9db2-e8c59b3b7c21	5f85fa0b-6587-4856-912f-9772585b97d9	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.674375+00
52f3ee3c-f7c7-4201-95a1-c89449c7391e	5f85fa0b-6587-4856-912f-9772585b97d9	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.676837+00
5c600def-a6f1-4f0d-bab6-1d61b8f7157c	5f85fa0b-6587-4856-912f-9772585b97d9	3	rating	How likely are you to try or use Indomie Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.679712+00
fafea411-e85e-4949-8a77-6a82a47ef35e	5f85fa0b-6587-4856-912f-9772585b97d9	4	multiple_choice	After watching this ad, your impression of Indomie Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.682236+00
472b5d89-0066-4009-bed0-b698c6e0c1a7	5f85fa0b-6587-4856-912f-9772585b97d9	5	multiple_choice	How often do you eat Indomie noodles?	["Daily", "Several times a week", "Once a week", "A few times a month", "Rarely"]	2026-05-02 19:20:51.685057+00
19b0120f-42b9-4ff8-a8a9-82729ebb6124	5f85fa0b-6587-4856-912f-9772585b97d9	6	multiple_choice	Where do you most often buy Indomie?	["Supermarket / shoprite", "Neighborhood provision store", "Open market", "Online delivery", "Not applicable"]	2026-05-02 19:20:51.687498+00
94dc107d-5ff5-4479-85af-01bb91f31a54	5f85fa0b-6587-4856-912f-9772585b97d9	7	open_text	In your own words, what is the single most memorable thing about this Indomie Nigeria ad?	\N	2026-05-02 19:20:51.690001+00
e113ad20-d798-4415-a713-dcc19d013673	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	0	multiple_choice	Before watching this ad, how familiar were you with Peak Milk Nigeria?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.693556+00
1636c5dc-572c-4aa6-88d9-19a18f10af73	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.69603+00
762e5e49-4f62-475e-b6ee-557af56acb66	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.69859+00
1c075a4c-6345-461a-b390-808ab57157ee	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	3	rating	How likely are you to try or use Peak Milk Nigeria in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.701143+00
8557c677-5f4b-48e8-9e3f-b52e2d4abd6b	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	4	multiple_choice	After watching this ad, your impression of Peak Milk Nigeria is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.703499+00
c399d25c-e989-49e0-8fef-7faf0e870018	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	5	multiple_choice	Which dairy product do you use most at home?	["Peak Milk", "Other evaporated / powdered milk", "Fresh / pasteurised milk", "Plant-based milk", "I don't use dairy"]	2026-05-02 19:20:51.705869+00
e64d7ab1-3c4c-4ea3-9768-6e2bfdde544e	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	6	multiple_choice	Who in your household consumes the most milk?	["Children / babies", "Teenagers", "Adults", "Elderly family members", "Everyone equally"]	2026-05-02 19:20:51.709099+00
40d5df9e-0931-4fe4-a6bf-c432359fe7b1	01a9ccfb-b249-466b-a5d3-cd0bba85f1b7	7	open_text	In your own words, what is the single most memorable thing about this Peak Milk Nigeria ad?	\N	2026-05-02 19:20:51.71173+00
86472dd1-aacd-446a-af3d-839fb7cd4562	301643d2-f5c4-461e-9df9-c47f64cfeeed	0	multiple_choice	Before watching this ad, how familiar were you with Flutterwave?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.714933+00
6c5ef525-8845-42cf-a81d-3290aade9656	301643d2-f5c4-461e-9df9-c47f64cfeeed	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.717395+00
81b2704d-123c-4680-8d64-e25092e2679b	301643d2-f5c4-461e-9df9-c47f64cfeeed	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.720325+00
c9a6090f-d249-48e6-b918-2fe313db8e7b	301643d2-f5c4-461e-9df9-c47f64cfeeed	3	rating	How likely are you to try or use Flutterwave in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.723503+00
0f44d90f-7980-443d-8eb2-36f7d0427540	301643d2-f5c4-461e-9df9-c47f64cfeeed	4	multiple_choice	After watching this ad, your impression of Flutterwave is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.726592+00
ce6513f5-12a5-4492-96f8-7665a9fd5bc7	301643d2-f5c4-461e-9df9-c47f64cfeeed	5	multiple_choice	How often do you send or receive money online or across borders?	["Daily", "Several times a week", "Monthly", "Rarely", "Never"]	2026-05-02 19:20:51.729108+00
66e3f4fc-ce0a-49e0-8286-fc981969fbe3	301643d2-f5c4-461e-9df9-c47f64cfeeed	6	multiple_choice	What payment method do you use most often?	["Bank transfer", "Card payment", "Mobile money", "USSD", "Cash"]	2026-05-02 19:20:51.731822+00
69420108-e3f4-45a2-bb55-ac00348196f0	301643d2-f5c4-461e-9df9-c47f64cfeeed	7	open_text	In your own words, what is the single most memorable thing about this Flutterwave ad?	\N	2026-05-02 19:20:51.734669+00
9d22e4b0-2315-4b49-ad30-769fa18d6cb8	2e2c4657-6463-4b6f-9384-4e339a31b103	0	multiple_choice	Before watching this ad, how familiar were you with Paystack?	["Very familiar – I use it regularly", "Somewhat familiar – I've heard of it", "I've seen it but never used it", "Never heard of it before"]	2026-05-02 19:20:51.738097+00
6baf2505-3c20-477e-82c2-d262253423ae	2e2c4657-6463-4b6f-9384-4e339a31b103	1	rating	How clearly did this ad communicate its message? (1 = very unclear, 5 = crystal clear)	\N	2026-05-02 19:20:51.74089+00
4bdd629b-1ae2-4949-a42d-ff66fa93d1d1	2e2c4657-6463-4b6f-9384-4e339a31b103	2	multiple_choice	How did this ad make you feel?	["Excited", "Happy / Entertained", "Inspired", "Curious", "Neutral", "Unconvinced"]	2026-05-02 19:20:51.744015+00
fb6594ee-5cba-42ea-acbc-0a76b3de79b9	2e2c4657-6463-4b6f-9384-4e339a31b103	3	rating	How likely are you to try or use Paystack in the next 3 months? (1 = not at all, 5 = very likely)	\N	2026-05-02 19:20:51.747855+00
14fe1108-c0d3-4600-89fe-b7e183f257e4	2e2c4657-6463-4b6f-9384-4e339a31b103	4	multiple_choice	After watching this ad, your impression of Paystack is:	["Much more positive", "Slightly more positive", "No change", "Less positive than before"]	2026-05-02 19:20:51.750545+00
bd89a506-6794-4986-8b51-49fd39651043	2e2c4657-6463-4b6f-9384-4e339a31b103	5	multiple_choice	Are you currently a business owner or running a side hustle?	["Yes – full-time business", "Yes – side hustle", "Not yet, but planning to", "No – I'm an employee"]	2026-05-02 19:20:51.753004+00
173c4cbb-e410-4ebf-8b0a-adb9de2fc55a	2e2c4657-6463-4b6f-9384-4e339a31b103	6	multiple_choice	What's the biggest challenge you face with accepting payments online?	["High transaction fees", "Trust and security concerns", "Technical complexity", "Not relevant to me"]	2026-05-02 19:20:51.756203+00
386414bd-0fc8-45b2-85c7-8731ce273c55	2e2c4657-6463-4b6f-9384-4e339a31b103	7	open_text	In your own words, what is the single most memorable thing about this Paystack ad?	\N	2026-05-02 19:20:51.758703+00
5434a4bc-c48e-4feb-b9c4-ffacf8412197	e42ebb20-c389-488c-a5f0-fe9886830947	0	rating	Did you enjoy this ad?	\N	2026-05-02 21:04:54.645141+00
\.


--
-- Data for Name: redemptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redemptions (id, user_id, amount_points, redemption_type, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: review_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_sessions (id, user_id, ad_id, started_at, completed_at, watch_seconds, points_awarded, status, comment) FROM stdin;
74107e84-8b72-430e-bb87-8978a0369607	6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 15:40:33+00	2026-04-21 15:41:00+00	28	83	completed	Excellent quality, excellent ad. Five stars from me.
6c50d066-3f19-4e0e-851e-d022ff907c70	4a468db0-bb0d-4696-984a-a7e68ba0c80f	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 13:49:33+00	2026-04-23 13:50:00+00	16	61	completed	I liked how the ad focused on strength and durability. That's what matters.
45e8a5f7-7454-4eb7-ada2-ad876c43a7f5	fc410940-03db-4881-ba08-b2516b91b02a	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-28 15:12:08+00	2026-04-28 15:13:00+00	33	86	completed	Dangote brand always delivers. This ad is no exception.
0e07a3de-6603-4c96-befc-10baa022b55d	fc410940-03db-4881-ba08-b2516b91b02a	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 16:59:18+00	2026-05-01 17:00:00+00	33	59	completed	The visuals were stunning. Shows construction in a positive Nigerian light.
156d587c-9c4a-4f17-af75-44f52003ae94	352944b9-b107-418b-8420-ce5f98e1ed4f	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 17:47:09+00	2026-05-01 17:48:00+00	41	70	completed	The ad captures the essence of why Dangote is Nigeria's #1 brand.
b3b53ee6-3cc4-4607-9630-3a9a5ac7a08c	352944b9-b107-418b-8420-ce5f98e1ed4f	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-23 19:02:23+00	2026-04-23 19:03:00+00	18	88	completed	Very motivating. Made me proud to be Nigerian seeing this brand succeed.
fa5ce023-e934-4799-8847-5d422eb74e70	85ec9791-dc91-46cb-b7da-51f8af983a04	dfcb0277-69b7-4cbf-b5ad-f35f0359a5b3	2026-05-03 14:24:59.79009+00	\N	\N	\N	in_progress	\N
aed14e3c-8644-4711-8e63-53ebf90d0003	844f4ae8-0c18-4556-8196-518df739b1a7	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 07:56:37+00	2026-04-23 07:57:00+00	37	60	completed	The Dangote cement ad really resonated with me. Quality is undeniable!
5f246d58-8a72-4117-b89b-417ea2f9d554	411cbccc-9d5e-45be-ad3c-90f99f13a1a9	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 09:02:16+00	2026-05-01 09:03:00+00	28	83	completed	The ad was clear and informative. Would definitely recommend Dangote cement.
519ad0bb-4815-48d0-9ab9-6bebe71a847b	411cbccc-9d5e-45be-ad3c-90f99f13a1a9	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 11:24:45+00	2026-04-30 11:25:00+00	35	68	completed	Impressive! Shows why Dangote leads the market in Nigeria.
1f9a4c26-3784-4615-b977-901285e26e40	de513c1b-475b-4888-a59f-8f3beaf5955f	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-22 11:32:21+00	2026-04-22 11:33:00+00	18	65	completed	Very relatable ad for everyday Nigerians. Thumbs up!
d81301b4-6a6b-4120-bdc9-f80e829f951b	de513c1b-475b-4888-a59f-8f3beaf5955f	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 13:44:01+00	2026-04-24 13:45:00+00	29	91	completed	Love the patriotic feel of the campaign. Made in Nigeria, used across Africa.
ff0b8cd1-f7e1-454a-8bf4-b80953001163	de513c1b-475b-4888-a59f-8f3beaf5955f	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 15:42:43+00	2026-04-30 15:43:00+00	23	71	completed	Dangote products are everywhere in Kano. Good to see the ad campaign.
38f2f2bd-ec15-4d8a-9bad-25eaf722ad43	58f512f8-49f5-4127-882c-f7e89ba5ddcb	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 13:43:03+00	2026-05-01 13:44:00+00	29	95	completed	The quality message came through clearly. Will buy again.
50db2bde-4b4d-4ece-a4c4-51cb082f30ca	2080eedb-b15f-4a3c-978d-59145268d6dc	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 15:07:28+00	2026-05-01 15:08:00+00	20	64	completed	The ad made me want to upgrade my home renovation project with Dangote.
86ea4497-f522-43a8-8b5f-a5f55764140e	2080eedb-b15f-4a3c-978d-59145268d6dc	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-28 17:08:36+00	2026-04-28 17:09:00+00	16	87	completed	Short, punchy, to the point. Excellent advertising from the Dangote brand.
33e822c3-d9f8-4d7c-b54b-22de258bb819	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-30 17:19:06+00	2026-04-30 17:20:00+00	32	90	completed	Price point is competitive for the quality. Ad represents that well.
e19427a2-6b47-4a4a-834b-02507465a048	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 19:31:35+00	2026-04-30 19:32:00+00	28	71	completed	The brand trust is already there, the ad just reinforced it for me.
fad6dbfc-7de2-4476-b51c-750d501ffc7b	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 21:26:14+00	2026-04-24 21:27:00+00	22	94	completed	Would love to see Dangote expand into more product lines. Exciting times.
c7633ef4-e9d1-4caa-8b11-e833fe7c406b	5abc318c-dd54-4f4b-9498-69407fa70fe0	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 19:09:31+00	2026-04-30 19:10:00+00	41	61	completed	The ad could use more local language elements — more Pidgin maybe?
1f66b721-9c99-4104-8453-f74e26a97bd9	e115d60e-e348-4ec0-96b1-5247203a3b31	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-25 21:57:34+00	2026-04-25 21:58:00+00	21	91	completed	Dangote is synonymous with quality in Nigeria. Ad reflects that perfectly.
01d35acb-1c0d-4fb1-ba01-75c65fb455f0	e115d60e-e348-4ec0-96b1-5247203a3b31	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-02 23:04:09+00	2026-05-02 23:05:00+00	23	69	completed	Good production quality. The message about durability really hit home.
0eaad796-af46-4fd7-9a52-6ef43f7285d4	d481280c-9d2c-4fe5-b549-0ec647499af5	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-22 23:31:44+00	2026-04-22 23:32:00+00	20	65	completed	The ad feels authentic — not overdone. Real Nigerian feel to it.
e8430adb-d9c5-4fd5-b8cc-dbf4bdca4fe0	d481280c-9d2c-4fe5-b549-0ec647499af5	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-03 07:25:43+00	2026-05-03 07:26:00+00	41	98	completed	Watched it twice. The confidence in the brand comes through clearly.
f4f06ada-6682-426f-8345-50820fc29b9f	d481280c-9d2c-4fe5-b549-0ec647499af5	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-21 09:24:39+00	2026-04-21 09:25:00+00	38	65	completed	As a mother building a home for my children, Dangote gives me confidence.
d8b70f29-6926-4660-8e24-b7e839a01364	706d3279-0e2d-40b0-aa1d-578c435f3b42	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-27 07:12:34+00	2026-04-27 07:13:00+00	22	84	completed	Great campaign! Dangote should also show more about their flour products.
f66abedd-56d0-40bf-9528-ebe17d92ad37	b4cc310b-b857-4f04-a8d6-988cb89bc481	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 09:47:14+00	2026-04-26 09:48:00+00	40	71	completed	My village people use Dangote exclusively. Very trustworthy brand.
4acfd2c8-28d3-468d-b41c-26148c7b721b	b4cc310b-b857-4f04-a8d6-988cb89bc481	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-03 11:58:43+00	2026-05-03 11:59:00+00	20	90	completed	Ad was engaging from start to finish. No dull moments.
36fe1791-6e25-4546-a8ad-fbe83025788c	6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 11:41:12+00	2026-04-26 11:42:00+00	34	90	completed	Clear messaging, strong brand presence. Would watch again.
b0b2e5ae-d3ed-40bd-ae6a-9046b0667d41	6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-21 13:13:26+00	2026-04-21 13:14:00+00	43	61	completed	The ad reminded me to place an order for my building project in Lagos.
114b9d96-bd00-42cf-b7ac-d3261bb22d8d	352944b9-b107-418b-8420-ce5f98e1ed4f	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 21:17:38+00	2026-04-23 21:18:00+00	30	63	completed	The music in the ad was catchy. Stayed with me afterwards.
c268bfdb-370f-4499-bb61-31f47d76af83	e5d58143-9ec0-43aa-b649-487b7168c422	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-22 19:46:21+00	2026-04-22 19:47:00+00	42	93	completed	Product messaging was spot on. Would recommend to fellow contractors.
9b112d12-582a-461c-b384-921294608edf	9ab9438c-f1c6-484e-8305-907dbf16d44d	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-24 21:19:30+00	2026-04-24 21:20:00+00	42	64	completed	The ad gave me confidence in the product for my upcoming project in Imo.
e292f08d-56e6-4181-adb9-0547d7e38bb4	9ab9438c-f1c6-484e-8305-907dbf16d44d	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 23:06:39+00	2026-04-21 23:07:00+00	41	86	completed	Dangote's reach across Nigeria is impressive. Ad captures the scale well.
80fbd6de-3bbe-450a-a76c-d99427f7e73f	412657a8-b0db-4dc9-a50e-e9358092e49a	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 23:04:32+00	2026-04-21 23:05:00+00	22	89	completed	The ad touched on infrastructure development — very timely for Nigeria.
65b6caac-5deb-410a-9d6c-b7c89718a49a	412657a8-b0db-4dc9-a50e-e9358092e49a	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-22 07:30:42+00	2026-04-22 07:31:00+00	15	70	completed	Watched with my husband. We're both convinced to use Dangote for our project.
7af64dee-6253-4cc9-a415-7e7b09fb8f5f	412657a8-b0db-4dc9-a50e-e9358092e49a	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-29 09:07:30+00	2026-04-29 09:08:00+00	25	97	completed	A little more detail on specifications would be useful but overall great.
cc66ef4b-10d8-4c88-a875-7fd044894b61	48ca762c-7c2a-4525-8861-372e5c49cd6d	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 07:48:01+00	2026-04-26 07:49:00+00	32	61	completed	Love the emphasis on Nigerian excellence in the ad creative.
f1b13df0-bbbf-4f37-ac72-03c4fb5ca060	7d012f0b-5aa8-4bf7-88f1-191a8ce0288c	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-27 09:22:36+00	2026-04-27 09:23:00+00	21	94	completed	The ad's focus on reliability matches my personal experience with the product.
3541824c-3878-457c-a2a2-d463275cb923	7d012f0b-5aa8-4bf7-88f1-191a8ce0288c	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 11:28:44+00	2026-04-27 11:29:00+00	24	70	completed	Made me think about switching from my current supplier to Dangote.
2a5d24c1-663e-48ae-93d7-1c176d632f39	cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 11:47:34+00	2026-04-26 11:48:00+00	27	62	completed	Cement quality has always been top-notch. Glad they're advertising more.
8b8d9163-6e91-4064-9a12-9c209112a14b	cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-22 13:21:20+00	2026-04-22 13:22:00+00	25	89	completed	The ad was professional and I liked the Nigerian talent featured in it.
c593c54c-b8d7-4c10-ab20-cfc88375c5e1	cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 15:52:32+00	2026-04-25 15:53:00+00	36	61	completed	As a real estate developer, Dangote cement is my go-to. Love this ad.
6c78242a-ae45-4a73-bc63-5cf3de2c0bb3	43ea8459-f0f4-41fb-98e7-1714b9ce81ea	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 12:59:19+00	2026-04-24 13:00:00+00	16	98	completed	The ad was persuasive without being pushy. Perfect for the brand.
78912820-0591-4e12-a542-edc20172d705	027161c5-87ac-425c-9ca9-e82f1007e47b	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 15:58:30+00	2026-04-23 15:59:00+00	17	71	completed	The ad was engaging for my demographic — working class Nigerian.
62e9f1a2-8adb-48ed-9b5d-c743ec5074a0	027161c5-87ac-425c-9ca9-e82f1007e47b	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 17:51:11+00	2026-04-26 17:52:00+00	36	98	completed	Would love to see Dangote advertise their sugar and flour products too.
90e97409-0a49-4473-95a8-8c36818b566e	21b0e483-154e-4e6a-a9ca-3c56585e36b0	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 17:37:33+00	2026-04-21 17:38:00+00	41	95	completed	Ad felt genuine and not like typical corporate advertising. Refreshing.
1f68e0e5-5aee-4e65-ac90-030fceddf762	21b0e483-154e-4e6a-a9ca-3c56585e36b0	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-29 19:45:15+00	2026-04-29 19:46:00+00	21	59	completed	I'm in construction. This ad speaks directly to me. Very relevant.
4febb231-2806-4e16-8755-e092d92206d8	21b0e483-154e-4e6a-a9ca-3c56585e36b0	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-25 21:40:28+00	2026-04-25 21:41:00+00	26	94	completed	The comparison with imported cement is implied but effective.
6f3c6697-ec65-4cc9-9f54-d6af30271b4a	1c19d853-8e34-4aab-b2d3-30db3dd91239	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-29 19:02:08+00	2026-04-29 19:03:00+00	19	69	completed	Trusted brand, great ad. Will share this with my estate agent network.
515c1d52-978d-4e4d-92c7-a99a5b62d690	3fec7d15-2923-4f36-aaee-cb49b84a2901	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-23 21:01:25+00	2026-04-23 21:02:00+00	25	99	completed	Very relevant to my life right now as I'm renovating my property.
4dfba325-40ab-440a-96ff-794a78f627c5	3fec7d15-2923-4f36-aaee-cb49b84a2901	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-21 23:01:06+00	2026-04-21 23:02:00+00	16	67	completed	The pride of using Nigerian products came through in the ad.
6bcc520f-95e5-4ee1-8a64-2a381408e9c4	76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 23:16:45+00	2026-04-25 23:17:00+00	32	59	completed	Dangote should do more ads like this across all platforms.
be4796ff-4e4f-4d30-9d71-8b98a825211e	76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-04 07:28:10+00	2026-05-04 07:29:00+00	26	82	completed	The sustainability message was subtle but I caught it. Well done.
95adca7c-a568-4f0f-9783-2cf2ea5b3f08	76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 09:09:18+00	2026-04-28 09:10:00+00	22	67	completed	Made me curious to visit the Dangote website for more information.
5e59acbd-570c-47ec-b3c6-a4c460fb4cc9	38c4aba5-0612-4f86-aa76-a47db8320cff	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-28 07:56:11+00	2026-04-28 07:57:00+00	24	93	completed	The ad spoke to both individual buyers and large-scale contractors. Smart.
c048f72a-b2ee-4172-b57f-6e61e25c323b	3e38a0b3-aefb-4bf7-8a5a-24e03f590de3	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 09:17:16+00	2026-04-23 09:18:00+00	32	68	completed	The call to action at the end was clear and actionable.
325e95e1-cf75-4237-b192-4108dfb5b9ce	3e38a0b3-aefb-4bf7-8a5a-24e03f590de3	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-29 11:51:19+00	2026-04-29 11:52:00+00	20	88	completed	Watching this from Port Harcourt — Dangote is big here too!
0a9c2ded-69b0-4ec1-9cf2-eecd3f7a5368	8e19c3fb-7be8-4aa5-b5bd-af171861b57c	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-25 11:43:44+00	2026-04-25 11:44:00+00	37	85	completed	Overall impression: very positive. Would watch more Dangote ads.
b8e0723a-1a1e-495a-9182-778122c42f4b	8e19c3fb-7be8-4aa5-b5bd-af171861b57c	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 13:01:12+00	2026-04-23 13:02:00+00	15	62	completed	Short and punchy is the right approach for this type of product.
d657581c-46ea-4bfa-bb37-3fe6ceb75d61	8e19c3fb-7be8-4aa5-b5bd-af171861b57c	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-29 15:50:33+00	2026-04-29 15:51:00+00	30	97	completed	Ad reinforces why Dangote remains the gold standard in Nigeria.
246352f8-8aad-4b58-ac0e-8e95952af2a1	28d15e56-e782-4bad-9ce9-9c479390cac4	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-24 13:56:37+00	2026-04-24 13:57:00+00	41	68	completed	As a civil engineering student, this ad is inspiring for our industry.
66bc0d66-2a8f-439b-ab93-fdaa1a83056d	bd9cf8c9-aa13-4139-ae09-789c33a46b33	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 15:54:43+00	2026-04-21 15:55:00+00	29	82	completed	Fantastic campaign. Glad to be reviewing content from Dangote.
1194ae8a-04b2-4479-bee7-afe012ff1090	bd9cf8c9-aa13-4139-ae09-789c33a46b33	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 17:44:25+00	2026-04-26 17:45:00+00	17	62	completed	The Nigerian landscape in the ad background was a nice touch.
3f7da559-98d1-4bcc-8365-a075ebd290f1	ab043822-4518-4915-b133-b9320ab0fd16	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-21 17:10:24+00	2026-04-21 17:11:00+00	17	66	completed	Love how Dangote is investing in digital advertising. Smart move.
d13804bc-663a-4f64-8194-5bc500792242	ab043822-4518-4915-b133-b9320ab0fd16	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 19:47:42+00	2026-04-24 19:48:00+00	22	93	completed	The production values are high — befitting a brand of Dangote's stature.
766fc026-db0b-4ba2-bf65-aec3147ad9c1	ab043822-4518-4915-b133-b9320ab0fd16	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 21:54:25+00	2026-04-23 21:55:00+00	36	68	completed	Watching from Enugu. Dangote is very popular here for construction.
a6c50394-a89d-48ec-8e74-bea785ba2851	104ac577-7486-41a2-8d57-1ff9792e7c1b	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-30 19:03:11+00	2026-04-30 19:04:00+00	29	97	completed	The ad made an emotional connection for me. That's effective advertising.
788d08fe-1793-40f6-8bcb-08bf7da77497	f6c1113f-8c5d-4ebd-b8e6-1a306d832280	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 21:21:16+00	2026-04-27 21:22:00+00	27	61	completed	I've used Dangote products for years. Great to see them on this platform.
51d754be-acd8-4060-806a-83607ab58b41	f6c1113f-8c5d-4ebd-b8e6-1a306d832280	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 23:21:03+00	2026-04-21 23:22:00+00	27	92	completed	Very professional ad. Dangote is truly a pride of Africa.
7e4d6e75-b8f9-4817-8a60-996218899499	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-23 23:38:05+00	2026-04-23 23:39:00+00	34	98	completed	Impressive! Shows why Dangote leads the market in Nigeria.
177a5447-12a8-4949-8621-f08437390dba	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 07:31:33+00	2026-04-28 07:32:00+00	31	71	completed	As a contractor, I trust Dangote cement above all others. The ad confirms it.
c2083c67-18dc-450e-a93a-e2477b88e6d0	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 09:23:14+00	2026-05-01 09:24:00+00	32	97	completed	Very relatable ad for everyday Nigerians. Thumbs up!
b5efae7e-a07a-41c5-a0cd-76885114ee0d	240e8cfc-eed0-44a4-89bc-d9145a6ebeed	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 07:11:08+00	2026-04-25 07:12:00+00	24	64	completed	Love the patriotic feel of the campaign. Made in Nigeria, used across Africa.
bb8ffeac-9854-4601-9b47-98d4d0c86bb1	5fdd91fd-1a88-4a80-aa84-1766dbf34344	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 09:53:22+00	2026-04-24 09:54:00+00	19	87	completed	Solid ad. Dangote's dominance in the cement sector is well-deserved.
b5d4b921-d02e-4af5-8f37-a8416813ad16	5fdd91fd-1a88-4a80-aa84-1766dbf34344	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-22 11:55:32+00	2026-04-22 11:56:00+00	19	65	completed	My family has been using Dangote for over a decade. No regrets.
0eec84ee-7ce5-4400-83d2-a0d661751544	7eebcbb6-338d-4d54-b25e-dba123a39d2a	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-03 11:16:03+00	2026-05-03 11:17:00+00	39	64	completed	Short, punchy, to the point. Excellent advertising from the Dangote brand.
fb95a422-edfb-4c45-bf2e-e65e8069c999	7eebcbb6-338d-4d54-b25e-dba123a39d2a	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 13:30:21+00	2026-04-21 13:31:00+00	30	96	completed	As a civil engineer, I appreciate the technical accuracy in the messaging.
869178d9-d558-48a3-98d7-7774c3e523c1	7eebcbb6-338d-4d54-b25e-dba123a39d2a	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 15:24:15+00	2026-04-25 15:25:00+00	43	63	completed	Price point is competitive for the quality. Ad represents that well.
e2c095ee-3f78-4cbf-9606-d7551402dead	e46b6720-49db-4e3d-b6cd-d849cb0c9eeb	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-03 13:13:05+00	2026-05-03 13:14:00+00	31	87	completed	The brand trust is already there, the ad just reinforced it for me.
9ee51098-feb5-49a0-9228-7465769e5fb8	edaa49fd-dd8c-4d7f-8ab3-2a8a01863e7f	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 15:53:38+00	2026-04-28 15:54:00+00	26	66	completed	Very strong brand. The ad did justice to what Dangote represents.
f9640389-d66d-4682-8bb5-2ece151c0108	edaa49fd-dd8c-4d7f-8ab3-2a8a01863e7f	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 17:38:28+00	2026-04-21 17:39:00+00	20	83	completed	Saw this ad at the right time — currently building a house in Abuja.
a3bcc324-3431-42d0-bb72-97bf8a25f4c4	766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-04 17:11:31+00	2026-05-04 17:12:00+00	17	88	completed	Good production quality. The message about durability really hit home.
8679c977-1114-4478-b6c1-8faef5a75997	766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-21 19:35:22+00	2026-04-21 19:36:00+00	27	62	completed	I've recommended Dangote cement to my clients many times. Great ad.
a5d8f3a9-0325-489b-90d2-195bf59756c0	766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-02 21:24:23+00	2026-05-02 21:25:00+00	21	87	completed	The ad feels authentic — not overdone. Real Nigerian feel to it.
dad0e79c-6c81-44f7-8647-4b0351d39ddc	4987c977-6c68-4103-9863-6e0adfc4f276	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-21 19:11:02+00	2026-04-21 19:12:00+00	37	66	completed	Watched it twice. The confidence in the brand comes through clearly.
ba01412a-a0ce-427b-938e-c9704654315c	ad185731-3f7e-4950-a9af-01962006c9e0	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-27 21:50:32+00	2026-04-27 21:51:00+00	41	95	completed	The testimonial angle works well. Nigerians trust word of mouth.
216a0fd5-d471-44a4-8eb9-7f25f3e4b95a	ad185731-3f7e-4950-a9af-01962006c9e0	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 23:45:16+00	2026-04-28 23:46:00+00	18	65	completed	Love how the ad shows the product in real construction scenarios.
247cd269-734b-4589-91a5-b112a67d9ad8	e1d417cb-810f-49ae-8ea7-2eeac36ec593	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-03 23:06:11+00	2026-05-03 23:07:00+00	38	71	completed	Ad was engaging from start to finish. No dull moments.
93484672-5ac3-4bc8-bf8f-c79db5bc16d4	e1d417cb-810f-49ae-8ea7-2eeac36ec593	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-03 07:37:11+00	2026-05-03 07:38:00+00	36	90	completed	Dangote is doing great work for Nigeria's economy. Ad reflects that.
8bf00840-696c-4021-bdc3-90cf0d30980c	e1d417cb-810f-49ae-8ea7-2eeac36ec593	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-03 09:46:43+00	2026-05-03 09:47:00+00	42	59	completed	Clear messaging, strong brand presence. Would watch again.
cade1e7e-bb65-4df8-bcaa-a8ff9385a378	f3ca9228-81d7-4fd1-9f0f-abf29cbe5cfb	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 07:14:07+00	2026-05-01 07:15:00+00	36	84	completed	The ad reminded me to place an order for my building project in Lagos.
35d629b6-d438-436f-a956-3a3320bbe26c	71b28923-6de8-47ee-88b4-f235a2a6373f	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 09:26:23+00	2026-04-28 09:27:00+00	43	67	completed	The campaign speaks directly to builders and homeowners. Very targeted.
a168986a-8bb6-449e-97df-2b50e115b53a	71b28923-6de8-47ee-88b4-f235a2a6373f	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 11:58:11+00	2026-04-21 11:59:00+00	35	95	completed	Would have liked more info on pricing but overall a solid ad.
29f01f85-e0c2-4a3c-8f38-f8821b97cbdc	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-22 11:51:35+00	2026-04-22 11:52:00+00	35	91	completed	The visuals were stunning. Shows construction in a positive Nigerian light.
baff260d-e0e8-47bb-85da-68da285ffcc5	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 13:39:35+00	2026-04-25 13:40:00+00	17	63	completed	As a quantity surveyor, I specify Dangote in all my projects. Great ad.
c91c97a4-a4b3-4ac2-91d5-ff0ebeb404c9	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-04 15:00:14+00	2026-05-04 15:01:00+00	18	93	completed	The ad captures the essence of why Dangote is Nigeria's #1 brand.
1e38a5a0-d4dd-4f06-98c9-2fe94994d2ff	11c233d8-13db-4b03-a065-b452f15b371a	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 13:03:07+00	2026-04-28 13:04:00+00	24	60	completed	Very motivating. Made me proud to be Nigerian seeing this brand succeed.
ec163ffe-d8df-4b63-9219-ddb6f4b49222	64d8b8ef-cc91-4410-b2a9-d455a7c6a9f8	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 15:51:04+00	2026-04-26 15:52:00+00	22	88	completed	Too short but very impactful. Quality over quantity — like the cement!
fc67de83-23d9-46d4-80ee-277c7ef2747e	64d8b8ef-cc91-4410-b2a9-d455a7c6a9f8	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-03 17:04:22+00	2026-05-03 17:05:00+00	22	68	completed	I've switched to Dangote from foreign brands. No going back.
cfc482ed-c2d3-46d1-8791-128c5f34df76	17a2da93-6d4d-46a1-bb3d-ec5aa7850445	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 17:55:26+00	2026-05-01 17:56:00+00	23	63	completed	Dangote's reach across Nigeria is impressive. Ad captures the scale well.
283560ca-2bf6-445f-a2bb-4dbe12e61fd8	17a2da93-6d4d-46a1-bb3d-ec5aa7850445	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 19:02:01+00	2026-05-01 19:03:00+00	19	92	completed	Simple, effective, trustworthy. That's Dangote and that's this ad.
598ecc55-d9aa-4326-afc8-623beef05841	17a2da93-6d4d-46a1-bb3d-ec5aa7850445	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 21:21:31+00	2026-04-26 21:22:00+00	34	63	completed	The ad touched on infrastructure development — very timely for Nigeria.
0f59293b-5e72-4ae5-8af1-34558e08341d	1d3b38c3-dcfe-419c-ab19-744d2fe7733e	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 19:01:27+00	2026-04-26 19:02:00+00	23	99	completed	Watched with my husband. We're both convinced to use Dangote for our project.
f2906241-4a32-46c4-8612-66fd1653c851	03cfc327-5d88-43c7-8612-31e7a5a8a833	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-03 21:18:12+00	2026-05-03 21:19:00+00	33	60	completed	Strong visuals, strong message. Aligns with Dangote's market positioning.
f2be7f80-5f81-472d-b8ce-05a7c9726b85	03cfc327-5d88-43c7-8612-31e7a5a8a833	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-20 23:05:26+00	2026-04-20 23:06:00+00	15	92	completed	Dangote is feeding Nigeria and building Nigeria. This ad shows both.
92c4832b-7c95-495d-ae94-f92b75728a43	72d87e8e-f5c1-48e6-b047-c94fab9c7393	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-27 23:29:19+00	2026-04-27 23:30:00+00	31	91	completed	Made me think about switching from my current supplier to Dangote.
46c6188e-d270-48eb-b60c-9d3fb0391258	72d87e8e-f5c1-48e6-b047-c94fab9c7393	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 07:36:25+00	2026-05-01 07:37:00+00	28	62	completed	Great job on the ad! Dangote is truly transforming Nigeria.
ae6e1545-240a-4613-be86-54051780e6cb	72d87e8e-f5c1-48e6-b047-c94fab9c7393	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-29 09:08:35+00	2026-04-29 09:09:00+00	36	82	completed	Cement quality has always been top-notch. Glad they're advertising more.
5dcae94e-5a83-4b96-9b3b-55af29de54ed	0d08839e-ebe9-4f14-b879-8c56c0044f33	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 07:15:21+00	2026-04-26 07:16:00+00	16	63	completed	The ad was professional and I liked the Nigerian talent featured in it.
de03a911-1330-4f3b-a2c4-6b6eadaac1b5	7b982e66-76e6-438f-939a-77344b934380	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 09:40:04+00	2026-04-26 09:41:00+00	35	81	completed	Reminds me why I've been loyal to Dangote for so many years.
e271bc4e-f681-4fbd-b335-aa7cfd14114b	7b982e66-76e6-438f-939a-77344b934380	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-22 11:56:12+00	2026-04-22 11:57:00+00	42	67	completed	Excellent campaign. Shows Dangote understands their Nigerian customers.
52aeec76-af5e-460e-81c9-e86700a009c5	e7da5f29-e44a-4585-81fd-2244675f45fd	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 11:23:02+00	2026-04-27 11:24:00+00	19	62	completed	Would love to see Dangote advertise their sugar and flour products too.
703fb958-cb27-4df9-96a1-7d5979921d55	e7da5f29-e44a-4585-81fd-2244675f45fd	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-02 13:41:44+00	2026-05-02 13:42:00+00	22	82	completed	The imagery of strong Nigerian homes built with Dangote was powerful.
173844bb-b248-4d89-86ad-37562e2f1590	e7da5f29-e44a-4585-81fd-2244675f45fd	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-02 15:49:44+00	2026-05-02 15:50:00+00	34	63	completed	Ad felt genuine and not like typical corporate advertising. Refreshing.
415bc80b-4ffc-45f6-95e0-75ae29c8bf05	39add4d6-53a8-4896-984f-f247a9d5a2b7	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-25 13:32:17+00	2026-04-25 13:33:00+00	19	92	completed	I'm in construction. This ad speaks directly to me. Very relevant.
5a1a5dd7-c3fe-4f7b-ac75-eda1c18461d3	f8bcd338-39b0-4186-830f-228e55604064	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 15:57:22+00	2026-04-28 15:58:00+00	24	63	completed	The durability angle resonates with me as someone building to last.
4532fc0a-4929-453c-9b7c-53b0267fdefb	f8bcd338-39b0-4186-830f-228e55604064	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-29 17:25:21+00	2026-04-29 17:26:00+00	39	81	completed	Beautiful execution. Shows Dangote knows their audience.
35188bca-4987-4cb6-a29e-1c5e2a325710	b9c3be6b-8da0-4414-bf50-69410fa774bb	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 17:58:11+00	2026-04-26 17:59:00+00	31	89	completed	The pride of using Nigerian products came through in the ad.
9074a1f7-6ffa-4bac-9e15-693f6219ae01	b9c3be6b-8da0-4414-bf50-69410fa774bb	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 19:20:41+00	2026-04-25 19:21:00+00	25	63	completed	Good pacing. Didn't feel too long or too rushed.
410a6c83-b8fd-4948-b839-77ecb801b209	b9c3be6b-8da0-4414-bf50-69410fa774bb	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 21:42:19+00	2026-04-24 21:43:00+00	20	93	completed	Dangote should do more ads like this across all platforms.
c8dea943-2e1a-4575-90bc-244da15fefec	7b9e7324-16e7-4b01-944d-4f6ff9384366	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-04 19:58:30+00	2026-05-04 19:59:00+00	35	65	completed	The sustainability message was subtle but I caught it. Well done.
b604fd50-c0c9-4b7c-8b32-892518e7df64	8c7c19e3-3bd3-4b95-be5c-9f793d8db656	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 21:31:28+00	2026-04-26 21:32:00+00	41	94	completed	Nigerian brands like Dangote deserve more visibility. This ad helps.
977d50ea-7bf5-420d-abd7-90570ea155dd	8c7c19e3-3bd3-4b95-be5c-9f793d8db656	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 23:00:06+00	2026-04-30 23:01:00+00	21	60	completed	I'm in Kaduna and Dangote cement is everywhere here. Good ad.
4977a03d-d6ef-4840-a294-1037d4241336	9550b05b-35a6-40e9-af4d-c83a83a2a96d	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-20 23:02:37+00	2026-04-20 23:03:00+00	18	62	completed	Watching this from Port Harcourt — Dangote is big here too!
b3989144-79e1-493a-b84e-46072edf1ccb	9550b05b-35a6-40e9-af4d-c83a83a2a96d	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-02 07:53:12+00	2026-05-02 07:54:00+00	17	94	completed	The emphasis on job creation resonated with me. Patriotic angle worked.
998dcf7d-96fa-4116-bea2-b4ffc14bb1f3	9550b05b-35a6-40e9-af4d-c83a83a2a96d	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 09:21:42+00	2026-04-28 09:22:00+00	23	67	completed	Overall impression: very positive. Would watch more Dangote ads.
d3070228-9738-4934-b9f4-745ccb758fcb	d93b2055-e8b3-4438-bb78-b7f288ae6e2c	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-27 07:54:02+00	2026-04-27 07:55:00+00	23	97	completed	Short and punchy is the right approach for this type of product.
abe5e74a-a60b-4dfb-a6fd-9973e375ff23	9f7fa566-ec18-426f-b374-86b4596716ac	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-03 09:14:38+00	2026-05-03 09:15:00+00	36	64	completed	Very confident brand voice. Exactly what Dangote should project.
627e513e-fcbb-4517-ba73-9b138601ae62	9f7fa566-ec18-426f-b374-86b4596716ac	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 11:40:34+00	2026-05-01 11:41:00+00	27	97	completed	Touched on quality, durability, and trust. Hit all the right notes.
8882d436-cd20-4bfd-9c34-a28ad1263558	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-28 11:47:29+00	2026-04-28 11:48:00+00	21	99	completed	The Nigerian landscape in the ad background was a nice touch.
cef20cad-ff54-414b-9e73-97f6ff2d3a59	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 13:55:30+00	2026-04-28 13:56:00+00	18	70	completed	Ad was clear about the value proposition. No confusion.
e4d765b2-5044-49a3-be06-f6eceb49abd9	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-27 15:35:20+00	2026-04-27 15:36:00+00	18	94	completed	Love how Dangote is investing in digital advertising. Smart move.
32a962e5-ca81-4017-abc7-5c8060a04db7	6890c0e7-eab0-4edd-8922-1186632c105b	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 13:03:31+00	2026-05-01 13:04:00+00	38	60	completed	The production values are high — befitting a brand of Dangote's stature.
f56f5f4d-247c-4747-94ce-755de5f352f8	a0d8b8d9-fb84-4b41-9928-aa4abfa255b4	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-25 15:14:33+00	2026-04-25 15:15:00+00	27	90	completed	I'd give this ad a 10/10 for clarity, relevance, and brand alignment.
df2e9b6b-45eb-439c-9773-e8d21122a513	a0d8b8d9-fb84-4b41-9928-aa4abfa255b4	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 17:28:14+00	2026-05-01 17:29:00+00	25	61	completed	The Dangote cement ad really resonated with me. Quality is undeniable!
66c3be0e-e271-4cef-9f15-dac27663dca6	4dfa4e2b-263f-4271-93c0-3e3af55a2f15	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 17:27:29+00	2026-04-26 17:28:00+00	17	64	completed	Very professional ad. Dangote is truly a pride of Africa.
9dba5125-28d7-45d6-b0ae-d735a78494f5	4dfa4e2b-263f-4271-93c0-3e3af55a2f15	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 19:53:18+00	2026-04-24 19:54:00+00	29	85	completed	The ad was clear and informative. Would definitely recommend Dangote cement.
e2e9def1-a736-47c5-9c76-9855b343d5e0	4dfa4e2b-263f-4271-93c0-3e3af55a2f15	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-20 21:00:40+00	2026-04-20 21:01:00+00	15	69	completed	Impressive! Shows why Dangote leads the market in Nigeria.
30a69f7b-062d-4fe1-ae56-c89001007830	773a0438-e576-4ad7-b14f-5aefd011304c	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-04 19:27:33+00	2026-05-04 19:28:00+00	36	88	completed	As a contractor, I trust Dangote cement above all others. The ad confirms it.
91084e76-306a-424f-a5a7-be098480ea96	3a5b9d93-ed69-4d00-8ab2-8122511c2ec2	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 21:47:15+00	2026-04-28 21:48:00+00	29	63	completed	Dangote products are everywhere in Kano. Good to see the ad campaign.
a6d2d43a-550b-4b26-89bd-c9479dd35e5c	3a5b9d93-ed69-4d00-8ab2-8122511c2ec2	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-03 23:09:17+00	2026-05-03 23:10:00+00	27	95	completed	The quality message came through clearly. Will buy again.
a20a39ae-7136-4fab-a55b-a85cb05c8b24	3d6078c0-3a00-4652-8a0f-0aea34ef2e16	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 23:24:45+00	2026-04-26 23:25:00+00	20	86	completed	My family has been using Dangote for over a decade. No regrets.
3d27283c-4903-46ca-8a18-8f5c6fb38602	3d6078c0-3a00-4652-8a0f-0aea34ef2e16	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-29 07:28:13+00	2026-04-29 07:29:00+00	21	65	completed	The ad made me want to upgrade my home renovation project with Dangote.
a3305cb0-3cca-44a9-884b-94063b8de50a	3d6078c0-3a00-4652-8a0f-0aea34ef2e16	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-20 09:42:33+00	2026-04-20 09:43:00+00	17	93	completed	Short, punchy, to the point. Excellent advertising from the Dangote brand.
87998689-c9ed-4a2c-8c0a-cd047d3787b0	641e883e-1fcc-44d7-b61f-45bf45daae83	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 07:45:12+00	2026-04-27 07:46:00+00	44	69	completed	As a civil engineer, I appreciate the technical accuracy in the messaging.
b4b24a11-2c4b-42cb-9119-8a60b46ce117	2d6bf6ed-8785-41e6-a41a-0f80907edeb0	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 09:06:43+00	2026-04-26 09:07:00+00	36	90	completed	Would love to see Dangote expand into more product lines. Exciting times.
a2f0424a-e1f0-4a04-b33e-bc0ad6d4203f	2d6bf6ed-8785-41e6-a41a-0f80907edeb0	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-21 11:24:09+00	2026-04-21 11:25:00+00	19	60	completed	The ad could use more local language elements — more Pidgin maybe?
b37e1b83-3b15-4313-839d-6224a90b9ff9	221c08f9-07f2-4b22-a19a-86db67c5c7ba	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 11:48:04+00	2026-05-01 11:49:00+00	32	66	completed	Saw this ad at the right time — currently building a house in Abuja.
a8c1ed06-95b1-4a66-8dd1-7a6ed36cc753	221c08f9-07f2-4b22-a19a-86db67c5c7ba	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 12:59:17+00	2026-04-24 13:00:00+00	31	93	completed	Dangote is synonymous with quality in Nigeria. Ad reflects that perfectly.
4201927d-7141-4612-aae3-c4ba21761d67	221c08f9-07f2-4b22-a19a-86db67c5c7ba	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 15:41:17+00	2026-04-26 15:42:00+00	36	65	completed	Good production quality. The message about durability really hit home.
553b8ba7-ddcd-44f3-a9a9-7aeededb15c9	5ac1cdcd-c7bf-42b3-bc27-96aa3b745080	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-24 13:00:03+00	2026-04-24 13:01:00+00	27	87	completed	I've recommended Dangote cement to my clients many times. Great ad.
0ba32da1-325e-4cf2-a80b-6253906c65d5	9221e178-bf98-4523-9701-37a463c71ff5	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-24 15:06:04+00	2026-04-24 15:07:00+00	30	63	completed	As a mother building a home for my children, Dangote gives me confidence.
f6ea718e-4222-47ed-bcd1-b86c3c4aee33	9221e178-bf98-4523-9701-37a463c71ff5	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-20 17:24:45+00	2026-04-20 17:25:00+00	30	93	completed	Great campaign! Dangote should also show more about their flour products.
22c898e0-fa78-4295-851e-37023f60ecc5	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-03 17:48:35+00	2026-05-03 17:49:00+00	31	93	completed	Love how the ad shows the product in real construction scenarios.
9a3f6aeb-47d0-433d-bec9-db5d8eb238be	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 19:21:13+00	2026-04-30 19:22:00+00	43	64	completed	My village people use Dangote exclusively. Very trustworthy brand.
d8b58fb7-6847-4b92-af14-c57a6992a0e3	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-20 21:51:13+00	2026-04-20 21:52:00+00	43	98	completed	Ad was engaging from start to finish. No dull moments.
5bc1e70c-516f-450e-b621-a690072cb520	fc553e0f-1b13-4104-93b7-db4d61313ca1	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 19:03:25+00	2026-04-25 19:04:00+00	35	70	completed	Dangote is doing great work for Nigeria's economy. Ad reflects that.
fd4c4135-2ae3-45ad-98f4-665c40358d53	b015caff-4ca4-4999-9acf-b99c11df8215	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-30 21:49:35+00	2026-04-30 21:50:00+00	28	93	completed	Excellent quality, excellent ad. Five stars from me.
63b866f3-85d9-4109-baea-e31f82852fe2	b015caff-4ca4-4999-9acf-b99c11df8215	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 23:57:10+00	2026-04-30 23:58:00+00	43	62	completed	I liked how the ad focused on strength and durability. That's what matters.
d2beef58-ab46-430f-ac2a-00e12818f8c2	9014881d-e2e6-49b3-b386-4883f4e380ba	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 23:36:24+00	2026-04-30 23:37:00+00	24	61	completed	Would have liked more info on pricing but overall a solid ad.
734290b2-d00a-4d9e-953e-cbaaca25247a	9014881d-e2e6-49b3-b386-4883f4e380ba	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 07:34:39+00	2026-04-21 07:35:00+00	38	87	completed	Dangote brand always delivers. This ad is no exception.
20acd977-8ac6-4ab6-9585-9d3c8827bb98	9014881d-e2e6-49b3-b386-4883f4e380ba	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-04 09:06:08+00	2026-05-04 09:07:00+00	17	66	completed	The visuals were stunning. Shows construction in a positive Nigerian light.
eb6c03b6-516b-48ed-b206-d9c83a15129c	8a22e5e3-618d-4e9d-a8e6-83aa38ecae41	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-28 07:53:35+00	2026-04-28 07:54:00+00	20	93	completed	As a quantity surveyor, I specify Dangote in all my projects. Great ad.
db8e306b-483d-4651-9066-bb63e3b92c9d	5b90a702-4abe-4847-8549-70228af35bc5	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-22 09:52:19+00	2026-04-22 09:53:00+00	25	59	completed	The music in the ad was catchy. Stayed with me afterwards.
b837b636-d54e-477a-90af-e493cd94ab47	5b90a702-4abe-4847-8549-70228af35bc5	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-20 11:56:15+00	2026-04-20 11:57:00+00	27	95	completed	Product messaging was spot on. Would recommend to fellow contractors.
84dfaac3-c40f-47ab-862a-6463665a6f60	15753795-0698-4fd8-898d-cd03f4ee0a9e	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 11:46:11+00	2026-05-01 11:47:00+00	44	94	completed	I've switched to Dangote from foreign brands. No going back.
6bffd0bb-4656-48f2-88dc-0d78419ba453	15753795-0698-4fd8-898d-cd03f4ee0a9e	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-30 13:18:45+00	2026-04-30 13:19:00+00	21	61	completed	The ad gave me confidence in the product for my upcoming project in Imo.
05e0d3a5-6806-4d6f-9864-f88f2eb0b917	15753795-0698-4fd8-898d-cd03f4ee0a9e	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-22 15:50:23+00	2026-04-22 15:51:00+00	15	94	completed	Dangote's reach across Nigeria is impressive. Ad captures the scale well.
1d238bb8-7afd-4d31-b56e-57cd8831025d	9c4ae611-b83a-4f21-bbc9-c2f5115feed2	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 13:17:20+00	2026-05-01 13:18:00+00	44	59	completed	Simple, effective, trustworthy. That's Dangote and that's this ad.
adea2112-7829-48ad-9f0b-3c3dc8c08d28	575a77de-f3b5-4fcf-a3b7-bb3c71766358	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 15:25:18+00	2026-04-21 15:26:00+00	36	85	completed	A little more detail on specifications would be useful but overall great.
b4fd72b6-cdc4-4920-8364-1f7a2855d6eb	575a77de-f3b5-4fcf-a3b7-bb3c71766358	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 17:10:33+00	2026-04-25 17:11:00+00	39	70	completed	Love the emphasis on Nigerian excellence in the ad creative.
48b7da8c-a0d4-4636-b810-75a3e9eb08d3	f90ee443-8fcf-4dbb-aeaa-273e90484c41	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 17:21:13+00	2026-04-27 17:22:00+00	30	68	completed	Dangote is feeding Nigeria and building Nigeria. This ad shows both.
325fa6ac-a019-4517-a701-d21afb713a6d	f90ee443-8fcf-4dbb-aeaa-273e90484c41	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-04 19:35:13+00	2026-05-04 19:36:00+00	43	92	completed	The ad's focus on reliability matches my personal experience with the product.
fd98f02a-fe56-4913-aa50-2253cd443515	f90ee443-8fcf-4dbb-aeaa-273e90484c41	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-22 21:39:05+00	2026-04-22 21:40:00+00	26	69	completed	Made me think about switching from my current supplier to Dangote.
97f7f26e-f082-4c4d-b2dd-27e0a4062d83	c3bd05bf-c22f-422b-91bc-b4ee405913fd	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 19:05:10+00	2026-04-21 19:06:00+00	33	84	completed	Great job on the ad! Dangote is truly transforming Nigeria.
eb9bd312-f0ac-417b-b844-e54cf4e075fb	430fef7b-211e-4617-a19d-7feafd030d6c	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-28 21:39:02+00	2026-04-28 21:40:00+00	35	61	completed	As a real estate developer, Dangote cement is my go-to. Love this ad.
dd77da3f-6285-4045-83db-91807ac9b749	430fef7b-211e-4617-a19d-7feafd030d6c	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-30 23:06:42+00	2026-04-30 23:07:00+00	25	92	completed	The ad was persuasive without being pushy. Perfect for the brand.
b970045c-2c1e-4042-8d10-3f4fcb44326c	f4456d9b-7c4e-4a9c-9f23-b6139bf60906	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-21 23:27:11+00	2026-04-21 23:28:00+00	19	90	completed	Excellent campaign. Shows Dangote understands their Nigerian customers.
b43d393b-18fd-4222-84be-e9a02d4f4014	f4456d9b-7c4e-4a9c-9f23-b6139bf60906	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-02 07:01:34+00	2026-05-02 07:02:00+00	25	71	completed	The ad was engaging for my demographic — working class Nigerian.
8a449245-6285-4e9c-b412-713b4ec40f9d	f4456d9b-7c4e-4a9c-9f23-b6139bf60906	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-23 09:25:45+00	2026-04-23 09:26:00+00	31	83	completed	Would love to see Dangote advertise their sugar and flour products too.
20ec81ca-6a65-475a-9897-2b67712fd4bc	9064b7c5-d14e-43d5-ac45-21518e4a1502	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-25 07:06:45+00	2026-04-25 07:07:00+00	28	70	completed	The imagery of strong Nigerian homes built with Dangote was powerful.
4de05ad6-46bf-4a09-b484-fc40bbfd8e23	e7f044e8-487b-4995-83b7-0900b6aab267	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 09:56:27+00	2026-04-26 09:57:00+00	15	94	completed	The comparison with imported cement is implied but effective.
525414ea-3ff1-446d-8e5e-74f03b6bb4ec	e7f044e8-487b-4995-83b7-0900b6aab267	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 11:29:11+00	2026-04-27 11:30:00+00	34	67	completed	Trusted brand, great ad. Will share this with my estate agent network.
e0728c97-46d0-4171-a257-436008b88a65	0a708c77-9b65-4843-aac8-a4da7a150572	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 11:58:04+00	2026-04-26 11:59:00+00	34	68	completed	Beautiful execution. Shows Dangote knows their audience.
f2c5b24a-7002-4cf0-9ebd-4817ab110300	0a708c77-9b65-4843-aac8-a4da7a150572	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 13:22:28+00	2026-04-26 13:23:00+00	44	98	completed	Very relevant to my life right now as I'm renovating my property.
36ce9f6d-dd95-4e25-b630-62db3e81d957	0a708c77-9b65-4843-aac8-a4da7a150572	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 15:18:26+00	2026-04-27 15:19:00+00	17	67	completed	The pride of using Nigerian products came through in the ad.
197bb758-943a-48a1-b906-591277454a13	259b82b4-1ffb-477f-add3-15b08f061e2d	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-03 13:49:22+00	2026-05-03 13:50:00+00	28	84	completed	Good pacing. Didn't feel too long or too rushed.
5a98bf41-39db-4f91-9c9f-5df5d4b211aa	c0e4a2c4-cd8a-4dcd-9f99-89d0019a24fb	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-23 15:41:13+00	2026-04-23 15:42:00+00	19	70	completed	Made me curious to visit the Dangote website for more information.
f01440cc-3ec2-449a-874d-3972827d2d2b	c0e4a2c4-cd8a-4dcd-9f99-89d0019a24fb	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-22 17:41:03+00	2026-04-22 17:42:00+00	17	90	completed	The ad spoke to both individual buyers and large-scale contractors. Smart.
7a165eff-7218-42c5-a7d0-a22c3f8058be	7f8d51b9-6769-40a2-8690-48eabb1fc122	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-29 17:31:39+00	2026-04-29 17:32:00+00	17	97	completed	I'm in Kaduna and Dangote cement is everywhere here. Good ad.
e27dfc85-f62d-4cf5-b07c-80800fe861da	7f8d51b9-6769-40a2-8690-48eabb1fc122	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-03 19:40:40+00	2026-05-03 19:41:00+00	42	68	completed	The call to action at the end was clear and actionable.
9c31935b-68b4-49e0-85cf-bf1453603d04	7f8d51b9-6769-40a2-8690-48eabb1fc122	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-26 21:38:15+00	2026-04-26 21:39:00+00	38	93	completed	Watching this from Port Harcourt — Dangote is big here too!
091c6288-f640-465b-b89f-73d708be0798	5401247a-d1c6-4747-aef1-6fac25c8a188	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 19:53:08+00	2026-04-27 19:54:00+00	23	69	completed	The emphasis on job creation resonated with me. Patriotic angle worked.
ddd34d9f-8979-4095-90e7-57a0037e7f35	4fee828d-a7c5-4a87-bd4d-ed04decf7bdb	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-30 21:38:09+00	2026-04-30 21:39:00+00	36	94	completed	Ad reinforces why Dangote remains the gold standard in Nigeria.
b5403e89-71c6-4a98-ae9a-8aa225be72bb	4fee828d-a7c5-4a87-bd4d-ed04decf7bdb	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-05-01 23:53:18+00	2026-05-01 23:54:00+00	24	63	completed	As a civil engineering student, this ad is inspiring for our industry.
862825fc-bdde-41ba-8a71-c43dcae272d9	b0c8b78d-e858-4e7c-9a07-14d288480618	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-26 22:59:21+00	2026-04-26 23:00:00+00	18	59	completed	Touched on quality, durability, and trust. Hit all the right notes.
97826de9-5942-48db-a55e-190c0fdd6abd	b0c8b78d-e858-4e7c-9a07-14d288480618	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-05-01 07:50:45+00	2026-05-01 07:51:00+00	42	86	completed	Fantastic campaign. Glad to be reviewing content from Dangote.
d2bf5d62-f10c-4c6f-9233-8933ebf76c2d	b0c8b78d-e858-4e7c-9a07-14d288480618	c1fe2aec-5508-4711-990d-3dbc1fb761e0	2026-04-27 09:14:03+00	2026-04-27 09:15:00+00	16	63	completed	The Nigerian landscape in the ad background was a nice touch.
7d97ebb8-47a5-4ec2-a1e0-a28fe7ce1a65	a350339b-d835-42f1-8e65-fcc50920a097	f7fd0f69-bde1-4106-89fc-7d44f2aff71c	2026-04-27 07:56:13+00	2026-04-27 07:57:00+00	37	87	completed	Ad was clear about the value proposition. No confusion.
738e0026-1828-495e-bc19-3b5a6764175d	85ec9791-dc91-46cb-b7da-51f8af983a04	b816c046-cefc-430c-a25b-6c35f958302d	2026-05-04 11:23:42.027647+00	\N	\N	\N	in_progress	\N
\.


--
-- Data for Name: reviewer_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviewer_profiles (id, user_id, gender, age_band, state, employment_status, education_level, created_at, updated_at) FROM stdin;
0d7e6933-9dd6-42e1-a6a7-2cb56f33852a	844f4ae8-0c18-4556-8196-518df739b1a7	female	25_34	Kano	self_employed	secondary	2026-05-04 11:14:31.309083+00	2026-05-04 11:14:31.309083+00
1b05300a-0923-4d8d-ae8e-53bbdf09d025	de513c1b-475b-4888-a59f-8f3beaf5955f	male	45_54	FCT – Abuja	unemployed	masters	2026-05-04 11:14:31.335032+00	2026-05-04 11:14:31.335032+00
e7d3ae04-f65f-4a12-9488-7eeea941e645	58f512f8-49f5-4127-882c-f7e89ba5ddcb	female	55_plus	Oyo	retired	phd	2026-05-04 11:14:31.341439+00	2026-05-04 11:14:31.341439+00
3792b8cd-372d-45c7-b1d8-09eb14b01cc8	1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	male	25_34	Delta	self_employed	primary	2026-05-04 11:14:31.354335+00	2026-05-04 11:14:31.354335+00
cc681a63-8ba8-4746-862c-d9bf898393c4	5abc318c-dd54-4f4b-9498-69407fa70fe0	female	35_44	Enugu	student	secondary	2026-05-04 11:14:31.360551+00	2026-05-04 11:14:31.360551+00
4d70b7b9-0a18-4081-aad9-ea6bcf67d913	d481280c-9d2c-4fe5-b549-0ec647499af5	male	55_plus	Imo	retired	masters	2026-05-04 11:14:31.37225+00	2026-05-04 11:14:31.37225+00
1fbb7ae6-e0c6-4dfb-98a7-a52a90bc59d6	706d3279-0e2d-40b0-aa1d-578c435f3b42	female	18_24	Edo	employed	phd	2026-05-04 11:14:31.377972+00	2026-05-04 11:14:31.377972+00
d6df1e05-752c-416d-82c9-c66fc2058a5e	6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	male	35_44	Borno	student	primary	2026-05-04 11:14:31.389086+00	2026-05-04 11:14:31.389086+00
b7a28688-4d19-4bcf-99ac-700cc1c14ccf	4a468db0-bb0d-4696-984a-a7e68ba0c80f	female	45_54	Katsina	unemployed	secondary	2026-05-04 11:14:31.394232+00	2026-05-04 11:14:31.394232+00
14367fab-aa8a-4f80-978b-d6c603f2f697	352944b9-b107-418b-8420-ce5f98e1ed4f	male	18_24	Bauchi	employed	masters	2026-05-04 11:14:31.406114+00	2026-05-04 11:14:31.406114+00
b4a0bbe2-e3ab-4a2e-9b16-50f2c1c38106	e5d58143-9ec0-43aa-b649-487b7168c422	female	25_34	Adamawa	self_employed	phd	2026-05-04 11:14:31.414398+00	2026-05-04 11:14:31.414398+00
5d6af62a-69d9-4c08-8628-286cc0bf3385	412657a8-b0db-4dc9-a50e-e9358092e49a	male	45_54	Kwara	unemployed	primary	2026-05-04 11:14:31.425394+00	2026-05-04 11:14:31.425394+00
44056fcc-066d-42d9-a8eb-f261a24fbb9c	48ca762c-7c2a-4525-8861-372e5c49cd6d	female	55_plus	Cross River	retired	secondary	2026-05-04 11:14:31.43042+00	2026-05-04 11:14:31.43042+00
67ff43ae-2f06-45f8-8c4b-73b357f047aa	cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	male	25_34	Ekiti	self_employed	masters	2026-05-04 11:14:31.441137+00	2026-05-04 11:14:31.441137+00
9780a9a7-ca96-44d9-8d29-619b6150b0de	43ea8459-f0f4-41fb-98e7-1714b9ce81ea	female	35_44	Osun	student	phd	2026-05-04 11:14:31.447125+00	2026-05-04 11:14:31.447125+00
12ec84af-2bec-4fc3-85a7-014c92e3783f	21b0e483-154e-4e6a-a9ca-3c56585e36b0	male	55_plus	Benue	retired	primary	2026-05-04 11:14:31.459296+00	2026-05-04 11:14:31.459296+00
3596a396-338b-4966-8ec4-202091495728	1c19d853-8e34-4aab-b2d3-30db3dd91239	female	18_24	Kebbi	employed	secondary	2026-05-04 11:14:31.465546+00	2026-05-04 11:14:31.465546+00
775d2bfb-cbc8-44e0-814d-a927609dee3b	76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	male	35_44	Taraba	student	masters	2026-05-04 11:14:31.477995+00	2026-05-04 11:14:31.477995+00
005d98df-f003-4578-a214-4eb836073f9d	38c4aba5-0612-4f86-aa76-a47db8320cff	female	45_54	Zamfara	unemployed	phd	2026-05-04 11:14:31.484025+00	2026-05-04 11:14:31.484025+00
424d9aaa-7425-4111-886e-cf395d135eb8	8e19c3fb-7be8-4aa5-b5bd-af171861b57c	male	18_24	Kano	employed	primary	2026-05-04 11:14:31.495881+00	2026-05-04 11:14:31.495881+00
aff53707-f889-4073-afdd-6a4d33911652	28d15e56-e782-4bad-9ce9-9c479390cac4	female	25_34	Rivers	self_employed	secondary	2026-05-04 11:14:31.50173+00	2026-05-04 11:14:31.50173+00
e2da664d-df26-426f-ba40-e539c37e9666	ab043822-4518-4915-b133-b9320ab0fd16	male	45_54	Oyo	unemployed	masters	2026-05-04 11:14:31.513514+00	2026-05-04 11:14:31.513514+00
25a9f139-d84c-4e33-affd-a26fd5b1b088	104ac577-7486-41a2-8d57-1ff9792e7c1b	female	55_plus	Kaduna	retired	phd	2026-05-04 11:14:31.519352+00	2026-05-04 11:14:31.519352+00
1e4760d3-167d-4862-9019-9357c9c264f2	4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	male	25_34	Enugu	self_employed	primary	2026-05-04 11:14:31.532046+00	2026-05-04 11:14:31.532046+00
1178a627-6a01-4c4c-9c98-243bb990028c	240e8cfc-eed0-44a4-89bc-d9145a6ebeed	female	35_44	Anambra	student	secondary	2026-05-04 11:14:31.537434+00	2026-05-04 11:14:31.537434+00
9e390acb-3635-499a-a06f-eccd780420ed	7eebcbb6-338d-4d54-b25e-dba123a39d2a	male	55_plus	Edo	retired	masters	2026-05-04 11:14:31.54922+00	2026-05-04 11:14:31.54922+00
42d48041-12ba-4e32-884a-f8976fb0c685	e46b6720-49db-4e3d-b6cd-d849cb0c9eeb	female	18_24	Ogun	employed	phd	2026-05-04 11:14:31.555804+00	2026-05-04 11:14:31.555804+00
0f954c77-7f75-48dd-8dcd-330284866c9f	766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	male	35_44	Katsina	student	primary	2026-05-04 11:14:31.567508+00	2026-05-04 11:14:31.567508+00
74b3604d-02df-4af0-b5eb-3c9ff96f91f7	4987c977-6c68-4103-9863-6e0adfc4f276	female	45_54	Sokoto	unemployed	secondary	2026-05-04 11:14:31.573358+00	2026-05-04 11:14:31.573358+00
fda64899-a868-4061-8cf4-5c2dabacd64b	e1d417cb-810f-49ae-8ea7-2eeac36ec593	male	18_24	Adamawa	employed	masters	2026-05-04 11:14:31.584889+00	2026-05-04 11:14:31.584889+00
042dd46e-f8ef-492c-8635-e55bd483fedb	f3ca9228-81d7-4fd1-9f0f-abf29cbe5cfb	female	25_34	Plateau	self_employed	phd	2026-05-04 11:14:31.59124+00	2026-05-04 11:14:31.59124+00
d8f4a979-9cc8-4b97-9177-d4468de85809	03bf8260-a5d7-4fa0-9af2-e59e891d3dab	male	45_54	Cross River	unemployed	primary	2026-05-04 11:14:31.604129+00	2026-05-04 11:14:31.604129+00
3d52693f-5b2f-4fa0-90a8-77a4a4032b85	11c233d8-13db-4b03-a065-b452f15b371a	female	55_plus	Ondo	retired	secondary	2026-05-04 11:14:31.610176+00	2026-05-04 11:14:31.610176+00
a12d140a-d2ef-464f-a0ad-5cf4ca1f601d	17a2da93-6d4d-46a1-bb3d-ec5aa7850445	male	25_34	Osun	self_employed	masters	2026-05-04 11:14:31.622063+00	2026-05-04 11:14:31.622063+00
c645c2ec-0f6a-4fab-b94f-c74131f50a68	1d3b38c3-dcfe-419c-ab19-744d2fe7733e	female	35_44	Abia	student	phd	2026-05-04 11:14:31.628115+00	2026-05-04 11:14:31.628115+00
166720c2-c5ca-4cc4-96de-eaf8cace5a2a	72d87e8e-f5c1-48e6-b047-c94fab9c7393	male	55_plus	Kebbi	retired	primary	2026-05-04 11:14:31.640227+00	2026-05-04 11:14:31.640227+00
dda18546-0ac1-46f0-8e0a-42c28347dd40	0d08839e-ebe9-4f14-b879-8c56c0044f33	female	18_24	Niger	employed	secondary	2026-05-04 11:14:31.646456+00	2026-05-04 11:14:31.646456+00
548c1501-e84d-4caa-8419-03e02e5c58b5	e7da5f29-e44a-4585-81fd-2244675f45fd	male	35_44	Zamfara	student	masters	2026-05-04 11:14:31.657658+00	2026-05-04 11:14:31.657658+00
53066783-5d02-44ad-bec7-76692c43634b	39add4d6-53a8-4896-984f-f247a9d5a2b7	female	45_54	Lagos	unemployed	phd	2026-05-04 11:14:31.663933+00	2026-05-04 11:14:31.663933+00
0096bd8c-1fcc-4471-9209-d37ddb4b1fc2	b9c3be6b-8da0-4414-bf50-69410fa774bb	male	18_24	Rivers	employed	primary	2026-05-04 11:14:31.677953+00	2026-05-04 11:14:31.677953+00
fb119858-4096-4408-ad96-a07db55f59c7	7b9e7324-16e7-4b01-944d-4f6ff9384366	female	25_34	FCT – Abuja	self_employed	secondary	2026-05-04 11:14:31.683977+00	2026-05-04 11:14:31.683977+00
8de7085c-d822-48d7-9ce1-9c0db02bd4e3	9550b05b-35a6-40e9-af4d-c83a83a2a96d	male	45_54	Kaduna	unemployed	masters	2026-05-04 11:14:31.694235+00	2026-05-04 11:14:31.694235+00
24104d75-e465-4ea2-951a-9f8143f2f942	d93b2055-e8b3-4438-bb78-b7f288ae6e2c	female	55_plus	Delta	retired	phd	2026-05-04 11:14:31.7001+00	2026-05-04 11:14:31.7001+00
67504286-2c1f-4707-a830-4b7ebbb6685d	82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	male	25_34	Anambra	self_employed	primary	2026-05-04 11:14:31.712253+00	2026-05-04 11:14:31.712253+00
a0fb449b-2049-47fd-ae68-acce378b2c34	6890c0e7-eab0-4edd-8922-1186632c105b	female	35_44	Imo	student	secondary	2026-05-04 11:14:31.71898+00	2026-05-04 11:14:31.71898+00
de701eea-5ee9-4ab0-a860-a8706ec09fa2	4dfa4e2b-263f-4271-93c0-3e3af55a2f15	male	55_plus	Ogun	retired	masters	2026-05-04 11:14:31.731256+00	2026-05-04 11:14:31.731256+00
e41d9617-4170-4998-b09f-68e47e31b9d6	773a0438-e576-4ad7-b14f-5aefd011304c	female	18_24	Borno	employed	phd	2026-05-04 11:14:31.737212+00	2026-05-04 11:14:31.737212+00
6c97a248-a2e2-4e4d-a0f1-ad53ea8d87b2	3d6078c0-3a00-4652-8a0f-0aea34ef2e16	male	35_44	Sokoto	student	primary	2026-05-04 11:14:31.746914+00	2026-05-04 11:14:31.746914+00
c57e39b9-3e04-4bff-8585-b16940cd5746	641e883e-1fcc-44d7-b61f-45bf45daae83	female	45_54	Bauchi	unemployed	secondary	2026-05-04 11:14:31.752766+00	2026-05-04 11:14:31.752766+00
be6e6782-9558-49db-8902-61c697a61c28	221c08f9-07f2-4b22-a19a-86db67c5c7ba	male	18_24	Plateau	employed	masters	2026-05-04 11:14:31.764576+00	2026-05-04 11:14:31.764576+00
74d6e224-f31c-41d6-a56d-be72317ac743	5ac1cdcd-c7bf-42b3-bc27-96aa3b745080	female	25_34	Kwara	self_employed	phd	2026-05-04 11:14:31.771093+00	2026-05-04 11:14:31.771093+00
6b879ba9-c15e-429a-b47e-2558bd25e6dc	0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	male	45_54	Ondo	unemployed	primary	2026-05-04 11:14:31.784054+00	2026-05-04 11:14:31.784054+00
39050da0-ca68-442d-8343-e9d17abbddc9	fc553e0f-1b13-4104-93b7-db4d61313ca1	female	55_plus	Ekiti	retired	secondary	2026-05-04 11:14:31.78907+00	2026-05-04 11:14:31.78907+00
90be4e6f-2e3d-4824-9c90-56df9e10d476	9014881d-e2e6-49b3-b386-4883f4e380ba	male	25_34	Abia	self_employed	masters	2026-05-04 11:14:31.800655+00	2026-05-04 11:14:31.800655+00
2d0945c8-269d-41d5-9c79-6d8bbb9050be	8a22e5e3-618d-4e9d-a8e6-83aa38ecae41	female	35_44	Benue	student	phd	2026-05-04 11:14:31.806393+00	2026-05-04 11:14:31.806393+00
3fba7c9d-d07d-4d55-b0c2-7aff20ee997b	15753795-0698-4fd8-898d-cd03f4ee0a9e	male	55_plus	Niger	retired	primary	2026-05-04 11:14:31.819216+00	2026-05-04 11:14:31.819216+00
fac92d00-774f-48ab-9375-c8b880f56d5f	9c4ae611-b83a-4f21-bbc9-c2f5115feed2	female	18_24	Taraba	employed	secondary	2026-05-04 11:14:31.824502+00	2026-05-04 11:14:31.824502+00
047216d1-d9ad-4d25-af04-d0ac249209e5	f90ee443-8fcf-4dbb-aeaa-273e90484c41	male	35_44	Lagos	student	masters	2026-05-04 11:14:31.836025+00	2026-05-04 11:14:31.836025+00
2fc34857-eacb-46dd-a834-067955a94153	c3bd05bf-c22f-422b-91bc-b4ee405913fd	female	45_54	Kano	unemployed	phd	2026-05-04 11:14:31.841796+00	2026-05-04 11:14:31.841796+00
d56779be-8e61-4699-b076-c91cdb2bda8a	f4456d9b-7c4e-4a9c-9f23-b6139bf60906	male	18_24	FCT – Abuja	employed	primary	2026-05-04 11:14:31.854039+00	2026-05-04 11:14:31.854039+00
f7368b3a-052c-4b3f-a1d4-09611ab1d955	9064b7c5-d14e-43d5-ac45-21518e4a1502	female	25_34	Oyo	self_employed	secondary	2026-05-04 11:14:31.859619+00	2026-05-04 11:14:31.859619+00
9053e5aa-436e-4334-9e9e-2a43b6da66c3	0a708c77-9b65-4843-aac8-a4da7a150572	male	45_54	Delta	unemployed	masters	2026-05-04 11:14:31.87098+00	2026-05-04 11:14:31.87098+00
4e70cbe0-6f22-4e2e-8e44-dc22a00f0e26	259b82b4-1ffb-477f-add3-15b08f061e2d	female	55_plus	Enugu	retired	phd	2026-05-04 11:14:31.876169+00	2026-05-04 11:14:31.876169+00
8485fd41-f0d7-4cae-ac90-fe7b5c1fc874	7f8d51b9-6769-40a2-8690-48eabb1fc122	male	25_34	Imo	self_employed	primary	2026-05-04 11:14:31.887111+00	2026-05-04 11:14:31.887111+00
6b5a2c8b-cf41-40c6-9f1b-44c820b046c7	5401247a-d1c6-4747-aef1-6fac25c8a188	female	35_44	Edo	student	secondary	2026-05-04 11:14:31.892677+00	2026-05-04 11:14:31.892677+00
f794afca-e843-4352-b162-51104bf00d07	b0c8b78d-e858-4e7c-9a07-14d288480618	male	55_plus	Borno	retired	masters	2026-05-04 11:14:31.904976+00	2026-05-04 11:14:31.904976+00
923ad9d3-8d03-4968-9909-0dbd4183ccd7	a350339b-d835-42f1-8e65-fcc50920a097	female	18_24	Katsina	employed	phd	2026-05-04 11:14:31.910821+00	2026-05-04 11:14:31.910821+00
b693dcbc-d1a8-4c6f-b2e3-836076cd7e21	411cbccc-9d5e-45be-ad3c-90f99f13a1a9	\N	35_44	Rivers	student	bachelors	2026-05-04 11:14:31.328021+00	2026-05-04 11:14:31.328021+00
22d65728-b712-4457-9583-e0a77e0cf165	2080eedb-b15f-4a3c-978d-59145268d6dc	\N	18_24	Kaduna	employed	other	2026-05-04 11:14:31.348077+00	2026-05-04 11:14:31.348077+00
e787c3e8-d7b3-4379-8c9d-2e5469e8e62b	e115d60e-e348-4ec0-96b1-5247203a3b31	\N	45_54	Anambra	unemployed	bachelors	2026-05-04 11:14:31.366268+00	2026-05-04 11:14:31.366268+00
88457194-18a7-4303-bf5e-2e3df96c2768	b4cc310b-b857-4f04-a8d6-988cb89bc481	\N	25_34	Ogun	self_employed	other	2026-05-04 11:14:31.383281+00	2026-05-04 11:14:31.383281+00
c4982961-a484-4433-a60a-49803d6eacdd	fc410940-03db-4881-ba08-b2516b91b02a	\N	55_plus	Sokoto	retired	bachelors	2026-05-04 11:14:31.399963+00	2026-05-04 11:14:31.399963+00
a336bb34-5595-47e1-ae77-aa9b45974f4a	9ab9438c-f1c6-484e-8305-907dbf16d44d	\N	35_44	Plateau	student	other	2026-05-04 11:14:31.419906+00	2026-05-04 11:14:31.419906+00
135aad5e-5c1f-4ce4-84b7-73cfd4b11622	7d012f0b-5aa8-4bf7-88f1-191a8ce0288c	\N	18_24	Ondo	employed	bachelors	2026-05-04 11:14:31.435944+00	2026-05-04 11:14:31.435944+00
c7fc3cd7-b1db-4017-9d96-8b2262fccc1e	027161c5-87ac-425c-9ca9-e82f1007e47b	\N	45_54	Abia	unemployed	other	2026-05-04 11:14:31.453215+00	2026-05-04 11:14:31.453215+00
fb07aae7-ce48-4892-b126-926cdf9e9343	3fec7d15-2923-4f36-aaee-cb49b84a2901	\N	25_34	Niger	self_employed	bachelors	2026-05-04 11:14:31.471581+00	2026-05-04 11:14:31.471581+00
6b002431-dac2-458a-b644-68c2b1a8b5b5	3e38a0b3-aefb-4bf7-8a5a-24e03f590de3	\N	55_plus	Lagos	retired	other	2026-05-04 11:14:31.489969+00	2026-05-04 11:14:31.489969+00
c7514325-b749-4bc5-a372-28fc491de818	bd9cf8c9-aa13-4139-ae09-789c33a46b33	\N	35_44	FCT – Abuja	student	bachelors	2026-05-04 11:14:31.507377+00	2026-05-04 11:14:31.507377+00
6877e862-0fa1-46c8-86b2-1a4dac3e97de	f6c1113f-8c5d-4ebd-b8e6-1a306d832280	\N	18_24	Delta	employed	other	2026-05-04 11:14:31.525285+00	2026-05-04 11:14:31.525285+00
d6d56d50-93b6-4e9c-825c-29d50bd77fd3	5fdd91fd-1a88-4a80-aa84-1766dbf34344	\N	45_54	Imo	unemployed	bachelors	2026-05-04 11:14:31.542961+00	2026-05-04 11:14:31.542961+00
7998030a-aedf-4c2a-a502-1ed6fa3fe09b	edaa49fd-dd8c-4d7f-8ab3-2a8a01863e7f	\N	25_34	Borno	self_employed	other	2026-05-04 11:14:31.562323+00	2026-05-04 11:14:31.562323+00
2f8575fb-171a-4e6e-9309-fd8af698a8c4	ad185731-3f7e-4950-a9af-01962006c9e0	\N	55_plus	Bauchi	retired	bachelors	2026-05-04 11:14:31.579241+00	2026-05-04 11:14:31.579241+00
e2b962cc-d08b-4e64-886d-76c87da345f0	71b28923-6de8-47ee-88b4-f235a2a6373f	\N	35_44	Kwara	student	other	2026-05-04 11:14:31.597527+00	2026-05-04 11:14:31.597527+00
4f29157e-f4cc-45ee-8064-bde880afb7f5	64d8b8ef-cc91-4410-b2a9-d455a7c6a9f8	\N	18_24	Ekiti	employed	bachelors	2026-05-04 11:14:31.615868+00	2026-05-04 11:14:31.615868+00
fed16a2d-c16c-44bb-9c8a-91d85ad753ec	03cfc327-5d88-43c7-8612-31e7a5a8a833	\N	45_54	Benue	unemployed	other	2026-05-04 11:14:31.634202+00	2026-05-04 11:14:31.634202+00
04a93cc4-cd88-4642-a10b-39318a1a107a	7b982e66-76e6-438f-939a-77344b934380	\N	25_34	Taraba	self_employed	bachelors	2026-05-04 11:14:31.651888+00	2026-05-04 11:14:31.651888+00
42826bfd-a89d-4853-9ba0-10e3e492ac98	f8bcd338-39b0-4186-830f-228e55604064	\N	55_plus	Kano	retired	other	2026-05-04 11:14:31.671131+00	2026-05-04 11:14:31.671131+00
ac97b3e6-6ddd-41df-a50c-c304c7cb1fc6	8c7c19e3-3bd3-4b95-be5c-9f793d8db656	\N	35_44	Oyo	student	bachelors	2026-05-04 11:14:31.689403+00	2026-05-04 11:14:31.689403+00
40c08528-96bc-479a-93a6-60ae7772c2fd	9f7fa566-ec18-426f-b374-86b4596716ac	\N	18_24	Enugu	employed	other	2026-05-04 11:14:31.706008+00	2026-05-04 11:14:31.706008+00
062bc938-b10a-4856-8d4f-88f9069f21d2	a0d8b8d9-fb84-4b41-9928-aa4abfa255b4	\N	45_54	Edo	unemployed	bachelors	2026-05-04 11:14:31.724792+00	2026-05-04 11:14:31.724792+00
cd62db47-600f-45ef-b248-5ac7d13493f7	3a5b9d93-ed69-4d00-8ab2-8122511c2ec2	\N	25_34	Katsina	self_employed	other	2026-05-04 11:14:31.742062+00	2026-05-04 11:14:31.742062+00
ca36b986-731f-47b4-8635-eb6a6bf1abbf	2d6bf6ed-8785-41e6-a41a-0f80907edeb0	\N	55_plus	Adamawa	retired	bachelors	2026-05-04 11:14:31.759016+00	2026-05-04 11:14:31.759016+00
7da7e61c-88ae-4f86-b9a3-453bbdb48ade	9221e178-bf98-4523-9701-37a463c71ff5	\N	35_44	Cross River	student	other	2026-05-04 11:14:31.777966+00	2026-05-04 11:14:31.777966+00
78503484-793b-49cf-8fbe-00bbf3f385a4	b015caff-4ca4-4999-9acf-b99c11df8215	\N	18_24	Osun	employed	bachelors	2026-05-04 11:14:31.794124+00	2026-05-04 11:14:31.794124+00
30bd6c15-9581-4c58-a082-2da5246519de	5b90a702-4abe-4847-8549-70228af35bc5	\N	45_54	Kebbi	unemployed	other	2026-05-04 11:14:31.812305+00	2026-05-04 11:14:31.812305+00
ce8afc5e-861b-4ba7-8257-6704b513873f	575a77de-f3b5-4fcf-a3b7-bb3c71766358	\N	25_34	Zamfara	self_employed	bachelors	2026-05-04 11:14:31.830391+00	2026-05-04 11:14:31.830391+00
d5571d2d-68ca-4604-8007-7ebe3afb07a8	430fef7b-211e-4617-a19d-7feafd030d6c	\N	55_plus	Rivers	retired	other	2026-05-04 11:14:31.847656+00	2026-05-04 11:14:31.847656+00
f4efaf74-bd15-465d-b4fd-24be784d41fe	e7f044e8-487b-4995-83b7-0900b6aab267	\N	35_44	Kaduna	student	bachelors	2026-05-04 11:14:31.866251+00	2026-05-04 11:14:31.866251+00
e9a7488a-0c7c-4c8a-9618-0683ab1fdce5	c0e4a2c4-cd8a-4dcd-9f99-89d0019a24fb	\N	18_24	Anambra	employed	other	2026-05-04 11:14:31.881418+00	2026-05-04 11:14:31.881418+00
dcf9ddf8-3378-42a1-844f-dda62e342805	4fee828d-a7c5-4a87-bd4d-ed04decf7bdb	\N	45_54	Ogun	unemployed	bachelors	2026-05-04 11:14:31.898196+00	2026-05-04 11:14:31.898196+00
\.


--
-- Data for Name: reward_claims; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reward_claims (id, reward_id, user_id, redemption_code, claimed_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, username, role, created_at, updated_at) FROM stdin;
741fbf4b-afda-422f-a134-b5c51dd972f4	test@test.com	$2b$12$QB.UeLhFxkHDz62nEG8jD.FEaPDQRbSyQEsMCjiDmi9QnIDKFAEPa	testuser	reviewer	2026-05-02 17:38:12.096938+00	2026-05-02 17:38:12.096938+00
98abd0b2-a97c-40b9-a1dc-03142d6eea61	newbrand@test.com	$2b$12$pfPNRi8nYcd.zOAJKcjRdOj3bFL/DZeqBJpiryZXm7K5jZvfiPy82	newbrand	brand	2026-05-02 17:53:56.007176+00	2026-05-02 17:53:56.007176+00
9c9b308b-e68b-44f6-80c4-8d52adc0e97d	testbrand2@example.com	$2b$12$i9V3mxXEOZLdMyIqlmaDH.yulrvYTV4CEevifmyiYtqXh5OE0/gGO	testbrand2	brand	2026-05-02 17:55:59.646221+00	2026-05-02 17:55:59.646221+00
06a1e7e1-ac24-4ca5-8740-24a2c1a71378	newbrand99@test.com	$2b$12$C4uZDhuskTkbAjGfjTQGquFS8fLwqtoHHmRUcrXMjbbFYJJgPq6xm	newbrand99	brand	2026-05-02 17:56:37.493856+00	2026-05-02 17:56:37.493856+00
572284ed-7fb3-4f13-8c43-24976496bdc4	brandx99@test.com	$2b$12$f4gGKAtOuZXuzdtzHNMbLevSgQ5kw1O/gjqqh980dR0uQoNvWfrxi	brandx99	brand	2026-05-02 17:58:07.977812+00	2026-05-02 17:58:07.977812+00
1380e418-cbad-4825-acbf-4bdb91bf1c5f	brandz100@test.com	$2b$12$eciHZF1oYwhE86wMcBvs.etWEbHOE11TaZeYbwEZpcM1hDsy7nqua	brandz100	brand	2026-05-02 18:03:19.465086+00	2026-05-02 18:03:19.465086+00
6c240835-a66f-4aa5-a782-2f3343334a73	brandz202@test.com	$2b$12$OFkyG0sM7Ul3Ngw3QlN/0u9LwyWmzyY4IbHUKmE4mUEtECc5q8W56	brandz202	brand	2026-05-02 18:08:48.406377+00	2026-05-02 18:08:48.406377+00
4550cf82-811c-45ae-805b-24ecda62029d	testreviewer99@test.com	$2b$12$u1ioC/nmuQUagfEWH4aB9.Eg/T4wUeAzwzxs3tYgzT3fkzdVlncwu	testreviewer99	reviewer	2026-05-02 18:34:08.955537+00	2026-05-02 18:34:08.955537+00
105ea61a-fa47-47f5-a7bf-f576b41b75b8	brand-test-1777755590732@example.com	$2b$12$g2kY7WSpwBjgKfMgS.E1Hu1NlDWSEF1WXjRi.MBg..O5Mp3His/iC	brandtester43060	brand	2026-05-02 21:00:02.800231+00	2026-05-02 21:00:02.800231+00
135d7699-6e7b-4a84-8b38-3c1ac65a1340	brand1777755771379@test.com	$2b$12$SNdv9DSZH/6/oIC.PKL.NOiWwJb28sNLt2TLjg03wwUbDpvHXsVPG	brand771379	brand	2026-05-02 21:04:06.865394+00	2026-05-02 21:04:06.865394+00
985de5ae-27d8-44d0-b2c2-fc0b32d65a19	brand1777756453070@test.com	$2b$12$olHy/VlDWiqcdPxOPi08oeu/aV5C3ZYpiY5MCtXOW3aDKQ..sYCza	brand453070	brand	2026-05-02 21:15:03.880518+00	2026-05-02 21:15:03.880518+00
7218e299-4644-4f20-b480-8b59fee930eb	admin@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	admin	admin	2026-05-02 17:37:57.748553+00	2026-05-02 17:37:57.748553+00
61abef6b-4917-4d0a-a6d0-5f50137a6a71	brand1@acmecorp.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	acmecorp	brand	2026-05-02 17:37:57.757346+00	2026-05-02 17:37:57.757346+00
4fd1f0dc-bb89-4897-8ee8-e4eb98e26cdd	brand2@techwave.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	techwave	brand	2026-05-02 17:37:57.761345+00	2026-05-02 17:37:57.761345+00
85ec9791-dc91-46cb-b7da-51f8af983a04	alice@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	alice_reviews	reviewer	2026-05-02 17:37:57.771714+00	2026-05-02 17:37:57.771714+00
1c1ba66f-1c47-43b9-b3c6-d314426eb145	bob@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	bob_watches	reviewer	2026-05-02 17:37:57.775026+00	2026-05-02 17:37:57.775026+00
e89a4458-7ea7-41d9-bb3c-fce388d89786	carol@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	carol_critic	reviewer	2026-05-02 17:37:57.778396+00	2026-05-02 17:37:57.778396+00
6902ee2a-e1dc-4185-badf-9c0d01e2711e	david@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	david_rate	reviewer	2026-05-02 17:37:57.782081+00	2026-05-02 17:37:57.782081+00
b01b170f-5d12-448a-bab4-1aae4c19007d	eve@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	eve_eagle	reviewer	2026-05-02 17:37:57.785603+00	2026-05-02 17:37:57.785603+00
0bdfe30f-eb98-4a61-8aee-873a46e3bf40	frank@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	frank_fan	reviewer	2026-05-02 17:37:57.788671+00	2026-05-02 17:37:57.788671+00
ef469f0d-6242-4385-9125-a99beb8c6cd1	grace@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	grace_gem	reviewer	2026-05-02 17:37:57.791924+00	2026-05-02 17:37:57.791924+00
ff53cafa-c092-4b35-bf55-8b03054f62e7	henry@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	henry_hawk	reviewer	2026-05-02 17:37:57.795211+00	2026-05-02 17:37:57.795211+00
196ede38-71c7-4ad7-bee5-d3dfbd43a752	iris@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	iris_insight	reviewer	2026-05-02 17:37:57.798012+00	2026-05-02 17:37:57.798012+00
ab994e97-fe94-48ea-8e4d-cd937f113249	jack@reviewer.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	jack_judge	reviewer	2026-05-02 17:37:57.80142+00	2026-05-02 17:37:57.80142+00
65f4f8a1-c065-44f4-8662-3205d557b004	legend@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	legendhotel	brand	2026-05-02 18:23:02.824828+00	2026-05-02 18:23:02.824828+00
fe6047ce-7709-4778-bdde-40dd92a18dba	mtn@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	mtnuganda	brand	2026-05-02 18:23:02.824828+00	2026-05-02 18:23:02.824828+00
43079cf5-db3f-4f58-b30e-c2205aa0444e	clubbeer@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	clubbeer	brand	2026-05-02 18:23:02.824828+00	2026-05-02 18:23:02.824828+00
14e57746-0fc0-4a07-971b-a422e57d2b7a	safeboda@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	safeboda	brand	2026-05-02 18:23:02.824828+00	2026-05-02 18:23:02.824828+00
a88502c0-1135-4146-b87a-1405e5093171	airtel@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	airtel_nigeria	brand	2026-05-02 18:51:11.477992+00	2026-05-02 18:51:11.477992+00
ae9b9099-8d0f-4303-8ee8-3bb6151e6a04	guinness@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	guinness_ng	brand	2026-05-02 18:51:11.484381+00	2026-05-02 18:51:11.484381+00
e37ee3e7-9abf-4312-bb8b-ff2606c14a41	dangote@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	dangote_group	brand	2026-05-02 18:51:11.492391+00	2026-05-02 18:51:11.492391+00
d500cde9-eaca-4d95-86c1-f2ef11058887	jumia@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	jumia_ng	brand	2026-05-02 18:51:11.49802+00	2026-05-02 18:51:11.49802+00
907f1369-c234-415b-a698-a6eae4c4c186	gtbank@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	gtbank_ng	brand	2026-05-02 18:51:11.504365+00	2026-05-02 18:51:11.504365+00
0b4d81ce-b952-4b2b-9da6-08d82268274b	indomie@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	indomie_ng	brand	2026-05-02 18:55:37.245306+00	2026-05-02 18:55:37.245306+00
b20140d7-cb29-4d13-897d-806e3992c88f	peakmilk@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	peak_milk	brand	2026-05-02 18:55:37.252268+00	2026-05-02 18:55:37.252268+00
b5f0aa75-6efb-4d7c-9ff9-0a8449977f7c	flutterwave@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	flutterwave	brand	2026-05-02 18:55:37.259655+00	2026-05-02 18:55:37.259655+00
1b5c5409-c401-444a-84c0-f7e0757348d0	paystack@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	paystack_ng	brand	2026-05-02 18:55:37.268146+00	2026-05-02 18:55:37.268146+00
96ad3008-f19a-4450-acb8-536cb371e4a5	superadmin@adspot.demo	$2b$12$fSZQvue4ZVpXwjDgAP9mFeLe7x0ULkXf2zKJuDqN.NfpFJjEu4C0e	superadmin	super_admin	2026-05-02 19:36:14.682476+00	2026-05-02 19:36:14.682476+00
844f4ae8-0c18-4556-8196-518df739b1a7	dangote_reviewer_1@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_1	reviewer	2026-05-04 11:14:31.274204+00	2026-05-04 11:14:31.274204+00
411cbccc-9d5e-45be-ad3c-90f99f13a1a9	dangote_reviewer_2@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_2	reviewer	2026-05-04 11:14:31.323875+00	2026-05-04 11:14:31.323875+00
de513c1b-475b-4888-a59f-8f3beaf5955f	dangote_reviewer_3@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_3	reviewer	2026-05-04 11:14:31.331594+00	2026-05-04 11:14:31.331594+00
58f512f8-49f5-4127-882c-f7e89ba5ddcb	dangote_reviewer_4@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_4	reviewer	2026-05-04 11:14:31.338468+00	2026-05-04 11:14:31.338468+00
2080eedb-b15f-4a3c-978d-59145268d6dc	dangote_reviewer_5@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_5	reviewer	2026-05-04 11:14:31.344865+00	2026-05-04 11:14:31.344865+00
1ea1dd72-d8aa-4e17-be19-fd3f9bb90ec3	dangote_reviewer_6@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_6	reviewer	2026-05-04 11:14:31.351408+00	2026-05-04 11:14:31.351408+00
5abc318c-dd54-4f4b-9498-69407fa70fe0	dangote_reviewer_7@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_7	reviewer	2026-05-04 11:14:31.357898+00	2026-05-04 11:14:31.357898+00
e115d60e-e348-4ec0-96b1-5247203a3b31	dangote_reviewer_8@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_8	reviewer	2026-05-04 11:14:31.363102+00	2026-05-04 11:14:31.363102+00
d481280c-9d2c-4fe5-b549-0ec647499af5	dangote_reviewer_9@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_9	reviewer	2026-05-04 11:14:31.369382+00	2026-05-04 11:14:31.369382+00
706d3279-0e2d-40b0-aa1d-578c435f3b42	dangote_reviewer_10@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_10	reviewer	2026-05-04 11:14:31.374568+00	2026-05-04 11:14:31.374568+00
b4cc310b-b857-4f04-a8d6-988cb89bc481	dangote_reviewer_11@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_11	reviewer	2026-05-04 11:14:31.380457+00	2026-05-04 11:14:31.380457+00
6dccf3c0-f59c-4ab4-ba77-ba2dc06ed528	dangote_reviewer_12@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_12	reviewer	2026-05-04 11:14:31.3863+00	2026-05-04 11:14:31.3863+00
4a468db0-bb0d-4696-984a-a7e68ba0c80f	dangote_reviewer_13@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_13	reviewer	2026-05-04 11:14:31.391781+00	2026-05-04 11:14:31.391781+00
fc410940-03db-4881-ba08-b2516b91b02a	dangote_reviewer_14@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_14	reviewer	2026-05-04 11:14:31.396781+00	2026-05-04 11:14:31.396781+00
352944b9-b107-418b-8420-ce5f98e1ed4f	dangote_reviewer_15@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_15	reviewer	2026-05-04 11:14:31.403046+00	2026-05-04 11:14:31.403046+00
e5d58143-9ec0-43aa-b649-487b7168c422	dangote_reviewer_16@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_16	reviewer	2026-05-04 11:14:31.40973+00	2026-05-04 11:14:31.40973+00
9ab9438c-f1c6-484e-8305-907dbf16d44d	dangote_reviewer_17@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_17	reviewer	2026-05-04 11:14:31.417483+00	2026-05-04 11:14:31.417483+00
412657a8-b0db-4dc9-a50e-e9358092e49a	dangote_reviewer_18@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_18	reviewer	2026-05-04 11:14:31.422629+00	2026-05-04 11:14:31.422629+00
48ca762c-7c2a-4525-8861-372e5c49cd6d	dangote_reviewer_19@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_19	reviewer	2026-05-04 11:14:31.427838+00	2026-05-04 11:14:31.427838+00
7d012f0b-5aa8-4bf7-88f1-191a8ce0288c	dangote_reviewer_20@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_20	reviewer	2026-05-04 11:14:31.43337+00	2026-05-04 11:14:31.43337+00
cdc45cf4-4f7c-486c-b47f-3349f3e8fee3	dangote_reviewer_21@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_21	reviewer	2026-05-04 11:14:31.43848+00	2026-05-04 11:14:31.43848+00
43ea8459-f0f4-41fb-98e7-1714b9ce81ea	dangote_reviewer_22@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_22	reviewer	2026-05-04 11:14:31.443783+00	2026-05-04 11:14:31.443783+00
027161c5-87ac-425c-9ca9-e82f1007e47b	dangote_reviewer_23@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_23	reviewer	2026-05-04 11:14:31.450218+00	2026-05-04 11:14:31.450218+00
21b0e483-154e-4e6a-a9ca-3c56585e36b0	dangote_reviewer_24@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_24	reviewer	2026-05-04 11:14:31.456934+00	2026-05-04 11:14:31.456934+00
1c19d853-8e34-4aab-b2d3-30db3dd91239	dangote_reviewer_25@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_25	reviewer	2026-05-04 11:14:31.462309+00	2026-05-04 11:14:31.462309+00
3fec7d15-2923-4f36-aaee-cb49b84a2901	dangote_reviewer_26@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_26	reviewer	2026-05-04 11:14:31.468606+00	2026-05-04 11:14:31.468606+00
76624072-9b33-4a6d-b4a6-3dfa8b90d2e3	dangote_reviewer_27@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_27	reviewer	2026-05-04 11:14:31.474592+00	2026-05-04 11:14:31.474592+00
38c4aba5-0612-4f86-aa76-a47db8320cff	dangote_reviewer_28@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_28	reviewer	2026-05-04 11:14:31.48088+00	2026-05-04 11:14:31.48088+00
3e38a0b3-aefb-4bf7-8a5a-24e03f590de3	dangote_reviewer_29@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_29	reviewer	2026-05-04 11:14:31.486602+00	2026-05-04 11:14:31.486602+00
8e19c3fb-7be8-4aa5-b5bd-af171861b57c	dangote_reviewer_30@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_30	reviewer	2026-05-04 11:14:31.492962+00	2026-05-04 11:14:31.492962+00
28d15e56-e782-4bad-9ce9-9c479390cac4	dangote_reviewer_31@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_31	reviewer	2026-05-04 11:14:31.49843+00	2026-05-04 11:14:31.49843+00
bd9cf8c9-aa13-4139-ae09-789c33a46b33	dangote_reviewer_32@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_32	reviewer	2026-05-04 11:14:31.504812+00	2026-05-04 11:14:31.504812+00
ab043822-4518-4915-b133-b9320ab0fd16	dangote_reviewer_33@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_33	reviewer	2026-05-04 11:14:31.510838+00	2026-05-04 11:14:31.510838+00
104ac577-7486-41a2-8d57-1ff9792e7c1b	dangote_reviewer_34@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_34	reviewer	2026-05-04 11:14:31.516268+00	2026-05-04 11:14:31.516268+00
f6c1113f-8c5d-4ebd-b8e6-1a306d832280	dangote_reviewer_35@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_35	reviewer	2026-05-04 11:14:31.522625+00	2026-05-04 11:14:31.522625+00
4fcc9fd0-7bd9-47a3-9b09-096b1ee6172e	dangote_reviewer_36@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_36	reviewer	2026-05-04 11:14:31.529104+00	2026-05-04 11:14:31.529104+00
240e8cfc-eed0-44a4-89bc-d9145a6ebeed	dangote_reviewer_37@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_37	reviewer	2026-05-04 11:14:31.534586+00	2026-05-04 11:14:31.534586+00
5fdd91fd-1a88-4a80-aa84-1766dbf34344	dangote_reviewer_38@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_38	reviewer	2026-05-04 11:14:31.54036+00	2026-05-04 11:14:31.54036+00
7eebcbb6-338d-4d54-b25e-dba123a39d2a	dangote_reviewer_39@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_39	reviewer	2026-05-04 11:14:31.546272+00	2026-05-04 11:14:31.546272+00
e46b6720-49db-4e3d-b6cd-d849cb0c9eeb	dangote_reviewer_40@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_40	reviewer	2026-05-04 11:14:31.552586+00	2026-05-04 11:14:31.552586+00
edaa49fd-dd8c-4d7f-8ab3-2a8a01863e7f	dangote_reviewer_41@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_41	reviewer	2026-05-04 11:14:31.559002+00	2026-05-04 11:14:31.559002+00
766b3c30-4653-40b5-a7cc-35e2d5cb6a4e	dangote_reviewer_42@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_42	reviewer	2026-05-04 11:14:31.564737+00	2026-05-04 11:14:31.564737+00
4987c977-6c68-4103-9863-6e0adfc4f276	dangote_reviewer_43@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_43	reviewer	2026-05-04 11:14:31.570447+00	2026-05-04 11:14:31.570447+00
ad185731-3f7e-4950-a9af-01962006c9e0	dangote_reviewer_44@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_44	reviewer	2026-05-04 11:14:31.576853+00	2026-05-04 11:14:31.576853+00
e1d417cb-810f-49ae-8ea7-2eeac36ec593	dangote_reviewer_45@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_45	reviewer	2026-05-04 11:14:31.582113+00	2026-05-04 11:14:31.582113+00
f3ca9228-81d7-4fd1-9f0f-abf29cbe5cfb	dangote_reviewer_46@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_46	reviewer	2026-05-04 11:14:31.587801+00	2026-05-04 11:14:31.587801+00
71b28923-6de8-47ee-88b4-f235a2a6373f	dangote_reviewer_47@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_47	reviewer	2026-05-04 11:14:31.594008+00	2026-05-04 11:14:31.594008+00
03bf8260-a5d7-4fa0-9af2-e59e891d3dab	dangote_reviewer_48@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_48	reviewer	2026-05-04 11:14:31.600871+00	2026-05-04 11:14:31.600871+00
11c233d8-13db-4b03-a065-b452f15b371a	dangote_reviewer_49@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_49	reviewer	2026-05-04 11:14:31.60728+00	2026-05-04 11:14:31.60728+00
64d8b8ef-cc91-4410-b2a9-d455a7c6a9f8	dangote_reviewer_50@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_50	reviewer	2026-05-04 11:14:31.6132+00	2026-05-04 11:14:31.6132+00
17a2da93-6d4d-46a1-bb3d-ec5aa7850445	dangote_reviewer_51@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_51	reviewer	2026-05-04 11:14:31.619156+00	2026-05-04 11:14:31.619156+00
1d3b38c3-dcfe-419c-ab19-744d2fe7733e	dangote_reviewer_52@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_52	reviewer	2026-05-04 11:14:31.625402+00	2026-05-04 11:14:31.625402+00
03cfc327-5d88-43c7-8612-31e7a5a8a833	dangote_reviewer_53@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_53	reviewer	2026-05-04 11:14:31.631114+00	2026-05-04 11:14:31.631114+00
72d87e8e-f5c1-48e6-b047-c94fab9c7393	dangote_reviewer_54@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_54	reviewer	2026-05-04 11:14:31.637432+00	2026-05-04 11:14:31.637432+00
0d08839e-ebe9-4f14-b879-8c56c0044f33	dangote_reviewer_55@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_55	reviewer	2026-05-04 11:14:31.643496+00	2026-05-04 11:14:31.643496+00
7b982e66-76e6-438f-939a-77344b934380	dangote_reviewer_56@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_56	reviewer	2026-05-04 11:14:31.648945+00	2026-05-04 11:14:31.648945+00
e7da5f29-e44a-4585-81fd-2244675f45fd	dangote_reviewer_57@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_57	reviewer	2026-05-04 11:14:31.65471+00	2026-05-04 11:14:31.65471+00
39add4d6-53a8-4896-984f-f247a9d5a2b7	dangote_reviewer_58@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_58	reviewer	2026-05-04 11:14:31.661009+00	2026-05-04 11:14:31.661009+00
f8bcd338-39b0-4186-830f-228e55604064	dangote_reviewer_59@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_59	reviewer	2026-05-04 11:14:31.667935+00	2026-05-04 11:14:31.667935+00
b9c3be6b-8da0-4414-bf50-69410fa774bb	dangote_reviewer_60@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_60	reviewer	2026-05-04 11:14:31.674825+00	2026-05-04 11:14:31.674825+00
7b9e7324-16e7-4b01-944d-4f6ff9384366	dangote_reviewer_61@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_61	reviewer	2026-05-04 11:14:31.680745+00	2026-05-04 11:14:31.680745+00
8c7c19e3-3bd3-4b95-be5c-9f793d8db656	dangote_reviewer_62@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_62	reviewer	2026-05-04 11:14:31.686295+00	2026-05-04 11:14:31.686295+00
9550b05b-35a6-40e9-af4d-c83a83a2a96d	dangote_reviewer_63@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_63	reviewer	2026-05-04 11:14:31.692207+00	2026-05-04 11:14:31.692207+00
d93b2055-e8b3-4438-bb78-b7f288ae6e2c	dangote_reviewer_64@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_64	reviewer	2026-05-04 11:14:31.696979+00	2026-05-04 11:14:31.696979+00
9f7fa566-ec18-426f-b374-86b4596716ac	dangote_reviewer_65@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_65	reviewer	2026-05-04 11:14:31.702829+00	2026-05-04 11:14:31.702829+00
82288ed8-2dc8-4168-a5e2-c7f2046d6ac2	dangote_reviewer_66@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_66	reviewer	2026-05-04 11:14:31.709292+00	2026-05-04 11:14:31.709292+00
6890c0e7-eab0-4edd-8922-1186632c105b	dangote_reviewer_67@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_67	reviewer	2026-05-04 11:14:31.715399+00	2026-05-04 11:14:31.715399+00
a0d8b8d9-fb84-4b41-9928-aa4abfa255b4	dangote_reviewer_68@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_68	reviewer	2026-05-04 11:14:31.72185+00	2026-05-04 11:14:31.72185+00
4dfa4e2b-263f-4271-93c0-3e3af55a2f15	dangote_reviewer_69@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_69	reviewer	2026-05-04 11:14:31.728418+00	2026-05-04 11:14:31.728418+00
773a0438-e576-4ad7-b14f-5aefd011304c	dangote_reviewer_70@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_70	reviewer	2026-05-04 11:14:31.734229+00	2026-05-04 11:14:31.734229+00
3a5b9d93-ed69-4d00-8ab2-8122511c2ec2	dangote_reviewer_71@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_71	reviewer	2026-05-04 11:14:31.739853+00	2026-05-04 11:14:31.739853+00
3d6078c0-3a00-4652-8a0f-0aea34ef2e16	dangote_reviewer_72@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_72	reviewer	2026-05-04 11:14:31.7447+00	2026-05-04 11:14:31.7447+00
641e883e-1fcc-44d7-b61f-45bf45daae83	dangote_reviewer_73@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_73	reviewer	2026-05-04 11:14:31.749734+00	2026-05-04 11:14:31.749734+00
2d6bf6ed-8785-41e6-a41a-0f80907edeb0	dangote_reviewer_74@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_74	reviewer	2026-05-04 11:14:31.755956+00	2026-05-04 11:14:31.755956+00
221c08f9-07f2-4b22-a19a-86db67c5c7ba	dangote_reviewer_75@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_75	reviewer	2026-05-04 11:14:31.761764+00	2026-05-04 11:14:31.761764+00
5ac1cdcd-c7bf-42b3-bc27-96aa3b745080	dangote_reviewer_76@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_76	reviewer	2026-05-04 11:14:31.767614+00	2026-05-04 11:14:31.767614+00
9221e178-bf98-4523-9701-37a463c71ff5	dangote_reviewer_77@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_77	reviewer	2026-05-04 11:14:31.774489+00	2026-05-04 11:14:31.774489+00
0e1f7cfa-634c-41bf-b3e4-084c0e26bca1	dangote_reviewer_78@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_78	reviewer	2026-05-04 11:14:31.781207+00	2026-05-04 11:14:31.781207+00
fc553e0f-1b13-4104-93b7-db4d61313ca1	dangote_reviewer_79@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_79	reviewer	2026-05-04 11:14:31.786355+00	2026-05-04 11:14:31.786355+00
b015caff-4ca4-4999-9acf-b99c11df8215	dangote_reviewer_80@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_80	reviewer	2026-05-04 11:14:31.79135+00	2026-05-04 11:14:31.79135+00
9014881d-e2e6-49b3-b386-4883f4e380ba	dangote_reviewer_81@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_81	reviewer	2026-05-04 11:14:31.797323+00	2026-05-04 11:14:31.797323+00
8a22e5e3-618d-4e9d-a8e6-83aa38ecae41	dangote_reviewer_82@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_82	reviewer	2026-05-04 11:14:31.803449+00	2026-05-04 11:14:31.803449+00
5b90a702-4abe-4847-8549-70228af35bc5	dangote_reviewer_83@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_83	reviewer	2026-05-04 11:14:31.809598+00	2026-05-04 11:14:31.809598+00
15753795-0698-4fd8-898d-cd03f4ee0a9e	dangote_reviewer_84@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_84	reviewer	2026-05-04 11:14:31.815221+00	2026-05-04 11:14:31.815221+00
9c4ae611-b83a-4f21-bbc9-c2f5115feed2	dangote_reviewer_85@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_85	reviewer	2026-05-04 11:14:31.822211+00	2026-05-04 11:14:31.822211+00
575a77de-f3b5-4fcf-a3b7-bb3c71766358	dangote_reviewer_86@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_86	reviewer	2026-05-04 11:14:31.827455+00	2026-05-04 11:14:31.827455+00
f90ee443-8fcf-4dbb-aeaa-273e90484c41	dangote_reviewer_87@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_87	reviewer	2026-05-04 11:14:31.833157+00	2026-05-04 11:14:31.833157+00
c3bd05bf-c22f-422b-91bc-b4ee405913fd	dangote_reviewer_88@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_88	reviewer	2026-05-04 11:14:31.839089+00	2026-05-04 11:14:31.839089+00
430fef7b-211e-4617-a19d-7feafd030d6c	dangote_reviewer_89@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_89	reviewer	2026-05-04 11:14:31.844823+00	2026-05-04 11:14:31.844823+00
f4456d9b-7c4e-4a9c-9f23-b6139bf60906	dangote_reviewer_90@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_90	reviewer	2026-05-04 11:14:31.850399+00	2026-05-04 11:14:31.850399+00
9064b7c5-d14e-43d5-ac45-21518e4a1502	dangote_reviewer_91@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_91	reviewer	2026-05-04 11:14:31.856894+00	2026-05-04 11:14:31.856894+00
e7f044e8-487b-4995-83b7-0900b6aab267	dangote_reviewer_92@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_92	reviewer	2026-05-04 11:14:31.862911+00	2026-05-04 11:14:31.862911+00
0a708c77-9b65-4843-aac8-a4da7a150572	dangote_reviewer_93@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_93	reviewer	2026-05-04 11:14:31.868832+00	2026-05-04 11:14:31.868832+00
259b82b4-1ffb-477f-add3-15b08f061e2d	dangote_reviewer_94@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_94	reviewer	2026-05-04 11:14:31.87363+00	2026-05-04 11:14:31.87363+00
c0e4a2c4-cd8a-4dcd-9f99-89d0019a24fb	dangote_reviewer_95@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_95	reviewer	2026-05-04 11:14:31.878853+00	2026-05-04 11:14:31.878853+00
7f8d51b9-6769-40a2-8690-48eabb1fc122	dangote_reviewer_96@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_96	reviewer	2026-05-04 11:14:31.884231+00	2026-05-04 11:14:31.884231+00
5401247a-d1c6-4747-aef1-6fac25c8a188	dangote_reviewer_97@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_97	reviewer	2026-05-04 11:14:31.889826+00	2026-05-04 11:14:31.889826+00
4fee828d-a7c5-4a87-bd4d-ed04decf7bdb	dangote_reviewer_98@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_98	reviewer	2026-05-04 11:14:31.895315+00	2026-05-04 11:14:31.895315+00
b0c8b78d-e858-4e7c-9a07-14d288480618	dangote_reviewer_99@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_99	reviewer	2026-05-04 11:14:31.90109+00	2026-05-04 11:14:31.90109+00
a350339b-d835-42f1-8e65-fcc50920a097	dangote_reviewer_100@test.demo	$2b$10$8i2Gdg.P68w0KB1tu4/GKuL9dkTrcSx0tb/Zzd55VJemeHc0hGtGi	reviewer_ng_100	reviewer	2026-05-04 11:14:31.908231+00	2026-05-04 11:14:31.908231+00
\.


--
-- Name: ad_packages ad_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ad_packages
    ADD CONSTRAINT ad_packages_pkey PRIMARY KEY (id);


--
-- Name: ad_rewards ad_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ad_rewards
    ADD CONSTRAINT ad_rewards_pkey PRIMARY KEY (id);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: events_log events_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_log
    ADD CONSTRAINT events_log_pkey PRIMARY KEY (id);


--
-- Name: leaderboard_snapshots leaderboard_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaderboard_snapshots
    ADD CONSTRAINT leaderboard_snapshots_pkey PRIMARY KEY (id);


--
-- Name: platform_settings platform_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_settings
    ADD CONSTRAINT platform_settings_pkey PRIMARY KEY (key);


--
-- Name: points_ledger points_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points_ledger
    ADD CONSTRAINT points_ledger_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: redemptions redemptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT redemptions_pkey PRIMARY KEY (id);


--
-- Name: review_sessions review_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_sessions
    ADD CONSTRAINT review_sessions_pkey PRIMARY KEY (id);


--
-- Name: reviewer_profiles reviewer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviewer_profiles
    ADD CONSTRAINT reviewer_profiles_pkey PRIMARY KEY (id);


--
-- Name: reviewer_profiles reviewer_profiles_user_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviewer_profiles
    ADD CONSTRAINT reviewer_profiles_user_id_unique UNIQUE (user_id);


--
-- Name: reward_claims reward_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_claims
    ADD CONSTRAINT reward_claims_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: ad_rewards ad_rewards_ad_id_ads_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ad_rewards
    ADD CONSTRAINT ad_rewards_ad_id_ads_id_fk FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: ads ads_brand_id_brands_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_brand_id_brands_id_fk FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: answers answers_question_id_questions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_question_id_questions_id_fk FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: answers answers_review_session_id_review_sessions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_review_session_id_review_sessions_id_fk FOREIGN KEY (review_session_id) REFERENCES public.review_sessions(id);


--
-- Name: brands brands_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: leaderboard_snapshots leaderboard_snapshots_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaderboard_snapshots
    ADD CONSTRAINT leaderboard_snapshots_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: points_ledger points_ledger_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points_ledger
    ADD CONSTRAINT points_ledger_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: questions questions_ad_id_ads_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_ad_id_ads_id_fk FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: redemptions redemptions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT redemptions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: review_sessions review_sessions_ad_id_ads_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_sessions
    ADD CONSTRAINT review_sessions_ad_id_ads_id_fk FOREIGN KEY (ad_id) REFERENCES public.ads(id);


--
-- Name: review_sessions review_sessions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_sessions
    ADD CONSTRAINT review_sessions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: reviewer_profiles reviewer_profiles_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviewer_profiles
    ADD CONSTRAINT reviewer_profiles_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reward_claims reward_claims_reward_id_ad_rewards_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_claims
    ADD CONSTRAINT reward_claims_reward_id_ad_rewards_id_fk FOREIGN KEY (reward_id) REFERENCES public.ad_rewards(id) ON DELETE CASCADE;


--
-- Name: reward_claims reward_claims_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_claims
    ADD CONSTRAINT reward_claims_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict AefKdAqjzPHegFSOTHVJpZtz4KCXfjdh8SQXcicV1dy8K58ged7gbNQ2eLuGwcd

