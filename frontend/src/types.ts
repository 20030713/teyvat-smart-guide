export interface Region {
  code: string
  name: string
  subtitle: string
  themeColor: string
}

export interface Location {
  id: number
  regionCode: string
  name: string
  category: string
  description: string
  imageUrl: string
  score: number
  distanceKm: number
  tags: string
  featured: boolean
}

export interface Note {
  id: number
  userName: string
  locationName: string
  title: string
  content: string
  imageUrl: string
  liked: number
}

