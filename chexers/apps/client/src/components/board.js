import preact from 'preact'
import Row from './row' 

const board = {
  display: "inline-block"
}

class Board extends preact.Component {

  constructor(props) {
    super(props)
    this.state = {
      size: props.size,
      rows: [],
      currentPicked: {
        row: 0,
        col: 0
      }
    }
    this.selectCell = this.selectCell.bind(this)
  }

  componentDidMount() {
    let newRows = []
    for(let i = 0; i < this.state.size; i++) {
      newRows.push(<Row key={i} num={i} size={this.state.size} select={(row, col) => this.selectCell(row, col)} />);
    }
    this.setState({
      rows: newRows
    })
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
    return (
      <div className="board" style={board}>
        {this.state.rows}
      </div>
    )
  }
}

export default Board