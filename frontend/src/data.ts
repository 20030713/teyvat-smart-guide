import type { Location, Note, Region } from './types'

export const fallbackRegions: Region[] = [
  { code: 'all', name: '全部', subtitle: '七国漫游', themeColor: '#d3bc8e' },
  { code: 'mondstadt', name: '蒙德', subtitle: '风与自由', themeColor: '#61b6aa' },
  { code: 'liyue', name: '璃月', subtitle: '山海契约', themeColor: '#c99b52' },
  { code: 'inazuma', name: '稻妻', subtitle: '雷光群岛', themeColor: '#9a79c7' },
  { code: 'sumeru', name: '须弥', subtitle: '智慧之国', themeColor: '#72a34f' },
  { code: 'fontaine', name: '枫丹', subtitle: '水都律法', themeColor: '#5c9dd2' },
  { code: 'natlan', name: '纳塔', subtitle: '火与竞技', themeColor: '#d5654d' }
]

export const fallbackLocations: Location[] = [
  { id: 101, regionCode: 'mondstadt', name: '明冠山地', category: '观景点', description: '在风与自由的国度，越过高地遥望蒙德城与苍蓝湖泊。', imageUrl: '/assets/genshin/mondstadt.png', score: 4.9, distanceKm: 2.4, tags: '风元素,观景,宝箱', featured: true },
  { id: 102, regionCode: 'liyue', name: '璃月港夜景', category: '地标', description: '万家灯火映着海面，千帆与霄灯共同守望契约之城。', imageUrl: '/assets/genshin/liyue.png', score: 4.9, distanceKm: 1.8, tags: '岩元素,霄灯,摄影', featured: true },
  { id: 103, regionCode: 'inazuma', name: '鸣神岛', category: '人文', description: '穿过绯樱飘落的参道，登上影向山感受雷光与永恒。', imageUrl: '/assets/genshin/inazuma.png', score: 4.8, distanceKm: 3.6, tags: '雷元素,绯樱,神社', featured: false },
  { id: 104, regionCode: 'sumeru', name: '须弥雨林', category: '秘境', description: '巨木与智慧之城相映，在兰那罗的故乡寻找森林回声。', imageUrl: '/assets/genshin/sumeru.png', score: 4.8, distanceKm: 5.2, tags: '草元素,雨林,解谜', featured: true },
  { id: 105, regionCode: 'fontaine', name: '枫丹廷', category: '水都', description: '乘上巡轨船穿越水道，欣赏正义之国宏伟的机械都市。', imageUrl: '/assets/genshin/fontaine.png', score: 4.7, distanceKm: 2.1, tags: '水元素,巡轨船,潜水', featured: false },
  { id: 106, regionCode: 'natlan', name: '纳塔原野', category: '探索', description: '与龙同行越过炽热原野，在竞技与火焰中书写新的传奇。', imageUrl: '/assets/genshin/natlan.png', score: 4.9, distanceKm: 6.4, tags: '火元素,龙伙伴,竞技', featured: true }
]

export const fallbackNotes: Note[] = [
  { id: 1, userName: '空谷来客', locationName: '璃月港', title: '海灯亮起时，整座港口都在发光', content: '从玉京台一路走到码头，恰好赶上霄灯升空。带一份杏仁豆腐，会是很璃月的夜晚。', imageUrl: fallbackLocations[1].imageUrl, liked: 328 },
  { id: 2, userName: '薄荷团子', locationName: '鸣神岛', title: '在绯樱树下等一场雷雨', content: '沿参道慢慢登山，雨后的绯樱格外明亮。记得顺路采集绯樱绣球。', imageUrl: fallbackLocations[2].imageUrl, liked: 214 }
]
