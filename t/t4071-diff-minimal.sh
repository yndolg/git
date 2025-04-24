#!/bin/sh

test_description='minimal diff algorithm'

. ./test-lib.sh

test_expect_success 'minimal diff should not mark changes between changed lines' '
	printf "x\nx\nx\nx\n" >pre &&
	printf "x\nx\nx\nA\nB\nC\nD\nx\nE\nF\nG\n" >post &&
	test_must_fail git diff --no-index \
		--minimal pre post >diff &&
	! grep "+x" diff &&
	! grep "-x" diff
'

test_done
