-- ============================================================
-- J3D Lab PT — Supabase Schema
-- Execute este script no SQL Editor do Supabase:
-- Dashboard → SQL Editor → New Query → colar e executar
-- ============================================================

-- ORCAMENTOS (Orçamentos de impressão 3D)
create table if not exists public.orcamentos (
  id            bigint primary key,
  nome          text not null,
  cliente       text,
  material      text,
  impressora_id text,
  peso          numeric,
  tempo         numeric,
  eletrico      numeric,
  margem        numeric,
  filamento_preco numeric,
  qualidade     numeric,
  estado        text default 'Pendente',
  notas         text,
  preco         numeric,
  data          timestamptz default now(),
  created_at    timestamptz default now()
);

-- TRABALHOS (Trabalhos de impressão — ligados a orçamentos aceites)
create table if not exists public.trabalhos (
  orcamento_id  bigint primary key,
  status        text default 'Para Imprimir',
  venda_id      bigint,
  created_at    timestamptz default now()
);

-- VENDAS (Registo de vendas)
create table if not exists public.vendas (
  id            bigint primary key,
  data          date,
  produto       text,
  categoria     text,
  material      text,
  qtd           numeric,
  custo_unit    numeric,
  custo_total   numeric,
  preco         numeric,
  receita       numeric,
  lucro         numeric,
  margem        numeric,
  notas         text,
  created_at    timestamptz default now()
);

-- FILAMENTOS (Inventário de filamentos)
create table if not exists public.filamentos (
  id            bigint primary key,
  marca         text,
  material      text,
  cor_nome      text,
  cor_hex       text default '#ffffff',
  peso_total    numeric default 1000,
  peso_restante numeric default 1000,
  preco         numeric,
  diametro      text default '1.75mm',
  temp_bico     text,
  temp_cama     text,
  estado        text default 'Disponível',
  localizacao   text,
  created_at    timestamptz default now()
);

-- IMPRESSORAS (Impressoras 3D)
create table if not exists public.impressoras (
  id            bigint primary key,
  nome          text not null,
  marca         text,
  tipo          text default 'FDM',
  estado        text default 'Disponível',
  movimento     text,
  enclosure     text,
  vol_x         numeric,
  vol_y         numeric,
  vol_z         numeric,
  velocidade    numeric,
  max_temp      numeric,
  preco         numeric,
  w_print       numeric,
  w_standby     numeric,
  w_max         numeric,
  horas         numeric default 0,
  custo_hora    numeric default 0.15,
  descricao     text,
  notas         text,
  created_at    timestamptz default now()
);

-- CATALOGO (Catálogo de produtos — usado para autocomplete nas vendas)
create table if not exists public.catalogo (
  id              bigint primary key,
  sku             text,
  nome            text not null,
  categoria       text,
  material        text,
  custo_material  numeric,
  custo_mao_obra  numeric,
  embalagem       numeric,
  custo_total     numeric,
  preco_sugerido  numeric,
  margem_sugerida numeric,
  created_at      timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Esta app é uma ferramenta interna de utilizador único.
-- Permite todas as operações com a anon key.
-- ============================================================

alter table public.orcamentos  enable row level security;
alter table public.trabalhos   enable row level security;
alter table public.vendas      enable row level security;
alter table public.filamentos  enable row level security;
alter table public.impressoras enable row level security;
alter table public.catalogo    enable row level security;

-- Política: permitir tudo para utilizadores anónimos (ferramenta interna)
create policy "Allow all orcamentos"  on public.orcamentos  for all using (true) with check (true);
create policy "Allow all trabalhos"   on public.trabalhos   for all using (true) with check (true);
create policy "Allow all vendas"      on public.vendas      for all using (true) with check (true);
create policy "Allow all filamentos"  on public.filamentos  for all using (true) with check (true);
create policy "Allow all impressoras" on public.impressoras for all using (true) with check (true);
create policy "Allow all catalogo"    on public.catalogo    for all using (true) with check (true);
