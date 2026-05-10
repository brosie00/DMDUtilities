# Create an ArgumentCompleter function
function HashtableKeyCompleter {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $Global:MyHashTable.Keys | Where-Object { $_ -like "*$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Hashtable Key: $_")
    }
}
# Define a function with dynamic key completion
# add a parameter named mode to switch between output formats
function Format-UserNames {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ArgumentCompleter({ HashtableKeyCompleter @args })]
        [string[]]$Key
        ,
        
        [Parameter()]
        [ValidateSet("Raw", "DatabaseUnlock", "YAML")]
        [string]$Mode = "Raw"
        ,
        
        [Parameter()]
        [switch]$ToClipboard
    )
    process {
        foreach ($k in $Key) {
            [string]$value = $Global:MyHashTable[$k]
            switch ($Mode) {
                "Raw" {
                    $output = " $value".ToLower()
                }
                "YAML" {
                    $output = "-  $value".ToLower()
                }
                "DatabaseUnlock" {
                    $output = "Please Unlock $k => $value".ToLower()
                }
            }
            Write-Output $output
            if ($ToClipboard) {
                $output | clip
            }
        }
    }
}
                    