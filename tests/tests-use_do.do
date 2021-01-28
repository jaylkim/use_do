/***

Tests for use_do command in use_do.ado
======================================

***/


cap program drop use_do

do use_do.ado

// Test 1
cap program drop test1
program define test1 

  disp as txt "Test 1 started ... "

  qui cd "tests"
  cap mkdir "temp_tests"
  qui cd "temp_tests"

  use_do test1

  cap confirm file "test1.do"

  if _rc == 0 {
    disp as res "Test 1: Passed!"
    erase "test1.do"
    qui cd ..
    rmdir "temp_tests"
    qui cd ..
  }
  else {
    disp as err "Test 1: Failed!"
    erase "test1.do"
    qui cd ..
    rmdir "temp_tests"
    qui cd ..
  }
  
  qui cd ..

end

test1
