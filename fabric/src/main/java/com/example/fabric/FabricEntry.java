package com.example.fabric;

import net.fabricmc.api.ModInitializer;
import com.example.ModCoreLogic;

public class FabricEntry implements ModInitializer {
  @Override
  public void onInitialize() {
    System.out.println(ModCoreLogic.HELLO_WORLD);
  }
}
