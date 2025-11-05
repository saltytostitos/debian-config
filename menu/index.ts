#!/usr/bin/env bun
import catData from "/Users/saltytostitos/dev/menu/menu/cat.json"

interface MenuItem {
  title: string
  description?: string
  command?: string
  prompt?: string
  pause?: boolean
  items?: MenuItem[]
}

interface MenuCategory {
  title: string
  color?: string
  items: MenuItem[]
}



interface FlatMenuItem {
  title: string
  description?: string
  command?: string
  prompt?: string
  pause?: boolean
  items?: MenuItem[]
  category: string
  categoryColor?: string
}

class MenuState {
  currentIndex: number = 0
  flatItems: FlatMenuItem[] = []

  constructor(flatItems: FlatMenuItem[]) {
    this.flatItems = flatItems
  }

  getCurrentItem(): FlatMenuItem | undefined {
    return this.flatItems[this.currentIndex]
  }

  navigate(direction: 'up' | 'down'): void {
    if (direction === 'up') {
      this.currentIndex = Math.max(0, this.currentIndex - 1)
    } else {
      this.currentIndex = Math.min(this.flatItems.length - 1, this.currentIndex + 1)
    }
  }

  enterItem(): FlatMenuItem | null {
    const item = this.getCurrentItem()
    if (!item) return null

    if (item.items && item.items.length > 0) {
      // Has submenu - return the item to handle submenu navigation
      return item
    }

    return item
  }
}

class Renderer {
  render(state: MenuState): void {
    console.clear()

    // Header
    console.log('\n🔧 Terminal Menu')
    console.log('━'.repeat(60))

    // Group items by category
    const categories = new Map<string, FlatMenuItem[]>()
    state.flatItems.forEach(item => {
      if (!categories.has(item.category)) {
        categories.set(item.category, [])
      }
      categories.get(item.category)!.push(item)
    })

    let globalIndex = 0
    categories.forEach((items, category) => {
      const firstItem = items[0]
      const colorCode = this.getColorCode(firstItem?.categoryColor)

      // Category header
      console.log(`\n${colorCode}${category}\x1b[0m`)
      console.log('─'.repeat(30))

      // Items in this category
      items.forEach(item => {
        const isSelected = globalIndex === state.currentIndex
        const prefix = isSelected ? '▶ ' : '  '
        const title = isSelected ? `\x1b[1m${item.title}\x1b[0m` : item.title

        console.log(`${prefix}${title}`)

        if (item.description && isSelected) {
          console.log(`   └─ ${item.description}`)
        }

        globalIndex++
      })
    })

    // Footer
    console.log('\n' + '━'.repeat(60))
    console.log('↑↓ Navigate  → Enter  q Quit')
  }

  private getColorCode(color?: string): string {
    const colors: { [key: string]: string } = {
      'magenta': '\x1b[35m',
      'green': '\x1b[32m',
      'yellow': '\x1b[33m',
      'blue': '\x1b[34m',
      'red': '\x1b[31m',
      'cyan': '\x1b[36m'
    }
    return colors[color || 'white'] || '\x1b[37m'
  }

  showError(message: string, error?: any): void {
    console.clear()
    console.log(`❌ Error: ${message}`)
    if (error) {
      console.log(error)
    }
  }

  showCommandPrompt(item: FlatMenuItem): void {
    console.clear()
    console.log(`\n🚀 Executing: ${item.title}`)
    if (item.description) {
      console.log(`📝 ${item.description}`)
    }
    console.log('━'.repeat(60))
  }

  showSubmenu(item: FlatMenuItem, state: MenuState): void {
    console.clear()

    // Header
    console.log('\n🔧 Terminal Menu')
    console.log('━'.repeat(60))

    // Breadcrumb
    console.log(`📍 Home > ${item.category} > ${item.title}`)
    console.log('━'.repeat(60))

    // Submenu items
    if (item.items) {
      item.items.forEach((subItem, index) => {
        const isSelected = index === state.currentIndex
        const prefix = isSelected ? '▶ ' : '  '
        const title = isSelected ? `\x1b[1m${subItem.title}\x1b[0m` : subItem.title

        console.log(`${prefix}${title}`)

        if (subItem.description && isSelected) {
          console.log(`   └─ ${subItem.description}`)
        }
      })
    }

    // Footer
    console.log('\n' + '━'.repeat(60))
    console.log('↑↓ Navigate  → Enter  ← Back  q Quit')
  }
}

