# Web Scraper and Content Host

This Docker project grabs content from any website and serves it up through a simple web server. Perfect for collecting data or mirroring content.

##  Steps to Run

Build it:
```bash
docker build -t web-scraper-host .
```

Run it (using example.com by default):
```bash
docker run -p 9000:5000 web-scraper-host
```

Or scrape your own site:
```bash
docker run -p 9000:5000 -e SCRAPE_URL=https://your-website.com web-scraper-host
```

Then just visit http://localhost:9000 to see the scraped data.

## Port Issues?

If 9000 is taken, just use another port:
```bash
docker run -p 8080:5000 web-scraper-host
```

Or let Docker pick one for you:
```bash
docker run -P web-scraper-host
docker ps  # see which port was assigned
```

## What's Inside

The project uses Node.js/Puppeteer for scraping and Python/Flask for serving the content. The Docker build keeps everything nice and tidy in a single container.

Need to check if everything's working? Visit http://localhost:9000/health

Happy scraping!