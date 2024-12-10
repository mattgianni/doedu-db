DROP TYPE IF EXISTS public."MetricCategory";
CREATE TYPE public."MetricCategory" AS ENUM ('about', 'outcome');
ALTER TYPE public."MetricCategory" OWNER TO postgres;

DROP TYPE IF EXISTS public."ProgramCategory";
CREATE TYPE public."ProgramCategory" AS ENUM ('volunteer', 'donate', 'enrichment');
ALTER TYPE public."ProgramCategory" OWNER TO postgres;
