# -*- coding: utf-8 -*-
"""
Created on Sat Jun  8 04:49:16 2013

@author: pierre
"""

from bs4 import BeautifulSoup as BS
from bs4 import element
import codecs
import glob
import sys
import re
import json

RE_ex = re.compile(u"(?P<ex>[^\（]+)(?P<trans>（[^\）]+）)",re.UNICODE)




datatypes2 = (\
    (u"^詞目$",u"詞目"),\
    (u"^四縣音$", u"四縣音"),\
    (u"^海陸音$", u"海陸音"),\
    (u"^大埔音$", u"大埔音"),\
    (u"^饒平音$", u"饒平音"),\
    (u"^詔安音$", u"饒平音"),\
    (u"^釋義$", u"釋義"),\
    (u"^近義詞$", u"近義詞"),\
    (u"^反義詞$",u"反義詞"),\
    (u"^文白讀$", u"文白讀"),\
    (u"^又　音$", u"又音"),\
    (u"^多音字$", u"多音字"),\
    (u"^對應華語$", u"對應華語"),\

    )

datatypes1 = (\
    (u"^部首:", u"部首"),\
    (u"^詞性:", u"詞性"),\
    (u"^部首:", u"部首"),\
    (u"^筆畫:",u"筆畫"),\
    )

def parse_file(infile):
    f = codecs.open(infile ,"r","utf8")
    html = "\n".join(f.readlines())
    f.close()
    dict_entry = {}
    dom = BS(html)
    rows = dom.find_all('tr')
    for r in rows:
        cells = r.findChildren()
        for i,c in enumerate(cells):
            text = cleanup_cell([x for x in c.children])
            following = [x for x in cells[i+1].contents ] if i+1 < len(cells) else None
            dict_entry.update(parse_cell(text,following))
    dict_entry = parse_meaning(dict_entry)
    return dict_entry


def cleanup_cell(content):
    for i,e in enumerate(content):
        if isinstance(e,element.Tag):
            if e.name == "br":
                content[i]="\n"
            elif e.name == "img":
                if 'src' in e.attrs:
                    content[i] = "{[%s]}" % (e.attrs['src'][7:][:-4],)
                else:
                    content[i] = 'X'
            else:
                content[i] = e.getText()
        else:
            content[i] = e.strip().replace("\n","")
    return "".join(content)

def parse_cell(current,following):
    if following :
        following = cleanup_cell(following)
        for regexp,label in datatypes2:
            if re.match(regexp,current):
                return {label:following}
    for regexp,label in datatypes1:
            match = re.match(regexp,current)
            if match:
                return {label: current[match.end():].strip()}
    return {}


def parse_meaning(entry):
    if not u'釋義' in entry :
        return entry
    senses = entry[u'釋義'].split("\n")
    parsed_senses = []
    for s in senses:
        if u"。例：" in s:
            fields = s.split(u"。例：")
            if len(fields) == 2:
                (meaning,ex) = fields
                examples = RE_ex.findall(ex)
                parsed_ex = []
                for ex in examples:
                    parsed_ex.append((u"\ufff9"+ex[0],u"\ufffb"+ex[1]))
                parsed_senses.append({'def': meaning, 'example': parsed_ex})
    entry[u'釋義'] = parsed_senses
    return entry



if __name__ == "__main__":
    if len(sys.argv) != 3:
        print "usage : parse.py <path to html files> <output file>"
        sys.exit(0)
    path = sys.argv[1]
    files = glob.glob(path + "/*.html")
    result = []
    for f in files:
        print "processing %s" %(f,)
        result.append(parse_file(f))
    json.dump(result,open(sys.argv[2],"w"))
