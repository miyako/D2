![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/D2)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/D2/total)

# D2
Use D2 from 4D

## usage

```4d
#DECLARE($params : Object)

If (Count parameters=0)
	
	CALL WORKER(1; Current method name; {})
	
Else 
	
	var $D2 : cs.D2
	$D2:=cs.D2.new()
	
	$file:="# example.d2\n# Simple D2 diagram for testing rendering and CLI output\n\n# Nodes\nApp: \"Frontend App\"\nAPI: \"Backend API\"\nDB: \"Database\"\nCache: \"Redis Cache\"\n\n# Connections\nApp -> API: \"calls\"\nAPI -> DB: \"queries\"\nAPI -> Cache: \"reads/writes\"\nCache -> DB:"+" \"fallback\"\n\n# Grouping\ngroup Infra {\n    DB\n    Cache\n}\n\n# Styling\nApp.style.fill: \"#f0f9ff\"\nAPI.style.fill: \"#e0f7fa\"\nDB.style.fill: \"#fff3e0\"\nCache.style.fill: \"#e8f5e9\"\n\n# Layout direction\ndirection: right"
	
	var $tasks : Collection
	$tasks:=[]
	
	/*
		headless browser "playwright" is automatically downloaded and cached in
		Folder(fk user preferences folder).parent.folder("d2")
		if format other than svg or txt is requested
	*/
	
	$folder:=Folder(fk desktop folder).folder("d2")
	$folder.create()
	
	$output:=$folder.file("test_d2.png")
	$tasks.push({file: $file; output: $output; data: $output})
	
	$output:=$folder.file("test_d2.pdf")
	$tasks.push({file: $file; output: $output; data: $output})
	
	
	$output:=$folder.file("test_d2.pptx")
	$tasks.push({file: $file; output: $output; data: $output})
	
	$output:=$folder.file("test_d2.gif")
	$tasks.push({file: $file; output: $output; data: $output})
	
	/*
		only svg&txt can be received in stdOut
		binary out stream not supported
		the svg can't be rendered in 4D
	*/
	
	$tasks.push({file: $file; stdout_format: "svg"; data: "svg"})
	$tasks.push({file: $file; stdout_format: "txt"; data: "txt"})
	
	$D2.render($tasks; Formula(onResponse))
	
End if 
```

The callback formula should have the following signature:

```4d
#DECLARE($worker : 4D.SystemWorker; $params : Object)

var $text : Text
$text:=$worker.response
```

> [!TIP]
> whatever value you pass in `data` is returned in `context`.
