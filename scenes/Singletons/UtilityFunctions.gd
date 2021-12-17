extends Node


func mid(min_val,mid_val,max_val):
	var ret = mid_val
	if min_val > mid_val:
		ret = min_val
	elif max_val < mid_val:
		ret = max_val
	
	return ret
