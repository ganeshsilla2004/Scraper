const puppeteer = require('puppeteer');
const fs = require('fs');


const url = process.env.SCRAPE_URL || 'https://example.com';

async function scrape() {
  console.log(`Starting to scrape: ${url}`);
  

  const browser = await puppeteer.launch({
    executablePath: '/usr/bin/chromium',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu'
    ],
    headless: true
  });

  try {
    const page = await browser.newPage();
    

    await page.goto(url, { waitUntil: 'networkidle2' });
    

    const data = await page.evaluate(() => {
      return {
        title: document.title,
        heading: document.querySelector('h1') ? document.querySelector('h1').innerText : 'No heading found',
        url: window.location.href,
        timestamp: new Date().toISOString()
      };
    });
    

    fs.writeFileSync('/app/scraped_data.json', JSON.stringify(data, null, 2));
    console.log('Scraping completed successfully');
    
  } catch (error) {
    console.error('Error during scraping:', error);

    fs.writeFileSync('/app/scraped_data.json', JSON.stringify({ 
      error: error.message,
      timestamp: new Date().toISOString()
    }, null, 2));
  } finally {
    await browser.close();
  }
}

scrape();