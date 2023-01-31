{ pkgs }: {
	deps = with pkgs; [
    lua53Packages.lua
    lua53Packages.argparse
    lua53Packages.bit32
    lua53Packages.moonscript
    mgba
	];
}