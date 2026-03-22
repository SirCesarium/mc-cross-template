package com.example.neoforge;

import net.neoforged.fml.common.Mod;
import com.example.ModCoreLogic;

@Mod(NeoForgeEntry.MOD_ID)
public class NeoForgeEntry {
  public static final String MOD_ID = "@modId@";

  public NeoForgeEntry() {
    System.out.println(ModCoreLogic.HELLO_WORLD);
  }
}
