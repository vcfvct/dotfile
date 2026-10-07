const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const repo = path.resolve(__dirname, '../..');
const fish = spawnSync('fish', ['--version']).status === 0;

function runMigration(installed, { zoxide = true, removeFails = false } = {}) {
  const home = fs.mkdtempSync(path.join(os.tmpdir(), 'dotfile-fish-plugins-'));
  try {
    const bin = path.join(home, 'bin');
    fs.mkdirSync(bin);
    if (zoxide) {
      fs.writeFileSync(path.join(bin, 'zoxide'), '#!/bin/sh\nexit 0\n', { mode: 0o755 });
    }
    // Isolate HOME, universal variables, plugin state, and command lookup.
    // This fake Fisher never downloads or deletes anything.
    return spawnSync('fish', ['--no-config', '-c', `
      set -g fish_function_path
      set -g PATH "$TEST_BIN"
      set -g installed_plugins (string split --no-empty ' ' -- "$TEST_PLUGINS")
      function fisher
        switch $argv[1]
          case list
            printf '%s\\n' $installed_plugins
          case remove
            echo "remove:$argv[2]"
            if test "$TEST_REMOVE_FAILS" = 1
              return 1
            end
            set -l index (contains -i -- $argv[2] $installed_plugins)
            set -e installed_plugins[$index]
          case install
            echo "install:$argv[2]"
            set -ga installed_plugins $argv[2]
        end
      end
      source "$TEST_SCRIPT" "$TEST_MANIFEST"
    `], {
      encoding: 'utf8',
      env: {
        ...process.env,
        HOME: home,
        XDG_CONFIG_HOME: path.join(home, '.config'),
        XDG_DATA_HOME: path.join(home, '.local/share'),
        TEST_BIN: bin,
        TEST_PLUGINS: installed.join(' '),
        TEST_REMOVE_FAILS: removeFails ? '1' : '0',
        TEST_SCRIPT: path.join(repo, 'devbox/scripts/fish-plugins.fish'),
        TEST_MANIFEST: path.join(repo, '.config/fish/fishfile'),
      },
      input: '',
    });
  } finally {
    fs.rmSync(home, { recursive: true, force: true });
  }
}

const existing = ['jorgebucaran/nvm.fish', 'oh-my-fish/theme-bobthefish', '0rax/fish-bd'];

test('migrates only jethrokuan/z and preserves unrelated installed plugins', { skip: !fish }, () => {
  const result = runMigration([...existing, 'jethrokuan/z', 'local/unrelated']);
  assert.equal(result.status, 0, result.stderr);
  assert.equal(result.stdout, 'remove:jethrokuan/z\n');
});

test('rerun does not remove or reinstall plugins', { skip: !fish }, () => {
  const result = runMigration(existing);
  assert.equal(result.status, 0, result.stderr);
  assert.equal(result.stdout, '');
});

test('fresh install excludes the retired z plugin and maps fish-nvm', { skip: !fish }, () => {
  const result = runMigration([]);
  assert.equal(result.status, 0, result.stderr);
  assert.equal(result.stdout, existing.map(plugin => `install:${plugin}\n`).join(''));
});

test('does not remove old z if the replacement binary is missing', { skip: !fish }, () => {
  const result = runMigration([...existing, 'jethrokuan/z'], { zoxide: false });
  assert.equal(result.status, 1);
  assert.match(result.stderr, /Install zoxide before removing jethrokuan\/z/);
  assert.equal(result.stdout, '');
});

test('stops when Fisher removal fails', { skip: !fish }, () => {
  const result = runMigration(['jethrokuan/z'], { removeFails: true });
  assert.equal(result.status, 1);
  assert.equal(result.stdout, 'remove:jethrokuan/z\n');
});
