# Correção do Erro de Modelo Claude Sonnet 4.6

## Problema Identificado

O sistema PicoClaw estava apresentando erro 404 ao tentar usar o modelo `claude-sonnet-4.6`:

```
[ERROR] agent: LLM call failed {agent_id=main, iteration=1, error=API request failed:
  Status: 404
  Body:   {"error":{"code":"not_found_error","message":"model: claude-sonnet-4.6 was not found. Did you mean claude-sonnet-4-6?","type":"invalid_request_error","param":null}}
```

## Causa Raiz

O nome do modelo estava incorreto nos arquivos de configuração. A API da Anthropic espera o nome `claude-sonnet-4-6` (com hífens), mas o sistema estava configurado com `claude-sonnet-4.6` (com pontos).

## Arquivos Alterados

### 1. `docker/data/config.json`
**Localização**: Configuração ativa do Docker
**Alterações**:
- Linha 10: `"model": "claude-sonnet-4.6"` → `"model": "claude-sonnet-4-6"`
- Linha 172: `"model_name": "claude-sonnet-4.6"` → `"model_name": "claude-sonnet-4-6"`  
- Linha 173: `"model": "anthropic/claude-sonnet-4.6"` → `"model": "anthropic/claude-sonnet-4-6"`

### 2. `config/config.example.json`
**Localização**: Arquivo de exemplo de configuração
**Alterações**:
- Linha 20: `"model_name": "claude-sonnet-4.6"` → `"model_name": "claude-sonnet-4-6"`
- Linha 21: `"model": "anthropic/claude-sonnet-4.6"` → `"model": "anthropic/claude-sonnet-4-6"`

### 3. `cmd/picoclaw-launcher/internal/server/auth_config.go`
**Localização**: Configuração padrão do launcher
**Alterações**:
- Linha 51: `ModelName: "claude-sonnet-4.6"` → `ModelName: "claude-sonnet-4-6"`
- Linha 52: `Model: "anthropic/claude-sonnet-4.6"` → `Model: "anthropic/claude-sonnet-4-6"`
- Linha 56: `cfg.Agents.Defaults.ModelName = "claude-sonnet-4.6"` → `cfg.Agents.Defaults.ModelName = "claude-sonnet-4-6"`

## Comandos Executados para Aplicar a Correção

1. **Busca pelos arquivos com o problema**:
   ```bash
   grep -r "claude-sonnet-4\.6" .
   ```

2. **Reinicialização do container**:
   ```bash
   docker compose -f docker/docker-compose.yml --profile gateway restart picoclaw-gateway
   ```

3. **Verificação dos logs**:
   ```bash
   docker logs picoclaw-gateway --tail 20
   ```

## Verificação do Sucesso

Após as alterações, o sistema apresentou os seguintes indicadores de sucesso:

- ✅ Gateway iniciado na porta 127.0.0.1:18790
- ✅ Bot do Telegram conectado (velkan_trader_bot)
- ✅ LLM respondendo adequadamente sem erros 404
- ✅ Logs mostrando "LLM response without tool calls (direct answer)"

## Arquivos de Documentação Também Afetados

Os seguintes arquivos de README continham exemplos com o nome incorreto do modelo, mas não foram alterados pois são documentação:
- `README.md`
- `README.fr.md` 
- `README.pt-br.md`

**Nota**: Se estes READMEs forem atualizados no futuro, lembrar de usar `claude-sonnet-4-6` em vez de `claude-sonnet-4.6` nos exemplos.

## Data da Correção
2 de março de 2026

---

**Resumo**: O erro foi causado por uma diferença sutil no formato do nome do modelo. A Anthropic API requer hífens (`-`) em vez de pontos (`.`) no nome do modelo Claude Sonnet 4.6.