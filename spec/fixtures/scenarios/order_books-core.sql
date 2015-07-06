--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.signersaccount;
DROP INDEX public.priceindex;
DROP INDEX public.paysissuerindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.getsissuerindex;
DROP INDEX public.accountlines;
DROP INDEX public.accountbalances;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_ledgerseq_txindex_key;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(51) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(51),
    homedomain character varying(32),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= 0)),
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    bucketlisthash character(64) NOT NULL,
    ledgerseq integer,
    closetime bigint NOT NULL,
    data text NOT NULL,
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    accountid character varying(51) NOT NULL,
    offerid bigint NOT NULL,
    paysalphanumcurrency character varying(4),
    paysissuer character varying(51),
    getsalphanumcurrency character varying(4),
    getsissuer character varying(51),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price bigint NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT offers_amount_check CHECK ((amount >= 0)),
    CONSTRAINT offers_offerid_check CHECK ((offerid >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character varying(15) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535))),
    CONSTRAINT peers_rank_check CHECK ((rank >= 0))
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(51) NOT NULL,
    publickey character varying(51) NOT NULL,
    weight integer NOT NULL
);


--
-- Name: storestate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storestate (
    statename character(32) NOT NULL,
    state text
);


--
-- Name: trustlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trustlines (
    accountid character varying(51) NOT NULL,
    issuer character varying(51) NOT NULL,
    alphanumcurrency character varying(4) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags) FROM stdin;
gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	99999969999999970	3	0	\N		01000000	0
gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	9999999960	12884901892	0	\N		01000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	9999999920	12884901896	8	\N		01000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	9999999920	12884901896	8	\N		01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	0000000000000000000000000000000000000000000000000000000000000000	e71064e28d0740ac27cf07b267200ea9b8916ad1242195c015fa3012086588d3	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5xBk4o0HQKwnzweyZyAOqbiRatEkIZXAFfowEghliNMAAAABAAAAAAAAAAABY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
7f00148e898589c653c77aee81d06b9697d28be748ea06b8a0022ccd29647d83	a9d12414d405652b752ce4425d3d94e7996a07a52228a58d7bf3bd35dd50eb46	24128cf784e4c94f58a5a72a5036a54e82b2e37c1b1b327bd8af8ab48684abf6	2	1435792813	qdEkFNQFZSt1LORCXT2U55lqB6UiKKWNe/O9Nd1Q60bWGQFaFjFEkPZuQGDTJ8o1Qnt8FuQMpJZu40ekvFPjPOOwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVJBKM94TkyU9YpacqUDalToKy43wbGzJ72K+KtIaEq/YAAAACAAAAAFWUda0BY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
3d4af496687964ffe3d9d98d50e6b790fd1188ccc6466f2fd6f0c42863f25485	7f00148e898589c653c77aee81d06b9697d28be748ea06b8a0022ccd29647d83	59d90d92bc0c72e81d883fb80c027f37b182ac61704513789bb73916335a0409	3	1435792814	fwAUjomFicZTx3rugdBrlpfSi+dI6ga4oAIszSlkfYOeUjrlG44zfkA8SrGQP7+f9fZfboxHROaDWpypkwA1OG+UXGi9FfKG00tyiRQJNT79wKDwUaevHhHOJ5ohTAeHWdkNkrwMcugdiD+4DAJ/N7GCrGFwRRN4m7c5FjNaBAkAAAADAAAAAFWUda4BY0V4XYoAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
66f89bced279528e87f3c9eba012e4addaf92cff3875c3f0156919b27cf33983	3d4af496687964ffe3d9d98d50e6b790fd1188ccc6466f2fd6f0c42863f25485	70f1714eed1849dc5deb200b1d60a55c3cfd5c0e5c325137be7c026076353d1c	4	1435792815	PUr0lmh5ZP/j2dmNUOa3kP0RiMzGRm8v1vDEKGPyVIXHWoY7DWemBe2Q39LhadwzdFC9PscEqKYfM9JgpTSAHf4aVoOLCfB2AE/vLtXHq4wX1AZfUproBPo+5kQtcMl6cPFxTu0YSdxd6yALHWClXDz9XA5cMlE3vnwCYHY1PRwAAAAEAAAAAFWUda8BY0V4XYoAAAAAAAAAAABGAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
92833b51b582bd4f625c89f44f0d098ca40e671a55f4c0aac137e39c1a454fa0	66f89bced279528e87f3c9eba012e4addaf92cff3875c3f0156919b27cf33983	dc08040491707b6b13dcdf4c785791337d1557aac12d5365f6057b73b9bf4e1a	5	1435792816	ZvibztJ5Uo6H88nroBLkrdr5LP84dcPwFWkZsnzzOYNzt1I4tM7x3lVWa2nzX7MY9tte/N6QUAju1DIWdJPQ+Y9VaIz7VTbv+WN7gbvt87k0vLMrFCCiQINFwrtnGd/n3AgEBJFwe2sT3N9MeFeRM30VV6rBLVNl9gV7c7m/ThoAAAAFAAAAAFWUdbABY0V4XYoAAAAAAAAAAABuAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
398be9535f34707b36ab068c5d67e1f7f1d4992237383fec5126a31008a3a936	92833b51b582bd4f625c89f44f0d098ca40e671a55f4c0aac137e39c1a454fa0	735ac6bc014842f3f18d61378d1fb44824232007207bea5d18d1caae9e2cf45d	6	1435792817	koM7UbWCvU9iXIn0Tw0JjKQOZxpV9MCqwTfjnBpFT6Bt9MyhcjrBG9i9Y7RAhR2o4Rra4gJeATBFcCe5mCHwfTTc8mjvWrcK5jowGjWM6vW8lXIiXaIy7o4vIlJ+ovJnc1rGvAFIQvPxjWE3jR+0SCQjIAcge+pdGNHKrp4s9F0AAAAGAAAAAFWUdbEBY0V4XYoAAAAAAAAAAACqAAAAAAAAAAAAAAAGAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
38c4f2a990773dc285328604106362a50f800c78eeddfb06de2665e808bc1154	398be9535f34707b36ab068c5d67e1f7f1d4992237383fec5126a31008a3a936	f3b66325d259a592a966fcf67ff8765d66cce6e29ed9b887711a37c1322c0207	7	1435792818	OYvpU180cHs2qwaMXWfh9/HUmSI3OD/sUSajEAijqTab729cYqI6hYusJFbCFhYQQ+9K7J4H++a1e+OLhhcZEqBOTOM4o/053hNSZVqzl7tkF0GFTU65emsTzguklGyN87ZjJdJZpZKpZvz2f/h2XWbM5uKe2biHcRo3wTIsAgcAAAAHAAAAAFWUdbIBY0V4XYoAAAAAAAAAAADmAAAAAAAAAAAAAAAMAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, offerid, paysalphanumcurrency, paysissuer, getsalphanumcurrency, getsissuer, amount, pricen, priced, price, flags) FROM stdin;
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	1	\N	\N	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	10	15	1	150000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	2	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	\N	\N	1	1	10	1000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	3	\N	\N	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	100	20	1	200000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	4	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	\N	\N	11	1	9	1111111	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	5	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	\N	\N	200	1	5	2000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	6	\N	\N	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	1000	50	1	500000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	7	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	1	1	10	1000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	10	15	1	150000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	9	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	100	20	1	200000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	10	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	11	1	9	1111111	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	11	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	200	1	5	2000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	1000	50	1	500000000	0
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures, rank) FROM stdin;
\.


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY signers (accountid, publickey, weight) FROM stdin;
\.


