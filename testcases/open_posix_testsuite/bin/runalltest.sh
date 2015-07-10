#! /bin/sh 
# Copyright (c) 2002, Intel Corporation. All rights reserved.
# Created by:  julie.n.fleischer REMOVE-THIS AT intel DOT com
# This file is licensed under the GPL license.  For the full content
# of this license, see the COPYING file at the top level of this
# source tree.
#
# Use to build and run tests for a specific area

BASEDIR="$(dirname "$0")/../"


run_option_group_tests()
{
	for test_script in $(find $BASEDIR -name *run-test); do
		(cd "$(dirname "$test_script")" &&./$(basename "$test_script"))
		RET=$?		
		if   [ $RET -eq 0 ]; then
			echo $(basename "$test_script") "PASS"
		elif [ $RET -eq 1 ]; then 
		    echo $(basename "$test_script") "FAIL"
		elif [ $RET -eq 2 ]; then 
		    echo $(basename "$test_script") "UNRESOLVED"			
		elif [ $RET -eq 4 ]; then 
		    echo $(basename "$test_script") "UNSUPPORTED"	
		elif [ $RET -eq 5 ]; then 
		    echo $(basename "$test_script") "UNTESTED"				
		fi
	done
}

run_option_group_tests

