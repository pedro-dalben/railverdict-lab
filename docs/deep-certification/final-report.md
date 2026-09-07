# Relatório final — Certificação funcional profunda RailVerdict 1.8.3

Campanha executada em `lab/deep-cert-1.8.2` (16 commits sobre `1b371d1`),
produto em `fix/1.8.3-cli-surface` (`8e41472`, filho de `v1.8.2`).
Relatório ao usuário em português; documentos técnicos do repositório em inglês.

## 1. O que foi comprovado e para qual SHA/gem/ambiente

- **Candidato:** `rail_verdict` 1.8.3, build local do commit `8e41472`
  (`fix/1.8.3-cli-surface` ← `89a4673` = tag `v1.8.2`).
  Gem SHA-256 `6ed0275ce602cffd1172f2fc3444c6aa731325be6b15c187d9778a15f3bf19ad`,
  payload `lib/`+`exe/`+`schemas/` idêntico ao `git archive` da fonte,
  instalação isolada comprova `railverdict 1.8.3` carregado do gem home.
- **Harness:** oráculo 2.1, catálogo 5.0 com 245 cenários (173 legados
  preservados + 72 DEEP), runner com locks/attempts/identidade de fixture.
- **Ambiente canônico:** ruby 3.4.5, rails 8.1.3.1, rubocop 1.89.0,
  rspec-core 3.13.6, minitest 6.0.6, bundler-audit 0.9.3, simplecov
  formato 1.0, git 2.43.0, ubuntu 24.04. Seed da campanha: 18282.

## 2. Contratos, assertions e cenários cobertos

- **Obrigações:** 56 covered + 2 not_applicable com motivo verificável
  (`gate_mirror` não emite objeto de requirement por desenho;
  `database_consistency` diferido por falta de contrato estruturado).
- **Cenários:** 245/245 PASS na rodada final íntegra (exit 0, zero skips),
  replay da cadeia crítica 6/6 estável (RVLAB-01, DEEP-POL-001,
  DEEP-REPAIR-001, DEEP-REUSE-01, DEEP-MCP-001, DEEP-CI-UNMAP-11).
- **Harness:** self-test 33 checks, bateria trust 26 testes (fuzz com seed
  fixa, 42 mutantes, todos mortos), infra 14 testes — tudo verde.
  Agregação final: VALIDATION PASS, zero erros de integridade, zero
  capabilities descobertas.
- **Produto:** suite completa na branch de fix, 716 testes, 0 falhas.
- Contagem não substitui cobertura: cada obrigação acima tem cenários
  nomeados em `coverage-obligations.json` e evidência por cenário em
  `artifacts/<id>/` (stdout, stderr, exit, observation, reproduction).

## 3. Bugs encontrados e correção comprovada

**Produto (corrigidos em 1.8.3, com controle negativo):**
- B-001: `investigate` anunciado e implementado mas sem dispatch (saía 2
  como comando desconhecido) → 1 linha de dispatch + teste.
- B-002: `--format sarif` aceito em 5 comandos mas renderizando console →
  validação por comando (banners), 2 testes. `check` mantém SARIF 2.1.0.
- B-003: docs clamam 19 superfícies, o código define 18 desde a 1.6 →
  registrado, sem version bump (correção de palavra acompanha a próxima
  mudança comportamental).

**Harness (14 achados H-01..H-14, todos corrigidos com prova):** expectativa
ausente certificava; contagens inferidas de evidência ausente; `LabSupport.json`
engolia parse error; envelopes sintéticos; lock/colisão de workdir;
sobrescrita de attempts; `source_sha: HEAD`; flag `--remove` do bundler que
nunca existiu; `config_replace` silencioso; lista de tools do protocolo
obsoleta (12 em vez de 16); matriz do CI com 14 de 25 categorias.

**Cenários legados reparados (3):** RVLAB-WF-01/06/07 continham expectativas
que nenhum output jamais teve (`decision`, `completion_status` de receipt) —
o oráculo estrito expôs, foram reescritas para campos reais e passam.

## 4. O que continua limitado, bloqueado ou fora do escopo

- **Distribuição:** `LOCAL_CANDIDATE_ONLY` — 1.8.3 não publicada; CI segue
  vermelho no fetch até publicar (decisão do mantenedor).
- Real Brakeman ausente do bundle do lab (aceitação via simulados +
  indisponível; transição de revisão do DB de advisories não testada).
- Grandchild reaping de timeout não provado; lock é exclusão mútua.
- Ruby mínimo 3.3, outras linhas Rails, Windows/macOS/JRuby: fora do escopo.
- Near-miss/mixed além de auth/security: parcial menor e explícito.
- Ranking do foco é subconjunto dedupado ordenado por risco (recall 3/4
  com semântica documentada), não lista exaustiva — utilidade ≠ cobertura.
- G3/G4, adoção comercial, programa de 10 projetos, 2.0: fora do escopo.

## 5. Veredito principal e status de distribuição

- **Veredito: `DEEP_CERTIFIED`** — todas as 56 obrigações obrigatórias do
  escopo declarado comprovadas no candidato final, harness aprovado em
  todos os mutantes obrigatórios, rodada final íntegra 245/245, zero
  defeitos contratuais conhecidos escondidos.
- **Distribuição: `LOCAL_CANDIDATE_ONLY`** — certificação técnica do
  artefato local; publicação é verificação separada.

## 6. Índice de evidências (paths no branch de campanha)

- Manifesto: `docs/deep-certification/candidate-1.8.3.lock.json` (+ 1.8.2).
- Reconciliação: `reconciliation.md`. Inventário: `contract-inventory.md`
  + `lab/deep-certification/coverage-obligations.json`.
- Confiança do harness: `oracle-trust-report.json/.md`.
- Defeitos: `defects.md`. Relatórios por nó: `d04-*.md` … `d12-*.md`.
- Resultados: `artifacts/<id>/` (245), `artifacts/lab-run-summary.json`,
  `artifacts/validation-summary.json`, `docs/deep-certification/validation-report.md`.
- Diffs: 16 commits `1b5e173..ced3b88` no Lab; 1 commit `8e41472` no produto
  (branch `fix/1.8.3-cli-surface`, testes `test_cli_surface.rb`).
