<#
.SYNOPSIS
Creates an argument completer for hashtable keys used by Format-UserNames.

.DESCRIPTION
This helper function provides dynamic tab completion for usernames stored in the global MyHashTable.
It filters keys based on the user's input and returns matching completion results.

.PARAMETER commandName
The name of the command being completed.

.PARAMETER parameterName
The name of the parameter being completed.

.PARAMETER wordToComplete
The word being completed (what the user has typed so far).

.PARAMETER commandAst
The abstract syntax tree of the command line.

.PARAMETER fakeBoundParameters
The parameters that have been bound so far.

.OUTPUTS
System.Management.Automation.CompletionResult[]
Returns matching hashtable keys as completion results.

.NOTES
This is an internal helper function used by Format-UserNames for argument completion.
#>
function _format_Usernames {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $Global:MyHashTable.Keys | Where-Object { $_ -like "*$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Hashtable Key: $_")
    }
}
