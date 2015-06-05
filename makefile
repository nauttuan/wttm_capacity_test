opt0: capacity_test.c
	gcc -std=gnu99 -mrtm -O0 -o capacity_test capacity_test.c

opt1: capacity_test.c
	gcc -std=gnu99 -mrtm -O1 -o capacity_test capacity_test.c

opt2: capacity_test.c
	gcc -std=gnu99 -mrtm -O2 -o capacity_test capacity_test.c

opt3: capacity_test.c
	gcc -std=gnu99 -mrtm -O3 -o capacity_test capacity_test.c

.PHONY: clean

clean: 
	rm -f capacity_test



