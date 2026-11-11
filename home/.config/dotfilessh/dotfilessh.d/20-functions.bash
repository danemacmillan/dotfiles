watchindex() {
	watch -n1 'ps -eo pid,lstart,etime,cmd --no-headers | grep "[i]ndexer:reindex"'
}

psindex() {
	ps -eo pid,lstart,etime,cmd | grep "[i]ndexer:reindex"
}
