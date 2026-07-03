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

## Shared conventions

- **Source tag every claim.** The exact tag differs per tool — Jira:
  `(Reference: [PROJ-123](url))`, Wiki: `(Reference: [Title](url))`, Gerrit:
  `(Source: Codebase)`. See each file for the precise format.
- **Pick the right site.** Jira and Wiki tools are multi-site — always pass the
  owning `site_id` via the `site` parameter. Gerrit tools use `gerrit_base_url`.
- **Cite with absolute URLs** built from each system's base URL (below).
- **Respect access control.** Only the authorized projects/spaces listed in each
  detail file are in scope. Never run global/unscoped queries.

## Cross-tool workflows

The reason this umbrella exists — these systems reference each other:

1. **Ticket → code.** Given a Jira ticket, find implementing CLs with Gerrit
   `query_changes` using the ticket key as a message substring; confirm the link
   with `get_bugs_from_cl`.
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
