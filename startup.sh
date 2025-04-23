#!/bin/bash
# First run the scraper
node scrape.js

# Then start the Flask server
python server.py