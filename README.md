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

- Run the cluster:
   ```bash
   docker-compose up --build
   ```