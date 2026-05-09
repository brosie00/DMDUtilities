function Select-Accounts {

    param(
        [Parameter(Mandatory)]
        [string]$Text,

        [Parameter()]
        [ValidateSet("Emails","Usernames","Both")]
        [string]$Mode = "Both"
    )

    $userRegex  = '\b[a-zA-Z0-9]{4}(B|b)\b'
    $emailRegex = '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b'

    $emails = [regex]::Matches($Text, $emailRegex) | ForEach-Object { $_.Value }
    $users  = [regex]::Matches($Text, $userRegex)  | ForEach-Object { $_.Value.ToLower() }

    switch ($Mode) {
        "Emails"    { return $emails | Select-Object -Unique }
        "Usernames" { return $users  | Select-Object -Unique }
        "Both"      { return @($emails + $users) | Select-Object -Unique }
    }
}
