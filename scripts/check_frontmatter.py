"""Fail if a generated file's YAML frontmatter is missing or doesn't parse."""
import sys

import yaml

REQUIRED = {
    "trump.md": {"name": "trump", "keep-coding-instructions": True},
    "trump-style.mdc": {"alwaysApply": True},
}

failed = False
for path in sys.argv[1:]:
    text = open(path, encoding="utf-8").read()
    if not text.startswith("---\n"):
        print(f"{path}: no frontmatter")
        failed = True
        continue
    meta = yaml.safe_load(text.split("---\n", 2)[1])
    if not isinstance(meta, dict) or not meta.get("description"):
        print(f"{path}: frontmatter has no description")
        failed = True
        continue
    for key, want in REQUIRED.get(path.rsplit("/", 1)[-1], {}).items():
        if meta.get(key) != want:
            print(f"{path}: expected {key}={want!r}, got {meta.get(key)!r}")
            failed = True
    if not failed:
        print(f"{path}: ok")

sys.exit(1 if failed else 0)
