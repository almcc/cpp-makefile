#!/usr/bin/python

import re
import sys

class Line:
    def isOne(self, line):
        if self.regex.match(line):
            return True
        return False

class File(Line):
    def __init__(self):
        self.regex = re.compile("Done processing (.*)")
        self.filename = ""

    def html_row(self):
        html = "<tr>"
        html += "<td>{0}</td>".format(self.filename)
        html += "</tr>"
        return html

    def parseLine(self, line):
        match = self.regex.match(line)
        self.filename = match.group(1).strip()

class FileCollection:
    def __init__(self, files):
        self.files = files

    def html_title(self):
       html = "<div class='page-header'>"
       html += "<h3>Files processed:</h3>"
       html += "</div>"
       return html

    def html_table(self):
        html = "<table class='table grid'>"
        html += "<thead>"
        html += "<tr>"
        html += "<th>Filename</th>"
        html += "</tr>"
        html += "</thead>"
        html += "<tbody>"
        for file in self.files:
            html += file.html_row()
        html += "</tbody>"
        html += "<table>"
        return html

class Result(Line):
    def __init__(self):
        self.regex = re.compile("(.*):(.*):(.*)\[(.*)\/(.*)\].*\[(.*)\]")
        self.filename = ""
        self.line = 0
        self.error = ""
        self.category = ""
        self.sub_category = ""
        self.severity = 0

    def html_row(self):
        html = "<tr>"
        html += "<td>{0}</td>".format(self.filename)
        html += "<td>{0}</td>".format(self.line)
        html += "<td>{0}</td>".format(self.error)
        html += "<td>{0}</td>".format(self.category)
        html += "<td>{0}</td>".format(self.sub_category)
        html += "<td>{0}</td>".format(self.severity)
        html += "</tr>"
        return html

    def parseLine(self, line):
        match = self.regex.match(line)
        self.filename = match.group(1).strip()
        self.line = int(match.group(2).strip())
        self.error = match.group(3).strip()
        self.category = match.group(4).strip()
        self.sub_category = match.group(5).strip()
        self.severity = int(match.group(6).strip())

class ResultCollection:
    def __init__(self, results):
        self.results = results

    def html_title(self):
       html = "<div class='page-header'>"
       html += "<h3>Results:</h3>"
       html += "</div>"
       return html

    def html_table(self):
        html = ""
        if len(self.results) > 0:
            html += "<table class='table grid'>"
            html += "<thead>"
            html += "<tr>"
            html += "<th>Filename</th>"
            html += "<th>Line</th>"
            html += "<th>Error</th>"
            html += "<th>Category</th>"
            html += "<th>Sub Category</th>"
            html += "<th>Severity</th>"
            html += "</tr>"
            html += "</thead>"
            html += "<tbody>"
            for result in self.results:
                html += result.html_row()
            html += "</tbody>"
            html += "<table>"
        else:
            html += "<p> Nothing to report.</p>"
        return html

class Page:
    def __init__(self, fileCollection, resultCollection):
        self.fileCollection = fileCollection
        self.resultCollection = resultCollection

    def html(self): 
        html = "<html>"
        html += "<head>"
        html += "<title>cpplint.py</title>"
        html += "<link href='web/css/bootstrap.min.css' rel='stylesheet'>"
        html += "<link href='web/css/bootstrap-theme.min.css' rel='stylesheet'>"
        html += "<script src='web/js/jquery.min.js'></script>"
        html += "<script src='web/js/bootstrap.min.js'></script>"
        html += "</head>"
        html += "<body>"
        html += "<div class='container'>"
        html += "<h1>cpplint.py</h1>"
        html += self.resultCollection.html_title()
        html += self.resultCollection.html_table()
        html += self.fileCollection.html_title()
        html += self.fileCollection.html_table()
        html += "</div>"
        html += "</body>"
        html += "</html>"
        return html


f = open(sys.argv[1])
lines = f.readlines()
f.close() 

files = []
results = []
for line in lines:
    line = line[:-1]
    
    file = File()
    if file.isOne(line):
        file.parseLine(line)
        files.append(file)

    result = Result()
    if result.isOne(line):
        result.parseLine(line)
        results.append(result)
 
fileCollection = FileCollection(files)
resultCollection = ResultCollection(results)
page = Page(fileCollection, resultCollection)
print(page.html())
 