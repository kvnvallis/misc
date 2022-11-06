import java.lang.Math;


/* 

Count in binary based on set number of bits. First calculate number of values, loop while i is less than values and increment i. Start a new loop tracking bits. For the first bit, the bit value is 2^1. Modulate i using the bit value, and check if the result is greater than or equal to half the bit value. Return 1 if true, 0 is false.

The counter variable `values` is counting in base 10. Those values are modulated with the max number of base 2 values which can be stored in the current bit. Divide by 2 in order to check how far we have counted. If we're still in the first half of possible values for the current bit, return 0. If we're in the second half, return 1. The principle is best demonstrated visually. Here is the output for all the 3 bit numbers.

000
001
010
011
100
101
110
111

*/


class Binary {
    public static void main(String[] args) {
        int bits = 8;
        int[] digits = new int[bits];
        int values = (int) Math.pow(2, bits);
        int bitValue;
        String number;

        int i = 0;
        while (i < values) {

            // First binary digit gets assigned to index 0
            for (int b=0; b<bits; b++) {
                bitValue = (int) Math.pow(2, b+1);
                digits[b] = (i % bitValue >= bitValue / 2) ? 1 : 0;
            }

            // Print array in reverse
            number = "";
            for (int d=digits.length-1; d>=0; d--) {
                number = number + String.valueOf(digits[d]);
            }

            System.out.println(number);
            ++i;
        }
    }
}

