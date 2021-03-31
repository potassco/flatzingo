# :flamingo: flatzingo

A [FlatZinc](https://www.minizinc.org/doc-2.4.3/en/flattening.html) frontend to solve CP problems in [MiniZinc](https://www.minizinc.org) format using [clingcon](https://potassco.org/clingcon/) as solver.

The process is done in two stages:
1. Use `MiniZinc` to transform files from `MiniZinc` `*.mzn` into a `flatzingo` specific `FlatZinc` representation as `*.fzn` files.
2. The `FlatZinc` file can then be solved using the [fzn-flatzingo](fzn-flatzingo.sh) script.
   We use `fzn2lp` to convert the `fzn` file to an ASP input `lp` file.
   In combination with the encodings in files [encoding](encoding.lp) and [types](types.lp) a solution to the problem is produced in form of answer sets using the answer set solver `clingcon`.
   Finally, the script converts these answer sets into valid `FlatZinc` output, which can then be further processed in the `MiniZinc` toolchain if needed.


## Install

### Using Docker

Follow the steps in the last [section](install-using-a-docker-image). *Note that **Usage** will vary on the paths.*

### Manual Installation

1. Install MiniZinc as showed [here](https://www.minizinc.org/doc-2.5.5/en/installation.html)
2. [Install fzn2lp](https://github.com/potassco/fzn2lp) manually using `cargo`
3. [Install clingcon](https://github.com/potassco/clingcon) 
4. Run `install.sh` to copy the solver configuration and redefinition files into ~/.minizinc/ (currently only Linux and Mac)

## Usage

minizinc --solver flatzingo examples/example.mzn

## Set up for MiniZinc competition with docker

### Install using a docker image

The docker image is defined in [Dockerfile_Flatzingo](Dockerfile_Flatzingo). It contains the necessary settings to build up the environment for minizinc using flatzingo.
This option builds up an ubuntu OS where it installs the specific solver requirements `fzn2lp` and `flatzingo`. In a next stage it builds up on the docker image used of MiniZinc competition and moves the flatzingo files to be relative to the MiniZic installation. 

#### Create a docker image

We create a docker image (without cache, so that every new build builds everything from scratch) with the name `flatzingo` and tag `1.0` based on the DockerFile 

```
docker build --no-cache -t flatzingo:1.0 - < Dockerfile_Flatzingo
```

Once the image is successfully created it must appear in your list of images with:
```
docker images -a
``` 

Run any command `$COMMAND` inside a new docker container that will instantiate the image with:
```
docker run flatzingo:1.0 $COMMAND
```

Enter a new container in an interactive way, for an easier usage
```
docker run -it flatzingo:1.0 bash
```

See the list of containers currently running with:
```
docker ps -a
```

To use the same docker container again instead of creating a new one, use the `$CONTAINER_ID` from the list of containers after running the command above. 

```
docker start -i $CONTAINER_ID
```

When working on a docker container the files need to be accessed and edited in the terminal. However we can also create a connection between a local path and a path on the container to edit the files locally and see the changes on the container and the other way around.

General command
```
docker run -v '$ABSOLUTE_LOCAL_PATH':'$ABSOLUTE_DOCKER_PATH' -it flatzingo:1.0 bash
```

Link the encodings and output directories.
```
docker run -v '$PATH_TO_FLATZINGO/encodings':'/entry_data/encodings' -v '$PATH_TO_FLATZINGO/outputs':'/entry_data/outputs' -it flatzingo:1.0 bash
```

Now all changes in these directories will be reflected both locally abd in the container.

### Run flatzingo in the docker image

We can run the commands from the Usage section inside a docker container. However, in this case the files with the predicates are located in `/entry_data/mzn-lib`, and the path must include `../../../..` to move from the shared folder of minizinc to the root. For the model we can use the one provided inside the docker by MiniZinc in `/minizinc/test.mzn`  and instance `/minizinc/2.dzn`.


```
minizinc --solver flatzingo /minizinc/test.mzn /minizinc/2.dzn
```

Expected answer should have this after the warnings.
```
x = 2;
----------
```

#### Use solve script from competition

In the entry point of the flatzingo docker image which is the minizinc directory, there is a `solve` script which will solve minizinc examples using flatzingo by doing all the steps above. This can be ran with:

```
solver /minizinc/test.mzn /minizinc/2.dzn
```

To only test this `solve` script  use the following command which will remove the container when finished (using `--rm`)

```
docker run --rm flatzingo:1.0 solver /minizinc/test.mzn /minizinc/2.dzn
```

