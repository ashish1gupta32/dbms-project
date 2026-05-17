#!/usr/bin/env bash
# =============================================================================
# wiki-update.sh — Sarika Silk House LLM Wiki Helper
#
# Usage:
#   ./scripts/wiki-update.sh            → show help menu
#   ./scripts/wiki-update.sh ingest     → prompt to ingest a source file
#   ./scripts/wiki-update.sh query      → print query workflow prompt
#   ./scripts/wiki-update.sh lint       → run automated wiki health checks
#   ./scripts/wiki-update.sh log        → show recent log entries
#   ./scripts/wiki-update.sh status     → show wiki file count by category
# =============================================================================

set -e

WIKI_DIR="$(cd "$(dirname "$0")/.." && pwd)/wiki"
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)/src"
TODAY=$(date +%Y-%m-%d)

# Colors
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║     Sarika Silk House — LLM Wiki Manager        ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_help() {
    print_header
    echo -e "${BOLD}Commands:${NC}"
    echo -e "  ${GREEN}ingest${NC}   — Generate a prompt to ingest a source file into the wiki"
    echo -e "  ${GREEN}query${NC}    — Generate a prompt for asking questions against the wiki"
    echo -e "  ${GREEN}lint${NC}     — Run automated wiki health checks"
    echo -e "  ${GREEN}log${NC}      — Show last 10 wiki log entries"
    echo -e "  ${GREEN}status${NC}   — Show wiki page counts by category"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo -e "  ./scripts/wiki-update.sh ingest"
    echo -e "  ./scripts/wiki-update.sh lint"
    echo -e "  ./scripts/wiki-update.sh log"
    echo ""
}

cmd_log() {
    print_header
    echo -e "${BOLD}Recent Wiki Operations (last 10):${NC}"
    echo "────────────────────────────────────────────"
    if [ -f "$WIKI_DIR/log.md" ]; then
        grep "^## \[" "$WIKI_DIR/log.md" | tail -10
    else
        echo -e "${RED}ERROR: wiki/log.md not found.${NC}"
    fi
    echo ""
}

cmd_status() {
    print_header
    echo -e "${BOLD}Wiki Status — $(date)${NC}"
    echo "────────────────────────────────────────────"

    count_pages() {
        local dir="$WIKI_DIR/$1"
        if [ -d "$dir" ]; then
            find "$dir" -name "*.md" | wc -l | tr -d ' '
        else
            echo "0"
        fi
    }

    echo -e "  ${CYAN}entities/${NC}    $(count_pages entities) pages"
    echo -e "  ${CYAN}concepts/${NC}    $(count_pages concepts) pages"
    echo -e "  ${CYAN}endpoints/${NC}   $(count_pages endpoints) pages"
    echo -e "  ${CYAN}sources/${NC}     $(count_pages sources) pages"
    echo -e "  ${CYAN}synthesis/${NC}   $(count_pages synthesis) pages"
    echo -e "  ${CYAN}root/${NC}        $(find "$WIKI_DIR" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ') pages (index, log, overview)"
    echo ""

    TOTAL=$(find "$WIKI_DIR" -name "*.md" | wc -l | tr -d ' ')
    echo -e "${BOLD}  Total: ${GREEN}$TOTAL wiki pages${NC}"
    echo ""
}

