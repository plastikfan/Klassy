Import-Module .\Output\Elizium.Shelly\Elizium.Shelly.psm1

Describe 'UndoRename' {
  BeforeEach {
    InModuleScope Elizium.Shelly {
      [string]$script:_path = "$TestDrive\undo-script.ps1";
      [PoShShell]$script:_shell = [PoShShell]::new($_path);
      [Undo]$script:_undoRename = [UndoRename]::new($_shell);
    }
  }

  AfterEach {
    InModuleScope Elizium.Shelly {
      if (Test-Path -LiteralPath $_path) {
        Remove-Item -LiteralPath $_path;
      }
    }
  }

  Context 'given: PoShShell' {
    It 'should: generate undo rename operations' {
      InModuleScope Elizium.Shelly {
        [PSCustomObject[]]$operations = @(
          [PSCustomObject]@{
            From = "$TestDrive\one-old.txt";
            To   = 'one-new.txt';
          },

          [PSCustomObject]@{
            From = "$TestDrive\two-old.txt";
            To   = 'two-new.txt';
          },

          [PSCustomObject]@{
            From = "$TestDrive\three-old.txt";
            To   = 'three-new.txt';
          }
        )

        $operations | ForEach-Object {
          $_undoRename.alert($_);
        }

        [string]$content = $_undoRename.generate();
        $content | Should -Match "one-old\.txt";
        $content | Should -Match "two-old\.txt";
        $content | Should -Match "three-old\.txt";
        $content | Should -Match "one-new\.txt";
        $content | Should -Match "two-new\.txt";
        $content | Should -Match "three-new\.txt";
      }
    }
  }
}