package com.oltpbenchmark.benchmarks.ssb;

import com.oltpbenchmark.util.RandomGenerator;

public class SSBUtil {
    /**
     * Returns a random element of the array
     *
     * @param array
     * @param rand
     * @param <T>
     * @return a random element of the array
     */
    public static <T> T choice(T[] array, RandomGenerator rand) {
        return array[rand.number(1, array.length) - 1];
    }
}
