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

DROP INDEX IF EXISTS public.signersaccount;
DROP INDEX IF EXISTS public.sellingissuerindex;
DROP INDEX IF EXISTS public.scpenvsbyseq;
DROP INDEX IF EXISTS public.priceindex;
DROP INDEX IF EXISTS public.ledgersbyseq;
DROP INDEX IF EXISTS public.histfeebyseq;
DROP INDEX IF EXISTS public.histbyseq;
DROP INDEX IF EXISTS public.buyingissuerindex;
DROP INDEX IF EXISTS public.accountbalances;
ALTER TABLE IF EXISTS ONLY public.txhistory DROP CONSTRAINT IF EXISTS txhistory_pkey;
ALTER TABLE IF EXISTS ONLY public.txfeehistory DROP CONSTRAINT IF EXISTS txfeehistory_pkey;
ALTER TABLE IF EXISTS ONLY public.trustlines DROP CONSTRAINT IF EXISTS trustlines_pkey;
ALTER TABLE IF EXISTS ONLY public.storestate DROP CONSTRAINT IF EXISTS storestate_pkey;
ALTER TABLE IF EXISTS ONLY public.signers DROP CONSTRAINT IF EXISTS signers_pkey;
ALTER TABLE IF EXISTS ONLY public.scpquorums DROP CONSTRAINT IF EXISTS scpquorums_pkey;
ALTER TABLE IF EXISTS ONLY public.pubsub DROP CONSTRAINT IF EXISTS pubsub_pkey;
ALTER TABLE IF EXISTS ONLY public.publishqueue DROP CONSTRAINT IF EXISTS publishqueue_pkey;
ALTER TABLE IF EXISTS ONLY public.peers DROP CONSTRAINT IF EXISTS peers_pkey;
ALTER TABLE IF EXISTS ONLY public.offers DROP CONSTRAINT IF EXISTS offers_pkey;
ALTER TABLE IF EXISTS ONLY public.ledgerheaders DROP CONSTRAINT IF EXISTS ledgerheaders_pkey;
ALTER TABLE IF EXISTS ONLY public.ledgerheaders DROP CONSTRAINT IF EXISTS ledgerheaders_ledgerseq_key;
ALTER TABLE IF EXISTS ONLY public.accounts DROP CONSTRAINT IF EXISTS accounts_pkey;
ALTER TABLE IF EXISTS ONLY public.accountdata DROP CONSTRAINT IF EXISTS accountdata_pkey;
DROP TABLE IF EXISTS public.txhistory;
DROP TABLE IF EXISTS public.txfeehistory;
DROP TABLE IF EXISTS public.trustlines;
DROP TABLE IF EXISTS public.storestate;
DROP TABLE IF EXISTS public.signers;
DROP TABLE IF EXISTS public.scpquorums;
DROP TABLE IF EXISTS public.scphistory;
DROP TABLE IF EXISTS public.pubsub;
DROP TABLE IF EXISTS public.publishqueue;
DROP TABLE IF EXISTS public.peers;
DROP TABLE IF EXISTS public.offers;
DROP TABLE IF EXISTS public.ledgerheaders;
DROP TABLE IF EXISTS public.accounts;
DROP TABLE IF EXISTS public.accountdata;
DROP EXTENSION IF EXISTS plpgsql;
DROP SCHEMA IF EXISTS public;
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
-- Name: accountdata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accountdata (
    accountid character varying(56) NOT NULL,
    dataname character varying(64) NOT NULL,
    datavalue character varying(112) NOT NULL
);


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(56) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(56),
    homedomain character varying(32) NOT NULL,
    thresholds text NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
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
    sellerid character varying(56) NOT NULL,
    offerid bigint NOT NULL,
    sellingassettype integer NOT NULL,
    sellingassetcode character varying(12),
    sellingissuer character varying(56),
    buyingassettype integer NOT NULL,
    buyingassetcode character varying(12),
    buyingissuer character varying(56),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price double precision NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
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
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535)))
);


--
-- Name: publishqueue; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publishqueue (
    ledger integer NOT NULL,
    state text
);


