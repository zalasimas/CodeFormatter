# Set the path to your clang-format executable
$ClangFormat = "C:\Program Files\LLVM\bin\clang-format.exe"

# Set the path to your .clang-format file (assuming it's in the same directory as the script)
$ClangFormatStyle = Join-Path $PSScriptRoot ".clang-format"

# Find all C and header files (or any others) in the project folder
$Files = Get-ChildItem -Recurse -Path .\MyProjectDirectory\ -Include *.c,*.h

# Initialize variables to track formatting status
$formattingNeeded = $false
$alreadyFormatted = $false

# Iterate over each file
foreach ($File in $Files) {
    # Check if the file needs formatting
    $Replacements = & $ClangFormat -style "file" -output-replacements-xml $File.FullName

    # Check if $Replacements is not null, not an empty array, and contains replacements
    if ($Replacements -ne $null -and $Replacements.Length -gt 0 -and $Replacements -match '<replacement ') {
        Write-Host "Formatting: $($File.FullName)" -ForegroundColor Red
        & $ClangFormat -style "file" -i $File.FullName
        $formattingNeeded = $true
    } else {
        Write-Host "Already formatted: $($File.FullName)" -ForegroundColor Green
        $alreadyFormatted = $true
    }
}

# Display overall formatting status
if ($formattingNeeded) {
    Write-Host "Formatting check complete. Some files needed formatting." -ForegroundColor Red
} elseif ($alreadyFormatted) {
    Write-Host "Formatting check complete. All files are already formatted." -ForegroundColor Green
} else {
    Write-Host "No files found for formatting." -ForegroundColor Yellow
}
