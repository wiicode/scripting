$msgBoxInput =  [System.Windows.MessageBox]::Show('Postpone shutdown by 55 minutes?','ProServ Timer','YesNoCancel','Error')

  switch  ($msgBoxInput) {

  'Yes' {

  ## Do something
  shutdown -a
  shutdown -s -t 3300

  }

  'No' {

  ## Do something
  shutdown -s -t 10

  }

  'Cancel' {

  ## Do something
  shutdown -s -t 10

  }

  }
