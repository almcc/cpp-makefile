#!/usr/local/bin/python2.7

import re
import sys
import cgi

src_dir = sys.argv[2] + "/"
def get_lines_of_file(filename, line_number, buffer):
    f = open(filename)
    alllines = [x[:-1] for x in f.readlines()]
    f.close()
    lines = []
    for index, line in enumerate(alllines):
        start = line_number - buffer
        finish = line_number + buffer
        current_line_num = index + 1
        if current_line_num >= start and current_line_num <= finish:
            bad_line = "{:0>3}: {}".format(current_line_num, line)
            html_line = cgi.escape(bad_line)
            lines.append(html_line)
    return lines

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
        html = "<table class='information'>"
        html += "<tbody>"
        for file in self.files:
            html += file.html_row()
        html += "</tbody>"
        html += "<table>"
        html += "<hr />"
        return html

class Result(Line):
    def __init__(self):
        self.regex = re.compile("(.*):([0-9]*):[ ]+(.*)\[(.*)\/(.*)\].*\[([0-5]*)\]")
        self.filename = ""
        self.line = 0
        self.error = ""
        self.category = ""
        self.sub_category = ""
        self.severity = 0

    def get_source(self):
        lines = get_lines_of_file(src_dir+self.filename, self.line, 2)
        string = ""
        for line in lines:
            string += line + "\n"
        return string

    def get_category_label(self):
        if self.category == "build":
            return "warning"
        if self.category == "legal":
            return "success"
        if self.category == "readability":
            return "info"
        if self.category == "runtime":
            return "danger"
        if self.category == "whitespace":
            return "primary"
        return "default"

    def get_severity_color(self):
        if self.severity == 5:
            return "#FF3004"
        if self.severity == 4:
            return "#E8570C"
        if self.severity == 3:
            return "#FF8200"
        if self.severity == 2:
            return "#E89B0C"
        if self.severity == 1:
            return "#FFC70D"
        return "black"


    def html_row(self):
        html = "<div class='row'>"
        html += "<div class='col-md-6'>"
        html += "<table class='information'>"
        html += "<tr>"
        html += "<td><strong>Error:</strong></td>"
        html += "<td>{}</td>".format(self.error)
        html += "</tr>"
        html += "<tr>"
        html += "<td><strong>Location:</strong></td>"
        html += "<td>{}:{}</td>".format(self.filename, self.line)
        html += "</tr>"
        html += "<tr>"
        html += "<td><strong>Category:</strong></td>"
        html += "<td><span class='label label-{}'>{}/{}</span></td>".format(self.get_category_label(),
                                                                                 self.category,
                                                                                 self.sub_category)
        html += "</tr>"
        html += "<tr>"
        html += "<td><strong>Severity:</strong></td>"
        html += "<td><span class='badge' style='background-color:{};'>{}</span></td>".format(self.get_severity_color(),
                                                                                                  self.severity)
        html += "</tr>"
        html += "</table>"
        html += "</div>"
        html += "<div class='col-md-6'>"
        html += "<pre>{0}</pre>".format(self.get_source())
        html += "</div>"
        html += "</div>"
        html += "<hr />"
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
            for result in self.results:
                html += result.html_row()
        else:
            html += "<p> Nothing to report.</p>"
            html += "<hr />"
        return html

class Page:
    def __init__(self, fileCollection, resultCollection):
        self.fileCollection = fileCollection
        self.resultCollection = resultCollection

    def html(self):
        html = "<html>"
        html += "<head>"
        html += "<title>cpplint.py</title>"
        html += "<link href='../web/css/bootstrap.min.css' rel='stylesheet'>"
        html += "<link href='../web/css/bootstrap-theme.min.css' rel='stylesheet'>"
        html += "<script src='../web/js/jquery.min.js'></script>"
        html += "<script src='../web/js/bootstrap.min.js'></script>"
        html += "</head>"
        html += "<body>"
        html += "<style>"
        html += ".information, td{padding:5px;}"
        html += "</style>"
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
