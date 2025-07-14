extends CanvasLayer

@onready var job_dropdown: OptionButton = $VBoxContainer/JobDropdown
@onready var job_name_label: Label = $VBoxContainer/JobNameLabel
@onready var job_desc_label: Label = $VBoxContainer/JobDescLabel
@onready var skills_box: VBoxContainer = $VBoxContainer/SkillsBox

var jobs = []  # Array of dictionaries from CSV

func _ready():
	load_jobs_from_csv("res://resource/class.csv")
	populate_dropdown()
	job_dropdown.connect("item_selected", Callable(self, "_on_job_selected"))
	_on_job_selected(0)

func load_jobs_from_csv(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("Failed to open CSV")
		return
	
	file.get_line()  # Skip header
	while not file.eof_reached():
		var line = file.get_line()
		if line.strip_edges() == "":
			continue
		var parts = line.split(",", false)
		if parts.size() >= 4:
			var job = {
				"id": parts[0],
				"name": parts[1],
				"description": parts[2],
				"skills": parts[3].strip_edges().split(";")
			}
			jobs.append(job)

func populate_dropdown():
	for job in jobs:
		job_dropdown.add_item(job["name"])

func _on_job_selected(index: int):
	var job = jobs[index]
	job_name_label.text = "Job: " + job["name"]
	job_desc_label.text = "Description: " + job["description"]

	# Clear old skill labels
	for child in skills_box.get_children():
		child.queue_free()

	# Add new skill labels
	for skill in job["skills"]:
		var skill_label = Label.new()
		skill_label.text = "- " + skill
		skills_box.add_child(skill_label)
