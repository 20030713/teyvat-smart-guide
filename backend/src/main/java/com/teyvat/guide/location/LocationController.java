package com.teyvat.guide.location;

import com.teyvat.guide.common.ApiResponse;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class LocationController {
    private final JdbcClient jdbc;

    public LocationController(JdbcClient jdbc) { this.jdbc = jdbc; }

    @GetMapping("/regions")
    public ApiResponse<List<Map<String, Object>>> regions() {
        return ApiResponse.ok(jdbc.sql("SELECT code,name,subtitle,theme_color AS \"themeColor\" FROM t_region ORDER BY sort_order").query().listOfRows());
    }

    @GetMapping("/locations")
    public ApiResponse<List<Map<String, Object>>> locations(@RequestParam(required = false) String region,
                                                             @RequestParam(required = false) String category) {
        var sql = new StringBuilder("SELECT id,region_code AS \"regionCode\",name,category,description,image_url AS \"imageUrl\",score,distance_km AS \"distanceKm\",tags,featured FROM t_location WHERE 1=1");
        if (region != null && !region.isBlank()) sql.append(" AND region_code = :region");
        if (category != null && !category.isBlank()) sql.append(" AND category = :category");
        sql.append(" ORDER BY featured DESC, score DESC");
        var statement = jdbc.sql(sql.toString());
        if (region != null && !region.isBlank()) statement = statement.param("region", region);
        if (category != null && !category.isBlank()) statement = statement.param("category", category);
        return ApiResponse.ok(statement.query().listOfRows());
    }

    @GetMapping("/locations/{id}")
    public ApiResponse<Map<String, Object>> location(@PathVariable long id) {
        var rows = jdbc.sql("SELECT id,region_code AS \"regionCode\",name,category,description,image_url AS \"imageUrl\",score,distance_km AS \"distanceKm\",tags,featured FROM t_location WHERE id=:id")
            .param("id", id).query().listOfRows();
        return rows.isEmpty() ? ApiResponse.error("LOCATION_NOT_FOUND", "地点不存在") : ApiResponse.ok(rows.getFirst());
    }
}
