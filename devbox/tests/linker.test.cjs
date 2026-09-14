const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const repo = path.resolve(__dirname, '..', '..');
const linker = path.join(repo, 'symbolLink.js');

function fixture(t) {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'dotfile-devbox-test-'));
  t.after(() => fs.rmSync(root, { recursive: true }));
  const home = path.join(root, 'home with spaces');
  const local = path.join(home, 'AppData', 'Local');
  fs.mkdirSync(local, { recursive: true });
  const env = { ...process.env, HOME: home, USERPROFILE: home, LOCALAPPDATA: local };
  const run = (args = [], cwd = repo) => spawnSync(process.execPath, [linker, '--devbox', ...args], {
    cwd, env, encoding: 'utf8',
  });
  return { root, home, local, run };
}

test('plan is JSON, maps Windows nvim correctly, and writes nothing', t => {
  const { home, local, run } = fixture(t);
  const result = run(['--plan']);
  assert.equal(result.status, 0, result.stderr);
  const plan = JSON.parse(result.stdout);
  assert.ok(plan.some(entry => entry.destination === path.join(
    process.platform === 'win32' ? local : path.join(home, '.config'), 'nvim')));
  assert.deepEqual(fs.readdirSync(home), ['AppData']);
});

test('existing files and directories are backed up and reruns are no-ops', t => {
  const { home, local, run } = fixture(t);
  const nvim = path.join(process.platform === 'win32' ? local : path.join(home, '.config'), 'nvim');
  fs.mkdirSync(nvim, { recursive: true });
  fs.writeFileSync(path.join(nvim, 'personal.txt'), 'keep me');
  fs.writeFileSync(path.join(home, '.gitconfig'), 'personal git config');
  let result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.equal(fs.realpathSync(nvim), fs.realpathSync(path.join(repo, '.config', 'nvim')));
  const gitBackup = fs.readdirSync(home).find(name => name.startsWith('.gitconfig.devbox-backup-'));
  assert.equal(fs.readFileSync(path.join(home, gitBackup), 'utf8'), 'personal git config');
  const nvimBackup = fs.readdirSync(path.dirname(nvim)).find(name => name.startsWith('nvim.devbox-backup-'));
  assert.equal(fs.readFileSync(path.join(path.dirname(nvim), nvimBackup, 'personal.txt'), 'utf8'), 'keep me');
  const files = fs.readdirSync(home);
  result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(fs.readdirSync(home), files);
  assert.doesNotMatch(result.stdout, /Backup:/);
});

test('missing source fails before changing any destinations', t => {
  const { root, home, run } = fixture(t);
  const emptyRepo = path.join(root, 'empty');
  fs.mkdirSync(emptyRepo);
  const target = path.join(home, '.gitconfig');
  fs.writeFileSync(target, 'untouched');
  const result = run([], emptyRepo);
  assert.notEqual(result.status, 0);
  assert.equal(fs.readFileSync(target, 'utf8'), 'untouched');
  assert.deepEqual(fs.readdirSync(home).sort(), ['.gitconfig', 'AppData']);
});

test('does not write through a linked parent directory', t => {
  const { root, home, run } = fixture(t);
  const external = path.join(root, 'other configuration');
  fs.mkdirSync(external);
  fs.symlinkSync(external, path.join(home, '.config'), process.platform === 'win32' ? 'junction' : 'dir');
  const result = run();
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Refusing to write through linked parent/);
  assert.deepEqual(fs.readdirSync(external), []);
  assert.equal(fs.existsSync(path.join(home, '.gitconfig')), false);
});

test('broken directory links are preserved as backups', t => {
  const { root, local, home, run } = fixture(t);
  const nvim = path.join(process.platform === 'win32' ? local : path.join(home, '.config'), 'nvim');
  fs.mkdirSync(path.dirname(nvim), { recursive: true });
  const missing = path.join(root, 'missing');
  fs.symlinkSync(missing, nvim, process.platform === 'win32' ? 'junction' : 'dir');
  const result = run();
  assert.equal(result.status, 0, result.stderr);
  const backup = fs.readdirSync(path.dirname(nvim)).find(name => name.startsWith('nvim.devbox-backup-'));
  assert.ok(fs.lstatSync(path.join(path.dirname(nvim), backup)).isSymbolicLink());
  assert.equal(fs.realpathSync(nvim), fs.realpathSync(path.join(repo, '.config', 'nvim')));
});

test('verify is read-only and detects missing configuration', t => {
  const { home, run } = fixture(t);
  assert.equal(run().status, 0);
  assert.equal(run(['--verify']).status, 0);
  const target = path.join(home, '.gitconfig');
  fs.unlinkSync(target);
  const result = run(['--verify']);
  assert.notEqual(result.status, 0);
  assert.equal(fs.existsSync(target), false);
});

test('mistyped safe option cannot fall through to the legacy linker', t => {
  const { home } = fixture(t);
  const result = spawnSync(process.execPath, [linker, '--devbo'], {
    cwd: repo, env: { ...process.env, HOME: home }, encoding: 'utf8',
  });
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Unknown option/);
  assert.deepEqual(fs.readdirSync(home), ['AppData']);
});
