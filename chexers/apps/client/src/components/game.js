import { h, Component } from 'preact'
import { Socket } from 'phoenix'
import axios from "axios"
import Board from './board'
import Chat from './chat'

export default class Game extends Component {
  constructor(props) {
    super(props)
    this.state = {
      messages: [],
      game: {}
    }

    this.sendMsg = this.sendMsg.bind(this)
    this.id = props.id

    let socket = new Socket("ws://localhost:4000/socket")
    socket.connect()
    this.channel = socket.channel(`game:${this.id}`, {})
  }

  componentDidMount() {
    axios.get(`http://localhost:4000/api/game/${this.id}`).then(({data}) => {
      this.setState({
        game: data
      })
    })
  }

  componentWillMount() {
    this.channel.join()
      .receive("ok", response => { console.log("Joined successfully", response) })

    this.channel.on("message", ({body: message}) => {
      this.setState((prevState) => ({
        messages: [...prevState.messages, message]
      }))
    })

    this.channel.on("move", () => {

    })
  }

  sendMsg(event) {
    event.preventDefault()
    let message = event.target.message.value

    this.channel.push("message", message)
  }

  movePiece(from, to) {
    
  }

  render() {
    let board = this.state.game.board
    return(
      <div class="game d-flex justify-content-around align-items-center mt-4">
        <Board size={8} board={this.state.game.board} />
        <Chat messages={this.state.messages} send={this.sendMsg}/>
      </div>
    )
  }
}