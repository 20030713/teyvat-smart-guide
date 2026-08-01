package com.teyvat.guide;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import com.teyvat.guide.location.LocationController;
import org.springframework.beans.factory.annotation.Autowired;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class LocationApiTest {
    @Autowired LocationController controller;

    @Test
    void returnsFeaturedLocations() {
        var response = controller.locations(null, null);
        assertThat(response.code()).isEqualTo("OK");
        assertThat(response.data()).isNotEmpty();
        assertThat(response.data().getFirst().get("featured")).isEqualTo(true);
    }

    @Test
    void filtersByRegion() {
        var response = controller.locations("liyue", null);
        assertThat(response.data()).hasSize(1);
        assertThat(response.data().getFirst().get("regionCode")).isEqualTo("liyue");
    }
}
