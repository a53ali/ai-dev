# MCP Server Configurations

Pre-configured [Model Context Protocol](https://modelcontextprotocol.io) server definitions for tools commonly used by engineering teams. Drop a config into your agent's MCP settings to give it live access to Jira, Confluence, GitHub, and Linear.

> **What is MCP?** MCP servers extend what a coding agent can *do* — they add tools the agent can call (search Jira, create Confluence pages, query GitHub PRs) rather than just instructing it how to behave (that's what skills do).

---

## Files

| Config | Tool | What it enables |
|--------|------|-----------------|
| `jira.json` | Atlassian Jira | Query issues with JQL, create/update tickets, manage sprints |
| `confluence.json` | Atlassian Confluence | Search and read pages, create/update documentation |
| `github.json` | GitHub | Search repos/issues/PRs, create issues, manage releases |
| `linear.json` | Linear | Query issues and cycles, create and update issues |

---

## Setup by agent

### Claude Code

Add to `~/.claude/settings.json` under `mcpServers`:

```json
{
  "mcpServers": {
    "jira": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-jira"], "env": { "JIRA_URL": "https://your-org.atlassian.net", "JIRA_EMAIL": "you@example.com", "JIRA_API_TOKEN": "your-token" } }
  }
}
```

Or use the `/mcp` slash command inside a Claude Code session.

### Codex CLI

Add to `~/.codex/config.toml`:
```toml
[[mcp_servers]]
name = "jira"
command = "npx"
args = ["-y", "@modelcontextprotocol/server-jira"]

[mcp_servers.env]
JIRA_URL = "https://your-org.atlassian.net"
JIRA_EMAIL = "you@example.com"
JIRA_API_TOKEN = "your-token"
```

### GitHub Copilot CLI

Use the `/mcp` slash command to add servers interactively, or add to `~/.copilot/mcp.json`.

---

## Security

- Store credentials in environment variables or your system keychain — **never hardcode tokens in config files**
- Use API tokens with minimum required scopes (read-only where possible)
- Review the MCP safety skill: `skills/cross-cutting/mcp-safety-review/SKILL.md`

---

## References
- [MCP specification](https://modelcontextprotocol.io)
- [Anthropic MCP servers](https://github.com/anthropics/anthropic-mcp-servers)
- [MCP server registry](https://mcp.so)
