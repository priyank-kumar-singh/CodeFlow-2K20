const fs = require("fs");
const path = require("path");
const puppeteer = require('puppeteer');
const handlebars = require("handlebars");
var express = require('express');
var bodyParser = require('body-parser');
var url = require('url');
const { json } = require("body-parser");
var app = express();


async function createPDF(data){

	var templateHtml = fs.readFileSync(path.join(process.cwd(), 'template.html'), 'utf8');
	var template = handlebars.compile(templateHtml);
	var html = template(data);

	var milis = new Date();
	milis = milis.getTime();

	var pdfPath = path.join(`report.pdf`);

	var options = {
		width: '1230px',
		headerTemplate: "<p></p>",
		footerTemplate: "<p></p>",
		displayHeaderFooter: false,
		margin: {
			top: "10px",
			bottom: "30px"
		},
		printBackground: true,
		path: pdfPath
	}

	const browser = await puppeteer.launch({
		args: ['--no-sandbox'],
		headless: true
	});

	var page = await browser.newPage();

	await page.goto(`data:text/html;charset=UTF-8,${html}`, {
		waitUntil: 'networkidle0'
	});

	await page.pdf(options);
	await browser.close();
}

const data = {
	title: "Monc",
	date: "05/12/2018",
	name: "lord",
	age: 18,
	birthdate: "12/07/1990",
	course: "Computer Science",
	obs: "Graduated in 2014 by Federal University of Lavras, work with Full-Stack development and E-commerce."
}

// createPDF(data);

app.listen(process.env.PORT || 8080, function() {
    console.log('listening on 8080')
});

app.use(express.json());

app.post('/',function(req,res) {
	// res.send("Hello World,This is index page.")
	// res.writeHead(200, {'Content-Type': 'text/html'});
	// var q = url.parse(req.url, true).query;
	// var txt = q.year + " " + q.month;

	console.log(req.body);
	console.log("yo");
	createPDF(req.body);
    res.end("Red");
    // res.download('report.pdf');
})

app.get('/download', (req, res) => res.download('report.pdf'))
