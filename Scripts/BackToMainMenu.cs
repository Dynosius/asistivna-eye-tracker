using Godot;
using System;

public class BackToMainMenu : TextureButton
{
    public override void _Ready()
    {
        
    }

    public void pressed(){
        GetTree().ChangeScene("res://Scenes/MainMenu.tscn");
    }
}
