import { readFile, writeFile } from 'node:fs/promises'
import { parse } from '@saibotsivad/blockdown'
import glob from 'tiny-glob'
import { load } from 'js-yaml'

const FILENAME = '/Users/saibotsivad/Dropbox/Obsidian/ProbablyEverything/Kappa Streams/Treadmill.md'

const file = await readFile(FILENAME, 'utf8')

const entries = file
	.split(/---![^\#]+#stream/)[1]
	.trim()
	.split('\n')
	.map(line => {
		const [ date, time, distance, units, modifier ] = line.split(',')
		return { date, time, distance, units, modifier }
	})

entries.shift()

let sum = 0
for (const { distance } of entries) sum += parseFloat(distance)
sum = Math.round(sum * 100) / 100

const dayToDistance = {}
const dayToCount = {}
for (const { distance, date } of entries) {
	const day = new Date(date + 'T06:00:00.000Z').getDay()
	dayToDistance[day] = (dayToDistance[day] || 0) + parseFloat(distance)
	dayToCount[day] = (dayToCount[day] || 0) + 1
}

const dayToName = [ 'sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat' ]
const round = num => Math.round(num * 100) / 100

console.log('# Report')
console.log('start_date:', entries[0].date)
console.log('end_date:', entries[entries.length - 1].date)
console.log('total_miles:', sum)
console.log('average_miles_per_day:', round(sum / entries.length))
console.log('days:')
for (const day in dayToCount) {
	console.log(`  ${dayToName[parseInt(day, 10)]}:`)
	console.log(`    miles: ${round(dayToDistance[day])}`)
	console.log(`    days: ${dayToCount[day]}`)
	console.log(`    ave: ${round(dayToDistance[day] / dayToCount[day])}`)
}
