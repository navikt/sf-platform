const globals = require("globals");
const pluginJs = require("@eslint/js");
const eslintPluginLwc = require("@lwc/eslint-plugin-lwc");
const babelParser = require("@babel/eslint-parser");
const lwcConfig = require("@salesforce/eslint-config-lwc");
const pluginLightning = require("@salesforce/eslint-plugin-lightning");
const importPlugin = require("eslint-plugin-import");
const pluginJest = require("eslint-plugin-jest");

const { includeIgnoreFile } = require("@eslint/compat");
const path = require("node:path");
const gitignorePath = path.resolve(__dirname, ".gitignore");

module.exports = [
  includeIgnoreFile(gitignorePath),
  {
    ignores: [
      "**/lwc/**/*.css",
      "**/lwc/**/*.html",
      "**/lwc/**/*.json",
      "**/lwc/**/*.svg",
      "**/lwc/**/*.xml",
      "**/aura/**/*.auradoc",
      "**/aura/**/*.cmp",
      "**/aura/**/*.css",
      "**/aura/**/*.design",
      "**/aura/**/*.evt",
      "**/aura/**/*.json",
      "**/aura/**/*.svg",
      "**/aura/**/*.xml",
      "**/aura/**/*.tokens",
      "**/lwc/pubsub/README.md",
    ],
    languageOptions: {
      globals: pluginJest.environments.globals.globals,
      parser: babelParser,
      parserOptions: {
        requireConfigFile: false,
        babelOptions: {
          parserOpts: {
            plugins: [
              "classProperties",
              ["decorators", { decoratorsBeforeExport: false }],
              "typescript",
            ],
          },
        },
      },
    },
    plugins: {
      "@lwc/lwc": eslintPluginLwc, // https://github.com/salesforce/eslint-plugin-lwc
      "@salesforce/lightning": pluginLightning, // https://github.com/salesforce/eslint-plugin-lightning,
      jest: pluginJest,
    },
    rules: {
      "@lwc/lwc/no-deprecated": "error",
      "@lwc/lwc/valid-api": "error",
      "@lwc/lwc/no-document-query": "error",
      "@lwc/lwc/ssr-no-unsupported-properties": "error",
      "@salesforce/lightning/no-aura-localization-service": "error",
      "@salesforce/lightning/no-moment": "error",
      "@salesforce/lightning/prefer-i18n-service": "error",
      "@salesforce/lightning/valid-apex-method-invocation": "error",
      "jest/no-disabled-tests": "warn",
      "jest/no-focused-tests": "error",
      "jest/no-identical-title": "error",
      "jest/prefer-to-have-length": "warn",
      "jest/valid-expect": "error",
    },
  },
  pluginJs.configs.recommended,
  importPlugin.flatConfigs.recommended,
  ...lwcConfig.configs.recommended,
  ...lwcConfig.configs.i18n,
];
