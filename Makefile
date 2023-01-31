LUA ?= lua5.3
EMU ?= mgba-qt
PROJ ?= NewProject
ROM = ${PROJ}.gba

all: ${ROM}

${ROM}: build.lua BPCoreEngine.gba manifest.lua main.lua
	@echo Building ROM...
	${LUA} $<

%.lua: %.moon
	@echo Compiling MoonScript into Lua
	moonc $<

clean:
	@echo Removing generated files
	rm main.lua
	rm ${PROJ}.*

run: ${ROM}
	${EMU} $<

lint_config.lua: lint_config.moon
	moonc $<

check: lint_config.lua
	moonc -l .

.PHONY: all clean run check
