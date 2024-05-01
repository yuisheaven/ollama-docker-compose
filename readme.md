# Setting up a local Chat-GPT like experience (with Ollama and Open-Webui)

## Prerequisites

- installed Docker
- installed current wsl2 kernel (have a successfully working wsl2 setup)
- At least 8 GB of free RAM for 7B models, 16 GB for 13B models, and 32 GB for 33B models (llama3 is an 8B model)
- At least ~25 - 50GB of space on the SSD drive

## 1 - Setup Ollama in docker-compose

Clone / Download the repository.

With a terminal, go to the newly downloaded folder (in Windows, right click and press on Open with Terminal)

To start the docker compose, either run the command:

```bash
docker compose up -d
```

or if you are on windows, you can double click the `start services.bat`

## 2 - Download models via open-webui

If the docker compose command was executed successfully, you can go to <http://localhost:8080> and register to the local open-webui instance. This is only local, so you don't need to set strong credentials here as long as you don't forward the port to the outer internet (which this docker compose does not do).

Being in the open-webui, click on your user on the lower left of the screen -> Settings -> Models.
To know how the models need to be called, have a look at the library of ollama: <https://ollama.com/library>
Then, enter the model name in the text field and press on the download button. This should automatically download and setup the model for you. I would recommend not to leave the page until you see the green notification that the model has been successfully downloaded.

Going back to the chats window of the open-webui, you should now be able to select your downloaded model.
If you start docker compose the next time, you do not need to download it again as long as you don't manually delete the docker volumes. Everything should stay saved as long as the docker compose is only stopped, updates, restarted and started.

## 3 - Stopping / Updating / Starting again

Those commands need to be executed in the same directory/folder where the docker-compose.yml is.

To stop it, use:

```bash
docker compose down
```

or the `stop services.bat`

To update it, first stop it and then execute:

```bash
docker compose pull
```

or use the `update and restart.bat`

This will update Ollama and the Open-Webui both at once.

To start everything again, use 

```bash
docker compose up -d
```

or the `start services.bat`

## Optional - Setup Continue.dev (Visual Studio Code Extension)

Install the Continue.dev Visual Studio Code extension: <https://marketplace.visualstudio.com/items?itemName=Continue.continue>
When opening the Continue view, click on the settings button on the lower right. A config.json should open. There, make sure that there is this paragraph (models are empty on start):

```json
  "models": [
    {
      "title": "llama3",
      "model": "llama3",
      "completionOptions": {},
      "apiBase": "http://localhost:11434",
      "provider": "ollama"
    }
  ],
```

## Addressing RAM / Memory issues

As docker uses wsl2, it often piles up a lot of memory without freeing it.
To address this, I recommend setting up a custom wsl config file like the one here in the repository.
If you cannot see it, make sure to enable this in windows: "View" -> "Show" -> "Hidden items" and "View" -> "Show" -> "File name extensions".

Then, place the .wslconfig file into your users directory. For instance, in windows this could then look like:
`C:\Users\yourUser\.wslconfig`

Make sure to edit the file to fit the specs of your computer.

```text
[wsl2]
 
memory=20GB # this is your RAM/memory allocation of wsl. This should be around 70% of your max RAM if you don't need any other programs running in parallel to your AI. If you need other programs, I recommend about 50% of your maximum RAM

[experimental]
autoMemoryReclaim=dropcache
```

If you want to clear your RAM/memory in-between, you can execute the clear-wsl batch scripts for windows.
For the most users, the `clear-wsl-ram-from-docker-itself.bat` is the correct one as you don't need to use any other wsl distribution for it. 
For some power users, it might be interesting to clear the cache for the other running distro as well which is why the other script exists.

## Disclaimer

It is incumbent upon each individual to ensure that the tools and models employed are appropriately licensed for the intended use cases. This technical guide is provided without any guarantees or warranties.