--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY storestate (statename, state) FROM stdin;
databaseinitialized             	true
forcescponnextlaunch            	false
lastclosedledger                	38c4f2a990773dc285328604106362a50f800c78eeddfb06de2665e808bc1154
historyarchivestate             	{\n    "version": 0,\n    "currentLedger": 7,\n    "currentBuckets": [\n        {\n            "curr": "4804a3a4c4b96e1afa8605128af6d3ff72d23c51ed34fca0e5f6224d16c694e0",\n            "next": {\n                "state": 0\n            },\n            "snap": "e2bbff8e380803d52b6ae04f7b89c6e546fce2a30b8a4fa1e0ba3d54c5311915"\n        },\n        {\n            "curr": "e46a62f2f2cb46a177fa4ef4ca9c6c956795c0b82a993710fa2611f42107d84f",\n            "next": {\n                "state": 1,\n                "output": "e2bbff8e380803d52b6ae04f7b89c6e546fce2a30b8a4fa1e0ba3d54c5311915"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, issuer, alphanumcurrency, tlimit, balance, flags) FROM stdin;
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	9223372036854775807	5000	1
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	9223372036854775807	5000	1
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	9223372036854775807	5000	1
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	9223372036854775807	5000	1
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
e2b3ecd737eb4c241e7abe15a6d079dbe1de708263f59d1882c05eb7d0e89c08	3	1	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL5AAAAAABiZsoQHDoAd/mr0zgQ1i9SghJpb+MSD4VgZObbZmdJT2eusSp5fG0KzRd1nr+da5tBzVpotbKp2nbzkdvrnG87OuT+wg=	4rPs1zfrTCQeer4VptB52+HecIJj9Z0YgsBet9DonAgAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvkAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXYJfhv2AAAAAAAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
9692abb6739c52f1b76a2bc1ecc515763e8c481f8c46ac0bb13386305040af99	3	2	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAIAAAAAAAAAAAAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL5AAAAAABiZsoQKT+Ezzq7qTSGD6MIs2AWZhwMabtkbGOnaYmEhRyhIIVxiP1/kti5dxEcqKEPRlLhh4ztkmYlYW/Grv5u6FW0Qs=	lpKrtnOcUvG3aivB7MUVdj6MSB+MRqwLsTOGMFBAr5kAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvkAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXO1cjfsAAAAAAAAAAIAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
7aa3ca5873e4f8bd88715475d8be02fe3d31c82becad84fe1b41541fd442ec21	3	3	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAMAAAAAAAAAAAAAAAEAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL5AAAAAABiZsoQPiR3EJQazqwgAQwJPttGbdDJf3MDXCEOV8IUw7bB3ogXaWa7aXkJtXbJk/LVMIBdCrh/Pz4aO3/z4VxCKvZ3QI=	eqPKWHPk+L2IcVR12L4C/j0xyCvsrYT+G0FUH9RC7CEAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvkAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXFhZlPiAAAAAAAAAAMAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
1b92d9a9651b11379a62c13a21958d516cf3dfe15f3628981243f0b4475c02fa	4	1	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAABgAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe9//////////wAAAAGuo3otji0YArjFdZasKGHmff21mlxXFyEI17PROI+D1FdScjMBcHSnXaWOGpvz7nLm9aEfxDneXvis8ZW/VflOl6RmAw==	G5LZqWUbETeaYsE6IZWNUWzz3+FfNiiYEkPwtEdcAvoAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAA	AAAAAgAAAAAAAAABrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAEAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL4/YAAAADAAAAAQAAAAEAAAAAAAAAAAEAAAAAAAAAAAAAAA==
f44b155ce8e6a7db7dd6294166bb710a481f102514b3c73fcada10ff20dca37c	4	2	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAABgAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe9//////////wAAAAFuaCbV3G/DmD4nYxuPjfa8AKx2WySH9SZKQcdeOWNnBXGSds/QBAAqA1kZBKCTw6XWD1P6uw3xdvaUq7C5BqegYXSeDQ==	9EsVXOjmp9t91ilBZrtxCkgfECUUs8c/ytoQ/yDco3wAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAA	AAAAAgAAAAAAAAABbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAEAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL4/YAAAADAAAAAQAAAAEAAAAAAAAAAAEAAAAAAAAAAAAAAA==
6926fd316741a0dcc449863a3f57e7e311311099be8d98d667c6c2c30da8ed13	4	3	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAIAAAAAAAAAAAAAAAEAAAAAAAAABgAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe9//////////wAAAAGuo3otIGoQw3YfCSiWIRLAV/pMI9OdUh2RTVZechCZ0vdZn2ZvzDIsGVsGarcWlYmKwIWQMqeS+mUOP6shbgIVYVDKAw==	aSb9MWdBoNzESYY6P1fn4xExEJm+jZjWZ8bCww2o7RMAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAA	AAAAAgAAAAAAAAABrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAEAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL4+wAAAADAAAAAgAAAAIAAAAAAAAAAAEAAAAAAAAAAAAAAA==
2539e9b5d905c70fb01874c98fd3b4026118c6b0d487f2c33258c3dc8f805aab	4	4	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAIAAAAAAAAAAAAAAAEAAAAAAAAABgAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe9//////////wAAAAFuaCbVSU1GDGdICuwi/OgI/mp/1hJDJ5y61h/evftV3Q06mL7ebfgvgHIFZHXBGDiyQnzDTsaECSkUdAu+tKxsWE2+DA==	JTnptdkFxw+wGHTJj9O0AmEYxrDUh/LDMljD3I+AWqsAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAA	AAAAAgAAAAAAAAABbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAEAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL4+wAAAADAAAAAgAAAAIAAAAAAAAAAAEAAAAAAAAAAAAAAA==
2a837e4ec972a058de2c94598f9e44478f1efdbc30f6e8302324e7b5485172d6	5	1	tbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAa6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAbW4F0d2sPSjyrCkZS37RF/W6OCqcFpwR1TNHo4Z8MfnC4V6FxR+HXM7qY35fr45GJ1moeTApOUFow2rdizn+gTH5mcD	KoN+TslyoFjeLJRZj55ER48e/bww9ugwIyTntUhRctYAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAA	AAAAAgAAAAEAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvj9gAAAAMAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAGuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAATiH//////////AAAAAQ==
4e4af6fa9c4b4d908da5a9a3457d744baeef2aa858afec364d25510ac4698560	5	2	tbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAKAAAAAwAAAAIAAAAAAAAAAAAAAAEAAAAAAAAAAW5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAbW4F0fn/iOcqeKnbCvzctkGYXR4nQ58h54MErAJXHcCPId3wOrIp8RqD0wYa0PsxWrRQUN/pbcPJXGWaB4AJ6Zrk7QC	Tkr2+pxLTZCNpamjRX10S67vKqhYr+w2TSVRCsRphWAAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAA	AAAAAgAAAAEAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvj7AAAAAMAAAACAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAFuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAATiH//////////AAAAAQ==
d292bdbc5d65e7b81c9fb81ac4201e6f64b117c048b93024c0a5822ff5ac7d45	5	3	tbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAKAAAAAwAAAAMAAAAAAAAAAAAAAAEAAAAAAAAAAa6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAUJUQwC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAbW4F0dg+pTz84su6UoVWITs+3jw1Rjp9BLZkUephz+cZKaXg5OyRnyopmdgWCUpCPPbJIkGdPu7nX2BtGGSvbXlBmwA	0pK9vF1l57gcn7gaxCAeb2SxF8BIuTAkwKWCL/WsfUUAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAA	AAAAAgAAAAEAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvj4gAAAAMAAAADAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAGuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAATiH//////////AAAAAQ==
7193ad8f9fc201eee35cad60fa456ad6373e46e06487814f74d064b95bb0e16b	5	4	tbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAKAAAAAwAAAAQAAAAAAAAAAAAAAAEAAAAAAAAAAW5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAUJUQwC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAbW4F0ctr0FVWaS6Q2Xl1GNcGR0a4lygn0ecF06oZOS088y7l8FWeARtbXd2aUHfqQ7uSCCvAvgXFxMbXs4OaoQ0FbcC	cZOtj5/CAe7jXK1g+kVq1jc+RuBkh4FPdNBkuVuw4WsAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAA	AAAAAgAAAAEAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvj2AAAAAMAAAAEAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAFuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAATiH//////////AAAAAQ==
f0957ad75f54e72aecf74032bb37ce2307032b6772fa8d4b28161eb975c1a623	6	1	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAMAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAAoAAAAPAAAAAQAAAAAAAAAAAAAAAW5oJtXUWjNYSMzKHB5AZiskwm+cQ1zddTkFknh/3lI8LHtZJvv1zMZJzz8JCjAq5f3XmukTwCAsOxo1PwB+Ra9U5WYG	8JV6119U5yrs90AyuzfOIwcDK2dy+o1LKBYeuXXBpiMAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAABAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAACgAAAA8AAAABAAAAAA==	AAAAAgAAAAAAAAACbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAAAQAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAAoAAAAPAAAAAQAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL4+IAAAADAAAAAwAAAAMAAAAAAAAAAAEAAAAAAAAAAAAAAA==
24d3f1cea2ea00634fafc5a5247f17e003947e9ec5763235e3e8950ebfca169c	6	2	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAMAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAAAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAEAAAABAAAACgAAAAAAAAAAAAAAAa6jei1OjCq/fG6C3Xn+1LD+egmVGSMDSnArsjFa3QxopAseKEE+ALPxUeWQwSKBdT1CWLbOGeo1355U+PyMCRU1clsA	JNPxzqLqAGNPr8WlJH8X4AOUfp7FdjI14+iVDr/KFpwAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAAAAAACAAAAAAAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAQAAAAEAAAAKAAAAAA==	AAAAAgAAAAAAAAACrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAAAgAAAAAAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAEAAAABAAAACgAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL4+IAAAADAAAAAwAAAAMAAAAAAAAAAAEAAAAAAAAAAAAAAA==
53366442616e19a8fdcbbefe5fc7e4f35bc333d5c82cffad3b5a335aee105bc2	6	3	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAQAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAGQAAAAUAAAAAQAAAAAAAAAAAAAAAW5oJtWpltFhEVNrTegn5QY6YVky5cQ06R9SfIjwV50U+hhrYvo+rsNd2LaHNJx4KzEjJUCTzw9SFYwd2NlpYMIg6JAH	UzZkQmFuGaj9y77+X8fk81vDM9XILP+tO1ozWu4QW8IAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAADAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAAZAAAABQAAAABAAAAAA==	AAAAAgAAAAAAAAACbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAAAwAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAGQAAAAUAAAAAQAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL49gAAAADAAAABAAAAAQAAAAAAAAAAAEAAAAAAAAAAAAAAA==
aab7ebae362461dfc6b5452fa507751ee05509d3015821b44e311f865c709f80	6	4	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAQAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAAAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAsAAAABAAAACQAAAAAAAAAAAAAAAa6jei0U2qqvhbpmeJZAccfGu+netvGN7zP6N8rGgF4HI7hKlA00ayY0+h65vx3Fh0/hr515aJKMRpBW+/NDKEuM5+cP	qrfrrjYkYd/GtUUvpQd1HuBVCdMBWCG0TjEfhlxwn4AAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAAAAAAEAAAAAAAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAACwAAAAEAAAAJAAAAAA==	AAAAAgAAAAAAAAACrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAABAAAAAAAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAsAAAABAAAACQAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL49gAAAADAAAABAAAAAQAAAAAAAAAAAEAAAAAAAAAAAAAAA==
f30d222e6f13c505946b3d499633dfc440af67d9eaea6a264e8fc01d2afdf5f0	6	5	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAUAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAAAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAMgAAAABAAAABQAAAAAAAAAAAAAAAa6jei3Qe6DvgO/5RWMYxNx3wASxbiFjd0w/W7zSemzejP49yzVglCYjYalftV8Q7KLP5Ya3DWIe10AV/h5nuCFjmCoO	8w0iLm8TxQWUaz1JljPfxECvZ9nq6momTo/AHSr99fAAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAAAAAAFAAAAAAAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAyAAAAAEAAAAFAAAAAA==	AAAAAgAAAAAAAAACrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAABQAAAAAAAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAMgAAAABAAAABQAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL484AAAADAAAABQAAAAUAAAAAAAAAAAEAAAAAAAAAAAAAAA==
88d133fe0c3b703ca6f62afa9434b840de8a3d8b0089e4732825dac556c96573	6	6	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAUAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAA+gAAAAyAAAAAQAAAAAAAAAAAAAAAW5oJtVMzBHN3V63VY30bTfKMxiGS8A261P9eS3huUGYENnkL3T4SK9djOnIcKMbGbYAiWzvxyQKDRcnWIGd+dCNi6wF	iNEz/gw7cDym9ir6lDS4QN6KPYsAieRzKCXaxVbJZXMAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAAGAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAD6AAAADIAAAABAAAAAA==	AAAAAgAAAAAAAAACbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAABgAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAA+gAAAAyAAAAAQAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL484AAAADAAAABQAAAAUAAAAAAAAAAAEAAAAAAAAAAAAAAA==
f99ecd57eadce52b981792264554ec6528c73b7bda3e828d65f26769476253e0	7	1	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAYAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAEAAAABAAAACgAAAAAAAAAAAAAAAa6jei2EKdSV0fNBmiFylh3ozT9gdY3cSdKezONPfZMhf1cASiadM2munmAXQrjnlsgqckwOUh9HBQ6uAIPFCRX7J9MM	+Z7NV+rc5SuYF5ImRVTsZSjHO3vaPoKNZfJnaUdiU+AAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAAAAAAHAAAAAUJUQwC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAQAAAAEAAAAKAAAAAA==	AAAAAgAAAAAAAAACrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAABwAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAEAAAABAAAACgAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL48QAAAADAAAABgAAAAYAAAAAAAAAAAEAAAAAAAAAAAAAAA==
82a463c3129e41293499fae5db1cc90f1f0710bf12bd33cb3a82d843c11aa311	7	2	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAYAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAoAAAAPAAAAAQAAAAAAAAAAAAAAAW5oJtUMVO1czy9Q7YatAa/5V+O/TFa7B7c+vRETZem6oQt7hiS6cD9hMqAkx/2C2mfnkqAz77kvDzfXB6qU3l//fsQP	gqRjwxKeQSk0mfrl2xzJDx8HEL8SvTPLOoLYQ8EaoxEAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAAIAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAACgAAAA8AAAABAAAAAA==	AAAAAgAAAAAAAAACbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAACAAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAoAAAAPAAAAAQAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL48QAAAADAAAABgAAAAYAAAAAAAAAAAEAAAAAAAAAAAAAAA==
11b37de46c9846b3ac349b4cc64b06a0aee8c41205fb6e12be004759b4a07016	7	3	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAcAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAGQAAAAUAAAAAQAAAAAAAAAAAAAAAW5oJtVPunDfe5DNNE/z1f3Z837JM+6mxyN2zDS5NEm+uqdJ+3/OEYWCu08aTYHtd49GYs16Lr0dEBZzDJJ3DLxpadkN	EbN95GyYRrOsNJtMxksGoK7oxBIF+24SvgBHWbSgcBYAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAAJAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAZAAAABQAAAABAAAAAA==	AAAAAgAAAAAAAAACbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAACQAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAGQAAAAUAAAAAQAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL47oAAAADAAAABwAAAAcAAAAAAAAAAAEAAAAAAAAAAAAAAA==
774d6fd7f515481d5374d4a1120236382b7a87f8172294aa6834480af3606037	7	4	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAcAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAsAAAABAAAACQAAAAAAAAAAAAAAAa6jei0GCgHEMXkdDTFb6eVMa1XiKPd8ffbqzj7Iwxw6/kWOjNwHUzSqsMt7In9mIEDyvi0UOQ2rqe5c645jQ6uji6oF	d01v1/UVSB1TdNShEgI2OCt6h/gXIpSqaDRICvNgYDcAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAAAAAAKAAAAAUJUQwC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAACwAAAAEAAAAJAAAAAA==	AAAAAgAAAAAAAAACrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAACgAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAsAAAABAAAACQAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL47oAAAADAAAABwAAAAcAAAAAAAAAAAEAAAAAAAAAAAAAAA==
d655d70e665ac894085bf98db8d512e7963ec1b7dd611251a30813c46f2f3fa1	7	5	rqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAKAAAAAwAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAMgAAAABAAAABQAAAAAAAAAAAAAAAa6jei07Wq5eJZU4syF+AMJdE2zuPWc37aflnJ9K/NhVJvxmcupnFspYQP5BsACVBxT775rV+58ucWt/iwXcJfP2pnMA	1lXXDmZayJQIW/mNuNUS55Y+wbfdYRJRowgTxG8vP6EAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAAAAAALAAAAAUJUQwC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAyAAAAAEAAAAFAAAAAA==	AAAAAgAAAAAAAAACrqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAACwAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABVVNEALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAMgAAAABAAAABQAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL47AAAAADAAAACAAAAAgAAAAAAAAAAAEAAAAAAAAAAAAAAA==
38dfc4049bb6a5d4aa72264e556dd6140edc5264c1f6b02bf1ba3c452ee57620	7	6	bmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAKAAAAAwAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAA+gAAAAyAAAAAQAAAAAAAAAAAAAAAW5oJtXk7qcvTQDljZFOLg+qPyBbka8upP7cwqxtRZTGjW9a3sGcyNW2aahWlxGCR/jl2jST4maUSZe4PR67goOpwj8N	ON/EBJu2pdSqciZOVW3WFA7cUmTB9rAr8bo8RS7ldiAAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAAAAAAMAAAAAVVTRAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAD6AAAADIAAAABAAAAAA==	AAAAAgAAAAAAAAACbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAADAAAAAFVU0QAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAABQlRDALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAA+gAAAAyAAAAAQAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL47AAAAADAAAACAAAAAgAAAAAAAAAAAEAAAAAAAAAAAAAAA==
\.


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (accountid);


--
-- Name: ledgerheaders_ledgerseq_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_ledgerseq_key UNIQUE (ledgerseq);


--
-- Name: ledgerheaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (ledgerhash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offerid);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


--
-- Name: signers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signers
    ADD CONSTRAINT signers_pkey PRIMARY KEY (accountid, publickey);


--
-- Name: storestate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storestate
    ADD CONSTRAINT storestate_pkey PRIMARY KEY (statename);


--
-- Name: trustlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trustlines
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, alphanumcurrency);


--
-- Name: txhistory_ledgerseq_txindex_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_ledgerseq_txindex_key UNIQUE (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (txid, ledgerseq);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance);


--
-- Name: accountlines; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountlines ON trustlines USING btree (accountid);


--
-- Name: getsissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX getsissuerindex ON offers USING btree (getsissuer);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: paysissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX paysissuerindex ON offers USING btree (paysissuer);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- PostgreSQL database dump complete
--

