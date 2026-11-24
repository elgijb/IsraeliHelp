package il.israelihelp.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Автоматические тесты для PasswordHasher.
 * Запуск: ./mvnw test
 */
class PasswordHasherTest {

    @Test
    void correctPasswordIsAccepted() {
        String stored = PasswordHasher.hash("Secret123!");
        assertTrue(PasswordHasher.verify("Secret123!", stored));
    }

    @Test
    void wrongPasswordIsRejected() {
        String stored = PasswordHasher.hash("Secret123!");
        assertFalse(PasswordHasher.verify("secret123!", stored));
        assertFalse(PasswordHasher.verify("", stored));
    }

    @Test
    void samePasswordGivesDifferentHashesBecauseOfSalt() {
        assertNotEquals(PasswordHasher.hash("Secret123!"), PasswordHasher.hash("Secret123!"));
    }

    @Test
    void hashDoesNotContainPlainPassword() {
        assertFalse(PasswordHasher.hash("Secret123!").contains("Secret123!"));
    }

    @Test
    void unicodePasswordWorks() {
        String stored = PasswordHasher.hash("סיסמה-Пароль-1");
        assertTrue(PasswordHasher.verify("סיסמה-Пароль-1", stored));
    }

    @Test
    void malformedStoredValueIsRejected() {
        assertFalse(PasswordHasher.verify("x", null));
        assertFalse(PasswordHasher.verify(null, "pbkdf2$1$AA==$AA=="));
        assertFalse(PasswordHasher.verify("x", "plain-text-password"));
        assertFalse(PasswordHasher.verify("x", "pbkdf2$notanumber$AA==$AA=="));
        assertFalse(PasswordHasher.verify("x", "pbkdf2$1000$!!!$AA=="));
    }
}
