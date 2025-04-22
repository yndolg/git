#!/bin/sh

test_description='minimal diff algorithm'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-diff-alternative.sh

test_expect_success '--ignore-space-at-eol with a single appended character' '
	printf "a\nb\nc\n" >pre &&
	printf "a\nbX\nc\n" >post &&
	test_must_fail git diff --no-index \
		--minimal --ignore-space-at-eol pre post >diff &&
	grep "^+.*X" diff
'

test_expect_success 'minimal diff should only remove lines between common parts' '
	# Create test files where the first lines are the same
	cat >old <<-\EOF &&
	x
	x
	x
	A
	B
	C
	D
	x
	E
	F
	G
	EOF
	
	cat >new <<-\EOF &&
	x
	x
	x
	x
	EOF
	
	# A truly minimal diff would not add and remove the 4th "x",
	# but only remove the uppercase letters (and the "x" between D and E).
	# The expected output for a proper minimal algorithm would be:
	cat >expect <<-\EOF &&
	@@ -3,9 +3,1 @@
	 x
	-A
	-B
	-C
	-D
	-x
	-E
	-F
	-G
	 x
	EOF
	
	# Run diff and see if it only removes uppercase letters
	test_must_fail git diff --no-index --minimal old new >actual &&
	grep -e "^@@" -e "^ x$" -e "^-[A-G]$" -e "^-x$" actual >actual_content &&
	test_cmp expect actual_content
'

test_diff_frobnitz "minimal"

test_diff_unique "minimal"

test_done