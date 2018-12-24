import { h, Component } from 'preact'

const chatBox = {
  border: "1px #a6a6a6 solid",
  borderRadius: "0.5em",
  width: "25em",
  height: "30em",
  overflow: "scroll"
}
const Chat = ({messages, send}) => (
  <div>
    <ul class="list-group list-group-flush" style={chatBox}>
      { messages.map((msg) => <li class="list-group-item">{msg}</li>) }
    </ul>
    <form class="form d-flex mt-3" onSubmit={send}>
      <input type="text" class="form-control mr-3 flex-grow" name="message" id="message" placeholder="Message" />
      <button type="submit" class="btn btn-success">Send</button>     
    </form>
  </div>
)

export default Chat