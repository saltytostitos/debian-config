### ✅ Features Implemented:

1. Neovim-style Navigation:
 • j/k for up/down movement
 • l to enter submenus or execute commands
 • h to go back to previous level
 • q to quit
2. Breadcrumbs: Shows navigation path like "Home > Utils > Github"
3. Visual Interface:
 • Highlighted current selection with reverse video
 • Clean menu display with descriptions
 • Arrow indicators (→) for items with submenus
4. Command Execution:
 • Handles prompts for commands that need input
 • Shows command being executed
 • Respects pause: true flag for commands that need user to see output
 • Error handling with pause and reset
5. State Management:
 • Tracks navigation history
 • Maintains selection state
 • Proper cleanup of input handlers


### 🏗️ Architecture:

• MenuState: Manages navigation state and history
• Renderer: Handles all console output and formatting
• InputHandler: Processes keyboard input with neovim bindings
• CommandExecutor: Runs commands with prompts and pauses
• MenuApp: Main application controller

### 🚀 Usage:

Run with bun run index.ts and use:

• j/k to navigate up/down
• l to enter submenu or run command
• h to go back one level
• q to quit
