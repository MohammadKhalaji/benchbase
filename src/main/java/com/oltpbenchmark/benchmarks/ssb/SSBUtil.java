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

    // 25 possible categories
    public static String generateRandomCategory(RandomGenerator rand) {
        int firstCatDigit = rand.number(1, 5);
        int secondCatDigit = rand.number(1, 5);
        return String.format("MFGR#%d%d", firstCatDigit, secondCatDigit);
    }

    // 40 possible brands per category 
    public static String genrateRandomBrandForCategory(String category, RandomGenerator rand) {
        int forty = rand.number(1, 40);
        return String.format("%s%02d", category, forty);
    }
}
