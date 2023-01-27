build:
	rm -rf lambda_function.zip
	zip -rj lambda_function.zip ./lambda/src/*