cmd_ingest() {
    print_header
    echo -e "${BOLD}INGEST — Add a Source File to the Wiki${NC}"
    echo "────────────────────────────────────────────"
    echo ""
    echo -e "${YELLOW}Available source files to ingest:${NC}"
    echo ""

    # List Java source files
    echo "  [Java Controllers]"
    find "$SRC_DIR" -name "*Controller*.java" -o -name "*controller*.java" 2>/dev/null | \
        sed "s|$SRC_DIR/||" | sort | while read f; do echo "    src/$f"; done

    echo ""
    echo "  [Java DAO Files]"
    find "$SRC_DIR" -path "*/dao/*.java" 2>/dev/null | \
        sed "s|$SRC_DIR/||" | sort | while read f; do echo "    src/$f"; done

    echo ""
    echo "  [Java Model Files]"
    find "$SRC_DIR" -path "*/model/*.java" 2>/dev/null | \
        sed "s|$SRC_DIR/||" | sort | while read f; do echo "    src/$f"; done

    echo ""
    echo "  [Config & Resources]"
    echo "    src/main/resources/schema.sql"
    echo "    src/main/resources/application.properties"
    echo "    src/main/java/com/sarika/silkhouse/config/WebSecurityConfig.java"

    echo ""
    echo "────────────────────────────────────────────"
    echo -e "${BOLD}Copy this prompt to your LLM agent:${NC}"
    echo ""
    cat << 'PROMPT'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
INGEST OPERATION

Please ingest the following source file into the project wiki.
Follow the INGEST workflow in AGENTS.md exactly:

1. Read wiki/index.md first (understand current wiki state)
2. Read wiki/log.md (last 10 entries: grep "^## \[" wiki/log.md | tail -10)
3. Read the source file fully
4. Discuss key takeaways
5. Create/update wiki/sources/<FileName>.md
6. Update relevant wiki/entities/ pages
7. Update relevant wiki/concepts/ pages
8. Update relevant wiki/endpoints/ pages
9. Update wiki/index.md
10. Append entry to wiki/log.md

Source file to ingest: [PASTE FILE PATH HERE]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROMPT
    echo ""
}

cmd_query() {
    print_header
    echo -e "${BOLD}QUERY — Ask a Question Against the Wiki${NC}"
    echo "────────────────────────────────────────────"
    echo ""
    echo -e "${BOLD}Copy this prompt to your LLM agent:${NC}"
    echo ""
    cat << 'PROMPT'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUERY OPERATION

Follow the QUERY workflow in AGENTS.md:

1. Read wiki/index.md first — identify the 3-5 most relevant pages
2. Read those pages in full
3. Synthesize an answer with citations (e.g., [Cart entity](entities/Cart.md))
4. If the answer reveals a valuable insight, file it as a new page
   in wiki/synthesis/ or update an existing synthesis page
5. Append a query entry to wiki/log.md

Question: [PASTE YOUR QUESTION HERE]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROMPT
    echo ""
}

