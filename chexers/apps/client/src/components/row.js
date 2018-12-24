import preact from 'preact'
import Cell from './cell'

const row = {
  display: "flex",
  flexDirection: "row"
}

const Row = ({size, num, select,...props}) => {
  let cells = []

  for(let i = 0; i < size; i++) {
    cells.push(<Cell key={num+i} odd={num%2 === i%2} select={() => select(num, i)}/>)
  }

  return (
    <div className="row" style={row}>
      {cells}
    </div>
  )
}

export default Row