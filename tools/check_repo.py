#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
"""check_repo.py -- text hygiene and book-listing checks for the repo.

1. Every tracked text file: ASCII only, LF line ends, no TABs, no
   trailing spaces, ends with a newline. Code files: at most 100
   columns. Files under book/listings/: at most 72 columns (the
   book's printed limit; 64 inside callouts is checked by the book).
2. book/listings/chNN/INDEX.csv: every listing exported from the
   manuscript that names a repository file (library_path) must be
   byte-identical to that file, so the book prints the real code.
Exit 1 on any problem.
"""
import csv
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
CODE = {'.sv', '.svh', '.xdc', '.tcl', '.sh', '.py', '.yml', '.lock',
        '.flags', '.mk'}
TEXT = CODE | {'.md', '.csv', '.txt', ''}


def tracked() -> list[pathlib.Path]:
    out = subprocess.run(['git', 'ls-files', '-z'], cwd=ROOT, check=True,
                         capture_output=True).stdout
    return [ROOT / p for p in out.decode().split('\0') if p]


def hygiene(path: pathlib.Path, problems: list[str]) -> None:
    rel = path.relative_to(ROOT).as_posix()
    data = path.read_bytes()
    # Licence texts are kept exactly as published (CC BY 4.0 has a
    # few non-ASCII characters).
    if any(b > 127 for b in data) and not rel.startswith('LICENSES/'):
        problems.append(f'{rel}: non-ASCII byte')
    if b'\r' in data:
        problems.append(f'{rel}: CR line ending')
    if b'\t' in data:
        problems.append(f'{rel}: TAB character')
    if data and not data.endswith(b'\n'):
        problems.append(f'{rel}: no newline at end of file')
    limit = 72 if rel.startswith('book/listings/') else (
        100 if path.suffix in CODE else None)
    for n, line in enumerate(data.split(b'\n'), 1):
        if line.endswith(b' '):
            problems.append(f'{rel}:{n}: trailing space')
        if limit and len(line) > limit:
            problems.append(f'{rel}:{n}: {len(line)} columns (max {limit})')


def listings(problems: list[str]) -> int:
    count = 0
    for index in sorted(ROOT.glob('book/listings/ch*/INDEX.csv')):
        with index.open(newline='') as fh:
            for row in csv.DictReader(fh):
                exported = ROOT / row['repo_export_path']
                if not exported.is_file():
                    problems.append(f'{index}: missing {exported}')
                    continue
                source = row['library_path']
                if not source:
                    continue
                count += 1
                if exported.read_bytes() != (ROOT / source).read_bytes():
                    problems.append(f'Listing {row["listing"]}: '
                                    f'{row["repo_export_path"]} differs '
                                    f'from {source}')
    return count


def main() -> int:
    problems: list[str] = []
    files = [p for p in tracked()
             if p.is_file() and (p.suffix in TEXT or p.name == 'LICENSE')]
    for path in files:
        hygiene(path, problems)
    n = listings(problems)
    for p in problems:
        print('FAIL', p)
    print(f'check_repo: {len(files)} text files, {n} book listings '
          f'compared byte for byte: '
          f'{"FAIL" if problems else "PASS"}')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
