import { readFile } from 'node:fs/promises'
import { join } from 'node:path'
import glob from 'tiny-glob'

const FOLDER = '/Users/saibotsivad/Dropbox/Obsidian/GTD'

// ----------------------------

const DATE_MATCHER = /\d{4}-\d{2}-\d{2}\.md$/
const filenames = (
	await glob('**/****-**-**.md', { cwd: FOLDER })
).filter(f => DATE_MATCHER.test(f))
// #blood-pressure 12:41 149/102@84 been high for several readings this morning as well
const BP_REGEX = /#blood-pressure\s+([\d:]+)\s+([\d@\/]+)\s*(.+)?/

const dateToEntries = {}
for (const name of filenames) {
	const file = await readFile(join(FOLDER, name), 'utf8')
	if (file.includes('#blood-pressure')) {
		const date = name.split('/').pop().split('.')[0]
		dateToEntries[date] = dateToEntries[date] || []
		const lines = file.split('\n')
		for (const line of lines) if (line.includes('#blood-pressure')) {
			const match = BP_REGEX.exec(line)
			if (!match) {
				console.log('Blood pressure line incorrectly formatted:', name)
				process.exit(1)
			}
			const [ , time, measurement, notes ] = match
			const [ systolic, diastolic, rate ] = measurement.split(/\D/)
			dateToEntries[date].push({ date, time, systolic, diastolic, rate, notes })
		}
	}
}

console.log([ 'datetime', 'systolic', 'diastolic', 'rate' ].join(','))
for (const date of Object.keys(dateToEntries).sort()) {
	for (const { time, systolic, diastolic, rate } of dateToEntries[date]) {
		console.log([date + ' ' + time, systolic, diastolic, rate].join(','))
	}
}
