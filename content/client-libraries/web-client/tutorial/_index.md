---
title: Browser Client Tutorial
description: Get started with Javascript and Speechly
display: article
weight: 1
menu:
  integrations:
    title: "Tutorial Guide"
    weight: 1
    parent: "Browser Client"
---

{{< info title="Clone and try" >}}
  Try out the app by cloning the repository and using the appid `6e61df24-2fbe-4cd9-b560-3c39842bafea`
{{< /info >}}

{{< button "https://github.com/speechly/speech-to-chess/" "logo-github" "light" "Tutorial Repository" >}}

# SpeechToChess tutorial

Let’s play chess by using voice! In this tutorial, we’ll build a simple chess game with JavaScript that can be controlled by using voice commands.

After completing this tutorial, you will be able to create a [Speechly](https://www.speechly.com/) voice interface for a new project or integrate it to an existing one in Javascript.

Chessboard consists of rows and columns, or in the language of chess ranks and files. The files (columns) are identified by the letters a to h and the ranks (rows) by the numbers 1 to 8. In this tutorial, we will be using the [chess game  notation](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)): “e4 e5 Nf3 Nc6 Bb5 a6 Ba4 Nf6”. Upper-case letters N and B stand for the knight and bishop.

You say “knight f3" and Speechly will provide you with a javascript object of intent
```
{
 “intent”: “move”
}
```
and an array of entities
```
[
  {
    “type”: “piece”,
    “value”: “KNIGHT”
  },
  {
    “type”: “square”,
    “value”: “F3"
  }
]
```
## Define intents in SAL - Speechly Annotation Language

