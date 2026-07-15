#!/usr/bin/env python3
"""Extract the LeetCode session cookie from Firefox's cookie store.

leetcode.nvim only supports manual cookie paste; this lets the editor pull the
cookie straight from Firefox instead. It scans every Firefox profile, finds the
`LEETCODE_SESSION` + `csrftoken` cookies for the requested LeetCode domain, and
prints them on stdout in the exact form the plugin's Cookie.parse() expects:

    csrftoken=<value>; LEETCODE_SESSION=<value>

Firefox keeps cookies.sqlite locked (WAL mode) while running, so we copy the db
(plus -wal/-shm) to a temp dir and read the copy. Exit code is non-zero with a
human message on stderr when the cookies can't be found.

Usage: firefox_leetcode_cookie.py [--cn]   (--cn => leetcode.cn instead of .com)
"""

import configparser
import glob
import os
import shutil
import sqlite3
import sys
import tempfile

FF_DIR = os.path.expanduser("~/.mozilla/firefox")


def default_profile_path():
    """Profile marked Default in profiles.ini, if any (preferred when found)."""
    ini = os.path.join(FF_DIR, "profiles.ini")
    if not os.path.exists(ini):
        return None
    cp = configparser.ConfigParser()
    try:
        cp.read(ini)
    except configparser.Error:
        return None
    for sect in cp.sections():
        if cp.has_option(sect, "Default") and cp.has_option(sect, "Path"):
            # [Install...] section points at the active default profile.
            return os.path.join(FF_DIR, cp.get(sect, "Path"))
    return None


def read_cookies(db, domain):
    """Return {name: value} for LeetCode auth cookies in one cookies.sqlite."""
    tmp = tempfile.mkdtemp(prefix="lc-ff-")
    dst = os.path.join(tmp, "cookies.sqlite")
    try:
        shutil.copy(db, dst)
        for ext in ("-wal", "-shm"):
            if os.path.exists(db + ext):
                shutil.copy(db + ext, dst + ext)
        con = sqlite3.connect(dst)
        # Newest expiry first so an active session wins over a stale duplicate.
        rows = con.execute(
            "SELECT name, value FROM moz_cookies "
            "WHERE host LIKE ? AND name IN ('LEETCODE_SESSION', 'csrftoken') "
            "ORDER BY expiry DESC",
            ("%" + domain,),
        ).fetchall()
        con.close()
    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    out = {}
    for name, value in rows:
        if value and name not in out:  # first (newest) wins
            out[name] = value
    return out


def main():
    domain = "leetcode.cn" if "--cn" in sys.argv[1:] else "leetcode.com"

    # Search the default profile first, then every other profile.
    profiles = []
    default = default_profile_path()
    if default:
        profiles.append(os.path.join(default, "cookies.sqlite"))
    profiles += sorted(glob.glob(os.path.join(FF_DIR, "*", "cookies.sqlite")))

    seen = set()
    for db in profiles:
        if db in seen or not os.path.exists(db):
            continue
        seen.add(db)
        try:
            ck = read_cookies(db, domain)
        except sqlite3.Error as e:
            print(f"warning: could not read {db}: {e}", file=sys.stderr)
            continue
        if "LEETCODE_SESSION" in ck and "csrftoken" in ck:
            print(f"csrftoken={ck['csrftoken']}; LEETCODE_SESSION={ck['LEETCODE_SESSION']}")
            return 0

    print(
        f"No {domain} session found in Firefox. "
        f"Log in at https://{domain} in Firefox first, then try again.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    sys.exit(main())
