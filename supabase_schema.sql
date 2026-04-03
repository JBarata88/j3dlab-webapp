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
  created_at    timestamptz default now(),
  mao_obra_min  numeric,
  embalagem_nome text,
  embalagem_custo numeric,
  transporte_nome text,
  transporte_custo numeric,
  outros_nome   text,
  outros_custo  numeric,
  categoria     text,
  preco_final   numeric
);

-- Migração: adicionar coluna preco_final se a tabela já existir
alter table public.orcamentos add column if not exists preco_final numeric;
-- Migração: filamentos usados no orçamento (para passar ao trabalho)
alter table public.orcamentos add column if not exists filamentos_usados jsonb default '[]';

-- TRABALHOS (Trabalhos de impressão — ligados a orçamentos aceites)
create table if not exists public.trabalhos (
  orcamento_id      bigint primary key,
  status            text default 'Para Imprimir',
  venda_id          bigint,
  filamentos_usados jsonb default '[]',
  created_at        timestamptz default now()
);

-- Migração: adicionar coluna filamentos_usados se a tabela já existir
alter table public.trabalhos add column if not exists filamentos_usados jsonb default '[]';

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
  cliente       text,
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

-- Migração: coluna bobines (gestão de bobines individuais por filamento)
alter table public.filamentos add column if not exists bobines jsonb default '[]';

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
  filamentos_usados jsonb default '[]',
  embalagem_nome  text,
  transporte_nome text,
  transporte_custo numeric,
  outros_nome     text,
  outros_custo    numeric,
  created_at      timestamptz default now()
);

-- Migração: novas colunas no catálogo
alter table public.catalogo add column if not exists filamentos_usados jsonb default '[]';
alter table public.catalogo add column if not exists embalagem_nome text;
alter table public.catalogo add column if not exists transporte_nome text;
alter table public.catalogo add column if not exists transporte_custo numeric;
alter table public.catalogo add column if not exists outros_nome text;
alter table public.catalogo add column if not exists outros_custo numeric;
-- Campos de custo detalhados (espelham o orçamento)
alter table public.catalogo add column if not exists peso numeric;
alter table public.catalogo add column if not exists tempo numeric;
alter table public.catalogo add column if not exists eletrico numeric;
alter table public.catalogo add column if not exists mao_obra_min numeric;
alter table public.catalogo add column if not exists qualidade numeric default 1.1;
alter table public.catalogo add column if not exists filamento_preco numeric default 20;

-- CONFIGURACOES (Configurações gerais da app — linha única id=1)
create table if not exists public.configuracoes (
  id            bigint primary key default 1,
  mao_obra      numeric default 8,
  eletricidade  numeric default 0.15,
  embalagens      jsonb default '[]',
  outros          jsonb default '[]',
  transportadoras jsonb default '[]',
  categorias      jsonb default '[]',
  created_at    timestamptz default now()
);

-- CLIENTES (Carteira de clientes)
create table if not exists public.clientes (
  id            bigint primary key,
  cliente_id    text unique,
  nome          text not null,
  email         text,
  telefone      text,
  nif           text,
  morada        text,
  notas         text,
  created_at    timestamptz default now()
);

-- UTILIZADORES (Acesso ao sistema de gestão)
create table if not exists public.utilizadores (
  id            bigint primary key,
  nome          text not null,
  email         text not null,
  nivel         text default 'Visualizador',
  ativo         text default 'Ativo',
  password      text,
  notas         text,
  created_at    timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Apenas utilizadores autenticados via Supabase Auth têm acesso.
-- ============================================================

alter table public.orcamentos    enable row level security;
alter table public.trabalhos     enable row level security;
alter table public.vendas        enable row level security;
alter table public.filamentos    enable row level security;
alter table public.impressoras   enable row level security;
alter table public.catalogo      enable row level security;
alter table public.configuracoes enable row level security;
alter table public.clientes      enable row level security;
alter table public.utilizadores  enable row level security;

-- Política: só utilizadores autenticados (Supabase Auth)
create policy "Auth only" on public.orcamentos    for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.trabalhos     for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.vendas        for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.filamentos    for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.impressoras   for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.catalogo      for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.configuracoes for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.clientes      for all using (auth.uid() is not null) with check (auth.uid() is not null);
create policy "Auth only" on public.utilizadores  for all using (auth.uid() is not null) with check (auth.uid() is not null);
