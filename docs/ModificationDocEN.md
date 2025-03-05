# Trap Island - Modification Documentation

## Creating a Level (Tips)

The map can get completely messed up if you place objects without a grid. That’s why there’s a feature in the **Godot Editor**.

- To enable it, just turn on the **Snap / Encaixar** function in Godot’s top bar

![image](https://github.com/user-attachments/assets/1b159e6c-53c2-498c-82f8-fc0100a7c81d)

- To configure it, click on **Transform / Transformar** and then click **Configure Snap / Configurar Encaixe**

![image](https://github.com/user-attachments/assets/3fc6e67e-0a10-438d-8e23-76d698e63b2d)

- Set **Translate Snap / Translação do Encaixe** to 0.25

![image](https://github.com/user-attachments/assets/9c70feaa-88b0-4ad1-ac7b-f8e684e61f2a)

- Now, you have a 0.25 grid that will help when creating the level

## Cubes
- There’s a node that creates a cube procedurally, allowing you to adjust its scale, modify its texture, etc.

<img src="https://github.com/user-attachments/assets/b3fbe661-4650-4685-8003-040f892b003e" width="10%" height="10%">

### Size
- Setting its size is really easy; just change **Cube Size** to whatever you want

![image](https://github.com/user-attachments/assets/a8956a37-1ace-4a12-86fc-5eb605ab2d47)

- Preferably, set the size using this pattern: **0.25, 0.50, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00, ...** (Always divisible by 0.25), as this is important to keep the grid intact

### Texturing

- To modify textures, there are **Tiles**

![filelist](https://github.com/user-attachments/assets/21a9e047-e7e6-4516-8411-b5a6bb13cd95)

#### Creating Tiles
- You can simply create a **Tile** by creating a new resource called **TextureTile**:

![2](https://github.com/user-attachments/assets/3559bd31-f34a-4d13-acf5-ef4a65012068)

![3](https://github.com/user-attachments/assets/5c5246b5-f496-4f98-a560-d646c0a32a7e)

![image](https://github.com/user-attachments/assets/bb004c14-4592-42a1-99d0-5bcee49508be)

#### Modifying Tiles
- By double-clicking this new **TextureTile**, you can modify the tile using the editor:

![4Capturar](https://github.com/user-attachments/assets/938f138c-ef75-44fc-bca1-c9574c893385)

![5Capturar](https://github.com/user-attachments/assets/4652af77-e614-4be3-92b7-1bb80d3a4cd4)

#### Applying Tiles
- To apply a **TextureTile** to a cube, simply drag your tile into the cube’s **Tile** area

![cube tile](https://github.com/user-attachments/assets/663ed196-9a42-4666-ac28-7eae606649b5)