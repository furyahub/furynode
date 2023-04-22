#!/usr/bin/env bash
rm -rf all.json pending.json completed.json
furynoded q dispensation records-by-name ar1 All>> all.json
furynoded q dispensation records-by-name ar1 Pending >> pending.json
furynoded q dispensation records-by-name ar1 Completed>> completed.json