
<#
.SYNOPSIS
Formats and retrieves email addresses associated with usernames from the DMDUtilities database.

.DESCRIPTION
Format-UserNames looks up one or more usernames in the global MyHashTable and returns their associated 
email addresses in various formats. The function supports multiple output modes for different use cases, 
including raw email output, YAML formatting, and database unlock messages.

Usernames must end with 'b' (case-insensitive) and are typically 5 letters long. The function provides 
tab completion support for valid usernames stored in the module's data.

.PARAMETER Key
Specifies one or more usernames to look up. Accepts a single string or an array of strings. 
Usernames are case-insensitive and typically follow the pattern of 5-letter names ending with 'b' 
(e.g., 'ajaxb', 'alexb', 'applb'). Supports tab completion for available usernames.

.PARAMETER Mode
Specifies the output format for the email address. Valid values are:
- Raw (default): Returns the email address with a leading space
- YAML: Returns the email address with YAML list formatting (leading dash)
- DatabaseUnlock: Returns a formatted message suitable for database unlock operations

.PARAMETER ToClipboard
When specified, copies the output to the Windows clipboard in addition to writing it to the console.

.EXAMPLE
PS> Format-UserNames -Key "ajaxb"
 aj.axelrod@company.com

Retrieves and displays the email address for user 'ajaxb' in Raw mode.

.EXAMPLE
PS> Format-UserNames -Key "alexb" -Mode YAML
-  al.exurban@company.com

Retrieves the email address for user 'alexb' formatted as a YAML list item.

.EXAMPLE
PS> Format-UserNames -Key "applb" -Mode DatabaseUnlock
please unlock applb => ap.plebian@company.com

Returns a formatted database unlock message with the username and email.

.EXAMPLE
PS> "ajaxb", "alexb" | Format-UserNames
 aj.axelrod@company.com
 al.exurban@company.com

Accepts pipeline input to look up multiple users at once.

.EXAMPLE
PS> Format-UserNames -Key "ashlb" -ToClipboard
 as.heilbronner@company.com

Retrieves the email and copies it to the clipboard.

.OUTPUTS
System.String
Returns formatted email address(es) based on the selected Mode parameter.

.NOTES
- All output is converted to lowercase
- Usernames are looked up in the global MyHashTable which is populated from Data\Users.csv
- Invalid usernames return null/empty results without throwing errors
- The function supports argument completion for available usernames via HashtableKeyCompleter

.LINK
https://github.com/brosie00/DMDUtilities
#>
function Format-UserNames {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ArgumentCompleter({ _Format_Usernames @args })]
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
                    