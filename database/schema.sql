-- PostgreSQL database dump optimizado para Docker
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

-- 1. Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

-- 2. Tipos ENUM
-- Eliminamos el OWNER TO para que sea compatible con cualquier usuario del .env
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'player_roles_enum') THEN
        CREATE TYPE public.player_roles_enum AS ENUM (
            'manager',
            'player',
            'watcher'
        );
    END IF;
END $$;

SET default_tablespace = '';
SET default_table_access_method = heap;

-- 3. Tabla: games
CREATE TABLE IF NOT EXISTS public.games (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "roomName" text NOT NULL,
    "roomPassword" text NOT NULL,
    "roomPlayers" integer DEFAULT 4 NOT NULL,
    word text,
    "customWords" boolean DEFAULT false NOT NULL,
    "specificCategory" boolean DEFAULT false NOT NULL,
    category text,
    "multipleImpostors" boolean DEFAULT false NOT NULL,
    "overlay" boolean DEFAULT false NOT NULL,
    "roomPlayersJoined" integer DEFAULT 0 NOT NULL,
    round integer DEFAULT 0 NOT NULL,
    "gameStarted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "PK_c9b16b62917b5595af982d66337" PRIMARY KEY (id),
    CONSTRAINT "UQ_feb26e8afe6ddf82364c60a4081" UNIQUE ("roomName")
);

-- 4. Tabla: player
CREATE TABLE IF NOT EXISTS public.player (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    host boolean DEFAULT false NOT NULL,
    "avatarImg" boolean DEFAULT false NOT NULL,
    impostor boolean DEFAULT false NOT NULL,
    roles public.player_roles_enum[] DEFAULT '{player}'::public.player_roles_enum[] NOT NULL,
    "gameId" uuid,
    CONSTRAINT "PK_65edadc946a7faf4b638d5e8885" PRIMARY KEY (id),
    CONSTRAINT "FK_7dfdd31fcd2b5aa3b08ed15fe8a" FOREIGN KEY ("gameId") REFERENCES public.games(id) ON DELETE CASCADE
);

-- 5. Índices y Constraints adicionales (si los hubiera)
-- El script ya incluye las PK y FK arriba para asegurar la creación atómica.