src_dir := ./src
src_files := $(shell find ${src_dir} -name '*.cpp' -or -name '*.mm' -or -name '*.c')
header_only_files := %volk.c

src_files := $(filter-out ${header_only_files},${src_files})

build_dir := editor.app/Contents/MacOS
obj_files := $(src_files:${src_dir}/%=$(build_dir)/%.o)

all: ${build_dir}/editor

vk_ver = 1.3.236.0
linker_flags := -g -framework foundation -framework cocoa -framework quartzcore -framework metal -L $$VULKAN_SDK/${vk_ver}/macOS/lib -lshaderc_combined

${build_dir}/editor: ${obj_files}
	clang++ ${obj_files} -o ${build_dir}/editor ${linker_flags}

compile_flags := -std=c++17 -c -Wall -g
include_flags := -D VK_USE_PLATFORM_MACOS_MVK -D _DEBUG -I $$VULKAN_SDK/${vk_ver}/MacOS/include/glslang/Include -I $$VULKAN_SDK/${vk_ver}/MoltenVK/include
build_cmd = clang++ ${compile_flags} $< -o $@ ${include_flags}

# TODO we dont depend on header files in any way..

${build_dir}/%.cpp.o: ${src_dir}/%.cpp 
	${build_cmd}
${build_dir}/%.mm.o: ${src_dir}/%.mm
	${build_cmd}
${build_dir}/%.c.o: ${src_dir}/%.c
	${build_cmd}

.PHONY: clean
clean:
	rm -r editor.app/Contents/MacOS/*
