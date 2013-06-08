# -*- coding: utf-8 -*-
"""
Created on Sat Jun  8 04:49:16 2013

@author: pierre
"""

from bs4 import BeautifulSoup as BS
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
    (u"部首:", u"部首"),\
    (u"詞性:", u"詞性"),\
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
            text = c.text.strip()
            following = cells[i+1].text.strip() if i+1 < len(cells) else ""
            dict_entry.update(parse_cell(text,following))
    dict_entry = parse_meaning(dict_entry)
    return dict_entry




def parse_cell(current,following):
    if following != "":
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
    s = entry[u'釋義']
    if u"。例：" in s:
        fields = s.split(u"。例：")
        if len(fields) == 2:
            (meaning,ex) = fields
            examples = RE_ex.findall(ex)
            ret = []
            for ex in examples:
                ret.append((u"\ufff9"+ex[0],u"\ufffb"+ex[1]))
            entry[u'釋義'] = {'def': meaning, 'example': ret}
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
