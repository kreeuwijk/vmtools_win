function vmtools_win::compare_version(String $givenversion, String $desiredversion) >> Hash {
  #This function compares two provided version numbers (dot-seperated) and returns the lowest level at which they differ and in which direction
  #Example:
  #  vmtools_win::compare_version('10.1.5.5051234', '10.1.7.5541682')
  #
  #  returns: { 'lower' => 3 }
  #  This signifies that the 3rd level of the given version ('5') is lower than the desired version ('7'), with all previous levels being the same

  #Split given version into levels of numbers
  $arrGivenversion   = split($givenversion, '[.]')
  $arrDesiredversion = split($desiredversion, '[.]')

  #Determine size of arrays and use smallest size for comparison
  $lenArrGiven   = size($arrGivenversion)
  $lenArrDesired = size($arrDesiredversion)

  $levelstocompare = min($lenArrGiven, $lenArrDesired) - 1

  $level = $arrGivenversion.reduce(0) |$memo, $value| {
    if $arrGivenversion[$memo] == $arrDesiredversion[$memo] {
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

  if $arrGivenversion[$level] == $arrDesiredversion[$level] {
    $direction = "Equal"
  }
  elsif (0 + $arrGivenversion[$level]) > (0 + $arrDesiredversion[$level]) {
    $direction = "Higher"
  }
  elsif (0 + $arrGivenversion[$level]) < (0 + $arrDesiredversion[$level]) {
    $direction = "Lower"
  }
  else {
   $direction = "Error" 
  }

  $hash = {$direction => $level + 1}
  $hash 
}
