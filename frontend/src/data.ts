import type { Location, Note, Region } from './types'

export const fallbackRegions: Region[] = [
  { code: 'all', name: '全部', subtitle: '七国漫游', themeColor: '#4f8f91' },
  { code: 'mondstadt', name: '蒙德', subtitle: '风与自由', themeColor: '#68b9b0' },
  { code: 'liyue', name: '璃月', subtitle: '山海契约', themeColor: '#c99352' },
  { code: 'inazuma', name: '稻妻', subtitle: '雷光群岛', themeColor: '#9b78bc' },
  { code: 'sumeru', name: '须弥', subtitle: '雨林沙海', themeColor: '#6f9d63' },
  { code: 'fontaine', name: '枫丹', subtitle: '水都律法', themeColor: '#5d95c9' }
]

export const fallbackLocations: Location[] = [
  { id: 101, regionCode: 'mondstadt', name: '风起原野', category: '秘境', description: '沿着湖风穿过高地，适合日落前抵达。', imageUrl: 'https://images.pexels.com/photos/7232/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1400', score: 4.9, distanceKm: 2.4, tags: '风景,徒步,日落', featured: true },
  { id: 102, regionCode: 'liyue', name: '云来山径', category: '地标', description: '层峦与云海交叠的古道，晨雾时最有层次。', imageUrl: 'https://images.pexels.com/photos/9024240/pexels-photo-9024240.jpeg?auto=compress&cs=tinysrgb&w=1400', score: 4.8, distanceKm: 6.8, tags: '云海,古道,摄影', featured: true },
  { id: 103, regionCode: 'inazuma', name: '鸣霞森社', category: '人文', description: '被古木包围的静谧参道，雨后灯影尤其动人。', imageUrl: 'https://images.pexels.com/photos/9972602/pexels-photo-9972602.jpeg?auto=compress&cs=tinysrgb&w=1400', score: 4.7, distanceKm: 8.1, tags: '神社,森林,文化', featured: false },
  { id: 104, regionCode: 'sumeru', name: '赤砂绿洲', category: '秘境', description: '越过沙丘后出现的水与绿荫，是旅途中的惊喜。', imageUrl: 'https://images.pexels.com/photos/13921909/pexels-photo-13921909.jpeg?auto=compress&cs=tinysrgb&w=1400', score: 4.9, distanceKm: 12.6, tags: '沙海,绿洲,探险', featured: true },
  { id: 105, regionCode: 'fontaine', name: '白露水庭', category: '观景', description: '湖畔聚落与远山相映，清晨水面如镜。', imageUrl: 'https://images.pexels.com/photos/414491/pexels-photo-414491.jpeg?auto=compress&cs=tinysrgb&w=1400', score: 4.6, distanceKm: 4.3, tags: '湖泊,小镇,漫步', featured: false },
  { id: 106, regionCode: 'mondstadt', name: '苍风高地', category: '营地', description: '开阔的山脊营地，夜晚可见清晰星空。', imageUrl: 'https://images.pexels.com/photos/29053372/pexels-photo-29053372.jpeg?auto=compress&cs=tinysrgb&w=1400', score: 4.5, distanceKm: 14.2, tags: '露营,星空,高地', featured: false }
]

export const fallbackNotes: Note[] = [
  { id: 1, userName: '空谷来客', locationName: '云来山径', title: '云海散开前的十分钟', content: '六点从山脚出发，穿过石阶后正好遇见第一束光。建议带一壶热茶，风很大，但景色值得。', imageUrl: fallbackLocations[1].imageUrl, liked: 328 },
  { id: 2, userName: '薄荷团子', locationName: '风起原野', title: '在风里收集一整个下午', content: '沿湖的小路几乎没有难度，适合慢慢走。傍晚草坡的颜色会变成金绿色。', imageUrl: fallbackLocations[0].imageUrl, liked: 214 }
]

