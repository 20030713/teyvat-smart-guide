package com.teyvat.guide.common;

import java.time.Instant;
import java.util.UUID;

public record ApiResponse<T>(String code, String message, T data, String requestId, Instant timestamp) {
    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>("OK", "success", data, UUID.randomUUID().toString(), Instant.now());
    }

    public static <T> ApiResponse<T> error(String code, String message) {
        return new ApiResponse<>(code, message, null, UUID.randomUUID().toString(), Instant.now());
    }
}

