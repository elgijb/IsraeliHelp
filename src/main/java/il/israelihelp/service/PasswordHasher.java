package il.israelihelp.service;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Безопасное хеширование паролей.
 *
 * Пароль НИКОГДА не хранится в базе в открытом виде. Вместо него хранится строка вида
 *     pbkdf2$210000$<соль в Base64>$<хеш в Base64>
 *
 * Как это работает:
 *  1. Для каждого пароля генерируется случайная "соль" (16 случайных байт).
 *     Поэтому у двух пользователей с одинаковым паролем хеши всё равно разные.
 *  2. Алгоритм PBKDF2 с HMAC-SHA256 прогоняет пароль + соль 210 000 раз.
 *     Это специально медленно: подбор пароля перебором становится очень долгим.
 *  3. При входе берём соль из сохранённой строки, считаем хеш введённого пароля
 *     тем же способом и сравниваем с сохранённым.
 *
 * Всё это встроено в Java (javax.crypto), дополнительные библиотеки не нужны.
 */
public final class PasswordHasher {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String PREFIX = "pbkdf2";
    private static final int ITERATIONS = 210_000;
    private static final int SALT_BYTES = 16;
    private static final int HASH_BITS = 256;

    // SecureRandom — криптографически стойкий генератор случайных чисел (в отличие от Random)
    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordHasher() {
        // Утилитный класс: только статические методы, объекты создавать не нужно
    }

    /** Возвращает строку для сохранения в колонку users.password_hash. */
    public static String hash(String password) {
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        byte[] hash = pbkdf2(password.toCharArray(), salt, ITERATIONS);

        Base64.Encoder b64 = Base64.getEncoder();
        return PREFIX + "$" + ITERATIONS + "$" + b64.encodeToString(salt) + "$" + b64.encodeToString(hash);
    }

    /** Проверяет, подходит ли введённый пароль к сохранённому хешу. */
    public static boolean verify(String password, String stored) {
        if (password == null || stored == null) {
            return false;
        }
        String[] parts = stored.split("\\$");
        if (parts.length != 4 || !PREFIX.equals(parts[0])) {
            return false;
        }
        try {
            int iterations = Integer.parseInt(parts[1]);
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            byte[] actual = pbkdf2(password.toCharArray(), salt, iterations);
            // MessageDigest.isEqual сравнивает за одинаковое время,
            // чтобы по скорости ответа нельзя было угадывать хеш
            return MessageDigest.isEqual(expected, actual);
        } catch (IllegalArgumentException e) {
            // Неверный формат числа или Base64 — считаем пароль неподходящим
            return false;
        }
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations) {
        PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, HASH_BITS);
        try {
            return SecretKeyFactory.getInstance(ALGORITHM).generateSecret(spec).getEncoded();
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("PBKDF2 is not available in this Java", e);
        } finally {
            spec.clearPassword();
        }
    }

    /**
     * Вспомогательный запуск из терминала — чтобы получить хеш для database/sample_data.sql:
     *     java -cp target/classes il.israelihelp.service.PasswordHasher "Пароль"
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java -cp target/classes il.israelihelp.service.PasswordHasher <password>");
            return;
        }
        System.out.println(hash(args[0]));
    }
}
