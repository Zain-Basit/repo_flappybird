# Flappy Bird in Assembly
This is a repository for our flappy bird game coded in Assembly and MIPS

Here's an image of what the game looks like when we played it in the two player configuration:
![twoplayer](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/0b627094-97ba-4025-ae80-5136c659516e)

## How do I play the game?


1. In order the play the game, you must first download `flappybird.s` from this repo and save it to your local machine.
2. Second, you need to download MARS MIPS Simulator (free) from the [Missouri State University website](https://courses.missouristate.edu/kenvollmar/mars/download.htm) Alternatively like you can also download it from this repo as I've stored a copy of the program here too, it is called `Mars4_5.jar`. It looks like this:
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/b24072ee-0018-45df-bd78-e9c9280da8b1)

3. Open MARS and you will see this screen:
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/e3d7740f-60af-4186-b3be-f94910fe7f84)

4. Open the `flappybird.s` file with the file explorer:<br>
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/085a48cc-8fc2-472c-ba89-59917da42b38)

6. To disable the two player mode, I would recommend going through the code in the terminal and commenting out lines 82, 83, 84, 125, 191, 192.
    The character for comments in assembly is the hashtag (`#`) so just add that in front of those lines to make it easier to play.

7. Now you must go to the Tools section in the menu bar and open both the `Bitmap Display` and the `Keyboard and Display MMIO Simulator`.<br>
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/afc129a2-205b-46bb-8b46-b2c7a036dabd)

8. Configure these values for the `Bitmap Display` and then press "Connect to MIPS":<br>
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/158f7337-1521-4304-8dd1-ea780a0dff10)

9. Connect the `Keyboard and Display MMIO Simulator` to MIPS using the "Connect to MIPS" button.  You will pass your inputs into the keyboard section when playing the game:<br>
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/69e554bc-3654-40e2-a228-13736459fbc7)

10. Now with both windows open, assemble the file:<br>
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/6ff55eb5-44c3-4418-8cc5-2a26e54df198)

11. Now press the Play Button (which starts the game) and enter all inputs into your `Keyboard and Display MMIO Simulator`, the bird should respond: <br>
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/3b817dbd-8dd1-45b6-8f42-a5f84f8866ec)

12. To restart the game, just press the reset key (looks like a rewind button) and then the play button again: <br>
    ![image](https://github.com/Zain-Basit/repo_flappybird/assets/45300116/c4ab4bae-92a0-49ef-b971-5baeb132bda1)
