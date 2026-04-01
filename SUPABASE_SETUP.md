# Configurar Supabase — J3D Lab PT

## Passo 1 — Criar projeto no Supabase

1. Vai a [supabase.com](https://supabase.com) e cria uma conta (grátis)
2. Clica em **"New Project"**
3. Dá um nome ao projeto (ex: `j3dlab`) e escolhe uma região próxima (ex: West EU)
4. Define uma password para a base de dados → guarda-a num lugar seguro
5. Aguarda ~2 minutos enquanto o projeto é criado

---

## Passo 2 — Criar as tabelas (executar o schema SQL)

1. No dashboard do Supabase, vai a **SQL Editor** (menu lateral)
2. Clica em **"New Query"**
3. Abre o ficheiro `supabase_schema.sql` deste projeto
4. Copia todo o conteúdo e cola no editor do Supabase
5. Clica em **"Run"** (ou `Ctrl+Enter`)
6. Deves ver "Success. No rows returned" — as tabelas foram criadas

---

## Passo 3 — Obter as credenciais da API

1. No dashboard, vai a **Project Settings** → **API** (menu lateral)
2. Copia os seguintes valores:
   - **Project URL** → algo como `https://abcdefghij.supabase.co`
   - **anon / public** key → uma string longa que começa com `eyJ...`

---

## Passo 4 — Ligar o site ao Supabase

1. Abre o ficheiro `index.html` neste projeto
2. Procura estas linhas perto do início do `<script>` (logo após os CDN imports):

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';       // ex: https://abcdef.supabase.co
const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY';  // chave anon/public
```

3. Substitui `YOUR_SUPABASE_URL` pelo **Project URL** que copiaste
4. Substitui `YOUR_SUPABASE_ANON_KEY` pela **anon key** que copiaste
5. Guarda o ficheiro

---

## Passo 5 — Testar

1. Abre o site (`node serve.mjs` → `http://localhost:3000`)
2. O ecrã de carregamento deve aparecer brevemente e depois a app abre
3. Adiciona um orçamento de teste → abre o **Table Editor** no Supabase e confirma que aparece na tabela `orcamentos`

---

## Tabelas criadas

| Tabela        | Descrição                          |
|---------------|------------------------------------|
| `orcamentos`  | Orçamentos de impressão 3D         |
| `trabalhos`   | Trabalhos de impressão em produção |
| `vendas`      | Registo de vendas                  |
| `filamentos`  | Inventário de filamentos           |
| `impressoras` | Impressoras 3D                     |
| `catalogo`    | Catálogo de produtos               |

---

## Notas de segurança

- A configuração atual usa a **anon key** com políticas RLS abertas (allow all).
  Isto é seguro para uma ferramenta interna de uso pessoal.
- Se quiseres restringir acesso, podes ativar autenticação no Supabase e
  ajustar as políticas RLS para exigir `auth.uid()`.
- **Nunca partilhes o ficheiro `index.html` com as credenciais em público.**
  Para deploy público, move as credenciais para variáveis de ambiente.
