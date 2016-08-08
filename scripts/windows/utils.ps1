# Tests if a registry value $Name exists for a given key at $Path
function Test-RegValue{
	param (
		[Parameter(Position=0, Mandatory=$true)][String]$Path, 
		[Parameter(Position=1, Mandatory=$true)][String]$Name
	)
	
	process{
		if(Test-Path $Path){
			$key = (gi $Path)
			return $key.GetValueNames() -contains "$Name"
		}
		else{
			return $false;
		}
	}
}

# Invokes a Cmd.exe shell script and updates the environment.
function Invoke-CmdScript {
  param(
    [String] $scriptName
  )
  $cmdLine = """$scriptName"" $args & set"
  & $Env:SystemRoot\system32\cmd.exe /c $cmdLine |
  select-string '^([^=]*)=(.*)$' | foreach-object {
    $varName = $_.Matches[0].Groups[1].Value
    $varValue = $_.Matches[0].Groups[2].Value
    set-item Env:$varName $varValue
  }
}
