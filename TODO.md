###  TODO

1. Reformatar arquivos para nomes que façam mais sentido e deixálos importáveis.
   Exemplo:
    
    ```
    projeto/
    ├── scrapers/
    │   ├── __init__.py
    │   └── ipea_scraper.py
    ├── api/
    │   ├── __init__.py
    │   └── bolsas_api.py
    └── main.py

    OBS: main.py deve conter apenas a inicialização da API.
    ```
2. Também seria interessante ter um deafault config para API e Scraper.
3. No código SwiftUI, fazer o texto de loading para "isso pode domorar um tempo"
   depois de 10s, importante para informar o usuário de que é uma operação
   demorada.
4. Realizar as raspagens de forma assíncrona. O método atual está levando muito
   tempo para completar o processo todo.


    
    