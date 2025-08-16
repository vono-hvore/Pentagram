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
	tusit edit

format:
	swiftformat .

autocorrect:
	swiftlint autocorrect --quiet

lint:
	swiftlint version
	swiftformat --version
	swiftlint --strict --quiet
	swiftformat . --lint
