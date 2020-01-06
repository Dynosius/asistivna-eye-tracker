using Godot;
using System;

public class ThreeAnswerButton : TextureButton
{

    public override void _Ready()
    {
        
    }

    public void pressed(){
        GetTree().ChangeScene("res://Scenes/3QuestionPanel.tscn");
    }
}
