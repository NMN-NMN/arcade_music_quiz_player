import json

with open("assets/db/chunithm video.json", "r", encoding="utf-8") as f:
    data = json.load(f)

with open("no_video_list.txt", "w", encoding="utf-8") as f:
    for item in data:
        if item.get("hasVideo") == False:
            f.write(item["title"] + "\n")