import type { Config } from '/Users/kevin/Library/pnpm/global/5/node_modules/@sxzz/create/dist/config'

const config: Config = {
  gitAdd: true,
  templates: [
    {
      name: 'Library',
      color: 'blue',
      children: [
        {
          name: 'TypeScript',
          color: '#3178c6',
          url: 'sxzz/node-lib-starter',
        },
        {
          name: 'unplugin',
          url: 'sxzz/unplugin-starter',
        },
      ],
    },
    {
      name: 'Web App',
      color: 'green',
      children: [
        {
          name: 'Element Plus',
          color: '#409eff',
          url: 'sxzz/element-plus-best-practices',
        },
        {
          name: 'Tauri App',
          color: '#ffc131',
          url: 'sxzz/element-plus-tauri-starter',
        },
      ],
    },
  ],
}

export default config
