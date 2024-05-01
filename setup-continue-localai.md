# Setting up Continue.dev with LocalAI and AI Models

Prerequisites:

- installed Docker
- installed Ubuntu distribution via WSL2
- At least 8 GB of RAM for 7B models, 16 GB for 13B models, and 32 GB for 33B models
- At least ~25GB of space on the SSD

Setup:

## Setup Nvidia Container GPU Support

Execute the following commands in the ubuntu terminal:

Configure the nvidia repository

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

You can test the GPU support with this container (optional):

```bash
docker run --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark
```

Then check what CUDA version to use by running:

```bash
nvidia-smi
```

Note the CUDA Version in the upper right corner (should be 12.2 on the newer Dell Laptops with Nvidia RTX A1000)

## Setup LocalAI

Open a windows terminal or cmd in a repository-suited folder and execute the following commands:

Clone LocalAI. For CUDA12 models: v2.4.1-cublas-cuda12 is the latest image tag. Otherwise: master-cublas-cuda12 should also work.

```bash
git clone https://github.com/go-skynet/LocalAI
```

Switch to the downloaded folder

```bash
cd LocalAI/examples/continue
```

Start it either with gpt4all-j or with a more coding-specific model like codellama.
Open the docker-compose.yml in the examples/continue folder and edit the following line. I highly recommend changing the name of the model to not get confused to which model it is allowed to send production code to and to which not as the continue.dev also features gpt-3.5 and gpt-4 trials which send data to OpenAI (those would not be allowed!).

```yaml
- 'PRELOAD_MODELS=[{"url": "github:go-skynet/model-gallery/gpt4all-j.yaml", "name": "gpt-3.5-turbo"}]'
```

to load gpt4all-j (allrounder) - attention! Licence not checked!:

```yaml
- 'PRELOAD_MODELS=[{"url": "github:go-skynet/model-gallery/gpt4all-j.yaml", "name": "gpt4all-j-local"}]'
```

or to load codellama-7b (coding specific):

```yaml
- 'PRELOAD_MODELS=[{"url": "github:go-skynet/model-gallery/codellama-7b-instruct.yaml", "name": "codellama-7b-instruct-local"}]'
```

Then, start the localai container:

```bash
docker-compose up --build -d
```

## Setup Continue.dev

Install the Continue.dev Visual Studio Code extension: <https://marketplace.visualstudio.com/items?itemName=Continue.continue>

## Licences
- LocalAI as of 27.02.2024: MIT License -> Can be used for everything but copies of the software need to include this notice. (We are not creating a copy which is why this is not relevant for us). Commercial use is not limited. <https://github.com/mudler/LocalAI?tab=MIT-1-ov-file#>
- continue.dev as of 27.02.2024: Apache 2.0 License -> Can be used for everything including commercial use, but is more strict if changes are made to continue.dev software itself (which we dont do): <https://github.com/continuedev/continue/blob/main/LICENSE>
- Ollama: As of 27.02.2024: MIT License: <https://github.com/ollama/ollama?tab=MIT-1-ov-file>
- CodeLLama - Meta AI License -> The generated content is free to use for everything as it is not restricted at all.

## Other information

Quick setup sample LocalAI with Continue (but different, more allrounder model): <https://github.com/mudler/LocalAI/tree/master/examples/continue>