package il.israelihelp.service;

import il.israelihelp.model.Category;
import il.israelihelp.model.City;
import il.israelihelp.model.Event;
import il.israelihelp.model.EventStatus;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.EnumMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Временный каталог мероприятий для этапа 3 (frontend).
 * Данные совпадают с database/sample_data.sql.
 * На этапе 5 этот класс заменит EventDao + EventService с MySQL.
 */
public final class DemoCatalog {

    private static final List<Event> ALL = build();

    private DemoCatalog() {}

    public static List<Event> all() {
        return List.copyOf(ALL);
    }

    public static Optional<Event> findById(int id) {
        return ALL.stream().filter(e -> e.getId() == id).findFirst();
    }

    /** Ближайшие открытые (или FULL) будущие мероприятия для главной. */
    public static List<Event> upcoming(int limit) {
        LocalDateTime now = LocalDateTime.now();
        return ALL.stream()
                .filter(e -> e.getStatus() == EventStatus.OPEN || e.getStatus() == EventStatus.FULL)
                .filter(e -> e.getEventDate().isAfter(now))
                .sorted(Comparator.comparing(Event::getEventDate))
                .limit(limit)
                .collect(Collectors.toList());
    }

    public static Map<City, Long> openCountByCity() {
        Map<City, Long> map = new EnumMap<>(City.class);
        for (City c : City.values()) {
            map.put(c, 0L);
        }
        ALL.stream()
                .filter(e -> e.getStatus() == EventStatus.OPEN)
                .forEach(e -> map.merge(e.getCity(), 1L, Long::sum));
        return map;
    }

    public static long openCount() {
        return ALL.stream().filter(e -> e.getStatus() == EventStatus.OPEN).count();
    }

    /**
     * Фильтрация каталога.
     * @param q поиск по названию (без учёта регистра)
     * @param city код города или null/пусто
     * @param categories коды категорий (может быть пустым = все)
     * @param openOnly только OPEN
     */
    public static List<Event> filter(String q, String city, List<String> categories, boolean openOnly) {
        String query = q == null ? "" : q.trim().toLowerCase(Locale.ROOT);
        return ALL.stream()
                .filter(e -> e.getStatus() != EventStatus.COMPLETED) // прошедшие скрываем из каталога по умолчанию
                .filter(e -> !openOnly || e.getStatus() == EventStatus.OPEN)
                .filter(e -> city == null || city.isBlank() || e.getCity().name().equalsIgnoreCase(city))
                .filter(e -> categories == null || categories.isEmpty()
                        || categories.stream().anyMatch(c -> e.getCategory().name().equalsIgnoreCase(c)))
                .filter(e -> query.isEmpty() || e.getTitle().toLowerCase(Locale.ROOT).contains(query)
                        || e.getDescription().toLowerCase(Locale.ROOT).contains(query))
                .sorted(Comparator.comparing(Event::getEventDate))
                .collect(Collectors.toList());
    }

    /** Группировка по "yyyy-MM" для заголовков месяцев в каталоге. */
    public static Map<String, List<Event>> groupByMonth(List<Event> events) {
        Map<String, List<Event>> map = new LinkedHashMap<>();
        for (Event e : events) {
            String key = String.format("%04d-%02d", e.getEventDate().getYear(), e.getEventDate().getMonthValue());
            map.computeIfAbsent(key, k -> new ArrayList<>()).add(e);
        }
        return map;
    }

    public static Map<Category, Long> countsByCategory() {
        Map<Category, Long> map = new EnumMap<>(Category.class);
        for (Category c : Category.values()) {
            map.put(c, 0L);
        }
        ALL.stream()
                .filter(e -> e.getStatus() != EventStatus.COMPLETED && e.getStatus() != EventStatus.CANCELLED)
                .forEach(e -> map.merge(e.getCategory(), 1L, Long::sum));
        return map;
    }

