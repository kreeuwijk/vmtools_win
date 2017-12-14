function vmtools_win::compare_version(String $givenversion, String $desiredversion) {
  # This function compares two provided version numbers (dot-seperated) and returns
  # the lowest level at which they differ and in which direction
  #
  # Example:
  #  vmtools_win::compare_version('10.1.5.5051234', '10.1.7.5541682')
  #
  #  returns: { 'lower' => 3 }
  #
  #  This signifies that the 3rd level of the given version ('5') is lower than the
  #  desired version ('7'), with all previous levels being the same

  #Split given version into levels of numbers
  $arrgivenversion   = split($givenversion, '[.]')
  $arrdesiredversion = split($desiredversion, '[.]')

  #Determine size of arrays and use smallest size for comparison
  $lenarrgiven   = size($arrgivenversion)
  $lenarrdesired = size($arrdesiredversion)

  $levelstocompare = min($lenarrgiven, $lenarrdesired) - 1

  $level = $arrgivenversion.reduce(0) |$memo, $value| {
    if $arrgivenversion[$memo] == $arrdesiredversion[$memo] {
      if $memo == $levelstocompare {
        $memo
      }
      else {
        $memo + 1
      }
    }
    else {
      $memo
    }
  }

  if $arrgivenversion[$level] == $arrdesiredversion[$level] {
    $direction = 'Equal'
  }
  elsif (0 + $arrgivenversion[$level]) > (0 + $arrdesiredversion[$level]) {
    $direction = 'Higher'
  }
  elsif (0 + $arrgivenversion[$level]) < (0 + $arrdesiredversion[$level]) {
    $direction = 'Lower'
  }
  else {
    $direction = 'Error'
  }

  $hash = {$direction => $level + 1}
  $hash
}
