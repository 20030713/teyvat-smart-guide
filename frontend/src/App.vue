<script setup lang="ts">
import { computed, onMounted, reactive, ref } from "vue";
import {
  BookOpen,
  CalendarCheck,
  Check,
  ChevronRight,
  Compass,
  Gift,
  Heart,
  Map,
  MapPinned,
  Navigation,
  Search,
  Sparkles,
  Star,
  UserRound,
  WandSparkles,
  X,
} from "lucide-vue-next";
import { api } from "./api";
import { fallbackLocations, fallbackNotes, fallbackRegions } from "./data";
import type { Location, Note, Region } from "./types";

type View = "discover" | "notes" | "supply";
const view = ref<View>("discover");
const activeRegion = ref("all");
const search = ref("");
const regions = ref<Region[]>(fallbackRegions);
const locations = ref<Location[]>(fallbackLocations);
const notes = ref<Note[]>(fallbackNotes);
const selected = ref<Location | null>(null);
const assistantOpen = ref(false);
const assistantLoading = ref(false);
const routePlan = ref<Array<{ time: string; title: string; note: string }>>([]);
const toast = ref("");
const noteEditorOpen = ref(false);
const noteSubmitting = ref(false);
const noteDraft = reactive({ locationId: 101, title: "", content: "" });

const regionGlyph: Record<string, string> = {
  all: "✦",
  mondstadt: "风",
  liyue: "岩",
  inazuma: "雷",
  sumeru: "草",
  fontaine: "水",
  natlan: "火",
};
const filteredLocations = computed(() =>
  locations.value.filter((item) => {
    const byRegion =
      activeRegion.value === "all" || item.regionCode === activeRegion.value;
    const term = search.value.trim().toLowerCase();
    return (
      byRegion &&
      (!term ||
        `${item.name}${item.description}${item.tags}`
          .toLowerCase()
          .includes(term))
    );
  }),
);

function notify(message: string) {
  toast.value = message;
  window.setTimeout(() => (toast.value = ""), 2200);
}

async function makePlan() {
  assistantOpen.value = true;
  assistantLoading.value = true;
  try {
    routePlan.value = (await api.plan(activeRegion.value)).items;
  } catch {
    routePlan.value = [
      {
        time: "09:00",
        title: "前往七天神像",
        note: "点亮地图，确认今日探索区域",
      },
      { time: "11:30", title: "清理沿途委托", note: "顺路收集宝箱与区域特产" },
      { time: "15:00", title: "抵达推荐观景点", note: "在日落前记录这段旅程" },
    ];
  } finally {
    assistantLoading.value = false;
  }
}

async function signIn() {
  try {
    await api.signIn();
  } catch {
    /* demo fallback */
  }
  notify("今日签到成功 · 获得冒险阅历 ×100");
}

async function publishNote() {
  const location =
    locations.value.find((item) => item.id === Number(noteDraft.locationId)) ||
    locations.value[0];
  if (!noteDraft.title.trim() || !noteDraft.content.trim()) {
    notify("请先写下札记标题和旅途见闻");
    return;
  }
  noteSubmitting.value = true;
  try {
    await api.createNote({
      userName: "旅行者",
      locationName: location.name,
      title: noteDraft.title.trim(),
      content: noteDraft.content.trim(),
      imageUrl: location.imageUrl,
    });
    notes.value = await api.notes();
    noteDraft.title = "";
    noteDraft.content = "";
    noteEditorOpen.value = false;
    notify("冒险札记发布成功");
  } catch (error) {
    const detail = error instanceof Error ? error.message : "未知错误";
    notify(`札记暂时无法发布：${detail}`);
  } finally {
    noteSubmitting.value = false;
  }
}

async function likeNote(note: Note) {
  try {
    await api.likeNote(note.id);
    note.liked += 1;
    notify("已为这段旅途点赞");
  } catch {
    notify("点赞失败，请稍后重试");
  }
}

onMounted(async () => {
  const results = await Promise.allSettled([
    api.regions(),
    api.locations(),
    api.notes(),
  ]);
  if (results[0].status === "fulfilled" && Array.isArray(results[0].value))
    regions.value = [fallbackRegions[0], ...results[0].value];
  if (results[1].status === "fulfilled" && Array.isArray(results[1].value))
    locations.value = results[1].value;
  if (results[2].status === "fulfilled" && Array.isArray(results[2].value))
    notes.value = results[2].value;
});
</script>

