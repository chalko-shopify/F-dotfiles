#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys
import subprocess
import textwrap

from glob import glob

"""Tool to automatically update sub-directories listings of stow packages.
"""

COMMENT = "<!--- Tree block injection -->"


def usage():
    print("""
SYNOPSIS
    f-dotfiles.py

DESCRIPTION
    Parse content of README.md files in the repository packages and edit them
    in-place.
    Search for the sentinel "{}" and if found
    inject package tree view just after it.
    Files beginning with a comment (like "# this is a comment"), will have the
    comment appended next to their filename in the generated listing.
    """.format(COMMENT))


def make_tree(path, full=False):
    """Generate tree for path"""
    cmd = ["tree", "-I", "README.md|.stow-local-ignore|.gitignore", "-a"]
    if full:
        cmd.insert(1, "-f")
    cmd.append(os.path.basename(path))

    with subprocess.Popen(cmd, stdout=subprocess.PIPE) as s:
        tree_out = s.stdout.read().decode("utf-8")

    # Simulate `tail -n +2`: remove the first line
    lines = tree_out.split("\n")
    if len(lines) > 0:
        tree = "\n".join(lines[1:])
    else:
        tree = tree_out

    # Remove files count line at the end
    return tree.split("\n\n")[0] + "\n\n"


def format_tree(text):
    """Format tree for inclusion in markdown text"""
    return """{}
    {}

""".format(COMMENT, textwrap.indent(text, " " * 4).strip())


def extract_descriptions(root):
    """Extract descriptions in scripts headers"""
    desc = {}
    header_size = 10

    for local_root, dirnames, filenames in os.walk(root):
        for filename in filenames:
            abs_filename = os.path.join(local_root, filename)
            try:
                with open(abs_filename) as myfile:
                    try:
                        head = [next(myfile) for x in range(header_size)]
                    except StopIteration:
                        myfile.seek(0)
                        head = myfile.readlines()

                # Check for matches in the header
                search_str = f"# {filename}: "
                for line in head:
                    idx = line.find(search_str)
                    if idx != -1:
                        desc[
                            os.path.join(
                                os.path.basename(root), os.path.relpath(abs_filename, root)
                            )
                        ] = line[idx + len(search_str):].strip()
                        break # Stop after the first matching description is found
            except UnicodeDecodeError:
                pass  # binary file
    return desc


def make_tree_doc(root):
    """Append file description for each text file of tree"""
    res = []

    desc = extract_descriptions(root)
    tree = make_tree(root)
    tree_full = make_tree(root, full=True)

    for branch_full, branch in zip(tree_full.split("\n"), tree.split("\n")):
        if branch_full:
            filename = branch_full.split()[-1].strip()
            if filename in desc:
                branch += " \t# " + desc[filename]
        res.append(branch)
    return "\n".join(res)


def make_doc(sentinel=COMMENT):
    """For each package, insert the directories listing into the README.md
    by updating the block introduced by sentinel
    """
    for readme_path in [os.path.abspath(x) for x in glob("*/README.md")]:
        with open(readme_path, "r+") as readme_file:
            readme = readme_file.read()
            if sentinel in readme:
                root = os.path.dirname(readme_path)
                tree = make_tree_doc(root)
                pattern = r"{}(?:\n[ \t]+[^\n]*)*(?:\n[ \t]*)*".format(re.escape(sentinel))
                text = re.sub(pattern, format_tree(tree), readme, count=1)
                readme_file.seek(0)
                readme_file.truncate()
                readme_file.write(text)


if __name__ == "__main__":
    if "-h" in sys.argv or "--help" in sys.argv:
        usage()
        exit()
    make_doc()
