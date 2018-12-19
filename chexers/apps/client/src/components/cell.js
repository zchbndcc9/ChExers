import preact from 'preact'
import Radium from 'radium'

const cell = {
  width: "3.5em",
  height: "3.5em",
  border: "1px black solid",
  ":hover": {
    cursor: "pointer"
  }
}

const piece = {
  margin: "auto auto auto auto",
  width: "3em",
  height: "3em",
  border: "0.5px black solid",
  borderRadius: "50%"
}

const pieceDark = {
  ...piece,
  backgroundColor: "black"
}

const pieceLight = {
  ...piece,
  backgroundColor: "white"
}

const cellDark = { 
  ...cell,
  backgroundColor: "#b8b8b8"
}

const putColor = (color) => {
  let type = color === "white" ? pieceLight : pieceDark
  return (
    <div class="piece" style={type}></div>
  )
}

const Cell = ({odd, piece, select}) => (
  <div class="cell" style={odd ? cellDark : cell} onClick={() => select()}>
    {piece ? putColor(piece) : piece}
  </div>
)

export default Radium(Cell)