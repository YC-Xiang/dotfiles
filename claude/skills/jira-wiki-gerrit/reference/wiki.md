# Wiki Skill

## Overview
A Confluence/Wiki specialist optimized for discovering, reading, and synthesizing documentation while maintaining precise source integrity via absolute URL citations.

## When to Use
- **Discovery**: Use when you need to understand the hierarchy or structure of a Wiki space.
- **Searching**: Use when the exact page location is unknown and CQL search is required.
- **Synthesizing**: Use when a request requires information from multiple pages or spaces.
- **Reporting**: Use when findings must be cited with absolute URLs.

**When NOT to Use:**
- When the user provides a direct file path (use file tools).
- When the information is purely external (use search_web).

## Core Pattern: Discover, Search & Link
1. **Site Selection**: Identify which site owns the target space from the Execution Parameters below, then pass that `site_id` via the `site` parameter on every tool call.
2. **Explore Space Structure**: Start by calling `confluence_get_space_page_tree` if you need to understand the space layout or find relevant sub-pages.
3. **Search & Retrieve**: Use `confluence_search` for keywords and `confluence_get_page` for full content.
4. **Pre-Update: Fetch Raw Storage**: Before updating any page, call `confluence_get_content(content_id=..., body_mode='storage')` to obtain the full Confluence storage XML. Use this as the base for your edit — append or modify only the necessary nodes, then submit with `content_format='storage'`. If the page was already overwritten incorrectly, recover the original via `confluence_get_page_history(version=N)`.

  > **Note**: Pages containing `<ac:structured-macro>` with `<ac:plain-text-body><![CDATA[...]]>` blocks must have those blocks preserved verbatim. Never truncate or escape CDATA content.
5. **Citing**: Every claim MUST include a reference tag: `(Reference: [Title]({base_url}{url}))`. Use the base URL of the site that owns the space (see Execution Parameters below).

## Implementation Example
**User**: "Can you find the 'Phase 1' specs in the PCIPC space and tell me the deadline?"
**Agent Thought**: "I'll first check the structure of the PCIPC space to locate the 'Phase 1' documents."
1. Check Execution Parameters: PCIPC is in site `default`, base URL is `https://wiki.example.com`.
2. Call `confluence_get_space_page_tree(space_key='PCIPC', site='default')` -> returns a tree showing `Docs > Specs > Phase 1 (ID: 456)`
3. Call `confluence_get_page(page_id=456, site='default')` -> returns `url: "/display/PCIPC/Phase+1"`, `content: "Deadline: June 20th"`
**Agent Output**: "The deadline for Phase 1 is June 20th (Reference: [Phase 1](https://wiki.example.com/display/PCIPC/Phase+1))"

## Quick Reference
| Tool                             | Key Parameter       | Purpose                                                      |
| -------------------------------- | ------------------- | ------------------------------------------------------------ |
| `confluence_get_space_page_tree` | `space_key`         | Explore page hierarchy and find parent/child relationships.  |
| `confluence_search`              | `cql`               | Search for keywords across pages.                            |
| `confluence_get_page`            | `page_id`           | Retrieve full content and relative URL.                      |
| `confluence_get_content`         | `body_mode=storage` | Retrieve raw storage XML before any update to preserve images, attachments, and macros. |

## Compliance & Security
- **Use `site` Param**: When a tool exposes a `site` parameter, you MUST pass the `site_id` of the site that owns the space you are querying. Each tool call targets exactly one site — passing the wrong site_id or omitting it will query the wrong instance. Use the Execution Parameters below to determine which site_id to use for a given space.

## Common Mistakes
- **Skipping Discovery**: Trying to search broad keywords without understanding the space structure first.
- **Missing Source Tags**: Failing to include the `(Reference: ...)` tag for every claim.
- **Overwriting with Markdown Format**: Using `content_format=markdown` when updating a page that contains images, attachments, or macros. Markdown conversion silently drops all non-text elements.
- **Updating Without Fetching Storage First**: Reconstructing page content from the markdown-rendered view instead of the raw storage XML. Always call `confluence_get_content` with `body_mode=storage` before any update.

## Red Flags - STOP and Correct
- Using relative links instead of absolute URLs constructed with `base_url`.
- Overwhelming the user with search results without first checking the page tree for context.
- Calling `confluence_update_page` or `confluence_update_content` with `content_format=markdown` on a page that was not originally plain text — this will destroy images, attachments, and macros.
- Basing an update on the markdown-converted content instead of the raw `body.storage` XML.

## Execution Parameters
### Site: `default`
- MCP Tool URL (internal, used by tools): `https://devops.realtek.com/wiki`
- Citation URL (user-facing links): `https://wiki.realtek.com`
- Build user-facing links as: `https://wiki.realtek.com` + relative path returned by tools (e.g. `/display/PCDV/PageTitle`)
- Authorized Spaces:
  - `PCIPC`
  - `PCIC`
  - `PCDV`
  - `PCFW`
  - `PCHW`
  - `PCSW`
