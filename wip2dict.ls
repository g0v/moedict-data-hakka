it = meng!

require! fs

const ABBREV = {
  "四縣音": \四
  "海陸音": \海
  "大埔音": \大
  "饒平音": \平
  "詔安音": \安
}
const PUA = pua!

sounds = ->
  it.replace(/1/g '¹')
    .replace(/2/g '²')
    .replace(/3/g '³')
    .replace(/4/g '⁴')
    .replace(/5/g '⁵')

def = ->
  it.example = [ e.join('') - /[（）]/g for e in it.example ] if it.example
  delete it.example unless it.example?length
  it.def += '。' unless it.def is /[。，、；：？！─…．·－」』》〉]$/
  it.def -= /^\d+\.\s*/
  it

py = ->
  m = []
  for x in ["四縣音" "海陸音" "大埔音" "饒平音" "詔安音"] | it[x]
    m.push(ABBREV[x] + '\u20DE' + sounds(it[x] - /（.*）/ - /\s/g))
  m * ' '

norm = -> (it || '') - /【/ - /】/
m2t = -> {
  title: norm(it['詞目'])
  heteronyms: [ {
    audio_id: (100000 + Number(it['檔名'] - /\D/g)) - /^1/
    pinyin: py it
    synonyms: [ norm(x - /^\d+\.\s*/) for x in it['近義詞'] / \、] * \,
    antonyms: [ norm(x - /^\d+\.\s*/) for x in it['反義詞'] / \、] * \,
    definitions: [ def d <<< { type: "#{ it['詞性'] || '' }".replace(/　/g \,) } for d in it['釋義'] ]
  } ]
}

flatten = (xs) -> [].concat.apply [], [(if x.length? then flatten x else x) for x in xs]

sort-by = (f, xs=[]) -> xs.concat!.sort (x, y) ->
  if (f x) > (f y)      => 1
  else if (f x) < (f y) => -1
  else                  => 0

WIP = JSON.parse fs.read-file-sync(\work-in-progress.json \utf8).replace(
  /\{\[(....)\]\}/g
  (_, $1) -> PUA[$1] || do ->
    console.log $1
    process.exit $1
)
HETERONYMS = {}
for w in WIP | w['詞目']
  {title, heteronyms} = m2t w
  HETERONYMS[title] ||= []
  HETERONYMS[title].push(for h in heteronyms
    delete h.synonyms unless h.synonyms
    delete h.antonyms unless h.antonyms
    h
  )

console.log JSON.stringify(for title in Object.keys(HETERONYMS).sort!
  { title, heteronyms: flatten sort-by( ((.0.audio_id) >> Number), HETERONYMS[title] ) }
)
process.exit!

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
function pua => {
  "2430": "𤌍",
  "2A61": "𪘒",
  'F307': '⿰亻恩',
  'F442': '⿰虫念',
  'F545': '⿺皮卜',
  "35F1": "㗱",
  "3614": "㘔",
  "39FE": "㧾",
  "3F13": "㼓",
  "3F8A": "㾊",
  "F305": "𠊎",
  "F30E": "𢼛",
  "F315": "𢫦",
  "F31B": "䀴",
  "F349": "䘆",
  "F34E": "㧡",
  "F34F": "䟓",
  "F350": "𠲿",
  "F354": "䞚",
  "F357": "㬹",
  "F35A": "𢱤",
  "F35F": "䃗",
  "F360": "𪐞",
  "F369": "𧊅",
  "F36A": "㰵",
  "F36B": "𤊶",
  "F36C": "𥯟",
  "F36D": "𠠃",
  "F36E": "𧩣",
  "F36F": "𩜰",
  "F372": "𥍉",
  "F374": "𢯭",
  "F377": "㪐",
  "F379": "𣲩",
  "F37B": "𥺆",
  "F37C": "𣼎",
  "F37D": "𣛮",
  "F37E": "𨒇",
  "F382": "㖸",
  "F383": "𤐰",
  "F384": "䗁",
  "F385": "𤸁",
  "F390": "𢳆",
  "F392": "䢍",
  "F394": "䁯",
  "F397": "𥯥",
  "F39A": "䟘",
  "F39B": "𠖄",
  "F39C": "㘝",
  "F3A5": "𤸱",
  "F3B4": "䀯",
  "F3B5": "𪖐",
  "F3B9": "𥉌",
  "F3BF": "㸐",
  "F3C9": "𠜱",
  "F401": "𤘅",
  "F40E": "㔇",
  "F40F": "㩢",
  "F414": "𩜄",
  "F416": "𢜳",
  "F426": "㸰",
  "F433": "𤍒",
  "F434": "𨃰",
  "F436": "贌",
  "F437": "𠗻",
  "F438": "𨰠",
  "F444": "𫟧",
  "F446": "𫝘",
  "F448": "䯋",
  "F44F": "𠎷",
  "F463": "㗘"

  F488: \割 # XXX
  F4BC: \墩 # XXX
}
