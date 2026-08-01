import type { Location, Note, Region } from './types'

type Envelope<T> = { data: T }

async function get<T>(path: string): Promise<T> {
  const response = await fetch(path)
  if (!response.ok) throw new Error(`Request failed: ${response.status}`)
  const body = await response.json() as Envelope<T>
  return body.data
}

export const api = {
  regions: () => get<Region[]>('/api/regions'),
  locations: (region = '') => get<Location[]>(`/api/locations${region ? `?region=${region}` : ''}`),
  notes: () => get<Note[]>('/api/notes/hot'),
  signIn: () => fetch('/api/users/me/sign-ins', { method: 'POST' }).then(r => r.json()),
  vouchers: () => get<Array<{id:number; title:string; locationName:string; stock:number; total:number}>>('/api/supply-vouchers'),
  plan: (region: string) => fetch('/api/agent/plan', {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ region, duration: '半日', preference: '风景优先' })
  }).then(r => r.json()).then(r => r.data)
}

