dict ::
	lsc wip2dict.ls > z
	lsc -j z > dict-hakka.json

parse ::
	python parse.py ~/Downloads/taiwan_language/hakka wip.json
	lsc -j wip.json > work-in-progress.json
