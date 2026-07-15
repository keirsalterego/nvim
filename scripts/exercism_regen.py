#!/usr/bin/env python3
"""Regenerate ordered Exercism exercise lists for exercism.nvim.

Fetches each track from the public Exercism API and writes
<out-dir>/<track>.json sorted into the order you actually learn in:

    1. hello-world (tutorial)
    2. concept exercises, in syllabus order
    3. practice exercises, easiest first

Each entry is {name, type, difficulty} — `name`/`type` are what exercism.nvim
reads, `difficulty` is consumed by the config/exercism_order.lua picker override
to show a serial number + difficulty marker. `type` is normalised to
concept/practice so the plugin's own code paths never hit an unknown icon.

Output lives in your Neovim config (default ~/.config/nvim/exercism-data), not in
the plugin directory, so plugin updates can never clobber it.

Usage:
    exercism_regen.py [--out DIR] rust cpp python go ...
"""

import argparse
import json
import os
import sys
import urllib.error
import urllib.request

API = "https://exercism.org/api/v2/tracks/{track}/exercises"
DIFFICULTY_RANK = {"easy": 0, "medium": 1, "hard": 2}
TYPE_RANK = {"tutorial": 0, "concept": 1, "practice": 2}


def fetch(track):
    url = API.format(track=track)
    req = urllib.request.Request(url, headers={"User-Agent": "exercism.nvim-regen"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.load(resp)
    return data.get("exercises", [])


def normalise(ex):
    """API exercise -> {name, type, difficulty} with plugin-safe type."""
    api_type = ex.get("type", "practice")
    # exercism.nvim only knows concept/practice icons; fold tutorial into concept.
    plugin_type = "practice" if api_type == "practice" else "concept"
    difficulty = ex.get("difficulty") if api_type == "practice" else None
    return {
        "name": ex["slug"],
        "type": plugin_type,
        "difficulty": difficulty,
        "_api_type": api_type,  # used only for sorting; stripped before write
    }


def order(exercises):
    items = [normalise(e) for e in exercises]
    # Stable sort: group (tutorial<concept<practice); practice by difficulty.
    # enumerate index keeps the API's recommended order within each bucket.
    items = [dict(it, _i=i) for i, it in enumerate(items)]
    items.sort(
        key=lambda it: (
            TYPE_RANK.get(it["_api_type"], 9),
            DIFFICULTY_RANK.get(it["difficulty"], 9) if it["type"] == "practice" else 0,
            it["_i"],
        )
    )
    for it in items:
        it.pop("_api_type", None)
        it.pop("_i", None)
    return items


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--out",
        default=os.path.expanduser("~/.config/nvim/exercism-data"),
        help="output directory (default: ~/.config/nvim/exercism-data)",
    )
    ap.add_argument("tracks", nargs="+", help="track slugs, e.g. rust cpp python")
    args = ap.parse_args()

    os.makedirs(args.out, exist_ok=True)
    failures = 0
    for track in args.tracks:
        try:
            exercises = fetch(track)
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
            print(f"  ! {track}: fetch failed ({e}); keeping existing file", file=sys.stderr)
            failures += 1
            continue
        if not exercises:
            print(f"  ! {track}: API returned no exercises; skipping", file=sys.stderr)
            failures += 1
            continue

        items = order(exercises)
        path = os.path.join(args.out, f"{track}.json")
        with open(path, "w") as fh:
            json.dump(items, fh, indent=2)
            fh.write("\n")
        concepts = sum(1 for it in items if it["type"] == "concept")
        practice = sum(1 for it in items if it["type"] == "practice")
        print(f"  ✓ {track}: {len(items)} exercises ({concepts} concept, {practice} practice) -> {path}")

    # Exit 0 even on partial failure so a plugin update / cron never shows red;
    # failed tracks just keep their previous file. Real errors go to stderr.
    return 0 if failures == 0 else 0


if __name__ == "__main__":
    sys.exit(main())
