#include <stdio.h>

void quick_sort(int* a0, int a1);
void quick_sort_wrapper(int* a0, int lo, int a1);
int partition(int* a0, int lo ,int a1);

void quick_sort(int* a0, int a1) {
    a1 = a1 - 1;
    quick_sort_wrapper(a0, 0, a1);
}

void quick_sort_wrapper(int* a0, int t9, int a1) {
    int t8 = t9 < a1;
    if (t8 == 0) goto end_quick_sort;
        int v0 = partition(a0, t9, a1);
        t8 = a1;
        a1 = v0;
        quick_sort_wrapper(a0, t9, v0);
        t9 = a1 + 1;
        a1 = t8;
        quick_sort_wrapper(a0, t9, a1);

        // quick_sort_wrapper(a0, s0, v0 - 1);
        // quick_sort_wrapper(a0, v0 + 1, a1);
    end_quick_sort:
    return;
}

// void quick_sort_wrapper(int* A, int lo, int hi) {
//     if (lo < hi) {
//         int p = partition(A, lo, hi);
//         quick_sort_wrapper(A, lo, p);
//         quick_sort_wrapper(A, p + 1, hi);
//     }
// }

int partition(int* A, int lo, int hi) {
    int pivot = *(A + lo);
    int i = lo - 1;
    int j = hi + 1;
    int temp;
    while (1) {
        do {
            j--;
        } while (*(A + j) > pivot);

        do {
            i++;
        } while (*(A + i) < pivot);
        if (i < j) {
            temp = *(A + i);
            printf("Swapping %i and %i\n", temp, *(A + j));
            *(A + i) = *(A + j);
            *(A + j) = temp;
        }
        else {
            return j;
        }
    }
}

// int partition(int* a0, int t9, int a1) {
//     int t8 = *(a0 + t9);
//     int t0 = t9 - 1; // i
//     int t1 = a1 + 1; // j
//     int* t2;
//     int t3;
//     int* t4;
//     int t5;
//     int t6;

//     parition_while:
//         first_do_while:
//             t1 = t1 - 1;
//             t2 = a0 + t1;
//             t3 = *t2;

//             t6 = t8 < t3;
//             if (t6 != 0) goto first_do_while;

//         second_do_while:
//             t0 = t0 + 1;
//             t4 = a0 + t0;
//             t5 = *t4;
//             t6 = t5 < t8;
//             if (t6 != 0) goto second_do_while;

//         t6 = t0 < t1;
//         if (t6 == 1) goto swap;
//             return t1;
//         swap:
//             printf("Swapping %i and %i\n", t5, t3);
//             *t2 = t5;
//             *t4 = t3;
//             goto parition_while;
// }

int main() {
    int x[] = {515, 531, 797, 563, 770, 643, 681, 949, 658, 538};
    // int x[] = {5, 4, 3, 2, 1};
    quick_sort((int*)x, 10);
    for (int i=0; i < 10; i++) {
        printf("%i, ", x[i]);
    }
    printf("\n");
    return 0;
}