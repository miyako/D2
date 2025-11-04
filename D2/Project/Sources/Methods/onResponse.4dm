//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($worker : 4D:C1709.SystemWorker; $params : Object)

Case of 
	: ($params.context=Null:C1517)
		
	: (Value type:C1509($params.context)=Is object:K8:27) && (OB Instance of:C1731($params.context; 4D:C1709.File))
		
		var $file : 4D:C1709.File
		$file:=$params.context
		
	: (Value type:C1509($worker.response)=Is text:K8:3)
		
		var $text : Text
		$text:=$worker.response
		
End case 