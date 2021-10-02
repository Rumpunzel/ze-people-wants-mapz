tool
class_name FileHelper


static func list_files_in_directory(directory_path: String, recursive: bool, file_suffix:String = "") -> Array:
	var files := []
	var directory := Directory.new()
	
	if not directory.dir_exists(directory_path):
		printerr("Directory %s does not exist!" % directory)
		return files
	
	# warning-ignore:return_value_discarded
	directory.open(directory_path)
	# warning-ignore:return_value_discarded
	directory.list_dir_begin(true, true)
	
	while true:
		var file := directory.get_next()
		
		if file == "":
			break
		elif directory.current_is_dir():
			if recursive:
				files += list_files_in_directory(directory_path.plus_file(file), recursive, file_suffix)
		elif file.ends_with(file_suffix):
			var file_path := directory_path.plus_file(file)
			files.append(file_path)
	
	directory.list_dir_end()
	
	return files


static func delete_file(file_path:String):
	var directory = Directory.new()
	directory.remove(file_path)
