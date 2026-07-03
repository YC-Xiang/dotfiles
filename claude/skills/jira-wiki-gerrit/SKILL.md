---
name: jira-wiki-gerrit
description: Realtek DevOps assistant for Jira, Confluence/Wiki, and Gerrit. Routes to jira.md, wiki.md, or gerrit.md for tool-specific rules and coordinates cross-tool workflows (tracing a Jira ticket to its Gerrit CLs and Wiki specs). Use when working with Realtek Jira tickets/epics/JQL (jira.realtek.com), Confluence/Wiki pages/spaces/CQL (wiki.realtek.com), or Gerrit changes/code/blame (pcgit2.rtkbf.com) — especially requests that span more than one of these systems.
metadata:
  version: "1.0"
---

# Realtek DevOps (Jira · Wiki · Gerrit)

Umbrella skill for Realtek's three interlinked DevOps systems. Load the matching
detail file for tool-specific rules, then apply the shared conventions below.

## Routing

| If the request involves…                                          | Read                    |
| ----------------------------------------------------------------- | ----------------------- |
| Jira tickets, epics, JQL, custom fields, Epic Links               | `reference/jira.md`     |
| Confluence/Wiki pages, spaces, CQL search, page updates           | `reference/wiki.md`     |
| Gerrit changes/CLs, code search, blame, reviews, commit messages  | `reference/gerrit.md`   |

When a request touches more than one system, read each relevant file and follow
the cross-tool workflows below.

## Tool loading

All tools behind these three systems are deferred — they exist but are not in
your default tool list until loaded. A direct call before loading fails with
`InputValidationError`; a tool missing from your visible list is **not**
evidence the system is unavailable, and is never grounds to refuse.

1. Load schemas before first use each session: `ToolSearch(query="select:<exact
   names>")`.
2. Name prefixes: Jira/Wiki tools are `mcp__mcp_atlassian__*` (e.g.
   `mcp__mcp_atlassian__jira_get_issue`, `mcp__mcp_atlassian__confluence_search`);
   Gerrit tools are `mcp__mcp_gerrit__*` (e.g. `mcp__mcp_gerrit__query_changes`).
3. Site discovery — call these when the `default` site below doesn't look right,
   or a request implies another instance: `mcp__mcp_atlassian__atlassian_list_sites`
   (Jira + Wiki), `mcp__mcp_gerrit__gerrit_list_sites` (Gerrit).

## Shared conventions

- **Source tag every claim.** The exact tag differs per tool — Jira:
  `(Reference: [PROJ-123](url))`, Wiki: `(Reference: [Title](url))`, Gerrit:
  `(Source: Codebase)`. See each file for the precise format.
- **Pick the right site.** Jira, Wiki, and Gerrit tools all accept a `site`
  parameter (Gerrit also accepts `gerrit_base_url`) — pass it explicitly. The
  `default` site listed per-system below is confirmed for Realtek's primary
  instances; if a request implies a different instance (e.g. a vendor/partner
  Jira) or `default` returns unexpected results, call `atlassian_list_sites` /
  `gerrit_list_sites` first and use the matching alias instead of guessing.
- **Cite with absolute URLs** built from each system's base URL (below).
- **Respect access control.** Only the authorized projects/spaces listed in each
  detail file are in scope. Never run global/unscoped queries.

## Cross-tool workflows

The reason this umbrella exists — these systems reference each other:

1. **Ticket → code.** Given a Jira ticket, find implementing CLs with
   `query_changes_by_date_and_filters` (`message_substring` = ticket key), or
   `query_changes` with a query like `message:"PROJ-123"`; confirm the link with
   `get_bugs_from_cl`.
2. **CL → ticket.** Given a Gerrit CL, extract Jira bug IDs via `get_bugs_from_cl`,
   then `jira_get_issue` for status and details.
3. **Ticket/CL → spec.** Feature specs live in Wiki. Search the matching space —
   project namespaces align across systems (e.g. `PCIPC` is both a Jira project
   and a Wiki space).
4. **Synthesis.** For requests like "status of feature X", gather from each system
   and cite each finding with its own source tag.

## Systems at a glance

| System | MCP Tool URL (internal)                  | Citation URL (user-facing)       | Site      |
| ------ | ---------------------------------------- | -------------------------------- | --------- |
| Jira   | `https://devops.realtek.com/jira`        | `https://jira.realtek.com`       | `default` |
| Wiki   | `https://devops.realtek.com/wiki`        | `https://wiki.realtek.com`       | `default` |
| Gerrit | `https://pcgit2.rtkbf.com/gerrit`        | `https://pcgit2.rtkbf.com/gerrit`| `default` |
