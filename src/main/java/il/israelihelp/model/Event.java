package il.israelihelp.model;

import java.time.LocalDateTime;

/**
 * Мероприятие. Поля соответствуют таблице events.
 * На этапе 3 данные пока берутся из DemoCatalog (без MySQL).
 * На этапе 5 тот же класс будет заполняться через EventDao.
 */
public class Event {

    private int id;
    private String title;
    private String description;
    private Category category;
    private City city;
    private String address;
    private LocalDateTime eventDate;
    private int requiredVolunteers;
    private int approvedVolunteers; // сколько заявок уже одобрено (из applications)
    private EventStatus status;
    private String image; // имя файла, например environment.jpg
    private LocalDateTime createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public City getCity() { return city; }
    public void setCity(City city) { this.city = city; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public LocalDateTime getEventDate() { return eventDate; }
    public void setEventDate(LocalDateTime eventDate) { this.eventDate = eventDate; }

    public int getRequiredVolunteers() { return requiredVolunteers; }
    public void setRequiredVolunteers(int requiredVolunteers) { this.requiredVolunteers = requiredVolunteers; }

    public int getApprovedVolunteers() { return approvedVolunteers; }
    public void setApprovedVolunteers(int approvedVolunteers) { this.approvedVolunteers = approvedVolunteers; }

    public EventStatus getStatus() { return status; }
    public void setStatus(EventStatus status) { this.status = status; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    /** Процент заполненности для полоски (0–100). */
    public int getFillPercent() {
        if (requiredVolunteers <= 0) {
            return 0;
        }
        return Math.min(100, (int) Math.round(100.0 * approvedVolunteers / requiredVolunteers));
    }

    public int getSpotsLeft() {
        return Math.max(0, requiredVolunteers - approvedVolunteers);
    }
}
