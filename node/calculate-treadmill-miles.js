import { readFile } from 'node:fs/promises'
import { parse } from '@saibotsivad/blockdown'
import glob from 'tiny-glob'
import { load } from 'js-yaml'

const DIR = '/Users/saibotsivad/Dropbox/Obsidian/ProbablyEverything'

const files = await glob(DIR + '/**/*.md').then(maybes => maybes.filter(f => !f.includes('/.trash')))

console.log('Markdown files found:', files.length)

let treadmillMiles = 0

const MILES_FINDER = /\d{2}:\d{2}\s+([\d.]+)\s+mile/
const getMilesFromEntry = string => {
	const match = string && MILES_FINDER.exec(string)
	if (match[1]) return parseFloat(match[1])
	return 0
}

const TAG_MILES_FINDER = /#walk\s+#treadmill\s+\d{2}:\d{2}\s+([\d.]+)\s+mile/g

const getFileTreadmillMiles = string => {
	// It might be in the frontmatter
	const { blocks } = parse(string)
	if ([ 'yaml', 'frontmatter' ].includes(blocks?.[0]?.name)) {
		try {
			const data = load(blocks[0].content)
			if (data.treadmill?.length) {
				let sum = 0
				for (const entry of data.treadmill) sum += getMilesFromEntry(entry)
				return sum
			}
		} catch (ignore) {
			// playing loose
		}
	}
	// Or it might be in as a tag
	let match
	let sum = 0
	while ((match = TAG_MILES_FINDER.exec(string)) !== null) {
		sum += parseFloat(match[1])
	}
	return sum
}

for (const file of files) treadmillMiles += getFileTreadmillMiles(await readFile(file, 'utf8'))

console.log('Total treadmill miles:', treadmillMiles)
