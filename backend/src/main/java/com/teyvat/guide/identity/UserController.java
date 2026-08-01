package com.teyvat.guide.identity;

import com.teyvat.guide.common.ApiResponse;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.time.LocalDate;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/api/users/me")
public class UserController {
    private final StringRedisTemplate redis;
    private final Map<String, Boolean> fallback = new ConcurrentHashMap<>();

    public UserController(StringRedisTemplate redis) { this.redis = redis; }

    @GetMapping
    public ApiResponse<Map<String, Object>> me() {
        return ApiResponse.ok(Map.of("id", 10001L, "nickname", "旅行者", "region", "蒙德", "level", 32));
    }

    @PostMapping("/sign-ins")
    public ApiResponse<Map<String, Object>> signIn() {
        String key = "teyvat:dev:sign:10001:" + LocalDate.now().getYear();
        String field = LocalDate.now().toString();
        boolean first;
        try {
            first = Boolean.TRUE.equals(redis.opsForHash().putIfAbsent(key, field, "1"));
            redis.expire(key, Duration.ofDays(730));
        } catch (RuntimeException unavailable) {
            first = fallback.putIfAbsent(field, true) == null;
        }
        return ApiResponse.ok(Map.of("signed", true, "firstTime", first, "streak", 7));
    }
}

