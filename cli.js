const minimist = require('minimist')
const path = require('path')

const command = process.argv[2]
const argv = minimist(process.argv.slice(3))
const cwd = process.cwd()

const tool = require(path.join(__dirname, 'node', `${command}.js`))
tool({ argv, cwd })
	.then(() => {
		console.log(`complete: ${command}`)
		process.exit(0)
	})
	.catch(error => {
		console.error(error)
		process.exit(1)
	})
