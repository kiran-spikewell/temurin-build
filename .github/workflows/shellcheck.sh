name: Shell Script Code Scan

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  shell_lint:
    runs-on: ubuntu-latest
    steps:
    - name: Check out code
      uses: actions/checkout@v4.1.1
    
    - name: Install ShellCheck
      run: sudo apt-get install -y shellcheck

    - name: Run ShellCheck
      run: |
        find . -name "*.sh" -print0 | xargs -0 shellcheck -f gcc

    - name: Install shfmt
      run: |
        sudo apt-get install -y golang-go
        go install mvdan.cc/sh/v3/cmd/shfmt@latest

    - name: Run shfmt
      run: |
        find . -name "*.sh" -print0 | xargs -0 shfmt -d

    - name: Upload ShellCheck Results
      uses: github/codeql-action/upload-sarif@v2
      with:
        sarif_file: results.sarif