<template>
  <div class="app-shell">
    <header class="topbar">
      <a class="brand" href="#" @click.prevent="view = 'discover'">
        <img src="/assets/genshin/genshin-mark.png" alt="原神标志" />
        <span><b>提瓦特智游</b><small>TEYVAT SMART GUIDE</small></span>
      </a>
      <nav class="desktop-nav" aria-label="主导航">
        <button
          :class="{ active: view === 'discover' }"
          @click="view = 'discover'"
        >
          <MapPinned :size="17" />探索
        </button>
        <button :class="{ active: view === 'notes' }" @click="view = 'notes'">
          <BookOpen :size="17" />旅行札记
        </button>
        <button :class="{ active: view === 'supply' }" @click="view = 'supply'">
          <Gift :size="17" />冒险补给
        </button>
      </nav>
      <div class="header-actions">
        <button class="signin" @click="signIn">
          <CalendarCheck :size="17" />每日签到
        </button>
        <button class="avatar" aria-label="个人中心">
          <UserRound :size="19" />
        </button>
      </div>
    </header>

    <main v-if="view === 'discover'">
      <section class="hero">
        <div class="hero-image" aria-hidden="true"></div>
        <div class="hero-copy">
          <div class="hero-kicker">
            <span>ADVENTURER'S GUILD</span><i></i
            ><span>提瓦特大陆探索指南</span>
          </div>
          <h1>向着星辰与深渊</h1>
          <p>
            从传送锚点出发，发现七国秘境、观景点与旅人的真实札记。<br />让派蒙为你的下一段冒险规划路线。
          </p>
          <div class="hero-actions">
            <button class="start-button" @click="makePlan">
              <Compass :size="20" />开始今日冒险
            </button>
            <button class="ghost-button" @click="notify('世界地图正在展开')">
              <Map :size="19" />查看提瓦特地图
            </button>
          </div>
          <div class="search-box">
            <Search :size="19" /><input
              v-model="search"
              placeholder="搜索地区、秘境或观景点"
            /><button @click="notify(`正在搜寻「${search || '附近秘境'}」`)">
              搜索
            </button>
          </div>
        </div>
        <div class="hero-version">
          <small>VERSION 7.0</small
          ><img src="/assets/genshin/version-title.png" alt="当前版本主题" />
        </div>
        <button class="assistant-orb" @click="makePlan">
          <img src="/assets/genshin/paimon.png" alt="派蒙" /><span
            ><Sparkles :size="14" />派蒙领航</span
          >
        </button>
        <div class="hero-scroll"><i></i><span>SCROLL TO EXPLORE</span></div>
      </section>

      <section class="content-section region-section">
        <div class="ornament"><span></span><i>✦</i><span></span></div>
        <div class="section-heading">
          <div>
            <small>SELECT A NATION</small>
            <h2>选择探索区域</h2>
            <p>循着元素的回响，前往提瓦特的不同国度</p>
          </div>
          <button class="text-button"><Map :size="16" />展开世界地图</button>
        </div>
        <div class="region-tabs">
          <button
            v-for="region in regions"
            :key="region.code"
            :class="{ active: activeRegion === region.code }"
            :style="{ '--region': region.themeColor }"
            @click="activeRegion = region.code"
          >
            <span class="region-sigil">{{
              regionGlyph[region.code] || "✦"
            }}</span>
            <span
              ><b>{{ region.name }}</b
              ><small>{{ region.subtitle }}</small></span
            >
          </button>
        </div>
      </section>

      <section class="content-section places-section">
        <div class="section-heading">
          <div>
            <small>ADVENTURE RECOMMENDATION</small>
            <h2>冒险家协会推荐</h2>
            <p>值得点亮传送锚点、专程抵达的探索目的地</p>
          </div>
          <span class="result-count"
            >已发现 {{ filteredLocations.length }} 处</span
          >
        </div>
        <div class="place-grid">
          <article
            v-for="place in filteredLocations"
            :key="place.id"
            class="place-card"
          >
            <button class="place-image" @click="selected = place">
              <img :src="place.imageUrl" :alt="place.name" /><span
                class="category"
                >{{ place.category }}</span
              ><span v-if="place.featured" class="featured">协会推荐</span>
            </button>
            <div class="place-body">
              <div class="place-title">
                <div>
                  <small>{{ place.regionCode.toUpperCase() }}</small>
                  <h3>{{ place.name }}</h3>
                </div>
                <span class="score"
                  ><Star :size="14" fill="currentColor" />{{
                    place.score
                  }}</span
                >
              </div>
              <p>{{ place.description }}</p>
              <div class="tag-row">
                <span v-for="tag in place.tags.split(',')" :key="tag">{{
                  tag
                }}</span>
              </div>
              <div class="place-footer">
                <span
                  ><Navigation :size="14" />距锚点
                  {{ place.distanceKm }}km</span
                ><button @click="selected = place">
                  查看详情 <ChevronRight :size="14" />
                </button>
              </div>
            </div>
          </article>
        </div>
      </section>

      <section class="journal-preview">
        <div class="journal-inner">
          <div class="section-heading light">
            <div>
              <small>TRAVELER'S NOTES</small>
              <h2>旅人的冒险札记</h2>
              <p>每一段被记录的旅途，都让世界更加完整</p>
            </div>
            <button class="text-button" @click="view = 'notes'">
              查看全部 <ChevronRight :size="16" />
            </button>
          </div>
          <div class="note-strip">
            <article v-for="note in notes" :key="note.id">
              <img :src="note.imageUrl" :alt="note.title" />
              <div>
                <span>{{ note.locationName }}</span>
                <h3>{{ note.title }}</h3>
                <p>{{ note.content }}</p>
                <footer>
                  <b>{{ note.userName }}</b
                  ><button class="note-like" @click="likeNote(note)">
                    <Heart :size="15" />{{ note.liked }}
                  </button>
                </footer>
              </div>
            </article>
          </div>
        </div>
      </section>
    </main>

    <main v-else-if="view === 'notes'" class="subpage">
      <div class="subpage-hero">
        <span>TRAVELER'S NOTES</span>
        <h1>冒险札记</h1>
        <p>把路上的风、光与偶遇，写进共同的提瓦特地图。</p>
        <button @click="noteEditorOpen = true">撰写新札记</button>
      </div>
      <div class="masonry-notes">
        <article v-for="note in notes" :key="note.id">
          <img :src="note.imageUrl" :alt="note.title" />
          <div>
            <small>{{ note.locationName }}</small>
            <h2>{{ note.title }}</h2>
            <p>{{ note.content }}</p>
            <footer>
              <b>{{ note.userName }}</b
              ><button class="note-like" @click="likeNote(note)">
                <Heart :size="15" />{{ note.liked }}
              </button>
            </footer>
          </div>
        </article>
      </div>
    </main>

    <main v-else class="subpage">
      <div class="subpage-hero">
        <span>ADVENTURE SUPPLIES</span>
        <h1>今日冒险补给</h1>
        <p>完成每日委托，领取冒险家协会准备的限定物资。</p>
      </div>
      <div class="voucher-grid">
        <article>
          <b>100</b>
          <div>
            <small>每日委托 · 今日限定</small>
            <h2>冒险阅历补给</h2>
            <p>完成四项委托后，可领取原石、摩拉与冒险阅历。</p>
            <button @click="notify('补给领取成功')">立即领取</button>
          </div>
        </article>
        <article>
          <b>20</b>
          <div>
            <small>探索奖励 · 七国通用</small>
            <h2>传送锚点勘测券</h2>
            <p>让派蒙为你规划一条轻松又高效的探索路线。</p>
            <button @click="makePlan">规划路线</button>
          </div>
        </article>
      </div>
    </main>

    <nav class="mobile-nav">
      <button
        :class="{ active: view === 'discover' }"
        @click="view = 'discover'"
      >
        <MapPinned /><span>探索</span></button
      ><button :class="{ active: view === 'notes' }" @click="view = 'notes'">
        <BookOpen /><span>札记</span></button
      ><button :class="{ active: view === 'supply' }" @click="view = 'supply'">
        <Gift /><span>补给</span></button
      ><button><UserRound /><span>我的</span></button>
    </nav>

    <Transition name="drawer"
      ><aside v-if="assistantOpen" class="assistant-drawer">
        <div class="drawer-head">
          <div>
            <img src="/assets/genshin/paimon.png" alt="派蒙" /><span
              ><b>派蒙的冒险路线</b><small>正在参考地区与探索偏好</small></span
            >
          </div>
          <button @click="assistantOpen = false"><X /></button>
        </div>
        <div class="assistant-intro">
          旅行者，派蒙为你准备了一条<strong>风景优先的半日路线</strong>，沿途还会经过宝箱和区域特产哦！
        </div>
        <div v-if="assistantLoading" class="route-loading">
          <i></i><i></i><i></i><span>正在翻阅冒险手册…</span>
        </div>
        <div v-else class="route-list">
          <div v-for="item in routePlan" :key="item.time">
            <span>{{ item.time }}</span
            ><i></i>
            <div>
              <b>{{ item.title }}</b>
              <p>{{ item.note }}</p>
            </div>
          </div>
        </div>
        <button
          class="save-route"
          @click="
            notify('路线已加入冒险手册');
            assistantOpen = false;
          "
        >
          <Check :size="17" />保存到冒险手册
        </button>
      </aside></Transition
    >
    <Transition name="fade"
      ><div
        v-if="assistantOpen"
        class="backdrop"
        @click="assistantOpen = false"
      ></div
    ></Transition>
    <Transition name="toast"
      ><div v-if="toast" class="toast">
        <Check :size="17" />{{ toast }}
      </div></Transition
    >
    <Transition name="modal"
      ><div v-if="selected" class="modal-wrap" @click.self="selected = null">
        <article class="place-modal">
          <button class="modal-close" @click="selected = null"><X /></button
          ><img :src="selected.imageUrl" :alt="selected.name" />
          <div>
            <span
              >{{ selected.category }} ·
              {{ selected.regionCode.toUpperCase() }}</span
            >
            <h2>{{ selected.name }}</h2>
            <p>
              {{
                selected.description
              }}
              推荐在完成每日委托后前往，沿途记得点亮传送锚点并收集区域特产。
            </p>
            <div class="tag-row">
              <span v-for="tag in selected.tags.split(',')" :key="tag">{{
                tag
              }}</span>
            </div>
            <button
              class="primary-button"
              @click="
                makePlan();
                selected = null;
              "
            >
              <WandSparkles :size="17" />加入冒险路线
            </button>
          </div>
        </article>
      </div></Transition
    >
    <Transition name="modal"
      ><div
        v-if="noteEditorOpen"
        class="modal-wrap"
        @click.self="noteEditorOpen = false"
      >
        <form class="note-editor" @submit.prevent="publishNote">
          <button
            type="button"
            class="modal-close"
            aria-label="关闭札记编辑器"
            @click="noteEditorOpen = false"
          >
            <X />
          </button>
          <div class="editor-heading">
            <small>NEW TRAVELER'S NOTE</small>
            <h2>记录这段冒险</h2>
            <p>选择旅途地点，把沿途的风景与发现留给下一位旅行者。</p>
          </div>
          <label
            >记录地点<select v-model="noteDraft.locationId">
              <option
                v-for="place in locations"
                :key="place.id"
                :value="place.id"
              >
                {{ place.name }} · {{ place.regionCode.toUpperCase() }}
              </option>
            </select></label
          ><label
            >札记标题<input
              v-model="noteDraft.title"
              maxlength="120"
              placeholder="例如：海灯亮起时，整座港口都在发光" /></label
          ><label
            >旅途见闻<textarea
              v-model="noteDraft.content"
              maxlength="1000"
              rows="6"
              placeholder="写下路线、时间、宝箱或值得分享的瞬间…"
            ></textarea>
          </label>
          <div class="editor-meta">
            <span>{{ noteDraft.content.length }} / 1000</span
            ><button type="button" :disabled="noteSubmitting" @click="publishNote">
              <BookOpen :size="17" />{{
                noteSubmitting ? "正在发布…" : "发布冒险札记"
              }}
            </button>
          </div>
        </form>
      </div></Transition
    >
  </div>
</template>
