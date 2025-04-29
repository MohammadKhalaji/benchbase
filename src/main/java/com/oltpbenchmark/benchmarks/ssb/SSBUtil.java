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

    // 7 possible years
    public static int generateRandomYear(RandomGenerator rand) {
        return rand.number(1992, 1998);
    }

    public static int generateRandomYearRangeStart(int offset, RandomGenerator rand) {
        return rand.number(1992, 1998 - offset);
    }

    // 12 possible months
    public static int generateRandomMonth(RandomGenerator rand) {
        return rand.number(1, 12);
    }

    public static int generateRandomWeek(RandomGenerator rand) {
        return rand.number(1, 53);
    }

    public static int generateRandomDiscount(RandomGenerator rand) {
        return rand.number(0, 10);
    }

    // Usually offset = 1
    public static int generateRandomDiscountRangeCenter(int offset, RandomGenerator rand) {
        return rand.number(0 + offset, 10 - offset);
    } 

    public static int generateRandomQuantity(RandomGenerator rand) {
        return rand.number(1, 50);
    }

    public static int generateRandomQuantityRangeStart(int offset, RandomGenerator rand) {
        return rand.number(1, 50 - offset);
    }

    public static String getNationPrefix(String nation) {
        // The first 9 characters of the nation name
        // are the prefix of the city name
        // e.g. "UNITED STATES" -> "UNITED ST"
        // e.g. "UNITED KINGDOM" -> "UNITED KI"
        if (nation.length() <= 9) {
            return nation;
        }
        return nation.substring(0, 9);
    }

    public static String generateRandomCityInNation(String nation, RandomGenerator rand) {
        return String.format("%s%d", getNationPrefix(nation), rand.number(0, 9));
    }

    public static int getYearMonthNumber(int year, int month) {
        return year * 100 + month;
    }

    public static String getMonthShortString(int month) {
        switch (month) {
            case 1:
                return "Jan";
            case 2:
                return "Feb";  
            case 3:
                return "Mar";
            case 4:
                return "Apr";
            case 5:
                return "May";
            case 6:
                return "Jun";
            case 7:
                return "Jul";
            case 8:
                return "Aug";
            case 9:
                return "Sep";
            case 10:
                return "Oct";
            case 11:
                return "Nov";
            case 12:
                return "Dec";
            default: 
                throw new IllegalArgumentException("Invalid month: " + month);
        }
    }

    public static String getYearMonth(int year, int month) {
        return String.format("%s%d", getMonthShortString(month), year);
    }

    public static String generateRandomMfgr(RandomGenerator rand) {
        return String.format("MFGR#%d", rand.number(1, 5));
    }
}
