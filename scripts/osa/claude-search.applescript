on run argv
	if (count of argv) is 0 then
		set query to "hello world"
	else
		set query to item 1 of argv
	end if
	
	try
		log_message("Starting Claude search script with query: " & query)
		
		log_message("Activating Chrome")
		tell application "Google Chrome" to activate
		
		log_message("Opening Claude URL")
		tell application "Google Chrome" to open location "https://claude.ai" -- Claude 的实际 URL
		
		log_message("Starting to wait for input field")
		
		-- 等待输入框出现并可点击
		set inputReady to false
		set attempts to 0
		set jsStr to "
			try {
				inputElement = document.querySelector('main div[aria-label=\"Write your prompt to Claude\"] div[contenteditable=\"true\"]'); 
			if(inputElement){
				//inputElement.click();
			 	ok = true;
			}
		}
		catch {
			ok = false;
		}
		 "
		
		repeat until inputReady or attempts > 3
			tell application "Google Chrome"
				tell active tab of front window
					set inputReady to do javascript jsStr
				end tell
			end tell
			
			log_message("inputReady: " & inputReady)
			
			if not inputReady then
				delay 2
				set attempts to attempts + 1
			end if
		end repeat
		
		if inputReady then
			log_message("Input field is ready, proceeding to input query")
			-- 模拟用户输入
			tell application "System Events"
				log_message("Inputting query")
				keystroke query
				log_message("Pressing enter")
				--key code 36 -- 回车键
			end tell
			log_message("Successfully input query: " & query)
			return "Successfully input query: " & query
		else
			--log_message("Timeout: Input field not ready after 30 seconds")
			return "Timeout: Input field not ready after 30 seconds"
		end if
	on error errMsg
		log_message("Error occurred: " & errMsg)
		return "Error: " & errMsg
	end try
end run

on log_message(msg)
	log msg
	
	(*
	set logFile to (path to desktop folder as text) & "claude_search_log.txt"
	set curDate to (current date) as string
	try
		do shell script "echo '" & curDate & ": " & msg & "' >> " & quoted form of POSIX path of logFile
	on error
		-- 如果写入文件失败，至少尝试在控制台打印消息
		error msg
	end try
	*)
end log_message
