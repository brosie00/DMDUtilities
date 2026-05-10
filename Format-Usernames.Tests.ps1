BeforeAll {
    $ModulePath = "$PSScriptRoot\DMDUtilities.psm1"
    Import-Module $ModulePath -Force
}

AfterAll {
    Remove-Module DMDUtilities -Force
}

Describe "Format-UserNames Function" {
    
    Context "Basic Functionality" {
        
        It "Should format a single username in Raw mode" {
            $result = Format-UserNames -Key "ajaxb" -Mode "Raw"
            $result | Should -Not -BeNullOrEmpty
            $result | Should -Match "aj.axelrod@company.com"
        }

        It "Should return lowercase output" {
            $result = Format-UserNames -Key "AJAXB" -Mode "Raw"
            $result | Should -Match "aj.axelrod@company.com"
        }

        It "Should default to Raw mode when Mode parameter is omitted" {
            $result = Format-UserNames -Key "alexb"
            $result | Should -Match "al.exurban@company.com"
        }

        It "Should accept pipeline input" {
            $result = "applb" | Format-UserNames
            $result | Should -Match "ap.plebian@company.com"
        }
    
    }

    Context "Mode Parameter - Output Formats" {
        
        It "Should format in Raw mode with leading space" {
            $result = Format-UserNames -Key "ajaxb" -Mode "Raw"
            $result | Should -BeLike " *"
        }

        It "Should format in YAML mode with leading dash" {
            $result = Format-UserNames -Key "alexb" -Mode "YAML"
            $result | Should -Match "^-\s+"
            $result | Should -Match "al.exurban@company.com"
        }

        It "Should format in DatabaseUnlock mode with message" {
            $result = Format-UserNames -Key "applb" -Mode "DatabaseUnlock"
            $result | Should -Match "Please Unlock applb"
            $result | Should -Match "ap.plebian@company.com"
        }

       It "Should validate Mode parameter" {
            { Format-UserNames -Key "ajaxb" -Mode "InvalidMode" } | Should -Throw
        }
    }

    Context "Pipeline Input" {
        
        It "Should process pipeline input from string" {
            $result = "angrb" | Format-UserNames
            $result | Should -Not -BeNullOrEmpty
        }

        It "Should process pipeline input from multiple strings" {
            $result = @("ajaxb", "alexb") | Format-UserNames
            $result.Count | Should -Be 2
        }

        It "Should accept ValueFromPipeline by property name" {
            $obj = [PSCustomObject]@{Key = "applb"}
            $result = $obj | Format-UserNames
            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context "Error Handling" {
        
        It "Should handle non-existent key without error" {
            $result = Format-UserNames -Key "notexist" 2>$null
            $result | Should -BeNullOrEmpty
        }

        It "Should require Key parameter" {
            { Format-UserNames } | Should -Throw
        }

        It "Should handle empty key string gracefully" {
            $result = Format-UserNames -Key "" 2>$null
            $result | Should -BeNullOrEmpty
        }

        It "Should handle null key gracefully" {
            $result = Format-UserNames -Key $null 2>$null
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Data Retrieval" {
        
        It "Should retrieve correct email for ajaxb" {
            $result = Format-UserNames -Key "ajaxb" -Mode "Raw"
            $result.Trim() | Should -Be "aj.axelrod@company.com"
        }

        It "Should retrieve correct email for alexb" {
            $result = Format-UserNames -Key "alexb" -Mode "Raw"
            $result.Trim() | Should -Be "al.exurban@company.com"
        }

        It "Should retrieve correct email for applb" {
            $result = Format-UserNames -Key "applb" -Mode "Raw"
            $result.Trim() | Should -Be "ap.plebian@company.com"
        }

        It "Should retrieve correct email for ashlb" {
            $result = Format-UserNames -Key "ashlb" -Mode "Raw"
            $result.Trim() | Should -Be "as.heilbronner@company.com"
        }

        It "Should retrieve correct email for angrb" {
            $result = Format-UserNames -Key "angrb" -Mode "Raw"
            $result.Trim() | Should -Be "an.gruber@company.com"
        }
    }

    Context "Parameter Validation" {
        
        It "Should have Key parameter as mandatory" {
            $paramInfo = (Get-Command Format-UserNames).Parameters['Key']
            $paramInfo.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] } | 
                Select-Object -First 1 | Select-Object -ExpandProperty Mandatory | Should -Be $true
        }

        It "Should accept string array for Key parameter" {
            $result = Format-UserNames -Key @("ajaxb", "alexb", "applb")
            $result.Count | Should -Be 3
        }

        It "Should accept single string for Key parameter" {
            $result = Format-UserNames -Key "ashlb"
            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context "Output Consistency" {
        
        It "Should return same result for multiple calls with same input" {
            $result1 = Format-UserNames -Key "angrb" -Mode "Raw"
            $result2 = Format-UserNames -Key "angrb" -Mode "Raw"
            $result1 | Should -Be $result2
        }

        It "Should always return lowercase email" {
            $result = Format-UserNames -Key "AJAXB" -Mode "Raw"
            $result | Should -Match "^[^A-Z]*$"
        }

        It "Should maintain email format across modes" {
            $rawResult = Format-UserNames -Key "alexb" -Mode "Raw"
            $yamlResult = Format-UserNames -Key "alexb" -Mode "YAML"
            
            $rawResult.Trim() -match "[a-z.]+@[a-z.]+" | Should -Be $true
            $yamlResult -match "[a-z.]+@[a-z.]+" | Should -Be $true
        }
    }
}
