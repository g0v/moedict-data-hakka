it = meng!

require! fs

const ABBREV = {
  "四縣音": \四
  "海陸音": \海
  "大埔音": \大
  "饒平音": \平
  "詔安音": \安
}

sounds = ->
  it.replace(/1/g '¹')
    .replace(/2/g '²')
    .replace(/3/g '³')
    .replace(/4/g '⁴')
    .replace(/5/g '⁵')

do-d = ->
  it.example = [ e.join('') for e in it.example ]
  it

py = ->
  m = []
  for x in ["四縣音" "海陸音" "大埔音" "饒平音" "詔安音"] | it[x]
    m.push(ABBREV[x] + '\u20DE' + sounds(it[x] - /\n/g))
  m * ' '

norm = -> (it || '') - /【/ - /】/
m2t = ->
  j = {
    title: norm(it['詞目'])
    heteronyms: [ {
      pinyin: py it
      synonyms: [ norm x for x in it['近義詞'] / \、] * \,
      antonyms: [ norm x for x in it['反義詞'] / \、] * \,
      definitions: [ do-d d for d in it['釋義'] ]
      type: it['詞性']
    } ]
  }

WIP = JSON.parse fs.read-file-sync \work-in-progress.json \utf8
h2m = {}
for w in WIP | w['對應華語']
  title = norm(w['詞目'])
  m = ",#{ w['對應華語'].replace(/、/g \,).replace(/　/g \,).replace(/\d+\./g '') },"
  m = m.replace(",#title,", ',')
  m -= /^,/
  m -= /,$/
  h2m[title] = m

console.log JSON.stringify h2m

process.exit!
console.log JSON.stringify [m2t w for w in WIP | w['詞目']]

process.exit!
console.log JSON.stringify {
  "title": "發芽",
  "heteronyms": [ {
     "synonyms": "暴芽,暴筍",
     "pinyin": "四\u20DEfad²nga¹¹ 海\u20DEfad⁵nga⁵⁵ 大\u20DEfad²¹nga¹¹³ 平\u20DEfad²⁴nga⁵³",
     "definitions": [
        "example": [
            "\uFFF9春天一到，草仔樹仔相賽開始發芽。\uFFFB春天一到，草木相繼開始萌芽。"
        ]
        "def": "植物的種子，因本身的生理、外部環境條件的合適，而開始萌發的一種現象"
        "type": "動"
     ]
  } ]
}

function meng => {
    "多音字": "",
    "四縣音": "\n\n\n\nfad2nga11",
    "海陸音": "\n\n\n\nfad5nga55",
    "又音": "",
    "釋義": [
      {
        "example": [
          [
            "\uFFF9春天一到，草仔樹仔相賽開始發芽。",
            "\uFFFB（春天一到，草木相繼開始萌芽。）"
          ]
        ],
        "def": "植物的種子，因本身的生理、外部環境條件的合適，而開始萌發的一種現象"
      }
    ],
    "大埔音": "\n\n\n\nfad21nga113",
    "對應華語": "萌芽",
    "近義詞": "【暴芽】、【暴筍】",
    "詞性": "動",
    "詞目": "【發芽】",
    "反義詞": "",
    "文白讀": "",
    "饒平音": "\n\n\n\nfad24nga53"
}
