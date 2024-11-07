#!/bin/bash
export FLASK_APP=/app/index.py
python -m flask db upgrade
python -m gunicorn --bind 0.0.0.0:5000 index:app
