// import type { Config } from '/Users/kevin/Library/pnpm/global/5/.pnpm/@sxzz+create@0.3.0/node_modules/@sxzz/create/dist/types'
import type { Config } from '/Users/kevin/Developer/open-source/create/src/types'

const config: Config = {
  git: {
    add: true,
  },

  replaces: [
    {
      from: /\n.*Remove belows[\w\W]*Remove aboves.*\n/gi,
      to: '',
    },
  ],

  commands: ['code .', 'pnpm i'],

  templates: [
    {
      name: 'Library',
      color: 'blue',

      variables: {
        description: {
          type: 'text',
          message: 'Package description',
          initial: 'My awesome typescript library',
        },
      },

      children: [
        {
          name: 'TypeScript',
          color: '#3178c6',
          url: 'sxzz/node-lib-starter',

          replaces: [
            { from: 'node-lib-starter', to: (o) => o.project.folderName },
            {
              from: 'My awesome typescript library',
              to: (o) => o.project.variables.description,
            },
          ],
        },

        {
          name: 'unplugin',
          url: 'sxzz/unplugin-starter',
          variables: {
            pascalCase: {
              type: 'text',
              message: 'Pascal case of project name',
              initial: 'UnpluginStarter',
              required: true,
            },
          },

          replaces: [
            { from: 'unplugin-starter', to: (o) => o.project.folderName },
            {
              from: 'UnpluginStarter',
              to: (o) => o.project.variables.pascalCase,
            },
            {
              from: 'Description.',
              to: (o) => o.project.variables.description,
            },
          ],
        },

        {
          name: 'monorepo',
          url: 'sxzz/monorepo-starter',
          variables: {
            scope: {
              type: 'text',
              message: 'Package scope of the project',
              required: true,
            },
          },
          replaces: [
            { from: 'project-name', to: (o) => o.project.folderName },
            { from: '@scope', to: (o) => `@${o.project.variables.scope}` },
            {
              from: 'My awesome typescript library',
              to: (o) => o.project.variables.description,
            },
          ],
        },
      ],
    },
    {
      name: 'Web App',
      color: 'green',
      children: [
        {
          name: 'Vue 3',
          color: '#42b883',
          url: 'vitejs/vite/packages/create-vite/template-vue-ts',
          replaces: [
            {
              from: 'vite-vue-typescript-starter',
              to: (o) => o.project.folderName,
            },
          ],
          commands: ({ project }) => [
            'mv _gitignore .gitignore',
            `echo '# ${project.folderName}' > README.md`,
          ],
        },
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
