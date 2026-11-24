package il.israelihelp.model;

/**
 * Категория помощи. В базе хранится код (name()),
 * а название на языке пользователя берётся из i18n: category.FOOD и т.д.
 */
public enum Category {
    FOOD,
    ELDERLY,
    CHILDREN,
    ENVIRONMENT,
    SOLDIERS,
    ANIMALS,
    HEALTH,
    COMMUNITY;

    /** Имя файла картинки в /img/events/ */
    public String imageFile() {
        return switch (this) {
            case FOOD -> "food.jpg";
            case ELDERLY -> "elderly.jpg";
            case CHILDREN -> "children.jpg";
            case ENVIRONMENT -> "environment.jpg";
            case SOLDIERS -> "soldiers.jpg";
            case ANIMALS -> "animals.jpg";
            case HEALTH -> "health.jpg";
            case COMMUNITY -> "community.jpg";
        };
    }

    /** Имя свойства для JSP: ${category.messageKey} → getMessageKey(). */
    public String getMessageKey() {
        return "category." + name();
    }
}
