<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { Compass, MapPinned, Sparkles, BookOpen, Gift, UserRound, Search, Map, Star, Navigation, Heart, MessageCircle, WandSparkles, CalendarCheck, ArrowRight, X, Clock3, Check } from 'lucide-vue-next'
import { api } from './api'
import { fallbackLocations, fallbackNotes, fallbackRegions } from './data'
import type { Location, Note, Region } from './types'

type View = 'discover' | 'notes' | 'supply'
const view = ref<View>('discover')
const activeRegion = ref('all')
const search = ref('')
const regions = ref<Region[]>(fallbackRegions)
const locations = ref<Location[]>(fallbackLocations)
const notes = ref<Note[]>(fallbackNotes)
const selected = ref<Location | null>(null)
const assistantOpen = ref(false)
const assistantLoading = ref(false)
const routePlan = ref<Array<{time:string; title:string; note:string}>>([])
const toast = ref('')

const filteredLocations = computed(() => locations.value.filter(item => {
  const byRegion = activeRegion.value === 'all' || item.regionCode === activeRegion.value
  const term = search.value.trim().toLowerCase()
  const bySearch = !term || `${item.name}${item.description}${item.tags}`.toLowerCase().includes(term)
  return byRegion && bySearch
}))

function notify(message: string) {
  toast.value = message
  window.setTimeout(() => toast.value = '', 2200)
}

async function makePlan() {
  assistantOpen.value = true
  assistantLoading.value = true
  try {
    const result = await api.plan(activeRegion.value)
    routePlan.value = result.items
  } catch {
    routePlan.value = [
      { time: '09:00', title: '风起原野', note: '沿湖慢行，感受清晨湖风' },
      { time: '11:30', title: '冒险家营地', note: '领取补给，短暂休息' },
      { time: '14:00', title: '苍风高地', note: '在山脊等待日落前柔光' }
    ]
  } finally { assistantLoading.value = false }
}

async function signIn() {
  try { await api.signIn() } catch { /* demo fallback */ }
  notify('今日签到成功，连续冒险 7 天')
}

onMounted(async () => {
  const results = await Promise.allSettled([api.regions(), api.locations(), api.notes()])
  if (results[0].status === 'fulfilled' && Array.isArray(results[0].value)) regions.value = [fallbackRegions[0], ...results[0].value]
  if (results[1].status === 'fulfilled' && Array.isArray(results[1].value)) locations.value = results[1].value
  if (results[2].status === 'fulfilled' && Array.isArray(results[2].value)) notes.value = results[2].value
})
</script>

