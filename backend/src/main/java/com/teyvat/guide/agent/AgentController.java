package com.teyvat.guide.agent;

import com.teyvat.guide.common.ApiResponse;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/agent")
public class AgentController {
    @PostMapping("/plan")
    public ApiResponse<Map<String, Object>> plan(@RequestBody PlanRequest request) {
        return ApiResponse.ok(Map.of(
            "summary", "为你安排一条轻松、风景优先的半日路线",
            "items", List.of(
                Map.of("time", "09:00", "title", "风起原野", "note", "沿湖慢行，避开正午强光"),
                Map.of("time", "11:30", "title", "冒险家营地", "note", "领取早餐补给并短暂休息"),
                Map.of("time", "14:00", "title", "苍风高地", "note", "在山脊等待日落前的柔光")
            ),
            "preference", request.preference() == null ? "风景优先" : request.preference()
        ));
    }

    public record PlanRequest(String region, String duration, String preference) {}
}

