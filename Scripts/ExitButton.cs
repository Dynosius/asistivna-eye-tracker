using Godot;
using System;

public class ExitButton : TextureButton
{

    public override void _Ready()
    {
        
    }

    public void pressed(){
        GetTree().Quit();
    }
}
