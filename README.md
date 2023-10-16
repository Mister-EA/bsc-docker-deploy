# bsc-docker-deploy

Deploy a local cluster of BSC validators using Docker.

## Steps to run

- If the `keys/` directory is empty , run the following command to generate a new set of keys for the validators:
    ```bash
    bash setup_keys.sh generate
    ```

    You can view the generated keys with:
    
    ```bash
    bash setup_keys.sh view
    ```
    
        


- Initialize the BSC, Beacon Chain, and bsc-genesis-contract repositories:
    ```bash
    bash init_submodules.sh
    ```

- Build these repositories:
    ```bash
    bash build_submodules.sh

    ```
    To try new features you can checkout different branches of these repositories and rebuild.


- Generate `genesis.json`:
    ```bash
    bash generate_genesis.sh
    ```

  This will generate the genesis file with all 5 authorities as validators. If you want a custom number of validators (up to 5) you can pass the number as an argument. E.g.

     ```bash
    bash generate_genesis.sh 3
    ```
    This will register 3 validators: Alice , Bob and Charlie.

- Build the docker image:
    ```bash
    bash docker_build.sh
    ```

- Run the cluster:
   ```bash
   docker-compose up
   ```

    This will run all 5 validators.  

    If you want to run certain validators (e.g. Alice, Charlie and Eve) you can pass the names as arguments to docker compose:

    ```bash
    docker-compose up alice charlie eve
    ```

