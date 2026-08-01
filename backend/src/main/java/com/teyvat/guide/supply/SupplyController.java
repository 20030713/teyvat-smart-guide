package com.teyvat.guide.supply;

import com.teyvat.guide.common.ApiResponse;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/supply-vouchers")
public class SupplyController {
    private final JdbcClient jdbc;
    public SupplyController(JdbcClient jdbc) { this.jdbc = jdbc; }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> list() {
        return ApiResponse.ok(jdbc.sql("SELECT id,title,location_name AS \"locationName\",stock,total,end_at AS \"endAt\" FROM t_supply_voucher ORDER BY id").query().listOfRows());
    }

    @PostMapping("/{id}/orders")
    @Transactional
    public ApiResponse<Map<String, Object>> claim(@PathVariable long id) {
        int updated = jdbc.sql("UPDATE t_supply_voucher SET stock=stock-1 WHERE id=:id AND stock>0").param("id", id).update();
        if (updated == 0) return ApiResponse.error("OUT_OF_STOCK", "补给已经领完");
        try {
            jdbc.sql("INSERT INTO t_supply_order(user_id,voucher_id) VALUES(10001,:id)").param("id", id).update();
            return ApiResponse.ok(Map.of("claimed", true));
        } catch (DuplicateKeyException duplicate) {
            throw duplicate;
        }
    }
}
