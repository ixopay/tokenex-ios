[private]
default:
	just --justfile {{ justfile() }} --choose

format:
	swift-format format --configuration "{{ justfile_directory() }}/.swift-format" --recursive --parallel --in-place "{{ justfile_directory() }}"

lint:
	swiftlint lint --fix --config "{{ justfile_directory() }}/.swiftlint.yml" "{{ justfile_directory() }}"
	swiftlint lint --config "{{ justfile_directory() }}/.swiftlint.yml" "{{ justfile_directory() }}"

build:
	ci/build.sh

clean:
	rm -rf build/
