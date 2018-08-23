init:
	# Install bundler if not installed
	if ! gem spec bundler > /dev/null 2>&1; then\
  		echo "bundler gem is not installed!";\
  		-sudo gem install bundler;\
	fi
	-bundle install --path .bundle
	-bundle exec pod repo update
	-bundle exec pod install
	-bundle exec generamba template install

screen: 
	bundle exec generamba gen $(modName) surf_mvp_module

synx:
	bundle exec synx --exclusion "ExchangeRates/Non-iOS Resources" ExchangeRates.xcodeproj

lint:
	./Pods/SwiftLint/swiftlint lint --config .swiftlint.yml

format:
	./Pods/SwiftLint/swiftlint autocorrect --config .swiftlint.yml