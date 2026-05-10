@{
    RootModule        = 'DMDUtilities.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'b8c1c1a4-3e8c-4e0f-9b7e-1c2f9f0d1234'
    Author            = 'Brett'
    CompanyName       = 'DMD'
    PowerShellVersion = '5.1'

    FunctionsToExport = @(
        'Select-Accounts',
        'Format-Usernames'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('fun')
}


# Usage:
# Try typing `Format-UserNames -Key <Tab>` to cycle through keys interactively
