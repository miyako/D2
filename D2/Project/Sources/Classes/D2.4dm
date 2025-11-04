Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	If (Not:C34(OB Instance of:C1731($controller; cs:C1710._D2_Controller)))
		$controller:=cs:C1710._D2_Controller
	End if 
	
	Super:C1705("d2"; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function layout($option : Object; $formula : 4D:C1709.Function)
Function themes($option : Object; $formula : 4D:C1709.Function)
Function fmt($option : Object; $formula : 4D:C1709.Function)
Function play($option : Object; $formula : 4D:C1709.Function)
Function validate($option : Object; $formula : 4D:C1709.Function)
	
Function render($option : Variant; $formula : 4D:C1709.Function) : Collection
	
	var $stdOut; $isStream; $isAsync : Boolean
	var $options : Collection
	var $results : Collection
	$results:=[]
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=[$option]
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
		Else 
			$options:=[]
	End case 
	
	var $commands : Collection
	$commands:=[]
	
	If (OB Instance of:C1731($formula; 4D:C1709.Function))
		$isAsync:=True:C214
		This:C1470.controller.onResponse:=$formula
	End if 
	
	For each ($option; $options)
		
		If ($option=Null:C1517) || (Value type:C1509($option)#Is object:K8:27)
			continue
		End if 
		
		$stdOut:=Not:C34(OB Instance of:C1731($option.output; 4D:C1709.File))
		
		$command:=This:C1470.escape(This:C1470.executablePath)
		
		var $arg : Object
		var $valueType : Integer
		var $key : Text
		
		For each ($arg; OB Entries:C1720($option))
			Case of 
				: (["data"; "output"; "file"; "watch"; "host"; "port"; "browser"].includes($arg.key))
					continue
			End case 
			$valueType:=Value type:C1509($arg.value)
			$key:=Replace string:C233($arg.key; "_"; "-"; *)
			Case of 
				: ($valueType=Is real:K8:4)
					$command+=(" --"+$key+"="+String:C10($arg.value)+" ")
				: ($valueType=Is text:K8:3)
					$command+=(" --"+$key+"="+This:C1470.escape($arg.value)+" ")
				: ($valueType=Is boolean:K8:9) && ($arg.value)
					$command+=(" --"+$key+" ")
				Else 
					//
			End case 
		End for each 
		
		If ($stdOut)
			$format:="svg"
			If (Value type:C1509($option.stdout_format)=Is text:K8:3) && ($option.stdout_format#"")
				$format:=$option.stdout_format
			End if 
		Else 
			$format:=Replace string:C233($option.output.extension; "."; ""; *)
		End if 
		
		If ($format="gif") && ($option.animate_interval=Null:C1517)
			$command+=(" --animate-interval 250 ")
		End if 
		
		Case of 
			: (Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.File)) && ($option.file.exists) && ($option.file.extension=".d2")
				$command+=" "
				$command+=This:C1470.escape(This:C1470.expand($option.file).path)
			: ((Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.Blob))) || (Value type:C1509($option.file)=Is BLOB:K8:12) || (Value type:C1509($option.file)=Is text:K8:3)
				$command+=" - "
				$isStream:=True:C214
				If (Value type:C1509($option.file)=Is text:K8:3)
					$option.file:=Replace string:C233($option.file; "\r"; "\n"; *)
				End if 
		End case 
		
		If ($stdOut)
			$command+=" - "
		Else 
			$command+=" "
			$command+=This:C1470.escape(This:C1470.expand($option.output).path)
		End if 
		
		$HOME:=Folder:C1567(fk user preferences folder:K87:10).parent.folder("d2")
		$HOME.create()
		This:C1470.controller.variables.HOME:=$HOME.path
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.controller.execute($command; $isStream ? $option.file : Null:C1517; $option.data).worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If (Not:C34($isAsync))
			//%W-550.26
			//%W-550.2
			If ($stdOut)
				$results.push(This:C1470.controller.stdOut)
			Else 
				$results.push(Null:C1517)
			End if 
			This:C1470.controller.clear()
			//%W+550.2
			//%W+550.26
		End if 
		
	End for each 
	
	If (Not:C34($isAsync))
		return $results
	End if 