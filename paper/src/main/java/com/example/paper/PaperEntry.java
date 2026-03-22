package com.example.paper;

import org.bukkit.plugin.java.JavaPlugin;
import com.example.ModCoreLogic;

public class PaperEntry extends JavaPlugin {
  @Override
  public void onEnable() {
    System.out.println(ModCoreLogic.HELLO_WORLD);
  }
}
