const words = document.getElementById("words");
words.addEventListener("submit", event => {
  event.preventDefault();
  let n = words["q"].value;
  getWords(n);
});

const cword = document.getElementById("cword");
cword.addEventListener("submit", event => {
  event.preventDefault();
  getCword();
});

async function getCword() {
  //let response = await fetch("https://fwordsweb.herokuapp.com/api/v1/cword");
  let response = await fetch("http://localhost:3000/api/v1/cword");

  if (response.ok) {
    const json = await response.json();
    document.getElementById("cword-output").innerText = json["cword"].replace(",", "");
  }
}

async function getWords(n) {
  //let response = await fetch(`https://fwordsweb.herokuapp.com/api/v1/words?q=${n}`);
  let response = await fetch(`http://localhost:3000/api/v1/words?q=${n}`);

  if (response.ok) {
    const json = await response.json();
    document.getElementById("words-output").innerText = Object.values(json).join(", ");
  }
}