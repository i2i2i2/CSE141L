#! /usr/local/bin/node

const fs = require("fs");

const RED = "\033[31;1m";
const YELLOW = "\033[32;1m";
const RESET = "\033[0m";

const ref = require("./instr.json");
const instrTable = ref.instr;
const regsTable = ref.regs;

// parsing args
var filename;
if (process.argv.length != 3) {
  console.log(RED + "Error: " + RESET + "Incorrect Arguments Number");
  console.log("  USAGE: ./compiler.js [File Name]");
  return 1;

} else {
  filename = process.argv[2];
}

// try open file
var assembly;
try {
  assembly = fs.readFileSync(filename, 'utf-8');
} catch (err) {
  console.log(RED + "Error: " + RESET + err);
  return 1;
}

// prepare parsing
var bitcodes = [];                // store instruction bit codes
var branches = {};                // future branch storage
var branchTaken = [];             // taken branches
assembly = assembly.split("\n");  // turn string to array

// parse line by line
assembly.forEach((line, index) => {

  // remove white space and comment, format to array
  line = line.replace(/!.*$/, "").split(/\s+/).filter(word => word);

  // if empty line move to next
  if (!line.length) {
    return;
  }

  // invalid line
  if (line.length > 2) {
    console.log(JSON.stringify(line, null, 2));
    errorGen(index, "Invalid Instruction Format.")
    return;
  }

  // if line is a branch label
  if (line.length == 1 && line[0].substr(-1) == ':') {
    var label = line[0].substr(0, line[0].length - 1);
    branches[label] = bitcodes.length;
    return;
  }

  // check if instruction valid
  var instr = instrTable[line[0]];
  if (!instr) {
    errorGen(index, "Unknown Instruction: " + RED + line[0] + RESET);
    return;
  }

  // if valid check which kind of command
  var bitcode;
  if (instr.imm) {
    bitcode = processImm(line, index, instr);

  } else if (instr.reg) {
    bitcode = processReg(line, index, instr);

  } else if (instr.branch) {
    bitcode = processBranch(line, index, instr);

  } else {
    if (line.length != 1) {
      errorGen(index, "Invalid Instruction Format: "
          + "No argument should be provided.");
      return;
    }

    bitcode = instr.pre + instr.opcode + "00";
  }

  if (bitcode) {
    bitcodes.push(bitcode);
  }
});

// verify
// verify(bitcodes, branchTaken);

// turn parsed result to instr code
bitcodes = bitcodes.map(code => padding(parseInt(code, 2).toString(16), 3));
bitcodes = bitcodes.join("\n");
branchTaken = branchTaken.map(branch => padding(branch.toString(16), 2));
branchTaken = branchTaken.join("\n");

// store to File
try {
  fs.writeFileSync("instr", bitcodes);
  fs.writeFileSync("branch", branchTaken);

} catch (err) {
  console.log(RED + "Error: " + RESET + err);
  return 1;
}

console.log("Instruction Code and Branch Look Up table File Generated!");
return 0;


/* helper function */
function processBranch(line, index, instr) {
  // check argument counts
  if (line.length != 2) {
    errorGen(index, "Invalid Instruction Format: "
        + "A branch label must be provided.");
    return "";
  }

  // check branch
  var label = branches[line[1]];
  if (!label) {
    errorGen(index, "Invalid Instruction Format: "
        + "Unknown branch label");
    return null;
  }

  // check maximum number of branch exceed?
  if (branchTaken.length == 4 && branchTaken.indexOf(label) == -1) {
    errorGen("Invalid Instruction Format: "
        + "Unknown branch label (only backward branch is supported)");
    return "";
  }

  // if push to branch
  if (branchTaken.length < 4) {
    branchTaken.push(label);
  }

  var branch = padding(branchTaken.indexOf(label).toString(2), 2);

  return instr.pre + instr.opcode + branch;
}

function verify(bitcodes, branches) {
  var regsArr = {"00": "$t0", "01": "$t1", "10": "$t2", "11": "$t3"};

  var str = "";
  bitcodes.forEach(code => {
    var instr;
    if (code.substr(0,1) == "0") {
      instr = "set     " + parseInt(code.substr(-8), 2);
      str += instr + "\n";

    } else {
      instr = revProperty(code.substr(1,6));
      var next;
      if (instrTable[instr].reg) {
        next = regsArr[code.substr(-2)];
      } else if (instrTable[instr].branch) {
        next = branches[parseInt(code.substr(-2), 2)];
      } else {
        next = "";
      }
      str += backing(instr) + next + "\n";
    }
  })

  console.log(str);

  function revProperty(code) {
    for (var key in instrTable) {
      if (instrTable.hasOwnProperty(key)) {
        if (instrTable[key].opcode == code)
          return key;
      }
    }
    return {};
  }

  function backing(instr) {
    for (var i = instr.length; i < 8; i++) {
      instr += " ";
    }
    return instr;
  }
}

function processReg(line, index, instr) {
  // check argument counts
  if (line.length != 2) {
    errorGen(index, "Invalid Instruction Format: "
        + "A register must be provided.");
    return "";
  }

  // check regs valid
  var reg = regsTable[line[1]];
  if (!reg) {
    errorGen(index, "Invalid Instruction Format: "
        + "Provided argument is not a register.");
    return;
  }

  // generate machine code
  return instr.pre + instr.opcode + reg;
}

function processImm(line, index, instr) {
  // check line length
  if (line.length != 2) {
    errorGen(index, "Invalid Instruction Format: "
        + "8-bit signed decimal integer must be provided.");
    return "";
  }

  // check parse number
  var imm = Number(line[1]);
  if (isNaN(imm)) {
    errorGen(index, "Invalid Instruction Format: "
        + "Provided argument is not a number.");
    return "";
  }

  imm = padding((imm >>> 0).toString(2), 32);
  // check overflow
  if (imm.substr(0, 24) != "000000000000000000000000"
      && imm.substr(0, 24) != "111111111111111111111111") {
    errorGen(index, "Overflow Detected: "
        + "Provided Immediate Number is larger than 8-bit");
    return "";
  }

  return instr.pre + imm.substr(-8);
}

function errorGen(index, reason) {
  var str = "Line " + (index + 1) + ", " + RED
      + "Error: " + RESET + reason;
  console.error(str);
}

function padding(str, number) {
  for (var i = str.length; i < number; i++) {
    str = '0' + str;
  }
  return str;
}
