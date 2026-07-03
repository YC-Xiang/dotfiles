---
name: git-commit
description: Analyze the currently staged git diff and generate a Conventional Commits compliant commit message, then commit.
allowed-tools: Bash(git *)
---

# Git Commit Message Generation Skill

Generate a well-formed commit following Conventional Commits based on the changes currently added to the
git staging area.

The user-provided JIRA issue ID (if any) is: $ARGUMENTS

## Steps

### 1. Check staged changes

Run:

```bash
git diff --cached --stat
```

If the output is empty, tell the user: "No staged changes detected. Please run git add first." Then stop.

### 2. Collect change context

Run:

```bash
git diff --cached
```

Carefully analyze the diff to understand:

The affected module/component (used to infer the scope)
The nature of the change (feature / fix / refactor / docs, etc., used to infer the type)
The purpose and impact of the change (used to write the body)

### 3. Generate the commit message

Strictly follow this format:

```bash
<type>[optional scope]: <description>

[optional body]

[JIRA-ID]
```

Field rules:

- type: Must be one of: feat fix docs style refactor perf test build ci chore revert
- scope: Optional, wrapped in parentheses, reflects the affected module (e.g. cif, isp, lcdc), inferred from the diff path/content
- description: Imperative mood, lowercase first letter, no trailing period, header line <= 50 characters
- body: Explain what changed, why, and the impact; each line <= 72 characters; may span multiple lines
- JIRA-ID: If a JIRA issue ID was provided in $ARGUMENTS, place it on its own line after the body, separated by a blank line. If $ARGUMENTS is empty, omit the JIRA-ID line.

### 4. Commit

Commit using a heredoc so the full generated message is passed correctly:

```bash
git commit -s -F - <<'EOF'
<type>(scope): <description>

<body>

<JIRA-ID>
EOF
```

Then run the following command and show its raw output to the user inside a
fenced code block.

```bash
git log -1
```

### 5. Check JIRA-ID

If $ARGUMENTS is empty (i.e. the user did not provide a JIRA issue ID), after
showing the commit, explicitly ask the user:

"⚠️ No JIRA-ID was provided. Did you forget to add one? If needed, you can amend
the commit with git commit --amend."

If $ARGUMENTS is NOT empty, skip this step.
