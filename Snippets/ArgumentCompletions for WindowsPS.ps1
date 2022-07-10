﻿# are we running in Windows PowerShell?
if ($PSVersionTable.PSEdition -ne 'Core') {
  # add the attribute [ArgumentCompletions()]:
  $code = @'
using System;
using System.Collections.Generic;
using System.Management.Automation;

    public class ArgumentCompletionsAttribute : ArgumentCompleterAttribute
    {

        private static ScriptBlock _createScriptBlock(params string[] completions)
        {
            string text = "\"" + string.Join("\",\"", completions) + "\"";
            string code = "param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams);@(" + text + ") -like \"*$WordToComplete*\" | Foreach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_) }";
            return ScriptBlock.Create(code);
        }

        public ArgumentCompletionsAttribute(params string[] completions) : base(_createScriptBlock(completions))
        {
        }
    }
'@

  $null = Add-Type -TypeDefinition $code *>&1
}

# Allows you to use [ArgumentCompletions] block native to PowerShell 6 and later!

function Get-Country {
  param
  (
    # suggest today, yesterday, and last week:
    [ArgumentCompletions('USA', 'Germany', 'Norway', 'Sweden', 'Austria', 'YouNameIt')]
    [string]
    $Name
  )

  # return parameter
  $PSBoundParameters
}

#NOTE: This does not work if ScriptBlocks are used to determine the values