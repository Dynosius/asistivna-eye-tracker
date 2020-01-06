using Godot;
using System;

public class PlayButton : TextureButton
{
    public override void _Ready()
    {
        
    }

    public void pressed(){
        GetTree().ChangeScene("res://Scenes/GameSelect.tscn");
    }

}
