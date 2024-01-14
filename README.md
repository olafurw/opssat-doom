# OPS-SAT DOOM

Experiment with the European Space Agency (ESA) to run DOOM in Space onboard the [OPS-SAT satellite](https://www.esa.int/Enabling_Support/Operations/OPS-SAT).

### Events

**2023-12-28 18:16:36 (UTC)** — DOOM runs on OPS-SAT (initial demo checks).

<div align="center">
<img src="https://github.com/olafurw/opssat-doom/assets/103783/8b2ece4b-bb92-4694-9655-9debc2569c2e" alt="doom-demo-tests" width="600" />
  </div>

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
./build-64.sh
./start_exp272.sh
```

### How We Got Here
A vision brewing for 13 years:
- **2011**: [Georges](https://georges.fyi) stumbles on what would become [his favorite SMBC comic](https://www.smbc-comics.com/comic/2011-02-17), thank you [Zach](https://mastodon.social/@ZachWeinersmith)!
- **2020**: Georges joins the [OPS-SAT-1](https://www.esa.int/Enabling_Support/Operations/OPS-SAT) mission control team as a Spacecraft Operations Engineer at the European Space Agency (ESA). Visions of running DOOM on a space computer intensifies.
- **2023**: The reality of a 2024 end-of-mission by atmospheric re-entry starts to hit hard. The spacecraft's impending doom (see what I did there?) is a wake-up call to get serious about running DOOM in space before it's too late.
- **2024**: Georges has been asking around for help with compiling and deploying DOOM for the spacecraft's ARM32 onboard computer but isn't making progress. One night, instead of sleeping, he is trapped doomscrolling (ha!) on Instagram and stumbles on a reel from [Ólafur](https://mastodon.social/@olafurw)'s "Doom on GitHub Actions" talk at NDC TechTown 2023: [*Playing Video Games One Frame at a Time*](https://www.youtube.com/watch?v=Z1Nf8KcG4ro). After sliding into the DM, the rest is history.

<br>
<div align="center">
  <img src="https://www.smbc-comics.com/comics/20110217.gif" alt="Zach Weinersmith SMBC DOOM" width="400" />
</div>

### Source Ports

Based on [doomgeneric](https://github.com/ozkl/doomgeneric)