Building [voice user interfaces](https://www.speechly.com/blog/voice-application-design-guide/) starts from the declaration of the intents and entities. In our chess example, the most common user intent is to move a piece on the board. This intent has two entities (modifiers for this intent): piece and square where this piece will be moved.  

Go to [Speechly Dashboard](https://api.speechly.com/dashboard/), login and click on the “Create app” button. 

{{< info title="Quick Start to Dashboard" >}}If you are unsure on how to use the Speechly Dashboard, see our [Quick Start](/quick-start/){{</info>}}

Set a name for the app. Now you can see the editor where you can write your SAL code.
Like mentioned,the intents in chess are moves. There is a list of intents on the right side of the screen, type the name of the first intent “move” and click on “Add” button.

There are also two kinds of special moves: “capture” and “castle”, add them to the list, too. And finally we need an intent to restart the game, call it “reset”.

Add three entities: “piece” of the type string and “square” as the type identifier. 

SAL uses a asterisk (*) to define an intent. To define an entity in SAL syntax list all the possible values in square brackets followed by the entity name in parenthesis `[knight|bishop](piece)`. We can set the above mentioned list as a variable `pieces = [pawn|knight|bishop|rook|queen|king]`. Set also variables for the lists of squares. 

SAL code sample:
```
pieces = [pawn|knight|bishop|rook|queen|king]
squares = [
  A8|B8|C8|D8|E8|F8|G8|H8
  A7|B7|C7|D7|E7|F7|G7|H7
  A6|B6|C6|D6|E6|F6|G6|H6
  A5|B5|C5|D5|E5|F5|G5|H5
  A4|B4|C4|D4|E4|F4|G4|H4
  A3|B3|C3|D3|E3|F3|G3|H3
  A2|B2|C2|D2|E2|F2|G2|H2
  A1|B1|C1|D1|E1|F1|G1|H1
]
*move {$pieces(piece)} $squares(square)
*castle castle
*capture $pieces(piece) takes $pieces(piece) on $squares(square)
*reset new game
```

Curly braces wrap the optional values. You can refer to [Cheat Sheet for SAL syntax](https://docs.speechly.com/slu-examples/cheat-sheet/) for more information on the syntax. 

You can see the App ID under the application name. You’ll need to use it when integrating the project. 

## Deploy Speechly app and try

Now you can play around with your configuration. Press “Deploy” and wait for about 2 minutes.

When you see the status “Deployed”, press “Try”. The Playground screen will show up. Press space and hold it to say something like “KNIGHT E4”, “KNIGHT takes PAWN on E5", “castle”.

## Create a plain javascript project

Now we can start building our Javascript application.

Create a new folder `mkdir MyVoiceApp` and run there `yarn init`. Add Speechly’s client and webpack for bundling the code `yarn add @speechly/browser-client webpack webpack-cli`. By default webpack looks for the index.js file in the src folder and creates a bundle named main.js in the dist folder.

Add index.js file to the src folder and index.html file to the dist folder.

src/index.js
```
import { Client } from ‘@speechly/browser-client’;
console.log(‘Hello Speechly!’);
```
dist/index.html 
```
<html>
<head>
  <style>
    * {font-size: 40px}
    table {border: 1px #000 solid}
    td {text-align: center}
    tr:nth-child(2n+1) td:nth-child(2n), tr:nth-child(2n) td:nth-child(2n+1) {
      background: #DDD
    }
  </style>
</head>
<body>
  <script src=“main.js”></script>
  <table id=“board” cellpadding=0 cellspacing=0></table>
  <br/>
  <button id=“mic”>Microphone</button>
</body>
</html>
```

Now you can run the bundler `yarn run webpack`. As a result you will get the main.js file in the dist folder.

Open the index.html file in Chrome browser. You will see the ‘Microphone’ button on the screen and the greeting in the console.

## Client is a key

Create a new Client and initialize it: 
```
const client = new Client({
 appId: ‘HereIs-AppId-From-The-Dashbord’,
 language: ‘en-US’,
});
client.initialize();
```
Bind the ‘Microphone’ button to record and send voice audio:
```
 window.onload = () => {
 document.getElementById(‘mic’).onmousedown = () => client.startContext();
 document.getElementById(‘mic’).onmouseup = () => client.stopContext();
};

```
We will connect the game and the client by the onSegmentChange event handler:
```
client.onSegmentChange((segment) => {
  if (segment.intent && segment.isFinal) {
    // TODO: game logic
  }
}
```

## State of the game, reducer and rendering

Create game object with the default position on the chessboard to store the state. Add reducer function to update the game state by incoming segments. Finally add a function to render the chessboard.

```
const defaultPosition = [
 [‘r’, ‘n’, ‘b’, ‘q’, ‘k’, ‘b’, ‘n’, ‘r’],
 [‘p’, ‘p’, ‘p’, ‘p’, ‘p’, ‘p’, ‘p’, ‘p’],
 [‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’],
 [‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’],
 [‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’],
 [‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’, ‘.’],
 [‘P’, ‘P’, ‘P’, ‘P’, ‘P’, ‘P’, ‘P’, ‘P’],
 [‘R’, ‘N’, ‘B’, ‘Q’, ‘K’, ‘B’, ‘N’, ‘R’],
];
let game = {
 position: defaultPosition,
 activeColor: ‘w’,
};
/**
 * Creates a new position by changing current file and rank of a piece
 */
function move(position, {file, rank}, dst) {
 const piece = position[rank][file];
 let newPosition = position;
 newPosition[rank][file] = ‘.’;
 newPosition[dst.rank][dst.file] = piece;
 return newPosition;
}
const files = [‘A’, ‘B’, ‘C’, ‘D’, ‘E’, ‘F’, ‘G’, ‘H’];
/**
 * Transforms square string value like ‘E4’ to an object with coordinates
 * 
 * @param {string} square
 * @return {object} file number and rank number combined in an object.
 */
const transformCoordinates = (square) => ({
 file: files.indexOf(square[0]),
 rank: 8 - square[1]
});
const pieces = {
 PAWN: ‘P’,
 KNIGHT: ‘N’,
 BISHOP: ‘B’,
 ROOK: ‘R’,
 QUEEN: ‘Q’,
 KING: ‘K’,
};
/**
 * Transforms array of entities to a key value object
 * @param {array} entities 
 * @return {object} key value object.
 */
const formatEntities = (entities) =>
 entities.reduce((accumulator, currentValue) => ({
  ...accumulator,
  [currentValue.type]: currentValue.value
 }), {});
/**
 * Creates a new game state
 * @return {object} new state of the game.
 */
const reducer = (game, segment) => {
 switch (segment.intent.intent) {
  case ‘reset’:
   const newGame = {
    position: defaultPosition,
    activeColor: ‘w’,
   };
   return newGame;
  case ‘move’:
   let {piece, square} = formatEntities(segment.entities);
   if (piece) {
    piece = pieces[piece];
   } else {
    piece = ‘P’;
   }
   piece = game.activeColor === ‘b’ ? piece.toLowerCase() : piece;  
   const {file, rank} = transformCoordinates(square);
   const selectedPiece = selectPiece(game, piece, file, rank);
   if (!selectedPiece) {
    console.error(`Can’t find out the piece ${piece} for move on ${square}`);
    return game;
   }
   return {
    position: move(game.position, selectedPiece, {file, rank}),
    activeColor: game.activeColor === ‘w’ ? ‘b’ : ‘w’,
   };
  case ‘capture’:
   return game;
  case ‘castle’:
   let newPosition;
   if (game.activeColor === ‘w’) {
    newPosition = move(game.position, transformCoordinates(‘E1’), transformCoordinates(‘G1’));
    newPosition = move(newPosition, transformCoordinates(‘H1’), transformCoordinates(‘F1’));
   } else {
    newPosition = move(game.position, transformCoordinates(‘E8’), transformCoordinates(‘G8’));
    newPosition = move(newPosition, transformCoordinates(‘H8’), transformCoordinates(‘F8’));
   }
   return {
    position: newPosition,
    activeColor: game.activeColor === ‘w’ ? ‘b’ : ‘w’,
   };
  default:
   return game;
 }
}
/**
 * Since user provide us only with a destination square for example ‘E4’,
 * we add a selectPiece function to get the piece coordinates on the chessboard.
 */

function selectPiece(game, piece, newFile, newRank) {
 return game.position.flatMap((rank) => rank)
  .map((piece, i) => ({ piece, rank: Math.floor(i / 8), file: (i % 8) }))
  .find((item) =>
   item.piece === piece
   && isCorrectMove(piece, newRank, newFile, item.rank, item.file));
}
/**
 * Checks correctness of a move
 * @return {boolean} is correct.
 */
function isCorrectMove(piece, rank, file, rankIndex, fileIndex) {
 const dRank = Math.abs(rankIndex - rank);
 const dFile = Math.abs(fileIndex - file);
 switch (piece.toUpperCase()) {
  case ‘P’:
   return file === fileIndex && dRank <= 2;
  case ‘N’:
   return dRank + dFile === 3 && Math.abs(dRank - dFile) == 1;
  case ‘B’:
   return dRank === dFile;
  case ‘R’:
   return rankIndex === rank || fileIndex === file;
  default:
   return false;
 }
};
/**
 * Maps the game position to html table content 
 */
function renderBoard(position) {
 const view = position.map(
  (rank) => `<tr>${
   rank.map((file) => `<td>${file}</td>`).join(‘’)
  }</tr>`,
 ).join(‘’);
 document.getElementById(‘board’).innerHTML = view;
};
```
Now you can call the game reducer on each event with a segment and render the chessboard.
```
client.onSegmentChange((segment) => {
  if (segment.intent && segment.isFinal) {
      game = reducer(game, segment);
      renderBoard(game.position);
  }
}
```
## Enjoy the game
Now you can run your application by running ´yarn start´ 9. Oress the ‘Microphone’ button and say ‘E4’ and release the button. Repeat with ‘E5’, ‘knight f3’, ‘knight c6’ etc.

Have a great game!
