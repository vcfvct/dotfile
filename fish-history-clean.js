// extract commands that is sort of useful for migration purposes.
const fs = require('fs');

const h = fs.readFileSync('./fish_history', 'utf-8').split('\n');
const rs = [];
const cmdPrefix = '- cmd: '
const blackList = [
  `${cmdPrefix}git`,
  `${cmdPrefix}z `,
  `${cmdPrefix}ls`,
  `${cmdPrefix}ag `,
];

const whiteList = [
  `${cmdPrefix}avenue `,
  `${cmdPrefix}onecloud `,
  `${cmdPrefix}curl `,
  `${cmdPrefix}aws `,
  `${cmdPrefix}system_profiler `,
  `${cmdPrefix}openssl `,
  `${cmdPrefix}docker `,
  `${cmdPrefix}k6 `,
  `${cmdPrefix}java `,
  `${cmdPrefix}ssh `,
]

let includeRow = false;
for(const l of h){
  if(l.startsWith(cmdPrefix)){
    // includeRow = !isBadStart(l);
    includeRow = isGoodStart(l);
  }
  includeRow && rs.push(l);
}
fs.writeFileSync('output', rs.join('\n'));

function isBadStart(line){
  return blackList.some(pre => line.startsWith(pre));
}

function isGoodStart(line){
  return whiteList.some(pre => line.startsWith(pre));
}
