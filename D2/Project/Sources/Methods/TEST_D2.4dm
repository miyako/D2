//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $D2 : cs:C1710.D2
	$D2:=cs:C1710.D2.new()
	
	$file:="# example.d2\n# Simple D2 diagram for testing rendering and CLI output\n\n# Nodes\nApp: \"Frontend App\"\nAPI: \"Backend API\"\nDB: \"Database\"\nCache: \"Redis Cache\"\n\n# Connections\nApp -> API: \"calls\"\nAPI -> DB: \"queries\"\nAPI -> Cache: \"reads/writes\"\nCache -> DB:"+" \"fallback\"\n\n# Grouping\ngroup Infra {\n    DB\n    Cache\n}\n\n# Styling\nApp.style.fill: \"#f0f9ff\"\nAPI.style.fill: \"#e0f7fa\"\nDB.style.fill: \"#fff3e0\"\nCache.style.fill: \"#e8f5e9\"\n\n# Layout direction\ndirection: right"
	
	var $tasks : Collection
	$tasks:=[]
	
/*
headless browser "playwright" is automatically downloaded and cached in
Folder(fk user preferences folder).parent.folder("d2")
if format other than svg or txt is requested
*/
	
	$folder:=Folder:C1567(fk desktop folder:K87:19).folder("d2")
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
	
	$D2.render($tasks; Formula:C1597(onResponse))
	
End if 