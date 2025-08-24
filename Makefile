PROJECT_NAME = PentagramExample

clean:
	tuist clean
	rm -rf $(PROJECT_NAME).xcodeproj
	rm -rf $(PROJECT_NAME).xcworkspace

generate:
	tuist generate --no-open

build:
	tuist build

edit:
	tuist edit

format:
	swift format . --recursive

autocorrect:
	swiftlint autocorrect --quiet

lint:
	swiftlint version
	swift format --version
	swiftlint --strict --quiet
	swift format lint . --recursive
