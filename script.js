const btnEl = document.getElementById("btn")
const jokeEl = document.getElementById("joke")

const apikey = "Yo57novC/Zc3f1ZOOkOh7A==LdHpvvX4p4s23yIT";

const options = {
    method: "GET",
    headers: {"X-Api-Key" : apikey,}
}

const apiURL = "https://api.api-ninjas.com/v1/dadjokes?limit=1"

async function getJoke() { 

    try {
        jokeEl.innerText = "...",
        btnEl.disabled = true
        btnEl.innerText = "Loading..."
        const response = await fetch(apiURL, options);
        const data = await response.json()
    
        btnEl.disabled = false
        btnEl.innerText = "Tell Me Another..."
    
        jokeEl.innerText = data[0].joke;
        
        
    } catch (error) {
        jokeEl.innerText = "An error occurred, try again later..."
        btnEl.disabled = false
        btnEl.innerText = "We're Back!"
        console.log(error);

  
        
    }


    }


btnEl.addEventListener("click", getJoke)