class CommandExecutor {
  async execute(item: FlatMenuItem, promptValue?: string): Promise<void> {
    if (!item.command) return

    try {
      const { spawn } = await import('node:child_process')

      let command = item.command
      if (item.prompt && promptValue) {
        command = `${command} ${promptValue}`
      }

      return new Promise((resolve, reject) => {
        const child = spawn(command, {
          shell: true,
          stdio: 'inherit'
        })

        child.on('close', (code) => {
          if (code === 0) {
            resolve()
          } else {
            reject(new Error(`Command exited with code ${code}`))
          }
        })

        child.on('error', reject)
      })
    } catch (error) {
      throw error
    }
  }
}

class MenuApp {
  private state: MenuState
  private renderer: Renderer
  private commandExecutor: CommandExecutor
  private submenuState: MenuState | null = null
  private currentSubmenu: FlatMenuItem | null = null

  constructor(menuData: MenuCategory[]) {
    const flatItems = this.flattenMenuItems(menuData)
    this.state = new MenuState(flatItems)
    this.renderer = new Renderer()
    this.commandExecutor = new CommandExecutor()
  }

  private flattenMenuItems(categories: MenuCategory[]): FlatMenuItem[] {
    const flatItems: FlatMenuItem[] = []

    categories.forEach(category => {
      category.items.forEach(item => {
        flatItems.push({
          ...item,
          category: category.title,
          categoryColor: category.color
        })
      })
    })

    return flatItems
  }

  async start(): Promise<void> {
    try {
      console.clear()
      this.renderer.render(this.state)
      await this.runMenuLoop()
    } catch (error) {
      this.renderer.showError('Failed to start menu', error)
      await this.pause()
    }
  }

  private async runMenuLoop(): Promise<void> {
    while (true) {
      const input = await this.waitForInput()
      const trimmedInput = input.trim().toLowerCase()

      // Handle navigation based on whether we're in a submenu
      if (this.submenuState && this.currentSubmenu) {
        await this.handleSubmenuInput(trimmedInput)
      } else {
        await this.handleMainInput(trimmedInput)
      }
    }
  }

  private async handleMainInput(input: string): Promise<void> {
    switch (input) {
      case 'j':
      case 'arrowdown':
        this.state.navigate('down')
        this.renderer.render(this.state)
        break

      case 'k':
      case 'arrowup':
        this.state.navigate('up')
        this.renderer.render(this.state)
        break

      case 'l':
      case 'arrowright':
      case '':
      case '\n':
      case '\r':
        await this.handleEnter()
        break

      case 'q':
        await this.handleQuit()
        return

      default:
        // Unknown command, just redraw
        this.renderer.render(this.state)
        break
    }
  }

  private async handleSubmenuInput(input: string): Promise<void> {
    if (!this.submenuState || !this.currentSubmenu) return

    switch (input) {
      case 'j':
      case 'arrowdown':
        this.submenuState.navigate('down')
        this.renderer.showSubmenu(this.currentSubmenu, this.submenuState)
        break

      case 'k':
      case 'arrowup':
        this.submenuState.navigate('up')
        this.renderer.showSubmenu(this.currentSubmenu, this.submenuState)
        break

      case 'l':
      case 'arrowright':
      case '':
      case '\n':
      case '\r':
        await this.handleSubmenuEnter()
        break

      case 'h':
      case 'arrowleft':
        // Exit submenu
        this.submenuState = null
        this.currentSubmenu = null
        this.renderer.render(this.state)
        break

      case 'q':
        await this.handleQuit()
        return

      default:
        // Unknown command, just redraw
        this.renderer.showSubmenu(this.currentSubmenu, this.submenuState)
        break
    }
  }

  private async handleEnter(): Promise<void> {
    const item = this.state.enterItem()

    if (!item) return

    if (item.items && item.items.length > 0) {
      // Enter submenu
      this.currentSubmenu = item
      const submenuFlatItems = item.items.map(subItem => ({
        ...subItem,
        category: item.category,
        categoryColor: item.categoryColor
      }))
      this.submenuState = new MenuState(submenuFlatItems)
      this.renderer.showSubmenu(item, this.submenuState)
    } else {
      // Execute command
      await this.executeCommand(item)
    }
  }

