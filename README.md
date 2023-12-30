# opssat-doom

Experiment with the European Space Agency (ESA) to run Doom in Space onboard the [OPS-SAT satellite](https://www.esa.int/Enabling_Support/Operations/OPS-SAT).

### Events

**2023-12-28 18:16:36 (UTC)** — Doom runs on OPS-SAT (initial demo checks).

<img src="https://github.com/olafurw/opssat-doom/assets/103783/8b2ece4b-bb92-4694-9655-9debc2569c2e" alt="doom-demo-tests" width="600" />

### Setup

Requires the `ops-sat-sepp-ci` image to be initialized.

```
git clone https://gitlab.com/esa/NMF/ops-sat-sepp-ci-docker.git
cd ops-sat-sepp-ci-docker
docker build -t sepp-builder-image .
```

Then inside that image, these commands need to be run.

```
git clone https://github.com/olafurw/opssat-doom.git
cd opssat-doom/
./setup.sh
./build-full.sh
./start_exp272.sh
```

### Source Ports

Based on [Chocolate Doom 2.3.0](https://github.com/chocolate-doom/chocolate-doom)