cmd_lint() {
    print_header
    echo -e "${BOLD}LINT — Wiki Health Check (${TODAY})${NC}"
    echo "────────────────────────────────────────────"
    ERRORS=0
    WARNINGS=0
    SUGGESTIONS=0

    # --- Check 1: All wiki pages listed in index.md ---
    echo ""
    echo -e "${BOLD}[1] Checking for orphan pages (exist but not in index.md)...${NC}"
    while IFS= read -r page; do
        rel="${page#$WIKI_DIR/}"
        if ! grep -q "$rel" "$WIKI_DIR/index.md" 2>/dev/null; then
            echo -e "  ${RED}[ERROR]${NC} Orphan page not in index.md: $rel"
            ERRORS=$((ERRORS + 1))
        fi
    done < <(find "$WIKI_DIR" -name "*.md" ! -name "index.md" ! -name "log.md")

    # --- Check 2: Links in index.md point to real files ---
    echo ""
    echo -e "${BOLD}[2] Checking for broken links in index.md...${NC}"
    grep -oP '\]\(\K[^)]+(?=\))' "$WIKI_DIR/index.md" 2>/dev/null | while read -r link; do
        # skip external links
        if [[ "$link" != http* ]]; then
            target="$WIKI_DIR/$link"
            if [ ! -f "$target" ]; then
                echo -e "  ${RED}[ERROR]${NC} Broken link in index.md: $link"
                ERRORS=$((ERRORS + 1))
            fi
        fi
    done

    # --- Check 3: Entity pages link to data-access-layer.md ---
    echo ""
    echo -e "${BOLD}[3] Checking entity pages link to data-access-layer...${NC}"
    while IFS= read -r entity_page; do
        if ! grep -q "data-access-layer" "$entity_page" 2>/dev/null; then
            echo -e "  ${YELLOW}[WARNING]${NC} Entity page missing DAO link: $(basename "$entity_page")"
            WARNINGS=$((WARNINGS + 1))
        fi
    done < <(find "$WIKI_DIR/entities" -name "*.md" -type f)

    # --- Check 4: Endpoint pages have entity links ---
    echo ""
    echo -e "${BOLD}[4] Checking endpoint pages link to entities...${NC}"
    while IFS= read -r ep_page; do
        if ! grep -q "entities/" "$ep_page" 2>/dev/null; then
            echo -e "  ${YELLOW}[WARNING]${NC} Endpoint page missing entity link: $(basename "$ep_page")"
            WARNINGS=$((WARNINGS + 1))
        fi
    done < <(find "$WIKI_DIR/endpoints" -name "*.md" -type f)

    # --- Check 5: Frontmatter present on all pages ---
    echo ""
    echo -e "${BOLD}[5] Checking frontmatter on all wiki pages...${NC}"
    while IFS= read -r page; do
        first_line=$(head -1 "$page" 2>/dev/null)
        if [ "$first_line" != "---" ]; then
            echo -e "  ${YELLOW}[WARNING]${NC} Missing YAML frontmatter: ${page#$WIKI_DIR/}"
            WARNINGS=$((WARNINGS + 1))
        fi
    done < <(find "$WIKI_DIR" -name "*.md" ! -name "log.md" -type f)

    # --- Check 6: log.md is append-only (no edits to past entries) ---
    echo ""
    echo -e "${BOLD}[6] Checking log.md exists and has entries...${NC}"
    if [ ! -f "$WIKI_DIR/log.md" ]; then
        echo -e "  ${RED}[ERROR]${NC} wiki/log.md is missing!"
        ERRORS=$((ERRORS + 1))
    else
        LOG_COUNT=$(grep -c "^## \[" "$WIKI_DIR/log.md" 2>/dev/null || echo 0)
        echo -e "  ${GREEN}[OK]${NC} log.md has $LOG_COUNT entries"
    fi

    # --- Check 7: Suggest pages for unlinked controllers ---
    echo ""
    echo -e "${BOLD}[7] Checking for controllers without source summary pages...${NC}"
    for java_file in "$SRC_DIR/main/java/com/sarika/silkhouse/"*Controller*.java; do
        base=$(basename "$java_file" .java)
        wiki_page="$WIKI_DIR/sources/${base}.md"
        if [ ! -f "$wiki_page" ]; then
            echo -e "  ${CYAN}[SUGGESTION]${NC} No source page for: $base → create wiki/sources/${base}.md"
            SUGGESTIONS=$((SUGGESTIONS + 1))
        fi
    done

    # --- Summary ---
    echo ""
    echo "────────────────────────────────────────────"
    echo -e "${BOLD}Lint Summary:${NC}"
    echo -e "  ${RED}Errors:${NC}      $ERRORS"
    echo -e "  ${YELLOW}Warnings:${NC}    $WARNINGS"
    echo -e "  ${CYAN}Suggestions:${NC} $SUGGESTIONS"
    echo ""

    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        echo -e "  ${GREEN}✓ Wiki is healthy!${NC}"
    else
        echo -e "  Run the LLM LINT workflow (see AGENTS.md §6.3) to fix issues."
        echo ""
        echo -e "${BOLD}Copy this prompt to your LLM agent for full lint:${NC}"
        cat << 'PROMPT'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
LINT OPERATION

Please health-check the wiki. Follow the LINT workflow in AGENTS.md §6.3.

Check for: orphan pages, broken index links, missing DAO cross-references,
stale claims, contradictions between pages, concepts without pages,
log entries referencing missing files.

File a lint report as: wiki/synthesis/lint-report-<TODAY>.md
Append the lint entry to wiki/log.md.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROMPT
    fi
    echo ""
}

# ── Main dispatcher ──────────────────────────────────────────────
case "${1:-help}" in
    ingest)  cmd_ingest ;;
    query)   cmd_query ;;
    lint)    cmd_lint ;;
    log)     cmd_log ;;
    status)  cmd_status ;;
    help|--help|-h) print_help ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        print_help
        exit 1
        ;;
esac
