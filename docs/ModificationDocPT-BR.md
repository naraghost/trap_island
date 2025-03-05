# Trap Island - Modification Documentation

## Criação de um Level (Dicas)

O mapa pode ficar todo errado, se você colocar objetos sem uma grid.
Por isso, exite uma funcionalidade do **Editor da Godot**.

- Para ativa-la apenas ative a função **Encaixar / Snap** na barra superior da Godot

![image](https://github.com/user-attachments/assets/1b159e6c-53c2-498c-82f8-fc0100a7c81d)

- Para configura-la, clique em **Transformar / Transform** e depois clique em **Configurar Encaixe / Configure Snap**

![image](https://github.com/user-attachments/assets/3fc6e67e-0a10-438d-8e23-76d698e63b2d)

- Defina **Translação do Encaixe / Translate Snap**, para 0.25

![image](https://github.com/user-attachments/assets/9c70feaa-88b0-4ad1-ac7b-f8e684e61f2a)

- Agora, você tem uma grid de 0.25, que ajudará quando for criar o Level

## Cubos
- Existe um nó que faz um cubo proceduralmente, podendo ajustar a escala, modificar a textura, e etc.

<img src="https://github.com/user-attachments/assets/b3fbe661-4650-4685-8003-040f892b003e" width="10%" height="10%">

### Tamanho
- Definir o seu tamanho é muito facil, apenas mude **Cube Size** para oque desejar

![image](https://github.com/user-attachments/assets/a8956a37-1ace-4a12-86fc-5eb605ab2d47)

- De preferência defina o tamanho no seguinte padrão: **0.25, 0.50, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00, ...** (Sempre divisível por 0.25), isso é importante para não quebrar a Grid

### Texturizando

- Para modificar as texturas, existem os **Tiles**

![filelist](https://github.com/user-attachments/assets/21a9e047-e7e6-4516-8411-b5a6bb13cd95)

#### Criando Tiles
- Você pode simplesmente criar um **Tile**, criando um novo recurso chamado **TextureTile**:

![2](https://github.com/user-attachments/assets/3559bd31-f34a-4d13-acf5-ef4a65012068)

![3](https://github.com/user-attachments/assets/5c5246b5-f496-4f98-a560-d646c0a32a7e)

![image](https://github.com/user-attachments/assets/bb004c14-4592-42a1-99d0-5bcee49508be)

#### Modificando Tiles
- Clicando duas vezes nesse novo **TextureTile** você podera modificar esse tile pelo editor:

![4Capturar](https://github.com/user-attachments/assets/938f138c-ef75-44fc-bca1-c9574c893385)

![5Capturar](https://github.com/user-attachments/assets/4652af77-e614-4be3-92b7-1bb80d3a4cd4)

#### Aplicando os Tiles
- Para aplicar um **TextureTile** em um cubo, apenas arraste o seu tile para a área de **Tile** do cubo

![cube tile](https://github.com/user-attachments/assets/663ed196-9a42-4666-ac28-7eae606649b5)