  private async handleSubmenuEnter(): Promise<void> {
    if (!this.submenuState || !this.currentSubmenu) return

    const item = this.submenuState.enterItem()
    if (!item) return

    await this.executeCommand(item)
  }

  private async executeCommand(item: FlatMenuItem): Promise<void> {
    let promptValue: string | undefined

    if (item.prompt) {
      promptValue = await this.getPromptInput(item.prompt)
      if (!promptValue) {
        // User cancelled, go back to menu
        if (this.submenuState && this.currentSubmenu) {
          this.renderer.showSubmenu(this.currentSubmenu, this.submenuState)
        } else {
          this.renderer.render(this.state)
        }
        return
      }
    }

    this.renderer.showCommandPrompt(item)

    try {
      await this.commandExecutor.execute(item, promptValue)

      if (item.pause === true) {
        console.log('\n✅ Command completed successfully')
        await this.pause()
      }
    } catch (error) {
      console.log('\n❌ Command failed:', error)
      await this.pause()
    }

    // Return to appropriate menu
    if (this.submenuState && this.currentSubmenu) {
      this.renderer.showSubmenu(this.currentSubmenu, this.submenuState)
    } else {
      this.renderer.render(this.state)
    }
  }

  private async handleQuit(): Promise<void> {
    console.clear()
    console.log('\n👋 Goodbye!')
    process.exit(0)
  }

  private async pause(): Promise<void> {
    console.log('\nPress Enter to continue...')
    await this.waitForInput()
  }

  private async getPromptInput(prompt: string): Promise<string | undefined> {
    const readline = await import('node:readline')
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    })

    return new Promise((resolve) => {
      rl.question(`${prompt}: `, (input) => {
        rl.close()
        resolve(input.trim() || undefined)
      })
    })
  }

  private waitForInput(): Promise<string> {
    return new Promise((resolve) => {
      process.stdin.resume()
      process.stdin.setEncoding('utf8')
      process.stdin.setRawMode(true)

      let buffer = ''

      const onData = (chunk: string) => {
        buffer += chunk

        // Handle special keys (arrows)
        if (buffer.includes('\x1b[')) {
          if (buffer.includes('A')) {
            process.stdin.off('data', onData)
            process.stdin.setRawMode(false)
            process.stdin.pause()
            resolve('arrowup')
            return
          } else if (buffer.includes('B')) {
            process.stdin.off('data', onData)
            process.stdin.setRawMode(false)
            process.stdin.pause()
            resolve('arrowdown')
            return
          } else if (buffer.includes('C')) {
            process.stdin.off('data', onData)
            process.stdin.setRawMode(false)
            process.stdin.pause()
            resolve('arrowright')
            return
          } else if (buffer.includes('D')) {
            process.stdin.off('data', onData)
            process.stdin.setRawMode(false)
            process.stdin.pause()
            resolve('arrowleft')
            return
          }
        }

        // Handle single character input
        if (buffer.length > 0 && buffer[0]) {
          const char = buffer[0].toLowerCase()

          // Only process if it's a valid command or Enter/Escape
          if (['j', 'k', 'l', 'h', 'q', '\r', '\n', '\x03'].includes(char) ||
            buffer.includes('\r') || buffer.includes('\n')) {
            process.stdin.off('data', onData)
            process.stdin.setRawMode(false)
            process.stdin.pause()

            if (char === '\x03') {
              // Ctrl+C
              resolve('q')
            } else if (char === '\r' || char === '\n') {
              resolve('')
            } else {
              resolve(char)
            }
          }
        }
      }

      process.stdin.on('data', onData)
    })
  }
}

// Main execution
async function main() {
  try {
    const menuData: MenuCategory[] = catData as MenuCategory[]

    const app = new MenuApp(menuData)
    await app.start()
  } catch (error) {
    console.error('Failed to load menu:', error)
    process.exit(1)
  }
}

// Handle process termination
process.on('SIGINT', () => {
  console.clear()
  console.log('\n👋 Goodbye!')
  process.exit(0)
})

main()