<template>
  <div class="app-shell">
    <header class="topbar">
      <a class="brand" href="#" @click.prevent="view = 'discover'">
        <span class="brand-mark"><Compass :size="23" stroke-width="1.6" /></span>
        <span><b>提瓦特智游</b><small>TEYVAT JOURNEY</small></span>
      </a>
      <nav class="desktop-nav" aria-label="主导航">
        <button :class="{active:view==='discover'}" @click="view='discover'"><MapPinned :size="17"/>发现</button>
        <button :class="{active:view==='notes'}" @click="view='notes'"><BookOpen :size="17"/>游记</button>
        <button :class="{active:view==='supply'}" @click="view='supply'"><Gift :size="17"/>补给</button>
      </nav>
      <div class="header-actions">
        <button class="signin" @click="signIn"><CalendarCheck :size="17"/>签到</button>
        <button class="avatar" aria-label="个人中心"><UserRound :size="19"/></button>
      </div>
    </header>

    <main v-if="view === 'discover'">
      <section class="hero">
        <div class="hero-image" aria-hidden="true"></div>
        <div class="hero-grid" aria-hidden="true"></div>
        <div class="hero-copy">
          <div class="eyebrow"><span></span> 冒险者探索手册 · 第 01 卷</div>
          <h1>风会记住<br><em>每一次出发</em></h1>
          <p>发现值得停留的秘境，收藏旅人的真实笔记，<br class="desktop-only">让派蒙助手为下一段旅程画出路线。</p>
          <div class="search-box">
            <Search :size="20" />
            <input v-model="search" placeholder="搜索地点、风景或冒险关键词" />
            <button @click="notify(`正在寻找「${search || '附近秘境'}」`)">开始探索</button>
          </div>
          <div class="hero-meta">
            <span><Map :size="15"/>收录 126 个探索地点</span>
            <span><Sparkles :size="15"/>今日 8 条新路线</span>
          </div>
        </div>
        <button class="assistant-orb" @click="makePlan">
          <span class="orb-stars">✦</span><WandSparkles :size="25"/><b>派蒙<br>规划</b>
        </button>
      </section>

      <section class="content-section region-section">
        <div class="section-heading">
          <div><span class="section-index">01</span><h2>选择你的目的地</h2><p>从七国的风土与故事开始</p></div>
          <button class="text-button">展开地图 <ArrowRight :size="16"/></button>
        </div>
        <div class="region-tabs">
          <button v-for="region in regions" :key="region.code" :class="{active:activeRegion===region.code}" :style="{'--region':region.themeColor}" @click="activeRegion=region.code">
            <span class="region-sigil">{{ region.name.slice(0,1) }}</span>
            <span><b>{{ region.name }}</b><small>{{ region.subtitle }}</small></span>
          </button>
        </div>
      </section>

      <section class="content-section">
        <div class="section-heading">
          <div><span class="section-index">02</span><h2>此刻值得抵达</h2><p>由旅人足迹与口碑共同选出</p></div>
          <span class="result-count">{{ filteredLocations.length }} 处地点</span>
        </div>
        <div class="place-grid">
          <article v-for="(place,index) in filteredLocations" :key="place.id" class="place-card" :class="{wide:index===0}">
            <button class="place-image" @click="selected=place">
              <img :src="place.imageUrl" :alt="place.name" loading="lazy" />
              <span class="category">{{ place.category }}</span>
              <span v-if="place.featured" class="featured">编辑精选</span>
            </button>
            <div class="place-body">
              <div class="place-title"><div><small>{{ place.regionCode.toUpperCase() }}</small><h3>{{ place.name }}</h3></div><span class="score"><Star :size="14" fill="currentColor"/>{{ place.score }}</span></div>
              <p>{{ place.description }}</p>
              <div class="tag-row"><span v-for="tag in place.tags.split(',')" :key="tag"># {{ tag }}</span></div>
              <div class="place-footer"><span><Navigation :size="14"/> 距你 {{ place.distanceKm }}km</span><button @click="selected=place">查看手记 <ArrowRight :size="14"/></button></div>
            </div>
          </article>
        </div>
      </section>

      <section class="content-section journal-preview">
        <div class="section-heading light">
          <div><span class="section-index">03</span><h2>旅人的新鲜故事</h2><p>世界因每一份真实记录而更加完整</p></div>
          <button class="text-button" @click="view='notes'">阅读全部 <ArrowRight :size="16"/></button>
        </div>
        <div class="note-strip">
          <article v-for="note in notes" :key="note.id">
            <img :src="note.imageUrl" :alt="note.title" />
            <div><span class="note-place">{{ note.locationName }}</span><h3>{{ note.title }}</h3><p>{{ note.content }}</p><footer><b>{{ note.userName }}</b><span><Heart :size="15"/>{{ note.liked }}</span></footer></div>
          </article>
        </div>
      </section>
    </main>

    <main v-else-if="view === 'notes'" class="subpage">
      <div class="subpage-hero"><span>ADVENTURE NOTES</span><h1>冒险笔记</h1><p>把路上的风、光与偶遇，写进共同的世界地图。</p><button @click="notify('发布编辑器将在下一迭代开放')">写一篇游记</button></div>
      <div class="masonry-notes">
        <article v-for="(note,index) in [...notes,...notes]" :key="`${note.id}-${index}`"><img :src="note.imageUrl" :alt="note.title"><div><small>{{ note.locationName }}</small><h2>{{ note.title }}</h2><p>{{ note.content }}</p><footer><b>{{ note.userName }}</b><span><Heart :size="15"/> {{ note.liked }}</span><span><MessageCircle :size="15"/> 18</span></footer></div></article>
      </div>
    </main>

    <main v-else class="subpage supply-page">
      <div class="subpage-hero supply-hero"><span>DAILY SUPPLIES</span><h1>今日冒险补给</h1><p>限量物资已由冒险家协会送达，先到先得。</p></div>
      <div class="voucher-grid">
        <article><div class="voucher-stamp">36<small>/100</small></div><div><small>风起原野 · 今日限定</small><h2>冒险家早餐补给</h2><p>热饮、便携餐与一枚路线纪念章。</p><div class="progress"><i style="width:36%"></i></div><button @click="notify('补给领取成功，请在营地出示凭证')">立即领取</button></div></article>
        <article><div class="voucher-stamp amber">12<small>/50</small></div><div><small>云来山径 · 路线服务</small><h2>云来山径向导券</h2><p>含半日路线讲解与摄影点位指引。</p><div class="progress amber"><i style="width:24%"></i></div><button @click="notify('向导券领取成功')">立即领取</button></div></article>
      </div>
    </main>

    <nav class="mobile-nav"><button :class="{active:view==='discover'}" @click="view='discover'"><MapPinned/><span>发现</span></button><button :class="{active:view==='notes'}" @click="view='notes'"><BookOpen/><span>游记</span></button><button :class="{active:view==='supply'}" @click="view='supply'"><Gift/><span>补给</span></button><button><UserRound/><span>我的</span></button></nav>

    <Transition name="drawer">
      <aside v-if="assistantOpen" class="assistant-drawer">
        <div class="drawer-head"><div><span class="mini-orb"><WandSparkles/></span><span><b>派蒙路线助手</b><small>正在参考天气与旅行偏好</small></span></div><button @click="assistantOpen=false"><X/></button></div>
        <div class="assistant-intro"><span>✦</span><p>旅行者，我准备了一条<strong>风景优先的半日路线</strong>。节奏不会太赶，也留出了拍照和补给时间。</p></div>
        <div v-if="assistantLoading" class="route-loading"><i></i><i></i><i></i><span>正在翻阅冒险手册…</span></div>
        <div v-else class="route-list"><div v-for="(item,index) in routePlan" :key="item.time"><span class="route-time">{{ item.time }}</span><i><Check v-if="index===0" :size="12"/></i><div><b>{{ item.title }}</b><p>{{ item.note }}</p></div></div></div>
        <div class="drawer-tip"><Clock3 :size="17"/><span>预计 5 小时 · 徒步约 7.8km</span></div>
        <button class="save-route" @click="notify('路线已收藏到「我的旅程」');assistantOpen=false">收藏这条路线</button>
      </aside>
    </Transition>
    <Transition name="fade"><div v-if="assistantOpen" class="backdrop" @click="assistantOpen=false"></div></Transition>

    <Transition name="toast"><div v-if="toast" class="toast"><Check :size="17"/>{{ toast }}</div></Transition>

    <Transition name="modal">
      <div v-if="selected" class="modal-wrap" @click.self="selected=null">
        <article class="place-modal"><button class="modal-close" @click="selected=null"><X/></button><img :src="selected.imageUrl" :alt="selected.name"><div><span>{{ selected.category }} · {{ selected.regionCode.toUpperCase() }}</span><h2>{{ selected.name }}</h2><p>{{ selected.description }} 推荐在清晨或日落前抵达，光线柔和，也更容易避开人群。</p><div class="tag-row"><span v-for="tag in selected.tags.split(',')" :key="tag"># {{ tag }}</span></div><button class="primary-button" @click="makePlan();selected=null"><WandSparkles :size="17"/>加入智能路线</button></div></article>
      </div>
    </Transition>
  </div>
</template>
