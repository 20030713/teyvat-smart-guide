package com.teyvat.guide.social;

import com.teyvat.guide.common.ApiResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notes")
public class NoteController {
    private final JdbcClient jdbc;
    public NoteController(JdbcClient jdbc) { this.jdbc = jdbc; }

    @GetMapping("/hot")
    public ApiResponse<List<Map<String, Object>>> hot() {
        return ApiResponse.ok(jdbc.sql("SELECT id,user_name AS \"userName\",location_name AS \"locationName\",title,content,image_url AS \"imageUrl\",liked,created_at AS \"createdAt\" FROM t_note ORDER BY liked DESC,id DESC LIMIT 20").query().listOfRows());
    }

    @PostMapping
    public ApiResponse<Map<String, Object>> create(@Valid @RequestBody CreateNote body) {
        jdbc.sql("INSERT INTO t_note(user_name,location_name,title,content,image_url,liked) VALUES(:user,:location,:title,:content,:image,0)")
            .param("user", body.userName()).param("location", body.locationName()).param("title", body.title())
            .param("content", body.content()).param("image", body.imageUrl()).update();
        Long id = jdbc.sql("SELECT MAX(id) FROM t_note").query(Long.class).single();
        return ApiResponse.ok(Map.of("id", id));
    }

    @PutMapping("/{id}/like")
    public ApiResponse<Map<String, Object>> like(@PathVariable long id) {
        int updated = jdbc.sql("UPDATE t_note SET liked=liked+1 WHERE id=:id").param("id", id).update();
        return updated == 1 ? ApiResponse.ok(Map.of("liked", true)) : ApiResponse.error("NOTE_NOT_FOUND", "笔记不存在");
    }

    public record CreateNote(@NotBlank String userName, @NotBlank String locationName, @NotBlank @Size(max=120) String title,
                             @NotBlank @Size(max=1000) String content, String imageUrl) {}
}
