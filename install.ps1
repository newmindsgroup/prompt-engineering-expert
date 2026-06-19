# Install prompt-engineering-expert across whatever AI IDEs/CLIs are present (Windows / PowerShell).
#
# The portable Agent Skill (skill/SKILL.md) is the unit of capability and is installed
# into every detected skills directory. Native on-demand adapters (Claude agent +
# command, Codex prompt) are installed where they apply.
#
# Usage:
#   ./install.ps1                  # auto-detect + install user-global
#   ./install.ps1 -Cursor PATH     # also install the Cursor rule into PATH\.cursor\rules
#   ./install.ps1 -DryRun          # show what would happen, change nothing
[CmdletBinding()]
param(
  [switch]$DryRun,
  [string]$Cursor = ""
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Name = "prompt-engineering-expert"

function Say($m) { Write-Host $m }
function Ensure-Dir($d) { if ($DryRun) { Say "  (dry-run) mkdir $d" } else { New-Item -ItemType Directory -Force -Path $d | Out-Null } }
function Copy-It($src, $dst) { if ($DryRun) { Say "  (dry-run) copy $src -> $dst" } else { Copy-Item -Force -Path $src -Destination $dst } }

function Install-Skill($skillsDir) {
  Ensure-Dir (Join-Path $skillsDir "$Name\references")
  Copy-It (Join-Path $Root "skill\SKILL.md") (Join-Path $skillsDir "$Name\SKILL.md")
  Copy-It (Join-Path $Root "skill\references\blueprint.md") (Join-Path $skillsDir "$Name\references\blueprint.md")
  Copy-It (Join-Path $Root "skill\references\model-guide.md") (Join-Path $skillsDir "$Name\references\model-guide.md")
  Say "  [ok] skill -> $skillsDir\$Name\"
}

Say "Installing $Name ..."
if ($DryRun) { Say "(dry-run: nothing will be written)" }

# --- Claude Code ---
if ((Get-Command claude -ErrorAction SilentlyContinue) -or (Test-Path "$HOME\.claude")) {
  Say "* Claude Code detected"
  Install-Skill "$HOME\.claude\skills"
  Ensure-Dir "$HOME\.claude\agents"; Ensure-Dir "$HOME\.claude\commands"
  Copy-It (Join-Path $Root "claude-code\agents\$Name.md") "$HOME\.claude\agents\$Name.md"
  Copy-It (Join-Path $Root "claude-code\commands\$Name.md") "$HOME\.claude\commands\$Name.md"
  Say "  [ok] agent + /$Name command"
}

# --- Codex ---
if ((Get-Command codex -ErrorAction SilentlyContinue) -or (Test-Path "$HOME\.codex")) {
  Say "* Codex detected"
  Install-Skill "$HOME\.codex\skills"
  Ensure-Dir "$HOME\.codex\prompts"
  Copy-It (Join-Path $Root "codex\prompts\$Name.md") "$HOME\.codex\prompts\$Name.md"
  Say "  [ok] prompt -> ~\.codex\prompts\$Name.md (use /$Name)"
}

# --- Cross-runtime skills dir (Gemini CLI, Antigravity, Copilot CLI) ---
if ((Test-Path "$HOME\.gemini") -or (Test-Path "$HOME\.agents") -or (Get-Command gemini -ErrorAction SilentlyContinue)) {
  Say "* Gemini/Antigravity (cross-runtime) detected"
  Install-Skill "$HOME\.agents\skills"
}

# --- Cursor (project-level) ---
if ($Cursor -ne "") {
  Say "* Cursor: installing project rule into $Cursor\.cursor\rules"
  Ensure-Dir "$Cursor\.cursor\rules"
  Copy-It (Join-Path $Root "cursor\$Name.mdc") "$Cursor\.cursor\rules\$Name.mdc"
  Say "  [ok] rule -> $Cursor\.cursor\rules\$Name.mdc"
} else {
  Say "* Cursor: rules are per-project. To install into a project, run:"
  Say "    ./install.ps1 -Cursor C:\path\to\your\project"
}

Say ""
Say "Done. Restart your IDE/CLI session so it picks up the new skill."
