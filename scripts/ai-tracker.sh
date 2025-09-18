#!/bin/bash
# AI Commit Statistics for Branches and Tags

show_help() {
    echo "🤖 AI Commit Tracker"
    echo "===================="
    echo "Usage: $0 [options] [branch/tag] [base_branch/previous_tag]"
    echo ""
    echo "Options:"
    echo "  -b, --branch [BRANCH]       Track AI commits in specific branch (uses current branch if not specified)"
    echo "  -t, --tag TAG [PREV_TAG]    Track AI commits in tag, optionally compare with previous tag"
    echo "  -f, --feature [BRANCH] [BASE] Track AI commits since feature branch creation (uses current branch if not specified, default base: master)"
    echo "  -c, --compare BASE FEATURE  Compare AI commits between base and feature branch"
    echo "  -a, --all-branches          Show AI stats for all branches"
    echo "  -r, --range FROM TO         Track AI commits between two commits/tags/branches"
    echo "  -h, --help                  Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 -b                                     # AI commits in current branch"
    echo "  $0 -b feature/new-login                    # AI commits in specific branch"
    echo "  $0 -f                                     # AI commits since current branch creation from master"
    echo "  $0 -f feature/new-login                    # AI commits since branch creation from master"
    echo "  $0 -f feature/new-login develop           # AI commits since branch creation from develop"
    echo "  $0 -t live-2.0.3                          # AI commits in specific tag"
    echo "  $0 -t live-2.0.3 live-2.0.2              # AI commits between two tags"
    echo "  $0 -c master feature/new-login            # Compare feature branch with master"
    echo "  $0 -r v1.0.0 v2.0.0                      # AI commits between two versions"
    echo "  $0 -a                                     # Show AI stats for all branches"
    echo ""
    echo "💡 Tips:"
    echo "  • Feature branch tracking uses git merge-base to find the exact divergence point"
    echo "  • Tag comparisons show changes between releases"
    echo "  • Use quotes for branch names with special characters: 'feature/fix-bug'"
}

track_branch() {
    local branch="$1"
    echo "📊 AI Commit Statistics for Branch: $branch"
    echo "============================================"
    
    if ! git rev-parse --verify "$branch" >/dev/null 2>&1; then
        echo "❌ Branch '$branch' not found"
        return 1
    fi
    
    total_commits=$(git rev-list --count "$branch")
    ai_commits=$(git log "$branch" --oneline --grep="\[AI\]" | wc -l)
    
    echo "Total commits: $total_commits"
    echo "AI commits: $ai_commits"
    
    if [ $total_commits -gt 0 ]; then
        percentage=$(echo "scale=2; $ai_commits * 100 / $total_commits" | bc -l 2>/dev/null || echo "0")
        echo "AI percentage: ${percentage}%"
    fi
    
    echo ""
    echo "Recent AI commits:"
    git log "$branch" --grep="\[AI\]" --oneline | head -5
}

