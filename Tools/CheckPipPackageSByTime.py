#!/usr/bin/env python3
# Check Pip Package Sort by time.
# This script use to check pip install package time.
# mod by manesec.
# Reference: https://stackoverflow.com/questions/24736316/see-when-packages-were-installed-updated-using-pip

# select mode 1 or 2:
mode = 2

# ------------------------------
from datetime import datetime
print("[*] Fetching pip installed information ...")

if mode == 1:
    import pkg_resources, os, time

    installed = []

    for package in pkg_resources.working_set:
        installed.append([package,os.path.getctime(package.location)])

    sorted_list = sorted(installed, key=(lambda x:x[1] ))
    for i,d in sorted_list:
        print("[%s] %s" % ( datetime.fromtimestamp(d) ,i))

if mode == 2:
    from importlib.metadata import distributions  
    import os, time

    installed = []

    for dist in distributions():
        try: 
            installed.append([ dist.metadata["Name"] + dist.version , os.path.getctime(dist._path) ])
        except: pass

    sorted_list = sorted(installed, key=(lambda x:x[1] ))
    for i,d in sorted_list:
        print("[%s] %s" % (  datetime.fromtimestamp(d),i))
