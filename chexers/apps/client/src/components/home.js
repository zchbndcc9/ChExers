import { h, Component } from "preact"
import { route } from "preact-router";
import axios from "axios"

class Home extends Component {
  createGame() {
    axios.post("http://localhost:4000/api/game", {
      headers: {
        'Access-Control-Allow-Origin': '*'
      }
    }).then(({data: {name: name}})=> {
      route(`/game/${name}`)
    })
  }

  joinGame() {

  }

  render() {
    return(
      <div>
        <div class="jumbotron">
          <h1>ChExers</h1>
        </div>
        <div class="container d-flex justify-content-around align-items-center">
          <div>
            <h3 class="mb-3">Join existing game</h3>
            <form class="form-inline" onSubmit={this.createGame}>
              <div class="form-group">
                <input name="gameName" id="gameName" class="form-control mr-3" type="text" placeholder="e.x. 'obnoxious-car'" />
                <button type="submit" class="btn btn-primary">Join Game</button>
              </div>
            </form>
          </div>
          <h2>OR</h2>
          <div>
            <h3 class="mb-3">Create a new game</h3>
            <button class="btn btn-success" onclick={this.createGame}>Create Game</button>
          </div>
        </div>
      </div>
    )
  }
}

export default Home