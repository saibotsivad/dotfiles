const fs = require('fs')
const glob = require('glob')
const path = require('path')
const sh = require('shell-tag')
const waitForUserInput = require('wait-for-user-input')

const files = glob
	.sync(`${path.join(__dirname, '..', 'blank-npm-module')}/*`)
	.map(filepath => {
		const content = fs.readFileSync(filepath, { encoding: 'utf8' })
		return {
			content,
			filename: path.basename(filepath).replace(/^dotfile\./, '.')
		}
	})

const devDependencies = [
	'commitizen@^2.9.6',
	'cz-conventional-changelog@^2.1.0',
	'tape@^4.6.3'
]

module.exports = async ({ cwd, argv }) => {
	// write files
	const partsToReplace = {
		'{{REPO_NAME}}': path.parse(cwd).base,
		'{{DESCRIPTION}}': await waitForUserInput('Add a description (you can update later): '),
		'{{KEYWORDS}}': JSON.stringify((await waitForUserInput('Type some keywords (space seperated): ')).split(/\s+/)),
		'{{CURRENT_DATE}}': new Date().toISOString().split('T')[0]
	}
	files
		.forEach(({ content, filename }) => {
			let data = Object
				.keys(partsToReplace)
				.reduce((text, key) => text.replace(new RegExp(key, 'g'), partsToReplace[key]), content)
			// a nice touch: reformat the package.json so future commits don't change it
			if (filename === 'package.json') {
				data = JSON.stringify(JSON.parse(data), undefined, 2)
			}
			fs.writeFileSync(path.join(cwd, filename), data, { encoding: 'utf8' })
		})

	// install some dependencies
	devDependencies
		.forEach(dependency => {
			console.log(`installing: ${dependency}`)
			sh`npm install --save-dev ${dependency}`
		})

	// commit it as version 0
	sh`git init`
	sh`git add -A`
	sh`git commit -m "0.0.0"`
	sh`git tag -a v0.0.0 -m "chore: initialize project using automated script"`
}