track_tag() {
    local tag="$1"
    local previous_tag="$2"
    
    echo "📊 AI Commit Statistics for Tag: $tag"
    echo "======================================"
    
    if ! git rev-parse --verify "$tag" >/dev/null 2>&1; then
        echo "❌ Tag '$tag' not found"
        return 1
    fi
    
    # Get tag creation date
    tag_date=$(git log -1 --pretty=format:"%ad" --date=short "$tag")
    echo "📅 Tag date: $tag_date"
    
    total_commits=$(git rev-list --count "$tag")
    ai_commits=$(git log "$tag" --oneline --grep="\[AI\]" | wc -l)
    
    echo "Total commits: $total_commits"
    echo "AI commits: $ai_commits"
    
    if [ $total_commits -gt 0 ]; then
        percentage=$(echo "scale=2; $ai_commits * 100 / $total_commits" | bc -l 2>/dev/null || echo "0")
        echo "AI percentage: ${percentage}%"
    fi
    
    # If previous tag provided, show AI commits between tags
    if [ -n "$previous_tag" ] && git rev-parse --verify "$previous_tag" >/dev/null 2>&1; then
        echo ""
        echo "📊 AI commits between $previous_tag and $tag:"
        commits_between=$(git rev-list --count "$previous_tag".."$tag")
        ai_commits_between=$(git log "$previous_tag".."$tag" --oneline --grep="\[AI\]" | wc -l)
        
        echo "Commits between tags: $commits_between"
        echo "AI commits between tags: $ai_commits_between"
        
        if [ $commits_between -gt 0 ]; then
            percentage_between=$(echo "scale=2; $ai_commits_between * 100 / $commits_between" | bc -l 2>/dev/null || echo "0")
            echo "AI percentage between tags: ${percentage_between}%"
        fi
        
        echo ""
        echo "🤖 AI commits in this release:"
        git log "$previous_tag".."$tag" --grep="\[AI\]" --pretty=format:"%h - %ad - %s" --date=short
    fi
    
    echo ""
    echo "Recent AI commits in tag:"
    git log "$tag" --grep="\[AI\]" --oneline | head -5
}

track_feature_branch() {
    local feature_branch="$1"
    local base_branch="${2:-master}"
    
    echo "📊 AI Commits unique to Feature Branch: $feature_branch"
    echo "======================================================="
    echo "Base branch: $base_branch"
    echo ""
    
    if ! git rev-parse --verify "$feature_branch" >/dev/null 2>&1; then
        echo "❌ Feature branch '$feature_branch' not found"
        return 1
    fi
    
    if ! git rev-parse --verify "$base_branch" >/dev/null 2>&1; then
        echo "❌ Base branch '$base_branch' not found"
        return 1
    fi
    
    # Find the merge base (common ancestor)
    merge_base=$(git merge-base "$feature_branch" "$base_branch")
    
    if [ -z "$merge_base" ]; then
        echo "❌ No common ancestor found between branches"
        return 1
    fi
    
    echo "📍 Branch point: $(git log -1 --pretty=format:"%h - %s" "$merge_base")"
    echo "📅 Branch created: $(git log -1 --pretty=format:"%ad" --date=short "$merge_base")"
    echo ""
    
    # Get commits in feature branch since it diverged from base
    total_new_commits=$(git rev-list --count "$merge_base".."$feature_branch")
    ai_new_commits=$(git log "$merge_base".."$feature_branch" --oneline --grep="\[AI\]" | wc -l)
    
    echo "Commits since branch creation: $total_new_commits"
    echo "AI commits since branch creation: $ai_new_commits"
    
    if [ $total_new_commits -gt 0 ]; then
        percentage=$(echo "scale=2; $ai_new_commits * 100 / $total_new_commits" | bc -l 2>/dev/null || echo "0")
        echo "AI percentage in feature branch: ${percentage}%"
    fi
    
    echo ""
    echo "🤖 AI commits in feature branch (since creation):"
    git log "$merge_base".."$feature_branch" --grep="\[AI\]" --pretty=format:"%h - %ad - %s" --date=short
    
    echo ""
    echo "📈 Timeline of AI commits:"
    git log "$merge_base".."$feature_branch" --grep="\[AI\]" --pretty=format:"%ad %h %s" --date=short | sort
}

compare_branches() {
    local base_branch="$1"
    local feature_branch="$2"
    
    echo "🔍 AI Commit Comparison"
    echo "======================="
    echo "Base: $base_branch"
    echo "Feature: $feature_branch"
    echo ""
    
    echo "📊 $base_branch stats:"
    track_branch "$base_branch"
    
    echo ""
    echo "📊 $feature_branch stats:"
    track_branch "$feature_branch"
    
    echo ""
    track_feature_branch "$feature_branch" "$base_branch"
}

