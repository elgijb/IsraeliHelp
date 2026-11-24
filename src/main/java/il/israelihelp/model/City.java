package il.israelihelp.model;

/** Город Израиля. Код хранится в базе, название — в i18n: city.TEL_AVIV. */
public enum City {
    JERUSALEM,
    TEL_AVIV,
    HAIFA,
    BEER_SHEVA,
    RISHON_LEZION,
    PETAH_TIKVA,
    NETANYA,
    ASHDOD,
    HOLON,
    EILAT;

    /** Имя свойства для JSP: ${city.messageKey} → getMessageKey(). */
    public String getMessageKey() {
        return "city." + name();
    }
}
