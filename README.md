# :flamingo: flatzingo

A [FlatZinc](https://www.minizinc.org/doc-2.4.3/en/flattening.html) frontend to solve CP problems in [MiniZinc](https://www.minizinc.org) format using [clingcon](https://potassco.org/clingcon/) as solver.

The process is done in two stages:
1. Transform files from MiniZinc in the flattened representation FlatZinc using [fzn2lp](https://github.com/potassco/fzn2lp) into `lp` files.
2. With the encodings in files [encoding](encoding.lp) and [types](types.lp), the `lp` file is proceeded to use the constraints with the syntax of `clingcon`.


## Install

### Using Docker

Follow the steps in the last [section](install-using-a-docker-image). *Note that **Usage** will vary on the paths.*

### Manual Installation

1. Install MiniZinc as showed [here](https://www.minizinc.org/doc-2.5.5/en/installation.html)
2. MiniZinc requires the [files](share/minizinc/flatzingo) defining the high-level constraints used by flatzingo, to be on a relative path to the installation of MiniZinc. So they have to be copied to these directory. Given the MiniZinc path added during the instalation `$PATH_MINIZINC` copy the files with: 
```
cp share/minizinc/flatzingo/* $PATH_MINIZIC/share/minizinc/flatzingo
```
Example in MacOS
```
cp share/minizinc/flatzingo/* /Applications/MiniZincIDE.app/Contents/Resources/share/minizinc/flatzingo
```
3. [Install fzn2lp](https://github.com/potassco/fzn2lp) manually using `cargo`
4. [Install clingcon](https://github.com/potassco/clingcon) 

## Usage

Run MiniZinc (Without solving `-c`) to get a FlatZinc output (`--output-fzn-to-stdout`) from a MiniZinc model (in this case `example.mzn`). Additionally the path to the high-level constraints (moved during the installation) must be specified with the `-G` option.
The output is then piped to `fzn2lp`

```
minizinc  -G -c flatzingo --output-fzn-to-stdout example.mzn | fzn2lp > tmp.lp
```

Use the `lp` file obtained in a `clingcon` call with other encodings. 

- **Static check**
  
Check the problem before converting it to clingcon's syntax
```
clingcon static_check.lp types.lp tmp.lp
```

- **Compute solution with `clingcon`**

```
clingcon encodings/encoding.lp encodings/types.lp tmp.lp
```

### Single command

The full process can be pied a single command:
```
{minizinc -c -G flatzingo --output-fzn-to-stdout example.mzn | fzn2lp; cat encodings/encoding.lp encodings/types.lp }| clingcon
```

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

To use the same docker container again instead of creating a new one use:
```
docker start -i $CONTAINER_ID
```


### Run flatzingo in the docker image

We can run the commands from the Usage section inside a docker container. However, in this case the files with the predicates are located in `/entry_data/mzn-lib` so MiniZinc will run with

```
minizinc -c -G ../../../../entry_data/mzn-lib --output-fzn-to-stdout /minizinc/test.mzn /minizinc/2.dzn | fzn2lp > /lp_file.lp
```

Note also that the `example.mzn` file is no longer available so we use the model in `/minizinc/test.mzn`  and instance `/minizinc/2.dzn` provided inside the docker by MiniZinc

Solve with `clingcon` using the output of the previous command
```
clingcon /lp_file.lp /entry_data/encodings/encoding.lp /entry_data/encodings/types.lp
```

Expected answer should have this after the warnings.
```
Answer: 1
var(true)
Assignment:
"x"=2
SATISFIABLE
```

### Use solve script from competition

The entry point of the flatzingo docker image is on minizinc and has access to the `solve` script. To only test this `solve` script  use the following command which will remove the container when finished (using `--rm`)

```
docker run --rm flatzingo:1.0 solver /minizinc/test.mzn /minizinc/2.dzn
```