track_range() {
    local from_ref="$1"
    local to_ref="$2"
    
    echo "📊 AI Commits between $from_ref and $to_ref"
    echo "=========================================="
    
    if ! git rev-parse --verify "$from_ref" >/dev/null 2>&1; then
        echo "❌ Reference '$from_ref' not found"
        return 1
    fi
    
    if ! git rev-parse --verify "$to_ref" >/dev/null 2>&1; then
        echo "❌ Reference '$to_ref' not found"
        return 1
    fi
    
    # Get commits between the two references
    total_commits=$(git rev-list --count "$from_ref".."$to_ref")
    ai_commits=$(git log "$from_ref".."$to_ref" --oneline --grep="\[AI\]" | wc -l)
    
    echo "Total commits in range: $total_commits"
    echo "AI commits in range: $ai_commits"
    
    if [ $total_commits -gt 0 ]; then
        percentage=$(echo "scale=2; $ai_commits * 100 / $total_commits" | bc -l 2>/dev/null || echo "0")
        echo "AI percentage in range: ${percentage}%"
    fi
    
    echo ""
    echo "🤖 AI commits in range:"
    git log "$from_ref".."$to_ref" --grep="\[AI\]" --pretty=format:"%h - %ad - %an - %s" --date=short
    
    echo ""
    echo "📈 AI commits by date:"
    git log "$from_ref".."$to_ref" --grep="\[AI\]" --pretty=format:"%ad" --date=short | sort | uniq -c | sort -k2
}

show_all_branches() {
    echo "📊 AI Commit Statistics for All Branches"
    echo "========================================"
    
    echo "🏷️  Local branches with AI commits:"
    git for-each-ref --format='%(refname:short)' refs/heads/ | while read branch; do
        ai_count=$(git log "$branch" --oneline --grep="\[AI\]" | wc -l)
        total_count=$(git rev-list --count "$branch")
        if [ $ai_count -gt 0 ]; then
            percentage=$(echo "scale=1; $ai_count * 100 / $total_count" | bc -l 2>/dev/null || echo "0")
            last_ai_commit=$(git log "$branch" --grep="\[AI\]" --pretty=format:"%ad" --date=short -1 2>/dev/null)
            echo "$branch: $ai_count AI commits ($percentage%) - Last AI: ${last_ai_commit:-N/A}"
        fi
    done | sort -k2 -nr
    
    echo ""
    echo "🚀 Recent remote branches with AI commits:"
    git for-each-ref --format='%(refname:short)' refs/remotes/origin/ | head -20 | while read branch; do
        ai_count=$(git log "$branch" --oneline --grep="\[AI\]" | wc -l 2>/dev/null)
        if [ $ai_count -gt 0 ]; then
            last_ai_commit=$(git log "$branch" --grep="\[AI\]" --pretty=format:"%ad" --date=short -1 2>/dev/null)
            echo "$branch: $ai_count AI commits - Last AI: ${last_ai_commit:-N/A}"
        fi
    done | sort -k2 -nr | head -10
}

# Get current branch function
get_current_branch() {
    git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Main script logic
case "$1" in
    -b|--branch)
        # Use current branch if no branch specified
        branch_name="${2:-$(get_current_branch)}"
        if [ -z "$branch_name" ]; then
            echo "❌ Could not determine current branch and no branch specified"
            exit 1
        fi
        track_branch "$branch_name"
        ;;
    -t|--tag)
        track_tag "$2" "$3"
        ;;
    -f|--feature)
        # Use current branch if no branch specified
        feature_branch="${2:-$(get_current_branch)}"
        if [ -z "$feature_branch" ]; then
            echo "❌ Could not determine current branch and no branch specified"
            exit 1
        fi
        track_feature_branch "$feature_branch" "${3:-master}"
        ;;
    -c|--compare)
        compare_branches "$2" "$3"
        ;;
    -r|--range)
        track_range "$2" "$3"
        ;;
    -a|--all-branches)
        show_all_branches
        ;;
    -h|--help|"")
        show_help
        ;;
    *)
        echo "❌ Unknown option: $1"
        echo "Use -h or --help for usage information"
        exit 1
        ;;
esac
