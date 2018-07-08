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
		'{{DESCRIPTION}}': await waitForUserInput('Add a description (you can update later): ')
	}
	files
		.forEach(({ content, filename }) => {
			const data = Object
				.keys(partsToReplace)
				.reduce((text, key) => text.replace(new RegExp(key, 'g'), partsToReplace[key]), content)
			fs.writeFileSync(path.join(cwd, filename), data, { encoding: 'utf8' })
		})

	// install some dependencies
	devDependencies
		.forEach(dependency => {
			console.log(`installing: ${dependency}`)
			sh`npm install --save-dev ${dependency}`
		})
}
