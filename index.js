const os = require('os')

const platforms = Object.assign(Object.create(null), {
	linux: 'linux',
	darwin: 'macos',
	win32: 'windows'
})

const platform = platforms[os.platform()]
if (!platform) {
  console.error(`Unsupported platform ${os.platform()}.`)
  process.exit(1)
}

const arch = os.arch()
if (platform === 'macos' && arch !== 'x64' && arch !== 'arm64') {
  console.error(`Unsupported architecture ${arch} on macOS. Only x64 and arm64 are supported.`)
  process.exit(1)
} else if (platform !== 'macos' && arch !== 'x64') {
  console.error(`Unsupported architecture ${arch}. Only x64 is supported on ${platform}.`)
  process.exit(1)
}

module.exports = require('sox-static-' + platform)