    private static List<Event> build() {
        List<Event> list = new ArrayList<>();
        list.add(ev(1, "Food package sorting before Hanukkah",
                "Help sort and pack food boxes for families in need ahead of Hanukkah. No experience required; work in teams of four. Comfortable shoes recommended.",
                Category.FOOD, City.JERUSALEM, "Food bank warehouse, Talpiot industrial area",
                LocalDateTime.of(2026, 12, 10, 9, 0), 25, 1, EventStatus.OPEN, "food.jpg"));
        list.add(ev(2, "Weekly visits to senior citizens",
                "Spend an afternoon with elderly residents: conversation, board games and help with small everyday tasks. Basic Hebrew, Russian or English is enough.",
                Category.ELDERLY, City.HAIFA, "Senior day center, Hadar neighborhood",
                LocalDateTime.of(2026, 12, 14, 16, 0), 8, 0, EventStatus.OPEN, "elderly.jpg"));
        list.add(ev(3, "Beach cleanup at Gordon Beach",
                "Join a morning beach cleanup. Gloves and bags are provided. Suitable for families with children over 10.\n\nWe meet next to the lifeguard station and work in small groups along the shore for about two hours. At the end, the collected waste is sorted for recycling.",
                Category.ENVIRONMENT, City.TEL_AVIV, "Gordon Beach, near the lifeguard station",
                LocalDateTime.of(2026, 12, 19, 8, 0), 40, 0, EventStatus.OPEN, "environment.jpg"));
        list.add(ev(4, "Homework help for elementary school students",
                "Help children in grades 2–6 with homework in math and English twice a week. Volunteers commit for at least one month.",
                Category.CHILDREN, City.BEER_SHEVA, "Community center, Neighborhood Dalet",
                LocalDateTime.of(2027, 1, 5, 15, 30), 10, 0, EventStatus.OPEN, "children.jpg"));
        list.add(ev(5, "Care packages for soldiers",
                "Prepare care packages with snacks, socks and handwritten letters for soldiers on duty.",
                Category.SOLDIERS, City.RISHON_LEZION, "Municipal hall, Rothschild Street",
                LocalDateTime.of(2026, 12, 22, 18, 0), 30, 0, EventStatus.OPEN, "soldiers.jpg"));
        list.add(ev(6, "Animal shelter weekend",
                "Walk dogs, clean enclosures and help with feeding at the city animal shelter. Volunteers must be 16 or older.",
                Category.ANIMALS, City.PETAH_TIKVA, "Animal shelter, Kiryat Aryeh",
                LocalDateTime.of(2027, 1, 9, 10, 0), 12, 0, EventStatus.OPEN, "animals.jpg"));
        list.add(ev(7, "Blood donation day — registration desk",
                "Assist the medical team at a blood donation drive: greet donors, help with registration and hand out refreshments.",
                Category.HEALTH, City.NETANYA, "City sports hall, Herzl Street",
                LocalDateTime.of(2027, 1, 17, 11, 0), 6, 0, EventStatus.OPEN, "health.jpg"));
        list.add(ev(8, "Community garden planting",
                "Plant herbs and vegetables in a new neighborhood community garden. Tools are provided.",
                Category.ENVIRONMENT, City.ASHDOD, "Community garden, City district 7",
                LocalDateTime.of(2027, 2, 2, 9, 30), 15, 0, EventStatus.OPEN, "environment.jpg"));
        list.add(ev(9, "Shabbat meals delivery",
                "Deliver warm Shabbat meals to lonely elderly residents. A car is an advantage but not required.",
                Category.FOOD, City.HOLON, "Distribution point, Sokolov Street",
                LocalDateTime.of(2026, 12, 25, 11, 0), 2, 2, EventStatus.FULL, "food.jpg"));
        list.add(ev(10, "Purim costume workshop for kids",
                "Help children create Purim costumes and masks from recycled materials.",
                Category.CHILDREN, City.JERUSALEM, "Neighborhood library, Katamon",
                LocalDateTime.of(2027, 3, 15, 16, 0), 8, 0, EventStatus.OPEN, "children.jpg"));
        list.add(ev(11, "Desert trail cleanup",
                "Clean a popular hiking trail near Eilat. Transportation from the city center is organized.",
                Category.ENVIRONMENT, City.EILAT, "Meeting point: central bus station",
                LocalDateTime.of(2027, 2, 20, 7, 30), 20, 0, EventStatus.CANCELLED, "environment.jpg"));
        list.add(ev(12, "Neighborhood repair day",
                "Help repaint benches and fix playground equipment together with neighbors.",
                Category.COMMUNITY, City.TEL_AVIV, "Neighborhood park, Yad Eliyahu",
                LocalDateTime.of(2026, 10, 30, 9, 0), 20, 1, EventStatus.COMPLETED, "community.jpg"));
        return list;
    }

    private static Event ev(int id, String title, String description, Category category, City city,
                            String address, LocalDateTime date, int required, int approved,
                            EventStatus status, String image) {
        Event e = new Event();
        e.setId(id);
        e.setTitle(title);
        e.setDescription(description);
        e.setCategory(category);
        e.setCity(city);
        e.setAddress(address);
        e.setEventDate(date);
        e.setRequiredVolunteers(required);
        e.setApprovedVolunteers(approved);
        e.setStatus(status);
        e.setImage(image);
        e.setCreatedAt(LocalDateTime.of(2026, 11, 24, 12, 0));
        return e;
    }
}
