#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <immintrin.h>

int main(int argc, char * argv[]) {
    if (argc != 4) {
        printf("./capacity_test num_cache_lines stride_power write\n");
        return 0;
    }
    long num_cache_lines = atol(argv[1]);
    int stride_power = atoi(argv[2]);
    int write = atoi(argv[3]);

    // BEGIN capacity test
    int num_trials = 1000;
    int count_success = 0;
    for (int trial = 0; trial < num_trials; trial++) {
        // create the array to read/write
        int stride = 1<<stride_power;
        int array_length = (8*num_cache_lines) * stride;
        unsigned long *x_array = aligned_alloc(64, sizeof(unsigned long)*array_length);
        for (int i = 0; i < array_length; i++) {
            x_array[i] = (unsigned long) i;
        }

        // run the transaction 
        unsigned long dummy_var = 1337;
        int j;
        unsigned int status = _xbegin();
        if (status == _XBEGIN_STARTED) {
            for (j = 0; j < num_cache_lines; j++) {
                if (write) {
                    x_array[(8*j) * stride] = dummy_var;
                }
                else {
                    dummy_var = x_array[(8*j) * stride];
                }
            }
            _xend();
            count_success++;
        }

        // free the array
        free(x_array);
    }
    printf("completed %d/%d\n", count_success, num_trials);
    // END capacity test

    return 0;
}








