import preact from 'preact'
import Cell from './cell'
import cell from './cell';

const board = {
  display: "inline-block"
}

class Board extends preact.Component {
  constructor(props) {
    super(props)
    this.state = {
      currentPicked: {
        row: 0,
        col: 0
      }
    }
    this.selectCell = this.selectCell.bind(this)
  }

  drawBoard() {
    if (this.props.board === undefined) return (<div></div>)

    
    let cells = this.props.board.map(({occupier, row, col}) => <Cell odd={row%2 === col%2} piece={occupier}></Cell>)

  }

  selectCell(row, col) {
    this.setState({
      currentPicked: {
        row: row,
        col: col
      }
    })
  }

  render() {
    let gameBoard = this.drawBoard()
    return (
      <div className="board" style={board}>
        {gameBoard}
      </div>
    )
  }
}

export default Board