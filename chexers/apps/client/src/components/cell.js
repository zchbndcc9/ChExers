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

const cellDark = { 
  ...cell,
  backgroundColor: "#b8b8b8"
}

const Cell = ({odd, select}) => (
  <div class="cell" style={odd ? cellDark : cell} onClick={() => select()}/>
)

export default Radium(Cell)