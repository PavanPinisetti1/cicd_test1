import os
import sys
import subprocess
from pathlib import Path

def run(cmd, cwd=None, check=True, capture_output=False):
    """Run a shell command with optional output capture and error handling."""
    kwargs = {
        "cwd": cwd,
        "shell": isinstance(cmd, str),
        "check": check,
        "text": True,
    }
    if capture_output:
        kwargs["stdout"] = subprocess.PIPE
        kwargs["stderr"] = subprocess.PIPE
    try:
        return subprocess.run(cmd, **kwargs)
    except subprocess.CalledProcessError as e:
        if capture_output:
            print(e.stdout or "", end="")
            print(e.stderr or "", end="", file=sys.stderr)
        raise

def ensure_repo():
    # Sanity check: are we in a git repo?
    try:
        run(["git", "rev-parse", "--is-inside-work-tree"], check=True)
    except subprocess.CalledProcessError:
        print("Error: Not inside a Git repository. Run this script at the repo root.")
        sys.exit(1)

def sanitize_branch_name(name: str) -> str:
    # Safe-ish file-friendly representation
    return name.replace("/", "_").replace("\\", "_").replace("..", "_")

def main():
    ensure_repo()

    try:
        updated_branch = input("Enter updated branch (new version): ").strip()
        old_branch = input("Enter old branch (previous version): ").strip()
        if not updated_branch or not old_branch:
            print("Both branch names are required.")
            sys.exit(1)

        # Switch to the updated branch
        run(["git", "checkout", updated_branch])

        # Ensure old branch is available locally (fetch, checkout old, return to updated)
        run(["git", "fetch", "origin"])
        run(["git", "checkout", old_branch])
        run(["git", "checkout", updated_branch])

        # Make reports folder cross-platform
        reports_dir = Path("reports")
        reports_dir.mkdir(parents=True, exist_ok=True)

        # Filenames (match the style in your SQLcl script)
        old_s = sanitize_branch_name(old_branch)
        upd_s = sanitize_branch_name(updated_branch)

        files_changed_path = reports_dir / f"files_changed_{old_s}_to_{upd_s}.txt"
        summary_path = reports_dir / f"summary_{old_s}_to_{upd_s}.txt"
        patch_path = reports_dir / f"diff_{old_s}_to_{upd_s}.patch"

        # Generate reports
        with files_changed_path.open("w", encoding="utf-8") as f:
            p = run(["git", "diff", "--name-only", f"{old_branch}..{updated_branch}"],
                    capture_output=True)
            f.write(p.stdout or "")

        with summary_path.open("w", encoding="utf-8") as f:
            p = run(["git", "diff", "--stat", f"{old_branch}..{updated_branch}"],
                    capture_output=True)
            f.write(p.stdout or "")

        with patch_path.open("w", encoding="utf-8") as f:
            p = run(["git", "diff", f"{old_branch}..{updated_branch}"],
                    capture_output=True)
            f.write(p.stdout or "")

        # Stage and commit the reports
        run(["git", "add", str(files_changed_path), str(summary_path), str(patch_path)], check=True)

        # Commit message mirrors your original
        commit_msg = f"Add human-readable diffs: {old_branch} → {updated_branch}"
        # If nothing to commit, 'git commit' exits with non-zero; handle gracefully
        try:
            run(["git", "commit", "-m", commit_msg], check=True)
            print("Reports committed successfully.")
        except subprocess.CalledProcessError:
            print("No changes to commit (reports unchanged).")

        print("Done.")
        print(f"- {files_changed_path}")
        print(f"- {summary_path}")
        print(f"- {patch_path}")

    except KeyboardInterrupt:
        print("\nAborted by user.")
        sys.exit(1)

if __name__ == "__main__":
    main()
