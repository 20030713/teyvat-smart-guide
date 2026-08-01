package com.teyvat.guide;

import com.teyvat.guide.social.NoteController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class NoteApiTest {
    @Autowired NoteController controller;

    @Test
    void createsAndLikesAdventureNote() {
        var created = controller.create(new NoteController.CreateNote(
            "旅行者", "明冠山地", "风吹过山脊的时候", "用于验证札记发布链路。", "/assets/genshin/mondstadt.png"
        ));
        long id = ((Number) created.data().get("id")).longValue();

        assertThat(created.code()).isEqualTo("OK");
        assertThat(controller.hot()).satisfies(response ->
            assertThat(response.data()).anyMatch(note -> note.get("id").equals(id))
        );
        assertThat(controller.like(id).data().get("liked")).isEqualTo(true);
    }
}
