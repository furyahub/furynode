#!/usr/bin/env bash
rm -rf all.json pending.json completed.json
furynd q dispensation records-by-name ar1 All>> all.json
furynd q dispensation records-by-name ar1 Pending >> pending.json
furynd q dispensation records-by-name ar1 Completed>> completed.json