--
-- Name: pubsub; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pubsub (
    resid character(32) NOT NULL,
    lastread integer
);


--
-- Name: scphistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scphistory (
    nodeid character(56) NOT NULL,
    ledgerseq integer NOT NULL,
    envelope text NOT NULL,
    CONSTRAINT scphistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: scpquorums; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scpquorums (
    qsethash character(64) NOT NULL,
    lastledgerseq integer NOT NULL,
    qset text NOT NULL,
    CONSTRAINT scpquorums_lastledgerseq_check CHECK ((lastledgerseq >= 0))
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(56) NOT NULL,
    publickey character varying(56) NOT NULL,
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
    accountid character varying(56) NOT NULL,
    assettype integer NOT NULL,
    issuer character varying(56) NOT NULL,
    assetcode character varying(12) NOT NULL,
    tlimit bigint NOT NULL,
    balance bigint NOT NULL,
    flags integer NOT NULL,
    lastmodified integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit > 0))
);


--
-- Name: txfeehistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txfeehistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txchanges text NOT NULL,
    CONSTRAINT txfeehistory_ledgerseq_check CHECK ((ledgerseq >= 0))
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
-- Data for Name: accountdata; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO accounts VALUES ('GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H', 999999969999999700, 3, 0, NULL, '', 'AQAAAA==', 0, 2);
INSERT INTO accounts VALUES ('GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU', 9999999900, 8589934593, 1, NULL, '', 'AQAAAA==', 0, 4);
INSERT INTO accounts VALUES ('GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON', 9999999900, 8589934593, 1, NULL, '', 'AQAAAA==', 0, 5);
INSERT INTO accounts VALUES ('GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4', 9999999500, 8589934597, 0, NULL, '', 'AQAAAA==', 3, 8);


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO ledgerheaders VALUES ('63d98f536ee68d1b27b5b89f23af5311b7569a24faf1403ad0b52b633b07be99', '0000000000000000000000000000000000000000000000000000000000000000', '572a2e32ff248a07b0e70fd1f6d318c1facd20b6cc08c33d5775259868125a16', 1, 0, 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABXKi4y/ySKB7DnD9H20xjB+s0gtswIwz1XdSWYaBJaFgAAAAEN4Lazp2QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZAX14QAAAABkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('3e4369447e1f510b0c9cc3c97713a213d6cf379880ecd80ecf0a715ee6220930', '63d98f536ee68d1b27b5b89f23af5311b7569a24faf1403ad0b52b633b07be99', '01b733cfde9f97fb8d590e1baf6ea77d8013e13006b4e13f8519346d93dc87b4', 2, 1458662889, 'AAAAAmPZj1Nu5o0bJ7W4nyOvUxG3Vpok+vFAOtC1K2M7B76ZU7nPOoI7SirHEO1Sa67WumwKQ62PpQGlvJvyyQ8QGEYAAAAAVvFt6QAAAAIAAAAIAAAAAQAAAAIAAAAIAAAAAwAAJxAAAAAAj6+p+aI7JvbSfHisaUUAXhzcG+/2YWJE2bnf4zuV8i4BtzPP3p+X+41ZDhuvbqd9gBPhMAa04T+FGTRtk9yHtAAAAAIN4Lazp2QAAAAAAAAAAAEsAAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('032917e0e85d097843764846a0d82c14bb0f8e73cabbfcd003a5111a5f32c5d9', '3e4369447e1f510b0c9cc3c97713a213d6cf379880ecd80ecf0a715ee6220930', '39884abf2a5c1b93f305bbde369e6648cedf9c7e941046f5af2ba84b8152779f', 3, 1458662890, 'AAAAAj5DaUR+H1ELDJzDyXcTohPWzzeYgOzYDs8KcV7mIgkwd0EFH2/XsanJVR8X8ELJBTxcGzVFw3wAeAIIF6BdKwQAAAAAVvFt6gAAAAAAAAAATlvjBWe7MinR9n7UosajCKxUpgQMBBbhmF6bHAvPHGU5iEq/Klwbk/MFu942nmZIzt+cfpQQRvWvK6hLgVJ3nwAAAAMN4Lazp2QAAAAAAAAAAAH0AAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('cab34e504843017d6331b03b852f13b41e02bb6577e87f178e705333092d04ff', '032917e0e85d097843764846a0d82c14bb0f8e73cabbfcd003a5111a5f32c5d9', '00ce11e04988fb9a1fadb6c999179272245d00148f1f7bfbee5af6e1f55b5155', 4, 1458662891, 'AAAAAgMpF+DoXQl4Q3ZIRqDYLBS7D45zyrv80AOlERpfMsXZd8GwjnYvgPqZ0VWIaiZGcRTpH4v4F5m0AN6VDaFpt6gAAAAAVvFt6wAAAAAAAAAALLKPbMojH+RR+TSBDKGB/tufH2mL12ccCHr1Jn27yPAAzhHgSYj7mh+ttsmZF5JyJF0AFI8fe/vuWvbh9VtRVQAAAAQN4Lazp2QAAAAAAAAAAAJYAAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('f33708ae768e93033985edaa387c97efd6925e725bd0c2b8c1b70f645467505a', 'cab34e504843017d6331b03b852f13b41e02bb6577e87f178e705333092d04ff', '9c00f2d58fdd33ebdd9a14c33fb09066476ac4ca6591d0520777f798ac32dd75', 5, 1458662892, 'AAAAAsqzTlBIQwF9YzGwO4UvE7QeArtld+h/F45wUzMJLQT/rqCaozn62PY/yRKj7lt/rwdmcUC5XZDOgMV3ey62hdgAAAAAVvFt7AAAAAAAAAAAxlJuyWie0d1LzUCR1K4LD2g+0KuAHvbJ+SgmGHyguLWcAPLVj90z692aFMM/sJBmR2rEymWR0FIHd/eYrDLddQAAAAUN4Lazp2QAAAAAAAAAAAK8AAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('fb568a3aefb5484a357e0d8d8f6d0113e95b82c6334b720c1e34b9fc133c6187', 'f33708ae768e93033985edaa387c97efd6925e725bd0c2b8c1b70f645467505a', 'e8c8563156d6d2d1ca35a3b3eb520fc34fd1eca0dd822e72b3bdf7880e02181f', 6, 1458662893, 'AAAAAvM3CK52jpMDOYXtqjh8l+/Wkl5yW9DCuMG3D2RUZ1BayBengGbsurDd/bSXLW9Usuq0a3CyzV3QwCLroEc75DAAAAAAVvFt7QAAAAAAAAAAFp2fvkMO7OW+Jq1zFYvyIp0pN6KM6DetMmxOjZVOCKfoyFYxVtbS0co1o7PrUg/DT9HsoN2CLnKzvfeIDgIYHwAAAAYN4Lazp2QAAAAAAAAAAAMgAAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('69faabfcbfa1a28de52323cd647ea2b5931e8e07475f037e866acabba759c27f', 'fb568a3aefb5484a357e0d8d8f6d0113e95b82c6334b720c1e34b9fc133c6187', '98f53fc9f25f194602769ef1cf82c3812d7894b7ff34a1b088b8d610fb993e1d', 7, 1458662894, 'AAAAAvtWijrvtUhKNX4NjY9tARPpW4LGM0tyDB40ufwTPGGHXj+sAFac2I86NcAEdsKDClJFOJyVw4CF/STkrdYg9EIAAAAAVvFt7gAAAAAAAAAA2F0xW7K6lNYrXRzu7d5HyBUnPlumNFQipNBwSQNAx1KY9T/J8l8ZRgJ2nvHPgsOBLXiUt/80obCIuNYQ+5k+HQAAAAcN4Lazp2QAAAAAAAAAAAOEAAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('b4fd0a1deec7f8b90fb91c067567fb15776a1176c380fcf6c1faddcd63311104', '69faabfcbfa1a28de52323cd647ea2b5931e8e07475f037e866acabba759c27f', 'c9d1407eb6f6d1bcbfe6af0babe9300b8169ab0cbfbe15fa6fa1121e63369049', 8, 1458662895, 'AAAAAmn6q/y/oaKN5SMjzWR+orWTHo4HR18DfoZqyrunWcJ/RB681YejnrC0sjDS3nDAwFFFY4ZeHWeyXfdf2mA1j9sAAAAAVvFt7wAAAAAAAAAA17tytOKBxgu8yeo5X/akyYnyYlyrUb7gJWE+zfCgC2DJ0UB+tvbRvL/mrwur6TALgWmrDL++FfpvoRIeYzaQSQAAAAgN4Lazp2QAAAAAAAAAAAPoAAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
INSERT INTO ledgerheaders VALUES ('42751611629b320c79a620947d506a01f0423225ee50871428b1dac92b9d5669', 'b4fd0a1deec7f8b90fb91c067567fb15776a1176c380fcf6c1faddcd63311104', 'c9d1407eb6f6d1bcbfe6af0babe9300b8169ab0cbfbe15fa6fa1121e63369049', 9, 1458662896, 'AAAAArT9Ch3ux/i5D7kcBnVn+xV3ahF2w4D89sH63c1jMREEtl4Gj8sYtrTfhwiRhp771HnhdLkMAoukbNIuGgI+r5wAAAAAVvFt8AAAAAAAAAAA3z9hmASpL9tAVxktxD3XSOp3itxSvEmM6AUkwBS4ERnJ0UB+tvbRvL/mrwur6TALgWmrDL++FfpvoRIeYzaQSQAAAAkN4Lazp2QAAAAAAAAAAAPoAAAAAAAAAAAAAAAAAAAAZAX14QAAACcQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: publishqueue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: pubsub; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: scphistory; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 2, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAIAAAACAAAAAQAAAEhTuc86gjtKKscQ7VJrrta6bApDrY+lAaW8m/LJDxAYRgAAAABW8W3pAAAAAgAAAAgAAAABAAAAAgAAAAgAAAADAAAnEAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABApORtBCr9k4hRicnvDWBA2+sAEYdcsstGumbkenBLDBaUQqFmM5kMYEg9kRiqjp7Lyyp1Ljk99rMluIRoLS0yBQ==');
INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 3, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAMAAAACAAAAAQAAADB3QQUfb9exqclVHxfwQskFPFwbNUXDfAB4AggXoF0rBAAAAABW8W3qAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABAB9zOiXcfuOhRklJhx0/QAw5rSU7sfmRi3bDig/gMiwqNZERJe+rQzaSJpHrQA9N7Jebr0DOVR60EwdI4uTbIBA==');
INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 4, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAQAAAACAAAAAQAAADB3wbCOdi+A+pnRVYhqJkZxFOkfi/gXmbQA3pUNoWm3qAAAAABW8W3rAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABArQrUoA3wGyqDGOMDftlEqL1MUJqucGpRXgBUkXtswLBEd5+CpbwuPgmU0XzDsFneFQEiboyDevNzv1NW0gswAA==');
INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 5, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAUAAAACAAAAAQAAADCuoJqjOfrY9j/JEqPuW3+vB2ZxQLldkM6AxXd7LraF2AAAAABW8W3sAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABA3L6b03rUl/r9B61v0MkKOicrgWTslhv1emdT0p1V+GtmDjxANYCmmuWlogJQOtg9Tui0C4Fui9gPDT7m1V4LDw==');
INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 6, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAYAAAACAAAAAQAAADDIF6eAZuy6sN39tJctb1Sy6rRrcLLNXdDAIuugRzvkMAAAAABW8W3tAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABAfmClhEQM6/fdU4HOnM7UJxeNvBtUY0AltKC2ItifdhI1Zb5SEewugjeh56sJNO1tf34AhZPGlRJ9fVWUMiCoDQ==');
INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 7, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAcAAAACAAAAAQAAADBeP6wAVpzYjzo1wAR2woMKUkU4nJXDgIX9JOSt1iD0QgAAAABW8W3uAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABAWc5+VThoq3pbq22i5jZ5MHdC/JDjykQf4NnCdhjQPRV/gTlysHUj29WSKtH+henTrGlyYzoTiuPgaqLrorcfDA==');
INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 8, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAgAAAACAAAAAQAAADBEHrzVh6OesLSyMNLecMDAUUVjhl4dZ7Jd91/aYDWP2wAAAABW8W3vAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABAExZNUYlLJptvnNllx9jriLaKyobR2Z14Y2Jdg8iuMJFMRFARaqMNHjhxTqVcDsBny1rmOffGjavMlju+kDODDg==');
INSERT INTO scphistory VALUES ('GBXFWZOGH37RXG3FL6UMAKA6C663IL77IIK5LMRWFQSAX6P6DWMYJNKL', 9, 'AAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAkAAAACAAAAAQAAADC2XgaPyxi2tN+HCJGGnvvUeeF0uQwCi6Rs0i4aAj6vnAAAAABW8W3wAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABANg6KoRsiqDx5Ob/VmStE7p6nzLCmU4N8f0HkXLdG3aUNXpCOPshYNS3sFnBGE5Mj3KrceDS9r5YA8Qlm61irDQ==');


--
-- Data for Name: scpquorums; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO scpquorums VALUES ('cc1fb22376f71e23e1bb26c1cc4cca61c9c98e379e1cfb7e0e98204ff54dfd88', 9, 'AAAAAQAAAAEAAAAAbltlxj7/G5tlX6jAKB4XvbQv/0IV1bI2LCQL+f4dmYQAAAAA');


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO storestate VALUES ('databaseschema                  ', '3');
INSERT INTO storestate VALUES ('forcescponnextlaunch            ', 'false');
INSERT INTO storestate VALUES ('lastclosedledger                ', '42751611629b320c79a620947d506a01f0423225ee50871428b1dac92b9d5669');
INSERT INTO storestate VALUES ('historyarchivestate             ', '{
    "version": 1,
    "server": "v0.4.1-61-gffd1ccd",
    "currentLedger": 9,
    "currentBuckets": [
        {
            "curr": "7143480fc84788c095e494cd2844321a62ce81d2e1d3ba6c15b9ac5d6bfe5848",
            "next": {
                "state": 0
            },
            "snap": "5fbe1e53bf079fb1745944c3b0eb066c16f2934238ae0c1595fdf6bdabf709c8"
        },
        {
            "curr": "119e94eda9f771a7917b37dc2a53fcdd55de1fd33f3ffebff65ee207b4947213",
            "next": {
                "state": 1,
                "output": "3a47c2d0cba5d3c8e84a8c739cab7a661dd1d13898ad9c4ae6281dc996c574c0"
            },
            "snap": "5d0267c5830128805375bd61c17d3b41edc594f0c0d0c520b0f57776624eaa50"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 1,
                "output": "85d70ff8507c4a08f80fed6c67c989ce8b4515db24cd1c1e5bd36dccbc8c43e2"
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "curr": "0000000000000000000000000000000000000000000000000000000000000000",
            "next": {
                "state": 0
            },
            "snap": "0000000000000000000000000000000000000000000000000000000000000000"
        }
    ]
}');
INSERT INTO storestate VALUES ('lastscpdata                     ', 'AAAAAgAAAABuW2XGPv8bm2VfqMAoHhe9tC//QhXVsjYsJAv5/h2ZhAAAAAAAAAAJAAAAA8wfsiN29x4j4bsmwcxMymHJyY43nhz7fg6YIE/1Tf2IAAAAAQAAADC2XgaPyxi2tN+HCJGGnvvUeeF0uQwCi6Rs0i4aAj6vnAAAAABW8W3wAAAAAAAAAAAAAAABAAAAMLZeBo/LGLa034cIkYae+9R54XS5DAKLpGzSLhoCPq+cAAAAAFbxbfAAAAAAAAAAAAAAAEB3Uk+p5Sx324oiGsRU4LvIgib9jHqFSINK2wWFLjdAiKUBDhuox4OT2VBbhz6jJmFVw47Njgre2xwZLfPoKY8PAAAAAG5bZcY+/xubZV+owCgeF720L/9CFdWyNiwkC/n+HZmEAAAAAAAAAAkAAAACAAAAAQAAADC2XgaPyxi2tN+HCJGGnvvUeeF0uQwCi6Rs0i4aAj6vnAAAAABW8W3wAAAAAAAAAAAAAAABzB+yI3b3HiPhuybBzEzKYcnJjjeeHPt+DpggT/VN/YgAAABANg6KoRsiqDx5Ob/VmStE7p6nzLCmU4N8f0HkXLdG3aUNXpCOPshYNS3sFnBGE5Mj3KrceDS9r5YA8Qlm61irDQAAAAG0/Qod7sf4uQ+5HAZ1Z/sVd2oRdsOA/PbB+t3NYzERBAAAAAAAAAABAAAAAQAAAAEAAAAAbltlxj7/G5tlX6jAKB4XvbQv/0IV1bI2LCQL+f4dmYQAAAAA');


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO trustlines VALUES ('GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU', 1, 'GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4', 'USD', 9223372036854775807, 0, 1, 6);
INSERT INTO trustlines VALUES ('GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON', 1, 'GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4', 'USD', 40000000000, 0, 0, 8);


--
-- Data for Name: txfeehistory; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO txfeehistory VALUES ('db398eb4ae89756325643cad21c94e13bfc074b323ee83e141bf701a5d904f1b', 2, 1, 'AAAAAgAAAAMAAAABAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/+cAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('f97caffab8c16023a37884165cb0b3ff1aa2daf4000fef49d21efc847ddbfbea', 2, 2, 'AAAAAQAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/84AAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('90880ac53815dac8441add0220a7631ef5eac3d57c2e89634ea9b5203f61a8e4', 2, 3, 'AAAAAQAAAAEAAAACAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9w3gtrOnY/7UAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('7a707186a5cc36a0e520548ae511b53896c0391ce166d40da80588cbaae6aa2c', 3, 1, 'AAAAAgAAAAMAAAACAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAADAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+OcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('c6bfdd93f1470df9dfa3ef95d57ba28cecace068d9f2bb040a79ffc7c5d96cb9', 3, 2, 'AAAAAQAAAAEAAAADAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+M4AAAAAgAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('bd486dbdd02d460817671c4a5a7e9d6e865ca29cb41e62d7aaf70a2fee5b36de', 4, 1, 'AAAAAgAAAAMAAAACAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAAEAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+OcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('b55d768a4e8e712da20efdee0e7d85f02948f9b6fd3ef2daefd3a5a147ecd63d', 5, 1, 'AAAAAgAAAAMAAAACAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAAFAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+OcAAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('3b666a253313fc7a0d241ee28064eec78aaa5ebd0a7c0ae7f85259e80fad029f', 6, 1, 'AAAAAgAAAAMAAAADAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+M4AAAAAgAAAAIAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAAGAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+LUAAAAAgAAAAMAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('3f2aa00ba539e24ba9c0ba62f50318d8c7180f2d6757cc76e9984055c5e19ff4', 7, 1, 'AAAAAgAAAAMAAAAGAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+LUAAAAAgAAAAMAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAAHAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+JwAAAAAgAAAAQAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAA==');
INSERT INTO txfeehistory VALUES ('3ce9fc1159c25adc62c9686792cd41f06908280b899744057856db33bafe75de', 8, 1, 'AAAAAgAAAAMAAAAHAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+JwAAAAAgAAAAQAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAAIAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+IMAAAAAgAAAAUAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAA==');


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO txhistory VALUES ('db398eb4ae89756325643cad21c94e13bfc074b323ee83e141bf701a5d904f1b', 2, 1, 'AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvkAAAAAAAAAAABVvwF9wAAAEAYjQcPT2G5hqnBmgGGeg9J8l4c1EnUlxklElH9sqZr0971F6OLWfe/m4kpFtI+sI0i1qLit5A0JyWnbhYLW5oD', '2zmOtK6JdWMlZDytIclOE7/AdLMj7oPhQb9wGl2QTxsAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL5AAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2sVNYGtQAAAAAAAAAAwAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA');
INSERT INTO txhistory VALUES ('f97caffab8c16023a37884165cb0b3ff1aa2daf4000fef49d21efc847ddbfbea', 2, 2, 'AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAACAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvkAAAAAAAAAAABVvwF9wAAAEBmKpSgvrwKO20XCOfYfXsGEEUtwYaaEfqSu6ymJmlDma+IX6I7IggbUZMocQdZ94IMAfKdQANqXbIO7ysweeMC', '+Xyv+rjBYCOjeIQWXLCz/xqi2vQAD+9J0h78hH3b++oAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL5AAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2rv9MNtQAAAAAAAAAAwAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA');
INSERT INTO txhistory VALUES ('90880ac53815dac8441add0220a7631ef5eac3d57c2e89634ea9b5203f61a8e4', 2, 3, 'AAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3AAAAZAAAAAAAAAADAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvkAAAAAAAAAAABVvwF9wAAAEBdX4R/Ghzq8/r+u8PL+sNriHsS5lW1Vt+9eCe0nnWMNTzMgcUbarePbrpD2gr8DjVumcmpVH9wG2GXtWvwzXoL', 'kIgKxTgV2shEGt0CIKdjHvXqw9V8LoljTqm1ID9hqOQAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAAAAAAIAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL5AAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3DeC2rKtAUtQAAAAAAAAAAwAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA');
INSERT INTO txhistory VALUES ('7a707186a5cc36a0e520548ae511b53896c0391ce166d40da80588cbaae6aa2c', 3, 1, 'AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB+ZAt7wAAAEDBhDOsFWP2KCoZuJDRXuiNm0CjgVKLLtdZi/A3OfrCsgvX8izhAllXkRqrXyitSvGo3kQh6V/S/tnQbrYgHQQG', 'enBxhqXMNqDlIFSK5RG1OJbAORzhZtQNqAWIy6rmqiwAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==', 'AAAAAAAAAAEAAAABAAAAAQAAAAMAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL4zgAAAACAAAAAgAAAAAAAAAAAAAAAQAAAAABAAAAAAAAAAAAAAAAAAAA');
INSERT INTO txhistory VALUES ('c6bfdd93f1470df9dfa3ef95d57ba28cecace068d9f2bb040a79ffc7c5d96cb9', 3, 2, 'AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAZAAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB+ZAt7wAAAEBVJkTQTFlpFKoMhcibMpdJ5khR91LY3zPQwv/e5Ov7XIcWKGIv5sDfgyhaK/x5WYWfawNWcc5fMlW7c/PxGOQJ', 'xr/dk/FHDfnfo++V1XuijOys4GjZ8rsECnn/x8XZbLkAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==', 'AAAAAAAAAAEAAAABAAAAAQAAAAMAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL4zgAAAACAAAAAgAAAAAAAAAAAAAAAwAAAAABAAAAAAAAAAAAAAAAAAAA');
INSERT INTO txhistory VALUES ('bd486dbdd02d460817671c4a5a7e9d6e865ca29cb41e62d7aaf70a2fee5b36de', 4, 1, 'AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAGu5L5MAAAAQB9kmKW2q3v7Qfy8PMekEb1TTI5ixqkI0BogXrOt7gO162Qbkh2dSTUfeDovc0PAafhDXxthVAlsLujlBmyjBAY=', 'vUhtvdAtRggXZxxKWn6dboZcopy0HmLXqvcKL+5bNt4AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAAAAAAQAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAAAAAAAAAAAAAAAAAQAAAAQAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL45wAAAACAAAAAQAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA');
INSERT INTO txhistory VALUES ('b55d768a4e8e712da20efdee0e7d85f02948f9b6fd3ef2daefd3a5a147ecd63d', 5, 1, 'AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAZAAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAlQL5AAAAAAAAAAAAFvFIhaAAAAQBlpm/6rv5JvbN2AKUSlH+4idIlX0cM678QXxK+il0u7z3KLORdzKSkLnS5WdLZlAB6iDmoKI5WbydQLktNtDQA=', 'tV12ik6OcS2iDv3uDn2F8ClI+bb9PvLa79OloUfs1j0AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAAAAAAUAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAAlQL5AAAAAAAAAAAAAAAAAAAAAAAQAAAAUAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL45wAAAACAAAAAQAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA');
INSERT INTO txhistory VALUES ('3b666a253313fc7a0d241ee28064eec78aaa5ebd0a7c0ae7f85259e80fad029f', 6, 1, 'AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAZAAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAcAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABVVNEAAAAAAEAAAAAAAAAAfmQLe8AAABAL6czYFvSBhdVeD4fbXOHuXFa2CDqLpFfc+QJnoiPLt/23YViURGLyfg388FKMKsbNJEgmFsCJjtgl3fj7wr/Aw==', 'O2ZqJTMT/HoNJB7igGTux4qqXr0KfArn+FJZ6A+tAp8AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAcAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAwAAAAQAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAAAAAAAAAAAAAAAAAQAAAAYAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAQAAAAAAAAAA');
INSERT INTO txhistory VALUES ('3f2aa00ba539e24ba9c0ba62f50318d8c7180f2d6757cc76e9984055c5e19ff4', 7, 1, 'AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAZAAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAcAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEAAAAAAEAAAAAAAAAAfmQLe8AAABA1TAQBu/2f7XHs/ctAJ5W7Ytk4jvQBopdO05zkSQoS8piu1mZm/tTvDTXEq/QUufpt/E8NBgKtNpcJXuMv5aPCw==', 'PyqgC6U54kupwLpi9QMY2McYDy1nV8x26ZhAVcXhn/QAAAAAAAAAZAAAAAAAAAABAAAAAAAAAAcAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAwAAAAUAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAAlQL5AAAAAAAAAAAAAAAAAAAAAAAQAAAAcAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAAlQL5AAAAAAAQAAAAAAAAAA');
INSERT INTO txhistory VALUES ('3ce9fc1159c25adc62c9686792cd41f06908280b899744057856db33bafe75de', 8, 1, 'AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAZAAAAAIAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAcAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEAAAAAAAAAAAAAAAAAfmQLe8AAABASafHp/zp11tF81MRvbAnx9gQNTXdLW4DmoIofkgoG+jJw/Xj/k+N5WvSjqGrGF33uB6KnD+wAfQIhf0/DlxpBQ==', 'POn8EVnCWtxiyWhnks1B8GkIKAuJl0QFeFbbM7r+dd4AAAAAAAAAZAAAAAAAAAABAAAAAAAAAAcAAAAAAAAAAA==', 'AAAAAAAAAAEAAAACAAAAAwAAAAcAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAAlQL5AAAAAAAQAAAAAAAAAAAAAAAQAAAAgAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAAAAAAlQL5AAAAAAAAAAAAAAAAAA');


--
-- Name: accountdata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accountdata
    ADD CONSTRAINT accountdata_pkey PRIMARY KEY (accountid, dataname);


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
-- Name: publishqueue_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publishqueue
    ADD CONSTRAINT publishqueue_pkey PRIMARY KEY (ledger);


--
-- Name: pubsub_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pubsub
    ADD CONSTRAINT pubsub_pkey PRIMARY KEY (resid);


--
-- Name: scpquorums_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scpquorums
    ADD CONSTRAINT scpquorums_pkey PRIMARY KEY (qsethash);


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
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, assetcode);


--
-- Name: txfeehistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txfeehistory
    ADD CONSTRAINT txfeehistory_pkey PRIMARY KEY (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (ledgerseq, txindex);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance) WHERE (balance >= 1000000000);


--
-- Name: buyingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX buyingissuerindex ON offers USING btree (buyingissuer);


--
-- Name: histbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX histbyseq ON txhistory USING btree (ledgerseq);


--
-- Name: histfeebyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX histfeebyseq ON txfeehistory USING btree (ledgerseq);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: scpenvsbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX scpenvsbyseq ON scphistory USING btree (ledgerseq);


--
-- Name: sellingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sellingissuerindex ON offers USING btree (sellingissuer);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- PostgreSQL database dump complete
--

