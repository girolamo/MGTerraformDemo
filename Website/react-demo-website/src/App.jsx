import './App.css'

const handleClick = () => {
    window.open('https://www.linkedin.com/in/michalgrzech/', '_blank');
};

function App() {
  return (
    <>
      <h1>Michal's Grzech portfolio demo app</h1>
      <p>This app was deployed on Azure by using Terraform</p>
      <div className="card">
        <button onClick={handleClick}>
          Click me, and visit my LinkedIn
        </button>
      </div>
      <p className="read-the-docs">
        Thanks for checking my protfolio!
      </p>
    </>
  )
}

export default App
