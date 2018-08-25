download ::
	curl "https://hakka.dict.edu.tw/hakkadict/result_detail.jsp?n_no=[1-15487]&soundtype=0&sample=%E7%9A%84" -o "corpus/text/detail_#1.html" --create-dirs --retry 100 --retry-delay 10
	curl "https://hakka.dict.edu.tw/hakkadict/audio/s_sound{,2,3,4,5,6}/[00001-15487].mp3" -o "corpus/s_sound#1/#2.mp3" --create-dirs --retry 100 --retry-delay 10
	find corpus -name '*mp3' ! -size +4k -exec rm -f {} \;

dict ::
	lsc wip2dict.ls > z
	lsc -j z > dict-hakka.json

parse ::
	virtualenv venv
	. venv/bin/activate
	pip install beautifulsoup4 lxml
	python parse.py corpus/text/ wip.json
	lsc -j wip.json > work-in-progress.json
