# Setting up Continue.dev with Ollama and codellama-7b-instruct as model

## Prerequisites

- installed Docker
- installed Ubuntu distribution via WSL2 (ubuntu 22 can be downloaded via windows store)
- At least 8 GB of free RAM for 7B models, 16 GB for 13B models, and 32 GB for 33B models
- At least ~25GB of space on the SSD

## 1 (only if running with Docker or Docker compose) - Setup Nvidia Container GPU Support

Download the recommended cuda drivers from nvidia to make sure they run smooth with large data: <https://developer.nvidia.com/cuda-downloads>

Execute all of the following commands in the ubuntu terminal (on windows, after installing ubuntu, just search for ubuntu and open it. It will open a console app).

Configuring the nvidia repository (guide steps also here: <https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html>)

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

Configure the repository to allow experimental packages as GPU support is quite new

```bash
sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

Update the packages list from the repository

```bash
sudo apt-get update
```

Install the NVIDIA Container Toolkit packages

```bash
sudo apt-get install -y nvidia-container-toolkit
```

You can test the GPU support with this container (optional), can be cancelled after it has run:

```bash
docker run --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark
```

Then check what CUDA version is used by running:

```bash
nvidia-smi
```

Note the CUDA Version in the upper right corner (should be 12.2 on the newer Dell Laptops with Nvidia RTX A1000)

## 2/1 - Setup Ollama in docker-compose

- Create a folder in which the docker compose of ollama should be saved (alternatively, docker run command at the bottom)
- Go to the new folder
- Copy the following contents to a new file called `docker-compose.yml`

docker-compose.yml

```yml
version: '2.3'
services:
  ollama:
    image: ollama/ollama
    container_name: ollama
    restart: unless-stopped
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    volumes:
      - ./ollama:/root/.ollama
    ports:
      - "11434:11434"
    tty: true
```

This will create a local folder in the directory of the docker-compose.yml where the models and other data is saved. If it should be saved to a normal docker volume instead, the volumes line should be adjusted to:

```yml
volumes:
      - ollama:/root/.ollama
```

Afterwards, in the same directory, open a terminal and enter those two commands:

To start the docker compose:

```bash
docker compose up -d
```

And after waiting a few seconds so it is able to first initialize:

```bash
docker exec -it ollama ollama run codellama:7b-instruct
```

 to download and run the codellama model (only required on first time).

Alternatively the docker run (also requires the docker exec one time afterwards):

```bash
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

## 2/2 - Setup Ollama as windows client (was slower in recent tests)

- Download the ollama windows client: <https://registry.ollama.ai/download/windows>
- Open the client
- Enter the command:

  ```bash
  ollama run codellama:7b-instruct
  ```

## Setup Continue.dev

Install the Continue.dev Visual Studio Code extension: <https://marketplace.visualstudio.com/items?itemName=Continue.continue>
When opening the Continue view, click on the settings button on the lower right. A config.json should open. There, make sure that there is this paragraph (models are empty on start):

```json
  "models": [
    {
      "title": "CodeLlama:7b-ollama",
      "model": "codellama:7b-instruct",
      "completionOptions": {},
      "apiBase": "http://localhost:11434",
      "provider": "ollama"
    }
  ],
```

## Other Models

Other models can be specified from the Ollama Library: <https://ollama.com/library>.
To use other models, the models paragraph in the json (from Setup Continue.dev) has to be changed to the name of the model that is used and the docker exec command on ollama has to be run with the other model once so that ollama downloads and initializes it.

Currently, only the Codellama license was checked and appears to be fine. The other versions of codellama can be viewed here: <https://ollama.com/library/codellama>

## Licences

Last updated (last seen): 27.02.2024

- continue.dev: Apache 2.0 License: <https://github.com/continuedev/continue/blob/main/LICENSE>
- Ollama: MIT: <https://github.com/ollama/ollama?tab=MIT-1-ov-file>
- CodeLLama - Meta AI License <https://github.com/facebookresearch/llama/blob/main/LICENSE>
- Nvidia Cuda custom License: <https://docs.nvidia.com/cuda/eula/index.html>
- Nvidia container toolkit: Apache 2.0: <https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/1.13.1/index.html#license>

## Other information

Note: It is normal that the first view prompts and after the container restarted 1-2 times, the models are very slow. After some usage, it drastically increases in speed.

## Disclaimer

It is incumbent upon each individual to ensure that the tools and models employed are appropriately licensed for the intended use cases. This technical guide is provided without any guarantees or warranties.
