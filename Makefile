PROJECTNAME="The Connection"

platform=linux
threads=4

build-godot-bindings:
	@echo "  >  Generating `api.json`..."
	@godot --gdnative-generate-json-api api.json
	@echo "  >  Building bindings..."
	@cd godot-cpp && scons platform=$(platform) bits=64 generate_bindings=yes -j$(threads) use_custom_api_file=yes custom_api_file=../api.json

## compile: Compiles GDNative code
compile:
	@mkdir -p ./godot/bin
	@echo "  >  Compiling GDNative..."
	@scons platform=$(platform)

## build: Cleans project, create bindings, and compiles GDNative
build: clean build-godot-bindings compile

## clean: Removes all build related files
clean:
	@echo "  >  Cleaning project..."
	@rm -f ./api.json
	@rm -f ./.sconsign.dblite
	@rm -rf ./godot-cpp/bin
	@find ./client/bin -name \*.dll -type f -delete
	@find ./client/bin -name \*.so -type f -delete
	@find ./client/bin -name \*.dylib -type f -delete 


## help: Displays help text for make commands
.DEFAULT_GOAL := help
all: help
help: Makefile
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'